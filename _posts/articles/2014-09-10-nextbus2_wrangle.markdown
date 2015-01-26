---
layout: post
title:   "How accurate is Next Bus II: wrangling data"
date:   2014-09-10
categories: articles
tags: [data science, R, data wrangling, nextbus]
comments: true
share: true
---

* Table of Contents
{:toc}

In a the [previous post](../nextbus1_api) we extracted Next Bus predictions from the [Wmata API](http://developer.wmata.com/).  
If that's too much or uninteresting to you, start here.  Our extracted data looks something like this:

{% highlight bash%}

time                            Minutes  VehicleID  DirectionText                  RouteID  TripID
2014-08-04 18:43:33.525000      17       6506       South to Federal Triangle      64       6464186
2014-08-04 18:43:33.525000      37       7228       South to Federal Triangle      64       6464187
2014-08-04 18:43:33.525000      56       7235       South to Federal Triangle      64       6464188
2014-08-04 18:43:33.525000      80       7231       South to Federal Triangle      64       6464189
2014-08-04 18:43:43.868000      17       6506       South to Federal Triangle      64       6464186
2014-08-04 18:43:43.868000      37       7228       South to Federal Triangle      64       6464187

{% endhighlight %}

## Goal: determine how accurate Next Bus predictions are

I did this analysis in [R](http://www.r-project.org/), however it could be easily be done in Python or one of many languages.  It could even be done in JavaScript.  However, 
doing some data magic in R first will improve performance of the d3 visualizations.  It also allows for much more rapid prototyping, exploration and analysis.


## Step 1: Create a timeseries

Wmata conveniently provides with us a TripID for each unique bus trip.  The only problem is they're not actually unique.
The simplest fix I found was the create a unique identifier for bus trips by concatenating `TripID` and `VehicleID`.
There are certainly more complex ways that use a time dimension to determine unique trips, but this worked for me.

{% highlight R %}
## reading in Nextbus data
df <- read.delim('/data/bus64_8Aug2014.txt', sep='|', header=T, stringsAsFactors=F)

## setting up dates
df$time <- as.POSIXct(df$time, origin='EST')
df$hour <- as.numeric(strftime(df$time, '%H'))

## creating unique ID for bus trips
df$TripID <- as.character(df$TripID)
df$ID <- paste(df$TripID, df$VehicleID, sep="_")
df <- df[order(df$ID, df$time),]
 
{% endhighlight %}

## Step 2: Flag arrivals and departures

Next Bus doesn't actually tell us when a bus arrives.  We need to determine this from the time series we collect.
This is one of the reasons I collect predictions from the API every 10 seconds.
There is probably a more computationally efficient method for doing this using vectorized functions, but this works fine.


{% highlight R %}
## marking arrival and departure dates for Trips
depart <- by(df$time, df$ID, min)
arrive <- by(df$time, df$ID, max)
df$departure <- 0; df$arrival <- 0; df$est <- 0
for(i in 1:nrow(depart)-1) {
  tname <- names(depart)[i]
  df$departure[df$ID==tname & df$time==depart[i]] <- 1
  df$arrival[df$ID==tname & df$time==arrive[i]] <- 1
}

{% endhighlight %}

This gives us something like this:

{% highlight bash %}

time                 Minutes  VehicleID  DirectionText              RouteID  TripID   hour  ID            departure  arrival
2014-08-12 12:35:36  1        6470       South to Federal Triangle  64       6464164  12    6464164_6470  0          0
2014-08-12 12:35:46  1        6470       South to Federal Triangle  64       6464164  12    6464164_6470  0          0
2014-08-12 12:35:57  0        6470       South to Federal Triangle  64       6464164  12    6464164_6470  0          0
2014-08-12 12:36:38  0        6470       South to Federal Triangle  64       6464164  12    6464164_6470  0          0
2014-08-12 12:36:48  0        6470       South to Federal Triangle  64       6464164  12    6464164_6470  0          0
2014-08-12 12:36:58  0        6470       South to Federal Triangle  64       6464164  12    6464164_6470  0          1
2014-08-07 10:56:06  98       6482       South to Federal Triangle  64       6464164  10    6464164_6482  1          0
2014-08-07 10:56:16  98       6482       South to Federal Triangle  64       6464164  10    6464164_6482  0          0
2014-08-07 10:56:26  98       6482       South to Federal Triangle  64       6464164  10    6464164_6482  0          0

{% endhighlight %}

**Assumption 1:** When Next Bus says a bus is arriving (`Minutes==0`) multiple times, I take the latest prediction as the actual arrival time.
In other words, I take the last prediction where `Minutes==0` before the bus disappears off your Next Bus app as the arrival time.

## Step 2: Filter
**Assumption 2:** Remove bus trips that never arrive.
There are some ghost buses out there.  It's impossible to determine the error in a prediction if you don't know the outcome (true arrival time), so these trips are removed.


{% highlight R %}

# removing buses that never arrive 
TripsThatArrive <- df$ID[df$arrival==1 & df$Minutes==0]
df <- df[df$ID %in% TripsThatArrive,]

{% endhighlight %}

## Step 3: Calculate error in Next Bus predictions
Now that we know the arrival times for each bus trip (`df$arrival`), the prediction in minutes until arrival (`df$Minutes`) 
and the time the prediction was made (`df$time`), we can figure calculate the prediction error (`df$err`) and actual time until arrival (`df$est`).

{% highlight R %}
# finding actual prediction-to-arrival times
df$est <- 0
for(i in 1:nrow(depart)) {
  tname <- names(depart)[i]
  df$est[df$ID==tname] <- (df$time[df$ID==tname & df$arrival==1] - df$time[df$ID==tname])/60
}

# finding prediction errors
df$err <- df$est - df$Minutes
{% endhighlight %}

## Step 4: Write out data to csv

Easy enough.  This is the data that will feed the d3 visualizations built in the [next post](../nextbus4_viz).

{% highlight R %}
write.table(df, file='/Users/ajb/Documents/github/nextbus/data/cleanTrips.csv', row.names=F, sep=',')
{% endhighlight %}





<!-- Next to add: 

* make app work on default view
* add a vertical line to the histogram, or highlight the bar or something to indicate where the current selection is
* add hourly window slider at the bottom that allows to see what 5 minutes looks like at midday vs rush hour
* add text to app that says:
    On average: 5 minutes really means 6.5 minutes
    On a late days*: 5 minutes could mean 12 minutes or more
    On an early day*: 5 minutes could mean 4 minutes

    * late days are the latest 10%      of predictions
    * early dats are the earliest 10% of predictions

* add error scatter chart
* add scroll scatter plot (maybe) 
    http://bl.ocks.org/stepheneb/1182434
    http://jsfiddle.net/PyvZ7/7/ -->