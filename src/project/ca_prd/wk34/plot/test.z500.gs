'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/adam/test_prd_psi200_z500_wkly.ctl'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.13 0.13'
'draw string 4.5 10.5 CA H500 Forecast with data throuch 5/5/2016'
'draw string 4.5 10.2 Unit: m'
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
  bx=xmin+2.
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
'set gxout contour'
*'set clevs   -90 -80 -70 -55 55 70 80 90'
*'set ccols  48 46 44 42 0 22 24 26 28'
*'draw string 'titlx' 'titly' T2m (prob in %)'
'set cint 10'
'd prd'%iframe
 'set string 1 tc 5 90'
 'set strsiz 0.13 0.13'
 'draw string 'tx' 'ty' '
 if(iframe = 1); 'draw string 'tx' 'ty' WEEK1'; endif
 if(iframe = 2); 'draw string 'tx' 'ty' WEEK2'; endif
 if(iframe = 3); 'draw string 'tx' 'ty' WEEK3'; endif
 if(iframe = 4); 'draw string 'tx' 'ty' WEEK4'; endif
 iframe=iframe+1
*'run /cpc/home/wd52pp/bin/cbarn2.gs 0.5 0 'bx' 'by''
 'set string 1 tc 5'
 'set strsiz 0.15 0.15'
endwhile
'printim test.z500.png gif x600 800'
'print'
*
*'c'
'set vpage off'
