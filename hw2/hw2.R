library(haven)
library(modelsummary)
library(tidyverse)
library(MatchIt)
library(fastDummies)
library(sjmisc)
library(glmnet)
library(hdm)

timeuse <- read_dta("./term/work/timeuse.dta")
summary(timeuse)
datasummary_skim(timeuse,
                 title = "The descriptive statistics of Timeuse data")

never.married <- timeuse %>% filter(marst == 6)
married <- timeuse %>% filter(marst == 1)
timeuse <- timeuse %>% 
    mutate(
        D.female = distance_work * female, 
        D.hh_numkids = distance_work * hh_numkids,
        D.age = distance_work * age)

inter.term$D.female


wb_grpby_marst <- timeuse %>% 
    group_by(marst) %>% 
    summarize(wb.mean.grpby.marst = mean(wbladder,na.rm = T))


combine.data <- full_join(timeuse, wb_grpby_marst)


ggplot(timeuse, aes(x = factor(distance_work), y = bls_work_travel)) +
    geom_boxplot(fill = "skyblue", color = "black", alpha = 0.8) +
    labs(x = "Distance work", y = "bls_work_travel") +
    ggtitle("Box Plot of Well-being by Distance work") +
    theme_minimal()

# as.factor
tu1 <- timeuse %>% select(-wt06, -wt20, -sex, -bpl, -painmed, -wb_resp, 
                          -caseid, -covidtelew, -uhrsworkt, -painmed,
                          -wbeligtime, -hh_child, -rested, -hh_numownkids)
y <- tu1 %>% select(starts_with("bls_"), wbladder)
tu1 <- tu1 %>% select(-starts_with("bls_"), -wbladder)

catagorical.data <- tu1 %>% select(statefip,race, marst, 
                      empstat, occ2, ind2, famincome, 
                      citizen, clwkr, fullpart) %>% to_label()
numeric.data <- tu1 %>%
    select(-c(statefip,race, marst, 
              empstat, occ2, ind2, famincome, 
              citizen, clwkr, fullpart))
covariate <- bind_cols(catagorical.data, numeric.data)
covariate <- covariate %>% 
    relocate(c(distance_work, female, D.female, D.hh_numkids, D.age), 
             .before = statefip)




# ols without control variables
ols_list <- list()
for (i in 1:ncol(y)){
    regdata <- bind_cols(y[i], tu1)
    print(colnames(y[i]))
    fmla <- as.formula(paste(colnames(y[i]), "distance_work", sep=" ~ "))
    ols_list[[i]] <- lm(fmla, data=regdata)
    print(summary(lm(fmla, data=regdata)))
}

# ols
olslist <- list()
for (i in 1:ncol(y)){
    regdata <- bind_cols(y[i], covariate)
    fmla <- as.formula(paste(colnames(y[i]), ".", sep=" ~ "))
    olslist[[i]] <- lm(fmla, data=regdata)
    print(summary(lm(fmla, data=regdata)))
}
summary(olslist[[15]])


# psmatch
psmatchlist <- list()
for (i in 1:ncol(y)){
    regdata <- bind_cols(y[i], tu1)
    if (i == ncol(y)){
        regdata <- regdata %>% drop_na()
    }
    print(colnames(y[i]))
    fmla1 <- as.formula(paste("distance_work", ".", sep=" ~ "))
    fmla2 <- as.formula(paste(colnames(y[i]), "distance_work", sep=" ~ "))
    m.out1 <- matchit(fmla1, data = regdata, method = "nearest", distance = "logit",replace=FALSE)
    m.data1 <- match.data(m.out1,distance ="pscore") 
    psmatchlist[[i]] <- lm(fmla2, data = m.data1)
}
summary(psmatchlist[[18]])


# ols with interaction terms and control
dataf <- dummy_cols(covariate) %>% select(-(statefip:fullpart))
x2 <- dataf %>% 
    mutate(
        D.female = distance_work * female, 
        D.hh_numkids = distance_work*hh_numkids) %>% 
    relocate(c(D.female, D.hh_numkids), .after = female)
ols_list_inter <- list()
for (i in 1:ncol(y)){
    regdata <- bind_cols(y[i], x2)
    print(colnames(y[i]))
    fmla <- as.formula(paste(colnames(y[i]), ".", sep=" ~ "))
    ols_list_inter[[i]] <- lm(fmla, data=regdata)
    print(summary(lm(fmla, data=regdata)))
}

# lasso
lasso_list <- list()
for (i in 1:ncol(y)){
    regdata <- bind_cols(y[i], x2)
    regdata <- regdata[complete.cases(regdata),]
    cov <- regdata[,-1] %>% as.matrix()
    wb <- regdata[,1] %>% as.matrix()
    cvfit <- cv.glmnet(cov, wb, alpha = 1)
    lambda_opt <- cvfit$lambda.min
    lasso_model <- glmnet(cov, wb, alpha = 1, lambda = lambda_opt)
    lasso_list[[i]] <- list()
    lasso_list[[i]]$y <- colnames(y[i])
    lasso_list[[i]]$non_zero_coef <- coef(lasso_model)[coef(lasso_model)!=0]
    lasso_list[[i]]$non_zero_var_name <- colnames(x2)[which(coef(lasso_model) != 0)]
}



#double selection with interaction terms
double_selection_list <- list()
for (i in 1:ncol(y)){
    regdata <- bind_cols(y[i], x2)
    regdata <- regdata[complete.cases(regdata),]
    Y <- regdata[[1]]
    D <- regdata[[2]]
    X <- as.matrix(regdata)[, -c(1,2)]
    doublesel.effect <- rlassoEffect(x = X, y = Y, d = D, method = "double selection")
    double_selection_list[[i]] <- summary(doublesel.effect)
    print(summary(doublesel.effect))
}


