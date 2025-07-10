## LSE Data Analytics Online Career Accelerator 
# DA301:  Advanced Analytics for Organisational Impact

###############################################################################

# Assignment 5 scenario
## Turtle Games’s sales department has historically preferred to use R when performing 
## sales analyses due to existing workflow systems. As you’re able to perform data analysis 
## in R, you will perform exploratory data analysis and present your findings by utilising 
## basic statistics and plots. You'll explore and prepare the data set to analyse sales per 
## product. The sales department is hoping to use the findings of this exploratory analysis 
## to inform changes and improvements in the team. (Note that you will use basic summary 
## statistics in Module 5 and will continue to go into more detail with descriptive 
## statistics in Module 6.)

################################################################################

## Assignment 5 objective
## Load and wrangle the data. Use summary statistics and groupings if required to sense-check
## and gain insights into the data. Make sure to use different visualisations such as scatterplots, 
## histograms, and boxplots to learn more about the data set. Explore the data and comment on the 
## insights gained from your exploratory data analysis. For example, outliers, missing values, 
## and distribution of data. Also make sure to comment on initial patterns and distributions or 
## behaviour that may be of interest to the business.

################################################################################

# Module 5 assignment: Load, clean and wrangle data using R

## It is strongly advised that you use the cleaned version of the data set that you created and 
##  saved in the Python section of the course. Should you choose to redo the data cleaning in R, 
##  make sure to apply the same transformations as you will have to potentially compare the results.
##  (Note: Manual steps included dropping and renaming the columns as per the instructions in module 1.
##  Drop ‘language’ and ‘platform’ and rename ‘remuneration’ and ‘spending_score’) 

## 1. Open your RStudio and start setting up your R environment. 
## 2. Open a new R script and import the turtle_review.csv data file, which you can download from 
##      Assignment: Predicting future outcomes. (Note: You can use the clean version of the data 
##      you saved as csv in module 1, or, can manually drop and rename the columns as per the instructions 
##      in module 1. Drop ‘language’ and ‘platform’ and rename ‘remuneration’ and ‘spending_score’) 
## 3. Import all the required libraries for the analysis and view the data. 
## 4. Load and explore the data.
##    - View the head the data.
##    - Create a summary of the new data frame.
## 5. Perform exploratory data analysis by creating tables and visualisations to better understand 
##      groupings and different perspectives into customer behaviour and specifically how loyalty 
##      points are accumulated. Example questions could include:
##    - Can you comment on distributions, patterns or outliers based on the visual exploration of the data?
##    - Are there any insights based on the basic observations that may require further investigation?
##    - Are there any groupings that may be useful in gaining deeper insights into customer behaviour?
##    - Are there any specific patterns that you want to investigate
## 6. Create
##    - Create scatterplots, histograms, and boxplots to visually explore the loyalty_points data.
##    - Select appropriate visualisations to communicate relevant findings and insights to the business.
## 7. Note your observations and recommendations to the technical and business users.

###############################################################################
# Import tidyverse package.
library(tidyverse)

# Set the working directory
# Load clean data set
df1 <- read.csv('df1.csv', header = TRUE)

# View first lines of the data set imported.
head(df1)

# View the data set in new window.
View(df1)

# Determine the structure of the data set.
str(df1)

# Convert $product type to character
df1$product <- as.character(df1$product)

# Summary stats of the data set.
summary(df1)

# To search for missing values in a data set.
df1[is.na(df1)]
#Output: character(0)

# Find duplicate rows
duplicates <- df1[duplicated(df1), ]
duplicates
#Output:<0 rows> 

# drop unnecessary columns 'review' and 'summary'
df2 <- subset(df1, select = -c(review, summary))
View(df2)

#############################################################################
# Since analysis is about loyalty points' accumulation start with it.

# Distribution of loyalty_points. 
ggplot(df2, aes(y = loyalty_points)) +
  geom_boxplot(fill = "lightblue", color = "darkblue") +
  labs(title = "Distribution of Loyalty points", y = "Loyalty points") +
  theme_classic()
