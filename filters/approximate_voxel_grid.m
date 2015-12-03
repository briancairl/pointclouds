function [Svox,likelihoods] = approximate_voxel_grid(S,d,sigma_n)

    % Fit to grid and remove duplicates
    trunc               = round(S.points(1:3,:)/d);
    [~,keep,occ]        = unique(trunc.','rows','stable');

    Svox = S;
    
    % Handle Points (w/ normals)
    if  size(S.points,1) == 6
        Svox.points = [trunc(:,keep)*d;S.points(4:6,keep)];
    else
        Svox.points = trunc(:,keep)*d;
    end
    
    % Handles Colors (if available)
    if  iscolored(S)
        Svox.colors = S.colors(:,keep);
    end
    
    % Comput likelihoods for voxel center
    if nargout == 2
        likelihoods = zeros(1,size(Svox));
        
        for idx = 1:size(Svox)
            likelihoods(idx) = nnz(occ==idx);
        end
        
        likelihoods = 1 - exp( -(likelihoods / sigma_n) );
    else
        likelihoods = [];
    end
        
end