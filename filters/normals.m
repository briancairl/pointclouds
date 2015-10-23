function X = normals(S,varargin)
    if numel(varargin) % for particular elements
        X = S.points(4:6,varargin{1});
    else
        X = S.points(4:6,:);
    end
end