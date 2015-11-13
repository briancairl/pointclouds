function pf = pf_descriptor(xs,xt,us,ut)

    N                       = size(xs,2)*size(xt,2);
    pf                      = zeros(4,N);
    [~,dx,pf(4,:),nii,~]    = pairwise_distance(xs,xt,2);
    good                    = pf(4,:) > eps;
    
    up                      = dx(:,good)./repmat(pf(4,good),3,1);
    u                       = us(:,nii(good));
    v                       = cross(u,up);
    w                       = cross(u,v);

    pf(1,good)              = dot(v,ut(:,good));
    pf(2,good)              = dot(u,up);
    pf(3,good)              = atan2( dot(w,ut(:,good)) , dot(u,ut(:,good)) );
end