% VIEW_SCAN
%
% @brief    Plots a single scan
%
% @input    S       valid scan struct
function viewscan(S,varargin)
    
    % Auto-create scan from raw points
    if isnumeric(S)
       S = scan('Points',S); 
    end

    % Defaults
    viewsize                = -1;
    map                     = [];
    show_map                = false;
    show_normals            = false;
    show_source             = true;
    show_rgb                = (~show_map) && iscolored(S);
    point_color             = 'w';
    normal_color            = 'w';
    background_color        = [0,0,0];
    nvararg                 = numel(varargin);
    markersize              = 3;
    


    hold on 
    for idx = 1:2:nvararg
        if      field(varargin,'NORMALS')
            show_normals    = strcmpi( param(varargin,'CHAR') ,'ON');
        elseif  field(varargin,'VIEWSIZE')
            viewsize        = param(varargin,'DOUBLE');
        elseif  field(varargin,'SOURCE')
            show_source     = strcmpi( param(varargin,'CHAR') ,'ON');
        elseif  field(varargin,'MARKERSIZE')
            markersize      = param(varargin,'DOUBLE');
        elseif  field(varargin,'RGB')
            show_rgb        = strcmpi( param(varargin,'CHAR') ,'ON');
            if  iscolored(S)
                if  show_rgb
                    point_color = S.colors;
                end
            else
                show_rgb = false;
                warning('Cannot use RBG to color pointcloud. Does not have this attribute.');
            end
        elseif  field(varargin,'MAP')
            map = varargin{2};
            if  size(map,2) ~= size(S)
                warning('MAP must be 1-by-size(S). Cannot render.');
            else
                map = varargin{2};
            end
            show_map = ~isempty(map);
        elseif  field(varargin,'BACKGROUNDCOLOR')
            background_color= param(varargin,'DOUBLE');
        elseif  field(varargin,'POINTCOLOR')
            point_color 	= param(varargin,'DOUBLE');
        elseif  field(varargin,'NORMALCOLOR')
            normal_color 	= param(varargin,'DOUBLE');            
        else
            error(['Unrecognized option : ',varargin{1}]);
        end
        varargin(1:2)       = [];
    end
    
    % Point colors are scaled (MAP option)
    if  show_map
        point_color         = map;       
    end
    
    hold on
    
    % Show the points
    if  isempty(S)
        warning('Pointcoud is empty. Will not render.');
    else
        
        if  show_map || show_rgb
            scatter3(   S.points(1,:), S.points(2,:), S.points(3,:),    ...
                        markersize,                                     ...
                        transpose(point_color),                         ...
                        'Marker', '.'                                   ...
                   );           
        else
            plot3(      S.points(1,:), S.points(2,:), S.points(3,:),    ...
                        'Marker', '.',                                  ...
                        'MarkerSize', markersize,                       ...
                        'LineStyle', 'none',                            ...
                        'Color',point_color                             ...
                   );  
        end
        
        
        if  show_normals && issurf(S)
            quiver3(    S.points(1,:), S.points(2,:), S.points(3,:),    ...
                        S.normals(1,:),S.normals(2,:),S.normals(3,:),   ...
                        markersize/2,                                     ...
                        'Color',normal_color                            ...
                   );  
        end
        
    end
    
    
    % Show the point-cloud source (sensor base)
    if  show_source
        plot3(0,0,0,'go','MarkerSize',8);
        plot3(0,0,0,'gx','MarkerSize',8);
    end
    hold off

    
    % Rename the figure
    cleanfig(gcf,           ...
        'ViewSize',         ...
        viewsize,           ...
        'Color',            ...
        background_color,   ...
        'Name',     ...
            sprintf('Time : %f | Size : %d | Surface : %s | Colored : %s',...
                S.timestamp,        ...
                size(S),            ...
                YNSTR(issurf(S)),   ...
                YNSTR(iscolored(S)) ...
            )...
        );
end









% Helpers
function str = YNSTR(bool)
    if  bool
        str = 'Yes';
    else
        str = 'No';
    end
end
function b = field(argv,name)
    b = strcmpi(argv{1},name);
end
function str = param(argv,type)
    str = argv{2};
    %if ~strcmpi( class(par), type )
    %   error( sprintf( 'Field [%s] supplied mismatching parameter type [%s].',argv{1},type) ) 
    %end
end