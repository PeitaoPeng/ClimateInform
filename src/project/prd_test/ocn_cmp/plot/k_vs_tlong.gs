'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
*'open /cpc/home/wd52pp/data/prd_test/gocn.k_vs_t.acc.ctl'
'open /cpc/home/wd52pp/data/prd_test/gocn.k_vs_t.rms.ctl'
*
*'enable acc_vs_t.ltp'
*
*---------------------------string/caption
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 5.5 7.7 OCN vs Ending Year of Training Data'
'draw string 5.5 7.4 (Training Period Starts from 1961)'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
nframe3=1
nframe4=1
xmin0=1.;  xlen=9.;  xgap=0.75
ymax0=7; ylen=-5;  ygap=-1.
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  if (iframe > nframe3); icx=3; endif
  if (iframe > nframe4); icx=4; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  if (iframe > nframe3); icy=iframe-nframe3; endif
  if (iframe > nframe4); icy=iframe-nframe4; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  tlx=xmin+1.
  tly=ymax-0.5
  tlx2=xmin+1
  tly2=ymax-0.8
*
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
'set vrange 10 20'
'set xaxis 1990 2015 2'
if(iframe = 1) 
'd k' 
'set ccolor 2'
*'d k.2' 
endif
*
'draw xlab Ending Year of Training Data'
'draw ylab K(years)'
'set strsiz 0.15 0.15'
'set string 1 tl 5'
*'draw string 'tlx' 'tly' From ACC metrics'
'set string 2 tl 5'
*'draw string 'tlx2' 'tly2' From RMSE metrics'
iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 1.0 0 4.25 0.9'
'print'
'printim k_vs_t.png gif x800 y600'
*'set vpage off'
