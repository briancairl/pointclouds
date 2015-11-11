function D = pairwise(fn,varargin)
    if      nargin == 2
        X = varargin{1};
        Y = varargin{2};
    elseif  nargin == 1
        X = varargin{1};
        Y = varargin{1};
    else
        error('Bad argument count');
    end
    N = size(X,2);
    M = size(Y,2);
    D = zeros(N,M);
    for idx = 1:N
        for jdx = idx:M
            D(idx,jdx) = fn(Y(:,jdx),X(:,idx));
            D(jdx,idx) = D(idx,jdx);
        end
    end
end