## ----echo=FALSE, results="asis"-----------------------------------------------
if(knitr::is_latex_output()){
  cat("# (PART) (ref:inferpart) {-}")
} else {
  cat("# (PART) Statistical Inference with infer {-} ")
}




## ----message=FALSE, warning=FALSE---------------------------------------------
library(tidyverse)
library(moderndive)


## ----message=FALSE, warning=FALSE, echo=FALSE---------------------------------
# Packages needed internally, but not in text.
library(knitr)
library(kableExtra)
library(patchwork)














## -----------------------------------------------------------------------------
tactile_prop_red


## ----eval=FALSE---------------------------------------------------------------
## ggplot(tactile_prop_red, aes(x = prop_red)) +
##   geom_histogram(binwidth = 0.05, boundary = 0.4, color = "white") +
##   labs(x = "Proportion of 50 balls that were red",
##        title = "Distribution of 33 proportions red")

## ----samplingdistribution-tactile, echo=FALSE, fig.cap="Distribution of 33 proportions based on 33 samples of size 50.", fig.height=3.1----
tactile_histogram <- ggplot(tactile_prop_red, aes(x = prop_red)) +
  geom_histogram(binwidth = 0.05, boundary = 0.4, color = "white")
tactile_histogram + 
  labs(x = "Proportion of 50 balls that were red", 
       title = "Distribution of 33 proportions red")






## -----------------------------------------------------------------------------
bowl


## -----------------------------------------------------------------------------
fruit_basket <- tibble(
  fruit = c("Mango", "Tangerine", "Apricot", "Pamplemousse", "Lime")
)


## -----------------------------------------------------------------------------
fruit_basket %>% 
  rep_sample_n(size = 3)


## ---- eval = FALSE------------------------------------------------------------
## fruit_basket %>%
##   rep_sample_n(size = 6)


## -----------------------------------------------------------------------------
virtual_shovel <- bowl %>% 
  rep_sample_n(size = 50)
virtual_shovel


## -----------------------------------------------------------------------------
virtual_shovel %>% 
  mutate(is_red = (color == "red"))


## -----------------------------------------------------------------------------
virtual_shovel %>% 
  mutate(is_red = (color == "red")) %>% 
  summarize(num_red = sum(is_red))

## ---- echo=FALSE--------------------------------------------------------------
n_red_virtual_shovel <- virtual_shovel %>% 
  mutate(is_red = (color == "red")) %>% 
  summarize(num_red = sum(is_red)) %>% 
  pull(num_red)


## -----------------------------------------------------------------------------
virtual_shovel %>% 
  mutate(is_red = color == "red") %>% 
  summarize(num_red = sum(is_red)) %>% 
  mutate(prop_red = num_red / 50)

## ---- echo=FALSE--------------------------------------------------------------
virtual_shovel_prop_red <- virtual_shovel %>% 
  mutate(is_red = color == "red") %>% 
  summarize(num_red = sum(is_red)) %>% 
  mutate(prop_red = num_red / 50) %>% 
  pull(prop_red) 
virtual_shovel_perc_red <- virtual_shovel_prop_red * 100


## -----------------------------------------------------------------------------
virtual_shovel %>% 
  summarize(num_red = sum(color == "red")) %>% 
  mutate(prop_red = num_red / 50)


## -----------------------------------------------------------------------------
virtual_samples <- bowl %>% 
  rep_sample_n(size = 50, reps = 33)
virtual_samples


## -----------------------------------------------------------------------------
virtual_prop_red <- virtual_samples %>% 
  group_by(replicate) %>% 
  summarize(red = sum(color == "red")) %>% 
  mutate(prop_red = red / 50)
virtual_prop_red


## ----eval=FALSE---------------------------------------------------------------
## ggplot(virtual_prop_red, aes(x = prop_red)) +
##   geom_histogram(binwidth = 0.05, boundary = 0.4, color = "white") +
##   labs(x = "Proportion of 50 balls that were red",
##        title = "Distribution of 33 proportions red")

