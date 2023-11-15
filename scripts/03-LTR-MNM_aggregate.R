#################################
#--Simulation & calculation of--# 
#-------the lifetime risk-------# 
#-----of maternal near miss-----#
#-----------(LTR-MNM)-----------#  
#################################

# --- FILE 03-LTR-MNM_aggregate.R: CALCULATE LTR-MNM WITH AGGREGATE DATA ---

# load input information
load(file=here::here("data", "Input.RData"))

# load WPP data
load(file=here::here("data", paste0("WPP-", CNTRY, "-", YR, ".RData")))

# life table radix
l0 <- 100000

# life table survivors at age 15
l15 <- WPP.total[[1]]$Lx[1] / WPP.total[[1]]$survivor[1]

# calculate LTR-MNM using aggregate data
ltr <- mnm.ratio*WPP.total[[2]]*WPP.total[[3]]*(l0/l15)/1000

# create data frame
ltr.agg <- data.frame("ltr"=ltr,
                      "ltr.1.in"=1/ltr)

# save environment
save(ltr.agg, file=here::here("data", paste0("LTR-agg-", CNTRY, "-", YR, ".RData")))

# clear environment
rm(list=ls())
