'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/prd_test/gocn.prog.ocn.vs.ltp_t.rms.ctl'
*
*'enable print meta.ocn.ltp_vs_time'
*
*---------------------------string/caption
'set string 1 tc 5'
'set strsiz 0.18 0.18'
'draw string 5.5 7.8 OCN of Seasonal Mean Temp'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
nframe3=1
nframe4=1
xmin0=1.5;  xlen=8.;  xgap=0.5
ymax0=7.5; ylen=-5.;  ygap=-1.
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
  tlx=xmin+4
  tly=ymin-0.3
  tlx3=xmin-0.8
  tly3=ymax-2.5
*
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
'set x 5 30'
'set t 1 22'
'set xaxis 5 30 5'
'set ylops 0. r'
'set yaxis 1990 2011 5'
'set ylops 0. r'
'set string 1 tc 5 90'
'set strsiz 0.18 0.18'
'draw string 'tlx3' 'tly3' Ending Year of Training data'
'set string 1 tc 5 0'
'set gxout shaded'
'set clevs  7 8 9 10 11 12 13 14 15 16 17 18 19 20'
'set ccols  0 42 44 46 48 32 34 36 38 62 64 65 66 67 69' 
'd mk'
'set string 1 tc 5'
'set strsiz 0.18 0.18'
*'draw string 'tlx' 'tly' Number of Training-data windows'
'draw string 'tlx' 'tly' Length of Training Period'
*
'set string 1 tl 5'
iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 1.0 0 5.5 1.5'
'print'
'printim ocn.ltp_vs_time.png gif x800 y600'
*'set vpage off'
