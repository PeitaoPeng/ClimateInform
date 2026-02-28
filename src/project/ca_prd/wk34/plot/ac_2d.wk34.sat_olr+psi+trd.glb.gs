'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/wk34/ac_2d_ca_psi200_olr_trd.nmme_sat_wkly.winter.ctl'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
'draw string 5.5 8 AC Skill of CA WK34 SAT Forecast'
'draw string 5.5 7.75 DJFM 1979/80-2012/13, based on OLR,PSI200&Trend'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.15 0.15'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=1.0;  xlen=9.0;  xgap=0.6
ymax0=7.5; ylen=-6.0;  ygap=-0.5
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
'set mproj scaled'
*'set lon 190 305'
*'set lat 10 90'
 'set lon 0 360'
 'set lat -90 90'
*'set xlab off'
'set grads off'
*'set grid off'
'set gxout shaded'
* 'set clevs    0 0.05 0.1 0.15 0.2 0.25 0.3'
* 'set ccols     0 21 23 25 27 63 66 69'
'set clevs    0.1 0.2 0.3 0.4 0.5 0.6 0.7'
'set ccols    0 42 44 46 22 24 26 28'
*'set yaxis -30 30 10'
'd ac(t=6)'
*
  iframe=iframe+1
'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 0 5.5 1'
endwhile
'printim ac_2d.wk34.olr+psi+trd_sat.glb.png gif x800 y600'
'print'
*
*'c'
'set vpage off'
