# EpilepsyAdmissions

## Spatial Regression
In this project we will be looking at epilepsy admission in Australia. The data is from PHIDU and used 2018 admission data. The data exist as raw admission data which describe the number of cases per Local Government Area (LGA). Administrative data such as LGA is also viewed as areal data. Analysis of areal data uses aggregate count rath than individual data. This issue will become apparent later when we discuss regression. 

To determine hot spots, we need to first calculate the standardised epilepsy admission ratio. This ratio is calculated by dividing the number of cases by the expected number of cases. As such it takes taking into account the number of admissions as well as the population. Following this initial step we can perform regression analysis to evaluate the contribution of the explanatory variables or covariates. .These variables are related to areal unit and can include the number of General Practitioners, age >60 or the number of people who are obese or have diabetes. Back to areal data, we are not using the individual person’s history of obesity or diabetes but the aggregate count of cases with obesity or diabetes and so on. 

Due to the influence of neighbouring areas, we cannot assume that the number of epilepsy admissions in one LGA is independent of its neighbours. Spatial autocorrelation or clustering of cases can be tested by using Moran I test. We also need to construct a way of assessing adjacent LGA or neighbourhood. In this project we used a Queen’s movement in chess to define neighbourhood as any point of contact along the border of LGA.

Spatial regression uses strategies, described below. There are different libraries available in R to perform spatial regression. This project focusses on the use of INLA to perform spatial regression. The R-INLA package can be downloaded from http://www.r-inla.org/. Integrated Nested Laplace Approximation (INLA) uses Bayesian Inference, which first finds prior distributions of parameters before considering the observed data. INLA approximates the posterior distribution of parameters by computing the likelihood of the prior distributions based on observed data. There are different models available in the R-INLA package. In this project we used six models. The first is the baseline Fixed Effects Model, a multivariate Poisson regression model, that only considers explanatory variables. The second model has both fixed effects as well as random effects.

The third, the Intrinsic Conditional Autoregression (ICAR) or Besag Model, has a spatial random component. The Besag, York and Mollié (BYM) model, is an extension of the Besag Model, as it has both an ICAR component and a non-spatial random component. The Leroux Model combines aspects of the Besag and the BYM Models. The Spatial Lag Model considers both the covariate values of the LGA, as well as the values of the neighbouring regions' response variable.

Criteria, such as the Deviance Information Criterion (DIC) and the Watanabe-Akaike information criterion (WAIC) can be used to see which models are better. The lower the DIC and WAIC, the better the model fit.

## Data
The shapefiles for the 2016 Local Government Areas were from the Australian Bureau of Statistics (ABS). The 2018 Median Income data for each LGA is also from the ABS. Data on epilepsy was obtained from the PHIDU website.
![image](https://user-images.githubusercontent.com/78997343/176580204-8bcfffec-7b58-4b81-9047-997ada862a2d.png)
