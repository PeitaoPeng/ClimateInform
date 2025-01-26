'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/wk34/ac_2d_ca_psi200_wkly.winter.mm35.ctl'
*
*---------------------------string/caption
'set string 1 tc 4'
'set strsiz 0.13 0.13'
'draw string 5.5 6.5 AC Skill of CA WK34 PSI200 Forecast, DJFM 1979/80-2012/13, EOF-modes=35'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.15 0.15'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=1.0;  xlen=9.;  xgap=0.6
ymax0=7.6; ylen=-6.0;  ygap=-0.5
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
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set mproj scaled'
'set lon 0 360'
'set lat -20.0 87.5'
*'set xlab off'
'set grads off'
*'set grid off'
'set gxout shaded'
*'set clevs   0. 0.10 0.2 0.3 0.4 0.5 0.6'
*'set ccols   0 21 23 25 27 29 63 66 69'
'set clevs   0.10 0.2 0.3 0.4 0.5 0.6 0.7'
'set ccols   0 42 44 46 22 24 26 28'
*'set yaxis -30 30 10'
'd ac(t=6)'
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -20 180 87.5'
*
  iframe=iframe+1
'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 0 5.5 2.5'
endwhile
'printim ac_2d.wk34.psi200.png gif x800 y600'
'print'
*
*'c'
'set vpage off'
