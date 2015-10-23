function [D,nni] = densityfilter(S,k,tol)
    X            = points(S);
    [nni,d]      = knnsearch(X.',X.','K',k);
    select       = mean(d,2) < tol;
    D            = subset(S,select);
end