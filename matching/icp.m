% [dst,TR,TT] = IXP( x, y, errortol, step_weight, max_iterations )
%   
%   Inputs:
%       X               source points
%       Y               model points
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
function [dst,TR,TT,err] = icp( x, y, errortol, max_iterations, dmax )
    
    err_last        = 1e100;                    
    err             = 1e90;                     % initialize errors with a large value
    
    TR              = eye(size(x,1));           % initialize final rotation as identity
    TT              = zeros(size(x,1),1);       % initialize final translation as zero-vector
       
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
        
        [idx,d]     = knnsearch(y.',x.','K',1);         % find NN indices
        keep        = d < dmax;
        
        X           = x(:,keep);
        Y           = y(:,idx(keep));
        
        [X_C,cX]    = mean_center(X);
        [Y_C,cY]    = mean_center(Y);
        
        R           = ls_rigid_rotation(X_C,Y_C);       % get rigid rotation between nearest points in Y and X
        V           = cY - R*cX;                        % get translation between nearest points in Y and X
        
        TR          = R * TR;                           % incorperate rotation into total rotation
        TT          = R * TT + V;                       % incorperate translation into total translation
        x           = R * x + repmat(V,1,size(x,2));    % apply transform to source set
        
        err_last    = err;
        err         = calculate(X,Y);                   % calculate new total error 
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