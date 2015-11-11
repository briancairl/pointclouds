% [dst,TR,TT] = IXP( x, y, errortol, step_weight, max_iterations )
%   
%   Inputs:
%       X               source points
%       Y               model points
%       ERRORTOL        maxmimum difference between successive errors 
%                       until covergence
%       STEP_WEIGHT     used to recalculate step size by STEP_WEIGHT*ERROR
%                       (set to -1 to disable)
%       MAX_ITERATIONS  maximum iterations before stopping 
%                       (set to -1 to disable)
%
%   Output:
%       DST             source points after allignement
%       TR              final rotation between source and model
%       TT              final translation between source and model
%       ERR             final allignment error
%
function [dst,TR,TT,err] = icp( x, y, varargin )
    
    step_weight     = 0.01;
    errortol        = 0.001;
    max_iterations  = 1000;
    
    cY              = mean(y,2);                % generate the centeroid of the model
    centroidY       = repmat(cY,1,size(y,2));   % replicate centroid to match dim of Y
    Y_C             = y - centroidY;            % shift Y
    
    err_last        = 1e100;                    
    err             = 1e90;                     % initialize errors with a large value
    
    TR              = eye(size(x,1));           % initialize final rotation as identity
    TT              = zeros(size(x,1),1);       % initialize final translation as zero-vector
    alpha           = 1;
    
    
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
        
        idx         = knnsearch(y.',x.','K',1);         % find NN indices
        cX          = mean(x,2);                        % find new centroid of X
        centroidX   = repmat(cX,1,size(x,2));           % replicate centroid to match dim of X
        
        X_C         = x - centroidX;                    % shift X by centroid
        Y_C_near    = Y_C(:,idx);                       % select nearesy points of Y
        
        A           = alpha*eye(size(x,2));             % recalculate SVD weighting matrix using current step size
        R           = ls_rigid_rotation(X_C,Y_C_near,A);% get rigid rotation between nearest points in Y and X
        V           = cY - R*cX;                        % get translation between nearest points in Y and X
        
        TR          = R * TR;                           % incorperate rotation into total rotation
        TT          = R * TT + V;                       % incorperate translation into total translation
        x           = R * x + repmat(V,1,size(x,2));    % apply transform to source set
        
        err_last    = err;
        err         = calculate(x,y(:,idx));            % calculate new total error 
        
        if(step_weight>0)
            alpha   = step_weight*err;                  % recalculate step size proportional to error
        end
    end
    
    dst = x; % set corrected source set as output
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Helper Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Calulcates the average square error between all points in X and Y
% X and Y must be the same dim and length
function err= calculate(X,Y)
    N   = size(X,2);
    err = sum(sum((X - Y).^2,1))/N;
end


% Computes the least-squares rigid rotation between X and Y (centroid
% shifted) using SVD
function R  = ls_rigid_rotation(X,Y,A)
    H       = X*A*Y.';
    [U,~,V] = svd(H);
    R       = V*U.';
end