# Output: significant amount of outliers 

ggplot(df2, aes(x = loyalty_points)) +
  geom_histogram( fill = "lightblue", color = "darkblue", alpha = 0.7) +
  labs(title = "Distribution of loyalty_points", x = "loyalty_points", y = "Frequency") +
  theme_classic()
# Output: long right skew outliers

##############################

# hence the VIEW WAS TAKEN to establish the number of extreme outliers 
#and perhaps split df2 into two data frames.

##############################

# Determine upper threshold for loyalty points outliers.
# Calculate the IQR for loyalty points.
Q1 <- quantile(df2$loyalty_points, 0.25)
Q3 <- quantile(df2$loyalty_points, 0.75)
IQR <- Q3 - Q1

# Define the outlier thresholds, more importantly the upper one.
lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR
upper_bound
# Output: extreme outliers are above count of 3220 of loyalty points

# Create separate df for extreme outliers 
#(loyalty points above the upper bound of 3220 only)
outliers_loyalty_points <- df2[df2$loyalty_points > upper_bound, ]
outliers_loyalty_points

# Create the data frame for typical loyalty point holders, 
#( equal and below the upper bound of 3200).
typical_loyalty_points <- df2[df2$loyalty_points <= upper_bound, ]

dim(df2)
#Output 2000 out of 2000 customers (100%)
dim(outliers_loyalty_points)
#Output 266 out of 2000 customers (13.3%)
dim(typical_loyalty_points)
#Output 1734 out of 2000 customers (86.7%)

##############################

# FURTHER EDA will be carried out on three data frames separately.
#plots for df2 in 'skyblue'
#plots for typical_loyalty_points in 'pink'
#plots for outliers_loyalty_points in 'red'

##############################

# LOYALTY POINTS distribution in split df2:
#1.
ggplot(typical_loyalty_points, aes(x = loyalty_points)) +
  geom_histogram( fill = "pink", color = "black", alpha = 0.7) +
  labs(title = "Distribution of typical_loyalty_points", 
       x = "loyalty_points", y = "Frequency") +
  theme_classic()
#2.
ggplot(outliers_loyalty_points, aes(x = loyalty_points)) +
  geom_histogram( fill = "red", color = "black", alpha = 0.7) +
  labs(title = "Distribution of outliers_loyalty_points", 
       x = "loyalty_points", y = "Frequency") +
  theme_classic()

# OUTPUT: loyalty points distribution in both subsets of divided df2 is more symmetrical 
#and albeit still right skewed and majority of loyalty points are at the lower end 
#of each range, the skew is smaller.

#######
# GENDER distribution:
#1.
ggplot(df2, aes(x=gender)) +
  geom_histogram(fill = 'skyblue', colour= 'darkblue', stat="count") +
  labs(x='Gender',
       y='Number of Individuals',
       title = 'Customers by Gender')
#2.
ggplot(typical_loyalty_points, aes(x=gender)) +
  geom_histogram(fill = 'pink', colour= 'black', stat="count") +
  labs(x='Gender',
       y='Number of Individuals',
       title = 'Customers by Gender in typical_loyalty_points')

#3.
ggplot(outliers_loyalty_points, aes(x=gender)) +
  geom_histogram(fill = 'red', colour= 'black', stat="count") +
  labs(x='Gender',
       y='Number of Individuals',
       title = 'Customers by Gender in outliers_loyalty_points')

#Output: Slightly more female customers than male in all three

######
# Age distribution:
#1.
ggplot(df2, aes(x=age)) +
  geom_histogram(fill = 'skyblue', colour= 'darkblue', stat="count") +
  labs(x='Age',
       y='Number of Individuals',
       title = 'Customers by Age group')
#2.
ggplot(typical_loyalty_points, aes(x = age)) +
  geom_histogram( fill = "pink", color = "black", alpha = 0.7) +
  labs(title = "Distribution of Age for typical_loyalty_points", 
       x = "age", y = "Frequency") +
  theme_classic()

