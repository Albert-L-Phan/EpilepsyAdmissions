# EpilepsyAdmissions

## Spatial Regression
In this project we will be looking at seizure admission in Australia. The data is from PHIDU and the admission data used is from 2018. The data exist as raw admission data which describe the number of cases per Local Government Area (LGA). Administrative data such as LGA can be considered as areal data. Analysis of areal data uses aggregate count rather than individual data. For example, rather than looking at each person in an LGA and their individual risk factors for seizures, this analysis will aggregate the risk count for seizures for each LGA. This issue will become apparent later when we discuss regression.

To determine hot spots, we need to first calculate the standardised seizure admission ratio. This ratio is calculated by dividing the number of cases by the expected number of cases. As such it takes taking into account the number of admissions as well as the population. Following this initial step, we can perform regression analysis to evaluate the contribution of the explanatory variables or covariates to the standardised seizure admission ratio. These variables are related to areal unit, with this project looking into 18 variables. These variables included either access to healthcare (2 variables), socioeconomic factors (1 variable) or measurements of health (15 variables). Examples of measurements of health included the number of people in an LGA who smoke, are obese or have diabetes.

Due to the influence of neighbouring areas, we cannot assume that the number of seizure admissions in one LGA is independent of its neighbours. Therefore, to test for spatial autocorrelation or clustering of cases, a Global Moran I test was used. Here, if Moran’s I is positive and close to 1, it means that the data of one LGA is strongly correlated to its neighbours. Conversely, a result close to 0 suggests that the data in each LGA is independent of one another. However, as a Global Moran I test only provides an indication whether there is overall clustering, it may not show clustering at the local scale. In other words, while the data for LGAs of one region may show no correlation to one another, in another region, there may be some clustering. Hence, this study also used a Local Moran I test to see whether this was the case. From this, we could find clustering at the local scale.

We also need to construct a way of assessing which LGAs are adjacent. In this project we used a Queen’s movement in chess to define neighbourhood as any point of contact along the border of LGA. In other words, two LGAs that share a border are considered to be neighbours, hence the data of one LGA may influence the variables of the neighbouring LGA.

To perform spatial regression, there are different libraries available in R. This project focusses on the use of Integrated Nested Laplace Approximation (INLA) to perform spatial regression as it is quicker compared to others such as WinBUGS, which uses Markov Chain Monte Carlo methods. The R-INLA package can be downloaded from http://www.r-inla.org/. INLA uses Bayesian Inference, which first finds prior distributions of parameters before considering the observed data. INLA approximates the posterior distribution of parameters by computing the likelihood of the prior distributions based on observed data.

There are different models available in the R-INLA package. In this project we used six models. The first is the baseline Fixed Effects Model, a multivariate Poisson regression model, that only considers explanatory variables. The second model has both fixed effects as well as random effects. The third, the Intrinsic Conditional Autoregression (ICAR) or Besag Model, has a spatial random component. The Besag, York and Mollié (BYM) model, is an extension of the Besag Model, as it has both an ICAR component and a non-spatial random component. The Leroux Model combines aspects of the Besag and the BYM Models. The Spatial Lag Model considers both the covariate values of the LGA, as well as the values of the neighbouring regions' response variable.

Criteria, such as the Deviance Information Criterion (DIC) and the Watanabe-Akaike information criterion (WAIC) can be used to see which models are better. The lower the DIC and WAIC, the better the model fit. For example, the six choropleth maps for Victoria below show each model predicting the standardised seizure admission ratio, with the number of General Practitioners in an LGA being the covariate. As the Besag, York and Mollié (BYM) model has the lowest DIC and WAIC (261.57 and 252.27, respectively), this model would be considered the best for this covariate.

The six choropleth maps for Australia also have the number of General Practitioners in an LGA being the covariate. Some LGAs are not shaded in because the seizure admissions data was not available.



## Data
The shapefiles for the 2016 Local Government Areas were from the Australian Bureau of Statistics (ABS). The 2018 Median Income data for each LGA is also from the ABS. Data on epilepsy was obtained from the PHIDU website.

![image](https://user-images.githubusercontent.com/78997343/201897520-09d3281e-7dae-4e75-9fda-f56923723ce5.png)
![image](https://user-images.githubusercontent.com/78997343/201898762-3ce615a0-9822-49b1-a129-bdbe691c1027.png)

![image](https://user-images.githubusercontent.com/78997343/202053906-2eb71584-b3fe-46e9-9223-bbb2dd548f5d.png)

