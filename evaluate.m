function [population,fitness,accuracy]=evaluate(population,classifierType,paramValue,fold,shapley)
    % function to evaluate the candidate solutions under consideration

    fitness=zeros(1,size(population,1));

    % set the importance of accuracy, number of features and shapley score in fitness evaluation
    impAcc=0.5;
    impNumFeatures=0.2;
    impShapley=0.3;

    % crossvalidate the current population 
    [population,accuracy]=crossValidate(population,classifierType,paramValue,fold);

    [numAgents,numFeatures]=size(population);    

    % calculate fitness for every agent in the population
    for loop=1:numAgents
        shapleyVal=mean(shapley(1,population(loop,:)==1));       
        fitness(1,loop) = impAcc*(accuracy(1,loop)/100) + impNumFeatures*(sum(population(loop,:)==0)/numFeatures) + impShapley*shapleyVal;
    end

    % sort the population in decreasing order of fitness
    [fitness,index]=sort(fitness,'descend');
    population=population(index,:);
end