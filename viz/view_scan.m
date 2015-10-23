% VIEW_SCAN
%
% @brief    Plots a single scan
%
% @input    S       valid scan struct
function view_scan(S,varargin)
    
    % Defaults
    show_normals = true;
    show_source  = true;
    show_shade   = false;
    scores       = [];
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
        elseif  strcmpi(varargin{idx},'SHADE')
            show_shade  = strcmpi(varargin{idx+1},'ON');
            delvar      = [delvar,idx,idx+1]; %#ok<AGROW>
        elseif  strcmpi(varargin{idx},'SCORES')
            scores      = varargin{idx+1};
            delvar      = [delvar,idx,idx+1]; %#ok<AGROW>
        elseif  strcmpi(varargin{idx},'BACKGROUNDCOLOR')
            bgcolor     = varargin{idx+1};
            delvar      = [delvar,idx,idx+1]; %#ok<AGROW>
        end
    end
    varargin(delvar)=[];
    if ~isempty(S.points)
        if  (size(S.points,1)==6) && show_normals
            if  isempty(scores)
                quiver3(    S.points(1,:), S.points(2,:), S.points(3,:),    ...
                            S.points(4,:), S.points(5,:), S.points(6,:),    ...
                            'Marker', '.',                                  ...
                            'MarkerSize', 4,                                ...
                            varargin{:}                                     ...
                       );
            else
                quiver3(    S.points(1,:), S.points(2,:), S.points(3,:),    ...
                            S.points(4,:), S.points(5,:), S.points(6,:),    ...
                            scores,                                         ...
                            'Marker', '.',                                  ...
                            'MarkerSize', 4,                                ...
                            varargin{:}                                     ...
                       );
            end
        else
            if  isempty(scores)
                plot3(      S.points(1,:), S.points(2,:), S.points(3,:),    ...
                            'Marker', '.',                                  ...
                            'MarkerSize', 4,                                ...
                            'LineStyle', 'none',                            ...
                            varargin{:}                                     ...
                       );       
            else
                scatter3(   S.points(1,:), S.points(2,:), S.points(3,:),    ...
                            3*scores+1,                                     ...
                            score2colors(scores,show_shade),                ...
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
    set(gca,'Color',bgcolor)
    set(gcf,'Color',bgcolor)
    set(gca,'XColor',bgcolor)
    set(gca,'YColor',bgcolor)
    set(gca,'ZColor',bgcolor)
    set(gcf,'Name',sprintf('Time : %f | Scan size : %d',S.timestamp,size(S.points,2)));
end

function C = score2colors(scores,shade)
    cm  = colormap;
    N   = size(cm,1);
    ns  = (scores+eps)/(max(scores)+eps);
    ni  = ceil(ns*N);
    if shade
        C = cm(ni,:).*repmat(ns,1,3);
    else
        C = cm(ni,:);
    end
end