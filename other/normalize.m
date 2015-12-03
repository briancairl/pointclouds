function u = normalize(v,type)
    dims = size(v);
    if any(dims==1)
        
        if      strcmpi(type,'MINMAX')
            m1= min(v);
            m2= max(v);
            u = (v-m1)/(m2-m1);
        elseif  strcmpi(type,'SUM')
            u = v / sum(v);
        elseif  strcmpi(type,'MAX')
            u = v / max(v);
        end
    else
        error('V must be 1-by-N or N-by-1');
    end
end