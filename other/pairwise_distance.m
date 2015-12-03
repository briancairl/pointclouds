function [D,d,m,NII,MII] = pairwiselp(X,Y,p)
    N   = size(X,2);
    M   = size(Y,2);
    D   = zeros(N,M);
    NI  = repmat( (1:N)  , M, 1 ); NII = NI(:);
    MI  = repmat( (1:M).', 1, N ); MII = MI(:);
    d   = X(:,NII) - Y(:,MII);
    m   = sum(abs(d).^p,1).^(1/p);
    D(:)= m;
end