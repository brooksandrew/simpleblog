---
layout: post
title: Interactive association rules exploration app
date: 2015-11-30
categories: articles
tags: [data science, association rules, association analysis, arules, arulesViz, R, Shiny]
comments: true
share: true
---

* Table of Contents
{:toc}


In a [previous post](../association-rules-beyond-transactional-data), I wrote about what I use association rules for and mentioned a Shiny application I developed to explore and visualize rules.  This post is about that app. The app is mainly a wrapper around the [arules] and [arulesViz] packages developed by Michael Hahsler.

## Features

* train association rules
  * interactively adjust confidence and support parameters
  * sort rules
  * sample just top rules to prevent crashes
  * post process rules by subsetting LHS or RHS to just variables/items of interest
  * suite of interest measures
* visualize association rules
  * grouped plot, matrix plot, graph, scatterplot, parallel coordinates, item frequency
* export association rules to CSV

## How to get

**Option 1:** Copy the code below from the [arules_app.R gist](https://gist.github.com/brooksandrew/706a28f832a33e90283b)

**Option2:** Source gist directly.

{% highlight R %}
library('devtools')
library('shiny')
library('arules')
library('arulesViz')
source_gist(id='706a28f832a33e90283b')
{% endhighlight %}

**Option 3:** Download the Rsenal package (my personal R package with a hodgepodge of data science tools) and use the `arulesApp` function:

{% highlight R %}
library('devtools')
install_github('brooksandrew/Rsenal')
library('Rsenal')
?Rsenal::arulesApp
{% endhighlight %}

## How to use

`arulesApp` is intended to be called from the R console for interactive and exploratory use.  It calls `shinyApp` which spins up a Shiny app without the overhead of having to worry about placing server.R and ui.R.  Calling a Shiny app with a function also has the benefit of smooth passing of parameters and data objects as arguments. More on `shinyApp` [here](https://support.rstudio.com/hc/en-us/articles/200404846-Working-in-the-Console).

`arulesApp` is currently highly exploratory (and highly unoptimized).  Therefore it works best for quickly iterating on rule training and visualization with low-medium sized datasets.  Check out Michael Hahsler's [arulesViz] paper for a thorough description of how to interpret the visualizations.  There is a particularly useful table on page 24 which compares and summarizes the visualization techniques.

Simply call `arulesApp` from the console with a data.frame or transaction set for which rules will be mined from:

{% highlight R %}

library('arules') contains Adult and AdultUCI datasets

data('Adult') # transaction set
arulesApp(Adult, vars=40)

data('AdultUCI') # data.frame
arulesApp(AdultUCI)

{% endhighlight %} 


Here are the arguments: 

* `dataset` data.frame, this is the dataset that association rules will be mined from.  Each row is treated as a transaction.  Seems to work OK when a the S4 transactions class from *arules* is used, however this is not thoroughly tested.
* `bin` logical, *TRUE* will automatically discretize/bin numerical data into categorical features that can be used for association analysis.
* `vars` integer, how many variables to include in initial rule mining
* `supp` numeric, the support parameter for initializing visualization.  Useful when it is known that a high support is needed to not crash computationally.
* `conf` numeric, the confidence parameter for initializing visualization.  Similarly useful when it is known that a high confidence is needed to not crash computationally.


## Screenshots

###### Association rules list view

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/123438060@N05/23316969311/in/dateposted/" title="Association rule list view 1"><img src="https://farm6.staticflickr.com/5717/23316969311_8896fab691_c.jpg" width="800" height="473" alt="Screen Shot 2015-11-29 at 11.36.54 AM"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/123438060@N05/23031568189/in/dateposted/" title="Association rule list view 2"><img src="https://farm1.staticflickr.com/619/23031568189_6ac03917bb_c.jpg" width="800" height="486" alt="Screen Shot 2015-11-29 at 11.34.51 AM"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

###### Scatterplot

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/123438060@N05/23103789750/in/dateposted/" title="Association rule scatterplot"><img src="https://farm1.staticflickr.com/629/23103789750_d1147d6670_c.jpg" width="800" height="591" alt="Screen Shot 2015-11-29 at 11.40.47 AM"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

###### Graph 

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/123438060@N05/23031583459/in/dateposted/" title="Association rule graph plot"><img src="https://farm6.staticflickr.com/5756/23031583459_a88886a7b1_c.jpg" width="800" height="547" alt="Screen Shot 2015-11-29 at 11.39.53 AM"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

###### Grouped Plot

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/123438060@N05/23031572029/in/dateposted/" title="Association rule grouped plot"><img src="https://farm6.staticflickr.com/5796/23031572029_5c6b830076_c.jpg" width="800" height="589" alt="Screen Shot 2015-11-29 at 11.40.58 AM"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

###### Parallel Coordinates

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/123438060@N05/23316983041/in/dateposted/" title="Association rule parallel coordinate plot"><img src="https://farm1.staticflickr.com/722/23316983041_8efe1dce89_c.jpg" width="800" height="530" alt="Screen Shot 2015-11-29 at 11.37.30 AM"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

###### Matrix 

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/123438060@N05/23031580439/in/dateposted/" title="Association rule matrix plot"><img src="https://farm6.staticflickr.com/5741/23031580439_f985d39777_c.jpg" width="800" height="602" alt="Screen Shot 2015-11-29 at 11.40.39 AM"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

###### Item frequency

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/123438060@N05/23031598109/in/photostream/" title="Screen Shot 2015-11-29 at 11.36.19 AM"><img src="https://farm6.staticflickr.com/5786/23031598109_70b34851fb_c.jpg" width="800" height="595" alt="Screen Shot 2015-11-29 at 11.36.19 AM"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>


## Code

<script src="https://gist.github.com/brooksandrew/706a28f832a33e90283b.js"></script>


[arulesViz]: https://cran.r-project.org/web/packages/arulesViz/vignettes/arulesViz.pdf
[arules]: http://www.jstatsoft.org/v14/i15/paper



