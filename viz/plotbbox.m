% PLOTBBOX
%
% Plots a bounding box produced by BOUNDS
%
function plotbbox(bbox,varargin)
    c111 = [bbox(1,1);bbox(2,1);bbox(3,1)];
    c211 = [bbox(1,2);bbox(2,1);bbox(3,1)];
    c221 = [bbox(1,2);bbox(2,2);bbox(3,1)];
    c222 = [bbox(1,2);bbox(2,2);bbox(3,2)];
    c121 = [bbox(1,1);bbox(2,2);bbox(3,1)];
    c122 = [bbox(1,1);bbox(2,2);bbox(3,2)];
    c112 = [bbox(1,1);bbox(2,1);bbox(3,2)];
    c212 = [bbox(1,2);bbox(2,1);bbox(3,2)];
    
    bboxx = [c111,c211,c221,c121,c111,...
            c112,c212,c222,c122,c112 ...
            c111,c211,c212,...
            c222,c221,c121,...
            c122
            ];
    
    plot3(bboxx(1,:),bboxx(2,:),bboxx(3,:),varargin{:})
end