#3.
ggplot(outliers_loyalty_points, aes(x = age)) +
  geom_histogram( fill = "red", color = "black", alpha = 0.7) +
  labs(title = "Distribution of Age for outliers_loyalty_points", 
       x = "age", y = "Frequency") +
  theme_classic()

# Output: in typical loyalty points holder df age is mimicing wider range of 
#mostly between 25 and 50, and in the outliers one concentrating firmer around 30-40.

#######
# Distribution of remuneration. 
# 1.
ggplot(df2, aes(x = remuneration)) +
  geom_histogram( fill = "lightblue", color = "darkblue") +
  labs(title = "Distribution of Remuneration", x = "Remuneration", y = "Frequency") +
  theme_classic()

# Any outliers?
ggplot(df2, aes(y = remuneration)) +
  geom_boxplot(fill = "lightblue", color = "darkblue") +
  labs(title = "Distribution of Remuneration", y = "Remuneration") +
  theme_classic()

median(df2$remuneration)
# Output: [1] 47.15

#2.
ggplot(typical_loyalty_points, aes(x = remuneration)) +
  geom_histogram( fill = "pink", color = "black", alpha = 0.7) +
  labs(title = "Distribution of Remuneration for typical_loyalty_points", 
       x = "remuneration", y = "Frequency") +
  theme_classic()

# Any outliers?
ggplot(typical_loyalty_points, aes(y = remuneration)) +
  geom_boxplot(fill = "pink", color = "black") +
  labs(title = "Distribution of Remuneration in typical_loyalty_points", y = "Remuneration") +
  theme_classic()

median(typical_loyalty_points$remuneration)
# Output:[1] 44.28

#3.
ggplot(outliers_loyalty_points, aes(x = remuneration)) +
  geom_histogram( fill = "red", color = "black", alpha = 0.7) +
  labs(title = "Distribution of Remuneration for outliers_loyalty_points", 
       x = "remuneration", y = "Frequency") +
  theme_classic()

# Any outliers?
ggplot(outliers_loyalty_points, aes(y = remuneration)) +
  geom_boxplot(fill = "red", color = "black") +
  labs(title = "Distribution of Remuneration in outliers_loyalty_points", y = "Remuneration") +
  theme_classic()

median(outliers_loyalty_points$remuneration)
# Output: [1] 72.16

#Output:
# No extreme outliers except two data points in  typical_loyalty points 
# Medians of income are 47.15K for df, 44.28K for typical loyalty points holders df 
#and 72.16K for the outliers. Suggesting more balanced view of data after the split.

#######

# Distribution of spending score :
#1.
ggplot(df2, aes(x = spending_score)) +
  geom_density(fill = 'lightblue', bw = 5) +
  labs(title = "Distribution of Spending score")

#2.
ggplot(typical_loyalty_points, aes(x = spending_score)) +
  geom_density(fill = 'pink', bw = 5) +
  labs(title = "Distribution of Spending score for typical_loyalty_points")

#3.
ggplot(outliers_loyalty_points, aes(x = spending_score)) +
  geom_density(fill = 'red', bw = 5) +
  labs(title = "Distribution Spending Score for outliers_loyalty_points")

# Output:
# The distribution is symmetric in df2 and mimics it in typical loyalty points holders one, 
#ranging from 1 to 99, due to predefined limits, however it is left skewed and 
#mostly around 85-95 range in the outliers one.

########

# Distribution of education.
#1.
ggplot(df2, aes(x=education)) +
  geom_histogram(fill ='skyblue', colour= 'darkblue', stat="count") +
  labs(x='Education level',
       y='Number of Individuals',
       title = 'Customers by Education level')+
  theme_classic()

#2.
ggplot(typical_loyalty_points, aes(x = education)) +
  geom_histogram( fill = "pink", color = "black", stat="count") +
  labs(x='Education level',
       y='Number of Individuals',
       title = 'Customers by Education level for typical_loyalty_points') +
  theme_classic()

#3.
ggplot(outliers_loyalty_points, aes(x = education)) +
  geom_histogram( fill = "red", color = "black", stat="count") +
  labs(x='Education level',
       y='Number of Individuals',
       title = 'Customers by Education level for outliers_loyalty_points') +
  theme_classic()

