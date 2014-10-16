## Entity Resolution

The goal of this assignment is to perform entity resolution on a dataset containing products from Amazon and Google. The dataset is described first, followed
by a description of the tool you need to use. The tool is a python module so all your scripts need to be in python. 

There are several different files you need to submit, including two scripts, their output, and a short report with a description of your solution and its performance. Create a zip archive include all your python scripts, their output (specified below) and your report. The report should also contain a detailed description on how to run the scripts you submitted. 

---

### Dataset and Files Providing in Lab5

The lab5 directory contains the following files:

1. **products.csv**: This is a list of products from two online shops. The fields of this csv file are "source","id","title","description","manufacturer","price". Notice that "description" is a text field containing a description of the product. "Manufacturer" and "price" have missing values. Finally, the "price" field does not contain only numeric values but it may also contain values such as "19.32 gbp". 

2. **product_mapping.csv**: This is a list of all pairs of products that correspond to the same product, i.e., the correct matches. You will need to use this file in order to evaluate the performance of your entity resolution script.

3. **product_dedup.py**: This is a template file which you can use as a starting point for your own entity resolution script. The file contains the necessary functions for reading the file "products.csv" and write the results of entity resolution into a file named "products_out.csv". The fields of this output file are "Cluster ID","source","id","title","description","manufacturer","price","canonical_description","canonical_title","canonical_price","canonical_source","canonical_id","canonical_manufacturer","confidence_score". The "Cluster_ID" corresponds to an id grouping references of products that correspond to the same underlying entity. 


### Description of Entity Resolution Module

The entity resolution module we are going to use is called [a dedupe](http://dedupe.readthedocs.org/en/latest/). Before using dedupe, please go over the documentation and variable definitions in the attached link. You can also find a useful example on how to use dedupe for entity resolution when the input corresponds to csv files [a here](https://github.com/datamade/csvdedupe). 

#### Installation 

To install dedupe in your virtual machine you need to follow the instructions listed below:

1. Open a terminal and execute "pip install dedupe". This will download the necessary packages and install dedupe. 
TO BE FINALIZED

### Tasks

Use dedupe to perform enity resolution for the provided products. If you choose to use the template file product_dedup.py you will need to edit it in three places. You need to specify the fields that dedupe will use for entity resolution, you need to specify any custom field comparison function you want to use, and finally you can choose the trade-off between precision and recall while training the entity resolution mechanism. Please read the comments in the file carefully. 

As mentioned above, running this script will output a file named products_out.csv. You need to compare the entity resolution result in this output file with the provided ground truth file and report the precision and recall your method achieved. Please include a description of the fields you used and the comparison function for each field in your report. You should also report the precision and recall your algorithm achieves. Notice that you will have to write your own evaluation script which needs to be submitted as well together with your product_dedup.py script and your report.


