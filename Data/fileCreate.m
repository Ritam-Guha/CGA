function[] = fileCreate(fileName,trainPercentage)
    
    filePath=strcat(fileName,'.xlsx');
    content=importdata(filePath);
    trainPercentage = trainPercentage/100;
    
    class=content.textdata;
    inputData=content.data;
    
    [rows,~]=size(inputData);
    uniqueClass=unique(class);
    numClass=size(uniqueClass,1);
    disp(uniqueClass);
    disp(numClass);
    oneHotClass=zeros(rows,numClass);
    classCount=zeros(numClass,1);   
    startClass=zeros(numClass+1,1);
    
    for loop=1:numClass
        index=find(strcmp(class,uniqueClass(loop,1)));
        classCount(loop,1)=size(index,1);
        oneHotClass(index,loop)=1;
        startClass(loop,1)=index(1,1);        
    end
    
    startClass(numClass+1,1)=rows+1; %dummy addition to bring uniformity
    trainNo=1;
    testNo=1;
    
    
    for classNo=1:numClass                
        numTrainClass=int16(trainPercentage*classCount(classNo,1));
        numTestClass=classCount(classNo,1)-numTrainClass;                
        data.train(trainNo:trainNo+numTrainClass-1,:)=inputData(startClass(classNo,1):startClass(classNo,1)+numTrainClass-1,:);        
        data.trainLabel(trainNo:trainNo+numTrainClass-1,:)=oneHotClass(startClass(classNo,1):startClass(classNo,1)+numTrainClass-1,:);
        fprintf('index_start=%d index_end=%d data_index_start=%d data_index_end=%d\n',trainNo,trainNo+numTrainClass-1,startClass(classNo,1),startClass(classNo,1)+numTrainClass-1);
        fprintf('index_start=%d index_end=%d data_index_start=%d data_index_end=%d\n',testNo,testNo+numTestClass-1,startClass(classNo,1)+numTrainClass,startClass(classNo+1,1)-1);
        data.test(testNo:testNo+numTestClass-1,:)=inputData(startClass(classNo,1)+numTrainClass:startClass(classNo+1,1)-1,:);
        data.testLabel(testNo:testNo+numTestClass-1,:)=oneHotClass(startClass(classNo,1)+numTrainClass:startClass(classNo+1,1)-1,:);        
        trainNo=trainNo+numTrainClass;
        testNo=testNo+numTestClass;        
    end

    save(strcat(fileName,'_data.mat'),'data');
end