function [S,NNi,NND] = qualityfilter(S,varargin)
    [dsig,csig,pmin,NNi,NND] = procArg( S, varargin );

    U   = getnormals(S);
    P   = zeros(1,size(S));
    
    parfor idx  = 1:size(S)
        LC      = abs(transpose(U(:,NNi(idx,1)))*U(:,NNi(idx,2:end)));
        LD      = NND(idx,2:end);
        PC      = exp(-LC/csig);
        PD      = exp(-LD/dsig);
        P(idx)  = mean(PC.*PD);
    end
    cla;
    
    if pmin < 0
        pmin = median(P);
    end

    inlier  = ~((P < pmin) | isnan(P) | isinf(P) );
    plot(sort(P(inlier)))
    S       = subset(S,inlier);
end
function [dsig,csig,pmin,NNi,NND,k] = procArg( S, argv )
    pmin = -1;
    dsig = 0.05;
    csig = 0.005;
    k    = 5;
    for idx = 1:2:numel(argv)
        if       strcmpi(argv{idx},'DSIGMA') 
            dsig = argv{idx+1};
        elseif   strcmpi(argv{idx},'CSIGMA')
            csig = argv{idx+1};
        elseif   strcmpi(argv{idx},'K')
            k    = argv{idx+1};
        elseif   strcmpi(argv{idx},'NNI')
            error('This function does not accept external NNI input.');
        elseif   strcmpi(argv{idx},'PMIN')
            pmin = argv{idx+1};
        else
            error(['Unrecognized option : ',argv{idx}]);
        end
    end
    X           = getpoints(S);
    [NNi,NND]   = knnsearch(X.',X.','K',k);
end