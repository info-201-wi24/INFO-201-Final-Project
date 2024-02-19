food_df <- read.csv("dietary-compositions-by-commodity-group.csv")

mental_illness_df <- read.csv("mental-illness-estimated-cases.csv")

food_mental_df <- left_join(mental_illness_df, food_df)

#rename column
colnames(food_mental_df)[1] = "Country/Region"
