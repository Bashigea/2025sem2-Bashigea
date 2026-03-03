library(tidyverse)
library(tidymodels)
tidymodels_prefer()   ### Set any conflicts to prefer tidymodels

### Load in the data
data_file <- here::here("day15","data","employment_education.Rda")
load(data_file)


### Set the unemployment threshold for the model
unemployment_thresh <- 6  

### Create a new indicator variable for logistic regression
unemployment_education_data_new <- unemployment_education_data |>
  mutate(above_indicator = (unemployment_rate > unemployment_thresh),
         above_indicator = as.factor(above_indicator)) |>  # Set as a factor for regression
  na.omit()


### Step 0: Initial data visualization
  ## For our linear regression we will need to set the dependent variable as a 0 or 1, so let's do that now with a base plot:

base_plot <- unemployment_education_data_new |>
  mutate(above_indicator = as.numeric(above_indicator == TRUE)) |>
  ggplot(aes(x=less_than_hs, y = above_indicator)) +
  geom_count(
    position = position_jitter(width = 0, height = 0.05), 
    alpha = 0.5
  )

### Add on a smoothed logistic regression to the base plot
base_plot + 
  geom_smooth(
    method = "glm",method.args = list(family = "binomial"), 
    color = "dodgerblue", lty = 2, se = FALSE
  ) +
  geom_hline(aes(yintercept = 0.5), linetype = 3)


### Step 0: split the data into testing and training (spending the data budget)
set.seed(501)  ## So we can replicate this later (seed number can be modified)

### We will do a stratified sample along the rural, urban continuum
unemployment_parts <- unemployment_education_data_new |>
  initial_split(prop = 0.8,strata = rural_urban_continuum)

# Identify the training and testing sets as separate data frames
train <- unemployment_parts |>
  training()

test <- unemployment_parts |>
  testing()

### Model 1: "null"
# Step 1: Set your tidymodels engine and fit to training data
mod_null <- logistic_reg(mode = "classification") |>
  set_engine("glm")

mod_null_fit <- 
  mod_null |>
  fit(above_indicator ~ 1, data = train)

### Display the coefficients of the regression
broom::tidy(mod_null_fit)

# As an alternative you can do:
  # mod_null_fit <-mod_null |>
  # fit_xy(
  #   x = tibble(x=array(1,dim=nrow(train))), # Need this because it is a constant factor
  #   y = train |> select(above_indicator),
  #   
  # )

  
### Step 2: Evaluate the accuracy of your predictions with the training dataset
pred_null <- train |>  
  bind_cols(predict(mod_null_fit, train)) |>
  rename(above_indicator_null = .pred_class)

# Test out the accuracy
accuracy(pred_null,above_indicator,above_indicator_null)



########### Now let's repeat with logistic regression with an explanatory variable
########### (using the same training data as above)

### Model 2: "plus"
mod_plus <- logistic_reg(mode = "classification") |>
  set_engine("glm")

# The regression formula will be log(above_indicator) = b0 + b1*less_than_hs
mod_plus_fit <- 
  mod_plus |>
  fit(above_indicator ~ less_than_hs, data = train)

### Display the coefficients of the regression
broom::tidy(mod_plus_fit)

# Now with our regression model, 
# let's see how well it does with the training data
pred_plus <- train |>  
  bind_cols(predict(mod_plus_fit, train)) |>
  rename(above_indicator_plus = .pred_class)

glimpse(pred_plus)

### Accuracy of the new model
accuracy(pred_plus,above_indicator,above_indicator_plus)

### Plot the regression on the training data
train |>
  mutate(above_indicator = as.numeric(above_indicator == TRUE)) |>
  ggplot(aes(x=less_than_hs, y = above_indicator)) +
  geom_count(
    position = position_jitter(width = 0, height = 0.05), 
    alpha = 0.5
  ) + 
  geom_smooth(
    method = "glm",method.args = list(family = "binomial"), 
    color = "dodgerblue", lty = 2, se = FALSE
  ) +
  geom_hline(aes(yintercept = 0.5), linetype = 3)


# The confusion matrix!
pred_plus |>
  conf_mat(truth = above_indicator, estimate = above_indicator_plus)



### Now define the accuracy of the prediction in terms of probabilities:
prediction_probs <- pred_plus |>
  select(above_indicator, above_indicator_plus, less_than_hs) |>
  bind_cols(
    predict(mod_plus_fit, new_data = train, type = "prob")
  )

glimpse(prediction_probs)


### Step 4: Compare to the testing data
# Let's see how well this does with the testing data

# Null model first
pred_test <- test |>  
  bind_cols(predict(mod_null_fit, test)) |>
  rename(above_indicator_null = .pred_class)

# Test out the accuracy
accuracy(pred_test,above_indicator,above_indicator_null)

### Revised model
pred_plus_test <- test |>  
  bind_cols(predict(mod_plus_fit, test)) |>
  rename(above_indicator_plus = .pred_class)

# Test out the accuracy of this model:
accuracy(pred_plus_test,above_indicator,above_indicator_plus)


