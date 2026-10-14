function [gmv,vol_gmv,rend_gmv,sharpe_eff] = GMV_vincolato(matrice_covarianze, rendimenti_medi,rendimento_effettivo)

% Trova pesi del portafoglio a varainza minima

rendimenti_medi=rendimenti_medi(:);
rendimento_effettivo = rendimento_effettivo(:);
num_titoli = size(rendimenti_medi,1);

prob = optimproblem('Description','Trovare GMV',"ObjectiveSense","min");
pesi = optimvar('pesi',num_titoli,1,LowerBound=0,UpperBound=1);

prob.Constraints.sommapesi = sum(pesi) == 1; 

f = 0.5*pesi'*matrice_covarianze*pesi;
prob.Objective = f;

initialGuess.pesi = zeros(size(pesi));

sol = solve(prob,initialGuess);
gmv = sol.pesi;
vol_gmv = sqrt(gmv' * matrice_covarianze * gmv);     
rend_gmv = rendimento_effettivo' * gmv;                   
sharpe_eff = rend_gmv / vol_gmv;                     

end