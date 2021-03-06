
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Nutrition

<!-- badges: start -->
<!-- badges: end -->

## About

This Shiny App allows the user to track and monitor their nutritional
intake. The user will be able to search food items and/or enter their
own items under the **Ingredients** tab. Using this library of
ingredients, the user can then create recipes under the **Recipe** tab.
The **Log** tab then allows the user to enter their recipes/ingredients
that they consume throughout the day. This tab also provides data
visualizations to summarize their nutritional intake.

The app can be found here:
<https://nutrition-te925.ondigitalocean.app/>. The current state of the
app is loaded with sample data in order to showcase the project. In the
near future, the app will be able to accommodate different users.

This project is created under the
[golem](https://github.com/ThinkR-open/golem) framework by Colin Fay. If
you are interested in further reading on how this app was organized,
please check out the following resources by Hadley Wickham and Colin
Fay:

-   [Mastering Shiny](https://mastering-shiny.org/index.html) - Hadley
    Wickham  
-   [Engineering Production-Grade Shiny
    Apps](https://engineering-shiny.org/index.html) - Colin Fay

The Shiny App details are discussed further in the below sections.

## Ingredients

There are two sources of data that the user can add to their library:

### Food Data Central (FDC) API

The United States Department of Agriculture (USDA) hosts the FDC API to
allow users to query their database of nutrient data. This Shiny App
allows the user to query this database that requires an API key, which
can easily be obtained through the [signup
form](https://fdc.nal.usda.gov/api-key-signup.html). This allows the
user to make up to 3,600 requests per hour.

### Self-Upload

If a particular food item cannot be found from the FDC lookup, the user
can upload their own nutrition data using the form provided in this tab.

## Recipes

As users will typically consume a combination of ingredients at a time,
recipes are made available. Existing ingredients in the library will be
populated on this page to be added to create recipes.

**Note:** When logging recipes in the **Log** tab for consumption, the
total weight of the recipe (final product after cooking) will need to be
entered along with the amount consumed to get an accurate measure of
nutrition info consumed.

## Log

Once users have a base of ingredients and recipes added to their
library, this section is used to make the consumption entries. Both
ingredients and recipes can be selected along with the date and
quantities. The app then uses this data to create data visualizations.
