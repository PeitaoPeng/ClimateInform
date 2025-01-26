'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/adam/test_prd_psi200_sat_wkly.ctl'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.13 0.13'
'draw string 4.5 10.5 CA SAT Forecast with data throuch 5/5/2016'
'draw string 4.5 10.2 Unit: C'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.15 0.15'
*---------------------------set dimsnesion, page size and style
'define prd1=pw1'
'define prd2=pw2'
'define prd3=pw3'
'define prd4=pw4'
nframe=4
nframe2=4
xmin0=1.5;  xlen=6.;  xgap=1.0
ymax0=10.; ylen=-2.25; ygap=-0.05
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  bx=xmin+3.
  by=ymin-0.5
  tx=xmin-0.5
  ty=ymax-1.125
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set mproj scaled'
'set lon 0 360'
'set lat -20 87.5'
'set yaxis -20 87.5 20'
'set xlab off'
if(iframe = 4); 'set xlab on'; endif
'set grads off'
*'set grid off'
'set gxout shaded'
'set clevs -2.5 -2 -1.5 -1 -0.5 -0.2 0.2 0.5 1 1.5 2 2.5'
'set ccols  49 47 45 43 42 41 0 21 22 23 25 27 29'
'd prd'%iframe
 'set string 1 tc 5 90'
 'set strsiz 0.13 0.13'
 'draw string 'tx' 'ty' '
 if(iframe = 1); 'draw string 'tx' 'ty' WEEK1'; endif
 if(iframe = 2); 'draw string 'tx' 'ty' WEEK2'; endif
 if(iframe = 3); 'draw string 'tx' 'ty' WEEK3'; endif
 if(iframe = 4); 'draw string 'tx' 'ty' WEEK4'; endif
 iframe=iframe+1
 'set string 1 tc 5 0'
 'set strsiz 0.15 0.15'
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.9 0 'bx' 'by''
endwhile
'printim test.sat.png gif x600 800'
'print'
*
*'c'
'set vpage off'
