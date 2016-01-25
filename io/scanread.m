function S = scanread(fid,n)
    matpcl_checkversion(2);
    
    fileopen = false;
    if ischar(fid)
        fid      = fopen(fid,'r');
        fileopen = true;
    end
    
    if  fid > 0
        if  nargin == 1
            S = scanreadbase(fid);
        else
            idx = 0;
            S   = cell(1,n);
            while   true
                idx = idx + 1;
                [S{idx},valid]  = scanreadbase(fid);
                if 	idx == n
                    break;
                elseif ~valid
                    S(end) = [];
                    break;
                end
            end
        end
    else
        error('Invalid file,');
    end
    
    if  fileopen
        fclose(fid);
    end
    
end
function [S,valid] = scanreadbase(fid)
    S = scan();
    
    % Read timestamp
    S.timestamp = fread(fid,[1,1],'float32');

    % Read pointcloud data blocks
    [S.points ,v1] = readblock(fid);
    [S.normals,v2] = readblock(fid);
    [S.colors ,v3] = readblock(fid); 
    
    % Check validity
    valid = v1&&v2&&v3;
end

