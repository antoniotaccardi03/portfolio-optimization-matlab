function [RisultatiEW,RisultatiMVC,RisultatiGMV,RisultatiRP,RisultatiMDP] = ...
    calcola_startegie(matr_cov,rend_medio,rendimento_effettivo)

numero_titoli = size(matr_cov,1);

RisultatiEW  = NaN(numero_titoli+3,1);
RisultatiMVC = NaN(numero_titoli+3,1);
RisultatiGMV = NaN(numero_titoli+3,1);
RisultatiRP  = NaN(numero_titoli+3,1);
RisultatiMDP = NaN(numero_titoli+3,1);

%% Equally Weighted

[pesi_EW,rend_EW,vol_EW,sharpe_EW] = ew(matr_cov,rend_medio,rendimento_effettivo);

RisultatiEW(1:numero_titoli) = pesi_EW;
RisultatiEW(end-2) = rend_EW;
RisultatiEW(end-1) = vol_EW;
RisultatiEW(end)   = sharpe_EW;

%% Mean Variance Constraint

[pesi_MVC,rend_MVC,vol_MVC,sharpe_MVC] = mean_variance_constraint(matr_cov,rend_medio,rendimento_effettivo);

RisultatiMVC(1:numero_titoli) = pesi_MVC;
RisultatiMVC(end-2) = rend_MVC;
RisultatiMVC(end-1) = vol_MVC;
RisultatiMVC(end)   = sharpe_MVC;

%% Global Minimum Variance

[pesi_GMV,rend_GMV,vol_GMV,sharpe_GMV] = GMV_vincolato(matr_cov,rend_medio,rendimento_effettivo);

RisultatiGMV(1:numero_titoli) = pesi_GMV;
RisultatiGMV(end-2) = rend_GMV;
RisultatiGMV(end-1) = vol_GMV;
RisultatiGMV(end)   = sharpe_GMV;

%% Risk Parity

[pesi_RP,rend_RP,vol_RP,sharpe_RP] = riskparity(matr_cov,rend_medio,rendimento_effettivo);

RisultatiRP(1:numero_titoli) = pesi_RP;
RisultatiRP(end-2) = rend_RP;
RisultatiRP(end-1) = vol_RP;
RisultatiRP(end)   = sharpe_RP;

%% Most Diversified Portfolio

[pesi_MDP,rend_MDP,vol_MDP,sharpe_MDP] = most_diversified_portfolio(matr_cov,rend_medio,rendimento_effettivo);

RisultatiMDP(1:numero_titoli) = pesi_MDP;
RisultatiMDP(end-2) = rend_MDP;
RisultatiMDP(end-1) = vol_MDP;
RisultatiMDP(end)   = sharpe_MDP;

end