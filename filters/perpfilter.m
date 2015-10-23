function P = perpfilter(S,v,tol)
    scores  = abs(transpose(v)*normals(S));
    select  = scores<tol;
    P       = subset(S,select);
end