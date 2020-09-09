# MATLAB code for CGA: Cooperative Genetic Algorithm

### Paper Reference - Guha, R., Khan, A.H., Singh, P.K. et al. CGA: a new feature selection model for visual human action recognition. Neural Comput & Applic (2020). https://link.springer.com/article/10.1007/s00521-020-05297-5.

## Dataset Links

* Weizmann: Blank M, Gorelick L, Shechtman E, et al (2005) Actions as space-time shapes. In: Tenth IEEE International Conference on Computer Vision (ICCV’05) Volume 1. IEEE, pp 1395–1402
* KTH: Schuldt C, Laptev I, Caputo B (2004) Recognizing human actions: a local SVM approach. In: Proceedings of the 17th International Conference on Pattern Recognition, 2004. ICPR 2004. IEEE, pp 32–36
* UCF: Liu J, Luo J, Shah M (2009) Recognizing realistic actions from videos in the wild. In: IEEE conference on computer vision and pattern recognition. Citeseer, pp 1996–2003
* HMDB: Kuehne H, Jhuang H, Garrote E, et al (2011) HMDB: a large video database for human motion recognition. In: 2011 International conference on computer vision. IEEE, pp 2556–2563
* UCI HAR: Anguita D, Ghio A, Oneto L et al (2013) A public domain dataset for human activity recognition using smartphones. In: Esann
* UCI HAR in Ambient Assisted Living: Anguita D, Ghio A, Oneto L, et al (2012) Human activity recognition on smartphones using a multiclass hardware-friendly support vector machine. In: International workshop on ambient assisted living. Springer, pp 216–223

## Preparation of datasets

Format the datasets using the following steps:

* Video datasets
1. Capture proper frames from the videos.
2. Extract appropriate features from the frames.
3. Label each frame according to the human activity being performed.
4. Keep the features and labels in a single .xlsx file.
5. Run 'fileCreate.m' present in the Data directory as *fileCreate(xlsx file name, training percentage)* [for KTH: *fileCreate('KTH', 70)*]


* Sensor datastes
1. Keep the features and labels in a single .xlsx file.
2. Run 'fileCreate.m' present in the Data directory.

fileCreate creates the necessary train-test divisioned .mat file.

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

Example: *main('KTH', 30, 20, 10, 'knn', 5)*

Link for algorithm details: [Paper](https://link.springer.com/article/10.1007/s00521-020-05297-5)

## Abstract:

Recognition of human actions from visual contents is a budding field of computer vision and image understanding. The problem with such a recognition system is the huge dimensions of the feature vectors. Many of these features are irrelevant to the classification mechanism. For this reason, in this paper, we propose a novel feature selection (FS) model called cooperative genetic algorithm (CGA) to select some of the most important and discriminating features from the entire feature set to improve the classification accuracy as well as the time requirement of the activity recognition mechanism. In CGA, we have made an effort to embed the concepts of cooperative game theory in GA to create a both-way reinforcement mechanism to improve the solution of the FS model. The proposed FS model is tested on four benchmark video datasets named Weizmann, KTH, UCF11, HMDB51, and two sensor-based UCI HAR datasets. The experiments are conducted using four state-of-the-art feature descriptors, namely HOG, GLCM, SURF, and GIST. It is found that there is a significant improvement in the overall classification accuracy while considering very small fraction of the original feature vector.

## CGA flowchart

<b>Cooperative Genetic Algorithm</span></b><br>
<p align="center">  
  <img src="https://github.com/Ritam-Guha/CGA/blob/master/Images/CGA.png">
</p><br>

## Dataset samples

<b>HMDB samples</span></b><br>
<p align="center">  
  <img src="https://github.com/Ritam-Guha/CGA/blob/master/Images/HMDB%20samples.png">
</p><br>
  

<b>KTH samples</span></b><br>
<p align="center">  
  <img src="https://github.com/Ritam-Guha/CGA/blob/master/Images/KTH%20samples.png">
</p><br>


<b>UCF samples</span></b><br>
<p align="center">  
  <img src="https://github.com/Ritam-Guha/CGA/blob/master/Images/UCF%20samples.png">
</p><br>


<b>Weizmann samples</span></b><br>
<p align="center">  
  <img src="https://github.com/Ritam-Guha/CGA/blob/master/Images/Weizmann%20samples.png">
</p><br>
