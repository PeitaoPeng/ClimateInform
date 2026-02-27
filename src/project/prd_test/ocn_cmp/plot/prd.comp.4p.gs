'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/prd_test/gocn.prd.rms.ctl'
'open /cpc/home/wd52pp/data/prd_test/gocn.prd.rms.ss.ctl'
'open /cpc/home/wd52pp/data/prd_test/eocn.prd.rms.sm.ctl'
*
*'enable print meta.rms.ltp_vs_time'
*
*---------------------------string/caption
'set string 1 tc 5'
'set strsiz 0.18 0.18'
'draw string 5.5 7.75 OCN Temp Prediction for DJF 1992'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=2
nframe3=4
nframe4=4
xmin0=0.9;  xlen=4.5;  xgap=0.2
ymax0=7.0; ylen=-2.5; ygap=-0.5
'set t 12'
'define sk1=p'
'define sk2=prd.2'
'define sk3=p15'
*'define sk3=obs'
'define sk4=prd.3'
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
  tlx=xmin-0.3
  tly=ymin+0.7
  tlx2=xmin+2.25
  tly2=ymax+0.2
*
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
'set xlab off'
'set ylab off'
'set lat 24 50'
'set x 3 33'
'set gxout shaded'
'set clevs  -2 -1.5 -1 -0.5 0 0.5 1 1.5 2.'
'set ccols   49 46 44 43 42 22 23 24 26 29' 
'd sk'%iframe
'set string 1 tc 5 0'
if(iframe = 1); 'draw string 'tlx2' 'tly2' K(t,s)'; endif;
if(iframe = 2); 'draw string 'tlx2' 'tly2' K(t)'; endif;
if(iframe = 3); 'draw string 'tlx2' 'tly2' K=15'; endif;
if(iframe = 4); 'draw string 'tlx2' 'tly2' EOCN'; endif;
*
'set string 4 tc 6'
'set strsiz 0.15 0.15'
'set strsiz 0.18 0.18'
iframe = iframe +1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 0 5.5 1.0'
'print'
'printim prd.comp.4p.png gif x800 y600'
*'set vpage off'
