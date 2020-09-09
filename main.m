%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  CGA source codes version 1.0                                     %
%                                                                   %
%  Developed in MATLAB R2016a                                       %
%                                                                   %
%   Main Paper: Guha, R., Khan, A.H., Singh, P.K. et al.            %
%   CGA: a new feature selection model for visual human action      %
%   recognition. Neural Comput & Applic (2020).                     %
%   https://link.springer.com/article/10.1007/s00521-020-05297-5    %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[] = main(datasetName,numAgents,numIteration,numRuns,classifierType,paramValue)
    warning off;
    global train trainLabel test testLabel fold MI

    % import the dataset
    data=importdata(strcat('Data/', datasetName, '_data.mat'));

    % extract train and test data along with their labels
    train = data.train;
    trainLabel = data.trainLabel;       
    test = data.test;    
    testLabel = data.testLabel;

    % initial dimension reduction
    franks=franking(train, trainLabel);
    numFeatures=min(200, size(test,2));
    train=train(:,franks(1:numFeatures));    
    test=test(:,franks(1:numFeatures));    
    
    % initialize your variable here
    methodName='CGA';
    minFeaturePercentage=30;                            % min percentage of features to be selected in the initial population
    maxFeaturePercentage=80;                            % max percentage of features to be selected in the initial population
    mcross=int16(5);                                    % maximum number of crossovers in GA
    fold=3;                                             % number of folds for crossvalidation
    probMutation=rand(1);                               % probability for mutation
    shapley=zeros(1,numFeatures)+probMutation;          % shapley value initialization for the features
    MI=mutualInformation(train,trainLabel);             % mutual information scores for the features

    if ~exist('Results','dir')
        mkdir('Results')
    end
    
    for runNo=1:numRuns
        
        fprintf('\n\n-------------- Run %d --------------\n\n', runNo);
        % run starts
        if ~exist(strcat('Results/', datasetName),'dir')
            mkdir(['Results/'],[datasetName])
        end
        mkdir(['Results/' datasetName '/'],['Run_' int2str(runNo)]);               
        
        % memory initialization
        memory.population=zeros(2*numAgents,numFeatures);
        memory.accuracy=zeros(1,2*numAgents);
        memory.fitness=zeros(1,2*numAgents);
        memory.finalPopulation=zeros(0,0);
        memory.finalAccuracy=zeros(0,0);        
        
        % population initialization
        population=dataCreate(numAgents,numFeatures,minFeaturePercentage,maxFeaturePercentage);            
        
        tic
        for iterNo=1:numIteration
            
            fprintf('\n\n-------------- Iteration %d --------------\n\n', iterNo);
            % iteration starts
            mkdir(['Results/' datasetName '/Run_' int2str(runNo)],['Iteration_' int2str(iterNo)]);    
            
            % evaluation of initial population
            [population,fitness,accuracy]=evaluate(population,classifierType,paramValue,fold,shapley); 

            limit = randi(mcross-2,1)+2;

            fprintf('\n\n=========== Crossover starts ===========\n\n')
            % crossover and mutation begins
            for loop1=1:limit  
                
                % roulette wheel selection
                fitnessCS(1:numAgents)=fitness(1:numAgents);
                for loop2= 2:numAgents
                    fitnessCS(loop2)=fitnessCS(loop2)+fitnessCS(loop2-1);
                end
                maxcs=fitnessCS(numAgents);
                for loop2= 1:numAgents
                    fitnessCS(loop2)=fitnessCS(loop2)/maxcs;
                end            
                firstParentId=find(fitnessCS>rand(1),1,'first');
                secondParentId=find(fitnessCS>rand(1),1,'first');             
                probCross=rand(1); 
                
                % crossover-mutation
                [population,fitness]=crossover(population,firstParentId,secondParentId,probCross,shapley,fitness,classifierType,paramValue,fold);
                fprintf('\n');
            end
            fprintf('\n\n=========== Crossover ends ===========\n\n')
            
            % update memory after crossover-mutation
            memory=updateMemory(memory,population,fitness,accuracy);   
            displayMemory(memory);            
            saveFileName = strcat('Results/',datasetName,'/Run_',int2str(runNo),'/Iteration_',int2str(iterNo),'/',datasetName,'_result_',methodName,'_pop_',int2str(numAgents),'_iter_',int2str(numIteration),'_',classifierType,'_',int2str(paramValue),'.mat');
            save(saveFileName,'memory'); 
            fprintf('\n\ndata saved.........\n')
            
            % coalition or cooperative game begins
            fprintf('\n\n=========== Entering coalition game ===========\n\n')
            [shapley]=coalitionGame(train,trainLabel,population);   
        end

        time=toc;

        % evaluate and update the final population to the memory
        [population,fitness,accuracy]=evaluate(population,classifierType,paramValue,fold,shapley);
        memory=updateMemory(memory,population,fitness,accuracy);
        [memory.finalPopulation,memory.finalAccuracy]=populationRank(population,classifierType,paramValue);
        displayMemory(memory);
        mkdir(['Results/' datasetName '/Run_' int2str(runNo)],'Final');
        saveFileName = strcat('Results/',datasetName,'/Run_',int2str(runNo),'/Final/',datasetName,'_result_',methodName,'_pop_',int2str(numAgents),'_iter_',int2str(numIteration),'_',classifierType,'_',int2str(paramValue),'.mat');
        save(saveFileName,'memory','time');
        fprintf('\n\ndata saved.........\n')
    end
end

function [memory]=updateMemory(memory,population,fitness,accuracy)    
    % function for updating the memory

    numAgents=2*size(population,1);
    temp1=fitness';
    temp2=memory.fitness';    
    temp1=[temp2;temp1];
    memory.accuracy=[memory.accuracy accuracy];
    memory.population=[memory.population;population];
    memory.fitness=[memory.fitness fitness];
    [~,index]=sort(temp1,'descend');
  
    memory.accuracy=memory.accuracy(1,index');
    memory.population=memory.population(index,:);
    memory.fitness=memory.fitness(1,index');

    memory.accuracy=memory.accuracy(1,1:numAgents);
    memory.population=memory.population(1:numAgents,:);
    memory.fitness=memory.fitness(1,1:numAgents);
end

function []=displayMemory(memory)
    % function for displaying the memory
    
    fprintf('\n\n=========== Current Memory ===========\n\n')
    numAgents=size(memory.accuracy,2);    
    fprintf('\nIntermediate Memory - \n');
    for loop=1:numAgents/2
        fprintf('numFeatures - %d\tAccuracy - %f\n',sum(memory.population(loop,:)),memory.accuracy(loop));
    end
    numAgents=size(memory.finalAccuracy,2);
    if (numAgents > 0)
        fprintf('\nFinal Memory - \n');
        for loop=1:numAgents
            fprintf('finalNumFeatures - %d\tfinalAccuracy - %f\n',sum(memory.finalPopulation(loop,:)),memory.finalAccuracy(loop));
        end
    end    
end

