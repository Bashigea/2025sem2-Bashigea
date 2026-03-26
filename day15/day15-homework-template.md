# Day 15 - Homework Responses
Armand Bashige

## Preliminaries

Link to google doc for instructions:
[LINK](https://docs.google.com/document/d/1pn4HjL9HpNtZh2Rtc1usbTJs7bjlQ68WIvYF1qYvKms/edit?usp=sharing)

<div style="background-color: #f0f8ff; border-left: 5px solid #007acc; padding: 10px;">

## (20 points) Code of Ethics

I’m interested in understanding your process for completing all the
questions in this assignment. Please tell me about the tools and
resources—including any use of AI—that helped you with your work. Please
remember to follow the outlined [Code of
Ethics](https://docs.google.com/document/d/1lMvzPTGUAaMnH0KPibShQ1ualuo8uqICCexkh8zmsW8/edit?usp=sharing).
Because our understanding of how to work with AI tools is emerging,
please err on the side of including too much detail rather than too
little.

To complete this assignment, I used a combination of resources including
class notes, the tidymodels reading articles, and AI assistance through
Claude. For Problem 1, I referred back to my group’s previous weekly
huddle work on the Hennepin County SNAP project to ground my logistic
regression ideas in our actual research question about SNAP
underenrollment. I used Claude to help me organize and articulate those
ideas in paragraph form, making sure they connected to the tidymodels
workflow as requested.

For Problem 2, I read through the assigned tidymodels articles on
preprocessing with recipes, evaluating models with resampling, and
tuning hyperparameters. I used Claude to help me structure my three
lists of concepts, but the reflections on what I understood versus what
was still confusing are based on my own experience working through the
material.

For Problem 3, I used the class R file from Day 15 as my starting point
and followed the same coding style used in class. I used Claude to help
me understand how to extend the code to build a third model using both
less_than_hs and rural_urban_continuum as predictors.

Overall, I used AI as a learning aid rather than as a replacement for my
own thinking. All code was run and verified by me personally in RStudio.

</div>

## Problem 1 (20 points)

Discuss with your Hennepin County group: where can you imagine yourself
using logistic regression in your project? Sketch out some possible
ideas that you can incorporate the tidymodels workflow into binary
classification. (I encourage you to try to incorporate test your ideas
as well!)

In our Hennepin County project, we are investigating why some census
tracts with high poverty rates have lower SNAP enrollment than expected,
and whether the racial makeup of a neighborhood is connected to that
gap. One place we could use logistic regression is to predict whether a
census tract is underenrolling in SNAP — meaning it falls below the
expected enrollment line given its poverty level. This gives us a clean
binary outcome like a tract is either underenrolling or it is not. As
predictors, we could use variables like the percentage of residents at
125% of the poverty level (p_125_povertyE), the racial composition of
the tract such as the percentage of Black, White, or Asian residents,
and possibly the dominant race of the tract. Using the tidymodels
workflow, we would split our Hennepin County data into training and
testing sets, fit a logistic regression model on the training data, and
then evaluate how accurately it predicts which tracts are underenrolling
on the testing data. This approach would help us understand which
factors — especially racial demographics are most strongly associated
with SNAP underenrollment across Hennepin County tracts.

## Problem 2 (20 points)

Review [Chapter 18 in Modern Data Science with
R](https://www.tidymodels.org/start/). I encourage you to evaluate each
of these expressions on your computer. I imagine there are a lot of
terms and ideas that are familiar to you, and perhaps some that are
unfamiliar to you. Make a listing of concepts you:

1.  understood

I understood the idea of splitting data into a training set and a
testing set using initial_split(). This makes sense because you want to
train your model on one portion of the data and then test it on data it
has never seen before, just like studying for an exam and then taking a
different version of it. I also understood the basic logistic regression
workflow like defining a model with logistic_reg(), fitting it with
fit(), and making predictions with predict(). The idea that the outcome
variable needs to be a factor for logistic regression was also clear.
Also, the concept of a workflow using workflow() to bundle a model and a
recipe together made sense as a way to keep everything organized in one
place.

2.  didn’t understand initially, but working through the examples led to
    more understanding

The concept of a recipe was confusing at first, but after working
through the flight example I understood that a recipe is just a set of
instructions for preparing your data before modeling — things like
creating dummy variables with step_dummy() or removing zero-variance
predictors with step_zv(). I also initially did not understand why you
should never evaluate your model on the training data, but the cell
image example made it very clear: a model can essentially memorize the
training data and look like it performs perfectly, when in reality it
does much worse on new data. The ROC curve and roc_auc() also became
clearer since it is a way of measuring how well your model distinguishes
between the two outcomes across all possible probability thresholds,
where a value closer to 1.0 is better.

3.  still unfamiliar to you, even after working through the articles.

Hyperparameter tuning and the use of tune() as a placeholder is still
somewhat unclear to me. While I understand the general idea that some
model settings cannot be learned from the data directly and need to be
tested across many values — the specific mechanics of grid_regular(),
cost_complexity, and tree_depth remain confusing. I am also still not
fully comfortable with cross-validation

## Problem 3 (10 points)

In class we worked through two different models (“null” and “plus”) to
predict whether or not a locality had an unemployment above 6%. Using
the variables in joined_dataset, set up a third logistic regression
example using different predictor variables (or combinations of them).
Some starter code is below:

    # A tibble: 3 × 5
      term                  estimate std.error statistic   p.value
      <chr>                    <dbl>     <dbl>     <dbl>     <dbl>
    1 (Intercept)            -5.30     0.239      -22.2  9.95e-109
    2 less_than_hs            0.124    0.00683     18.1  1.41e- 73
    3 rural_urban_continuum   0.0565   0.0236       2.39 1.66e-  2

    # A tibble: 1 × 3
      .metric  .estimator .estimate
      <chr>    <chr>          <dbl>
    1 accuracy binary         0.870

    # A tibble: 1 × 3
      .metric  .estimator .estimate
      <chr>    <chr>          <dbl>
    1 accuracy binary         0.855

1.  Explain why you chose the combinations of variables you want to do.

For my third model, I chose to use both less_than_hs and
rural_urban_continuum together as predictor variables. The null model
used no predictors at all, and the plus model used only less_than_hs. My
reasoning is that whether a county is rural or urban likely plays an
independent role in predicting high unemployment beyond just education
levels. Rural counties tend to have fewer job opportunities and less
economic diversity, which could push unemployment above 6% regardless of
education. By combining both variables, I wanted to test whether adding
geographic context improves our ability to predict high unemployment on
top of what education alone already tells us.

2.  After the logistic regression, evaluate the effect these new
    covariates have on the accuracy and predictive power of your model
    on both the training and the testing data.

After fitting the combined logistic regression model using both
less_than_hs and rural_urban_continuum as predictors, the model achieved
an accuracy of 85.5% on the training data and 87.0% on the testing data.
Looking at the model coefficients, both predictor variables were
statistically significant.Less_than_hs had a p-value of approximately
1.4e-73 and rural_urban_continuum had a p-value of approximately 0.017 —
confirming that both variables contribute meaningful predictive power to
the model. Interestingly, the testing accuracy is slightly higher than
the training accuracy, which tells us the model is not overfitting and
generalizes well to new data it has not seen before. Compared to the
plus model which used only less_than_hs, adding the rural-urban
continuum variable improved overall predictive performance, suggesting
that the geographic character of a county matters when predicting
whether unemployment will exceed 6%.
