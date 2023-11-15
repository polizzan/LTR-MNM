#################################
#--Simulation & calculation of--# 
#-------the lifetime risk-------# 
#-----of maternal near miss-----#
#-----------(LTR-MNM)-----------#  
#################################

# --- FILE 00-main.R: INSTALL AND LOAD PACKAGES, RUN ALL OTHER FILES ---

# packages to be installed from cran
from.cran <- c("gt", "gtsummary", "here", 
               "plyr", "tidyverse", "webshot2")

## check if installed, else install
for(i in c(from.cran)){
  
  if(i %in% from.cran){
    
    if(system.file(package=i)==""){install.packages(i)}
    
  }
}

# load packages
library(gt)
library(gtsummary)
library(tidyverse)
library(webshot2)

# set directory
here::i_am("scripts/00-main.R")

# select input information
{
## seed (for reproducibility)
seed <- 280123
  
## select country (ISO code) and year
CNTRY <- "NAM" ## Namibia
YR <- 2019

## assumed total mnm ratio
mnm.ratio <- 8.03

## assumed number of stillbirths per 1,000
stillbirths <- 17.68

## save environment
save(seed, CNTRY, YR, mnm.ratio, stillbirths, 
     file=here::here("data", "Input.RData"))

## clear environment
rm(list=ls())
}

# create output folder
if(!dir.exists(here::here("out"))){dir.create(here::here("out"))}

# run scripts
{
source(here::here("scripts", "01-preparation.R")) 

source(here::here("scripts", "02-LTR-MNM_age-specific.R"))

source(here::here("scripts", "03-LTR-MNM_aggregate.R"))

source(here::here("scripts", "99-output.R"))
}
  
# load data files for post analysis (optional)
## load(file=here::here("data", "Input.RData"))
## load(file=here::here("data", paste0("LTR-byage-", CNTRY, "-", YR, ".RData")))
## load(file=here::here("data", paste0("LTR-agg-", CNTRY, "-", YR, ".RData")))
