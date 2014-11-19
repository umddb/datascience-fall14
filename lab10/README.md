# Lab 10

Lab 10 is about D3.js. This lab is optional -- it doesn't count towards your grade.

[D3 (Data-Driven Documents)](http://d3js.org/) is a JavaScript library for creating visualizations from data in a browser.

Scott Murray has an excellent [step-by-step tutorial](http://alignedleft.com/tutorials/d3) and [a (freely available) book](http://chimera.labs.oreilly.com/books/1230000000345/) 
based on the tutorial. He also has an interactive tutorial on [transitions](http://alignedleft.com/projects/2014/easy-as-pi/).

You can also find many examples on the D3 website above, and on the web.

### Assignment

The lab10 directory has two files about the Capital Bike Share data, one that contains all trips over a small period of time, and one that contains latitudes and longitudes
for the 342 bike stations.

1. Create a scatter plot with the bike stations' locations. If you had like, you can figure out how to overlay this plot on a topological map of DC area. Here are some
starting points: [link 1](http://bl.ocks.org/phil-pedruco/7745589), [link 2](http://www.maori.geek.nz/post/d3_js_geo_fun), [link
3](http://www.d3noob.org/2013/03/a-simple-d3js-map-explained.html)

1. Create an interactive visualization that shows some information about the stations at various times. 

As an example: for every hour of the day, for every station, count
the total number of rides that originated at that station during that hour (on any day). You should not try to do this in Javascript -- better to do it in Python and create
the data. Plot this using circles of varying sizes. Allow the user to change the hour of the day and redraw for that hour. Or you can do an animation using delay() and
transition() to show how things change over the course of the day.

Another option is to find: for each station, for each day of the week, the number of casual users who rented a bike at that station vs the number of registered users who
did. Draw equal-sized circles for each station, with different shades to indicate the ratio of casual to registered users. Again allow the user to change the day of the week
or animate it.


### Submission

Submit the URL of your webpage. If you are not sure where to host it, try [Github Pages](https://pages.github.com/).
