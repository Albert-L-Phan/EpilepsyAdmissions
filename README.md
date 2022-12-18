# EpilepsyAdmissions

## Spatial Regression
In this project we will be looking at seizure admissions in Australia. The data is from PHIDU and the admission data used is from 2018. The data exist as raw admission data which describe the number of cases per Local Government Area (LGA). Administrative data such as LGA can be considered as areal data. Analysis of areal data uses aggregate count rather than individual data. For example, rather than looking at each person in an LGA and their individual risk factors for seizures, this analysis will aggregate the risk count for seizures for each LGA. This issue will become apparent later when we discuss regression.

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


## Hospital Catchments
The aim of this project is to construct the hospital catchments for seizure admissions in Australia. The data from PHIDU contained seizure admissions data in 2018, as well as the number of general practitioners and number of specialists in each LGA. As this data is for LGAs only, to convert the data such that it reflects the hospital catchments, a weighted average of the data for all the LGAs in the hospital catchment was performed, taking into consideration the population of each LGA. The data exists in tabular form with the number of admissions per Local Government Area (LGA) for Australia. The dataset only contains information for this year. A caveat is that there is missing data on seizure admission within the centre and Northern part of Australia. 

The data on LGA comes from the Australian Bureau of Statistics (ABS). Here, each LGA is an administrative region governed by a council. The ABS provides shapefiles which outlines the borders of each LGA in Australia. The ABS updates the borders of LGAs every 5 years to reflect changes in population. This study used the shapefiles that were released in 2016. Since these shapefiles showed Australia’s population from 2016-2021, they represented the 2018 data available from PHIDU. 

To construct hospital catchment areas for seizure admissions, we need to determine which hospital was closest to each LGA. We use centroids or centre of each LGA as the point to measure the distance to the hospital. This study only focused on hospitals with neurology units as not all hospitals have the same level of resources or provide the same services. From this, we constructed a distance matrix that showed the distance between each centroid and all the hospitals that had neurology units.

Using the distance matrix, the closest hospital to each LGA centroid was evaluated. From there, all the LGAs that had the same hospital listed as the closest ones were grouped together and were considered as the catchment for that hospital. 


Using this data, we then plotted choropleth maps which showed the number of seizure admissions in each hospital catchment, along with other data such as the number of general practitioners or specialists in each hospital catchment. 


## Formal Concept Analysis 
Formal concept analysis enables us to find a hierarchy based on the attributes certain objects share. Before we discuss formal concept analysis, we need to define a few terms. Firstly, we need a matrix which shows the relationships between the objects and attributes. This matrix is called the formal context. This matrix shows which attributes an object has using binary notation. Secondly, a concept refers to a group of objects that share attributes in common, with no other object outside of the group having these same attributes. For each concept, there is an extent and an intent. The intent of a concept is the attributes that the objects have in common, while the extent refers to the objects in the group. 

In our matrix, the hospitals are the objects. In this study, we were interested in which hospitals a person with status epilepticus should go to based on where they live. Thus, we need two types of attributes which describe the hospitals. These encompass geographic aspects (whether a hospital is close to an LGA) or hospital resources (for example, whether a hospital has an intensive care unit, or whether they have a neurology unit). Thus, a concept is a group of hospitals that have the same resources and relative geographic location, with the intent referring to the resources that the hospitals have, as well as the LGAs which are close to the hospitals. The extent are the hospitals themselves.  

Concepts can be subsets of other larger concepts. For example, for a particular LGA, there may be two hospitals nearby. The first only has a emergency department, while the second has both an emergency department, as well as an intensive care unit. Since the second hospital has all of the attributes of the first hospital (as well as more), the concept that contains the first hospital is a subset of the concept that contains the second hospital. 

To be able to find which concepts are subsets of others and determine the hierarchy of hospitals, we used the R package fcaR. From this, we showed the hierarchy of hospitals using a Hasse Diagram.  

Hasse Diagrams for an entire state or Australia can be difficult to interpret because there can be many arrows showing the relationships between hospitals. Thus to simplify the Hasse diagram, we can subset the matrix to only include hospitals that are close to a singular LGA. This enables us to see which hospitals a patient living in that LGA should go to.



![image](https://user-images.githubusercontent.com/78997343/208284645-f8fff0bd-3edf-4e42-84ce-69322ea58704.png)

For example, this is the matrix for the LGA Warrnambool. The matrix only includes three hospitals because these were the hospitals that were close to Warrnambool. The first five columns of the matrix show which resources each hospital has. The other columns show whether each hospital is close to an LGA or its neighbours (the only neighbouring LGA is Moyne).

We can make a hierarchy of hospitals using this matrix. For example, South West Healthcare is a subset of Ballarat Health Services, since Ballarat Health Services has all of the attributes that South West Healthcare has. Thus, South West Healthcare would be considered a lower level compared to Ballarat Health Services. Likewise, Ballarat Health Services is a subset of University Hospital Geelong. We can show the relationships between the hospitals using the Hasse Diagram below: 

The is the Hasse Diagram for Warrnambool, a rural local government area in south west Victoria. 
![image](https://user-images.githubusercontent.com/78997343/208233942-df5aeeb1-8b03-4ba0-bc2f-de5cfe8a0ab7.png)



This is the Hasse Diagram for the local government area Melbourne.
![image](https://user-images.githubusercontent.com/78997343/208291392-b0bd9e70-988e-4cf9-a45f-e1799544b668.png)
Here, Williamstown Hospital and Western Hospital have less hospital resources than Royal Melbourne Hospital (RMH), thus appear lower on the Hasse Diagram. While the Alfred and St Vincent's Hospital have the same number of resources as RMH, they appear lower because they are further away from the centre of the Melbourne LGA compared to RMH. 



