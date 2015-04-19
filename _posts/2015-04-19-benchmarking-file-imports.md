---
layout: post
title: Benchmarking file imports
category: r
comments: true
tags: -r
---

Recently, [Hadley Wickham](http://had.co.nz/) announced the release of [readr](http://cran.r-project.org/web/packages/readr/) package v0.1.0. Having been written using [Rcpp](http://dirk.eddelbuettel.com/code/rcpp.html), this package claims to read tabular data into R in a fast and friendly manner. 

I decided to benchmark `read_csv()` from the readr package for a large csv file with base `read.csv()` function and `fread()` from the [data.table](http://cran.r-project.org/web/packages/data.table/) package, which is written in C. 

I use the `flights` data from [nycflights13](http://cran.r-project.org/web/packages/nycflights13/) package.


```r
library(nycflights13)
write.csv(flights, "flights.csv")
```

The *flights.csv* file gets extracted as a 25.5MB CSV file on my Windows machine. 


```r
library(rbenchmark)
library(data.table); library(readr)

## Read using read.csv() function from base
read.base <- function(x){
  read.csv("flights.csv")
}

## Read using read_csv() function from readr
read.readr <- function(x){
  read_csv("flights.csv")
}

## Read using fread() function from data.table
read.DT <- function(x){
  read_csv("flights.csv")
}

benchmark(
  read.base(),
  read.readr(),
  read.DT(),
  replications = 10
  )
```

```
##           test replications elapsed relative user.self sys.self user.child
## 1  read.base()           10   31.79    3.315     31.39     0.33         NA
## 3    read.DT()           10    9.59    1.000      9.53     0.07         NA
## 2 read.readr()           10    9.61    1.002      9.50     0.10         NA
##   sys.child
## 1        NA
## 3        NA
## 2        NA
```

Both `fread()` and `read_csv()` provide us with significant improvement in timings.

Let's tweak the `read.csv()` function to read the all the columns as characters (which supposedly improves performance).


```r
## Read using read.csv() function from base
read.base2 <- function(x){
  read.csv("flights.csv", colClasses = "character")
}

benchmark(
  read.base(),
  read.base2(),
  read.readr(),
  read.DT(),
  replications = 10
  )
```

```
##           test replications elapsed relative user.self sys.self user.child
## 1  read.base()           10   30.41    2.993     29.95     0.37         NA
## 2 read.base2()           10   26.14    2.573     25.46     0.42         NA
## 4    read.DT()           10   10.21    1.005     10.01     0.07         NA
## 3 read.readr()           10   10.16    1.000     10.08     0.04         NA
##   sys.child
## 1        NA
## 2        NA
## 4        NA
## 3        NA
```

Though the performance of `read.csv()` functions improves, it does not even come closer to that of function from readr or data.table packages.

Thanks, Hadley Wickham, Romain Francois for readr; Matt Dowle et.al. for data.table. Now I can read my data much more quickly and efficiently.
