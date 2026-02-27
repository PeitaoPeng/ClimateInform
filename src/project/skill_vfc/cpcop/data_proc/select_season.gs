var=temp
cat=below
mons=12
'open /cpc/home/wd52pp/data/cpc_vfc/0data/'var'01_forecast_'cat'.ctl'
if(mons = 1) ; season = jfm ; endif
if(mons = 2) ; season = fma ; endif
if(mons = 3) ; season = mam ; endif
if(mons = 4) ; season = amj ; endif
if(mons = 5) ; season = mjj ; endif
if(mons = 6) ; season = jja ; endif
if(mons = 7) ; season = jas ; endif
if(mons = 8) ; season = aso ; endif
if(mons = 9) ; season = son ; endif
if(mons = 10) ; season = ond ; endif
if(mons = 11) ; season = ndj ; endif
if(mons = 12) ; season = djf ; endif
'set x 1 36'
'set y 1 19'
'set gxout fwrite'
'set fwrite 'var'_forecast.'cat'.'season'.gr'
*
k=mons
while(k<=257)
'set t 'k''
'd t'
k=k+12
endwhile
