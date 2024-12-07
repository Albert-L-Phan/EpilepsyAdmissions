# EpilepsyAdmissions

## Spatial Regression
In this project we will be looking at seizure admissions in Australia. The data is from Public Health Information Development Unit (PHIDU), which contains information from 2021. This data shows the number of seizure admissions for each public administration region in Australia, or Local Government Area (LGA). As such, rather than looking at each person in an LGA and their individual risk factors for seizures, this analysis will aggregate the risk count for seizures for each LGA. This issue will become apparent later when we discuss regression.

To determine hot spots, we need to first calculate the standardised seizure admission ratio (SMR). The SMR for each LGA is calculated by dividing the number of cases by the expected number of cases. As such it takes taking into account the number of admissions as well as the population. Following this initial step, we can perform regression analysis to evaluate the contribution of the explanatory variables or covariates to the standardised seizure admission ratio. These variables are related to areal unit, with this project looking into 15 variables. These variables included age and sex, access to healthcare (2 variables), socioeconomic factors (3 variables) and measurements of health (8 variables). Examples of measurements of health included the number of people in an LGA who have heart disease or diabetes.

Due to the influence of neighbouring areas, we cannot assume that the SMR in one LGA is independent of its neighbours. Therefore, to test for spatial autocorrelation we calculated the Global Moran's I. Here, if Global Moran’s I is positive and close to 1, it means that the data of one LGA is strongly correlated to its neighbours. Conversely, a result close to 0 suggests that the data in each LGA is independent of one another. Negative spatial autocorrelation, where neighbouring LGA's have different values, is shown by a negative Global Moran's I. We also need to construct a way of assessing which LGAs are adjacent. In this project we used a Queen’s movement in chess to define neighbourhood as any point of contact along the border of LGA. In other words, two LGAs that share a border are considered to be neighbours, hence the data of one LGA may influence the variables of the neighbouring LGA.

To perform spatial regression, there are different libraries available in R. This project focusses on the use of Integrated Nested Laplace Approximation (INLA) to perform spatial regression as it is quicker compared to others such as WinBUGS, which uses Markov Chain Monte Carlo methods. The R-INLA package can be downloaded from http://www.r-inla.org/. INLA uses Bayesian Inference, which first finds prior distributions of parameters before considering the observed data. INLA approximates the posterior distribution of parameters by computing the likelihood of the prior distributions based on observed data.

There are different models available in the R-INLA package. In this project we used six models. The first is the baseline Fixed Effects Model, a multivariate Poisson regression model, which assumes that the SMR of an LGA is only influenced by the explanatory variables of that LGA. The second model is the Random Effects Model, which includes a random effect to account for random noise in the data. The third, the Intrinsic Conditional Autoregression (ICAR) or Besag Model, has a spatial random component, to account for spatial relationships that exist in the data. The Besag, York and Mollié (BYM) model, is an extension of the Besag Model, as it has both an ICAR component and a non-spatial random component. The Leroux Model combines aspects of the Besag and the BYM Models. Unlike the previous models that use spatial random components to account for spatial autocorrelation, the last model, the Spatial Lag Model, uses the SMR of neighbouring LGAs, as an explanatory variable. Since each model has its advantages and disadvantages, we calculated the Deviance Information Criterion (DIC) and the Watanabe-Akaike information criterion (WAIC) to see which models are better for the seizure data. The lower the DIC and WAIC, the better the model fit. 

## Data
We used shapefiles for each LGA to be able to map the SMR across Australia, and to investigate which LGAs were neighbours of one another. These shapefiles were from the Australian Bureau of Statistics (ABS). The 2021 Median Income data for each LGA was obtained from the Australian Bureau of Statistics  (ABS). All other variables used in the spatial regression analysis came from PHIDU. PHIDU obtained variables that measured access to healthcare (for example, number of GPs in each LGA) from the National Health Workforce Dataset. Epilepsy data from PHIDU was obtained from Australian Institute of Health and Welfare, which showed the number of admissions for acute convulsions and epilepsy to public hospitals for each LGA in 2021.


## Hospital Catchments
The aim of this project is to construct the hospital catchments for seizure admissions in Australia. The data from PHIDU contained seizure admissions data in 2018, as well as the number of general practitioners and number of specialists in each LGA. As this data is for LGAs only, to convert the data such that it reflects the hospital catchments, a weighted average of the data for all the LGAs in the hospital catchment was performed, taking into consideration the population of each LGA. The data exists in tabular form with the number of admissions per Local Government Area (LGA) for Australia. The dataset only contains information for this year. A caveat is that there is missing data on seizure admission within the centre and Northern part of Australia. 

The data on LGA comes from the Australian Bureau of Statistics (ABS). Here, each LGA is an administrative region governed by a council. The ABS provides shapefiles which outlines the borders of each LGA in Australia. The ABS updates the borders of LGAs every 5 years to reflect changes in population. This study used the shapefiles that were released in 2016. Since these shapefiles showed Australia’s population from 2016-2021, they represented the 2018 data available from PHIDU. 

