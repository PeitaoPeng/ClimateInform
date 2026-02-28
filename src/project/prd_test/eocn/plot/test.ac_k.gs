'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /cpc/home/wd52pp/data/prd_skill/ac_k.ocn.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print test.ac_k.ocn.mega'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 5.5 7.3 Skill-K relationship in OCN forecast'
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
*'set frame off'
'set grads off'
*'set grid off'
*'set xlab off'
*'set ylab off'
'set xaxis 0.01 0.5 0.05'
'set vrange 0 1'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 1 50'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
'd t4'
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 2'
'd t6'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 3'
'd t11'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 4'
'd t12'
'set clopts -1 3 0.05'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
'draw xlab K(fraction of period T)'
'draw ylab ACC'
'set line 1 6 4'
'draw line 3.8 2.25 2. 6.25'
*----------
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
endwhile
'set strsiz 0.15 0.15'
'set string 1 tl 4'
'draw string 7. 5.9 SNR=0.3'
'set string 2 tl 4'
'draw string 7. 5.6 SNR=0.5'
'set string 3 tl 4'
'draw string 7. 5.3 SNR=1.0'
'set string 4 tl 4'
'draw string 7. 5.0 SNR=2.0'
'print'
'printim test.ac_k.ocn.png gif x800 y600'
*'c'
 'set vpage off'
