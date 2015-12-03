function ver = matpcl_getversion()
    global matplc_version;
    if isempty(matplc_version)
        ver = -1;
        warning('Version not set. use MATPCL_SETVERSION');
    else
        ver = matplc_version;
    end
end