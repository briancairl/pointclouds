function C = scale2color(s)
    if  (size(s,1)==1) || (size(s,2)==1)
        c = ( s - min(s) + eps ) / ( max(s) - min(s) + eps );
        cm= colormap;
        ci= ceil(c*size(cm,1));
        C = cm(ci,:);
    else
        error('S must be 1-by-N or N-by-1')
    end
end