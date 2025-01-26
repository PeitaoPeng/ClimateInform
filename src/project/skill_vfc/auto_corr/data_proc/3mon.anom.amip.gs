reinit
'open /cpc/home/wd52pp/data/skill_ac/z200.amip.ctl'
*
'set gxout fwrite'
'set fwrite /cpc/home/wd52pp/data/skill_ac/z200.3mon.fma1981-jfm2021.amip.gr'
'set x 1 144'
'set y 1  73'
* have 1981-2010 clim
'set t 1 12'
'define clim=ave(z,t+0,t=360,1yr)'
'modify clim seasonal'
'set t 2 474'
'd ave(z-clim,t-1,t+1)'
