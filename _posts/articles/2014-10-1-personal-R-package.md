---
layout: post
title:   "DIY building an R package"
date:   2014-11-20
categories: articles
tags: [data science, R, R package, github]
comments: true
share: true
---

##### Why create a personal R package?

As a consulting data scientist, I write a lot of R code in a lot of different places -- physically and virtually.  Different computers, servers, evironments, VPNs, operating systems, all of the above.
Even when I have the luxury of working with the same client (and computing environment) for enough time to work on different projects, things can get messy.  

##### When is it worth it?

I find myself often facing a dilemma -- do I keep project specific code consolidated in one location at the expense of possible duplication later on by copying around old general purpose functions to allow for customization and further development in the future? 
Or do I maintain the general purpose functions which may be called from several different projects in one location at the expense of making customization and enhancing functionality more of a headache? 

I find there are pros and cons to each method:

* **Decentralized:** portable, customizable ... but can be grossly duplicatitive and suffer from curse of versionality.
* **Centralized:** organized, clean, efficient, scalable ... but can be rigid, requires discipline and can break old programs if you're not careful.  

Surely centralization is the better solution after some tipping point.  However, the unpredictable nature of my work sometimes makes it difficult to predict when (or if) that tipping point will occur -- when the benefits of centralization begin to outweigh the costs of the portable lightweight decentralized method.

##### Why not just a folder full of functions?

I'm not sure I have a good answer to this yet.  This was my previous solution for maintaining general purpose R functions until building a package.

Some current thoughts:

* **Organization:** I'm finding it easier to organize my functions with structured documentation on parameters and examples, albeit with some upfront cost of actually writing this documentation.
* **Sharing:** makes it easier to share your code that is documented in a common-tongue with others.
* **Version Control:** If you're using Github, you can always revert back to previous versions.
* **Tests & Checks:** When building a package, your code is evaluated for errors and missing dependencies, including your examples.
* **Shiny apps:** I realized during this process that you can actually wrap [Shiny apps](http://shiny.rstudio.com/) up into functions and configure them to take arguments from your environment.  Useful for quick and dirty exploratory work so you don't have to worry about directories or change ui.R and server.R code around to fit something new you want to throw in a Shiny app. 

##### How to start building

1. I got started following [Hilary Parker's post: Writing an R package from scrach](http://hilaryparker.com/2014/04/29/writing-an-r-package-from-scratch/).
This gets you a minimal package on Github.

2. I had to fill in with some steps from [Steve Mosher's post on building in Windows](http://stevemosher.wordpress.com/ten-steps-to-building-an-r-package-under-windows/).
I needed to add R to my path and install [Miktex](http://miktex.org/).

3. For anything else, you can probably find it on R guru [Hadley Wickham's R packages page](http://r-pkgs.had.co.nz/) soon to be published (2015) by [O'Reilly](http://www.oreilly.com/) .

##### These made my life easier

* [devtools](http://cran.r-project.org/web/packages/devtools/index.html) R package.
* [roxygen2](http://cran.r-project.org/web/packages/roxygen2/index.html) R package
* [RStudio](http://www.rstudio.com/) for building and testing
* [Miktex](http://miktex.org/)

##### Workflow for using the package

Once you've built a package on Github, it's simple to pull it down wherever you are.

{% highlight R %} 
install.packages('devtools') # if not already installed
library('devtools') 
install.packages('brooksandrew/Rsenal')
library('Rsenal')
{% endhighlight %} 

##### Workflow for adding to a package

1. Clone the git repository from Github locally on whichever machine you're on.

  {% highlight bash %} 
  git clone https://github.com/brooksandrew/Rsenal.git Rsenal
  {% endhighlight %}

2. Add function(s) to the `\R` folder of your package.
3. Good practice to add `packageName::` before each function from an external package, so it's clear what your dependencies are for each function.
4. Update DESCRIPTION file with package dependencies: [imports and suggests](http://r-pkgs.had.co.nz/description.html).
5. Check and Build in RStudio.
6. Commit and push changes to Github.

{% highlight bash %} 
git add .
git commit -m "adding functions to R package"
git push origin master
{% endhighlight %} 

##### Gotchas

If using RStudio and roxygen2, you might have to Configure Build Tools to allow Roxygen to generate the documentation you want it to.  

In RStudio:  
=> Build  
=> Configure Build Tools  
=> Check box for "Generate Documentation with Roxygen"  
=> Click "Configure"  
=> Probably want to check boxes for at least "RD files" and "NAMESPACE".

If your NAMESPACE file (simple list of your functions and dependencies) isn't updating and you dont want to use RStudio, try `devtools::document()`



