'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /cpc/home/wd52pp/data/attr/telcon/cor_rms_ts.z200_contrib_all.rsd_rpc.djf.raw.ctl'
'open /cpc/home/wd52pp/data/attr/telcon/cor_rms_ts.cmap_contrib_all.rsd_rpc.djf.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
*'enable print hdks_t2m.cpc.cons.gr'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
*'draw string 4.25 10.3 Corr to OBS Z200'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=1.25;  xlen=6.5;  xgap=0.75
ymax0=10.; ylen=-4;  ygap=-0.65
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+0.25
  titly=ymax+0.25
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
'set vrange 0. 1'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 1 42'
'set cmark 3'
'set cstyle 1'
'set cthick 1'
'set ccolor 1'
'd tloop(allc)'
'set cmark 3'
'set cstyle 1'
'set cthick 1'
'set ccolor 3'
*'d 0.65*tloop(allc.2)'
'd tloop(allc.2)'
 'set cstyle 1'
 'set cthick 6'
 'set cmark 0'
 'set ccolor 1'
 'define zero=0.'
 'd zero'
'draw ylab spatial cor'
*'draw xlab time(year)'
*---------
*if(iframe = 1);'draw string 'titlx' 'titly' a)'; endif
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'

endwhile
'set strsiz 0.13 0.13'
'set string 1 tl 4'
'draw string 5.5 6.6 Z200 mean=0.54'
'set string 3 tl 4'
'draw string 5.5 6.4 Prate mean=0.66'
'print'
*'printim cor.ts.all.png gif x1200 y1600'
'printim Fig12.png gif x1200 y1600'
*'c'
 'set vpage off'
*----------
