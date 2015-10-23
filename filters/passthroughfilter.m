function Sp = passthroughfilter(S,dim,limits)
    
    % Do filtering
    N               = size(S.points,2);
    ltl             = repmat(limits(:,1),1,N);
    gtl             = repmat(limits(:,2),1,N);
    select          = all((S.points(dim,:) > ltl) & (S.points(dim,:) <= gtl),1);
    
    % Copy-Select
    Sp.timestamp    = S.timestamp;
    Sp.points       = S.points(:,select);
end