function [cmap,NNi] = curvature(S,varargin)
    [NNi,doParallel,~]= procArgv( S, varargin );
    
    U       = getnormals(S);
    cmap    = zeros(1,size(S));
    if  doParallel
        parfor idx = 1:size(S)
            LU          = U(:,NNi(idx,:)); %#ok<PFBNS>
            CU          = abs( transpose(LU)*LU );
            cmap(idx)   = max(eig(CU))/size(NNi,2);
        end
    else
        for idx = 1:size(S)
            LU          = U(:,NNi(idx,:));
            CU          = abs( transpose(LU)*LU );
            cmap(idx)   = max(eig(CU))/size(NNi,2);           
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
