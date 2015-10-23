% VIEW_FRAMES
%
% @brief    Shows a sequence of scans, F,  at a specified fps
%
% @input    S       valid scan struct
function view_frames(F,fps,area_size,varargin)
    period = 1/fps;
    hold on
    axis(area_size*[-1,1,-1,1,-1,1]);
    for idx = 1:numel(F)
        cla
        view_scan(F{idx},'Color','w',varargin{:});
        pause(period);
    end
    hold off
end