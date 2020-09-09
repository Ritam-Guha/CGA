function [shapley]=coalitionGame(train,trainLabel,population)
    % function to generate shapley scores from coaltion game

    global MI
    PCC=modifiedPcc(train,population);
    shapley=MI.*PCC;
    shapley=(shapley-min(shapley))/(max(shapley)-min(shapley));
end