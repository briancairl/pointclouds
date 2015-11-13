clc;




S       = scanfileread('indoor1_r1/point_normals.bin');

%%
idx     = 50;
jdx     = 55;
ss      = 4;
Si      = subsample(S{idx},ss);
Sj      = subsample(S{jdx},ss);
Di      = wfpfh_descriptor( Si,1000,0.01,100);
Dj      = wfpfh_descriptor( Sj,1000,0.01,100);

%%

Si      = scan('POINTS',[getpoints(Si)/10;Di]);
Sj      = scan('POINTS',[getpoints(Sj)/10;Dj]);

[IDX,D] = knearest(Si,Sj,1)


view_correpondences(Si,Sj,IDX)
shg