To construct hospital catchment areas for seizure admissions, we need to determine which hospital was closest to each LGA. We use centroids or centre of each LGA as the point to measure the distance to the hospital. This study only focused on hospitals with neurology units as not all hospitals have the same level of resources or provide the same services. From this, we constructed a distance matrix that showed the distance between each centroid and all the hospitals that had neurology units.

Using the distance matrix, the closest hospital to each LGA centroid was evaluated. From there, all the LGAs that had the same hospital listed as the closest ones were grouped together and were considered as the catchment for that hospital. 


Using this data, we then plotted choropleth maps which showed the number of seizure admissions in each hospital catchment, along with other data such as the number of general practitioners or specialists in each hospital catchment. 


## Formal Concept Analysis [Old]
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

## Formal Concept Analysis [New]
Formal concept analysis enables us to find a hierarchy based on the attributes certain objects share. In our study, we are interested in finding a hierarchy of hospitals, as it allows us to find which larger hospitals a smaller hospital should refer patients to, as well as catchments of major hospitals. Before we discuss formal concept analysis, we need to define a few terms. Firstly, we need a matrix which shows the relationships between the objects and attributes. This matrix is called the formal context. This matrix shows which attributes an object has using binary notation. Secondly, a concept refers to a group of objects that share attributes in common, with no other object outside of the group having these same attributes. For each concept, there is an extent and an intent. The intent of a concept is the attributes that the objects have in common, while the extent refers to the objects in the group. 

In our matrix the hospitals are both the objects and the attributes. A hospital is considered an attribute of another hospital if the first hospital is nearby and has resources that the second one lacks. This way, the matrix considers both hospital resources (some patients need to be transferred to hospitals with more resources for better patient management) and geographic aspects (patients should be transferred to hospitals nearby) when building the hospital hierarchy. Because hospitals are both the objects and attributes, a concept is therefore a group of higher-level hospitals, and the smaller hospitals that transfer patients to them. 

Concepts can be subsets of other larger concepts. For example, there may be two groups of hospitals, each having a medium-level hospital that smaller hospitals transfer patients to. However, both medium hospitals transfer patients to the same larger level hospital. Since all the patients from the medium and smaller level hospitals can transferred to the larger-level hospital, the larger hospital has all the attributes that the 2 medium hospitals have. Thus, the first two concepts would be subsets of the third concept. 

To be able to find which concepts are subsets of others and determine the hierarchy of hospitals, we used the R package fcaR. From this, we showed the hierarchy of hospitals using a Hasse Diagram.  

Hasse Diagrams for an entire state or Australia can be difficult to interpret because there can be many arrows showing the relationships between hospitals. Thus, we can simply the Hasse diagram to show only relevant information. For example, if a patient lived in an area close to a small hospital, we can isolate the relevant nodes and edges to show only the small hospital, and the larger hospitals it transfers patients to. We could also isolate a major hospital, and the small hospitals that transfer patients to it. From this, we can determine the hospital catchment for that major hospital. 

![image](https://user-images.githubusercontent.com/78997343/218305963-e4b9f283-5088-4b75-bb23-79aa6260de4b.png)
This is the Hasse diagram for a person who lives near Casey Hospital. A patient with seizure will first be admitted to Casey Hospital. If the patient needs to be transferred because they requires services that Casey Hospital does not have, they will be transferred to Dandenong or Frankston Hospital. If the patient has a prolonged seizure and require even more hospital services, they can be transferred to Monash Medical Centre. 

![image](https://user-images.githubusercontent.com/78997343/218306292-169f83dd-b2a7-4a2c-a1fe-e562b0690138.png)
This shows all the hospitals that can transfer patients to Monash Medical Centre. From this, we can construct hospital catchments for major hospitals.

![image](https://user-images.githubusercontent.com/78997343/218308583-c1a1f9cf-4015-468e-81fb-7291f8d4db43.png)
![image](https://user-images.githubusercontent.com/78997343/218308628-e9d52832-33b8-4133-b7fa-d642959794eb.png)

For the two images above, for each LGA, the nearest hospital was found. LGAs that had the same hospital were grouped together and considered as the catchment for that hospital. However, while Monash Medical Centre has more hospital resources than Casey Hospital, it has a smaller catchment using this method. Since Monash Medical Centre is the closest major hospital to Casey Hospital, Casey Hospital can admit patients to Monash Medical Centre. Thus, this method does not reflect the number of patients that are admitted to Monash Medical Centre, and where they are from. Hasse diagrams considers this issue by finding which hospitals are higher level.

![image](https://user-images.githubusercontent.com/78997343/218342779-28b6feb8-659d-4a44-a17e-244fe6203318.png)
The region highlighted in red are the LGAs whose closest hospital can transfer patients to Monash Medical Centre. These hospitals appear lower in the hierarchy depicted in the Hasse Diagram. 

![image](https://user-images.githubusercontent.com/78997343/218344757-cfe98b42-56ed-4f49-ba29-0a2f6ea688c1.png)
Using the same method, we can find catchments for other major hospitals. This is the hospital catchment for Royal Melbourne Hospital.

## Shiny App
Here is the link to the shiny app: https://gntem3.shinyapps.io/epilepsyadmissions/



