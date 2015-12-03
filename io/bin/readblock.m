function data = readblock(fid)
    m       = fread(fid,[1,1],'uint32');
    n       = fread(fid,[1,1],'uint32');
    if  ~isempty(m) && ~isempty(n)
        data= fread(fid,[m,n],'float32'); 
    end
end