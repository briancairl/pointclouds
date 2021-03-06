function [cmap,NNi,NNd] = curvature(S,varargin)
    [NNi,NNd,p,doParallel,~]= procArgv( S, varargin );
    
    U       = getnormals(S);
    cmap    = zeros(1,size(S));
    LU      = cell(size(S),1);
    
    for idx = 1:size(S)
        LU{idx} = U(:,NNi(idx,:));
    end
    
    if  doParallel
        parfor idx = 1:size(S)
            EV          = abs(eig(LU{idx}*transpose(LU{idx}))).^p;
            cmap(idx)   = EV(1)/sum(EV);
        end
    else
        for idx = 1:size(S)
            EV          = abs(eig(LU{idx}*transpose(LU{idx}))).^p;
            cmap(idx)   = EV(1)/sum(EV);         
        end
    end
end
function [NNi,NNd,p,doParallel,verbose]= procArgv( S, argv )
    p           = 2;
    verbose     = false;
    doParallel  = false;
    NNi         = [];
    NNd         = [];
    while numel(argv)
        if      strcmpi('NNI' , argv{1})
            NNi         = argv{2};
            argv(1:2)   = [];
            
        elseif  strcmpi('VERBOSE' , argv{1})
            verbose     = strcmpi(argv{2},'ON');
            argv(1:2)   = [];
        
        elseif  strcmpi('P' , argv{1})
            p           = argv{2};
            argv(1:2)   = [];
            
        elseif  strcmpi('K' , argv{1})
            [NNi,NNd]   = knnsearch( S.points.' , S.points.' , 'K' , argv{2} );
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
