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

## Linear Regression

- Transformations
    - The *linearity* assumption is only about the parameters
    - We can take arbitrary transformations of the independent variables themselves
    - The following is a linear regression
        - r is the response variable, x, y, z, are the independent variables
        - r = c_1 x^2 + c_2 x + c_3 + c_4 y^3 + c_5 log(z) + c_6 x * y + c_7 x * y^2 * log(z)
- Assumption of independence
    - Things break down if the predictor variables are not independent, or if the errors are not independent

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

## Classification: Decision Trees

- Very intuitive and easy-to-use classification models
    - Works for categorical and numerical features
- Many techniques developed for learning them over large volumes of data

<img src="multimedia/classification4.png" height=300>

---

## Classification: Logistic Regression

- An example of a classification model, not a regression model
- Logistic function: 
    - F(t) = 1/ (1 + e<sup>-t</sup>)
    - Always between 0 and 1
    - Can be intepreted as a probability
- Say: features are: x, y, and response variable is r which takes two values (true and false)
- Consider the formula:
    - F = 1 / (1 + e<sup>-(c_1 x + c_2 y + c_3)</sup>)
    - Treat it as a probability that the response variable is true or false
- Learning problem: from training data, estimate the coefficients c_i's

---

## Classification: Support Vector Machines

- One of the most popular classification techniques</li>
    - Very powerful, and flexible</li>
    - Also called max-margin classifier</li>
- Goal is to maximally separate the two classes with a hyperplane 
    - In the example below, H1 does not separate the classes. H2 does, but only with a small margin. H3 separates them with the maximum margin.

<img src="multimedia/classification5.png" height=300>

- Maximum-margin hyperplane and margins for an SVM trained with samples from two classes. Samples on the margin are called the support vectors.

<img src="multimedia/classification6.png" height=300>

---

## Classification: Support Vector Machines

- What if the two classes are not linearly separable ??
- Soft-margin SVMs: 
    - Allow for mislabeled samples, i.e., samples that lie on the wrong side of the hyperplane
    - But penalize them
    - **New optimization goal**: Find a hyperplane with high margin but with only a few mislabelled examples
- Finding the optimal separating hyperplan (with a soft-margin one) is quite efficient
    - Between O(n^2) and O(n^3), where n is the number of training samples
    - Work well for high-dimensional data as well

---

## Classification: Support Vector Machines: Kernel Trick

- Can be used to construct non-linear classifiers
- Example:
    - Let **x<sup>i</sup>** = (x<sup>i</sup><sub>1</sub>, x<sup>i</sup><sub>2</sub>) denote the original samples
    - Consider a transformation: 
        - (x<sup>i</sup><sub>1</sub>, x<sup>i</sup><sub>2</sub>) --> ( (x<sup>i</sup><sub>1</sub>)<sup>2</sup>,  sqrt(2)  x<sup>i</sup><sub>1</sub> x<sup>i</sup><sub>2</sub>, (x<sup>i</sup><sub>2</sub>)<sup>2</sup> )
    - An ellipse in the original 2-dimensional space becomes a hyperplane in the 3-dimensional transformed space
        - i.e., we can learn a linear classifier in the 3-dimensional space, and transform it back

<img src="multimedia/classifier7.jpg" height=400>

---

## Classification: Support Vector Machines: Kernel Trick

- Quite powerful
    - The transformed space is often infinite dimensional
- For solving the SVM optimization problem, we only need to be able to compute distance between two vectors
    - **K(x, y)** = dot product of transformed versions of **x** and **y**
    - Called Kernel Function
- Examples of Kernel Functions:
    - Polynomial Kernel
    - Radial Basis Function Kernel: K(x, y) = exp(\gamma ||x - y||^2)
- Choosing a Kernel:
    - Largely based on domain knowledge
    - Kernel function can be thought of as a similarity measure
    - Cross-validation can be used to systematically choose a Kernel and its parameters


--- 

## Cluster Analysis

- Goal is to group the samples into clusters so that the objects in a cluster are more similar to each other than to objects outside
    - Somewhat vague definition -- different ways to formalize it
- [*K-means* Clustering](http://en.wikipedia.org/wiki/K-means_clustering):
    - A commonly used formalization
    - Goal is find *k* groups so that within-cluster distances are minimized
    - Problem is NP-Hard
    - Heuristic algorithm (also typically called *K-means* algorithm):
        - Pick *K* centroids randomly
        - Assign each of the data points to the closest centroid
        - Recompute centroid as the centroid of the data points assigned to it
        - Repeat till convergence
    - Usually converges quickly
    - Drawbacks:
        - Need to know *K*
        - Can't capture many types of clusters
        - Can converge to local minima (drawback of the greedy algorithm, not the formalization)

<img src="multimedia/clustering1.png" height=200>

--- 

## Cluster Analysis

- Hierarchical Clustering
    - Build nested clusters by merging (bottom-up) or splitting (top-down)
    - Agglomerative Clustering: a bottom-up strategy
        - Start with each data point in its own cluster
        - Merge the closest two clusters
        - Repeat till you are left with one cluster
- DBSCAN
    - Clusters are high-density areas separated by low-density areas
    - So clusters can be of any shape (unlike K-Means)

---

## Cluster Analysis

- From Scikit User Guide:

<img src="multimedia/clustering2.png" height=400>
