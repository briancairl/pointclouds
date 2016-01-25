function M = scan2map2D(S,s,w,h)
    
    S.points(1,:) = S.points(1,:) + w/2;
    S.points(2,:) = S.points(2,:) + h/2;
    
    I   = ceil(S.points/s + eps);
    WI  = ceil(w/s);
    HI  = ceil(h/s);
    M   = zeros(WI,HI);
    
    ok  = ( (I(1,:) <= WI) & (I(1,:) > 0) ) & ( (I(2,:) <= HI) & (I(2,:) > 0) );
    
    M(sub2ind([WI,HI],I(1,ok),I(2,ok))) = 1;
end