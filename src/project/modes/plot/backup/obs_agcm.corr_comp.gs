* reg to idx and rsd_reof
'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/bias_skill/rsd_eof.z200.jfm.51-99.3idx_sm.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*'enable print Fig_14'
*
*---------------------------string/caption
*
'set t 8'
'define regr1=cor'
'define regr2=eof1'
'define regr3=eof2'
'define regr4=eof3'
'define regr5=eof4'
'define regr6=eof5'
'define regr7=eof6'
'define regr8=eof7'
'define regr9=eof8'
'define regr10=eof9'
'define regr11=eof10'
'define regr12=eof11'

'set string 1 tc 4'
'set strsiz 0.18 0.18'
*'draw string 5.5 8. Z200 CORR to NINO34 SST (51-99 JFM)'
*'draw string 5.5 8. Z200 CORR to IPCC Global Mean SST (51-99 JFM)'
*'draw string 5.5 8. Z200 CORR to AMO (51-99 JFM)'
 'draw string 5.5 8. Z200 CORR to RPC5 (51-99 JFM)'
*---------------------------set dimsnesion, page size and style
nframe=12
nframe2=4
nframe3=8
xmin0=0.75;  xlen=3.;  xgap=0.25
ymax0=7.25; ylen=-1.5;  ygap=-0.0
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
  titlx=xmin+1.5
  titly=ymax-0.1
  numbx=xmin+2.
  numby=ymax
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set lat -20 80'
'set lon 0 360'
*'set frame off'
'set grads off'
'set grid off'
*'set map 15 1 2'
'set gxout shaded'
'set clevs -0.6 -0.5 -0.4 -0.3 -0.2 -0.1  0.1 0.2 0.3 0.4 0.5 0.6'
'set ccols   49 47 46 45 43 41 0 21 23 25 26 27 29'
'set xlab off'
'set ylab off'
*'set yaxis 80 80 10'
 'd regr'%iframe
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
*'run /export/hobbes/wd52pp/bin/dline.gs 180 -80 180 80'
'set gxout contour'
'set csmooth on'
*'set cint 0.5'
*'set ccolor 1'
* if(iframe = 6); 'set xlab on'; endif
* if(iframe = 12); 'set xlab on'; endif
*if(iframe > 8); 'set clevs -1 -0.8 -0.6 -0.4 -0.2 0.2 0.4 0.6 0.8 1'; endif
'set clopts -1 3 0.05'
'set cthick 4'
*'d reg'%iframe
 'set string 1 tc 4'
 'set strsiz 0.12 0.12'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly' OBS'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' CAM2'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' CCM3'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly' ECHAM3'; endif
 if(iframe = 5); 'draw string 'titlx' 'titly' ECHAM4.5'; endif
 if(iframe = 6); 'draw string 'titlx' 'titly' GFDL v1'; endif
 if(iframe = 7); 'draw string 'titlx' 'titly' GFDL v2'; endif
 if(iframe = 8); 'draw string 'titlx' 'titly' GFDL v3'; endif
 if(iframe = 9); 'draw string 'titlx' 'titly' NSIPP'; endif
 if(iframe = 10); 'draw string 'titlx' 'titly' SFM v1'; endif
 if(iframe = 11); 'draw string 'titlx' 'titly' SFM v2'; endif
 if(iframe = 12); 'draw string 'titlx' 'titly' SFM v3'; endif
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
 'run /export/hobbes/wd52pp/bin/cbarn2.gs 1. 0 5.5 0.75'
  iframe=iframe+1
endwhile
*'print'
 'printim obs_gcm.z200_rpc5.3idx_sm.png gif x800 y600'
*'printim obs_gcm.z200_glmsst.png gif x800 y600'
*'printim obs_gcm.z200_nino34.png gif x800 y600'
*'printim obs_gcm.z200_amo.3idx_sm.png gif x800 y600'
*'c'
 'set vpage off'
*----------
