#################################
#--Simulation & calculation of--# 
#-------the lifetime risk-------# 
#-----of maternal near miss-----#
#-----------(LTR-MNM)-----------#  
#################################

# --- FILE 02-LTR-MNM_age-specific.R: CALCULATE LTR-MNM WITH AGE-SPECIFIC DATA ---

# load input information
load(file=here::here("data", "Input.RData"))

# load WPP data
load(file=here::here("data", paste0("WPP-", CNTRY, "-", YR, ".RData")))

# define total maternal-near-misses for simulation
total.cases <- (sum(WPP.total[[1]]$livebirths)) * mnm.ratio ## implied cases

# define age profiles for simulation
set.seed(seed) ## set seed for reproducibility
age.profile <- sort(rnorm(n=length(WPP.total[[1]]$age), mean=10, sd=4), 
                    decreasing=FALSE) ## generate random rates

# order random rates in accordance with different age profiles
jshape <- c(age.profile[3], 
            age.profile[1],
            age.profile[2],
            age.profile[4],
            age.profile[5],
            age.profile[6], 
            age.profile[7])

increasing <- age.profile

decreasing <- sort(age.profile, decreasing=TRUE)

constant <- rep(mnm.ratio, length(WPP.total[[1]]$age))

nshape <- c(age.profile[1],
            age.profile[2],
            age.profile[5], 
            age.profile[7], 
            age.profile[6], 
            age.profile[4],
            age.profile[3])

ushape <- c(age.profile[6], 
            age.profile[4],
            age.profile[2],
            age.profile[1],
            age.profile[3],
            age.profile[5], 
            age.profile[7])

# calculate age-specific risks for each age profile
ltr.byage <-
  data.frame( ## create combined data set of all age profiles 
    "age"=rep(WPP.total[[1]]$age, 6),
    "name"=rep(c("J-shape", "Increasing", "Decreasing", "Constant", "N-shape", "U-shape"), 
               each=length(WPP.total[[1]]$age)),
    "age.profile"=c(jshape, increasing, decreasing, constant, nshape, ushape)
  ) %>% 
  left_join(WPP.total[[1]], by=c("age")) %>% ## add information from WPP
  group_by(name) %>% ## for each age profile:
  mutate(factor=total.cases/sum(age.profile*livebirths), ## calculate adjustment factor for random age-specific risks
         ratio=factor*age.profile, ## adjust age-specific risks using adjustment factor
         cases=ratio*livebirths, ## calculate age-specific near misses
         ltr=ratio*fx*survivor/1000, ## calculate age-specific risks
         livebirths=livebirths*1000,
         name=factor(name, 
                     levels=c("J-shape", "Increasing", "Decreasing", 
                              "Constant", "N-shape", "U-shape"))) %>% 
  ungroup() %>% 
  select(name, age, cases, livebirths, ratio, fx, Lx, survivor, ltr)

# calculate lifetime risks for each age profile
ltr.byage.sum <- 
  ltr.byage %>% 
    group_by(name) %>% 
    summarise(ltr.sum=sum(ltr), ## calculate lifetime risk
              ltr.1.in=1/ltr.sum) ## express lifetime risk as '1 in x' 

# save environment
save(ltr.byage, ltr.byage.sum, file=here::here("data", paste0("LTR-byage-", CNTRY, "-", YR, ".RData")))

# clear environment
rm(list=ls())
