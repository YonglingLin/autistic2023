#############################################################################
# sensitivity analysis based on sample size (Method)
#############################################################################
pwr.r.test(n = 348, sig.level = 0.05, power = 0.80) # online 1  r= .150
pwr.r.test(n = 342, sig.level = 0.05, power = 0.80) # online 2  r= .151
pwr.r.test(n = 875, sig.level = 0.05, power = 0.80) # online 3  r= .095
pwr.r.test(n = 56,  sig.level = 0.05, power = 0.80) #  lab 1    r=.364



#############################################################################
# compute Cosine similarity (supplementary Fig.S6)
#############################################################################
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source('../2_ana/environPrepar.R',chdir = TRUE)
datapath='../3_ana_out'
today_tag <- format(Sys.Date(), "%Y%m%d")


# 1) Get the data from 3_ana_out folder
#----------------------------------------------------------------------------
Fulldata <- read.csv(file.path(dataath,'Fulldata_20261020.csv'), header =TRUE,sep=',')

AQ_subscales <- c(
  "AQ_Social_Skills", "AQ_Att_Switch", "AQ_Att_Detail", "AQ_Communication", "AQ_Imagination",
  "AQ_3FM_Social_Skills", "AQ_3FM_Detail", "AQ_3FM_Communication", "AQ_2FM_Social_Comm")

AQ_labels <- c(
  AQ_total             = "AQ total",
  AQ_Social_Skills     = "Social skills",
  AQ_Att_Switch        = "Attention switching",
  AQ_Att_Detail        = "Attention to detail",
  AQ_Communication     = "Communication",
  AQ_Imagination       = "Imagination",
  AQ_3FM_Social_Skills = "Social skills factor (3F)",
  AQ_3FM_Detail        = "Detail and pattern factor (3F)",
  AQ_3FM_Communication = "Communication and mindreading factor (3F)",
  AQ_2FM_Social_Comm   = "Social interaction factor (2F)"
)

AQ_scores <- list(
  Continuous = c(AQ_subscales, "AQ_total"),
  Binary     = c(sub("^AQ_", "AQbinary_", AQ_subscales), "AQbinary_total")
)

AQ_modes <- list(
  Lab    = dplyr::filter(Fulldata, mode == "lab"),
  Online = dplyr::filter(Fulldata, mode != "lab")
)

make_aq_cor <- function(data, variables) {
  # Fix: split the finite-value assignment from the validity check (previously a syntax error)
  has_variation <- function(var) {
    values <- data[[var]][is.finite(data[[var]])]
    length(values) > 1 && length(unique(values)) > 1
  }
  variables <- Filter(has_variation, variables)
  
  x <- data[, variables, drop = FALSE]
  r <- stats::cor(x, use = "pairwise.complete.obs")
  n <- crossprod(!is.na(x))
  t_stat <- r * sqrt((n - 2) / (1 - r^2))
  p <- 2 * stats::pt(-abs(t_stat), df = n - 2)
  p[n < 3] <- NA_real_
  diag(p) <- NA_real_
  
  labels <- unname(AQ_labels[sub("^AQbinary_", "AQ_", variables)])
  dimnames(r) <- dimnames(p) <- dimnames(n) <- list(labels, labels)
  list(r = r, p = p, n = n)
}

AQ_correlations <- list()
for (mode in names(AQ_modes)) {
  for (score in names(AQ_scores)) {key <- paste(mode, score, sep = "_")
    AQ_correlations[[key]] <- make_aq_cor(AQ_modes[[mode]], AQ_scores[[score]])
  }
}

## 2) Sfig.6BC: then calculate the cosine similarity between lab and online in two different scoring method.
cosine <- function(a, b) {
  labels <- intersect(rownames(a), rownames(b))
  a <- a[labels, labels]
  b <- b[labels, labels]
  a <- a[upper.tri(a)]
  b <- b[upper.tri(b)]
  ok <- is.finite(a) & is.finite(b)
  sum(a[ok] * b[ok]) / sqrt(sum(a[ok]^2) * sum(b[ok]^2))
}

AQ_cosine <- lapply(names(AQ_scores), function(score) {
  sim <- cosine(AQ_correlations[[paste("Lab", score, sep = "_")]]$r,
                AQ_correlations[[paste("Online", score, sep = "_")]]$r)
  matrix(c(1, sim, sim, 1), 2,
         dimnames = list(c("Lab", "Online"), c("Lab", "Online")))
})
names(AQ_cosine) <- names(AQ_scores)
print(AQ_cosine)



###############################################################################################
# stats-fig.S7: Compare cognitive- and affective-empathy correlations within each experiment.
###############################################################################################

experiments <- list("Online 1" = online1, "Online 2" = online2, "Online 3" = online3, "Lab" = lab)
for (experiment in names(experiments)) {
  for (predictor in c("AQ_total", "SRP_total")) {
    vars <- c(predictor, "QCAE_Cog_Empathy", "QCAE_Emotion_Empathy")
    data <- experiments[[experiment]]
    complete_data <- data[stats::complete.cases(data[, vars]), vars, drop = FALSE]
    correlations <- stats::cor(complete_data)
    
    cat("\n", experiment, " | ", predictor, " | N = ", nrow(complete_data), "\n", sep = "")
    cat(sprintf("r with cognitive empathy = %.3f\n", correlations[predictor, "QCAE_Cog_Empathy"]))
    cat(sprintf("r with affective empathy = %.3f\n", correlations[predictor, "QCAE_Emotion_Empathy"]))
    
    print(cocor::cocor.dep.groups.overlap(
      r.jk = correlations[predictor, "QCAE_Cog_Empathy"],
      r.jh = correlations[predictor, "QCAE_Emotion_Empathy"],
      r.kh = correlations["QCAE_Cog_Empathy", "QCAE_Emotion_Empathy"],
      n = nrow(complete_data), test = "pearson1898"
    ))
  }
}

###############################################################################################
# Fig.S10: calculate how many participants above AQ cutoff for each experiment
###############################################################################################
summary_data <- Fulldata %>%
  group_by(ver) %>% summarise(total = n(), above_count = sum(AQcutoff == 'aboveAQcutoff'),
                              percentage = round(100 * above_count / total, 1))
print(summary_data)
