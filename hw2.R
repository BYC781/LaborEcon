install.packages("haven")
library(haven)
library(tidyverse)
timeuse <- read_dta("./term/work/timeuse.dta")
summary(timeuse)

never.married <- timeuse %>% filter(marst == 6)
married <- timeuse %>% filter(marst == 1)
inter.term <- timeuse %>% mutate(sex.X.wfh = female*distance_work)
inter.term$sex.X.wfh


wb_grpby_marst <- timeuse %>% 
    group_by(marst) %>% 
    summarize(wb.mean.grpby.marst = mean(wbladder,na.rm = T))


combine.data <- full_join(timeuse, wb_grpby_marst)


ggplot(timeuse, aes(x = factor(marst), y = wbladder)) +
    geom_violin(fill = "skyblue", color = "black", alpha = 0.8) +
    labs(x = "Marital Status", y = "Well-being Index") +
    ggtitle("Violin Plot of Well-being by Marital Status") +
    theme_minimal()

# as.factor
timeuse$marst <- factor(timeuse$marst)
attributes(timeuse$race)
ols <- lm(wbladder ~ marst, data = timeuse)
summary(ols)
