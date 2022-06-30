# EpilepsyAdmissions

## Spatial Regression
Regression is where we estimate the number of epilepsy admissions in a Local Government Area (LGA) based upon explanatory variables. These variables can include the number of General Practitioners or the number of people who are obese. Due to the influence of neighbouring areas, we cannot assume that the number of epilepsy admissions in one LGA is independent of its neighbours. This We can see whether there is a clustering of epilepsy admissions using a Moran I test. 

Spatial regression uses strategies, described below, to account for this clustering. There are different libraries available in R to perform spatial regression. These libraries include INLA and rstan. This project focusses on the use of INLA to perform spatial regression. 

### INLA
The R-INLA package can be downloaded from http://www.r-inla.org/. Integrated Nested Laplace Approximation (INLA) uses Bayesian Inference, which first finds prior distributions of parameters before considering the observed data. INLA approximates the posterior distribution of parameters by computing the likelihood of the prior distributions based on observed data.  

There are different models available in the R-INLA package. In this project we used six models. The first is the baseline Fixed Effects Model which only considers explanatory variables. The second, the Mixed Effects Model considers both explanatory variables and a random Gaussian distributed component as parameters. 

The Besag model takes into account both the explanatory variables of each area and its neighbours. The fourth model, the Besag, York and Mollié (BYM) model, is an extension of the Besag Model. It includes the explanatory variables of each area and its neighbours and also has a a random Gaussian distributed component. 

The Leroux Model 

Spatial Lag Model

Criteria, such as the Deviance Information Criterion (DIC) and the Watanabe-Akaike information criterion (WAIC) can be used to see which models are better. The lower the DIC and WAIC, the better the model. 

## Data
The shapefiles for the 2016 Local Government Areas were from the Australian Bureau of Statistics (ABS). The 2018 Median Income data for each LGA is also from the ABS. Data on epilepsy was obtained from the PHIDU website.
![image](https://user-images.githubusercontent.com/78997343/176580204-8bcfffec-7b58-4b81-9047-997ada862a2d.png)
