function [population,fitness]=crossover(population,firstParentId,secondParentId,probCross,shapley,fitness,classifierType,paramValue,fold)
    % function to perform crossover and MI guided mutation
    
    global MI;
    rng('shuffle');
    [rows,cols]=size(population);    
    child(1,1:cols)=population(firstParentId,:);
    child(2,1:cols)=population(secondParentId,:);

    % crossover
    for loop=1:cols
        if(rand(1)<=probCross)
            temp=child(1,loop);
            child(1,loop)=child(2,loop);
            child(2,loop)=temp;
        end
    end
    
    % MI guided mutation
    mutCount=int16((cols*5)/100);
    for loop=1:mutCount
        point=int16(rand(1)*(cols-1))+1;
        if(rand(1)<=MI(1,point))
            child(1,point)=1;
		else
			child(1,point)=0;
        end

        point=int16(rand(1)*(cols-1))+1;
        if(rand(1)<=MI(1,point))
            child(2,point)=1;
		else 
			child(2,point)=0;
        end
    end

    % evaulate child chromosomes
    [child(1,:),fitnessFirstChild]=evaluate(child(1,:),classifierType,paramValue,fold,shapley);
    [child(2,:),fitnessSecondChild]=evaluate(child(2,:),classifierType,paramValue,fold,shapley);

    % replacement in the original population
    for loop = 1:rows
        if(chromosomecomparator(population(loop,1:cols),fitness(loop),child(1,1:cols),fitnessFirstChild)<0)
            fprintf('Replaced chromosome at %d in crossover with first\n',loop);
            population(loop,1:cols)=child(1,1:cols);
            fitness(loop)=fitnessFirstChild;          
            break;
        end
    end

    for loop = 1:rows
        if(chromosomecomparator(population(loop,1:cols),fitness(loop),child(2,1:cols),fitnessSecondChild)<0)
            fprintf('Replaced chromosome at %d in crossover with second\n',loop);
            population(loop,1:cols)=child(2,1:cols);
            fitness(loop)=fitnessSecondChild;
            break;
        end
    end
end


function [val]=chromosomecomparator(origPopulation,origAccuracy,child,childAccuracy)
    % compares the child chromosomes to the parent chromosomes in terms of fitness
    % returns -1 if child is fitter, +1 if parent is fitter

    [~,cols]=size(origPopulation);

    count1=(sum(origPopulation(1:cols)==0));
    count2=(sum(child(1:cols)==0));    

    if count1==cols
            val=-1;

    elseif count2==cols
            val=1;

    elseif ((abs(origAccuracy-childAccuracy) > .01) || (count1==count2))
        if origAccuracy>childAccuracy
            val=1;
        else
            val=-1;
        end

    elseif ((origAccuracy>=childAccuracy) && (count1>=count2))
        val=1;

    elseif ((origAccuracy<=childAccuracy) && (count1<=count2))
        val=-1;

    else
        w1=1;w2=4;
        count1=count1/cols;
        count2=count2/cols;
        val=((w1*count1)+(w2*origAccuracy))-((w1*count2)+(w2*childAccuracy));
        if val>0
            val=1;
        elseif val<0
            val=-1;
        end
    end
end