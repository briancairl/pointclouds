function X = points(S,varargin)
    if  numel(varargin) % for particular elements
        X = S.points(1:3,varargin{1});
    else
        X = S.points(1:3,:);
    end
end