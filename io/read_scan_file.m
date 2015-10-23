% READ_SCAN_FILE
%
% @brief    Reads all frames from a binary scan file with points of dimension DIM
%
% @input    FILENAME    name of the data file to be read
%
% @return   F           a cell of timestamped scan structures
%
% @author   Brian Cairl (NYU-CRRL)
% @date     October 19, 2015
function F = read_scan_file(filename)
    fid = fopen(filename,'r');
    F   = {};
    if  fid > 0
        dim = filename2dim(filename);
        while ~feof(fid)
           F{end+1} = read_scan(fid,dim); %#ok<AGROW>
        end
        fclose(fid);
    else
        warning(sprintf('File [%s] could not be opened.',filename)); %#ok<SPWRN>
    end
end
% Determines point dimension from filename
function dim = filename2dim(filename)
    dim = 0; %#ok<NASGU>
    if      ~isempty(strfind(filename,'raw.bin'));                  
        dim = 3;
    elseif  ~isempty(strfind(filename,'point_normals.bin'));        
        dim = 6;
    else
        error(sprintf('Unrecognized data file : %s',filename));  %#ok<SPERR>
    end 
end