function writeblock(fid,data)
    [m,n] = size(data);
    fwrite(fid,m    ,'uint32'   );
    fwrite(fid,n    ,'uint32'   );
    fwrite(fid,data ,'float32'  );    
end