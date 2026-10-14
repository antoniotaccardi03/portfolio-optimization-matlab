function rend_cum(pesi_win,pesi_ew , pesi_mvc , pesi_gmv , pesi_rp,pesi_mdp, rendimenti_oos);


rendimenti_win = pesi_win * rendimenti_oos;
rendimenti_ew = pesi_ew * rendimenti_oos;
rendimenti_gmv = pesi_gmv * rendimenti_oos;
rendimenti_mvc = pesi_mvc * rendimenti_oos;
rendimenti_mdp = pesi_mdp * rendimenti_oos;
rendimenti_rp = pesi_rp * rendimenti_oos;

 % capitalizzo i rendimenti delle strategie
cap_ew = cumsum(sum(rendimenti_ew));
cap_gmv = cumsum(sum(rendimenti_gmv));
cap_mvc = cumsum(sum(rendimenti_mvc));
cap_mdp =cumsum(sum(rendimenti_mdp));
cap_rp = cumsum(sum(rendimenti_rp));

end