#Output: The same pattern of level of education in all three df. 
#Customers are well educated

######
# Distribution of products + products' frequancy:
#1.
ggplot(df2, aes(x=product)) +
  geom_histogram(fill ='skyblue', colour= 'darkblue', stat="count") +
  labs(x='Products',
       y='Number of products',
       title = 'Distribution of Products')+
  theme_classic()

# Count unique values in the product column
unique_products <- unique(df2$product)
num_unique_products <- length(unique_products)
# Output the number of unique products
num_unique_products

#Count the frequency of each product
product_frequency <- table(df2$product)
# Output the frequency of each product
product_frequency

#2.
ggplot(typical_loyalty_points, aes(x=product)) +
  geom_histogram(fill = 'pink', colour= 'black', stat="count") +
  labs(x='Products',
       y='Number of products',
       title = 'Distribution of Products for typical_loyalty_points')+
  theme_classic()

# Count unique values in the product column
unique_products_typical_lp <- unique(typical_loyalty_points$product)
num_unique_products_typical_lp <- length(unique_products_typical_lp)
# Output the number of unique products
num_unique_products_typical_lp

#Count the frequency of each product
product_frequency_typical_lp <- table(typical_loyalty_points$product)
# Output the frequency of each product
product_frequency_typical_lp

#3.
ggplot(outliers_loyalty_points, aes(x=product)) +
  geom_histogram(fill = 'red', colour= 'black', stat="count") +
  labs(x='Products',
       y='Number of products',
       title = 'Distribution of Products for outliers_loyalty_points')+
  theme_classic()

# Count unique values in the product column
unique_products_outliers_lp <- unique(outliers_loyalty_points$product)
num_unique_products_outliers_lp <- length(unique_products_outliers_lp)
# Output the number of unique products
num_unique_products_outliers_lp

#Count the frequency of each product
product_frequency_outliers_lp <- table(outliers_loyalty_points$product)
# Output the frequency of each product
product_frequency_outliers_lp

#Output: as a group outliers’ loyalty points holders buy from lesser variety of products 
#(108 from 200, also may be due to the size of the sample) but may be buying more 
# expensive items (hence they have higher spending_score and higher count of loyalty points)

###############################################################################

# Investigate relationships between loyalty_points and other variables 
# to discover what factors impact accumulation of loyalty points.

###############################################################################

# Correlation analysis.

# Select the numerical columns for correlation analysis.
numeric_data <- df2[, c("age", "remuneration", "spending_score", "loyalty_points")]
numeric_data_typical_lp <- typical_loyalty_points[, c("age", "remuneration", "spending_score", "loyalty_points")]
numeric_data_outliers_lp <- outliers_loyalty_points[, c("age", "remuneration", "spending_score", "loyalty_points")]

# Compute the correlation matrix
cor_matrix <- cor(numeric_data, use = "complete.obs")
cor_matrix_typical_lp <- cor(numeric_data_typical_lp, use = "complete.obs")
cor_matrix_outliers_lp <- cor(numeric_data_outliers_lp, use = "complete.obs")

# Display the correlation matrix
cor_matrix
cor_matrix_typical_lp
cor_matrix_outliers_lp

#Output: The impact to loyalty points from the most contributing features is 
#different in each data set:
#df2:spending score (0.672) and remuneration (0.616) strongly contribute, while age (-0.042) is insignificant.
#typical_lp: spending score (0.548) and remuneration (0.408) still strong, with age (0.043) contributing slightly.
#outliers_lp: remuneration(0.789) is the driver with spending score(0.243) and age(0.192)contributing moderately.

# However the latter one is very small dataset and should be approached cautiously. 

##########################################

# ONLY the df2 and typical_loyalty_points will be explored further

##########################################

# Create a scatter plot of spending_score vs loyalty_points
#1.
ggplot(df2, aes(x = spending_score, y = loyalty_points)) +
  geom_point(color = "skyblue") + 
  labs(title = "Spending Score vs Loyalty Points", 
       x = "Spending Score", 
       y = "Loyalty Points") +
  theme_classic()

