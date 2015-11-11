function [s,X,U] = curvature(E,k,p)
    X = getpoints(E);
    U = getnormals(E);
    s = zeros(1,size(E));
    f = @(x,y)(1-abs(dot(x,y)));
    K = knnsearch( X.', X.', 'K', k );

    for jdx = 1:size(E)
        v       = eig(U(:,K(jdx,:))*U(:,K(jdx,:)).')/k;
        s(jdx)  = max(v);
    end
    
    s = s.^p;
end