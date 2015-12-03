function S = scanread(fid,varargin)
    matpcl_checkversion(2);
    
    if  fid > 0
        if  isempty(varargin)
            S = scanreadbase(fid);
        else
            n   = varargin{1};
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
        error(sprintf('Could read file : %s\n',filename)); %#ok<SPERR>
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

