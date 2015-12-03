function cleanfig(f,varargin)
    a = get(f,'CurrentAxes');
    
    viewsize = -1;
    color    = 'k';
    
    for idx = 1:2:numel(varargin)
        if  strcmpi(varargin{idx},'VIEWSIZE')
            viewsize = varargin{idx+1};
        elseif  strcmpi(varargin{idx},'COLOR')
            color = varargin{idx+1}; 
        else
            set(f,varargin{idx},varargin{idx+1});
        end
    end
    

    set(a,'XTick',[])
    set(a,'YTick',[])
    set(a,'ZTick',[])
    
    set(a,'XColor',color)
    set(a,'YColor',color)
    set(a,'ZColor',color)
    
    set(a,'Color',color)
    set(f,'Color',color)
    
    if viewsize < 0
        axis(a,'equal');
    else
        axis(viewsize*[-1,1,-1,1,-1,1]);
    end
end