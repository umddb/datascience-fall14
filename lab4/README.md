## Data Cleaning

The goal of this assignment to use a variety of tools to clean several datasets. The datasets are described first, followed
by the tools you need to use. 

There are several different files you need to submit. You should zip them all into a single archive, and upload that archive.

---

### Datasets and Tasks

The lab4 directory contains several files:
    1. **crime.txt**: This is the one of the example files from the Data Wrangler website.
    1. **labor.csv**: Another file from Data Wrangler website.
    1. **cmsc.txt**: This is a cleaned-up version of the html file that you can download from UMD SOC (the original file is also there in the
            directory). It only contains 

1. A dataset of synonyms and their meanings (`synsets.txt`). Each line contains one synset with the following format:

    ID, &lt;synonyms separated by spaces&gt;, &lt;different meanings separated by semicolons&gt;

1. The second dataset (`worldcup.txt`) is a snippet of the following Wikipedia webpage on [FIFA (Soccer) World Cup](http://en.wikipedia.org/wiki/FIFA_World_Cup).
Specifically it is a partially cleaned-up wiki source for the table toward the end of the page that lists teams finishing in the top 4. 


Your task is to clean the dataset to get the following outputs, respectively.
    1.
    1.
    1.

---

### Data Wrangler

[Data Wrangler](http://vis.stanford.edu/wrangler/app/) is a visual interactive tool for cleaning datasets. You should see the demo
and make sure you can repeat the steps on the datasets provided on the website before attempting to try to use it on the above
datasets.

#### Assignment Part 1
Use Data Wrangler to clean and transform datasets 1 and 2. Dataset 3 is too messy for loading into Data Wrangler directly -- you would need some
significant pre-processing before trying to use Data Wrangler to clean it.

For each of the datasets (1 and 2): submit a screenshot of the final result and also export and submit the Python script.

---

### Grep, Sed & Awk

The set of three UNIX tools, `sed`, `awk`, and `grep`, can be very useful for quickly cleaning up and transforming data for further analysis
(and have been around since the inception of UNIX). 
In conjunction with other unix utilities like `sort`, `uniq`, `tail`, `head`, etc., you can accomplish many simple data parsing and cleaning 
tasks with these tools. 
You are encouraged to play with these tools and familiarize yourselves with the basic usage of these tools.


As an example, the following sequence of commands can be used to answer the third question from the [lab 2](../lab2/) ("Find the five uids that have tweeted the most").

	grep "created\_at" twitter.json | sed 's/"user":{"id":\([0-9]*\).*/XXXXX\1/' | sed 's/.*XXXXX\([0-9]*\)$/\1/' | sort | uniq -c | sort -n | tail -5

The first command (`grep`) discards the deleted tweets, the `sed` commands extract the first "user-id" from each line, `sort` sorts the user ids, and `uniq -c` counts the unique entries (i.e., user ids). The final `sort -n | tail -5` return the top 5 uids.
Note that, combining the two `sed` commands as follows does not do the right thing -- we will let you figure out why.

	grep "created\_at" twitter.json | sed 's/.*"user":{"id":\([0-9]*\).*/\1/' | sort | uniq -c | sort -n | tail -5"

To get into some details:

## grep

The basic syntax for `grep` is: 

	 grep 'regexp' filename

or equivalently (using UNIX pipelining):

	cat filename | grep 'regexp'

The output contains only those lines from the file that match the regular expression. Two options to grep are useful: `grep -v` will output those lines that
*do not* match the regular expression, and `grep -i` will ignore case while matching. See the manual (`man grep`) (or online resources) for more details.

## sed
Sed stands for _stream editor_. Basic syntax for `sed` is:

	sed 's/regexp/replacement/g' filename

For each line in the intput, the portion of the line that matches _regexp_ (if any) is replaced with _replacement_. Sed is quite powerful within the limits of
operating on single line at a time. You can use \\( \\) to refer to parts of the pattern match. In the first sed command above, the sub-expression within \\( \\)
extracts the user id, which is available to be used in the _replacement_ as \1. 


## awk 

Finally, `awk` is a powerful scripting language (not unlike perl). The basic syntax of `awk` is: 

	awk -F',' 'BEGIN{commands} /regexp1/ {command1} /regexp2/ {command2} END{commands}' 

For each line, the regular expressions are matched in order, and if there is a match, the corresponding command is executed (multiple commands may be executed
for the same line). BEGIN and END are both optional. The `-F','` specifies that the lines should be _split_ into fields using the separator "_,_", and those fields are available to the regular
expressions and the commands as $1, $2, etc. See the manual (`man awk`) or online resources for further details. 



## Examples 

A few examples to give you a flavor of the tools and what one can do with them.

1. Perform the equivalent of _wrap_ on `labor.csv` (i.e., merge consecutive groups of lines referring to the same record)

    	cat labor.csv | awk '/^Series Id:/ {print combined; combined = $0} 
                            !/^Series Id:/ {combined = combined", "$0;}
    	                    END {print combined}'

1. On  `crime-clean.txt`, the following command does a _fill_ (first row of output: "Alabama, 2004, 4029.3".

    	cat crime-clean.txt | grep -v '^,$' | awk '/^[A-Z]/ {state = $4} !/^[A-Z]/ {print state, $0}'
    
1. On `crime-clean.txt`, the following script cleans the data as was done in the Wrangler demo in class. The following works assuming perfectly homogenous data (as the example on the Wrangler wbesite is).

    	cat crime-clean.txt | grep -v '^,$' | sed 's/,$//g; s/Reported crime in //; s/[0-9]*,//' | 
            awk -F',' 'BEGIN {printf "State, 2004, 2005, 2006, 2007, 2008"} 
                /^[A-Z]/ {print c; c=$0}  
                !/^[A-Z]/ {c=c", "$0;}    
                END {print c}'

1. On `crime-unclean.txt` the follow script perfroms the same cleaning as above, but
allows incomplete information (e.g., some years may be missing).

    	cat crime-unclean.txt | grep -v '^,$' | sed 's/Reported crime in //;' | 
                awk -F',' 'BEGIN {printf "State, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008"} 
                           /^[A-Z]/ || /^$/ {if(state) {
                                        printf(state); 
                                        for(i = 2000; i <= 2008; i++) {
                                               if(array[i]) {printf("%s,", array[i])} else {printf("0,")}
                                        }; printf("\n");} 
                                     state=$0; 
                                     delete array} 
                          !/^[A-Z]/ {array[$1] = $2}'

We provided the last example to show how powerful `awk` can be. However if you need to write a long command like this, you may be better
off using a proper scripting language like `perl` or `python`!

    
## Tasks:

Perform the above cleaning tasks using these tools. Hints:

1. Use the "split" function, and "for loop" constructs (e.g., [here](http://www.math.utah.edu/docs/info/gawk_12.html)).

2. For World Cup data, start with this command that cleans up the data a little bit.

        cat worldcup.txt | sed 's/\[\[\([0-9]*\)[^]]*\]\]/\1/g; s/.*fb|\([A-Za-z]*\)}}/\1/g; s/<sup><\/sup>//g; s/|bgcolor[^|]*//g; s/|align=center[^|]*//g'

Perform the above cleaning tasks using these tools.   No need to re-answer the questions in the Wrangler section, but recompute them to ensure your answers are consistent.

#### Questions

1. Submit the scripts you wrote to perform the cleaning tasks.
2. From your experience, briefly discuss the pro and cons between using Data Wrangler as compared to lower levels tools like sed/awk?
3. What additional operations would have made using Data Wrangler "easier"?


# Handing in your work

Answer the questions above in a text file called "lab3-lastname", where lastname is your last name.  Make sure the text file also has your complete name.   Save your Wrangler and command line scripts as separate files and create a zip file or tarball with all three files.   Upload it to the [course Stellar site](http://stellar.mit.edu/S/course/6/fa13/6.885/) as the "lab3" assignment.

Now you're almost done!  Go read the assigned paper(s) for today.

You can always feel free to contact us with questions on [Piazza](https://piazza.com/class/hl6u4m7ft8n373).

### Feedback (optional, but valuable)

If you have any comments about this lab, or any thoughts about the
class so far, we would greatly appreciate them.  Your comments will
be strictly used to improve the rest of the labs and classes and have
no impact on your grade. 

Some questions that would be helpful:

* Is the lab too difficult or too easy?  
* Did you look forward to any exercise that the lab did not cover?
* Which parts of the lab were interesting or valuable towards understanding the material?
* How is the pace of the course so far?

