'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/wk34/ac_2d_ca_psi200_prcp_wkly.winter.1ics.mm35.detrd.ctl'
'open /cpc/home/wd52pp/data/wk34/ac_2d_ca_psi200_prcp_wkly.winter.2ics.mm35.detrd.ctl'
'open /cpc/home/wd52pp/data/wk34/ac_2d_ca_psi200_prcp_wkly.winter.3ics.mm35.detrd.ctl'
'open /cpc/home/wd52pp/data/wk34/ac_2d_ca_psi200_prcp_wkly.winter.4ics.mm35.detrd.ctl'
*
'define sk1=ac(t=6)'
'define sk2=ac.2(t=6)'
'define sk3=ac.3(t=6)'
'define sk4=ac.4(t=6)'
*---------------------------string/caption
'set string 1 tc 4'
'set strsiz 0.15 0.15'
'draw string 5.5 8.25 AC Skill of CA WK34 PRCP Forecast'
'draw string 5.5 7.95 DJF of 1979-2015, 35 EOFs in PSI200'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.14 0.14'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=2
xmin0=1.10;  xlen=4.0;  xgap=0.8
ymax0=7.5; ylen=-3.0;  ygap=-0.5
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
* 'set clevs    0 0.05 0.1 0.15 0.2 0.25 0.3'
* 'set ccols    0 21 23 25 27 63 66 69'
'set clevs    0.1 0.15 0.2 0.25 0.3 0.35 0.4'
'set ccols    0 42 44 46 22 24 26 28'
*'set yaxis -30 30 10'
'd 0.025+sk'%iframe
*
if (iframe = 1); 'draw string 'titlx' 'titly' IC-WEEK#=1'; endif
if (iframe = 2); 'draw string 'titlx' 'titly' IC-WEEK#=2'; endif
if (iframe = 3); 'draw string 'titlx' 'titly' IC-WEEK#=3'; endif
if (iframe = 4); 'draw string 'titlx' 'titly' IC-WEEK#=4'; endif
  iframe=iframe+1
'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 0 5.5 0.325'
endwhile
'printim ac2d.wk34.psi200_prcp.mwic.png gif x1600 y1200'
'print'
*
*'c'
'set vpage off'
