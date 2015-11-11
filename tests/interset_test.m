clear;
clc;

S = scanfileread('indoor1_r1/point_normals.bin');

%%
colormap('Jet')
k = 50;
p = 4;
for idx = 2:numel(S)

E1      = passthroughfilter(S{idx-1},1:3,[-8,8;-8,8;-0.1,2.1]);
E2      = passthroughfilter(S{ idx },1:3,[-8,8;-8,8;-0.1,2.1]);

%{
[s1,X1] = curvature(E1,10,4);
[s2,X2] = curvature(E2,10,4);
Y1      = [X1;s1];
Y2      = [X2;s2];
%}
Y1      = getpoints(E1);
Y2      = getpoints(E2);
Z       = icp(Y1,Y2,'Max_Iterations',20);

cla 
E1.points(1:3,:) = Z(1:3,:); 
view_scan(E1,'Color','g','Normals','Off')
view_scan(E2,'Color','r','Normals','Off')
pause(1e-3)
end