'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
'open /export-12/cacsrv1/wd52pp/prd_skill/corr.usp_rpc.vs.sst.31-10jfm.ctl'
*
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*
'define cor1=cor(t=1)'
'define cor2=cor(t=2)'
'define cor3=cor(t=3)'
'define cor4=cor(t=4)'
'define cor5=cor(t=5)'
'define cor6=cor(t=6)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
 'draw string 5.5 8.125 CORR (CONUS JFM Prec RPCs vs SST) over 1931-2010'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
nframe=6
nframe2=3
xmin0=0.5;  xlen=5;  xgap=0.25
ymax0=7.5; ylen=-2.;  ygap=-0.25
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+2.5
  titly=ymax+0.15
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
'set grid off'
'set xlab off'
'set ylab off'
'set lat -60 60'
if(iframe < 4); 'set ylab on'; endif
if(iframe = 3); 'set xlab on'; endif
if(iframe = 6); 'set xlab on'; endif
'set mpdset mres'
'set gxout shaded'
'set clevs  -0.8 -0.6 -0.4 -0.2  0.2 0.4 0.6 0.8'
'set ccols 49 47 45 43 0 23 25 27 29'
'd cor'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly' RPC1'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' RPC2'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' RPC3'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly' RPC4'; endif
 if(iframe = 5); 'draw string 'titlx' 'titly' RPC5'; endif
 if(iframe = 6); 'draw string 'titlx' 'titly' RPC6'; endif
*
*
  iframe=iframe+1
'run /export/hobbes/wd52pp/bin/cbarn2.gs 1. 0 5.5 0.4'
endwhile
'print'
'printim corr.usp_rpc_sst.jfm.png gif x800 y600'
*'c'
'set vpage off'
