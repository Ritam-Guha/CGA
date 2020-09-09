function [relevance] = mutualInformation(train,trainLabel)
    % function for computing mutual information between training set and labels

    numInstances=size(trainLabel,1);
    class = zeros(numInstances,1);
    for loop=1:numInstances
        class(loop,1)=find(trainLabel(loop,:),1);
    end
    bin = 10;
    numFeatures = size(train,2);
    relevance = zeros(1,numFeatures);
    
    meanFeature = repmat(mean(train),numInstances,1);
    minFeature = repmat(min(train),numInstances,1);
    maxFeature = repmat(max(train),numInstances,1);

    train = (train-meanFeature)./(maxFeature-minFeature);
    train(isnan(train))=0;
    train = (train+1)/2;   
          
    for loop1=1:numFeatures
        relevance(1,loop1) = mutualInformationfC(train(:,loop1),class,bin);
    end
    
end

function [val] = mutualInformationfC(xi,class,bin)
    val = entropy(xi,bin) + entropyClass(class) - jointEntropyClass(xi,class,bin);
end

function [val] = jointEntropyClass(xi,class,bin)
    if(isnan(xi))
        val=0;
        return;
    end        
        edges = 0:(1.0/bin):1;
        listi = discretize(xi',edges);
        if min(class)==0
            class=class+1;
        end
        numFeatures = max(class);
        count = zeros(bin,numFeatures);
        
        if (sum(isnan(listi)) || sum(isnan(class)))
            disp('error');
        end
        for loop=1:size(xi,1)
            count(listi(loop),class(loop)) = count(listi(loop),class(loop))+1;
        end
        count=count/(size(xi,1));
        count=reshape(count,1,(bin*numFeatures));
        val=0;
        for loop=1:size(count,2)
            if count(1,loop)~=0
                val = val + (count(1,loop)*log(count(1,loop)));
            end
        end
        val=-val;
end


function [val] = entropy(xi,bin)
    edges = 0:(1.0/bin):1;    
    list = discretize(xi',edges);    
    if sum(isnan(list))
        disp('error');
    end
    count = zeros(1,bin);
    for loop=1:bin
        count(1,loop) = sum(list==loop);
    end
    count=count/size(xi,1);
    val=0;
    for loop=1:size(count,2)
        if count(1,loop)~=0
            val = val + (count(1,loop)*log(count(1,loop)));
        end
    end
    val=-val;
end

function [val] = entropyClass(class)
    if min(class) == 0
        class=class+1;
    end
    bin=max(class);
    count = zeros(1,bin);
    for loop=1:bin
        count(1,loop) = sum(class==loop);
    end
    count=count/size(class,1);
    val=0;
    for loop=1:size(count,2)
        if count(1,loop)~=0
            val = val + (count(1,loop)*log(count(1,loop)));
        end
    end
    val=-val;
end