function scanwrite(fid,S)
    matpcl_checkversion(2);
    
    if  isempty(S)
        error('SCAN input is empty.');
    else
        fileopen = false;
        if ischar(fid)
            fileopen = true;
            fid = fopen(fid,'w');
        end
        
        if  fid > 0
            if  iscell(S)
                for idx = 1:max(size(S))
                   scanwritebase(fid,S{idx}); 
                end
            else
                scanwritebase(fid,S);
            end
        else
            error('Invalid file.');
        end
        
        if  fileopen
            fclose(fid);
        end
    end
end
function scanwritebase(fid,S)
    % Write timestamp
    fwrite(fid,S.timestamp,'float32');

    % Write pointcloud data blocks
    writeblock(fid,S.points);
    writeblock(fid,S.normals);
    writeblock(fid,S.colors);
end

