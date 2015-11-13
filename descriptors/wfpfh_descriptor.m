function D = wfpfh_descriptor( S, k, sigma, divs )
    
    X   = getpoints(S);
    U   = getnormals(S);
    IDX = knnsearch(X.',X.','K',k);
    
    N   = k;
    M   = size(IDX,1);
    D   = zeros(3,M);
    for jdx = 1:M
        
        S       = pf_descriptor(           ...
            X(:,IDX(jdx,1)), X(:,IDX(jdx,1:N)), ...
            U(:,IDX(jdx,1)), U(:,IDX(jdx,1:N))  ...
        );
        w       = genweights(S(4,:),sigma);        
        D(:,jdx)= sum(w.*S(1:3,:),2);
    end
end
function w = genweights(x,sigma)
    p   = exp(-x/sigma);
    w   = repmat(p/sum(p),3,1);
end