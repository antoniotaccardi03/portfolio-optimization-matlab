function [quote_ordinate , idx , pesi_top , nome_pesiTop , idx_top ] = sorting_pesi(quote_vincenti , dimensione_portafoglio , nomi_titoli)

[quote_ordinate,idx] = sort(quote_vincenti ,'descend');
pesi_top = quote_ordinate(1:dimensione_portafoglio,:);
nome_pesiTop = nomi_titoli(idx(1:dimensione_portafoglio,:))';
idx_top = idx(1:dimensione_portafoglio,:);

end