function d = distances(pts)
    d = sqrt(sum(pts(1:3,:).^2,1));
end