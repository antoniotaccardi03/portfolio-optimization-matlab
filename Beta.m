function [beta , alpha ,correlazione , vol_mercato , vol_port] = Beta(rendimenti_portfolio , rendimenti_mercato)

% Questa funzione calcola il beta tra il portafoglio e l'indice di
% riferimento

rendimenti_portfolio = rendimenti_portfolio(:);
rendimenti_mercato = rendimenti_mercato(:);

vol_port = std(rendimenti_portfolio);
var_mercato = var(rendimenti_mercato);
vol_mercato = sqrt(var_mercato);

correlazione = corr(rendimenti_mercato,rendimenti_portfolio);

covarianza = correlazione*vol_mercato*vol_port;

beta = covarianza/var_mercato;


media_port = mean(rendimenti_portfolio);
media_mercato = mean(rendimenti_mercato);

alpha = media_port - beta * media_mercato;




