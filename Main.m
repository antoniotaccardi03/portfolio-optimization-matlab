

clc , clear all ,close all

%%
%Importo i dati 
[rendimenti ,tickers]= xlsread('DATI.xlsx','Returns_giornalieri');
mercato = xlsread('Eurostoxx.xlsx','Rendimenti');

%%

numero_titoli = size(rendimenti,2);
nomi_strategie = {'Equally weighted' , 'Mean Variance Constraint' , 'Global Minimum Variance','Risk Parity' , 'Most Diversified Portfolio'};

dimensione_portafoglio = 15 ;

durata_periodi = inputdlg({'Durata perido IS' , 'Durata periodo OOS*' , 'Durata periodo OOS**'},'Selezione periodi analisi',[1 50]);

durataIS = str2double(durata_periodi{1});
durataOOS1 = str2double(durata_periodi{2});
durataOOS2 = str2double(durata_periodi{3});


totale_OOS = durataOOS1 + durataOOS2;
totale_giorni = durataIS+durataOOS1+durataOOS2;
%%

OOS_returns_2 = rendimenti(end-durataOOS2+1 : end, :);                   
OOS_returns_1 = rendimenti(end-durataOOS2-durataOOS1+1 : end-durataOOS2, :);  
IS_returns = rendimenti(end-totale_giorni+1 : end-durataOOS2-durataOOS1, :); 
complessivo_OOS = [OOS_returns_1 ; OOS_returns_2];
%%
% Inizializzare le matrici 
[ew,mvc,gmv,rp,mdp]=deal(zeros(numero_titoli+3,size(complessivo_OOS,1)));
migliore_startegia = strings(size(complessivo_OOS,1),1);
quote_strategia_vincente = zeros(numero_titoli,size(complessivo_OOS,1));
 
%%


for i = 1:size(complessivo_OOS,1);
    rendimenti_medi = mean(IS_returns)';
    matr_covIS = cov(IS_returns);
    rendimento_effettivo = complessivo_OOS(i,:);
    [ew(:,i),mvc(:,i),gmv(:,i),rp(:,i),mdp(:,i)] = calcola_startegie(matr_covIS,rendimenti_medi,rendimento_effettivo);
    IS_returns(1,:) = [];
    IS_returns(end+1,:) = complessivo_OOS(i,:);

    sharpe_ratio = [ew(end,:);mvc(end,:);gmv(end,:);rp(end,:);mdp(end,:)];

    [~,posizione] = max(sharpe_ratio(:,i));
    
    migliore_startegia(i) = nomi_strategie(posizione) ;

    if posizione == 1 
        quote_strategia_vincente(:,i) = ew(1:numero_titoli,i);
    elseif posizione == 2
        quote_strategia_vincente(:,i) = mvc(1:numero_titoli,i);
    elseif posizione == 3
        quote_strategia_vincente(:,i) = gmv(1:numero_titoli,i);
    elseif posizione == 4
        quote_strategia_vincente(:,i) = rp(1:numero_titoli,i);
    elseif posizione == 5
        quote_strategia_vincente(:,i) = mdp(1:numero_titoli,i);
    end 
end

%%

% calcolo media peso per ogni titolo 
media_pesi_titoliWIN = mean(quote_strategia_vincente(:,1:durataOOS1),2);

% calcolo del vettore delle medie dei pesi rilevati per singolo titolo
[pesi_ordinati , idx_vincenti , pesi_top15 , ticker_top15 , idx_top15]=sorting_pesi(media_pesi_titoliWIN,dimensione_portafoglio,tickers);


%% 
mercato_OS = mercato(end-durataOOS2-durataOOS1+1 : end-durataOOS2, :);

bb = cumulato_prod(mercato_OS);

cum_ew = cumulato_prod(ew(end-2,1:durataOOS1));
cum_mvc = cumulato_prod(mvc(end-2,1:durataOOS1));
cum_gmv = cumulato_prod(gmv(end-2,1:durataOOS1));
cum_rp = cumulato_prod(rp(end-2,1:durataOOS1));
cum_mdp = cumulato_prod(mdp(end-2,1:durataOOS1));



% pesi nel periodo OS*
w = quote_strategia_vincente(:, 1:durataOOS1)';

% rendimenti asset OS*
R = OOS_returns_1;

% rendimento giornaliero portafoglio
rendimenti_modello = sum(w .* R, 2);

% cumulato modello
dd = cumulato_prod(rendimenti_modello);


figure;
hold on;
plot(1:durataOOS1, bb, 'r-', 'LineWidth', 2.5,DisplayName='Benchmark');
plot(1:durataOOS1, dd, 'b-', 'LineWidth', 2.5, DisplayName='Modello');
plot(1:durataOOS1,cum_ew,'g:','LineWidth', 1.5, DisplayName='EW')
plot(1:durataOOS1,cum_mvc,'y-.','LineWidth', 1.5, DisplayName='MVC')
plot(1:durataOOS1,cum_gmv,'c:','LineWidth', 1.5,DisplayName='GMV')
plot(1:durataOOS1,cum_rp,'--','LineWidth', 1.5, DisplayName='RP')
plot(1:durataOOS1,cum_mdp,'magenta:','LineWidth', 1.5,DisplayName='MDP')
hold off;

xlabel('Giorni (OS*)');
ylabel('Rendimento cumulato');

title('Confronto Modello vs Eurostoxx (OS*)');

