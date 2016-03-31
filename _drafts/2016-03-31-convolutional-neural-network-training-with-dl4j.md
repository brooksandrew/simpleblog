---
layout: post
title: Exploring convolutional neural networks with DL4J
date: 2016-03-31
categories: articles
tags: [data science, Scala, sbt, Eclipse, DeepLearning4j, deep learning image processing, image recognition, computer vision]
comments: true
share: true
---

* Table of Contents
{:toc}

## Motivation

This project was motivated by a personal desire of mine to:  
  1. explore deep learning on a computer vision problem.  
  2. implement an end-to-end data science project in Scala.     
  3. build an image processing pipeline myself using real images

Rather than using with the [MNIST] or [CIFAR] datasets with pre-processed and standardized images, I wanted to go with a more "wild" dataset of "real-world" images.  

I opted for the [Kaggle Yelp Restaurant Photo Classification] problem.  The ~200,000 training images are raw uploads from Yelp users from mobile devices or cameras with a variety of sizes, dimensions and quality.  

## Problem








<!-- Links -->

[Kaggle Yelp Restaurant Photo Classification]: https://www.kaggle.com/c/yelp-restaurant-photo-classification
[MNIST]: https://en.wikipedia.org/wiki/MNIST_database
[CIFAR]: https://www.cs.toronto.edu/~kriz/cifar.html