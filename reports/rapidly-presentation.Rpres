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
For training was used SwiftKey 560MB text dataset, containing crawled text data from the internet: news, blog posts, tweets.  

#### Rapidly:
- has an average time <strong>13.5 msec</strong>* to make a prediction
- has an accuracy at a level of <strong>29.3%</strong> on the out of sample data
- <strong>no RAM</strong> used for storing data
- takes <strong>6,5 hours</strong>* to clean dataset and build an SQLite database
- database of 5 tables and a number of indices occupies <strong>97MB</strong> of disk space

*on VirtualBox machine under Ubuntu Guest OS, 2 cores from Intel Core i5 @2.50GHz, 8GB RAM and SSD

How Rapidly works
========================================================
#### Five independent parts:
 - <strong>Data cleaner</strong> performs string manipulations on the input corpora, preparing data samples in form of files.
 - <strong>Builder</strong> creates the dictionary of words present in training sample and then extracts word n-grams from the text data. Filters out the words and n-grams with low frequency. Results are saved in the SQLite database.
 - <strong>Predictor</strong> implements and applies the predictive model on the prepared database and returns suggestions on a request.
 - <strong>Benchmark</strong> is a tiny tool to evaluate accuracy and performance of the predictor.
 - <strong>WebApp</strong> is a Shiny web application, that enables access to Rapidly features with a handy UI.

A closer look at the model
========================================================
The database contains separate tables for each of 2-, 3-, 4-, 5-grams with their respective frequency greater than 5. 
#### Predictor:
- queries as many as possible tables depending on input size
- if a single word is missing in the dictionary, Predictor masks that word and matches any word on that particular position (multiple missing words don't make sense)
- 5 most frequent next-words in each table are sent to the model
- the model applies coefficients to all candidates and summarises the score for each next-word
- 3 words, that got the highest score, are returned 

The Shiny web application
========================================================
With the help of this WebApp, a user can further explore the data and the prediction algorithm.
- <strong>Next word suggestions</strong> tab allows one to try the main feature: get suggestions on the next word while typing
- <strong>Prediction exploration</strong> tab displays how the prediction was made in details. Each step is screened with all the related data to explore the effectiveness of the model.
- <strong>Word presence exploration</strong> tab allows user to explore a word's usage in the language, as it appeared in the training corpora 

https://mooromets.shinyapps.io/rapidly/
