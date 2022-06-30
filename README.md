# EpilepsyAdmissions

## Spatial Regression
Multivariate linear regression is where we estimate the number of epilepsy admissions in a Local Government Area (LGA) based upon explanatory variables, such as the number of General Practitioners or the number of people who are obese. However, this assumes that the number of epilepsy admissions in one LGA is independent of its neighbours. We can see whether there is a clustering of epilepsy admissions using a Moran I test. 

Spatial regression accounts for this clustering. There are different models, such as the Spatial Durbin Model and the Spatial Error Model, which consider different aspects of relatedness between neighbours. (The Spatial Durbin Model takes into account the neighbouring epilepsy and explanatory values, while the Spatial Error Model takes into account the neighbouring residual values). 
## INLA


## Data
The shapefiles for the 2016 Local Government Areas were from the Australian Bureau of Statistics. The 2018 Median Income data for each LGA is also from the ABS. I got the 2018 Epilepsy Data from PHIDU. 
