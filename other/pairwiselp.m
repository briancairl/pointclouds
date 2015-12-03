function [D,d,m,NII,MII] = pairwiselp(X,Y,p,varargin)
    N   = size(X,2);
    M   = size(Y,2);
    D   = zeros(N,M);
    
    if  isempty(varargin) || strcmpi( varargin{1}, 'MATRIX' )
        NI  = repmat( (1:N)  , M, 1 ); NII = NI(:);
        MI  = repmat( (1:M).', 1, N ); MII = MI(:);
        clear NI MI;
        d   = X(:,NII) - Y(:,MII);
        m   = sum(abs(d).^p,1).^(1/p);
        D(:)= m;
    elseif strcmpi( varargin{1}, 'ITERATIVE' )
        warning('Using iterative method. Slower but uses less memory');
        for idx = 1:N
            for jdx = (idx+1):M
                D(idx,jdx) = norm( X(:,idx) - Y(:,jdx) , p );
                if (idx <= M) && (jdx <= N)
                    D(jdx,idx) = D(idx,jdx); 
                end
            end
        end
    else
        error([ 'Unrecognized mode : ',varargin{1}]);
    end
end