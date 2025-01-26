'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
'open /export-12/cacsrv1/wd52pp/prd_skill/reof.prcp_102_anom_1931-2010.jas.2x2.ctl'
*
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*
'define cor1=cor(t=1)'
'define cor2=cor(t=2)'
'define cor3=cor(t=3)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
 'draw string 4.25 10.5 REOFs of JAS PREC (1931-2010)'
 'set strsiz 0.12 0.12'
 'draw string 4.25 10.2 (correlation map)'
*---------------------------set dimsnesion, page size and style
nframe=3
nframe2=3
xmin0=1.0;  xlen=6.5;  xgap=0.5
ymax0=9.5; ylen=-2.5;  ygap=-0.65
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+3.25
  titly=ymax+0.2
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
'set grid off'
'set xlab off'
'set ylab off'
'set mpdset mres'
'set gxout shaded'
'set clevs  -0.9 -0.7 -0.5 -0.3 -0.1 0.1 0.3 0.5 0.7 0.9'
'set ccols 49 47 45 43 41 0 21 23 25 27 29'
'd cor'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly' REOF1 14.3%'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' REOF2 9.2%'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' REOF3 7.5%'; endif
*
  iframe=iframe+1
'run /export/hobbes/wd52pp/bin/cbarn2.gs 1. 1 7. 5.1'
endwhile
'print'
'printim reof.prcp_102.31-10.jas.1-3.png gif x600 y800'
'c'
'set vpage off'
'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
'open /export-12/cacsrv1/wd52pp/prd_skill/reof.prcp_102_anom_1931-2010.jas.2x2.ctl'
*
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*
'define cor1=cor(t=4)'
'define cor2=cor(t=5)'
'define cor3=cor(t=6)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
 'draw string 4.25 10.5 REOFs of JAS PREC (1931-2010)'
 'set strsiz 0.12 0.12'
 'draw string 4.25 10.2 (correlation map)'
*---------------------------set dimsnesion, page size and style
nframe=3
nframe2=3
xmin0=1.0;  xlen=6.5;  xgap=0.5
ymax0=9.5; ylen=-2.5;  ygap=-0.65
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+3.25
  titly=ymax+0.2
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
'set grid off'
'set xlab off'
'set ylab off'
'set mpdset mres'
'set gxout shaded'
'set clevs  -0.9 -0.7 -0.5 -0.3 -0.1 0.1 0.3 0.5 0.7 0.9'
'set ccols 49 47 45 43 41 0 21 23 25 27 29'
'd cor'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly' REOF4 7.4%'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' REOF5 7.2%'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' REOF6 7.2%'; endif
*
  iframe=iframe+1
'run /export/hobbes/wd52pp/bin/cbarn2.gs 1. 1 7. 5.1'
endwhile
'print'
'printim reof.prcp_102.31-10.jas.4-6.png gif x600 y800'
*'c'
'set vpage off'
