function m = pmask(r,t,p)
    m = abs(r-t);
    m = (1 - m/max(m)).^p;
end