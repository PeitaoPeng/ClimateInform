'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open pcor_hstg.z200.ndjfm1949-2014.ctl'
'open pcor_hstg.z200.ndjfm1957-2013.para.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 4.25 10.3 Histogram of Z200 Pat Cor over NEP-NA for NDJFM'
'draw string 2.55 10.0 OBS'
'draw string 6.15 10.0 GOGA'
*---------------------------set dimsnesion, page size and style
'define hh1=h1'
'define hh2=h2'
'define hh3=h3'
'define hh4=h4'
'define hh5=h1.2'
'define hh6=h2.2'
'define hh7=h3.2'
'define hh8=h4.2'
nframe=8
nframe2=4
nframe3=8
xmin0=1.;  xlen=3.2;  xgap=0.4
ymax0=9.75; ylen=-1.75;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  if (iframe > nframe3); icx=3; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  if (iframe > nframe3); icy=iframe-nframe3; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  tlx=xmin+0.2
  tly=ymax-0.1
  tly2=ymax-0.3
  tlx3=xmin-0.55
  tly3=ymax-0.875
  tlx4=xmin+1.6
  tly4=ymin-0.35
  bx=xmax+0.5
  by=ymax+1.75
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set vrange 0 18'
'set grads off'
'set yaxis 0 18 2'
'set xaxis -0.95 0.95 0.2'
*'set xlab off'
*'set ylab off'
*if(iframe <= 3);'set ylab on'; endif
'set gxout bar'
'set bargap 30'
'set ccolor 4'
'd 100*hh'%iframe
'set string 1 tl 5'
'set strsiz 0.12 0.12'
if(iframe = 1); 'draw string 'tlx' 'tly'  1-mon Lag, 260 samples'; endif
if(iframe = 1); 'draw string 'tlx' 'tly2' Mean=0.23 STD=0.35'; endif
if(iframe = 2); 'draw string 'tlx' 'tly'  2-mon Lag, 195 samples'; endif
if(iframe = 2); 'draw string 'tlx' 'tly2' Mean=0.07 STD=0.38'; endif
if(iframe = 3); 'draw string 'tlx' 'tly'  3-mon Lag, 130 samples'; endif
if(iframe = 3); 'draw string 'tlx' 'tly2' Mean=0.04 STD=0.37'; endif
if(iframe = 4); 'draw string 'tlx' 'tly'  4-mon Lag,  65 samples'; endif
if(iframe = 4); 'draw string 'tlx' 'tly2' Mean=0.06 STD=0.34'; endif
if(iframe = 5); 'draw string 'tlx' 'tly'  1-mon Lag, 4104 samples'; endif
if(iframe = 5); 'draw string 'tlx' 'tly2' Mean=0.20 STD=0.36'; endif
if(iframe = 6); 'draw string 'tlx' 'tly'  2-mon Lag, 3078 samples'; endif
if(iframe = 6); 'draw string 'tlx' 'tly2' Mean=0.08 STD=0.37'; endif
if(iframe = 7); 'draw string 'tlx' 'tly'  3-mon Lag, 2052 samples'; endif
if(iframe = 7); 'draw string 'tlx' 'tly2' Mean=0.06 STD=0.36'; endif
if(iframe = 8); 'draw string 'tlx' 'tly'  4-mon Lag, 1026 samples'; endif
if(iframe = 8); 'draw string 'tlx' 'tly2' Mean=0.03 STD=0.35'; endif
'set string 1 tc 5 90'
'set strsiz 0.14 0.14'
if(iframe <= 4);'draw string 'tlx3' 'tly3'  Frequency(%)'; endif
'set string 1 tc 5 0'
if(iframe = 4);'draw string 'tlx4' 'tly4'  Pattern COR'; endif
if(iframe = 8);'draw string 'tlx4' 'tly4'  Pattern COR'; endif
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
*'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 1 'bx' 'by''
'print'
'printim hstg.z200.obs-para.na.png gif x600 y800'

