function [U,NNi] = est_normals(S,varargin)
    
    N                   = size(S);
    U                   = zeros(3,size(S));
    
    [NNi,doParallel,verbose]    = procArgv(S,varargin);
        
    if  doParallel

        slices          = cell(N,1);

        for idx = 1:N
            slices{idx} = S.points(:,NNi(idx,:));
        end

        parfor idx      = 1:N
            v           = pca(slices{idx}.');
            U(:,idx)    = cross(v(:,1),v(:,2));
            
            if verbose
               fprintf('Complete %f %%\n',idx/N*100);
            end
        end

    else

        for idx             = 1:N
            v               = pca(S.points(:,NNi(idx,:)).');
            U(:,idx)        = v(:,3);

            if verbose
               fprintf('Complete %f %%\n',idx/N*100);
            end
        end
        
    end

end
function [NNi,doParallel,verbose]= procArgv( S, argv )
    
    verbose     = false;
    doParallel  = false;
    NNi         = [];
    
    while numel(argv)
        
        if      strcmpi('NNI' , argv{1})
            NNi         = argv{2};
            argv(1:2)   = [];
        elseif  strcmpi('VERBOSE' , argv{1})
            verbose = strcmpi(argv{2},'ON');
            argv(1:2)   = [];
            
        elseif  strcmpi('K' , argv{1})
            NNi         = knnsearch( S.points.' , S.points.' , 'K' , argv{2} );
            argv(1:2)   = [];
            
        elseif  strcmpi('PARALLEL' , argv{1})
            doParallel  = strcmpi(argv{2},'ON');
            argv(1:2)   = [];
            
        else
            error(['Unrecognized argument : ',argv{1}]);
        end
    end
    
    if isempty(NNi)
        error('Requires K or NNI option to be set, but not niether.');
    end
end
