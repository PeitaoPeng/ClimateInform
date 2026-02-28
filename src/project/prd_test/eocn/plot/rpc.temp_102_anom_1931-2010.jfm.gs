'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/prd_skill/rpc.temp_102_anom_1931-2010.jfm.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.17 0.17'
 'draw string 4.25 10.0 RPCs of US T`bsfc`n (JFM 1931-2010)'
*---------------------------set dimsnesion, page size and style
nframe=3
nframe2=3
xmin0=1.0;  xlen=6.5;  xgap=0.5
ymax0=9.5; ylen=-2.5;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+0.7
  titly=ymax-0.15
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set xaxis 1931 2010 5'
'set t 1 80'
*'set xlab off'
*if(iframe = 3); 'set xlab on'; endif
'set grads off'
 if(iframe = 1); 'set yaxis -3 3 1'; endif
 if(iframe = 2); 'set yaxis -3 3 1'; endif
 if(iframe = 3); 'set yaxis -3 3 1'; endif
'set yaxis -2.5 2.5 1'
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 1'
if(iframe = 1); 'd pc1'; endif
if(iframe = 2); 'd pc2'; endif
if(iframe = 3); 'd pc3'; endif
'set t 4 77'
'define pc1m=ave(pc1,t-3,t+3)'
'define pc2m=ave(pc2,t-3,t+3)'
'define pc3m=ave(pc3,t-3,t+3)'
'set t 1 80'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 3'
if(iframe = 1); 'd pc1m'; endif
if(iframe = 2); 'd pc2m'; endif
if(iframe = 3); 'd pc3m'; endif
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
'define zero=0.0'
'd zero'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly'  RPC1'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly'  RPC2'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly'  RPC3'; endif
*
  iframe=iframe+1
endwhile
'print'
'printim rpc.temp_102.31-10.jfm.1-3.png gif x600 y800'
*'c'
'set vpage off'
*----------
'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/prd_skill/rpc.temp_102_anom_1931-2010.jfm.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.17 0.17'
 'draw string 4.25 10.0 RPCs of US T`bsfc`n (JFM 1931-2010)'
*---------------------------set dimsnesion, page size and style
nframe=3
nframe2=3
xmin0=1.0;  xlen=6.5;  xgap=0.5
ymax0=9.5; ylen=-2.5;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+0.7
  titly=ymax-0.15
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set xaxis 1931 2010 5'
'set t 1 80'
*'set xlab off'
*if(iframe = 3); 'set xlab on'; endif
'set grads off'
 if(iframe = 1); 'set yaxis -3 3 1'; endif
 if(iframe = 2); 'set yaxis -3 3 1'; endif
 if(iframe = 3); 'set yaxis -3 3 1'; endif
'set yaxis -2.5 2.5 1'
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 1'
if(iframe = 1); 'd pc4'; endif
if(iframe = 2); 'd pc5'; endif
if(iframe = 3); 'd pc6'; endif
'set t 4 77'
'define pc1m=ave(pc4,t-3,t+3)'
'define pc2m=ave(pc5,t-3,t+3)'
'define pc3m=ave(pc6,t-3,t+3)'
'set t 1 80'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 3'
if(iframe = 1); 'd pc1m'; endif
if(iframe = 2); 'd pc2m'; endif
if(iframe = 3); 'd pc3m'; endif
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
'define zero=0.0'
'd zero'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly'  RPC4'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly'  RPC5'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly'  RPC6'; endif
*
  iframe=iframe+1
endwhile
'print'
'printim rpc.temp_102.31-10.jfm.4-6.png gif x600 y800'
*'c'
'set vpage off'
*----------
