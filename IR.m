function [Information_Ratio] = IR(rendimenti_portafoglioAttivo , rendimento_benchmark)

% Questa funzione restituisce l'information Ratio una misura delle
% performance dei portafoglio a gestione attiva 

rendimenti_portafoglioAttivo = rendimenti_portafoglioAttivo(:);
rendimento_benchmark = rendimento_benchmark(:);

tracking_error =  rendimenti_portafoglioAttivo - rendimento_benchmark;

exp_tracking_error = mean(tracking_error);
vol_tracking_error = std(tracking_error);

Information_Ratio = exp_tracking_error / vol_tracking_error;
end

