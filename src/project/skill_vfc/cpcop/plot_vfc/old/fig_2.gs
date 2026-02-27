'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/hss_temp.95-cur.cpc.ctl'
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/hss_temp_t.95-cur.cpc.ctl'
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/hss_prec.95-cur.cpc.ctl'
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/hss_prec_t.95-cur.cpc.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print meta.fig2'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.12 0.12'
*'draw string 5.5 7.4 Non-EC Grid Number (%) of CPC Temp FCST'
*'draw string 8. 6.75 mean=50.6%'
*'draw string 5.5 7.4 Non-EC Grid Number (%) of CPC Temp FCST, ave=50.6%'
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
  strx=xmin+3.75
  stry=ymax-0.175
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
'set vrange 0 100'
'set gxout line'
'set t 1 181'
if(iframe = 1); 'set xaxis 1995 2010 2'; endif
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 1'
if(iframe = 1); 'd tloop(nec)'; endif
if(iframe = 1); 'set xlab off'; endif
if(iframe = 1); 'set ylab off'; endif
*
if(iframe = 2); 'set t 1'; endif
if(iframe = 2); 'set x 1 36'; endif
if(iframe = 2); 'set y 1 19'; endif
if(iframe = 2); 'set mpdset mres'; endif
if(iframe = 2); 'set gxout grfill'; endif
if(iframe = 2); 'set clevs 0 10 20 30 40 50 60 70 80'; endif
if(iframe = 2); 'set ccols 0 21 23 25 27 29 73 75 77 79'; endif
if(iframe = 2); 'd nec.2'; endif
*
if(iframe = 3); 'set xlab on'; endif
if(iframe = 3); 'set ylab on'; endif
'set vrange 0 100'
'set gxout line'
'set x 1'
'set y 1'
'set t 1 181'
if(iframe = 1); 'set xaxis 1995 2010 2'; endif
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 1'
if(iframe = 3); 'd tloop(nec.3)'; endif
if(iframe = 3); 'set xlab off'; endif
if(iframe = 3); 'set ylab off'; endif
*
if(iframe = 4); 'set t 1'; endif
if(iframe = 4); 'set x 1 36'; endif
if(iframe = 4); 'set y 1 19'; endif
if(iframe = 4); 'set mpdset mres'; endif
if(iframe = 4); 'set gxout grfill'; endif
if(iframe = 4); 'set clevs 0 10 20 30 40 50 60 70 80'; endif
if(iframe = 4); 'set ccols 0 21 23 25 27 29 73 75 77 79'; endif
if(iframe = 4); 'd nec.4'; endif
*
 'set string 1 tc 4'
 'set strsiz 0.12 0.12'
if(iframe = 1); 'draw string 'titlx' 'titly' Non-EC grid number(%) of CPC temp FCST'; endif
if(iframe = 1); 'draw string 'strx' 'stry' mean=50.6%'; endif
if(iframe = 2); 'draw string 'titlx' 'titly' Non-EC season number(%) of CPC temp FCST'; endif
if(iframe = 3); 'draw string 'titlx' 'titly' Non-EC grid number(%) of CPC prec FCST'; endif
if(iframe = 3); 'draw string 'strx' 'stry' mean=29.9%'; endif
if(iframe = 4); 'draw string 'titlx' 'titly' Non-EC season number(%) of CPC prec FCST'; endif
*
'set clopts -1 3 0.05'
'set string 1 tc 4'
'set strsiz 0.13 0.13'
*----------
  iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.75 0 5.5 0.65'
'print'
'printim Fig2.png gif x800 y600'
*'c'
 'set vpage off'
*----------
