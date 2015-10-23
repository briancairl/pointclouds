function [D,d] = create_curvature_descriptor(S,k,n)

    X               = points(S);
    U               = normals(S);
    C               = 1 - abs(U.'*U);
    [Kidx,Kdis]     = knnsearch( X.', X.', 'K', k );
    
    R               = linspace(0,1,n);
    
    N               = size(X,2);
    M               = numel(R);
    
    D               = zeros(M,N);
    d               = zeros(1,N);
    
    for idx = 1:N
        D(:,idx) = histc( C(idx,Kidx(idx,:)), R )/k;
        d(1,idx) = mean(Kdis(idx,:));
    end

end