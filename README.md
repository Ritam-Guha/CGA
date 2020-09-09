# MATLAB code for CGA: Cooperative Genetic Algorithm

### Paper Reference - Guha, R., Khan, A.H., Singh, P.K. et al. CGA: a new feature selection model for visual human action recognition. Neural Comput & Applic (2020). https://doi.org/10.1007/s00521-020-05297-5.

## Parameters

To Run the code, you need to specify the following parameters for the main function:
* datasetName : name of the input dataset 
* numAgents : count of search agents (chromosomes) in the population
* numIteration : maximum number of iterations allowed
* numRuns : number of times the algorithm will be executed
* classifierType : name of the classifier you want to use (currently there are 3 alternatives - 'mlp'/'knn'/'svm')
* paramValue : parameter value for the selected classifier (number of hidden layers for 'mlp', number of neighbors for 'knn', kernel function for 'svm')

***Apart from these main paramters, there are several other customizations available. Check the main file (section heading 'initialize your variables here') for more information***



## Running the code
* Set all the required parameters
* run file main.m

Example: main('KTH', 30, 20, 10, 'knn', 5)

Link for algorithm details: [Paper](https://link.springer.com/article/10.1007/s00521-020-05297-5)

## Abstract:

Recognition of human actions from visual contents is a budding field of computer vision and image understanding. The problem with such a recognition system is the huge dimensions of the feature vectors. Many of these features are irrelevant to the classification mechanism. For this reason, in this paper, we propose a novel feature selection (FS) model called cooperative genetic algorithm (CGA) to select some of the most important and discriminating features from the entire feature set to improve the classification accuracy as well as the time requirement of the activity recognition mechanism. In CGA, we have made an effort to embed the concepts of cooperative game theory in GA to create a both-way reinforcement mechanism to improve the solution of the FS model. The proposed FS model is tested on four benchmark video datasets named Weizmann, KTH, UCF11, HMDB51, and two sensor-based UCI HAR datasets. The experiments are conducted using four state-of-the-art feature descriptors, namely HOG, GLCM, SURF, and GIST. It is found that there is a significant improvement in the overall classification accuracy while considering very small fraction of the original feature vector.

## Dataset samples

<center>HMDB samples</center>
<p align="center">  
  <img src="https://github.com/Ritam-Guha/CGA/blob/master/Images/HMDB%20samples.png"><br>
</p>
  

  *KTH samples*
  ![KTH samples](https://github.com/Ritam-Guha/CGA/blob/master/Images/KTH%20samples.png)
</center>
