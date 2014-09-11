---

# CMSC 498O: Data Modeling

---

## Overview

- Data Modeling
    - Process of representing/capturing the structure in the data
    - **Data model**: A collection of concepts that describes how data is represented and accessed
    - **Schema**: A description of a specific collection of data, using a given data model
- Why?
    - Need to know the structure of the data/information (to some extent) to be able to write general purpose code
    - Lack of a data model makes it difficult to share data across programs, organizations, systems
    - Need to be able to integrate information from multiple sources
    - Efficiency: Can preprocess data to make access efficient (e.g., building a B-Tree on a field)
- A data model typically consists of:
    - Modeling Constructs: A collection of concepts used to represent the structure in the data
        - Typically need to represent types of *entities*, their *attributes*, types of *relationships* between *entities*, and *relationship attributes*
    - Integrity Constraints: Constraints to ensure data integrity (i.e., avoid errors)
    - Manipulation Languages: Constructs for manipulating the data
- We would like it to be:
    - Sufficiently expressive -- can capture real-world data well
    - Easy to use
    - Lends itself to good performance
- The history of modeling can be seen as an attempt to capture the structure in the data.

---

## Overview

- Some examples of data models
    - Relational, Entity-relationship model, XML...
    - Object-oriented, Object-relational, RDF...
    - Current favorites in the industry: JSON, Protocol Buffers, [Avro](http://avro.apache.org/docs/current/), Thrift, Property Graph
- Why so many models ?
    - Tension between descriptive power and ease of use/efficiency
    - More powerful models --> more datasets can be represented
    - More powerful models --> harder to use, to query, and less efficient
- Typically there are multiple levels of modeling
    - Physical modeling concerns itself with how the data is physically stored
    - Logical or Conceptual modeling concerns itself with type of information stored, the different entities, their attributes, and the relationships among those
    - There may be several layers of logical/conceptual models to restrict the information flow (both for security and ease-of-use)


--- 

## Examples

- Entity-relationship Model
- Relational Model
- JSON