## ----samplingdistribution-virtual, echo=FALSE, fig.cap="Distribution of 33 proportions based on 33 samples of size 50.", fig.height=3.2----
virtual_histogram <- ggplot(virtual_prop_red, aes(x = prop_red)) +
  geom_histogram(binwidth = 0.05, boundary = 0.4, color = "white")
virtual_histogram + 
  labs(x = "Proportion of 50 balls that were red", 
       title = "Distribution of 33 proportions red")


## ----tactile-vs-virtual, echo=FALSE, fig.cap="Comparing 33 virtual and 33 tactile proportions red.", fig.height=2.9----
facet_compare <- bind_rows(
  virtual_prop_red %>% 
    mutate(type = "Virtual sampling"), 
  tactile_prop_red %>% 
    select(replicate, red = red_balls, prop_red) %>% 
    mutate(type = "Tactile sampling")
) %>% 
  mutate(type = factor(type, levels = c("Virtual sampling", "Tactile sampling"))) %>% 
  ggplot(aes(x = prop_red)) +
  geom_histogram(binwidth = 0.05, boundary = 0.4, color = "white") +
  facet_wrap(~ type) +
  labs(x = "Proportion of 50 balls that were red", 
         title = "Comparing distributions") 

if(knitr::is_latex_output()){
  facet_compare +
  theme(
    strip.text = element_text(colour = 'black'),
    strip.background = element_rect(fill = "grey93")
  )
} else {
  facet_compare
}







## -----------------------------------------------------------------------------
virtual_samples <- bowl %>% 
  rep_sample_n(size = 50, reps = 1000)
virtual_samples


## -----------------------------------------------------------------------------
virtual_prop_red <- virtual_samples %>% 
  group_by(replicate) %>% 
  summarize(red = sum(color == "red")) %>% 
  mutate(prop_red = red / 50)
virtual_prop_red


## ----eval=FALSE---------------------------------------------------------------
## ggplot(virtual_prop_red, aes(x = prop_red)) +
##   geom_histogram(binwidth = 0.05, boundary = 0.4, color = "white") +
##   labs(x = "Proportion of 50 balls that were red",
##        title = "Distribution of 1000 proportions red")

## ----samplingdistribution-virtual-1000, echo=FALSE, fig.cap="Distribution of 1000 proportions based on 1000 samples of size 50."----
virtual_prop_red <- virtual_samples %>% 
  group_by(replicate) %>% 
  summarize(red = sum(color == "red")) %>% 
  mutate(prop_red = red / 50)
virtual_histogram <- ggplot(virtual_prop_red, aes(x = prop_red)) +
  geom_histogram(binwidth = 0.05, boundary = 0.4, color = "white")
virtual_histogram + 
  labs(x = "Proportion of 50 balls that were red", 
       title = "Distribution of 1000 proportions red")








