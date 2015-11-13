% [dst,TR,TT] = ICPNDT( x, y, errortol, step_weight, max_iterations )
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
function [dst,TR,TT,err] = icpndt( N1, N2, errortol, max_iterations )
    
    err_last        = 1e100;                    
    err             = 1e90;             % initialize errors with a large value
    
    TR              = eye(3);          % initialize final rotation as identity
    TT              = zeros(3,1);      % initialize final translation as zero-vector
    
    x               = N1(1:3,:);
    y               = N2(1:3,:);
    
    % Loop until convergence criteria met
    while abs(err-err_last) > errortol || (err > err_last)
        
        if  ~max_iterations
            % abort when max iterations met
            warning('Max iterations reached before convergence');
            break; 
        elseif(max_iterations>0)
            % max iterations condition disabled
            max_iterations = max_iterations - 1;
        end
        
        [idx,d]     = knnsearch(y.',x.','K',1);         % find NN indices
        keep        = ( d < ( N1(4,:).' + N2(4,idx).') );
        
        %X           = x(:,keep);
        %Y           = y(:,idx(keep));
        
        X           = x;
        Y           = y(:,idx);
        
        [X_C,cX]    = mean_center(X,N1(5,: ));
        [Y_C,cY]    = mean_center(Y,N2(5,idx(:)));
        
        W           = diag(N1(5,: ).*N2(5,idx(:)));
        R           = ls_rigid_rotation(X_C,W,Y_C);     % get rigid rotation between nearest points in Y and X
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


function [X_C,xc] = mean_center(X,P)
    xc  = sum(X.*repmat(P/sum(P),3,1),2);
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
function R  = ls_rigid_rotation(X,W,Y)
    H       = X*W*Y.';
    [U,~,V] = svd(H);
    R       = V*U.';
end