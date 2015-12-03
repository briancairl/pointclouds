function [IDS,regions] = regiongrowing(X,F,k,dmax,fmax,maxitr)
    [N,k,dmax,fmax,maxitr] = defaults(X,F,k,dmax,fmax,maxitr)
    
    Y       = [X;F];
    I       = randi([1,N],1,k);
    C       = Y(:,I);
    IDS     = zeros(1,N);
    IDS(I)  = 1:k;
    
    while (maxitr > 0); maxitr = maxitr - 1;
        available   = ~boolean(IDS); 
        [IDX,D]     = knnsearch( (X+anti(size(X,1),available)).', C(1:3,:).', 'K', 1 );
        dvalid      = (D < dmax);
        
        for kdx = 1:k
            if  dvalid(kdx,:)&&available(IDX(kdx))
                m = IDX(kdx,1);
                if  acos(abs(dot( F(:,m), C(4:end,kdx) ))) < fmax 
                    IDS(m)       = kdx;
                    available(m) = false;
                end
            end
            C(:,kdx) = pnmean(Y(:,IDS==kdx));
        end
    end
        
end
function L = anti(d,b)
    b = ~boolean(b);
    L = zeros(d,numel(b));
    L(:,b) = inf;
end
function [N,k,dmax,fmax,maxitr] = defaults(X,F,k,dmax,fmax,maxitr)
    N = size(X,2);
    if nargin < 2
        error('Muest provide points X and features F');
    end
    if nargin < 6
        maxitr  = 1000;
    end
    if nargin < 5
        fmax    = 0.5;
    end
    if nargin < 4
        dmax    = inf;
    end
    if nargin < 3
        k       = ceil(sqrt(N/2));
    end
end