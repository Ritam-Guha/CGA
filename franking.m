function [ftrank]=franking(x, t)

    for i=1:size(t,1)
        tar(1,i)=find(t(i,:));
    end
    
    k=10;
    [ftrank,weights] = relieff(x, tar, k, 'method', 'classification'); % feature ranking
end
    