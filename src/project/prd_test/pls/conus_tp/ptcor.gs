'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open hrcn_hadoisst.jun.pat.ctl'
'open hrcn_hadoisst.jun.hcst.pat.ctl'
*
'set t 5'
'define sr=sqrt(aave(r2*r2,lon=100,lon=360,lat=-30,lat=60))'
'define sc=sqrt(aave(cor.2*cor.2,lon=100,lon=360,lat=-30,lat=60)))'
'define rc=aave(r2*cor.2,lon=100,lon=360,lat=-30,lat=60))'
'define spc=rc/(sr*sc)'
