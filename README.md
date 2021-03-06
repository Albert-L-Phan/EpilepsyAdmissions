# EpilepsyAdmissions

## Spatial Regression
Regression is where we estimate the number of epilepsy admissions in a Local Government Area (LGA) based upon explanatory variables. These variables can include the number of General Practitioners or the number of people who are obese. Due to the influence of neighbouring areas, we cannot assume that the number of epilepsy admissions in one LGA is independent of its neighbours. We can see whether there is a clustering of epilepsy admissions using a Moran I test. 

Spatial regression uses strategies, described below, to account for this clustering. There are different libraries available in R to perform spatial regression. These libraries include INLA and rstan. This project focusses on the use of INLA to perform spatial regression. 

### INLA
The R-INLA package can be downloaded from http://www.r-inla.org/. Integrated Nested Laplace Approximation (INLA) uses Bayesian Inference, which first finds prior distributions of parameters before considering the observed data. INLA approximates the posterior distribution of parameters by computing the likelihood of the prior distributions based on observed data.  

There are different models available in the R-INLA package. In this project we used six models. The first is the baseline Fixed Effects Model, a multivariate Poisson regression model, that only considers explanatory variables. The second model has both fixed effects as well as random effects, which is Gaussian distributed. 

The third, the Intrinsic Conditional Autoregression (ICAR) or Besag Model, has a spatial random component. The Besag, York and Mollié (BYM) model, is an extension of the Besag Model, as it has both an ICAR component and a non spatial random component. The Leroux Model combines aspects of the Besag and the BYM Models. he Spatial Lag Model considers both the covariate values of the LGA, as well as the values of the neighbouring regions' response variable. 

Criteria, such as the Deviance Information Criterion (DIC) and the Watanabe-Akaike information criterion (WAIC) can be used to see which models are better. The lower the DIC and WAIC, the better the model. 

## Data
The shapefiles for the 2016 Local Government Areas were from the Australian Bureau of Statistics (ABS). The 2018 Median Income data for each LGA is also from the ABS. Data on epilepsy was obtained from the PHIDU website.
![image](https://user-images.githubusercontent.com/78997343/176580204-8bcfffec-7b58-4b81-9047-997ada862a2d.png)
