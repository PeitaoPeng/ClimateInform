'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/hss_temp_t.95-cur.cpc.ctl'
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/hss_cyc_temp.95-cur.cpc.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print meta.fig8'
*
*---------------------------string/caption
'define hds1=hs2w'
'define hds2=hs2s'
'define hds3=hs1w'
'define hds4=hs1s'
*
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=2.0;  xlen=4.5;  xgap=0.5
ymax0=10.1; ylen=-2.0;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+1.75
  titly=ymax+0.05
  strx1=xmin+2.25
  stry1=ymax+0.2
  strx2=xmin+0.5
  stry2=ymax-0.35
  strx3=xmin+0.5
  stry3=ymax-0.55
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
'set x 1'
'set y 1'
'set grads off'
'set xlabs JFM | FMA | MAM | AMJ | MJJ | JJA | JAS | ASO | SON | OND | NDJ | DJF '
'set vrange -50 100'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 1 12'
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 1'
'd tloop(hs1.2)'
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 2'
'd tloop(hs2.2)'
'set clopts -1 3 0.05'
'define zero=0'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
'd zero';
 'set string 1 tc 4'
 'set strsiz 0.12 0.12'
'draw string 'strx1' 'stry1' annual cycle of HSS of temp forecast'
 'set strsiz 0.12 0.12'
 'set string 2 tl 4'
'draw string 'strx2' 'stry2' HSS1'
 'set string 1 tl 4'
'draw string 'strx3' 'stry3' HSS2'
*
  iframe=iframe+1
endwhile
*
nframe=4
nframe2=2
xmin0=0.5;  xlen=3.5;  xgap=0.5
ymax0=7.5; ylen=-2.00;  ygap=-0.3
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+1.75
  titly=ymax+0.05
  strx1=xmin+1.75
  stry1=ymax+0.2
  strx2=xmin+0.5
  stry2=ymax-0.35
  strx3=xmin+0.5
  stry3=ymax-0.55
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
'set xlab off'
'set ylab off'
'set x 1 36'
'set y 3 17'
'set grads off'
'set grid off'
'set gxout grfill'
'set mpdset mres'
'set clevs   0 10 20 30 40 50 60'
*'set ccols   0 21 23 24 25 26 27 29'
'set ccols   0 21 23 25 27 73 76 79'
ifr=iframe
'd hds'%ifr
 'set string 1 tc 4'
 'set strsiz 0.12 0.12'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly' HSS1 in time for winter'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' HSS1 in time for summer'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' HSS2 in time for winter'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly' HSS2 in time for summer'; endif
 iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 1.0 0 4.25 2.75'
'print'
'printim Fig8.png gif x600 y800'
*'c'
* 'set vpage off'
*----------
