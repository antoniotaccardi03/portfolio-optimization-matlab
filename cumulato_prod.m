function [cumulato]= cumulato_prod(r)
% CUMULATO_PROD
% Calcola rendimento cumulato tramite capitalizzazione composta


    r = r(:);               
    cumulato = cumprod(1 + r) - 1;
end 