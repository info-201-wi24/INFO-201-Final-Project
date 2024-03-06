library(ggplot2)
library(plotly)
library(bslib)
library(markdown)

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
  "Alcoholic Beverages" = "Daily.caloric.intake.per.person.from.alcoholic.beverages",
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
  "Alcoholic Beverages" = "Daily.caloric.intake.per.person.from.alcoholic.beverages",
  "Sugar" = "Daily.caloric.intake.per.person.from.sugar",
  "Meat" = "Daily.caloric.intake.per.person.from.meat",
  "Starchy Roots" = "Daily.caloric.intake.per.person.from.starchy.roots",
  "Pulses/Legumes" = "Daily.caloric.intake.per.person.from.pulses", 
  "Dairy and Eggs" = "Daily.caloric.intake.per.person.from.dairy.and.eggs",
  "Oils and Fats" = "Daily.caloric.intake.per.person.from.oils.and.fats", 
  "Cereals and Grains" = "Daily.caloric.intake.per.person.from.cereals.and.grains",
  "Other" = "Daily.caloric.intake.per.person.from.other.commodities"
)

#color theme
my_theme <- bs_theme(bg = "#edf6f9", #background
                     fg = "black", #foreground color
                     primary = "#00b4d8") # primary color

## OVERVIEW TAB INFO

overview_tab <- tabPanel("Overview",
   h1("Exploring Associations Between Mental Health and Dietary Compositions"),
   img(src="nutrition.png", height="50%", width="50%"),
   p(""),
   includeMarkdown("intro_text.md")
)

## VIZ 1 TAB INFO

viz_1_sidebar <- sidebarPanel(
  #TODO: Put inputs for modifying graph here
  selectInput(inputId = "year_selection",
              label = "Year",
              choices = unique(df$Year),
              selected = 2019,
              multiple = FALSE), 
  radioButtons(inputId = "button_choice",
               label = p("Data Type"),
               choices = list("Diet" = 1,
                              "Mental Disorder" = 2),
                              selected = 1),
  selectInput(inputId = "country_selection",
              label = "Country",
              choices = unique(df$Entity),
              selected = "United States",
              multiple = FALSE)
)

viz_1_main_panel <- mainPanel(
  h2("Dietary Composition and Mental Disorders of Countries (1990-2019)"),
  plotlyOutput(outputId = "country_bar"),
  p(""),
  includeMarkdown("tab_1_text.md")
)

viz_1_tab <- tabPanel("Disorder/Food Type",
  sidebarLayout(
    viz_1_sidebar,
    viz_1_main_panel
  )
)

## VIZ 2 TAB INFO

viz_2_sidebar <- sidebarPanel(
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
    multiple = FALSE,
    selected = "Daily.caloric.intake.per.person.from.sugar"
  )
)

viz_2_main_panel <- mainPanel(
  h1("Mental Disorder and Diet Trends Over the Years (1990-2019)"),
  plotlyOutput(outputId = "trend_plot"),
  p(""),
  includeMarkdown("tab_2_text.md")
)
  

viz_2_tab <- tabPanel("Trends Over Time",
  sidebarLayout(
    viz_2_sidebar,
    viz_2_main_panel
  )
)

## VIZ 3 TAB INFO

viz_3_sidebar <- sidebarPanel(
  #TODO: Put inputs for modifying graph here
  selectInput(inputId = "scatter_year_selection",
              label = "Year",
              choices = unique(df$Year),
              selected = 2019,
              multiple = FALSE),
    selectInput(
              inputId = "x_axis",
              label = "Choose x axis variable", 
              choices = food_colnames,
              selected = "Daily.caloric.intake.per.person.from.cereals.and.grains"),
    selectInput(
              inputId = "y_axis",
              label = "Choose y axis variable", 
              choices = disorder_colnames,
              selected = "Current.number.of.cases.of.eating.disorders..in.both.sexes.aged.all.ages")
)

viz_3_main_panel <- mainPanel(
  h2("Food Comsumption versus Mental Disorder Prevalence (1990-2019)"),
  plotlyOutput(outputId = "scatter_plot"),
  p(""),
  includeMarkdown("tab_3_text.md")
)

viz_3_tab <- tabPanel("Food vs Mental Health",
  sidebarLayout(
    viz_3_sidebar,
    viz_3_main_panel
  )
)

## CONCLUSIONS TAB INFO

conclusion_tab <- tabPanel("Conclusion",
 h1("Conclusion"),
 img(src="mental health.png", height="30%", width="30%"),
 p(""),
 includeMarkdown("conclusion_text.md"),
 img(src="food-groups.png", height="30%", width="30%"),
 p("")
)

#Overall UI Navbar

ui <- navbarPage(
  theme = my_theme,
  "Mental Health-Diet",
  overview_tab,
  viz_1_tab,
  viz_2_tab,
  viz_3_tab,
  conclusion_tab
)