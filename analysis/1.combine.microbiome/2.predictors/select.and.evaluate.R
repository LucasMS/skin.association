
# Read input ----
args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args) ==1) {
  # default output file
  args[2] = "./variable.selection"
}



#libraries ----
library(MLmetrics) # F1, accuracy, precision
library(tidyverse)
library(broom) # tidy formula
library(caret) # RF and ranger
library(mltools) #MCC

# Load functions
tryCatch({source("./functions.R")},
         error = function(e) {source("../functions/functions.R")})
# Import data

#d.out <- "./variable.selection"
# Define response ----
n.rep <- as.numeric(args[1])
d.out <- args[2]
dir.create(d.out, showWarnings = F)

d.in <- "./aux.files"

all <- "all.rds" %>%
  paste0(d.in, "/", .) %>%
  readRDS()



# Work with just one sample per participant
set.seed(n.rep)  

# get random set of samples. One site per participant.

n <- all %>% pull(Participant_ID) %>% unique() %>% length()
samples <- data.frame(Participant_ID = all %>% 
                        pull(Participant_ID) %>% 
                        unique() %>% 
                        sample,
                      Microenvironment = rep(all %>%
                                               pull(Microenvironment) 
                                             %>% unique(), 
                                             n) %>% 
                        sample(n),
                      stringsAsFactors = F)
# Select samples

df <- all %>%
  inner_join(samples, by = c("Participant_ID", "Microenvironment")) %>% 
  # remove eventually duplicated Participants
  .[sample(nrow(.)),] %>% 
  filter(!duplicated(Participant_ID))
# This, will assure that one participant contribute to one sample, but the dry will be half of the other environments

counts <- count(df, Microenvironment) %>% pull(n) %>% paste0(collapse = ":")

# keep only essentials

df <- df %>% 
  mutate(response = Microenvironment) %>% 
  select(setdiff(colnames(.), c("Participant_ID","Site", "Cohort", "Microenvironment")))

# Split data
train.index <- createDataPartition(df$response, p = .8, times =1)$Resample1
test.index <- setdiff(1:nrow(df), train.index)
train <- df [train.index, ]
test <- df [test.index, ]

# Set variables
x <- setdiff(colnames(df), "response")
y <- "response"

# Perform RF with all variables -------------- 
y <- "response"
x <- colnames(df)[colnames(df) != y]

eval.all <- do.evaluation.rf(x)

eval.all[["df"]] <- eval.all[["df"]] %>% 
  mutate(variables = "all variables")

# gather results
global.res <- eval.all[["df"]] %>% 
  mutate(n.rep = n.rep,
         counts = counts)

# Save output ----

res.list <- list(global.res = global.res,
                 eval.all = eval.all)

paste0(n.rep %>% as.character(), ".results.rds") %>% 
  paste0(d.out,  "/", .) %>%
  saveRDS(res.list,.)

# Session info ----
sessionInfo()
