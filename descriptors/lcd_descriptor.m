function [D,C]      = lcd_descriptor(S,k,n)

    X               = getpoints(S);
    U               = getnormals(S);
    C               = (U.'*U);
    [Kidx,~]        = knnsearch( X.', X.', 'K', k );
    
    R               = linspace(-1.01,1.01,n);
    N               = size(X,2);    
    D               = zeros(n,N);
    
    for idx = 1:N
        h           = (histc( C(idx,Kidx(idx,:)), R ))/k;
        D(:,idx)    = transpose(h);
    end
end