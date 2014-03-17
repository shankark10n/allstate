require(plyr)
require(ggplot2)
require(lme4)
require(xts)

clear_all_data <- TRUE

load.libraries <- function() {
	require(plyr)
	require(tseries)
	require(ggplot2)
	require(lme4)
	require(xts)
	require(scales)
	require(stargazer)
	require(dplyr)
	require(RColorBrewer)
	require(xtable)
}

if (clear_all_data) {
	rm(list=ls(all=TRUE))
}

# AUXILIARY FUNCTIONS
rmse <- function(x, y) { sqrt(mean((x-y)^2)) }

# LOAD DATA
setwd('~/work/data/kaggle/allstate/')
train<-read.csv('train.csv')
test<-read.csv('test_v2.csv')
train$car_value[train$car_value=='']<-NA
test$car_value[test$car_value=='']<-NA

# MODELS
# preliminary cost function as a regression over state, group_size, homeowner, car_age, risk_factor, age_oldest, age_youngest, married_couple, duration_previous (trained only on purchase points)
m <- with(subset(train, record_type==1), lm(cost~factor(state) 
	+ group_size 
	+ factor(homeowner)
	+ car_age
	+ factor(risk_factor)
	+ age_oldest 
	+ age_youngest 
	+ factor(married_couple) 
	+ duration_previous))
test$pred <- predict(m, test)
with(subset(test, !is.na(pred)), rmse(cost, pred)) # 37.54
# add car_value
m <- with(subset(train, record_type==1), lm(cost~factor(state)
 + group_size
 + factor(homeowner)
 + car_age
 + factor(car_value)
 + factor(risk_factor)
 + age_oldest
 + age_youngest
 + factor(married_couple)
 + duration_previous))
test$pred <- predict(m, test)
with(subset(test, !is.na(pred)), rmse(cost, pred)) # 37.29
# add A...G
m <- with(subset(train, record_type==1), lm(cost~factor(state) 
	+ group_size 
	+ factor(homeowner)
	+ car_age
	+ factor(risk_factor)
	+ age_oldest 
	+ age_youngest 
	+ factor(married_couple) 
	+ factor(A)
	+ factor(B)
	+ factor(C)
	+ factor(D)
	+ factor(E)
	+ factor(F)
	+ factor(G)
	+ duration_previous))
test$pred <- predict(m, test)
with(subset(test, !is.na(pred)), rmse(cost, pred)) # 34.43
# try predicting cost function model on train with record_type==0
t <- subset(train, record_type==0)
t$pred <- predict(m, t)
with(subset(t, !is.na(pred)), rmse(cost, pred)) # 34.22
