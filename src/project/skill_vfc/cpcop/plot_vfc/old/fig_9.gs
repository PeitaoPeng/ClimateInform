'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/hss_prec.95-cur.cpc.ctl'
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/hss_prec_t.95-cur.cpc.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print meta.fig9'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
* 'draw string 4.25 10.0 HSS of CPC seasonal prec forecast'
*---------------------------set dimsnesion, page size and style
nframe=3
nframe2=3
xmin0=1.5;  xlen=5.5;  xgap=0.5
ymax0=10.5; ylen=-2.75;  ygap=-0.5
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
  strx2=xmin+0.75
  stry2=ymax-0.4
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
if(iframe = 1)
'set vrange -50 100'
'set xaxis 1995 2010 2'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 6 176'
'define hs1sm=ave(hs1,t-5,t+5)'
'define hs2sm=ave(hs2,t-5,t+5)'
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 1'
'set t 1 181'
'd hs1sm'
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 2'
'set t 1 181'
'd hs2sm'
'set clopts -1 3 0.05'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
'define zero=0'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
'd zero'
'set strsiz 0.12 0.12'
'set string 1 tc 4'
'draw string 'titlx' 'titly' HSS in space'
'set strsiz 0.1 0.1'
'set string 1 tl 4'
'draw string 'strx2' 'stry2' HSS2 mean=2.5';
'set string 2 tl 4'
'draw string 'strx1' 'stry1' HSS1 mean=11.0';
endif
*
if(iframe != 1)
'set xlab off'
'set ylab off'
*
'set t 1'
'set x 1 36'
'set y 3 17'
'set mpdset mres'
'set gxout grfill'
'set clevs  0 10 20 30 40 50 60'
'set ccols 0 21 23 25 27 73 76 79'
if(iframe = 2); 'd hs2.2'; endif
if(iframe = 3); 'd hs1.2'; endif
*
'set strsiz 0.12 0.12'
'set string 1 tc 4'
if(iframe = 2); 'draw string 'titlx' 'titly' HSS1 in time'; endif
if(iframe = 3); 'draw string 'titlx' 'titly' HSS2 in time'; endif
*
endif
*----------
  iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.8 0 4.25 0.75'
'print'
'printim Fig9.png gif 600 y800'
*'c'
 'set vpage off'
*----------
