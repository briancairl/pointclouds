function [D,S] = pfh_descriptor( S, IDX, n )
    X = getpoints(S);
    U = getnormals(S);
    N = size(IDX,2);
    M = size(IDX,1);
    
    S = zeros(4,N-1,M);
    D = zeros(n,1);
    
    for jdx = 1:M
        for idx = 2:N
            S(:,idx-1,jdx) = pf_descriptor(         ...
                X(:,IDX(jdx,1)), X(:,IDX(jdx,idx)), ...
                U(:,IDX(jdx,1)), U(:,IDX(jdx,idx))  ...
            );
        end
    end
end