#2.
ggplot(typical_loyalty_points, aes(x = spending_score, y = loyalty_points)) +
  geom_point(color = "pink") + 
  labs(title = "Spending Score vs Loyalty Points for typical_loyalty_points", 
       x = "Spending Score", 
       y = "Loyalty Points") +
  theme_classic()

#Output: both scatterplots suggest linearity

######

# Create a scatter plot of remuneration vs loyalty_points
#1.
ggplot(df2, aes(x = remuneration, y = loyalty_points)) +
  geom_point(color = "skyblue") + 
  labs(title = "Remuneration vs Loyalty Points", 
       x = "Remuneration", 
       y = "Loyalty Points") +
  theme_classic()

#2.
ggplot(typical_loyalty_points, aes(x = remuneration, y = loyalty_points)) +
  geom_point(color = "pink") + 
  labs(title = "Remuneration vs Loyalty Points for typical_loyalty_points", 
       x = "Remuneration", 
       y = "Loyalty Points") +
  theme_classic()

#Output: both scatterplots suggest linearity

######
# Create a scatter plot of age vs loyalty_points
#1.
ggplot(df2, aes(x = age, y = loyalty_points)) +
  geom_point(color = "skyblue") + 
  labs(title = "Age vs Loyalty Points", 
       x = "Age", 
       y = "Loyalty Points") +
  theme_classic()

#2.
ggplot(typical_loyalty_points, aes(x = age, y = loyalty_points)) +
  geom_point(color = "pink") + 
  labs(title = "Age vs Loyalty Points for typical_loyalty_points", 
       x = "Age", 
       y = "Loyalty Points") +
  theme_classic()

#Output: both scatterplots do not suggest linearity

###############################################################################
###############################################################################

# Assignment 6 scenario

## In Module 5, you were requested to redo components of the analysis using Turtle Games’s preferred 
## language, R, in order to make it easier for them to implement your analysis internally. As a final 
## task the team asked you to perform a statistical analysis and create a multiple linear regression 
## model using R to predict loyalty points using the available features in a multiple linear model. 
## They did not prescribe which features to use and you can therefore use insights from previous modules 
## as well as your statistical analysis to make recommendations regarding suitability of this model type,
## the specifics of the model you created and alternative solutions. As a final task they also requested 
## your observations and recommendations regarding the current loyalty programme and how this could be 
## improved. 

################################################################################

## Assignment 6 objective
## You need to investigate customer behaviour and the effectiveness of the current loyalty program based 
## on the work completed in modules 1-5 as well as the statistical analysis and modelling efforts of module 6.
##  - Can we predict loyalty points given the existing features using a relatively simple MLR model?
##  - Do you have confidence in the model results (Goodness of fit evaluation)
##  - Where should the business focus their marketing efforts?
##  - How could the loyalty program be improved?
##  - How could the analysis be improved?

################################################################################

## Assignment 6 assignment: Making recommendations to the business.

## 1. Continue with your R script in RStudio from Assignment Activity 5: Cleaning, manipulating, and 
##     visualising the data.
## 2. Load and explore the data, and continue to use the data frame you prepared in Module 5.
## 3. Perform a statistical analysis and comment on the descriptive statistics in the context of the 
##     review of how customers accumulate loyalty points.
##  - Comment on distributions and patterns observed in the data.
##  - Determine and justify the features to be used in a multiple linear regression model and potential
##.    concerns and corrective actions.
## 4. Create a Multiple linear regression model using your selected (numeric) features.
##  - Evaluate the goodness of fit and interpret the model summary statistics.
##  - Create a visual demonstration of the model
##  - Comment on the usefulness of the model, potential improvements and alternate suggestions that could 
##     be considered.
##  - Demonstrate how the model could be used to predict given specific scenarios. (You can create your own 
##     scenarios).
## 5. Perform exploratory data analysis by using statistical analysis methods and comment on the descriptive 
##     statistics in the context of the review of how customers accumulate loyalty points.
## 6. Document your observations, interpretations, and suggestions based on each of the models created in 
##     your notebook. (This will serve as input to your summary and final submission at the end of the course.)

