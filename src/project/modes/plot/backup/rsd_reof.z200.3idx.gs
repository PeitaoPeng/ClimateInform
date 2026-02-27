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
'define regr1=reg(t=2)'
'define regr2=reg(t=1)'
'define regr3=reg(t=3)'
'define regr4=reg(t=4)'
'define regr5=reg(t=5)'
'define regr6=reg(t=6)'
'define regr7=reg(t=7)'
'define regr8=reg(t=8)'
'define regr9=reg(t=9)'
'define regr10=reg(t=10)'
'define regr11=reg(t=11)'
'define regr12=reg(t=12)'
'define regr13=reg(t=13)'
'define regr14=reg(t=14)'
'define regr15=reg(t=15)'

'set string 1 tc 4'
'set strsiz 0.18 0.18'
'draw string 5.5 8.25 Decomposition of Z200 (51-99 JFM)'
*---------------------------set dimsnesion, page size and style
nframe=15
nframe2=5
nframe3=10
xmin0=0.75;  xlen=3.;  xgap=0.25
ymax0=7.75; ylen=-1.4;  ygap=-0.0
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
  titly=ymax
  numbx=xmin+2.
  numby=ymax
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
'set lat -20 80'
'set lon 0 360'
*'set frame off'
'set grads off'
'set grid off'
*'set map 15 1 2'
'set gxout shaded'
'set clevs  -50 -40 -30 -20 -10 0 10 20 30 40 50'
'set ccols   49 47 46 45 43 41 21 23 25 26 27 29'
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
 if(iframe = 1); 'draw string 'titlx' 'titly' regr to IPCC gl mean SST'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' regr to nino34'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' regr to AMO'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly' rsd_reof1'; endif
 if(iframe = 5); 'draw string 'titlx' 'titly' rsd_reof2'; endif
 if(iframe = 6); 'draw string 'titlx' 'titly' rsd_reof3'; endif
 if(iframe = 7); 'draw string 'titlx' 'titly' rsd_reof4'; endif
 if(iframe = 8); 'draw string 'titlx' 'titly' rsd_reof5'; endif
 if(iframe = 9); 'draw string 'titlx' 'titly' rsd_reof6'; endif
 if(iframe = 10); 'draw string 'titlx' 'titly' rsd_reof7'; endif
 if(iframe = 11); 'draw string 'titlx' 'titly' rsd_reof8'; endif
 if(iframe = 12); 'draw string 'titlx' 'titly' rsd_reof9'; endif
 if(iframe = 13); 'draw string 'titlx' 'titly' rsd_reof10'; endif
 if(iframe = 14); 'draw string 'titlx' 'titly' rsd_reof11'; endif
 if(iframe = 15); 'draw string 'titlx' 'titly' rsd_reof12'; endif
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
'printim rsd_reof.z200.3idx_sm.png gif x800 y600'
*'c'
 'set vpage off'
*----------
