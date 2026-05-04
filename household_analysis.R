# Libraries
library(tidyverse)
library(janitor)

# Load Data
household <- read.csv("household.csv")

# Initial Exploration
dim(household)
head(household)
names(household)

unique(household$Income..consumption.and.savings)

# Filter key variables
disposable_income <- household %>%
  filter(Income..consumption.and.savings == "Household disposable income",
         Characteristics == "All households",
         GEO == "Canada")

consumption <- household %>%
  filter(Income..consumption.and.savings == "Household final consumption expenditure (HFCE)",
         Characteristics == "All households",
         GEO == "Canada")

net_saving <- household %>%
  filter(Income..consumption.and.savings == "Household net saving",
         Characteristics == "All households",
         GEO == "Canada")

# Check Date Range
range(disposable_income$REF_DATE)

# Filter Results
disposable_income <- disposable_income %>%
  filter(Statistics == "Value")

consumption <- consumption %>%
  filter(Statistics == "Value")

net_saving <- net_saving %>%
  filter(Statistics == "Value")

# Verify Filter Results
dim(disposable_income)
dim(consumption)
dim(net_saving)

# Period labels for pre/post 2008 analysis
disposable_income <- disposable_income %>%
  mutate(period = ifelse(REF_DATE <= 2008, "Pre-2008", "Post-2008"))

# Check the split
table(disposable_income$period)

consumption <- consumption %>%
  mutate(period = ifelse(REF_DATE <= 2008, "Pre-2008", "Post-2008"))

net_saving <- net_saving %>%
  mutate(period = ifelse(REF_DATE <= 2008, "Pre-2008", "Post-2008"))

#Descriptive statistics
summary(disposable_income$VALUE)


# NOTE: Dataset changed from SFS 2019 to Statistics Canada Household 
# Economic Accounts (36-10-0588-01) based on instructor feedback 
# to use a more current dataset. Visualizations below reflect the new dataset.

# VISUALIZATIONS 

# 1. Time Series - Disposable Income Over Time
ggplot(disposable_income, aes(x = REF_DATE, y = VALUE)) +
  geom_line(color = "blue", linewidth = 1.2) +
  geom_point(color = "yellow", size = 2) +
  scale_y_continuous(labels = scales::comma) +
  labs(
    title = "Canadian Household Disposable Income Over Time",
    subtitle = "1999 to 2025 | Statistics Canada",
    x = "Year",
    y = "Value (Millions of Dollars)"
  ) +
  theme_minimal()

# 2. Boxplot - Pre vs Post 2008
ggplot(disposable_income, aes(x = period, y = VALUE, fill = period)) +
  geom_boxplot() +
  scale_y_continuous(labels = scales::comma) +
  labs(
    title = "Household Disposable Income: Pre vs Post 2008",
    subtitle = "Statistics Canada | Household Economic Accounts",
    x = "Period",
    y = "Value (Millions of Dollars)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

# 3. Histogram - Distribution of Disposable Income
ggplot(disposable_income, aes(x = VALUE)) +
  geom_histogram(bins = 10, fill = "#3A86FF", color = "white") +
  scale_x_continuous(labels = scales::comma) +
  labs(
    title = "Distribution of Household Disposable Income",
    subtitle = "1999 to 2025 | Statistics Canada",
    x = "Value (Millions of Dollars)",
    y = "Frequency"
  ) +
  theme_minimal()

# 4. QQ Plot - Check Normality
qqnorm(disposable_income$VALUE, main = "QQ Plot - Household Disposable Income")
qqline(disposable_income$VALUE, col = "orange", lwd = 2)

# 5. Scatterplot - Income vs Consumption (Correlation)
combined <- data.frame(
  year = disposable_income$REF_DATE,
  income = disposable_income$VALUE,
  consumption = consumption$VALUE
)

ggplot(combined, aes(x = income, y = consumption)) +
  geom_point(color = "red", size = 2.5) +
  geom_smooth(method = "lm", color = "green", se = TRUE) +
  scale_x_continuous(labels = scales::comma) +
  scale_y_continuous(labels = scales::comma) +
  labs(
    title = "Household Disposable Income vs Final Consumption",
    subtitle = "1999 to 2025 | Statistics Canada",
    x = "Disposable Income (Millions $)",
    y = "Final Consumption (Millions $)"
  ) +
  theme_minimal()


#Final Project 2 Assignment

#Hypothesis Testing

# 1. ONE SAMPLE T-TEST
# Question: Is average household disposable income significantly different from $900,000 million?
t.test(disposable_income$VALUE, mu = 900000)

ggplot(disposable_income, aes(x = VALUE)) +
  geom_histogram(bins = 10, fill = "blue", color = "white") +
  geom_vline(xintercept = 900000, color = "red", 
             linewidth = 1.2, linetype = "dashed") +
  scale_x_continuous(labels = scales::comma) +
  annotate("text", x = 900000, y = 3.8, 
           label = "Benchmark\n$900,000M", 
           color = "black", hjust = -0.1) +
  labs(
    title = "Disposable Income vs Benchmark of $900,000 Million",
    subtitle = "Red line shows the benchmark used in one sample t-test",
    x = "Value (Millions of Dollars)",
    y = "Frequency"
  ) +
  theme_minimal()


# 2. TWO INDEPENDENT SAMPLES T-TEST
# Question: Is disposable income significantly different between pre-2008 and post-2008?
pre <- disposable_income %>% filter(period == "Pre-2008") %>% pull(VALUE)
post <- disposable_income %>% filter(period == "Post-2008") %>% pull(VALUE)
t.test(pre, post)


# 3. MATCHED PAIRS T-TEST
# Question: Is there a significant difference between disposable income and consumption across the same years?
t.test(disposable_income$VALUE, consumption$VALUE, paired = TRUE)

ggplot(combined, aes(x = year)) +
  geom_line(aes(y = income, color = "Disposable Income"), 
            linewidth = 1.2) +
  geom_line(aes(y = consumption, color = "Final Consumption"), 
            linewidth = 1.2, linetype = "dashed") +
  scale_y_continuous(labels = scales::comma) +
  scale_color_manual(values = c("Disposable Income" = "orange", 
                                "Final Consumption" = "green")) +
  labs(
    title = "Disposable Income vs Final Consumption Over Time",
    subtitle = "Used in matched pairs t-test | Statistics Canada",
    x = "Year",
    y = "Value (Millions of Dollars)",
    color = "Measure"
  ) +
  theme_minimal()


# 4. CORRELATION TEST
# Question: Is there a significant linear relationship between disposable income and consumption?
cor.test(combined$income, combined$consumption)

# 5. F-TEST (Variance)
# Question: Is the variance in disposable income significantly different between pre and post 2008?
var.test(pre, post)
