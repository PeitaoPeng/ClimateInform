'reinit'
'open /cpc/home/wd52pp/data/attr/sst14-15/prate.1979-cur.cmap.mon.ctl'
'set x 1 144'
'set y 1  72'
'set gxout fwrite'
'set fwrite /cpc/home/wd52pp/data/attr/sst14-15/prate.1979-cur.cmap.3mon.gr'
k=2
while ( k <= 434)
'set t 'k''
'd ave(p,t-1,t+1)'
k=k+1
endwhile
'c'
