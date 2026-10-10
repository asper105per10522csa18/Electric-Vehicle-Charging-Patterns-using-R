# EV Charging Energy Consumption Prediction (R Implementation)

A machine learning project in **R** comparing **Multiple Linear Regression** and **Random Forest Regression** to model electric vehicle energy consumption (`energy_consumed_kwh`).

---

## 📊 Model Comparison Results

| Evaluation Metric | Linear Regression | Random Forest Regression | Best Model |
| :--- | :---: | :---: | :--- |
| **Test RMSE** | 6.177 | **4.697** | **Random Forest (~24% error reduction)** |
| **Test MAE** | 4.164 | **2.730** | **Random Forest (~34% error reduction)** |
| **Test $R^2$** | 0.971 | **0.983** | **Random Forest (98.3% variance explained)** |
| **Top Influencing Factor** | Distance Since Last Charge | Distance Since Last Charge | Consistent across models |

![Model Comparison](figures/model_comparison.png)

---

## 🔍 Key Findings (Results & Discussion)
1. **Model Accuracy:** Random Forest outperformed Linear Regression, reducing test RMSE from **6.18** to **4.70** (~24% error reduction).
2. **Variance Explained:** Both models showed strong predictive power, with Random Forest achieving $R^2 = 0.98$ versus $0.97$ for Linear Regression.
3. **Dominant Feature:** `distance_since_last_charge_km` was the primary driver of total charging energy across both models.
4. **Boundary Fit:** Random Forest accurately captures the upper 110 kWh battery cutoff ceiling where Linear Regression exhibits scatter.
5. **Trade-off:** Random Forest offers superior predictive accuracy, while Linear Regression provides closed-form interpretability.

---

## 📁 Repository Structure

```
├── data/
│   └── ev_charging_demo_dataset.csv     # EV charging session dataset
├── scripts/
│   └── main_analysis.R                  # Complete R script (fitting, metrics & plots)
├── figures/
│   ├── model_comparison.png             # Side-by-side actual vs. predicted plot
│   ├── model_comparison_table.png       # Comparison table image
│   └── rf_actual_vs_predicted.png       # Random forest evaluation plot
├── .Rprofile                            # R environment settings
├── .gitignore                           # R-specific git ignore file
└── README.md                            # Project documentation
```

---

## 🚀 How to Run in R / RStudio

1. Clone or download this repository.
2. Open R or RStudio in the project root directory.
3. Run the complete analysis:
```r
source("scripts/main_analysis.R")
```

The script will automatically:
- Install and load required R packages (`randomForest`, `ggplot2`).
- Fit both models on the 80/20 train/test split.
- Print summaries, coefficients, importance, and metrics to the console.
- Save the comparison figure to `figures/model_comparison.png`.

---

## 📜 License
MIT License
