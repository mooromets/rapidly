<style>
.reveal h1,
.reveal h2,
.reveal h3{
   margin-bottom: .6em;
   color: #95a5a6;
   font-weight: bold;
}
.reveal h4,
.reveal h5,
.reveal h6 { 
   margin-bottom: .6em;
   color: #2C3E50;
   font-size: 120%
}

.reveal p,
.reveal table {
   margin-bottom: 1em; 
   color: #2C3E50;
}

.reveal li {
   margin-bottom: .4em;
   color: #2C3E50;
}

.section .reveal .state-background {
  background: #2C3E50;
}

.section .reveal h1,
.section .reveal p {
    color: #18BC9C;
    position: relative;
    top: 4%;
}

.reveal strong {
  color: #18BC9C;
}

.rap {
  color: #18BC9C;
  font-weight: 900;
}

</style>

Rapidly. A smart keyboard
========================================================
author: Sergey Sambor 
date: 2017-12-01
autosize: true
font-family: 'Lato'
transition: rotate

Executive Summary
========================================================
For training was used SwiftKey 560MB text dataset, containing crawled text data from internet: news, blog posts, twitts.  

#### Rapidly:
- has an average time <strong>13.5 msec</strong>* to make a prediction
- has an accuracy at a level of <strong>29.3%</strong> on the out of sample data
- <strong>no RAM used</strong> for storing data
- takes <strong>8 hours</strong>* to clean dataset and build a SQLite database
- database of 5 tables and a number of indecies occupies <strong>120MB</strong> of disk space

*on VirtualBox machine under Ubuntu Guest OS, 2 cores from Intel Core i5 @2.50GHz, 8GB RAM and SSD

How Rapidly works
========================================================
#### Five independent parts:
 - <strong>Data cleaner</strong> performes string manupulations on the input corpora, preparing data samples in form of files.
 - <strong>Builder</strong> creates dictionary of words present in training sample and then extracts word n-grams from the text data. Filters out the words and n-grams with low frequency. Results are saved into the SQLite database.
 - <strong>Predictor</strong> implements and applies the predictive model on the prepared database and returns suggestions on a request.
 - <strong>Benchmark</strong> is tiny tool to evaluate accuracy and performance of the predictor.
 - <strong>WebApp</strong> is a Shiny web application, that enables access to Rapidly features with a handy UI.

A closer look at the model
========================================================
The database, created by Builder, contain 4 tables: 2-, 3-, 4-, 5-grams. Each table contains one, two, three or four predictor words respectively, one predicted (the next) word and a frequency of appearance this combination in the input corpora.
#### Predictor:
- queries all tables for which it is enough words that user has put in
- if any word is missing from dictionary, Predictor masks it and queries any word matching in this particular position in a phrase (multiple missing words are not allowed as it doesn't make sence)
- the probabilitiy is calculated for 5 most frequent next-words in each table 
- model applies coefficients to all candidates, and summarises the score for each word
- 3 words, that got the highest score, are returned 

The Shiny web application
========================================================
With the help of this WebApp a user can further explore the data and the prediction algorithm.
- <strong>Next word suggestions</strong> tab allows one to try the main feature: get suggestions on the next word while typing
- <strong>Prediction exploration</strong> tab displays how the prediction was made in details. Each step is screened with all the related data to explore effectiveness of the model.
- <strong>Word presence exploration</strong> tab allowes user to explore a word's usage in the language, as it appeared in the training corpora 

https://mooromets.shinyapps.io/rapidly/