function [population,accuracy]=populationRank(population,classifierType,paramValue)
    % function to rank the population according to their classification abilities

    global train trainLabel test testLabel
    rng('shuffle');
    [row,col]=size(population);
    temp=zeros(1,col);
    accuracy=zeros(1,row);
        for loop1=1:row
            [accuracy(1,loop1)]=classify(train,trainLabel,test,testLabel,population(loop1,:),classifierType,paramValue);
        end
        
        for loop2 =1:row
            for loop3 =1:row-1
                if ((accuracy(1,loop3)<accuracy(1,loop3+1))||(accuracy(1,loop3)==accuracy(1,loop3+1) && sum(population(loop3,:)==1)>sum(population(loop3+1,:)==1)))
                    val=accuracy(1,loop3);
                    accuracy(1,loop3)=accuracy(1,loop3+1);
                    accuracy(1,loop3+1)=val;

                    temp(1:col)=population(loop3,1:col);
                    population(loop3,1:col)=population(loop3+1,1:col);
                    population(loop3+1,1:col)=temp(1:col);
                end                   
            end
        end
end
