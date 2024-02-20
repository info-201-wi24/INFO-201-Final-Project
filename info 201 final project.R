#library statements
library(dplyr) 

#loads in dataset
food_df <- read.csv("dietary-compositions-by-commodity-group.csv")

mental_illness_df <- read.csv("mental-illness-estimated-cases.csv")

#join dataframes
food_mental_df <- left_join(mental_illness_df, food_df)

food_mental_df <- na.omit(food_mental_df)

#create new numerical column
food_mental_df <- food_mental_df %>% 
  mutate(Total.mental.disorders.cases = Current.number.of.cases.of.anxiety.disorders..in.both.sexes.aged.all.ages
         + Current.number.of.cases.of.depressive.disorders..in.both.sexes.aged.all.ages +
           Current.number.of.cases.of.schizophrenia..in.both.sexes.aged.all.ages +
           Current.number.of.cases.of.bipolar.disorder..in.both.sexes.aged.all.ages + 
           Current.number.of.cases.of.eating.disorders..in.both.sexes.aged.all.ages)

#create new categorical column
food_category <- food_mental_df %>% 
  select(Daily.caloric.intake.per.person.from.alcoholic.beverages, Daily.caloric.intake.per.person.from.sugar,
         Daily.caloric.intake.per.person.from.meat, Daily.caloric.intake.per.person.from.starchy.roots,
         Daily.caloric.intake.per.person.from.pulses, Daily.caloric.intake.per.person.from.dairy.and.eggs, 
         Daily.caloric.intake.per.person.from.oils.and.fats, Daily.caloric.intake.per.person.from.other.commodities,
         Daily.caloric.intake.per.person.from.cereals.and.grains)

food_mental_df <- food_mental_df %>% 
  mutate(biggest.food.group = print(colnames(food_category)[max.col(food_category)]))

#create summarization dataframe
avg_sugar_df <- food_mental_df %>% 
  group_by(Entity) %>%
  summarize(avg.sugar.intake = mean(Daily.caloric.intake.per.person.from.sugar, na.rm = TRUE))

#export new csv file
write.csv(food_mental_df, "final-diet-with-mental-illness.csv")
  