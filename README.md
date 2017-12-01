# Travel-Assist

## 1. Introduction
When planning any trip, one question that comes to everyone’s mind is - how can I find best accommodation, flights and restaurants? In achieving this goal, one has to spend a lot of time researching through mass of information on the internet, reading through reviews, to make a decision if particular choice is fit for them. With Sentiment analysis using Travel Ontology, the idea is to simplify this process to the user. This includes, creating travel ontology using hotels, restaurants and airline data and combining them with sentiment analysis. Sentiment Analysis is the process of determining whether a piece of writing is positive, negative or neutral to learn how customer feels about the service/product. The semantic web built will help reduce the gap between the mass of user reviews and its analysis to the user. 
##  2. Motivation
With overloaded information and reviews available on different travel web sites, user is not able to make an informed decision for planning their travel. There is a lack of intuitive and convenient way which could help the user plan the trip based on user reviews. Also there are chances that the website recommendations are biased towards the certain companies.  As a solution to this challenge, Travel Assistant is developed.

 ## 3. Travel Assistant
Travel Assistant is ontology based tool that assists travellers to provide recommendations for hotels, restaurants and airline while planning their trip. It also enables user to apply filters to the search results based on preferred features. These feature lists are mined from the user reviews and hence has not just standard features like WiFi but also noise level for restaurant.
Since Travel Assistant searches based on chosen features, it eliminates the issues of being biased to interest group/company.

## 4. Architecture
Travel Architecture has four main important modules.
* User Interface
* SPARQL Engine
Ontology Knowledge Base
NLP Engine

Customer  interacts with user-interface and searches  for his/her choice of restaurants, hotels or  airlines. The request is handled by SPARQL Engine in backend which queries the knowledge base and returns the result to the user. The knowledge base receives the sentiment analysis for the user reviews from NLP Engine, which reads the preprocessed data from raw data sources and sends the  sentiment scores for features to knowledge base. 



## 5. Ontology Knowledge Base
Three types of raw data is used to create travel ontology , which are then processed and stored in Knowledge Base.
Hotel Data
Restaurant Data
Airline Data
Raw data contains user reviews.  They are extracted, preprocessed and fed into NLP Engine to identify the features and its sentiment scores. Data from the NLP Engine is fed into ontology knowledge base.





## 6. Project Phases:
The various stages of our project right from inception to tool development are as follows:

* Data Collection
* Sentiment Engine
* Semantic model 
* Data ingestion
* SPARQL querying and results

### 6.1 Data Collection
In this phase we have collected hotel, restaurant and airline data from various sources. We were able to collect data from multiple sources but Yelp and Kaggle datasets matched our requirements. Currently, we are dealing with 4 major US tourist cities:
* San Francisco
* Las Vegas
* New York City
* Chicago
     
We were able to fetch and process 160k restaurant reviews from Yelp datasets,  130k reviews on hotels and 15k airline reviews from Kaggle. After the data collection, it underwent cleaning and pre-processing before being fed to the semantic model.

Data Pre-Processing: The collected data underwent the following changes before getting fed into the semantic model:
Detecting and removing irrelevant information from the data collected. For example, log data collected from Yelp had time stamp at the beginning of each review. In order to avoid inaccuracy in the sentiment engine, we removed the timestamp using Python data munging techniques.
Importing data from source (text files) and dumping  into csv files using Python scripts
Data cleaning like removing special characters, missing values using Excel

### 6.2  Sentiment Analyzer Engine: 
The pre-processed data obtained in the previous phase is fed into the NLP engine or Sentiment Analyzer Engine. The main purpose of this stage is to obtain the list of services(entities) a user can be interested in and provide a corresponding sentiment score to the entities. The main challenges involved in this phase include Lemmatization and Stemming. This stage is broken down into two steps:
Entity Selection
Calculation of Sentiment Score

Entity Selection: In the stage we annotate the user reviews using Named Entity Recognition Algorithm. It involves extracting and classifying entities out of user reviews and obtaining an exhaustive list of entities. We run the Named Entity Recognition Algorithm across all the reviews per domain level and take a subset of entities which are of high interest across all the reviews based on a threshold value.

Calculation of Sentiment Score: A Sentiment score is calculated for the subset of entities obtained in previous step using Google  Cloud Natural Language API. Structure and meaning of text is calculated which in turn is represented in the form of Sentiment Score. 

The list of entities and their corresponding sentiment score is fed to the Ontology builder for creating the semantic model.   

### 6.3 Ontology Building

Protege 5.2.0 is used to design the ontology. There are seven classes within the travel ontology (Hotel, Airline, Restaurant, City, Area, Services and Contact).  Each hotel, airline and restaurant has been linked to their respective City, Area and URL.  

Services class has 27 data properties.  For example, Service score of a hotel or whether a airline provides WiFi . Most of the services contain sentiment scores obtained by user reviews while the rest indicate if the entity(hotel,airline or restaurant) offers that particular service(e.g. Whether restaurants have Smoking area). 

### 6.4  Data Ingestion 

Hotel, Airline and Restaurant data obtained from feature level semantic analysis is stored in CSV format. Data is added to ontology using Apache Jena Ontology API with Java as programming language. Using the csv files and OWL file as input, instances are added to ontology using CreateIndividual method. Object properties  including their domain and range are written to Ontology with createObjectProperty. Instances belonging to different classes are linked by object properties using Jena.  Data properties are appended using createDataProperty method. Data properties for instances are added with addDataProperty method. The RDF triples generated in Jena are stored in Turtle format. 

### 6.5  SPARQL Querying & Results

Apache Jena Fuseki has been used as localhost server to query the RDF triples.  There are four different queries that can be run on the dataset:

1) Best rated hotels or hotels with specific features within a particular location.
2) Popular restaurants or restaurants offering services  in specific city.
3) Prefered airlines or airlines with set of features to destinations.
4) Best hotels along with their nearby restaurants in a city.

#### 6.5.1 R Shiny User Interface

R shiny is an R package that makes it easy to build interactive web apps straight from R. You can host standalone apps on a webpage or embed them in R Markdown documents or build dashboards. We can also extend Shiny apps with CSS themes, htmlwidgets, and JavaScript actions.

Shiny combines the computational power of R with the interactivity of the modern web.

Figure: User Interface that the user views when he lands on the tool
Figure: Deeper Analysis of the hotel and restaurant's data
## 7. Challenges
Data Cleaning: Dealing with UTF encoding- We had to clean the data and remove special characters which would otherwise hinder in the process of the NLP and create inaccuracies in the model
Data Filtering and Feature Selection - We had to spend time and run statistical tests to determine which features were more important and useful  for the user
Data Sources: Varied data sources - We had a variety of data sources which we had to unify before using it for the backend computation and NLP ready. 
Exploring various technologies like Karma for data ingestion, SentiNet for NLP Engine and deciding the right one using trial and error - For the purposes of Named Entity 
Retrieval and Sentiment Analysis - We tried many tools and technologies until we got what we desired. We finally settled for Google Natural Language API provided on Google compute engine.  Learning new technologies like Jena, implementing dynamic SPARQL query for multiple selected features in R Shiny was something we implemented for the first time and was a great addition to our skillset. 
## 8. Future Work
Scaling to other major cities in world which tourists most popularly travel to regularly. Expanding to handheld devices by creating mobile friendly application. We can look for creating personalization/recommendation engine on top of sentiment analyzer by user behavior using machine learning techniques. Adding other domains like tourist attractions, In city travel and nearby clubs  while planning the trip. Providing user feature to communicate with existing reviewers in our tool can be another useful feature

