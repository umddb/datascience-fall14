## Data Wrangling

The goal of this assignment to use a variety of tools to clean several datasets. The datasets are described first, followed
by the tools you need to use. 

There are several different files you need to submit, including a few scripts and a few screenshots (for Data Wrangler). There are two options.

1. Add the scripts/commands to the `submission.txt` file in the appropriate places. Create a zip archive with this file and the screenshots and submit the archive.

1. (Preferred) Fill in the `submission.docx` file (including scripts and screenshots) instead and upload it. You can also upload a `pdf` version.

---

### Datasets and Tasks

The lab4 directory contains several files:

1. **crime.txt**: This is the one of the example files from the Data Wrangler website.

1. **labor.csv**: Another file from Data Wrangler website.

1. **cmsc.txt**: This is a cleaned-up version of the html file that you can download from UMD SOC (the original file is also there in the directory). It does not contain the discussion sections information, and many other small exceptions are removed. 

2. **worldcup.txt**: This is a snippet of the following Wikipedia webpage on [FIFA (Soccer) World Cup](http://en.wikipedia.org/wiki/FIFA_World_Cup). Specifically it is a partially cleaned-up wiki source for the table toward the end of the page that lists teams finishing in the top 4. 

Your tasks (to be done using the different tools as discussed below):

1. **CMSC**: Convert the cmsc.txt file into table with columns: 

           Course No., Section No., Instructor, Seats, Open, Waitlist, Days, Time, Bldg., Room No.
   So the first two outputs would be:

           CMSC100, 0101, Charles Kassir, 45, 4, 0, M, 4:00pm - 4:50pm, CSI, 2117
           CMSC106, 0101, Jianwu Wang, 45, 0, 5, TuTh, 9:30am - 10:45am, CSI,  2117

1. **World Cup 1**: Create the following table from the world cup data, i.e., each line in the output contains a country, a year, and the position of the county in that year (if within top 4).

           BRA, 1962, 1
           BRA, 1970, 1
           BRA, 1994, 1
           BRA, 2002, 1
           BRA, 1958, 1
           BRA, 1998, 2
           BRA, 1950, 2
           ...

1. **World Cup 2**: We also want a slightly different representation of the data as shown below. You may want to start with the output of the above.

                     1930    1934    1938    1950    1954    ...
           Brazil      -       -       3       2       -
           Germany     -       3       -       -       1
In other words, we want a 2-dimensional table where the columns the years when world cups were held, the rows are countries, and the entry is the position of that country that year if within top 4, and empty (or N/A or "-") otherwise.
            

---

### Data Wrangler

[Data Wrangler](http://vis.stanford.edu/wrangler/app/) is a visual interactive tool for cleaning datasets. You should see the demo
and make sure you can repeat the steps on the datasets provided on the website before attempting to try to use it on the above
datasets.

#### Assignment Part 1
Use Data Wrangler to do the 3 tasks listed above. Submit a screenshot of the final results and also export and submit the Python script.

---

### Grep, Sed & Awk

The set of three UNIX tools, `sed`, `awk`, and `grep`, can be very useful for quickly cleaning up and transforming data for further analysis
(and have been around since the inception of UNIX). 
In conjunction with other unix utilities like `sort`, `uniq`, `tail`, `head`, etc., you can accomplish many simple data parsing and cleaning 
tasks with these tools. 
You are encouraged to play with these tools and familiarize yourselves with the basic usage of these tools.


As an example, the following sequence of commands can be used to find the 5 countries with the highest number of players born in 1975, using the `players.csv` file in `lab2`.
	`tail +1 ../lab2/players.csv | grep "1975-" | awk -F',' '{print $3}' | sort | uniq -c | sort -n | tail -5`
    
The first `tail` discards the first header row, the `grep` finds the players born in 1975, the `awk` script splits each line using delimiter `,` and extracts the 3rd field, `sort` sorts the country ids, and
`uniq -c` counts the unique entries. The final `sort -n | tail -5` return the top 5 country ids. You should try partial prefix of this command to make sure you understand how each one works, especially if you
haven't used these tools before.

To get into some details:

#### grep

The basic syntax for `grep` is: 

	 `grep 'regexp' filename`

or equivalently (using UNIX pipelining):

	`cat filename | grep 'regexp'`

The output contains only those lines from the file that match the regular expression. Two options to grep are useful: `grep -v` will output those lines that
*do not* match the regular expression, and `grep -i` will ignore case while matching. See the manual (`man grep`) (or online resources) for more details.

#### sed
Sed stands for _stream editor_. Basic syntax for `sed` is:

	`sed 's/regexp/replacement/g' filename`

For each line in the intput, the portion of the line that matches _regexp_ (if any) is replaced with _replacement_. Sed is quite powerful within the limits of
operating on single line at a time. You can use \\( \\) to refer to parts of the pattern match. In the first sed command above, the sub-expression within \\( \\)
extracts the user id, which is available to be used in the _replacement_ as \1. 


#### awk 

Finally, `awk` is a powerful scripting language (not unlike perl). The basic syntax of `awk` is: 

	awk -F',' 'BEGIN{commands} /regexp1/ {command1} /regexp2/ {command2} END{commands}' 

For each line, the regular expressions are matched in order, and if there is a match, the corresponding command is executed (multiple commands may be executed
for the same line). BEGIN and END are both optional. The `-F','` specifies that the lines should be _split_ into fields using the separator "_,_", and those fields are available to the regular
expressions and the commands as $1, $2, etc. See the manual (`man awk`) or online resources for further details. 



#### Examples 

A few examples to give you a flavor of the tools and what one can do with them.

1. Perform the equivalent of _wrap_ command in Data Wrangler on `labor.csv` (i.e., merge consecutive groups of lines referring to the same record)

    	cat labor.csv | awk '/^Series Id:/ {print combined; combined = $0} 
                            !/^Series Id:/ {combined = combined", "$0;}
    	                    END {print combined}'

1. On  `crime.txt`, the following command does a _fill_ (first row of output: "Alabama, 2004, 4029.3".

    	cat crime.txt | grep -v '^,$' | awk '/^[A-Z]/ {state = $4} !/^[A-Z]/ {print state, $0}'
    
1. On `crime.txt`, the following script cleans the data as was done in the Wrangler demo in class. The following works assuming perfectly homogenous data (as the example on the Wrangler wbesite is).

    	cat crime.txt | grep -v '^,$' | sed 's/,$//g; s/Reported crime in //; s/[0-9]*,//' | 
            awk -F',' 'BEGIN {printf "State, 2004, 2005, 2006, 2007, 2008"} 
                /^[A-Z]/ {print c; c=$0}  
                !/^[A-Z]/ {c=c", "$0;}    
                END {print c}'

1. The follow script perfroms the same cleaning as above, but allows incomplete information (e.g., some years may be missing). The missing data is reported as 0. Note that the `crime.txt` has information for
all 5 years for all states, but you can try removing some of those rows to make sure this script works.

    	cat crime.txt | grep -v '^,$' | sed 's/Reported crime in //;' | 
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

    
#### Assignment Part 2

Perform **CMSC** and **World Cup 1** using the UNIX tools. Task **World Cup 2** is a bit much for these tools.

---

### Python

Finally, as a scripting language and with powerful string operators, Python is an ideal language to write data cleaning tasks. In fact, the shell
scripts you may write using the above Unix tools can be pretty much directly mapped to Python code, although for simple things, the Unix tools are
likely to be significantly faster.

Pandas further enhances these capabilities of Python. Chapter 7 in the textbook (Python for Data Analysis) discusses data munging and cleaning abilities of
Pandas. For example, `.pivot` can take the output of the second task and do the third task in one line.

#### Assignment Part 3

Perform the three tasks using Python. Submit the Python scripts and the results.

