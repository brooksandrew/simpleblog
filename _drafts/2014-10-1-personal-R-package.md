---
layout: post
title:   "Building an R package"
date:   2014-10-01
categories: articles
tags: [data science]
comments: true
share: true
---



##### The personal R package

As a consulting data scientist, I write a lot of R code in a lot of different places -- physically and virtually.  Different computers, servers, evironments, VPNs, operating systems, you name it.
Even when I have the luxury of working with the same client (and computing environment) for enough time to work on different projects, things can get messy and begin 

Decentralized: portable, customizable  curse of versionality, 
Centralized: organized, clean, efficient, scalable ... rigid, discipline, 


<br>
I find myself often facing a dilemma.  Do I keep project specific code consolidated in one location at the expense of possible duplication... copying old general purpose functions to allow
for customization and further development in the future?  Or do I maintain the general purpose functions which may be called from several different projects in one location at the expense of making customization and enhancing functionality more of a headache.

The disciplined way 

For example, on my last engagement,
I wrote some model validation and visualization functions for our first project which ended successfully and led to a second modeling project.  

##### Why bother build an R package?

##### Why not just a folder full of functions?

I'm not sure I have a good answer to this yet.  This was my previous solution for maintaining general purpose R functions until this week.


##### Where to start

1. I got started following [Hilary Parker's post: Writing an R package from scrach](http://hilaryparker.com/2014/04/29/writing-an-r-package-from-scratch/).
This gets you a minimal package on Github.

2. I had to fill in with some steps from [Steve Mosher's post on building in Windows](http://stevemosher.wordpress.com/ten-steps-to-building-an-r-package-under-windows/).
I needed to add R to my path and install [Miktex](http://miktex.org/).

3. For anything else, you can probably find it on R guru [Hadley Wickham's R packages page](http://r-pkgs.had.co.nz/) soon to be published (2015) by [O'Reilly](http://www.oreilly.com/) .

##### Quick plugs

* use devtools
* use roxygen2
* use RStudio for building and testing
* get Miktex

##### Workflow for using the package

Simple!

{% highlight R %} 
require('devtools') # assuming devtools is installed
install.packages('Rsenal', 'brooksandrew')
require('Rsenal')
{% endhighlight %} 

##### Workflow for adding functions to the package

1. Clone the git repository from Github locally on whichever machine I'm on

  {% highlight bash %} 
  git clone https://github.com/brooksandrew/Rsenal.git Rsenal
  {% endhighlight %

2. Add function(s) to the `R` folder of Rsenal.
3. Add `packageName::` before each function from an external package, so it's clear what your dependencies are for each function.
4. Update DESCRIPTION file with package dependencies: [imports and suggests](http://r-pkgs.had.co.nz/description.html).
5. Check and Build in RStudio.
6. Commit and push changes to Github.

{% highlight bash %} 
git add *
git commit -m "adding functions to R package"
git push origin master
{% endhighlight %} 


* documentation in function.  initialize with roxygen2 document().  prevents editing .Rd files
* unit tests



