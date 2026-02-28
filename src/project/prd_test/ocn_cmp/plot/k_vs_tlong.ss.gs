'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/prd_test/gocn.ocn.vs.ss_t.rms.ss.ctl'
*
*'enable acc_vs_t.ltp'
*
*---------------------------string/caption
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 5.5 7.7 Seasonally dependent OCN vs Ending Year of Training Data'
'draw string 5.5 7.4 (Training period Starts from 1961)'
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
'set vrange 10 30'
'set xaxis 1990 2011 2'
if(iframe = 1) 
'set t 1 22'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
'd k12' 
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 2'
'd k3' 
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 3'
'd k6' 
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 4'
'd k9' 
endif
*
'draw xlab Ending Year of Training Data'
'draw ylab K(years)'
iframe=iframe+1
endwhile
'set strsiz 0.14 0.14'
'set string 1 tl 5'
'draw string 1.5 6.4 DJF'
'set string 2 tl 5'
'draw string 2.0 6.4 MAM'
'set string 3 tl 5'
'draw string 2.5 6.4 JJA'
'set string 4 tl 5'
'draw string 3.0 6.4 SON'
'print'
'printim k_vs_t.ss.png gif x800 y600'
*'set vpage off'
