var=prcp
*
run=1
while(run<=12)
*
mons=1
while(mons<=12)
reinit
'open 'var'_5094.run'run'.ctl'
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
'set fwrite 'var'_5094'season'.run'run'.i3e'
'set x 1 128'
'set y 1 64'
'set t 1 12'
* clim 50-94
'define clim=ave(z,t+0,t=540,1yr)'
'modify clim seasonal'
'set t 1'
*
if(season = djf)
'd ave(z-clim,t=1,t=2)'
endif
*
ms=mons
me=mons+2
*
k=0
kend=528
*
if(season = djf)
kend=526
endif
*
if(season = ndj)
kend=527
endif
*
while(k<=kend)
ks=k+ms
ke=k+me
'd ave(z-clim,t='ks',t='ke')'
k=k+12
endwhile
*
if(season = ndj)
'd ave(z-clim,t=539,t=540)'
endif
*
* write out seasonal clim 
'd ave(clim,t='ms',t='me')'
*
mons=mons+1
endwhile
*
run=run+1
endwhile
