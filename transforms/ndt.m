function NDT = ndt( X, dx, k, sigma_d, tol, varargin )
    
    if numel(varargin)
        B  = varargin{1};
    else
        B  = boundaries(X);
    end
    
    X_SPAN      = B(1):dx:B(2);
    Y_SPAN      = B(3):dx:B(4);
    Z_SPAN      = B(5):dx:B(6);
    [U,V,W]     = meshgrid(X_SPAN, Y_SPAN, Z_SPAN);
    NDT         = [U(:),V(:),W(:)];
    [~,d]       = knnsearch(X(1:3,:).',NDT,'K',k);
    
    
    P           = exp(-d/sigma_d);
    P_ave       = sum(P,2)/k;
    P           = P./repmat(sum(P,2),1,k);

    
    NDT(:,4)    = sum( P.*d , 2 );
    pass        = P_ave > tol;
    
    NDT         = [ transpose(NDT(pass,:)); transpose(P_ave(pass)) ];
end
function B = boundaries(X)
    B = [min(X(1:3,:),[],2),max(X(1:3,:),[],2)].';
end