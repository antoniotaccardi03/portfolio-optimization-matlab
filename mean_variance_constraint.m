function [pesi , rendimento , volatilita , sharpe_eff] = mean_variance_constraint(matrice_cov , rendimenti_medi , rendimento_effettivo)

% Calcola il portafoglio Mean Variance Constraint

rendimenti_medi = rendimenti_medi(:);
rendimento_effettivo = rendimento_effettivo(:);

numero_titoli = size(rendimenti_medi,1);

prob = optimproblem('ObjectiveSense','max');

pesi = optimvar('pesi',numero_titoli);

f = rendimenti_medi'*pesi - 5*(pesi'*matrice_cov*pesi);

prob.Objective = f;

prob.Constraints.somma_pesi = sum(pesi) == 1;
prob.Constraints.no_short = pesi >= 0;

sol = solve(prob);

pesi = round(sol.pesi,5);

rendimento = pesi' * rendimento_effettivo;

volatilita = sqrt(pesi' * matrice_cov * pesi);

sharpe_eff = rendimento / volatilita;

end