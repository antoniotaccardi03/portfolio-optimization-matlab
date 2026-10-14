function [pesi, rendimento, volatilita, sharpe_eff] = riskparity(matrice_cov, rendimenti_medi,rendimento_effettivo)

    rendimento_effettivo = rendimento_effettivo(:);
    num_titoli = size(matrice_cov, 1);

    obj = @(w) sum( ((matrice_cov * w) .* w ...
                      / (w' * matrice_cov * w) ...
                      - 1/num_titoli).^2 );

    w0   = ones(num_titoli, 1) / num_titoli;   
    Aeq  = ones(1, num_titoli);
    beq  = 1;
    lb   = zeros(num_titoli, 1);

    opts = optimoptions('fmincon', ...
        'Display',       'off', ...
        'MaxIterations', 2000,  ...
        'TolFun',        1e-12, ...
        'TolX',          1e-12);

    pesi = fmincon(obj, w0, [], [], Aeq, beq, lb, [], [], opts);
    pesi = pesi / sum(pesi);             

    rendimento = pesi' * rendimento_effettivo;
    volatilita = sqrt(pesi' * matrice_cov * pesi);
    sharpe_eff = rendimento / volatilita;
end