function d          = cddistance(d,D,a,p)
    diff            = ( repmat(d,size(D,1),1)-D).^p;
    diff(:,1:3)     = (1-a)*diff(:,1:3);
    diff(:,4:end)   =  (a) *diff(:,4:end);
    d               = sum(diff,2);
end