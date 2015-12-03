function Proj = pointplaneproj( u, c, P )
    N       = size(P,2);
    M       = size(P,1);
    t       = transpose(u)*( P - repmat(c,1,N) );
    Proj    = P + repmat(t,M,1).*repmat(u,1,N);
end