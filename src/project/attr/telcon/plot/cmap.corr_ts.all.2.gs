'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /cpc/home/wd52pp/data/attr/telcon/cor_rms_ts.cmap_contrib_all.rsd_rpc.djf.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
*'enable print hdks_t2m.cpc.cons.gr'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
*'draw string 4.25 10.3 Corr to OBS Prate'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
xmin0=1.;  xlen=6.5;  xgap=0.75
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
if (iframe = 1)
'set t 1'
*'set frame off'
'set grads off'
*'set grid off'
*'set xlab off'
*'set ylab off'
'set vrange -0.55 1'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 1 42'
'set cmark 3'
'set cstyle 1'
'set cthick 5'
'set ccolor 1'
'd tloop(c1))'
'set cmark 3'
'set cstyle 1'
'set cthick 5'
'set ccolor 2'
'd tloop(c2)'
'set cmark 3'
'set cstyle 1'
'set cthick 5'
'set ccolor 3'
'd tloop(c3)'
'set cmark 3'
'set cstyle 1'
'set cthick 5'
'set ccolor 4'
'd tloop(c4)'
 'define zero=0.'
 'set cstyle 1'
 'set cthick 5'
 'set cmark 0'
 'set ccolor 1'
 'd zero'
endif
if (iframe = 2)
'set t 1'
*'set frame off'
'set grads off'
*'set grid off'
*'set xlab off'
*'set ylab off'
'set vrange -0.35 1'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 1 42'
'set cmark 3'
'set cstyle 1'
'set cthick 5'
'set ccolor 1'
'd tloop(c14))'
'set cmark 3'
'set cstyle 1'
'set cthick 5'
'set ccolor 2'
'd tloop(nc)'
 'define zero=0.'
 'set cstyle 1'
 'set cthick 5'
 'set cmark 0'
 'set ccolor 1'
 'd zero'
endif
*----------
if(iframe = 1);'draw string 'titlx' 'titly' a)'; endif
if(iframe = 2);'draw string 'titlx' 'titly' b)'; endif
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'

endwhile
'set strsiz 0.13 0.13'
'set string 1 tl 4'
'draw string 1.5 9.8 RPC1 mean=0.13'
'set string 2 tl 4'
'draw string 1.5 9.6 RPC2 mean=0.14'
'set string 3 tl 4'
'draw string 3.5 9.8 RPC3 mean=0.15'
'set string 4 tl 4'
'draw string 3.5 9.6 RPC4 mean=0.14'
'set string 1 tl 4'
'draw string 1.5 5.2 RPC1-4 mean=0.31'
'set string 2 tl 4'
'draw string 1.5 5.0 Nino3.4 mean=0.30'
'print'
'printim cmap.cor.ts.all.2.png gif x1200 y1600'
*'c'
 'set vpage off'
*----------
