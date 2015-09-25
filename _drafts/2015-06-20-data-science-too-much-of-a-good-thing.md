---
layout: post
title: "Data Science: too much of a good thing?"
description: Are university data science programs producing an overly homogenous popuation of data scientists?
date: 2015-06-20
categories: articles
tags: [data science, graduate school, academic, education]
comments: true
share: true
---

* Table of Contents
{:toc}

This may sound blasphemous coming from a data scientist.  It's really more of a open question than a criticism.
Is data science becoming too institutionalized?  Specifically in universities?

Does the establishment of newly created curriculums and academic degrees focused soley on data science threaten to take some of the swag out of it?  Will these programs homogenize a field that has been made rich by the cross pollination of experts from a wide range of disciplines?  Data Science is such a vast and interdisciplinary field; can comprehensive data science university programs produce both experts and generalists?  So much of data science is learned through experimenting in the field; how effective is it to teach data science in a classroom?

I don't have answers to these questions, but they're questions I've thought about.

## Data science is blowing up  

##### LinkedIn Hottest Skills

This is no secret to anyone remotely involved in the data science world.  LinkedIn ranks *Statistical Analysis and Data Mining*
as the [#1 skill that got people hired in 2014 in nearly every country]. [^1].

<iframe src="//www.slideshare.net/slideshow/embed_code/key/DNtKLRJrGJDTYo" width="477" height="510" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong> <a href="//www.slideshare.net/linkedin/the-25-hottest-skills-of-2014-on-linkedin" title="The 25 Hottest Skills of 2014 on Linkedin" target="_blank">The 25 Hottest Skills of 2014 on Linkedin</a> </strong> from <strong><a href="//www.slideshare.net/linkedin" target="_blank">LinkedIn</a></strong> </div>

##### Search terms

Since people started Googling "data science" and "data scientist" in 2011, the rise has been exponential.

<script type="text/javascript" src="//www.google.com/trends/embed.js?hl=en-US&q=%22data+science%22,+%22data+scientist%22&cmpt=q&tz=Etc/GMT%2B4&tz=Etc/GMT%2B4&content=1&cid=TIMESERIES_GRAPH_0&export=5&w=500&h=330"></script>

##### Hype Cycle

Whether the momentum behind the data science movement is sustainable is another question.  Gartner sticks data science directly into the Peak of Inflated Expectations phase on their [hype cycle for emerging technologies].

<img src="/simpleblog/assets/png/gartner-hypecycle-2014-emerging-technologies.jpg" alt="Gartner Emerging Technologies Hype Cycle">

## Danger 1: Homogeneity 

Part of what I love about data science is that no two data scientists have taken the same path.  Nearly everyone, no matter their experience level, will have some skill or unique mindset from their background that no other data scientist on their team has.  Contrast with many other fields where the academic training, knowledge and though processes overlap much more.

In my previous life as an aspiring eonomist, there was a single one-way road, a PhD in economics.  

Jerry Friedman mentions around 5:00 how researchers often make large contributions when they swith fields and bring a fresh outside-of-the-box persepctive.
<iframe width="560" height="315" src="https://www.youtube.com/embed/79tR7BvYE6w" frameborder="0" allowfullscreen></iframe>


## Danger 2: Data Science as a vertical

As an international studies major undergrad, a professor once told me international studies is nothing on its own.  It's the international side and connectivity between other fields that exist on their own: economics, political science, law, language, art, etc.  She encouraged us to pick a focus rather than boiling the ocean trying to learn everything about economics, government, law and how they relate in every corner of the world.  I chose economics and Europe.  As it turns out, I'm pleased with my choice, although I think I'm really just glad I picked something.  

I see data science much the same way.  Data science is about solving complex real-world problems with algorithms.  It needs problems and a domain.  Drew Conway and others declare "Substantive Experience" or "Domain Knowledge"  is one of three core skills.  For most data scientists, especially consultants like myself, much of this substantve expertise is 

## Danger 3: Teaching students what they'll learn on their own

Continuous learning is part of a data scientist's ethos.  What I value most from my undergrad and grad school education are not the one-off lectures we had cool topics, but the hard painful math and statistics background: the kind of stuff that I would find very difficult to do on my own, weekdays after work on Coursera.  Curriculum that emphasizes empowers and teaches students how to learn is more important to me than cramming in a bunch of accelerated tutorials.  Easy for me to say now that I've finished grad school.  If I was my grad school self with current-me interests, I would probably jump ship to an applied data science program if given the oppportunity, rather than slaving away at probability theory or mathematical statistics, which turned out to be two of the most helpful courses I've ever taken.

In some ways, I wonder if data science is like entrepeurship.  [Some](http://www.washingtonpost.com/business/on-small-business/can-you-really-teach-entrepreneurship/2014/03/21/51426de8-a545-11e3-84d4-e59b1709222c_story.html) push for it to be taught in classrooms, while [others](http://www.huffingtonpost.com/michaelprice/3-reasons-why-entrepreneurship_b_5520175.html) say it should be learned in the field instead.  How much and which parts should be taught in schools and what should be left for the field?  It strikes me that the answer to this question is trickier for data science than it is for other fields.


## Danger 4: Mile wide, inch deep

Data Science encompasses many things.

At a [high level](http://drewconway.com/zia/2013/3/26/the-data-science-venn-diagram) (one of the seminal data science venn diagrams):
<img src="/simpleblog/assets/png/Data_Science_VD.png" alt="average prediction error by minute">

At a [granular level](http://nirvacana.com/thoughts/becoming-a-data-scientist/): 
<img src="http://nirvacana.com/thoughts/wp-content/uploads/2013/07/RoadToDataScientist1.png">

My advice to anyone with aspirations of working in data science is quickly scope out and acknowledge the core principles of the field.  Then narrow your focus and drill down.  Pick a tool, pick a technique, and learn it good, real good.  I did this with [LDA](../latent-dirichlet-allocation-under-the-hood) while brushing up on my Python when I had some free time.  I find learning a couple techniques and really understanding the underlying algorithms is more valuable than surface learning a bunch.  Algorithms and programming languages are more similar than they might seem.

It would be nice to see universities with data science programs specialize in some aspect of the field such as model validation techniques in machine learning, distributed computing, or data visualizations, etc.

## Danger 5: Just do it (not)

I majored in Economics and minored in Math as an undergrad.  I coded for mathematical economics and econometrics courses in Python and Stata.  But I never really learned programming until I started working at the Fed where I had real problems and needed to teach myself.  We had models that needed to be run, databases that needed updating, and data products that needed refreshing.  Building and automating programs to do these tasks was what really got me hooked on programming--my gateway drug to data science.  
We had tutorials in college for statistical programming and help from TAs, but it wasn't until my first job where I actually was able to make my life easier with programming.  Part of me is biased, because most things I've learned about data science, I've learned outside of my universities.  








[#1 skill that got people hired in 2014 in nearly every country]:http://blog.linkedin.com/2014/12/17/the-25-hottest-skills-that-got-people-hired-in-2014/

[hype cycle for emerging technologies]:http://www.gartner.com/newsroom/id/2819918

[^1]: *Cloud and Distributed Computing* was #1 in the United States, also a "big-data" skill.  *Statistical Analysis and Data Mining* was #2.