function [D,d]      = createcddescriptor(S,k,n)

    X               = getpoints(S);
    U               = getnormals(S);
    C               = 1 - abs(U.'*U);
    [Kidx,Kdis]     = knnsearch( X.', X.', 'K', k );
    
    R               = linspace(0,1,n);
    
    N               = size(X,2);
    M               = numel(R);
    
    D               = zeros(M+3,N);
    d               = zeros(1,N);
    
    for idx = 1:N
        H           = histc( C(idx,Kidx(idx,:)), R )/k;
        D(:,idx)    = [ X(:,idx); H.' ];
        d(1,idx)    = mean(Kdis(idx,:));
    end

end