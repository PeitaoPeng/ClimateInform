reinit
var=amo
*var=pdo
*var=nino34
mons=1
*while(mons<=12)
while(mons<=1)
reinit
'open /export-12/cacsrv1/wd52pp/obs/'var'_idx/'var'_mon.1900-2010.ctl'
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
*
'set gxout fwrite'
'set fwrite /export-12/cacsrv1/wd52pp/obs/'var'_idx/'var'_'season'.1951-2010.gr'
'set x 1'
'set y 1'
'set z 1'
'set t 1 12'
* clim 1951-2010
'define clim=ave(t,t+612,t=1323,1yr)'
'modify clim seasonal'
'set t 1'
*
if(mons = 12)
'd ave(t-clim,t=612,t=614)'
endif
*
ms=mons
me=mons+2
*
k=612
while(k<=1320)
ks=k+ms
ke=k+me
'd ave(t-clim,t='ks',t='ke')'
k=k+12
endwhile
*
* write out seasonal clim 
*'d ave(clim,t='ms',t='me')'
*
mons=mons+1
endwhile
