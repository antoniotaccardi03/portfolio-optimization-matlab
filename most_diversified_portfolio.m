function [pesi, rendimento, volatilita, sharpe_eff] = most_diversified_portfolio(matrice_cov, rendimenti_medi, rendimento_effettivo)

% Calcola il portafoglio Most Diversified Portfolio

rendimenti_medi = rendimenti_medi(:);
rendimento_effettivo = rendimento_effettivo(:);

numero_titoli = size(rendimenti_medi, 1);

deviazioni_std = sqrt(diag(matrice_cov));

prob = optimproblem('ObjectiveSense', 'max');

pesi = optimvar('pesi', numero_titoli);

diversification_ratio = sum(pesi .* deviazioni_std) / sqrt(pesi' * matrice_cov * pesi);

prob.Objective = diversification_ratio;

prob.Constraints.somma_pesi = sum(pesi) == 1;
prob.Constraints.no_short = pesi >= 0;

% PUNTO DI PARTENZA (OBBLIGATORIO!)
initialGuess.pesi = ones(numero_titoli, 1) / numero_titoli;

% OPZIONI PER SILENZIARE L'OUTPUT
options = optimoptions('fmincon', 'Display', 'off');

% RISOLUZIONE CON INITIAL GUESS E OPZIONI
sol = solve(prob, initialGuess, 'Options', options);

pesi = round(sol.pesi, 5);

rendimento = pesi' * rendimento_effettivo;

volatilita = sqrt(pesi' * matrice_cov * pesi);

sharpe_eff = rendimento / volatilita;

end