## ---- eval=FALSE--------------------------------------------------------------
## # Segment 1: sample size = 25 ------------------------------
## # 1.a) Virtually use shovel 1000 times
## virtual_samples_25 <- bowl %>%
##   rep_sample_n(size = 25, reps = 1000)
## 
## # 1.b) Compute resulting 1000 replicates of proportion red
## virtual_prop_red_25 <- virtual_samples_25 %>%
##   group_by(replicate) %>%
##   summarize(red = sum(color == "red")) %>%
##   mutate(prop_red = red / 25)
## 
## # 1.c) Plot distribution via a histogram
## ggplot(virtual_prop_red_25, aes(x = prop_red)) +
##   geom_histogram(binwidth = 0.05, boundary = 0.4, color = "white") +
##   labs(x = "Proportion of 25 balls that were red", title = "25")
## 
## 
## # Segment 2: sample size = 50 ------------------------------
## # 2.a) Virtually use shovel 1000 times
## virtual_samples_50 <- bowl %>%
##   rep_sample_n(size = 50, reps = 1000)
## 
## # 2.b) Compute resulting 1000 replicates of proportion red
## virtual_prop_red_50 <- virtual_samples_50 %>%
##   group_by(replicate) %>%
##   summarize(red = sum(color == "red")) %>%
##   mutate(prop_red = red / 50)
## 
## # 2.c) Plot distribution via a histogram
## ggplot(virtual_prop_red_50, aes(x = prop_red)) +
##   geom_histogram(binwidth = 0.05, boundary = 0.4, color = "white") +
##   labs(x = "Proportion of 50 balls that were red", title = "50")
## 
## 
## # Segment 3: sample size = 100 ------------------------------
## # 3.a) Virtually using shovel with 100 slots 1000 times
## virtual_samples_100 <- bowl %>%
##   rep_sample_n(size = 100, reps = 1000)
## 
## # 3.b) Compute resulting 1000 replicates of proportion red
## virtual_prop_red_100 <- virtual_samples_100 %>%
##   group_by(replicate) %>%
##   summarize(red = sum(color == "red")) %>%
##   mutate(prop_red = red / 100)
## 
## # 3.c) Plot distribution via a histogram
## ggplot(virtual_prop_red_100, aes(x = prop_red)) +
##   geom_histogram(binwidth = 0.05, boundary = 0.4, color = "white") +
##   labs(x = "Proportion of 100 balls that were red", title = "100")


## ----comparing-sampling-distributions, echo=FALSE, fig.height=3, fig.cap="Comparing the distributions of proportion red for different sample sizes."----
# n = 25
if(!file.exists("rds/virtual_samples_25.rds")){
  virtual_samples_25 <- bowl %>% 
    rep_sample_n(size = 25, reps = 1000)
  write_rds(virtual_samples_25, "rds/virtual_samples_25.rds")
} else {
  virtual_samples_25 <- read_rds("rds/virtual_samples_25.rds")
}
virtual_prop_red_25 <- virtual_samples_25 %>% 
  group_by(replicate) %>% 
  summarize(red = sum(color == "red")) %>% 
  mutate(prop_red = red / 25) %>% 
  mutate(n = 25)

# n = 50
if(!file.exists("rds/virtual_samples_50.rds")){
  virtual_samples_50 <- bowl %>% 
    rep_sample_n(size = 50, reps = 1000)
  write_rds(virtual_samples_50, "rds/virtual_samples_50.rds")
} else {
  virtual_samples_50 <- read_rds("rds/virtual_samples_50.rds")
}
virtual_prop_red_50 <- virtual_samples_50 %>% 
  group_by(replicate) %>% 
  summarize(red = sum(color == "red")) %>% 
  mutate(prop_red = red / 50) %>% 
  mutate(n = 50)

# n = 100
if(!file.exists("rds/virtual_samples_100.rds")){
  virtual_samples_100 <- bowl %>% 
    rep_sample_n(size = 100, reps = 1000)
  write_rds(virtual_samples_100, "rds/virtual_samples_100.rds")
} else {
  virtual_samples_100 <- read_rds("rds/virtual_samples_100.rds")
}
virtual_prop_red_100 <- virtual_samples_100 %>% 
  group_by(replicate) %>% 
  summarize(red = sum(color == "red")) %>% 
  mutate(prop_red = red / 100) %>% 
  mutate(n = 100)

virtual_prop <- bind_rows(virtual_prop_red_25, 
                          virtual_prop_red_50, 
                          virtual_prop_red_100)

comparing_sampling_distributions <- ggplot(virtual_prop, aes(x = prop_red)) +
  geom_histogram(binwidth = 0.05, boundary = 0.4, color = "white") +
  labs(x = "Proportion of shovel's balls that are red", 
       title = "Comparing distributions of proportions red for three different shovel sizes.") +
  facet_wrap(~ n) 

