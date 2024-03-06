library(plotly)
library(ggplot2)
library(dplyr)
library(scales)
library(tidyverse)
library(RColorBrewer)

#read file
df <- read.csv("final-diet-with-mental-illness.csv", stringsAsFactors = FALSE)
df <- df[-(4881:4910),]

server <- function(input, output){
  
  # TODO Make outputs based on the UI inputs here
    
  #graph 1
    output$country_bar <- renderPlotly({
      #TODO make plotly graph
      
      food_selected_df <- df %>%
        filter(Year %in% input$year_selection) %>%
        filter(Entity %in% input$country_selection) %>%
        pivot_longer (cols = c(`Daily.caloric.intake.per.person.from.alcoholic.beverages`,
                               `Daily.caloric.intake.per.person.from.sugar`,
                               `Daily.caloric.intake.per.person.from.meat`,
                               `Daily.caloric.intake.per.person.from.starchy.roots`,
                               `Daily.caloric.intake.per.person.from.pulses`,
                               `Daily.caloric.intake.per.person.from.dairy.and.eggs`,
                               `Daily.caloric.intake.per.person.from.oils.and.fats`,
                               `Daily.caloric.intake.per.person.from.cereals.and.grains`,
                               Daily.caloric.intake.per.person.from.other.commodities),
                      values_to = "food.kilocalories",
                      names_to = "food.type")

      mental_selected_df <- df %>%
        filter(Year %in% input$year_selection) %>%
        filter(Entity %in% input$country_selection) %>%
        pivot_longer (cols = c(`Current.number.of.cases.of.anxiety.disorders..in.both.sexes.aged.all.ages`,
                               `Current.number.of.cases.of.depressive.disorders..in.both.sexes.aged.all.ages`,
                               `Current.number.of.cases.of.schizophrenia..in.both.sexes.aged.all.ages`,
                               `Current.number.of.cases.of.bipolar.disorder..in.both.sexes.aged.all.ages`,
                               `Current.number.of.cases.of.eating.disorders..in.both.sexes.aged.all.ages`),
                      values_to = "mental.disorder.cases",
                      names_to = "mental.disorder.type")
      
      
      if (input$button_choice %in% 1) {
        my_plot <- ggplot(food_selected_df)+
          geom_col(mapping = aes(
            x = food.kilocalories,
            y = food.type,
            fill = food.type, 
            text = paste("Number of calories: ", food.kilocalories))) +
          theme(legend.position = "none") +
          scale_y_discrete(labels = c(
            "Daily.caloric.intake.per.person.from.alcoholic.beverages" = "Alcoholic Beverages",
             "Daily.caloric.intake.per.person.from.sugar" = "Sugar",
            "Daily.caloric.intake.per.person.from.meat" = "Meat",
             "Daily.caloric.intake.per.person.from.starchy.roots" = "Starchy Roots",
             "Daily.caloric.intake.per.person.from.pulses" = "Pulses/Legumes", 
              "Daily.caloric.intake.per.person.from.dairy.and.eggs" = "Dairy and Eggs",
              "Daily.caloric.intake.per.person.from.oils.and.fats" = "Oils and Fats", 
               "Daily.caloric.intake.per.person.from.cereals.and.grains" = "Cereals and Grains",
               "Daily.caloric.intake.per.person.from.other.commodities" = "Other")) +
          labs(x = "Daily Calorie Intake Per Person (kcal)", y = "Food Type")
      } else if (input$button_choice %in% 2){
        my_plot <- ggplot(mental_selected_df)+
      geom_col(mapping = aes(
        x = mental.disorder.cases,
        y = mental.disorder.type,
        fill = mental.disorder.type,
        text = paste("Number of cases: ", mental.disorder.cases))) +
          theme(legend.position = "none") +
          scale_y_discrete(labels = c(
          "Current.number.of.cases.of.anxiety.disorders..in.both.sexes.aged.all.ages" = "Anxiety Disorder",
          "Current.number.of.cases.of.depressive.disorders..in.both.sexes.aged.all.ages" = "Depressive Disorder",
          "Current.number.of.cases.of.schizophrenia..in.both.sexes.aged.all.ages" = "Schizophrenia",
          "Current.number.of.cases.of.bipolar.disorder..in.both.sexes.aged.all.ages" = "Bipolar Disorder", 
          "Current.number.of.cases.of.eating.disorders..in.both.sexes.aged.all.ages" = "Eating Disorder")) +
        labs(x = "Number of Mental Disorder Cases", y = "Mental Disorder Type") +
        scale_x_continuous(labels = label_number(scale_cut = cut_short_scale()))
       }
  
    return(ggplotly(my_plot, tooltip = "text"))
    })
    
    
    #graph 2
    output$trend_plot <- renderPlotly({
      #TODO make plotly graph
      filtered_df <- df %>%
        filter(Entity %in% input$trend_country_selection) 
      
      food <- c("Daily.caloric.intake.per.person.from.alcoholic.beverages",
      "Daily.caloric.intake.per.person.from.sugar",
      "Daily.caloric.intake.per.person.from.meat",
      "Daily.caloric.intake.per.person.from.starchy.roots",
      "Daily.caloric.intake.per.person.from.pulses", 
      "Daily.caloric.intake.per.person.from.dairy.and.eggs",
      "Daily.caloric.intake.per.person.from.oils.and.fats", 
      "Daily.caloric.intake.per.person.from.cereals.and.grains",
      "Daily.caloric.intake.per.person.from.other.commodities")
      
      health <- c("Current.number.of.cases.of.anxiety.disorders..in.both.sexes.aged.all.ages",
                    "Current.number.of.cases.of.depressive.disorders..in.both.sexes.aged.all.ages",
                    "Current.number.of.cases.of.schizophrenia..in.both.sexes.aged.all.ages",
                    "Current.number.of.cases.of.bipolar.disorder..in.both.sexes.aged.all.ages",
                    "Current.number.of.cases.of.eating.disorders..in.both.sexes.aged.all.ages")
      
      if (input$trend_selection %in% food) {
        my_plot <- ggplot(filtered_df, mapping =
                            aes(x = Year,
                                y = !!as.name(input$trend_selection),
                                color = Entity, group=1,
                                text = paste("Year: ", Year,
                                             "<br>Calories: ", !!as.name(input$trend_selection),
                                             "<br>Country: ", Entity))) +
          geom_line() +
          geom_point() +
          labs(x = "Years", y = "Daily Calorie Intake Per Person (kcal)", color = "Country") +
          scale_x_continuous(breaks = seq(1990, 2020, 5)) +
          scale_y_continuous(labels = label_number(scale_cut = cut_short_scale()))
        

      } else if (input$trend_selection %in% health) {
        my_plot <- ggplot(filtered_df, mapping =
                            aes(x = Year,
                                y = !!as.name(input$trend_selection),
                                color = Entity, group=1,
                                text = paste("Year: ", Year, ", ",
                                             "<br>Cases: ", !!as.name(input$trend_selection), ", ",
                                             "<br>Country: ", Entity))) +
          geom_line() +
          geom_point() +
          labs(x = "Years", y = "Number of Estimated Mental Disorder Cases", fill = "Country") +
          scale_x_continuous(breaks = seq(1990, 2020, 5)) +
          scale_y_continuous(labels = label_number(scale_cut = cut_short_scale()))
      }

      return(ggplotly(my_plot, tooltip = "text"))
    })
    
    #graph 3
    output$scatter_plot <- renderPlotly({
      #TODO make plotly graph
      chosen_df <- df %>% 
       filter(Year %in% input$scatter_year_selection)

    my_plot <- ggplot(chosen_df) +
      geom_point(mapping = aes(
        x = !!as.name(input$x_axis),
        y = !!as.name(input$y_axis),
        text = paste("Calories: ", !!as.name(input$x_axis), ",",
                     "<br>Cases: ", !!as.name(input$y_axis),
                     "<br>Country: ", Entity),
        alpha = 0.5)) + 
      labs(x = "Daily Calorie Intake Per Person (kcal)", y = "Number of Estimated Mental Disorder Cases") +
      scale_y_continuous(labels = label_number(scale_cut = cut_short_scale()))
    
    return(ggplotly(my_plot, tooltip = "text"))
})
}