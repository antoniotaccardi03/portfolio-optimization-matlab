function [pesi , rendimento , volatilita , sharpe_eff] = ew(matrice_cov , rendimenti_medi, rendimento_effettivo)
% Calcola peso del portafoglio equally weighted
rendimenti_medi = rendimenti_medi(:);
rendimento_effettivo = rendimento_effettivo(:);
num_titoli = size(rendimenti_medi,1);
pesi = ones(num_titoli,1)/num_titoli;
rendimento = pesi'*rendimento_effettivo;
volatilita = sqrt(pesi'*matrice_cov*pesi);
sharpe_eff = rendimento/volatilita;
end