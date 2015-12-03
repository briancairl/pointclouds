% KCENTERS(D, k)
%   
% Source : http://sites.stat.psu.edu/~jiali/course/stat597e/notes2/kcenter.pdf 
%
%
function [ids,seeds] = kcenters( D, k, varargin )
    
    % Init seed
    [N,idx,dist,maxdist]= procInit(D,varargin);
    
    % Store seeds
    seeds       = idx;
    
    % Init ids
    ids         = ones(1,N);
    avail       = ones(1,N);
    avail(idx)  = 0;
    
    % Assign the remainder of the IDs
    for kdx = 2:k
        [dl,idx]    = max(dist.*avail);
        leq         = ( D(idx,:) <= dist ) & ( D(idx,:) <= maxdist ) & ( boolean(avail) );
        dist(leq)   = D(idx,leq);
        ids(leq)    = kdx;
        avail(idx)  = 0;
    end
    
end
function [ N, idx, dist, maxdist ] = procInit(D,argv)
    
    N       = size(D,2);
    idx     = randi([1,N],1,1);
    maxdist = inf;
    
    % Variable arguments
    while numel(argv)
        if strcmpi(argv{1},'SEED')
            idx         = argv{2}(1,1); 
            argv(1:2)   = [];
        elseif strcmpi(argv{1},'MAXDIST')
            maxdist     = argv{2}(1,1);
            argv(1:2)   = [];
        else
            error(['Unrecognized option : ',argv{1}]);
        end
    end
    
    % Initial distances
    dist = D(idx,:);
end
    
