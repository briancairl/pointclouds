% VIEW_SCAN
%
% @brief    Plots a single scan
%
% @input    S       valid scan struct
function view_scan(S,varargin)
    
    % Defaults
    show_normals = true;
    show_source  = true;
    f_map        = [];
    bgcolor      = [0,0,0];
    nvararg      = numel(varargin);
    
    
    hold on 
    delvar       = [];
    for idx = 1:2:nvararg
        if      strcmpi(varargin{idx},'NORMALS')
            show_normals= strcmpi(varargin{idx+1},'ON');
            delvar      = [delvar,idx,idx+1]; %#ok<AGROW>
        elseif  strcmpi(varargin{idx},'SOURCE')
            show_source = strcmpi(varargin{idx+1},'ON');
            delvar      = [delvar,idx,idx+1]; %#ok<AGROW>
        elseif  strcmpi(varargin{idx},'MAP')
            show_normals= false;
            f_map       = varargin{idx+1};
            f_map       = (f_map-min(f_map))./(max(f_map)-min(f_map)) + eps;
            delvar      = [delvar,idx,idx+1]; %#ok<AGROW>
        elseif  strcmpi(varargin{idx},'BACKGROUNDCOLOR')
            bgcolor     = varargin{idx+1};
            delvar      = [delvar,idx,idx+1]; %#ok<AGROW>
        end
    end
    varargin(delvar)=[];
    if ~isempty(S.points)
        if  (size(S.points,1)==6) && show_normals
            if  isempty(f_map)
                quiver3(    S.points(1,:), S.points(2,:), S.points(3,:),    ...
                            S.points(4,:), S.points(5,:), S.points(6,:),    ...
                            'Marker', '.',                                  ...
                            'MarkerSize', 4,                                ...
                            varargin{:}                                     ...
                       );
            else
                quiver3(    S.points(1,:), S.points(2,:), S.points(3,:),    ...
                            S.points(4,:), S.points(5,:), S.points(6,:),    ...
                            f_map,                                         ...
                            'Marker', '.',                                  ...
                            'MarkerSize', 4,                                ...
                            varargin{:}                                     ...
                       );
            end
        else
            if  isempty(f_map)
                plot3(      S.points(1,:), S.points(2,:), S.points(3,:),    ...
                            'Marker', '.',                                  ...
                            'MarkerSize', 4,                                ...
                            'LineStyle', 'none',                            ...
                            varargin{:}                                     ...
                       );       
            else
                scatter3(   S.points(1,:), S.points(2,:), S.points(3,:),    ...
                            f_map*10,                                              ...
                            f_map,                                         ...
                            'Marker', '.',                                  ...
                            varargin{:}                                     ...
                       );      
            end
        end
    end
    if show_source
        plot3(0,0,0,'go','MarkerSize',10);
        plot3(0,0,0,'gx','MarkerSize',10);
    end
    hold off
    set(gca,'Color' ,bgcolor)
    set(gcf,'Color' ,bgcolor)
    set(gca,'XColor',bgcolor)
    set(gca,'YColor',bgcolor)
    set(gca,'ZColor',bgcolor)
    set(gca,'XTick' ,[])
    set(gca,'YTick' ,[])
    set(gca,'ZTick' ,[])
    set(gcf,'Name'  ,sprintf('Time : %f | Scan size : %d',S.timestamp,size(S.points,2)));
end