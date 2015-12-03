function [data,valid]= readblock(fid)
    m       = fread(fid,[1,1],'uint32');
    n       = fread(fid,[1,1],'uint32');
    if  ~isempty(m) && ~isempty(n)
        valid   = true;
        data    = fread(fid,[m,n],'float32'); 
    else
        valid   = false;
        data    = [];         
    end
end