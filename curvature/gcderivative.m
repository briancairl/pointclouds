function dC = gcderivative(C,NNi,NNd,sigma,order)
    for idx = 1:order
        CNN     = C(NNi);
        k       = size(CNN,2) - 1;
        dCNN    = (CNN(:,2:end) - repmat(CNN(:,1),1,k));
        PNN     = exp( -NNd(:,2:end)/sigma );
        PNN     = PNN./repmat( sum(PNN,2), 1, k );
        dC      = sum(PNN.*dCNN,2);
        C       = dC;
    end
end