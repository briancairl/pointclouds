function [Uave,Aave] = meannormal(U)
    A   = u2a(U);
    if any(isnan(A))
        error('NaN valued angle.')
    end
    Aave= mean(A,2);
    Uave= a2u(Aave);
end