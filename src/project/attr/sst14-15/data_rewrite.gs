'reinit'
'open /cpc/prcp/PRODUCTS/CMAP/monthly/current/cmap_mon.lnx.ctl'
'set gxout fwrite'
'set fwrite /cpc/home/wd52pp/data/attr/djf14-15/prate.1979-2015.cmap.mon.gr'
'set x 1 144'
'set y 1 72'
'set t 1 12'
'define pc=ave(cmap,t+0,t=434,1yr)'
'modify pc seasonal'
'set t 1'
k=1
while ( k <= 434)
'set t 'k''
'd cmap-pc'
k=k+1
endwhile
'c'
