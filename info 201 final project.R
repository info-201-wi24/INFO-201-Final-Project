food_df <- read.csv("dietary-compositions-by-commodity-group.csv")

mental_illness_df <- read.csv("mental-illness-estimated-cases.csv")

#join dataframes
food_mental_df <- left_join(mental_illness_df, food_df)

#create additional columns
food_mental_df <- food_mental_df %>% 
  mutate(Total.mental.disorders.cases = Current.number.of.cases.of.anxiety.disorders..in.both.sexes.aged.all.ages
         + Current.number.of.cases.of.depressive.disorders..in.both.sexes.aged.all.ages +
           Current.number.of.cases.of.schizophrenia..in.both.sexes.aged.all.ages +
           Current.number.of.cases.of.bipolar.disorder..in.both.sexes.aged.all.ages + 
           Current.number.of.cases.of.eating.disorders..in.both.sexes.aged.all.ages)

#create summarization dataframe
avg_sugar_df <- food_mental_df %>% 
  group_by(Entity) %>%
  summarize(avg.sugar.intake = mean(Daily.caloric.intake.per.person.from.sugar, na.rm = TRUE))
  
  