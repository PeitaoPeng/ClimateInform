'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/wk34/ac_2d_ca_olr_wkly.winter.mm10.ctl'
'open /cpc/home/wd52pp/data/wk34/ac_2d_ca_psi200_wkly.winter.mm30.ctl'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
'draw string 5.5 7.25 Area Averaged CA Forecast Skill(ACC) for OLR and PSI200'
*'draw string 5.5 7.25 DJFM 1979/80-2012/13'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.15 0.15'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=1.5;  xlen=8.5;  xgap=0.6
ymax0=7.; ylen=-6.0;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+0.5
  titly=ymax+0.2
  labx=xmin-0.65
  laby=ymin+3.
  sx1=6
  sy1=6
  sy2=5.6
  sy3=5.2
  sy4=4.8
  
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set mproj scaled'
*'set xlab off'
'set xlabs CA_IC | WEEK1 | WEEK2 | WEEK3 | WEEK4 | WEEK3-4 '
'set vrange 0 1.0'
'set grads off'
*'set grid off'
'set cthick 7'
'set cstyle 1'
'set cmark 5'
'set ccolor 2'
'set x 1'
'set y 50'
'set t 1 6'
'd tloop(aave(ac,lon=80,lon=280,lat=-15,lat=15))'
'set ccolor 1'
'set cmark 5'
'd tloop(aave(ac.2,lon=0,lon=360,lat=-20,lat=85))'
*
'set string 1 tc 6 90'
'set strsiz 0.15 0.15'
'draw string 'labx' 'laby' ACC'
'set string 2 tl 5 0'
'draw string 'sx1' 'sy1' Trop OLR'
'set string 1 tl 5 0'
'draw string 'sx1' 'sy2' TNH PSI200'
  iframe=iframe+1
*'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 0 4.25 1.75'
endwhile
'printim aveac.olr_psi.png gif x800 y600'
'print'
*
*'c'
'set vpage off'
