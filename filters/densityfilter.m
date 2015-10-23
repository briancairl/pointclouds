function S  = densityfilter(S,k,tol)
    X       = getpoints(S);
    [~,d]   = knnsearch(X.',X.','K',k);
    select  = mean(d,2) < tol;
    S       = subset(S,select);
end