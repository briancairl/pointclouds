function S = scanread(fid,varargin)
    matpcl_checkversion(2);
    
    if  fid > 0
        if  isempty(varargin)
            S = scanreadbase(fid);
        else
            n = varargin{1};
            S = cell(1,n);
            for idx = 1:n
               if   feof(fid)
                    warning( sprintf('File ended before %d SCANS read.',n) ); %#ok<SPWRN>
                    break;
               else
                    S{idx} = scanreadbase(fid);
               end
            end
        end
    else
        error(sprintf('Could read file : %s\n',filename)); %#ok<SPERR>
    end
end
function S = scanreadbase(fid)
    S = scan();
    
    % Read timestamp
    S.timestamp = fread(fid,[1,1],'float32');

    % Read pointcloud data blocks
    S.points    = readblock(fid);
    S.normals   = readblock(fid);
    S.colors    = readblock(fid); 
end

