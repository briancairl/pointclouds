function [U,nni]= estimate_normals(X,k)
    [M,N]               = size(X);
    if 	M~=3
        error('X must be a 3-by-N matrix of points.');
    end
    U                   = zeros(size(X));
    nni                 = knnsearch(X.',X.','K',k);
    slices              = cell(N,1);
    for idx = 1:N
        slices{idx}     = X(:,nni(idx,:));
    end
    for idx             = 1:N
        v               = pca(slices{idx}.');
        U(:,idx)        = cross(v(:,1),v(:,2));
    end
end