function matpcl_checkversion(ver)
    global matplc_version;
    if  isempty(matplc_version)
        error('MATPCL : Version number no. not defined.'); 
    else
        if matplc_version ~= ver
            error('MATPCL : Incorrect version.');
        end
    end
end