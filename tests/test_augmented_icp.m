clear;
clc;

global F;
if isempty(F)
   F = scanfileread('indoor1/point_normals.bin');
end

S   = F{1};
D   = createcddescriptor(S,10,20);


disFn = @(x,y)cddistance(x.',y.',0.5,2);

knnsearch(D.',D.','Distance',disFn)