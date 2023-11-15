#################################
#--Simulation & calculation of--# 
#-------the lifetime risk-------# 
#-----of maternal near miss-----#
#-----------(LTR-MNM)-----------#  
#################################

# --- FILE 01-preparation.R: LOAD AND COMBINE UNWPP DATA ---

# load input information
load(file=here::here("data", "Input.RData"))

# define ages (five-year intervals)
age <- c("15-19", 
         "20-24", 
         "25-29", 
         "30-34", 
         "35-39", 
         "40-44", 
         "45-49")

# WPP life table information (abridged)
WPP.mort <- read_csv(here::here("data", "WPP2022_Life_Table_Abridged_Medium_1950-2021.zip")) %>% 
              filter(ISO3_code==CNTRY) %>%
              filter(Time==YR) %>% 
              filter(Sex=="Female") %>% 
              filter(AgeGrp %in% age) %>%
              mutate(survivor=Lx/lx[1]) %>% ## survivorship ratio (Lx/l15)
              select(Lx, survivor)
  
# WPP age-specific fertility rates & births per 1,000 (abridged) 
WPP.fert <- read_csv(here::here("data", "WPP2022_Fertility_by_Age5.zip")) %>% 
              filter(ISO3_code==CNTRY) %>%
              filter(Time==YR) %>% 
              filter(AgeGrp %in% age) %>%
              mutate(fx=ASFR/1000,
                     livebirths=Births*((1000-stillbirths)/1000)) %>% ## adjust for number of stillbirths
              select(fx, livebirths)

# sex ratio at birth
srb <- read_csv(here::here("data", "WPP2022_Demographic_Indicators_Medium.zip")) %>% 
          filter(ISO3_code==CNTRY) %>% 
          filter(Time==YR) %>% 
          mutate(SRB=1+SRB/100) %>% 
          pull(SRB)

# net reproduction rate
nrr <- read_csv(here::here("data", "WPP2022_Demographic_Indicators_Medium.zip")) %>% 
          filter(ISO3_code==CNTRY) %>% 
          filter(Time==YR) %>% 
          pull(NRR)
  
# create list object
WPP.total <- list(data.frame(age, WPP.mort, WPP.fert), srb, nrr)

# save environment
save(WPP.total, file=here::here("data", paste0("WPP-", CNTRY, "-", YR, ".RData")))

# clear environment
rm(list=ls())
