# Rapidly - a smart keyboard
The project started as a capstone project for Data Science specialization from JHU at Coursera.  
Smart keyboards are widely used and developed these days as the number of mobile devices grows every year.  
Rapidly not only provides a quick and accurate prediction on the next word but also have a web application that allows easily investigate algorithms and models to enhance them or build new ones.  
  
A five-slide presentation is available at RPubs http://rpubs.com/mooromets/336933  
Web application https://mooromets.shinyapps.io/rapidly/  

## Getting Started

### Prerequisistes
An input text corpora must be placed in data/final/ dir in the project root.
### Building
All commands are performed in R console.
To clean data 
```
source('script/clean.R')
```
To train on cleaned data
```
source('script/clean.R')
```
To create SQLite DB on trained model
```
source('script/createDB.R')
```
To test the prediction
```
source('script/modeling.R`)
```

## Testing

All unit tests are in tests/ dir  
To run all tests
```
source('script/run-tests.R')
```

## Deploy Web application
```
source('script/deploy.R')
setwd('./deploy/')
deployApp()
```
## Authors

* **Sergey Sambor** - *Initial work* - [mooromets](https://github.com/mooromets)

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details  
