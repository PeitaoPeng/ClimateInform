'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /cpc/home/wd52pp/data/CFSv2_vfc/skill/lagged_hss.prec.95-cur.cfsv2.ctl'
'open /cpc/home/wd52pp/data/cpc_vfc/skill/lagged_hss.prec.95-cur.cpc.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*'enable print hdks_prec.cfs.gr'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 4.25 10.5 Lagged HSS of Seasonal Prec'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
xmin0=1.;  xlen=6.5;  xgap=0.75
ymax0=9.5; ylen=-3.5;  ygap=-1.25
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+3.25
  titly=ymax+0.25
  lx1=xmin+2.5
  lx2=lx1+0.75
  lxx=lx2+0.35
  ly1=ymax-0.5
  lyy1=ymax-0.4
  ly2=ymax-0.8
  lyy2=ymax-0.7
  ly3=ymax-1.1
  lyy3=ymax-1.0
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
 'set parea 'xmin' 'xmax' 'ymin' 'ymax''
*
 'set strsiz 0.16 0.16'
if(iframe = 1); 'draw string 'titlx' 'titly' HSS of FCST (verified against OBS)'; endif
if(iframe = 2); 'draw string 'titlx' 'titly' AUTO HSS (verified against itself)'; endif
*'set frame off'
'set grads off'
*'set grid off'
*'set xlab off'
*'set ylab off'
'set gxout line'
'set t 1 7'
'set xaxis 0 6 1'
if(iframe = 1);'set vrange 0 20'; endif
if(iframe = 2);'set vrange 0 100'; endif
'set cmark 3'
'set cstyle 1'
'set cthick 7'
'set ccolor 1'
if(iframe = 1); 'd hs21'; endif
if(iframe = 2); 'd hs41'; endif
'draw xlab lag(months)'
'set cmark 3'
'set cstyle 1'
'set cthick 7'
'set ccolor 2'
if(iframe = 1); 'd hs21.2'; endif
if(iframe = 2); 'd hs41.2'; endif
'set cmark 3'
'set cstyle 1'
'set cthick 7'
'set ccolor 3'
if(iframe = 2); 'd hs31'; endif
'set clopts -1 3 0.05'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
'set line 1 1 8'
'draw line 'lx1' 'ly1' 'lx2' 'ly1''
'draw string 'lxx' 'lyy1' CFSv2'
'set line 2 1 8'
'draw line 'lx1' 'ly2' 'lx2' 'ly2''
'draw string 'lxx' 'lyy2' CPC'
if(iframe = 2); then
'set line 3 1 8'
'draw line 'lx1' 'ly3' 'lx2' 'ly3''
'draw string 'lxx' 'lyy3' OBS'
endif
  iframe=iframe+1
endwhile
*'c'
*'print'
'printim lagged_hss.prec.png gif x600 y800'
*'c'
 'set vpage off'
*----------
