function XAV = pnmean(X)
    XAV      = X(:,1);
    XAV(1:3) = mean(X(1:3,:),2);
    XAV(4:6) = a2u(mean(u2a(X(4:end,:)),2));
end