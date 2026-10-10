# Electric Vehicle Charging Patterns - R Mini Project
# NOTE: Inspect names(ev) after loading the original Kaggle CSV and adapt column names if needed.
# This script is designed for the included demonstration CSV.

ev <- read.csv("ev_charging_demo_dataset.csv", stringsAsFactors = FALSE)
str(ev)
summary(ev)
head(ev)

# Q1: Data quality and objectives
cat("Rows:", nrow(ev), " Columns:", ncol(ev), "\n")
cat("Missing values by column:\n")
print(colSums(is.na(ev)))
cat("Duplicate rows:", sum(duplicated(ev)), "\n")

# Q2: Clean data; data.frame, vectors, factors, lists, loop and functions
ev <- ev[!duplicated(ev), ]
numeric_cols <- names(ev)[sapply(ev, is.numeric)]
for (nm in numeric_cols) {
  ev[[nm]][is.na(ev[[nm]])] <- median(ev[[nm]], na.rm = TRUE)
}
ev$charging_start_time <- as.POSIXct(ev$charging_start_time, tz = "UTC")
ev$hour <- as.integer(format(ev$charging_start_time, "%H"))
ev$time_of_day <- cut(ev$hour, breaks = c(-1,5,11,16,23),
                      labels = c("Night","Morning","Afternoon","Evening"))
metric_rmse <- function(actual, predicted) sqrt(mean((actual-predicted)^2))
metric_r2 <- function(actual, predicted) 1 - sum((actual-predicted)^2) /
  sum((actual-mean(actual))^2)

# Q3: Statistical analysis
print(summary(ev$energy_consumed_kwh))
print(aggregate(energy_consumed_kwh ~ charger_type, ev, mean))
print(aggregate(energy_consumed_kwh ~ hour, ev, mean))
numeric_cols <- names(ev)[sapply(ev, is.numeric)]
print(round(cor(ev[, numeric_cols], use = "pairwise.complete.obs"), 2))
boxplot(ev$energy_consumed_kwh, main = "Energy consumed per session", ylab = "kWh")
barplot(aggregate(energy_consumed_kwh ~ charger_type, ev, mean)$energy_consumed_kwh,
        names.arg = aggregate(energy_consumed_kwh ~ charger_type, ev, mean)$charger_type,
        main = "Mean energy by charger type", ylab = "kWh")

# Q4/Q5: 80/20 split, regression and evaluation
set.seed(42)
train_id <- sample(seq_len(nrow(ev)), size = floor(0.8*nrow(ev)))
train <- ev[train_id, ]
test <- ev[-train_id, ]

fit_lm <- lm(energy_consumed_kwh ~ charging_duration_hours + charging_rate_kw +
               battery_capacity_kwh + soc_start_pct + temperature_c +
               vehicle_age_years, data = train)
pred_lm <- predict(fit_lm, newdata = test)

# Optional Random Forest
if (!requireNamespace("randomForest", quietly = TRUE)) {
  install.packages("randomForest")
}
fit_rf <- randomForest::randomForest(
  energy_consumed_kwh ~ charging_duration_hours + charging_rate_kw +
    battery_capacity_kwh + soc_start_pct + temperature_c + vehicle_age_years,
  data = train, ntree = 200)
pred_rf <- predict(fit_rf, newdata = test)

metrics <- data.frame(
  Model = c("Linear Regression", "Random Forest"),
  R2 = c(metric_r2(test$energy_consumed_kwh, pred_lm),
         metric_r2(test$energy_consumed_kwh, pred_rf)),
  RMSE_kWh = c(metric_rmse(test$energy_consumed_kwh, pred_lm),
               metric_rmse(test$energy_consumed_kwh, pred_rf))
)
print(metrics)
write.csv(metrics, "model_metrics.csv", row.names = FALSE)

plot(test$energy_consumed_kwh, pred_rf,
     xlab = "Actual energy (kWh)", ylab = "Predicted energy (kWh)",
     main = "Random Forest: Actual vs Predicted")
abline(0, 1, lty = 2, col = "blue")

# Reproducibility note:
# For final submission, use the original public dataset, inspect its actual column names,
# adapt the formula, and regenerate every reported metric and chart.
