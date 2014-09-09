---

# CMSC 498O: Some Basic Stat/ML Algorithms

<img src="multimedia/scikit-learn.png" height=350>

---

## Some resources

- Wikipedia
- [A tour of ML algorithms](http://machinelearningmastery.com/a-tour-of-machine-learning-algorithms/)
- [Scikit-Learn User Guide](http://scikit-learn.org/stable/user_guide.html)

---

## Overview

- Statistical models vs machine learning algorithms
    - Used somewhat interchangeably
- Goal of ML algorithms is typically to predict, to classify, or to cluster
    - A sample of the data is typically provided to use for *learning* or *modelling*
- Some key terms:
    - **Training vs testing datasets**
        - Use the former to learn, the latter to test the learned model
    - **Supervised vs Unsupervised Learning**
        - In the former, we are provided with additional attributes that we want to predict/classify 
            - Classification: e.g., handwritten digit recognition 
            - Regression: e.g., predicting stock prices
        - In the latter, the goal is to deduce structure in the provided unlabelled data 
            - Clustering: e.g., group customers based on their buying patterns
            - Association rule mining: e.g., if you buy *A*, you are likely to buy *B*
            - Dimensionality reduction: project the data onto a few dimensions to make it simpler to visualize/classify etc.
        - Semi-supervised Learning: a combination of labelled and unlabelled data
    - **Feature Selection**: 
        - Selecting a subset of all possible features to use 
        - Most data contain too many features, most of which are redundant 
    - **Regularization**:
        - Simplifying solutions produced by a technique by penalizing complexity
    - **Overfitting**:
        - Learned model starts capturing the random error or noise instead of the underlying relationship
        - Typically happens when model is too complex (e.g., too many parameters given the data)
- A key challenge for a data scientist: 
    - Choosing which method/algorithm to use for a specific task

---

## Linear Regression

- Goal: to predict the value of a *dependent* (or response, or outcome) variable using one or more *independent* (or explanatory) variables
- Captures the relationship using a linear equation

<img src="multimedia/regression1.png" height=300>

<img src="multimedia/regression2.png" height=300>

<img src="multimedia/regression3.png" height=300>

---

## Linear Regression

- How to find the best fit?
    - Ordinary least squares: minimize the squared distance from the line
    - Ridge regression: add a penalty term for the sizes of the coefficients

<img src="multimedia/regression4.png" height=300>

<img src="multimedia/regression5.png" height=300>

---

## Linear Regression

- Goodness of fit: 
    - p-values: Can be used to test the null hypothesis that an independent variable has a significant effect on the dependent variable
        - Does not say anything about goodness-of-fit
    - R<sup>2</sup>: Ratio of mean squared error and total error
        - Interpreted as: the proportion of variance in the data explained by the model
        - = 1.0 --> perfect fit
        - = 0.0 --> no relationship
    - Use as one tool to assess the goodness of fit, but overreliance (as with most such things) is a bad idea
        - Hard to get good R<sup>2</sup> values for many domains (e.g., human behavior)
        - A very good value may still be a bad fit
    - Example from [http://blog.minitab.com](http://blog.minitab.com/blog/adventures-in-statistics/regression-analysis-how-do-i-interpret-r-squared-and-assess-the-goodness-of-fit)
        - Residual plot shows systematic bias -- would prefer to see random noise around the fitted line

<img src="multimedia/regression6.gif" height=300>

<img src="multimedia/regression7.gif" height=300>

--- 

## Classification

- One of the most common ML tasks
- Examples: spam vs non-spam emails; diagnostics; high risk vs low risk customers (for loans); ...
- Typical problem setting: 
    - Given a set of features (also called independent variables), and a set of samples (training data) along with labels (dependent variable) for those samples,
    - Learn a model to use for future data points
    - Labels are categorical, not numerical
- For numerical features, visualizing can often suggest how to classify

<img src="multimedia/classification1.png" height=300>

<br> <br> <br>

<img src="multimedia/classification2.png" height=300>

<br> <br> <br>

<img src="multimedia/classification3.png" height=300>

---

## Clustering

--- 
