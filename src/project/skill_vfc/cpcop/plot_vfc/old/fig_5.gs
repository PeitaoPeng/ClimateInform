'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/rpss_temp.95-cur.cpc.ctl'
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/rpss_temp_t.95-cur.cpc.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
'enable print meta.fig5'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
 'draw string 4.25 10.0 RPSS of CPC seasonal temp forecast'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
xmin0=1.5;  xlen=5.5;  xgap=0.5
ymax0=9.25; ylen=-2.75;  ygap=-0.75
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+2.75
  titly=ymax+0.175
  strx1=xmin+0.75
  stry1=ymax-0.2
  strx2=xmin+4.5
  stry2=ymax-0.31
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
*'set frame off'
'set grads off'
*'set grid off'
*'set xlab off'
*'set ylab off'
*
'set vrange -0.5 0.5'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 6 176'
'define rpssm=ave(rpss,t-5,t+5)'
'set t 1 181'
'set xaxis 1995 2010 2'
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 1'
if(iframe = 1); 'd tloop(rpss))'; endif
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 2'
if(iframe = 1); 'd rpssm'; endif
'set clopts -1 3 0.05'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
'define zero=0.'
 'set cstyle 1'
 'set cthick 6'
 'set cmark 0'
 'set ccolor 1'
if(iframe = 1); 'd zero'; endif
*
if(iframe = 2); 'set xlab off'; endif
if(iframe = 2); 'set ylab off'; endif
*
if(iframe = 2); 'set t 1'; endif
if(iframe = 2); 'set x 1 36'; endif
if(iframe = 2); 'set y 3 17'; endif
if(iframe = 2); 'set mpdset mres'; endif
if(iframe = 2); 'set gxout grfill'; endif
if(iframe = 2); 'set clevs  0 0.03 0.06 0.09 0.12 0.15 0.18 0.21 0.24'; endif
if(iframe = 2); 'set ccols 0 21 22 23 24 25 26 27 28 29'; endif
if(iframe = 2); 'd rpss.2'; endif
*
'set strsiz 0.12 0.12'
if(iframe = 1); 'set string 1 tc 4'; endif
if(iframe = 1); 'draw string 'titlx' 'titly' RPSS in space'; endif
if(iframe = 2); 'draw string 'titlx' 'titly' RPSS in time'; endif
'set strsiz 0.1 0.1'
'set string 1 tc 4'
if(iframe = 1); 'draw string 'strx1' 'stry1' mean=0.03'; endif
*
*----------
  iframe=iframe+1
endwhile
'run /export/hobbes/wd52pp/bin/cbarn2.gs 0.8 0 4.25 2.6'
'print'
'printim Fig5.png gif 600 y800'
*'c'
 'set vpage off'
*----------