if(knitr::is_latex_output()){
  comparing_sampling_distributions +
  theme(
    strip.text = element_text(colour = 'black'),
    strip.background = element_rect(fill = "grey93")
  )
} else {
  comparing_sampling_distributions
}



## ---- eval=FALSE--------------------------------------------------------------
## # n = 25
## virtual_prop_red_25 %>%
##   summarize(sd = sd(prop_red))
## 
## # n = 50
## virtual_prop_red_50 %>%
##   summarize(sd = sd(prop_red))
## 
## # n = 100
## virtual_prop_red_100 %>%
##   summarize(sd = sd(prop_red))


## ----comparing-n, eval=TRUE, echo=FALSE---------------------------------------
comparing_n_table <- virtual_prop %>% 
  group_by(n) %>% 
  summarize(sd = sd(prop_red)) %>% 
  rename(`Number of slots in shovel` = n, `Standard deviation of proportions red` = sd) 

comparing_n_table  %>% 
  kable(
    digits = 3,
    caption = "Comparing standard deviations of proportions red for three different shovels", 
    booktabs = TRUE,
    linesep = ""
  ) %>% 
  kable_styling(font_size = ifelse(knitr:::is_latex_output(), 10, 16),
                latex_options = c("hold_position"))










## ----comparing-sampling-distributions-1b, echo=FALSE, fig.cap="Previously seen three distributions of the sample proportion $\\widehat{p}$.", fig.height=3.1----
comparing_sampling_distributions


## ----comparing-n-repeat, eval=TRUE, echo=FALSE--------------------------------
comparing_n_table <- virtual_prop %>% 
  group_by(n) %>% 
  summarize(sd = sd(prop_red)) %>% 
  rename(`Number of slots in shovel` = n, `Standard deviation of proportions red` = sd) 

comparing_n_table  %>% 
  kable(
    digits = 3,
    caption = "Previously seen comparing standard deviations of proportions red for three different shovels", 
    booktabs = TRUE,
    linesep = ""
) %>% 
  kable_styling(font_size = ifelse(knitr:::is_latex_output(), 10, 16),
                latex_options = c("hold_position"))


## ----comparing-sampling-distributions-2, echo=FALSE, fig.cap="Three sampling distributions of the sample proportion $\\widehat{p}$."----
p_hat_compare <- virtual_prop %>% 
  mutate(
    n = str_c("n = ", n),
    n = factor(n, levels = c("n = 25", "n = 50", "n = 100"))
    ) %>% 
  ggplot( aes(x = prop_red)) +
  geom_histogram(binwidth = 0.05, boundary = 0.4, color = "white") +
  labs(x = expression(paste("Sample proportion ", hat(p))), 
       title = expression(paste("Sampling distributions of ", hat(p), " based on n = 25, 50, 100.")) ) +
  facet_wrap(~ n)

if(knitr::is_latex_output()){
  p_hat_compare  +
  theme(
    strip.text = element_text(colour = 'black'),
    strip.background = element_rect(fill = "grey93")
  )
} else {
  p_hat_compare
}



## ----comparing-n-2, eval=TRUE, echo=FALSE-------------------------------------
comparing_n_table <- virtual_prop %>% 
  group_by(n) %>% 
  summarize(sd = sd(prop_red)) %>% 
  mutate(
    n = str_c("n = ", n),
    n = factor(n, levels = c("n = 25", "n = 50", "n = 100"))
    ) %>% 
  rename(`Sample size (n)` = n, `Standard error of $\\widehat{p}$` = sd) 

comparing_n_table  %>% 
  kable(
    digits = 3,
    caption = "Standard errors of the sample proportion based on sample sizes of 25, 50, and 100", 
    booktabs = TRUE,
    escape = FALSE,
    linesep = ""
) %>% 
  kable_styling(font_size = ifelse(knitr:::is_latex_output(), 10, 16),
                latex_options = c("hold_position"))






