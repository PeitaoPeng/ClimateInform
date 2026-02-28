'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/hss_temp.95-cur.cpc.ctl'
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/hss_temp_t.95-cur.cpc.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print meta.fig4'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.12 0.12'
*'draw string 5.5 7.4 HSS of CPC seasonal temp forecast'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=2
xmin0=0.5;  xlen=4.75;  xgap=0.5
ymax0=7.8; ylen=-3.;  ygap=-0.75
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+2.375
  titly=ymax+0.2
  strx1=xmin+3.75
  stry1=ymax-0.125
  strx2=xmin+3.75
  stry2=ymax-0.325
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set frame off'
'set grads off'
'set grid off'
*'set xlab off'
*'set ylab off'
*
if(iframe = 3); 
'set t 6 176'; 
'define hs1sm=ave(hs1,t-5,t+5)';
'define hs2sm=ave(hs2,t-5,t+5)';
endif
*
if(iframe = 3); 'set xlab on'; endif
if(iframe = 3); 'set ylab on'; endif
if(iframe = 1); 'set x 1'; endif
if(iframe = 3); 'set x 1'; endif
if(iframe = 1); 'set y 1'; endif
if(iframe = 3); 'set y 1'; endif
if(iframe = 1); 'set vrange -50 100'; endif
if(iframe = 3); 'set vrange -50 100'; endif
if(iframe = 1); 'set t 1 181'; endif
if(iframe = 3); 'set t 1 181'; endif
if(iframe = 1); 'set xaxis 1995 2010 2'; endif
if(iframe = 3); 'set xaxis 1995 2010 2'; endif
'set gxout line'
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 1'
if(iframe = 1); 'd tloop(hs1))'; endif
if(iframe = 3); 'd hs1sm'; endif
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 2'
if(iframe = 1); 'd tloop(hs2))'; endif
if(iframe = 3); 'd hs2sm'; endif
'set clopts -1 3 0.05'
'set string 1 tc 4'
'set strsiz 0.13 0.13'
'define zero=0.'
'define zero=0.'
 'set cstyle 1'
 'set cthick 6'
 'set cmark 0'
 'set ccolor 1'
if(iframe = 1); 'd zero'; endif
if(iframe = 3); 'd zero'; endif
*
if(iframe = 2); 'set xlab off'; endif
if(iframe = 2); 'set ylab off'; endif
if(iframe = 4); 'set xlab off'; endif
if(iframe = 4); 'set ylab off'; endif
if(iframe = 2); 'set t 1'; endif
if(iframe = 4); 'set t 1'; endif
if(iframe = 2); 'set x 1 36'; endif
if(iframe = 4); 'set x 1 36'; endif
if(iframe = 2); 'set y 1 19'; endif
if(iframe = 4); 'set y 1 19'; endif
if(iframe = 2); 'set mpdset mres'; endif
if(iframe = 4); 'set mpdset mres'; endif
if(iframe = 2); 'set gxout grfill'; endif
if(iframe = 4); 'set gxout grfill'; endif
if(iframe = 2); 'set clevs 0 10 20 30 40 50 60'; endif
if(iframe = 4); 'set clevs 0 10 20 30 40 50 60'; endif
if(iframe = 2); 'set ccols 0 21 23 25 27 73 76 79'; endif
if(iframe = 4); 'set ccols 0 21 23 25 27 73 76 79'; endif
if(iframe = 2); 'd hs2.2'; endif
if(iframe = 4); 'd hs1.2'; endif
*
'set strsiz 0.12 0.12'
'set string 1 tc 4'
if(iframe = 1); 'draw string 'titlx' 'titly' time series of HSS'; endif
if(iframe = 3); 'draw string 'titlx' 'titly' smoothed HSS time series'; endif
if(iframe = 2); 'draw string 'titlx' 'titly' HSS1 in time'; endif
if(iframe = 4); 'draw string 'titlx' 'titly' HSS2 in time'; endif
'set strsiz 0.1 0.1'
'set string 1 tc 4'
if(iframe = 1); 'draw string 'strx2' 'stry2' HSS2 mean=11.3'; endif
if(iframe = 3); 'draw string 'strx2' 'stry2' HSS2 mean=11.3'; endif
'set string 2 tc 4'
if(iframe = 1); 'draw string 'strx1' 'stry1' HSS1 mean=22.6'; endif
if(iframe = 3); 'draw string 'strx1' 'stry1' HSS1 mean=22.6'; endif
*
'set clopts -1 3 0.05'
'set string 1 tc 4'
'set strsiz 0.13 0.13'
*----------
  iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.75 0 5.5 0.65'
'print'
'printim Fig4.png gif x800 y600'
*'c'
 'set vpage off'
*----------
