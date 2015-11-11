function [D,U] = pnpairs(pn1,pn2)
    n1= size(pn1,1);
    n2= size(pn2,1);
    D = zeros( n1, n2 );
    U = zeros( n1, n2 );
    
    for idx = 1:n1
        for jdx = idx:n2
            if idx == jdx
                D(idx,jdx) = inf;
                U(idx,jdx) = 1;
            else
                D(idx,jdx) = norm( pn1(1:3,idx) - pn2(1:3,jdx) );
                U(idx,jdx) = dot(  pn1(4:6,idx) , pn2(4:6,jdx) );
            end
            D(jdx,idx) = D(idx,jdx);
            U(jdx,idx) = U(idx,jdx);
        end
    end
end