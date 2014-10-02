---

# CMSC 498O: Data Wrangling

---

## Overview

- Goal: get data into a structured form suitable for analysis
    - Variously called: data preparation, data munging, data curation
    - Also often called ETL (Extract-Transform-Load) process
- Often the step where majority of time (80-90%) is spent
- Key steps:
    - Scraping: extracting information from sources, e.g., webpages, spreadsheets
    - Data transformation: to get it into the right structure
    - Data integration: combine information from multiple sources
    - Information extraction: extracting structured information from unstructured/text sources
    - Data cleaning: remove inconsistencies/errors

    <img src="multimedia/wrangling.png" height=500>

- Many of the problems are not easy to formalize, and have seen little work
    - E.g., Cleaning
    - Others aspects of integration, e.g., schema mapping, have been studied in depth
- Typical workflow
    - From [Data Cleaning:  Problems and Current Approaches](https://www.ki.informatik.hu-berlin.de/mac/lehre/lehrmaterial/Informationsintegration/Rahm00.pdf)
    - Somewhat old: data is mostly coming from structured sources
    - For a data scientist, the data scraping is equally important

    <img src="multimedia/etl-cleaning.png" height=400>

---

## Overview

#### Single-source problems: 
- Depends largely on the source
- Databases can enforce constraints, whereas data extracted from files or spreadsheets, or scraped from webpages is much more messy
- Types of problems:
    - Ill-formatted data, especially from webpages or files or spreadsheets
    - Missing or illegal values, Misspellings, Use of wrong fields, Extraction issues (not easy to separate out different fields)
    - Duplicated records, Contradicting Information, Referential Integrity Violations
    - Unclear default values (e.g., data entry software needs something)
    - Evolving schemas or classification schemes (for categorical attributes)
    - Outliers

#### Multi-source problems:
- Different sources are developed separately, and maintained by different people
- Issue 1: Mapping information across sources (schema mapping/transformation)
    - Naming conflicts: same name used for different objects
    - Structural conflicts: different representations across sources
    - We will cover this later
- Issue 2: Entity Resolution: Matching entities across sources
- Issue 3: Data quality issues
    - Contradicting information, Mismatched information, etc.

    <img src="multimedia/cleaning-sources.png" width=700>

    <img src="multimedia/cleaning-table-1.png" width=700>

    <img src="multimedia/cleaning-table-2.png" width=700>


---

## Data Scraping

- Data may reside in a wide variety of different sources, including: CSV files, JSON files, XML, different databases, Spreadsheets, ...
    - Most analytical tools support importing data from such sources
- Web scraping: Scraping data from web sources is tougher
    - In some cases, there may be APIs
    - In most other cases, data may have to be explicitly scraped
    - Often pipelines are set up to do this on a periodic basis
        - Can be fragile
    - Several tools out there to do this automatically
        - E.g., [import.io](https://import.io/), [Kimono](http://www.kimonolabs.com), ...


--- 

## Data Cleaning: Outlier Detection

- From: [Quantitative Data Cleaning for Large Databases; Joe Hellerstein](http://db.cs.berkeley.edu/jmh/papers/cleaning-unece.pdf)
    - Brief discussion of the general problem, but focuses primarily on quantitative data (i.e., integers/floats that measure some quantities of interest)
- Also from: [Outlier Detection: Principles, Techniques, Applications; Chawla and Sun](http://www3.ntu.edu.sg/sce/pakdd2006/tutorial/chawla_tutorial_pakddslides.pdf)

- Sources of errors in data
    - Data Entry Errors: users putting in arbitrary values to satisfy the form especially problematic
    - Measurement Errors: Much data never sees human eyes, especially sensor data; however rife with all kinds of errors
    - Distillation Errors: errors that pop up during processing and summarization
    - Data Integration Errors: inconsistencies across sources that are combined together

- Univariate outliers
    - A set of values can be characterized by metrics such as center (e.g., mean), dispersion (e.g., standard deviation), and skew
    - Can be used to identify outliers
        - Must watch out for "masking": one extreme outlier may alter the metrics sufficiently to mask other outliers
        - Should use **robust statistics**: considers effect of corrupted data values on distributions
        - Robust center metrics: median, k% trimmed mean (discard lowest and highest k% values)
        - Robust dispersion: 
            - Median Absolute Deviation (MAD): median distance of all the values from the median value
    - A reasonable approach to find outliers: any data points 1.4826x MAD away from median
        - The above assumes that data follows a **normal** distribution
        - May need to eyeball the data (e.g., plot a histogram) to decide if this is true
    - [Wikipedia Article on Outliers](http://en.wikipedia.org/wiki/Outlier) lists several other normality-based tests for outliers
    - If data appears to be not normally distributed:
        - Distance-based methods: look for data points that do not have many neighbors
        - Density-based methods:
            - Define *density* to be average distance to *k* nearest neighbors
            - *Relative density* = density of node/average density of its neighbors
            - Use relative density to decide if a node is an outlier
    - Most of these techniques start breaking down as the dimensionality of the data increases
        - *Curse of dimensionality*
        - Can project data into lower-dimensional space and look for outliers there
            - Not as straightforward -- outlier detection 

    <img src="multimedia/outliers-1.png" width=300>

- Multivariate outliers
    - Analogous to above, one set of techniques based on assuming data follows a *multi-variate normal distribution*
        - Defined by a mean, &mu;, and a *covariance matrix*, &Sigma;
        - **Mahalanobis Depth of a point**: Square root of (x - &mu;)'&Sigma;<sup>-1</sup>(x - &mu;)
        - Measures how far the point x is from the multivariate normal distribution
            - Look for points that are too far away
    - Mean/Covariance are not *robust* -- they are sensitive to outliers
        - Iterative approach: remove points with high Mahalanobis distance, recompute the mean and covariance
        - Several other general approaches discussed the reference above (by Hellerstein)
        - No clear guidelines here -- need to try different techniques based on the data

- Timeseries outliers
    - Often the data is in the form of a timeseries
    - Can use the historical values/patterns in the data to flag outliers
    - Rich literature on *forecasting* in timeseries data

- Frequency-based outliers
    - An item is considered a "heavy hitter" if it is much more frequent than other items
    - In relational tables, can be found using a simple *groupby-count*
    - Often the volume of data may be too much (e.g., internet routers)
        - Approximation techniques often used
        - To be discussed sometime later in the class

- Things generally not as straightforward with other types of data
    - Outlier detection continues to be a major research area

--- 

## Data Cleaning: Entity Resolution

- From: [Entity Resolution Tutorial](http://www.cs.umd.edu/~getoor/Tutorials/ER_VLDB2012.pdf)

- Identify different *manifestations* of the same real world object
    - Also called: identity reconciliation, record linkage, deduplication, fuzzy matching, Object consolidation, Coreference resolution, and several others
   
- Motivating examples
    - Postal addresses
    - Entity recognition in NLP/Information Extraction
    - Identifying companies in financial records
    - Comparison shopping
    - Author disambiguation in citation data
    - Connecting up accounts on online networks
    - ...

- Important to correctly identify references
    - Often actions taken based on extracted data
    - Cleaning up data by entity resolution can show structure that may not be apparent before

- Challenges
    - Such data is naturally ambiguous (e.g., names, postal addresses)
    - Abbreviations/data truncation
    - Data entry errors, Missing values, Data formatting issues complicate the problem
    - Heterogeneous data from many diverse sources
