function cleanfig(f,color,varargin)
    a = get(f,'CurrentAxes');
    
    set(a,'XTick',[])
    set(a,'YTick',[])
    set(a,'ZTick',[])
    
    set(a,'XColor',color)
    set(a,'YColor',color)
    set(a,'ZColor',color)
    
    set(a,'Color',color)
    set(f,'Color',color)
    
    for idx = 1:2:numel(varargin)
        set(f,varargin{idx},varargin{idx+1});
    end
    
    axis(a,'equal')
end