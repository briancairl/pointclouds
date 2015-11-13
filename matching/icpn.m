% [dst,TR,TT] = ICPN( x, y, xu, yu, angtol, errortol, max_iterations )
%   
%   Inputs:
%       X               source points
%       Y               model points
%       XU              source normals
%       YU              model normals
%       ERRORTOL        maxmimum difference between successive errors 
%                       until covergence
%       MAX_ITERATIONS  maximum iterations before stopping 
%                       (set to -1 to disable)
%
%   Output:
%       DST             source points after allignement
%       TR              final rotation between source and model
%       TT              final translation between source and model
%       ERR             final allignment error
%
function [dst,TR,TT,err] = icp( x, y, xu, yu, angtol, errortol, max_iterations )
    
    err_last        = 1e100;                    
    err             = 1e90;                     % initialize errors with a large value
    
    TR              = eye(size(x,1));           % initialize final rotation as identity
    TT              = zeros(size(x,1),1);       % initialize final translation as zero-vector
    alpha           = 1;
    
    % Compound
    x = [x;xu];
    y = [y;yu];
    
    % Loop until convergence criteria met
    while abs(err-err_last) > errortol
        
        if  ~max_iterations
            % abort when max iterations met
            warning('Max iterations reached before convergence');
            break; 
        elseif(max_iterations>0)
            % max iterations condition disabled
            max_iterations = max_iterations - 1;
        end
        
        [idx,~]     = knnsearch(y.',x.','K',1);         % find NN indices
        
        
        % Get dot prod
        U           = sum( (xu-yu(:,idx)).^2, 1 ).^(1/2);
        d_keep      = U < angtol;
        
        
        X           = x(1:3,d_keep);
        Y           = y(1:3,idx( d_keep ));
        
        [X_C,cX]    = mean_center(X);
        [Y_C,cY]    = mean_center(Y);
        
        R           = ls_rigid_rotation(X_C,Y_C);       % get rigid rotation between nearest points in Y and X
        V           = cY - R*cX;                        % get translation between nearest points in Y and X
        
        TR          = R * TR;                           % incorperate rotation into total rotation
        TT          = R * TT + V;                       % incorperate translation into total translation
        x(1:3,:)    = R * x(1:3,:) + repmat(V,1,size(x(1:3,:),2));    % apply transform to source set
        
        err_last    = err;
        err         = calculate(x(1:3,:),y(1:3,idx));            % calculate new total error 
    end
    
    dst = x; % set corrected source set as output
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Helper Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [X_C,xc] = mean_center(X)
    xc  = mean(X,2);
    C_X = repmat( xc, 1, size(X,2) );
    X_C = X - C_X;
end

% Calulcates the average square error between all points in X and Y
% X and Y must be the same dim and length
function err= calculate(X,Y)
    N   = size(X,2);
    err = sum(sum((X - Y).^2,1))/N;
end


% Computes the least-squares rigid rotation between X and Y (centroid
% shifted) using SVD
function R  = ls_rigid_rotation(X,Y)
    H       = X*Y.';
    [U,~,V] = svd(H);
    R       = V*U.';
end