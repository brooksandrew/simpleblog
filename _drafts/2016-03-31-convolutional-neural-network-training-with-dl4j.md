---
layout: post
title: Exploring convolutional neural networks with DL4J
date: 2016-03-31
categories: articles
tags: [data science, Scala, sbt, Eclipse, DeepLearning4j, deep learning image processing, image recognition, computer vision, Kaggle, Yelp]
comments: true
share: true
---

* Table of Contents
{:toc}

## Motivation

**TL;DR version:** This post walks through an image classification problem hosted on Kaggle for Yelp.  The project uses Scala, DeepLearning4J and convolutional neural networks and code is on Github [here].

### Why...

This project was motivated by a personal desire of mine to:  
  1. explore deep learning on a computer vision problem.  
  2. implement an end-to-end data science project in Scala.     
  3. build an image processing pipeline using real images.

Rather than using with the [MNIST] or [CIFAR] datasets with pre-processed and standardized images, I wanted to go with a more "wild" dataset of "real-world" images.  

I opted for the [Kaggle Yelp Restaurant Photo Classification] problem.  The ~200,000 training images are raw uploads from Yelp users from mobile devices or cameras with a variety of sizes, dimensions, colors and quality.  

### What I did instead...

I was initially going to document this project end-to-end from image processing to training the convolutional neural networks.  However upon more research and practice actually tuning convolutional networks, I've reconsidered my process.  The Kaggle Yelp Photo Classification problem is a novel problem, however it turns out to not be a great match with the deep learning techniques I wanted to explore.  Thus this article will focus mainly on the image processing pipeline using Scala.  While I may introduce DL4J here, I plan to discuss my experience with it in more detail in a forthcoming post.

### The Kaggle problem

The Kaggle problem is this.  Yelp wants to auto-classify restaurants on the 9 charateristics below:

	0. good_for_lunch
	1. good_for_dinner
	2. takes_reservations
	3. outdoor_seating
	4. restaurant_is_expensive
	5. has_alcohol
	6. has_table_service
	7. ambience_is_classy
	8. good_for_kids

Each restaurant has some number of images (several to several hundred).  However there are no restaurant features beyond these images.  Thus it is a [multiple-instance learning] problem where each business in the training data is represented by its bag of images.  

This is also a [multiple-label classification] problem where each business can have one or more of the 9 characteristics listed above.

### Inital approach

To deal with the **multiple-instance issue**, I simply applied the labels of the restaurant to all of the images associated with it and treated each image as a separate record.  

To deal with with the **multiple-label problem**, I simply handled each class as a separate binary classification problem.  While there are breeds of neural networks capable of classifying multiple labels, such as [BP-MLL] (backpropagation for multilabel learning), these are not currently available in DL4J.

### Pivot

While I didn't expect my initial approach would land me at the top of the Kaggle leaderboard, I did expect it would allow me to improve the benchmark while exploring new and untested (to me) tools and techniques: DeepLearning4j, Scala and convolutional nets.  That assumption turned out to bigger than I expected

The noise-to-signal ratio was too high with the Yelp data to train a meaningful convolutional network given my self-imposed constraints.  From what I've deduced from the [Kaggle forum], most teams are using pre-trained neural networks to extract features from each image.  From there it can be tackled as a classical (non-image) classification problem with crafty feature creation and aggregation to the image to restaurant level.  

While this is far more computationally efficient and could yield better predictions, it cuts out exactly the part I wanted to explore.  I eventually compromised with myself and decided to re-factor the image pipeline I developed for this project for a similar better posed problem (CIFAR or a self created problem scraping images from [image-net])

## Approach

### Image processing

### Training convolutional networks

### Recommended next steps from the DL4J examples

* use multiple epochs and minibatches (fit more data into memeory)
* utilize deeplearning4j-ui tool if possible
* try one convolutional layer at first.  adding additional layers can certainly improve results, but with so many parameters to tune, optimizing a single layer first will help reduce complexity
* ask questions on Gitter!  Also search directly in Gitter







<!-- Links -->
[here]: https://github.com/brooksandrew/kaggle_yelp
[Kaggle Yelp Restaurant Photo Classification]: https://www.kaggle.com/c/yelp-restaurant-photo-classification
[MNIST]: https://en.wikipedia.org/wiki/MNIST_database
[CIFAR]: https://www.cs.toronto.edu/~kriz/cifar.html
[multiple-instance learning]: https://en.wikipedia.org/wiki/Multiple-instance_learning
[multiple-label classification]: https://en.wikipedia.org/wiki/Multi-label_classification
[BP-MLL]: http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.507.910&rep=rep1&type=pdf
[Kaggle forum]: https://www.kaggle.com/c/yelp-restaurant-photo-classification/forums
[image-net]: http://www.image-net.org/