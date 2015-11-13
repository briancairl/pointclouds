clear;
clc;

S       = scanfileread('indoor1_r1/point_normals.bin');
XX      = 4;
YY      = 4;
s       = 1;
idx     = 100;
jdx     = 110;

E1      = passthroughfilter( subsample(S{idx},s),1:3,[-XX,XX;-YY,YY;-0.1,2.1]);
E2      = passthroughfilter( subsample(S{jdx},s),1:3,[-XX,XX;-YY,YY;-0.1,2.1]);

clear S;

%%
clc
colormap('Jet')

X1              = getpoints(E1);
X2              = getpoints(E2);
NDT1            = ndt(X1,0.1,20,0.5,0.6,[-3,3,-3,3,0,2]);
NDT2            = ndt(X2,0.1,20,0.5,0.6,[-3,3,-3,3,0,2]);

[DE,TR,TT,err]  = icpndt(NDT1,NDT2,0.0001,1000);
%%
cla
hold on
view_scan(scan('Points',NDT1),'Color','b','Normals','Off')
view_scan(scan('Points',NDT2),'Color','r','Normals','Off')
view_scan(scan('Points',DE(1:3,:)),'Color','g','Normals','Off')
pause(1e-3)
shg

%%
cla
hold on
view_scan(scan('Points',D1),'Color','b','Normals','Off')
view_scan(scan('Points',D2),'Color','r','Normals','Off')
view_scan(scan('Points',DE),'Color','g','Normals','Off')
pause(1e-3)
shg

%%

X   = zeros(3,1);
e   = size(tf,2);

E   = zeros(1,e);
XD  = zeros(3,e); 
RR  = eye(3);

for idx = 1:e
    if isempty(tf{1,idx})
        e = idx-1;
        break
    end
    E(1,idx)    = tf{3,idx};
    RR          = tf{1,idx}*RR;
    X           = X + RR*tf{2,idx};
    XD(:,idx)   = X;
end

figure(2)
cla

plot(XD(1,1:e),XD(2,1:e),'b')
axis equal

figure(3)
plot(E(1,1:e),'b')











