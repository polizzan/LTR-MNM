#################################
#--Simulation & calculation of--# 
#-------the lifetime risk-------# 
#-----of maternal near miss-----#
#-----------(LTR-MNM)-----------#  
#################################

# --- FILE 99-output.R: PLOT AND TABULATE LTR-MNM ---

# load input information
load(file=here::here("data", "Input.RData"))

# load ltr data
load(file=here::here("data", paste0("LTR-byage-", CNTRY, "-", YR, ".RData")))

# plot age-specific risks by age profile 
ltr.plot <- 
  ggplot(ltr.byage, aes(x=age, y=ratio, group=1)) + 
  geom_point() + 
  ylim(0, plyr::round_any(max(ltr.byage$ratio), 5, f=ceiling)) +
  geom_smooth(se=FALSE, method="loess", formula=y~x) +
  facet_wrap(~ name, nrow=2) + 
  labs(x="Age", y="MNM Ratio (per 1000 live births)") + 
  theme_classic() +
  theme(axis.title.x=element_text(vjust=-1))

pdf(here::here("out", paste0("MNMratio-", CNTRY, "-", YR, ".pdf")), width=11, height=9)

print(ltr.plot) ## save plot

dev.off()

# tabulate ltr-mnm by age profile
ltr.table <- 
  ltr.byage %>%
  gt(groupname_col="name",
     rowname_col="age") %>% 
  tab_header(
    title=md("**LTR-MNM**"),
    subtitle="By age profile of risk"
  ) %>% 
  cols_label(cases="MNM Cases", 
             livebirths="Livebirths", 
             ratio="MNMRatio", 
             survivor="Survivorship",
             ltr="LTR-MNM") %>%
  summary_rows(columns=c(cases, livebirths),
               fns=list(fn="sum", label = "Total"),
               fmt=list(~ fmt_number(., decimals=0))) %>% 
  summary_rows(columns=c(ltr),
               fns=list(fn="sum", label = "Total"),
               fmt=list(~ fmt_number(., decimals=4))) %>% 
  fmt_number(columns=c(cases, livebirths, Lx), decimals=0) %>% 
  fmt_number(columns=c(ratio, fx, survivor), decimals=2) %>% 
  fmt_number(columns=c(ltr), decimals=4) %>% 
  tab_options(
    row_group.as_column=TRUE,
    data_row.padding=px(2),
    summary_row.padding=px(2),
  ) %>% 
  tab_style(
    locations=cells_summary(),
    style=cell_fill(color="lightblue")
  ) 

gtsave(ltr.table, here::here("out", paste0("LTR-", CNTRY, "-", YR, ".png")), expand=25)

# clear environment
rm(list=ls())
