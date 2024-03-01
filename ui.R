library(ggplot2)
library(plotly)

library(bslib)

#read file
df <- read.csv("final-diet-with-mental-illness.csv", stringsAsFactors = FALSE)
df <- df[-(4881:4910),]

#get column names
 
disorder_colnames <- c(
  "Anxiety Disorder" = "Current.number.of.cases.of.anxiety.disorders..in.both.sexes.aged.all.ages",
  "Depressive Disorder" = "Current.number.of.cases.of.depressive.disorders..in.both.sexes.aged.all.ages",
  "Schizophrenia" = "Current.number.of.cases.of.schizophrenia..in.both.sexes.aged.all.ages",
  "Bipolar Disorder" = "Current.number.of.cases.of.bipolar.disorder..in.both.sexes.aged.all.ages", 
  "Eating Disorder" = "Current.number.of.cases.of.eating.disorders..in.both.sexes.aged.all.ages"
)

food_colnames <- c(
  "Alcoholic Bevarages" = "Daily.caloric.intake.per.person.from.alcoholic.beverages",
  "Sugar" = "Daily.caloric.intake.per.person.from.sugar",
  "Meat" = "Daily.caloric.intake.per.person.from.meat",
  "Starchy Roots" = "Daily.caloric.intake.per.person.from.starchy.roots",
  "Pulses/Legumes" = "Daily.caloric.intake.per.person.from.pulses", 
  "Dairy and Eggs" = "Daily.caloric.intake.per.person.from.dairy.and.eggs",
  "Oils and Fats" = "Daily.caloric.intake.per.person.from.oils.and.fats", 
  "Cereals and Grains" = "Daily.caloric.intake.per.person.from.cereals.and.grains",
  "Other" = "Daily.caloric.intake.per.person.from.other.commodities"
)
 
category_colnames <- c(
  "Anxiety Disorder" = "Current.number.of.cases.of.anxiety.disorders..in.both.sexes.aged.all.ages",
  "Depressive Disorder" = "Current.number.of.cases.of.depressive.disorders..in.both.sexes.aged.all.ages",
  "Schizophrenia" = "Current.number.of.cases.of.schizophrenia..in.both.sexes.aged.all.ages",
  "Bipolar Disorder" = "Current.number.of.cases.of.bipolar.disorder..in.both.sexes.aged.all.ages", 
  "Eating Disorder" = "Current.number.of.cases.of.eating.disorders..in.both.sexes.aged.all.ages",
  "Alcoholic Bevarages" = "Daily.caloric.intake.per.person.from.alcoholic.beverages",
  "Sugar" = "Daily.caloric.intake.per.person.from.sugar",
  "Meat" = "Daily.caloric.intake.per.person.from.meat",
  "Starchy Roots" = "Daily.caloric.intake.per.person.from.starchy.roots",
  "Pulses/Legumes" = "Daily.caloric.intake.per.person.from.pulses", 
  "Dairy and Eggs" = "Daily.caloric.intake.per.person.from.dairy.and.eggs",
  "Oils and Fats" = "Daily.caloric.intake.per.person.from.oils.and.fats", 
  "Cereals and Grains" = "Daily.caloric.intake.per.person.from.cereals.and.grains",
  "Other" = "Daily.caloric.intake.per.person.from.other.commodities"
)

## OVERVIEW TAB INFO

overview_tab <- tabPanel("Overview",
   h1("Exploring Associations Between Mental Disorders and Dietary Compositions"),
   p("some explanation")
)

## VIZ 1 TAB INFO

viz_1_sidebar <- sidebarPanel(
  h2("Options for graph"),
  #TODO: Put inputs for modifying graph here
  selectInput(inputId = "year_selection",
              label = "Year",
              choices = df$Year,
              selected = 1,
              multiple = FALSE), 
  radioButtons(inputId = "button_choice",
               label = h3("Data Type"),
               choices = list("Diet" = 1,
                              "Mental Disorder" = 2),
                              selected = 1),
  selectInput(inputId = "country_selection",
              label = "Country",
              choices = df$Entity,
              selected = 1,
              multiple = FALSE),
)

viz_1_main_panel <- mainPanel(
  h2("Dietary Composition and Mental Disorders of Countries"),
  plotlyOutput(outputId = "country_bar")
)

viz_1_tab <- tabPanel("Disorder/Food Type",
  sidebarLayout(
    viz_1_sidebar,
    viz_1_main_panel
  )
)

## VIZ 2 TAB INFO

viz_2_sidebar <- sidebarPanel(
  h2("Options for graph"),
  #TODO: Put inputs for modifying graph here
  selectInput(inputId = "trend_country_selection",
              label = "Country",
              choices = df$Entity,
              selected = "United States",
              multiple = TRUE),
  selectInput(
    inputId = "trend_selection",
    label = "Types of Food and Mental Disorders",
    choices = category_colnames,
    selectize = TRUE,
    # True allows you to select multiple choices...
    multiple = FALSE,
    selected = "Daily.caloric.intake.per.person.from.sugar"
  )
)

viz_2_main_panel <- mainPanel(
  h2("Mental Disorder and Diet Trends Over the Years"),
  plotlyOutput(outputId = "trend_plot")
)

viz_2_tab <- tabPanel("Trends Over Time",
  sidebarLayout(
    viz_2_sidebar,
    viz_2_main_panel
  )
)

## VIZ 3 TAB INFO

viz_3_sidebar <- sidebarPanel(
  h2("Options for graph"),
  #TODO: Put inputs for modifying graph here
  selectInput(inputId = "scatter_year_selection",
              label = "Year",
              choices = df$Year,
              selected = 1,
              multiple = FALSE),
    selectInput(
              inputId = "x_axis",
              label = "Choose x axis variable", 
              choices = food_colnames,
              selected = "Daily.caloric.intake.per.person.from.oils.and.fats"),
    selectInput(
              inputId = "y_axis",
              label = "Choose y axis variable", 
              choices = disorder_colnames,
              selected = "Current.number.of.cases.of.anxiety.disorders..in.both.sexes.aged.all.ages")
)

viz_3_main_panel <- mainPanel(
  h2("Vizualization 3 Title"),
  plotlyOutput(outputId = "scatter_plot")
)

viz_3_tab <- tabPanel("Food vs Mental Health",
  sidebarLayout(
    viz_3_sidebar,
    viz_3_main_panel
  )
)

## CONCLUSIONS TAB INFO

conclusion_tab <- tabPanel("Conclusion",
 h1("Some title"),
 p("some conclusions")
)

#Overall UI Navbar

ui <- navbarPage("Mental Health-Diet",
  overview_tab,
  viz_1_tab,
  viz_2_tab,
  viz_3_tab,
  conclusion_tab
)