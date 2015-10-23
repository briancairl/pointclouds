% READ_SCAN
%
% @brief    Reads a frame from an opened data file
%
% @input    FID         associated file handle
% @input    DIM         dimension of the points for each scan {3 or 6}
%
% @return   S           a timestamped scan structure with the following
%                       member variables:
%                           S.timestamp
%                           S.points 
%
%           n           size of the scan (number of points)
%
% @author   Brian Cairl (NYU-CRRL)
% @date     October 19, 2015
function [S,n]  = read_scan(fid,dim)
    S.timestamp = fread(fid,[1,1],'float32');
    n           = fread(fid,[1,1],'uint32');
    S.points    = fread(fid,[dim,n],'float32');
end