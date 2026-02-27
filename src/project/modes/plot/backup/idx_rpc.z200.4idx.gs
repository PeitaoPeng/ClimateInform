* reg to idx and rsd_rpc
'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/modes/idx_rcoef.z200.jfm.51-99.4idx_us.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*'enable print Fig_14'
*
*---------------------------string/caption
*
'define rpc1=tps'
'define rpc2=n34'
'define rpc3=amo'
'define rpc4=pdo'
'define rpc5=cf1'
'define rpc6=cf2'
'define rpc7=cf3'
'define rpc8=cf4'
'define rpc9=cf5'
'define rpc10=cf6'
'define rpc11=cf7'
'define rpc12=cf8'
'define rpc13=cf9'
'define rpc14=cf10'
'define rpc15=cf11'
'define rpc16=cf12'

'set string 1 tc 4'
'set strsiz 0.18 0.18'
'draw string 5.5 8.25 SST Indices and Residual RPCs of Z200 (51-99 JFM)'
*---------------------------set dimsnesion, page size and style
nframe=15
nframe2=5
nframe3=10
xmin0=0.75;  xlen=3.;  xgap=0.5
ymax0=7.75; ylen=-1.25;  ygap=-0.3
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  if (iframe > nframe3); icx=3; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  if (iframe > nframe3); icy=iframe-nframe3; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+0.05
  titly=ymax-0.05
  numbx=xmin+2.
  numby=ymax
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
'set grads off'
'set grid off'
*'set xlab off'
*'set ylab off'
'set gxout line'
'set xaxis 51 99 5'
'set yaxis -2.5 2.5 1'
if(iframe = 1); 'set yaxis -0.5 0.5 0.2'; endif
'run /export/hobbes/wd52pp/bin/dline.gs 0 0 135 0'
'set vrange -2.5 2.5'
if(iframe = 1); 'set vrange -0.5 0.5'; endif
'set ccolor 3'
'set cmark 0'
*'set csmooth on'
 'd rpc'%iframe
'set string 1 tl 4'
'set strsiz 0.12 0.12'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly' IPCC gl mean SST'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' detrended nino34'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' AMO'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly' PDO'; endif
 if(iframe = 5); 'draw string 'titlx' 'titly' rsd_rpc1'; endif
 if(iframe = 6); 'draw string 'titlx' 'titly' rsd_rpc2'; endif
 if(iframe = 7); 'draw string 'titlx' 'titly' rsd_rpc3'; endif
 if(iframe = 8); 'draw string 'titlx' 'titly' rsd_rpc4'; endif
 if(iframe = 9); 'draw string 'titlx' 'titly' rsd_rpc5'; endif
 if(iframe = 10); 'draw string 'titlx' 'titly' rsd_rpc6'; endif
 if(iframe = 11); 'draw string 'titlx' 'titly' rsd_rpc7'; endif
 if(iframe = 12); 'draw string 'titlx' 'titly' rsd_rpc8'; endif
 if(iframe = 13); 'draw string 'titlx' 'titly' rsd_rpc9'; endif
 if(iframe = 14); 'draw string 'titlx' 'titly' rsd_rpc10'; endif
 if(iframe = 15); 'draw string 'titlx' 'titly' rsd_rpc11'; endif
 if(iframe = 16); 'draw string 'titlx' 'titly' rsd_rpc12'; endif
'set strsiz 0.12 0.12'
*if(iframe = 1); 'draw string 'numbx' 'numby' 0.16'; endif
*if(iframe = 2); 'draw string 'numbx' 'numby' -0.03'; endif
*if(iframe = 3); 'draw string 'numbx' 'numby' 0.80'; endif
*if(iframe = 4); 'draw string 'numbx' 'numby' 0.57'; endif
*if(iframe = 5); 'draw string 'numbx' 'numby' 0.48'; endif
*if(iframe = 6); 'draw string 'numbx' 'numby' 0.59'; endif
*if(iframe = 7); 'draw string 'numbx' 'numby' 0.73'; endif
*if(iframe = 8); 'draw string 'numbx' 'numby' 0.64'; endif
*if(iframe = 9); 'draw string 'numbx' 'numby' 0.65'; endif
*if(iframe = 10); 'draw string 'numbx' 'numby' 0.81'; endif
*if(iframe = 11); 'draw string 'numbx' 'numby' 0.83'; endif
*
 'run /export/hobbes/wd52pp/bin/cbarn2.gs 1. 0 5.5 0.35'
  iframe=iframe+1
endwhile
*'print'
'printim idx_rpc.z200.4idx_us.png gif x800 y600'
*'c'
 'set vpage off'
*----------
