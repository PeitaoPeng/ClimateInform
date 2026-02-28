'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/wk34/ac_2d_ca_psi200_sat_wkly.winter.1ics.mm35.detrd.ctl'
'open /cpc/home/wd52pp/data/wk34/ac_2d_ca_psi200_sat_wkly.winter.2ics.mm35.detrd.ctl'
'open /cpc/home/wd52pp/data/wk34/ac_2d_ca_psi200_sat_wkly.winter.3ics.mm35.detrd.ctl'
'open /cpc/home/wd52pp/data/wk34/ac_2d_ca_psi200_sat_wkly.winter.4ics.mm35.detrd.ctl'
*
'define sk1=ac.2(t=6)-ac(t=6)'
'define sk2=ac.3(t=6)-ac(t=6)'
'define sk3=ac.4(t=6)-ac(t=6)'
*---------------------------string/caption
'set string 1 tc 4'
'set strsiz 0.15 0.15'
'draw string 5.5 8.25 AC Skill of CA WK34 SAT Forecast'
'draw string 5.5 7.95 Diff from IC-WEEK=1'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.14 0.14'
*---------------------------set dimsnesion, page size and style
nframe=3
nframe2=2
xmin0=1.10;  xlen=4.0;  xgap=0.8
ymax0=7.5; ylen=-3.0;  ygap=-0.75
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+0.75
  titly=ymax-1.75
  bx=xmin+2
  by=ymin-0.3
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set mproj scaled'
'set lon 190 305'
'set lat 10 75'
* 'set lon 0 360'
* 'set lat -90 90'
'set xlab off'
'set ylab off'
'set grads off'
*'set grid off'
'set gxout shaded'
'set clevs    -0.15 -0.12 -0.09 -0.06 -0.03 0 0.03 0.06 0.09 0.12 0.15'
'set ccols    49 47 45 43 42 41 21 22 23 24 25 27 29'
*'set yaxis -30 30 10'
'd sk'%iframe
*
if (iframe = 1); 'draw string 'titlx' 'titly' IC-WEEK#=2'; endif
if (iframe = 2); 'draw string 'titlx' 'titly' IC-WEEK#=3'; endif
if (iframe = 3); 'draw string 'titlx' 'titly' IC-WEEK#=4'; endif
*
'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 0 5.5 0.325'
  iframe=iframe+1
endwhile
'printim ac2d.wk34.psi200_sat.mwic.2.png gif x1600 y1200'
'print'
*'c'
'set vpage off'
