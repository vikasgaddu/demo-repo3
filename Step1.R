

# To learn any language you should be able to create fictitious scenarios
# in your data, to test out your logic so that it works for different situations

# To Create your own data in R, we will use TRIBBLE function 
# (row wise tibble creation)
# To use this function we need in import tidyverse library where this function is
# defined.

library(tidyverse)

# Open LOG file
library(logr)
library(tidylog, warn.conflicts = TRUE)

log_open("Step1", autolog = TRUE, show_notes=FALSE)

# DATALINES -----
# Similar to data lines to read in a data

dm <- tribble(~subjid, ~invname, ~sex, ~age, ~arm,
                 
                 200, "Crowe, Autumn", "F", 60, "A",
                 
                 101, "Crowe, Autumn", "M", 60, "A",
                 
                 100, "Raven, Spring", "M", 65, "B")


# DATA: Save dataframe as SAS Dataset ----
library(haven)
path <- './dm.sas7bdat'
file.exists(path)
write_sas(dm,path)

#SET: Read SAS Dataset as dataframe ----
dm1 <- read_sas(path)
dm1


sep('SOMETHING')

# Create New Variable ----
# Cannot use if condiiton as it only works on single value. Unless you create 
# function using vectorize function.

dm_cat <- dm %>% mutate(agecat = ifelse(age < 30,1,ifelse(age <= 60, 2,3) ))
dm_cat

dm_cat <- dm %>% mutate(agecat = ifelse(age %in% 0:30,1,ifelse(age %in% 31:60, 2,3) ))
dm_cat


# RENAME a variable -----
dm_cat_ <- dm_cat %>% rename(agecat1=agecat)
dm_cat_

# KEEP and DROP -------
# keep or drop only some columns(Similar to KEEP/Drop statement)

dm_keep <- dm %>% select(subjid,age,arm)
dm_keep <- dm %>% select(c(subjid,age,arm))
dm_keep

dm_drop <- dm %>% select(-subjid,-age,-arm)
dm_drop <- dm %>% select(-c(subjid,age,arm))
dm_drop

dm_keep

# WHERE -----
# Subsetting a data frame

dm_age <- dm %>% filter(age <= 60 & sex == 'F')
dm_age

# PROC SORT --
dm_sorted <- dm %>% arrange(age,desc(subjid),.by_group =TRUE)
str(dm_sorted)



ex <- tribble(~subjid,~exstdtc,~exendtc,
              1001,'2020-01-01','2020-01-15',
              1001,'2020-02-15','2020-02-28'
              )


# Creating Sequence -----
ex_seq <- ex %>% group_by(subjid) %>% 
  mutate(seq = seq_along(subjid))
ex_seq

# PROC TRANSPOSE ----
vignette("pivot")
ex_vert <- ex_seq %>% pivot_longer(cols=c(exstdtc,exendtc), values_to = "exdtc")
ex_vert

ex_hort <- ex_vert %>% pivot_wider(names_from = name, values_from = exdtc)
ex_hort

# First. Last. ------
rfxstdtc <- ex_vert %>% arrange(subjid,exdtc) %>% 
  group_by(subjid) %>% 
  slice(1) %>% 
  rename(rfxstdtc = exdtc)

rfxstdtc

rfxendtc <- ex_vert %>% arrange(subjid,desc(exdtc)) %>% 
  group_by(subjid) %>% 
  slice(1) %>% 
  rename(rfxendtc = exdtc)

rfxendtc


subjid <- dm$subjid
invname <- dm$invname

dmdf <- data.frame(subjid,invname)

typeof(dm$subjid)
typeof(dmdf$subjid)

typeof(dm[0])
typeof(dmdf[[0]])

log_close()
options("tidylog.display" = NULL)
