---
layout: post
title:   "How Accurate is Next Bus - Part III: Visualize"
date:   2014-09-12
categories: articles
tags: [data science]
comments: true
share: true
---


See the prior 2 posts for context:  

* [How Accurate is Next Bus - Part III: Extracting data from API](../nextbus1_api)
* [How Accurate is Next Bus - Part III: Analyzing and wrangling data](../nextbus2_analye)


<iframe style="border: 0px;" src="/simpleblog/assets/html/d3nextbus.html" width="1000" height="600"></iframe>

This one takes a long time to load.  It makes a `d3.csv` call to a 24MB file.  I was surprised to find that reading in the file took 
all this time, but transformations that happen in the app take almost no time at all.



### One week of Next Bus predictions
<iframe style="border: 0px;" src="/simpleblog/assets/html/busScatter.html" width="1000" height="550"></iframe>



The scatter plot with zoom+pan+brush loaded to slow with the full dataset (24MB) of all 190,000 predictions for the week.
It also made for a crowded visualization.  So I took a sample preserving the distance between predictions.  The sampled data (2.5MB) takes every 10th prediction which turns out to be approx a prediction every 90 seconds

{% highlight R %}
# keeping just estimates every nth prediction when time between predictions is less than 30 seconds
df$timediff[2:nrow(df)] <- df$time[2:nrow(df)] - df$time[1:(nrow(df)-1)]
df$timediff[is.na(df$timediff)] <- 0
n <- 10
df$timediffSample[df$timediff<30] <- rep(1:n, length.out=sum(df$timediff<30))
df$timediffSample[is.na(df$timediffSample)] <- 0
{% endhighlight %}