## -----------------------------------------------------------------------------
bowl %>% 
  summarize(sum_red = sum(color == "red"), 
            sum_not_red = sum(color != "red"))


## ----comparing-sampling-distributions-3, echo=FALSE, fig.cap="Three sampling distributions with population proportion $p$ marked by vertical line."----
p <- bowl %>% 
  summarize(mean(color == "red")) %>% 
  pull()
samp_distn_compare <- virtual_prop %>% 
  mutate(
    n = str_c("n = ", n),
    n = factor(n, levels = c("n = 25", "n = 50", "n = 100"))
    ) %>% 
  ggplot(aes(x = prop_red)) +
  geom_histogram(binwidth = 0.05, boundary = 0.4, 
                 color = "black", fill = "white") +
  labs(x = expression(paste("Sample proportion ", hat(p))), 
       title = expression(paste("Sampling distributions of ", hat(p), 
                                " based on n = 25, 50, 100.")) ) +
  facet_wrap(~ n) +
  geom_vline(xintercept = p, col = "red", size = 1)

if(knitr::is_latex_output()){
  samp_distn_compare  +
  theme(
    strip.text = element_text(colour = 'black'),
    strip.background = element_rect(fill = "grey93")
  )
} else {
  samp_distn_compare
}






## ----comparing-n-3, eval=TRUE, echo=FALSE-------------------------------------
set.seed(76)
comparing_n_table <- virtual_prop %>% 
  group_by(n) %>% 
  summarize(sd = sd(prop_red)) %>% 
  mutate(
    n = str_c("n = ")
  ) %>% 
  rename(`Sample size` = n, `Standard error of $\\widehat{p}$` = sd) %>% 
  sample_frac(1)

comparing_n_table  %>% 
  kable(
    digits = 3,
    caption = "Standard errors of $\\widehat{p}$ based on n = 25, 50, 100", 
    booktabs = TRUE,
    escape = FALSE,
    linesep = ""
  ) %>% 
  kable_styling(font_size = ifelse(knitr:::is_latex_output(), 10, 16),
                latex_options = c("hold_position"))








## ----table-ch8, echo=FALSE, message=FALSE-------------------------------------
# The following Google Doc is published to CSV and loaded using read_csv():
# https://docs.google.com/spreadsheets/d/1QkOpnBGqOXGyJjwqx1T2O5G5D72wWGfWlPyufOgtkk4/edit#gid=0

if(!file.exists("rds/sampling_scenarios.rds")){
  sampling_scenarios <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vRd6bBgNwM3z-AJ7o4gZOiPAdPfbTp_V15HVHRmOH5Fc9w62yaG-fEKtjNUD2wOSa5IJkrDMaEBjRnA/pub?gid=0&single=true&output=csv" %>% 
    read_csv(na = "") %>% 
    slice(1:5)
    write_rds(sampling_scenarios, "rds/sampling_scenarios.rds")
} else {
  sampling_scenarios <- read_rds("rds/sampling_scenarios.rds")
}

sampling_scenarios %>% 
  kable(
    caption = "\\label{tab:summarytable-ch8}Scenarios of sampling for inference", 
    booktabs = TRUE,
    escape = FALSE,
    linesep = ""
  ) %>% 
  kable_styling(font_size = ifelse(knitr:::is_latex_output(), 10, 16),
                latex_options = c("hold_position")) %>%
  column_spec(1, width = "0.5in") %>% 
  column_spec(2, width = "1.2in") %>%
  column_spec(3, width = "0.8in") %>%
  column_spec(4, width = "1.5in") %>% 
  column_spec(5, width = "0.6in")




## ----echo=FALSE, results="asis"-----------------------------------------------
if(knitr::is_latex_output()){
  cat("Solutions to all *Learning checks* can be found online in [Appendix D](https://moderndive.com/D-appendixD.html).")
} 

