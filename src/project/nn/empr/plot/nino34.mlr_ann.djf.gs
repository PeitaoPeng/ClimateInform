'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
icmon=may
nt=38
* ctls are from /cpc/home/wd52pp/project/nn/opr/ANN.hybrid.sst_2_nino34.3V.eof.sh, MLR.hybrid.sst_2_nino34.3V.eof.sh
'open /cpc/consistency/tmp_ann/mlr.ld07.ctl'
'open /cpc/consistency/tmp_ann/mlp.ld07.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print Fig2.meta'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 5.5 7.3 NINO3.4 Index: DJF 1983-2020'
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
  xstr=xmin-0.5
  ystr=ymin+2.5
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set x 1'
*'set frame off'
'set grads off'
*'set grid off'
*'set xlab off'
*'set ylab off'
'set vrange -3 4'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 0 39'
'set cmark 2'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
'd o'
'set cmark 2'
'set cstyle 1'
'set cthick 5'
'set ccolor 4'
'd p.2'
'set cmark 2'
'set cstyle 1'
'set cthick 5'
'set ccolor 2'
'd p'
'set clopts -1 3 0.05'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
 'define zero=0.'
 'set cstyle 1'
 'set cthick 5'
 'set cmark 0'
 'set ccolor 1'
 'd zero'
*----------
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
endwhile
'set strsiz 0.13 0.13'
'set string 1 tl 4'
'draw string 4.9 6.9 OBS(OI)'
'set string 4 tl 4'
'draw string 4.9 6.6 ANN Hybrid: AC=0.91, RMSE=0.50'
'set string 2 tl 4'
'draw string 4.9 6.3 MLR Hybrid: AC=0.92, RMSE=0.48'
*'draw line 5.6 2. 5.6 3.0'
*'draw line 7.986 2. 7.986 3.0'
*'draw line 9.068 2. 9.068 3.0'
'set string 1 tc 5 '
'set strsiz 0.18 0.18'
'draw string 'xstr' 'ystr' K'
'print'
'printim nino34.obs_ann.djf.png x800 y600'
*'c'
'set vpage off'
*----------
