---
layout: post
title:   "How accurate is Next Bus I: extracting data from API"
date:   2014-08-28
categories: articles
tags: [data science, nextbus, api, python]
comments: true
share: true
---

**Motivation:** If you're a bus-rider and public transportation enthusiast like myself, you probably use Next Bus -- well I do anyway.
Next Bus is great (usually).  It tells me exactly how many minutes I have until the bus rolls up to my bus stop... when it's right.

Having missed my fair share of early buses and waiting for what seems like ages when Next Bus continuously predicts just a few more minutes, 
I thought it would be an interesting and worthwhile problem to investigate... and also a good excuse to experiment working with some APIs 
and cool intereactive visualizations using JavaScript and D3.  So I sought out to determine how accurate Next Bus predictions really are.


**Disclaimer:** I use R and Python on a regular basis for scripting and data analysis.  I've worked with APIs before, but am by no means an expert.  
This is my first real venture into JavaScript and D3, so this is much more of an experiment than an expert-guide.  Anyhow, this is what I did.

I live in DC, so I tapped the [WMATA (Washington Metropolitan Area Transit Authority)](http://www.wmata.com/) API for my data.
I live in a house, which is near a bus stop, so I pulled predictions for my bus stop (selfish, I know) every 10 seconds for about a week.

**First: Get API key:** Pretty straightforward.  You can register in a couple clicks [here](http://developer.wmata.com/io-docs).  

**Second: Access data from API:** I found a great library that made this pretty simple: [python-wmata](https://github.com/bycoffe/python-wmata) from [bycoffe](https://github.com/bycoffe) on Github. 



{% highlight python %}

import datetime
from urllib import urlencode
from urllib2 import urlopen

try:
    import json
except ImportError:
    import simplejson as json


class WmataException(Exception):
    pass


class Wmata(object):

    base_url = 'http://api.wmata.com/%(svc)s.svc/json/%(endpoint)s'

    def __init__(self, apikey):
        self.apikey = apikey

    def _build_url(self, svc, endpoint, query={}):
        query.update({'api_key': self.apikey})
        url = self.base_url % {'svc': svc, 'endpoint': endpoint}
        return '%s?%s' % (url, urlencode(query))

    def _get(self, svc, endpoint, query={}):
        self.url = self._build_url(svc, endpoint, query)
        response = urlopen(self.url)

        if response.msg == 'OK':
            self.data = json.loads(response.read())
            return self.data

        raise WmataException('Got invalid response from WMATA server: %s' % response.msg)

    def lines(self):
        return self._get('Rail', 'JLines')['Lines']

    def stations(self, line_code):
        return self._get('Rail', 'JStations', {'LineCode': line_code})['Stations']

    def station_info(self, station_code):
        return self._get('Rail', 'JStationInfo', {'StationCode': station_code})

    def rail_path(self, from_station_code, to_station_code):
        return self._get('Rail', 'JPath', {'FromStationCode': from_station_code, 'ToStationCode': to_station_code})['Path']

    def rail_predictions(self, station_code='All'):
        return self._get('StationPrediction', 'GetPrediction/%s' % station_code)['Trains']

    def rail_incidents(self):
        return self._get('Incidents', 'Incidents')

    def elevator_incidents(self, station_code='All'):
        return self._get('Incidents', 'ElevatorIncidents', {'StationCode': station_code})

    def station_entrances(self, latitude=0, longitude=0, radius=0):
        return self._get('Rail', 'JStationEntrances', {'lat': latitude, 'lon': longitude, 'radius': radius})['Entrances']

    def bus_routes(self):
        return self._get('Bus', 'JRoutes')['Routes']

    def bus_stops(self):
        return self._get('Bus', 'JStops')['Stops']

    def bus_schedule_by_route(self, route_id, date=None, including_variations=False):
        if date is None:
            date = datetime.date.today().strftime('%Y-%m-%d')
        if including_variations:
            including_variations = 'true'
        else:
            including_variations = 'false'
        return self._get('Bus', 'JRouteSchedule', {'routeId': route_id, 'date': date, 'includingVariations': including_variations})

    def bus_route_details(self, route_id, date=None):
        if date is None:
            date = datetime.date.today().strftime('%Y-%m-%d')
        return self._get('Bus', 'JRouteDetails', {'routeId': route_id, 'date': date})

    def bus_positions(self, route_id, including_variations=False):
        if including_variations:
            including_variations = 'true'
        else:
            including_variations = 'false'
        return self._get('Bus', 'JBusPositions', {'routeId': route_id, 'includingVariations': including_variations})['BusPositions']

    def bus_schedule_by_stop(self, stop_id, date=None):
        if date is None:
            date = datetime.date.today().strftime('%Y-%m-%d')
        return self._get('Bus', 'JStopSchedule', {'stopId': stop_id, 'date': date})

    def bus_prediction(self, stop_id):
        return self._get('NextBusService', 'JPredictions', {'stopId': stop_id})

{% endhighlight python %}

With this `Wmata` class, here's the fastest way to access the API:

{% highlight python %}

runfile('python-wmata.py') # running code above that defines the class `Wmata` 
api = Wmata('kfgpmgvfgacx98de9q3xazww') # put your API key here
stopid = '1003043' # put your bus stop ID here
buspred=api.bus_prediction(stopid) # hitting API

{% endhighlight %}

which returns something like this when you `print buspred`:

{% highlight python %}

>>> print buspred

{u'Predictions': [{u'DirectionNum': u'1',
   u'DirectionText': u'South to Federal Triangle',
   u'Minutes': 19,
   u'RouteID': u'64',
   u'TripID': u'6783533',
   u'VehicleID': u'6495'},
  {u'DirectionNum': u'1',
   u'DirectionText': u'South to Federal Triangle',
   u'Minutes': 41,
   u'RouteID': u'64',
   u'TripID': u'6783534',
   u'VehicleID': u'2100'}].
u'StopName': u'New Hampshire Ave + 7th St'}


{% endhighlight %}

Pretty fast!  Here's the first function I wrote to actually process the pulled data from the API.  It's pretty simple -- it parses the JSON object 
pulled from the API into an array with the useful bits of information we want to save.


{% highlight python %}
###############################
## parses JSON bus prediction times 
###############################
import json
import datetime
import time
import datetime

def extractPred(buspred):
    now = datetime.datetime.now()
    preds = len(buspred.items()[1][1])
    v=[]
    if(preds>0):
        for b in range(0, preds): 
            v1=now
            v2=buspred['Predictions'][b]['Minutes']
            v3=buspred['Predictions'][b]['VehicleID']
            v4=buspred['Predictions'][b]['DirectionText']
            v5=buspred['Predictions'][b]['RouteID']
            v6=buspred['Predictions'][b]['TripID']
            v.insert(b, [v1,v2,v3,v4,v5,v6])
    return v
 
{% endhighlight %}

Here's what it does.  It actually transforms the JSON into an array of arrays.  Each array is a prediction for a different bus.
This happens for the same reason that when you check Next Bus on your phone, you see predictions for the next 2 or 3 buses en route towards your stop. 
In this example one bus is 19 minutes away while another is 41 minutes away.

{% highlight python %}

>>> print extractPred(buspred)

[[datetime.datetime(2014, 9, 11, 22, 58, 11, 776324),
  19,
  u'6495',
  u'South to Federal Triangle',
  u'64',
  u'6783533'],
 [datetime.datetime(2014, 9, 11, 22, 58, 11, 776324),
  41,
  u'2100',
  u'South to Federal Triangle',
  u'64',
  u'6783534']]
{% endhighlight %}

I probably could have skipped this step and transformed the the JSON directly to a flat file (or database), but this was made the most sense to me at the time
and it works.


`write2text` is the function that I initialize with the information I want to extract from the API and let rip for an hour, day, week, or however long you want to save predictions for.
It's basically a big wrapper around `extractPred`.  It writes the predictions to a .txt file every 10 seconds, or however often you specify with the `freq` argument.

* `filename` is the name of the output .csv datafile where results will be written
* `freq` is the frequency in seconds that the function will make a call to the API
*  `mins` is the number of minutes the function will run for 
* `stopid` is the ID for the bus-stop you want to pull data for

{% highlight python %}

import csv
import datetime
import time
def write2text(filename, freq=10, mins=10, stopid='1003043'):
    with open(filename, 'wb') as outcsv:   
        writer = csv.writer(outcsv, delimiter='|', lineterminator='\n') 
        writer.writerow(['time', 'Minutes', 'VehicleID', 'DirectionText', 'RouteID', 'TripID'])
        stime = datetime.datetime.now()
        while datetime.datetime.now() < stime + datetime.timedelta(minutes=mins):
            try:
                time.sleep(freq)
                buspred=api.bus_prediction(stopid)         
                tmp = extractPred(buspred)   
                NumOfLists = sum(isinstance(i, list) for i in tmp)
                print buspred
                print('numOfLists', NumOfLists)
                if(NumOfLists>1):
                    for i in tmp:
                        writer.writerow([i[0], i[1], i[2], i[3], i[4], i[5]])
                        print([i[0], i[1], i[2], i[3], i[4], i[5]])
                elif(len(tmp)==5): 
                    writer.writerow([tmp[0], tmp[1], tmp[2], tmp[3], tmp[4], tmp[5]])
                else:
                    writer.writerow([datetime.datetime.now(), 'NA', 'NA', 'NA', 'NA', 'NA', 'NA'])
            except:
                print [datetime.datetime.now(), 'some error...']
                pass
        outcsv.close()
 
{% endhighlight %}

Now we can start harvesting data.  I used an old laptop and let it rip for a week by running the code below by setting `min=60*24*7`.

{% highlight python %}

api = Wmata('kfgpmgvfgacx98de9q3xazww')  # put your API key here
stopid = '1003043'  # put your bus stop ID here
buspred=api.bus_prediction(stopid) 
write2text('data/bus64_outputData.txt', freq=10, mins=60*24*7) # start hitting API

{% endhighlight %}

Here's what the a snippet of the collected data (`bus64_outputData.txt`) looks like:

{% highlight bash%}
time                            Minutes  VehicleID  DirectionText                  RouteID  TripID
2014-08-04 18:43:33.525000      17       6506       South to Federal Triangle      64       6464186
2014-08-04 18:43:33.525000      37       7228       South to Federal Triangle      64       6464187
2014-08-04 18:43:33.525000      56       7235       South to Federal Triangle      64       6464188
2014-08-04 18:43:33.525000      80       7231       South to Federal Triangle      64       6464189
2014-08-04 18:43:43.868000      17       6506       South to Federal Triangle      64       6464186
2014-08-04 18:43:43.868000      37       7228       South to Federal Triangle      64       6464187
{% endhighlight %}


So now we've collected a lot of data from Next Bus.  I got ~190,000 rows for one bus stop for just one week.  So what do we do with it all?
Checkout the [next post](../nextbus2_wrangle).



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