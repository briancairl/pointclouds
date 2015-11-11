% VIEW_FRAMES
%
% @brief    Shows a sequence of scans, F,  at a specified fps
%
% @input    S       valid scan struct
function varargout = view_frames(F,fps,area_size,varargin)
    period = 1/fps;
    hold on
    axis(area_size*[-1,1,-1,1,-1,1]);
    if nargout == 1
        varargout{1} = repmat(struct('cdata',[],'colormap',[]),numel(F),1);
    end
    for idx = 1:numel(F)
        cla
        view_scan(F{idx},'Color','w',varargin{:});
        if nargout == 1
            varargout{1}(idx) = getframe(gca);
        end
        pause(period);
    end
    hold off
end