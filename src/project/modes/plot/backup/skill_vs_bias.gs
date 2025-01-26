'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/bias_skill/avg_skill_bias.amip.z200.jfm.51-99.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 5.5 7.5 JFM Z200 ACC vs Model Bias in NH'
 'set strsiz 0.12 0.12'
'draw string 5.5 7.25 From AMIP Ensemble Runs of 11 AGCMs over 1951-99'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=1
xmin0=1.;  xlen=4.;  xgap=1.
ymax0=6.75; ylen=-3.5;  ygap=-0.5
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
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
*'set frame off'
'set grads off'
*'set grid off'
*'set xlab off'
*'set ylab off'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout scatter'
'set t 1'
'set cmark 5'
if (iframe = 1);'set vrange 20 180';endif
if (iframe = 2);'set vrange 20 60';endif
'set vrange2 0 50'
*if (iframe = 1);'d bia;enso_cor*100';endif
 if (iframe = 1);'d bia;cor*100';endif
if (iframe = 2);'d clr;cor*100';endif
'draw ylab ACC(%)'
if (iframe = 1);'draw xlab Bias in Total Clim';endif
if (iframe = 2);'draw xlab Bias in Eddy Clim';endif
*----------
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
endwhile
*'print'
'printim cor_vs_bias.png gif x800 y600'
*'c'
 'set vpage off'
*----------
