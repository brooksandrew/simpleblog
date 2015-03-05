---
layout: post
title:   "How accurate is Next Bus IV: visualizing"
date:   2014-09-18
categories: articles
tags: [data science, dataviz, nextbus, javascript, d3]
comments: true
share: true
---


See the prior 3 posts for context:  

* [How accurate is Next Bus I: Extracting data from API](../nextbus1_api)
* [How accurate is Next Bus II: Wrangling data](../nextbus2_wrangle)
* [How accurate is Next Bus III: Getting the answers](../nextbus3_analyze)



<iframe style="border: 0px;" src="/simpleblog/assets/html/d3nextbus.html" width="1000" height="600"></iframe>

This one takes a long time to load.  It makes a `d3.csv` call to a 24MB file.  I was surprised to find that reading in the file took 
all this time, but transformations that happen in the app take almost no time at all.



### One week of Next Bus predictions
<iframe style="border: 0px;" src="/simpleblog/assets/html/busScatter.html" width="1000" height="550"></iframe>



The scatter plot with zoom+pan+brush loaded too slow with the full dataset (24MB) of all 190,000 predictions for the week.
It also made for a crowded visualization.  So I took a sample preserving a consistent distance between predictions.  The sampled data (2.5MB) takes every 10th prediction which turns out to be approximately a prediction every 90 seconds.

{% highlight R %}
# keeping just estimates every nth prediction when time between predictions is less than 30 seconds
df$timediff[2:nrow(df)] <- df$time[2:nrow(df)] - df$time[1:(nrow(df)-1)]
df$timediff[is.na(df$timediff)] <- 0
n <- 10
df$timediffSample[df$timediff<30] <- rep(1:n, length.out=sum(df$timediff<30))
df$timediffSample[is.na(df$timediffSample)] <- 0
{% endhighlight %}