legend('show','Location', 'bestoutside');
grid on;




%% 
IS_backtest = OOS_returns_1; 
n_top = size(pesi_top15,1);

[ew_back, mvc_back, gmv_back, rp_back, mdp_back] = deal(zeros(n_top + 3, durataOOS2));
strategia_vincente_back = strings(durataOOS2, 1);
pesi_vincenti_back = zeros(n_top, durataOOS2);
rendimenti_portafoglio_back = zeros(durataOOS2, 1);



for i = 1:durataOOS2
    % Sottomatrice top-15
    IS_top15  = IS_backtest(:, idx_top15);        
    matr_covBack        = cov(IS_top15, 1);
    ret_back        = mean(IS_top15)';
    r_eff    = OOS_returns_2(i, idx_top15)';     

    [ew_back(:,i), mvc_back(:,i), gmv_back(:,i), rp_back(:,i), mdp_back(:,i)] = calcola_startegie(matr_covBack, ret_back, r_eff);
    IS_backtest(1,:)     = [];
    IS_backtest(end+1,:) = OOS_returns_2(i,:);   

    sharpe_back = [ew_back(end,:); mvc_back(end,:); gmv_back(end,:); rp_back(end,:); mdp_back(end,:)];
    
    [~, posizione_back] = max(sharpe_back(:, i));
    
    strategia_vincente_back(i) = nomi_strategie(posizione_back);
    
    if posizione_back == 1
        pesi_vincenti_back(:, i) = ew_back(1:n_top, i);
    elseif posizione_back == 2
        pesi_vincenti_back(:, i) = mvc_back(1:n_top, i);
    elseif posizione_back == 3
        pesi_vincenti_back(:, i) = gmv_back(1:n_top, i);
    elseif posizione_back == 4
        pesi_vincenti_back(:, i) = rp_back(1:n_top, i);
    elseif posizione_back == 5
        pesi_vincenti_back(:, i) = mdp_back(1:n_top, i);
    end
    
    rendimenti_portafoglio_back(i) = pesi_vincenti_back(:, i)' * OOS_returns_2(i, idx_top15)';
end
            


% Rendimento cumulato
performance_cumulata_back = cumulato_prod(rendimenti_portafoglio_back);

% Benchmark su OS**
benchmark_OS2 = mercato(end-durataOOS2+1 : end, :);
benchmark_cumulato_OS2 = cumulato_prod(benchmark_OS2);




%% STATISTICHE AGGIUNTIVE


[beta,alpha,corr,vol_mercato,vol_portBack] = Beta(rendimenti_portafoglio_back,benchmark_OS2);


alpha
if alpha > 0
    disp('Il portafoglio ha sovraperformato il mercato')
elseif alpha == 0
    disp('Il rendimento del portafoglio è intermanente spiegato dal mercato (CAPM)')
elseif alpha < 0
    disp('Il portafoglio ha sottoperformato il mercato')
end

beta
if beta > 1 
    disp('Portafoglio più volatile del mercato')
else 
    disp('Portafoglio meno volatile del mercato')
end


Information_ratio = IR(rendimenti_portafoglio_back,benchmark_OS2)


sharpe_portfolioBack = mean(rendimenti_portafoglio_back) / vol_portBack;
sharpe_benchmark = mean(benchmark_OS2)/vol_mercato;




%%


cum_ew_back = cumulato_prod(ew_back(end-2,1:durataOOS2));
cum_mvc_back = cumulato_prod(mvc_back(end-2,1:durataOOS2));
cum_gmv_back = cumulato_prod(gmv_back(end-2,1:durataOOS2));
cum_rp_back = cumulato_prod(rp_back(end-2,1:durataOOS2));
cum_mdp_back = cumulato_prod(mdp_back(end-2,1:durataOOS2));


figure;
hold on;
plot(1:durataOOS2, benchmark_cumulato_OS2, 'r-', 'LineWidth', 2.5,DisplayName='Benchamrk');
plot(1:durataOOS2, performance_cumulata_back, 'b-', 'LineWidth', 2.5,DisplayName='Modello Top 15');
plot(1:durataOOS2,cum_ew_back,'g:','LineWidth', 1.5, DisplayName='EW')
plot(1:durataOOS2,cum_mvc_back,'y-.','LineWidth', 1.5, DisplayName='MVC')
plot(1:durataOOS2,cum_gmv_back,'c:','LineWidth', 1.5,DisplayName='GMV')
plot(1:durataOOS2,cum_rp_back,'--','LineWidth', 1.5, DisplayName='RP')
plot(1:durataOOS2,cum_mdp_back,'magenta:','LineWidth', 1.5,DisplayName='MDP')
txt1 = [ 'Sharpe Ratio Benchmark : ' num2str(sharpe_benchmark,2)];
txt2 = ['Sharpe Ratio Modello : ' num2str(sharpe_portfolioBack,2)];

text(0.02, 0.95, txt1,'Units','normalized','FontSize',12,'FontWeight','bold','EdgeColor','white','BackgroundColor','r','Color','white')

text(0.02, 0.88, txt2, 'Units','normalized', 'FontSize',12,'FontWeight','bold','EdgeColor','white','BackgroundColor','b','Color','white')

legend('show','Location','bestoutside')
hold off;
xlabel('Giorni (OS**)');
ylabel('Rendimento cumulato');
title('Backtest OS**: Modello (Top 15) vs Eurostoxx');

grid on;

%%



