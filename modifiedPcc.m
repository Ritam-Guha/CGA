function [val]=modifiedPcc(data,population)      
    % function to calculate modified pearson correlation coefficients of the features

    [numAgents,cols]=size(population);
    pccVal=corr(data);    
    val=zeros(1,cols);

    % checks the discriminating power of the features wrt other features present in the population
    for loop1=1:cols
        for loop2=1:numAgents
            ind=0;dep=0;
            for loop3=1:cols
                if loop1~=loop3
                    if population(loop2,loop3)==1 
                        if abs(pccVal(loop1,loop3)) > 0.5
                            dep=dep+1;
                        else
                            ind=ind+1;
                        end
                    end
                end
            end

            curImp=double(ind/dep);

            if(~isinf(curImp))
                val(1,loop1)=val(1,loop1)+curImp;
            end
        end
    end  
    val=(val-min(val))/(max(val)-min(val));
end
