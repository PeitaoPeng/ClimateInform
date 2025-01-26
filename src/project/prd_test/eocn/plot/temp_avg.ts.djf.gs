'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /cpc/home/wd52pp/data/prd_test/temp_usavg_1931-2012.djf.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
*'enable print hdks_t2m.cpc.gr'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 5.5 7.3 CONUS AVG Temp (DJF 1931-2012)'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=1.5;  xlen=8.;  xgap=0.75
ymax0=7.0; ylen=-5;  ygap=-0.65
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+2.15
  titly=ymax+0.2
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
'set vrange -3. 3.'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 5 78'
'define tm=ave(t,t-4,t+4)'
'set t 1 82'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
'define zero=0.'
'd zero'
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 1'
'd t'
'set cmark 0'
'set cstyle 1'
'set cthick 8'
'set ccolor 3'
'd tm'
'set clopts -1 3 0.05'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
endwhile
'set strsiz 0.15 0.15'
'set string 1 tl 4'
*'draw string 1.6 6.9 EOCN mean=18.0'
'set string 2 tl 4'
*'draw string 1.6 6.7 OCN(opt K) mean=16.0'
'set string 3 tl 4'
'draw string 1.6 6.5 9-year running mean'
'print'
'printim temp_avg.ts.djf.png gif x800 y600'
*'c'
 'set vpage off'