################################################################################

# Based on the above as well as previous EDA on Python for MLR model will use: 
# 1. Model1 - data set (df3) that has outliers removed  
# 2. Model2 - full data set (df2_1)
# 3. for both the most contributing to loyalty_points features 
#'spending_score', 'remuneration', and 'age'. 

# Import the psych package.
library(psych)

# For modeling create subset of numerical columns 
# from typical_loyalty_points data frame (df3)  and from full data set (df2_1)
df2_1 <- subset(df2, select = -c(gender, education, product))
df3 <- subset(typical_loyalty_points, select = -c(gender, education, product))

#Explore data set
head(df3)
summary(df3)
dim(df3)

# Plot crelation with corPlot() function.
corPlot(df2_1, cex=1)
corPlot(df3, cex=1)

##
# Better visual of the above corelation matrix.
#Install and load the corrplot package.
install.packages("corrplot")
library(corrplot)

# Compute the correlation matrix
cor_matrix <- cor(df2_1)

# Plot the correlation matrix without numbers, just with color scale.
corrplot(cor_matrix, 
         method = "color",   # Use color method
         addCoef.col = NULL, # No numeric display
         col = colorRampPalette(c("red", "white", "blue"))(200),  # Color scale from red to blue
         title = "Correlation Matrix")
##

# Create a new object, specify the lm function and the variables.
model1 = lm(loyalty_points~age+remuneration+spending_score, data=df3)
# Print the summary statistics.
summary(model1)

# Create a new object, specify the lm function and the variables.
model2 = lm(loyalty_points~age+remuneration+spending_score, data=df2_1)
# Print the summary statistics.
summary(model2)


# OBSERVATION

#model2, which includes all data points (including outliers), 
#seems to be the better model overall. It explains more variance in the dependent variable 
#(higher R-squared 0.8399 and Adjusted R-squared 0.8397 ), even though it has 
#a higher residual standard error(513.8). 
#The larger sample size contributes to a more reliable and generalizable model.
#model1 might give the illusion of a better fit due to its lower 
#residual standard error (358.3) and the removal of outliers. However, 
#this could be a result of overfitting to a smaller data set and the model might 
#not generalize as well to new data, especially with outliers in the population.

# Visualising models' accuracy. 

#Model2 - full data set
# Plot actual vs. predicted values with a different smoothing method if necessary
ggplot(df2_1, aes(x = loyalty_points, y = predict(model2, df2_1))) +
  geom_point() +
  stat_smooth(method = "loess") +  # You can change 'loess' to 'lm' or other methods
  labs(x = 'Actual Loyalty points', y = 'Predicted Loyalty points') +
  ggtitle('Actual vs. Predicted Loyalty points entire data set')

#Model1 - data set with removed outliers from loyalty points
# Plot actual vs. predicted values with a different smoothing method if necessary
ggplot(df3, aes(x = loyalty_points, y = predict(model1, df3))) +
  geom_point() +
  stat_smooth(method = "loess") +  # You can change 'loess' to 'lm' or other methods
  labs(x = 'Actual Loyalty points', y = 'Predicted Loyalty points') +
  ggtitle('Actual vs. Predicted Loyalty with outliers removed')

# Output: both plots shows most of the data points fairly close to diagonal line 
#indicating that predictions are quite accurate. As expected Model 2 performs slighly better

###############################################################################
###############################################################################

#test model2 - the stronger one - on hidden outliers data set

outliers <- subset(outliers_loyalty_points, select = -c(gender, education, product))

ggplot(outliers, aes(x = loyalty_points, y = predict(model2, outliers))) +
  geom_point() +
  stat_smooth(method = "lm") +  # You can change 'loess' to 'lm' or other methods
  labs(x = 'Actual Loyalty points', y = 'Predicted Loyalty points') +
  ggtitle('Model2 Actual vs. Predicted Loyalty points test on unseen outliers')

