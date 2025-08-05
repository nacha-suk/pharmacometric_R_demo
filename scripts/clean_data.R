# clean_data.R
# Cleaning and transforming Theophylline PK dataset

# Load required packages
library(dplyr)
library(readr)

# Load dataset
pk_data <- read_csv("data/theophylline.csv")

# Clean data
pk_clean <- pk_data %>%
  filter(!is.na(DV)) %>%               # remove missing concentrations
  mutate(log_dv = log(DV))             # create new column: log concentration

# Clean data 
#Why This Happens in PK Data
#DV = dependent variable = drug concentration
#Log-transformation is undefined for zero or negative values:
  #log(0) = undefined log(-2) = undefined
#These may come from:
#1Below limit of quantification (BLQ)
#2Simulation noise
#3Data entry issues
----------------------------------------------------------
#Fix it
#option 1 Filter out DV ≤ 0 before taking log
pk_clean <- pk_data %>%
  filter(!is.na(DV), DV > 0) %>%
  mutate(log_dv = log(DV))

# Save cleaned data
write_csv(pk_clean, "output/theo_clean1.csv")

# Preview cleaned data
glimpse(pk_clean)
---------------------------------------------------------
#option 2 Replace zeros with small value 
  #(not ideal for real modeling, but OK for testing)
  
  pk_clean <- pk_data %>%
  mutate(DV = ifelse(DV <= 0, 0.01, DV),  # replace 0 or negatives with 0.01
         log_dv = log(DV))
# Save cleaned data
write_csv(pk_clean, "output/theo_clean.csv")

# Preview cleaned data
glimpse(pk_clean)

#------------------------------------------------------
preadr::write_csv(pk_data, "output/theo_clean_final.csv")k_data <- readr::read_csv("output/theo_clean1.csv")
list.files("output/")




