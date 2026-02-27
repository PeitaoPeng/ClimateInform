'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/prd_skill/gocn_skill.vs.ltp.prog.acc.ctl'
*
*'enable print meta.ocn.ltp_vs_time'
*
*---------------------------string/caption
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 4.25 10.5 OCN of Seasonal Mean Temp(C)'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=2
nframe3=4
nframe4=4
xmin0=1.25;  xlen=3.;  xgap=0.5
ymax0=10.; ylen=-3.5;  ygap=-0.5
*
'define e1=mk(t=3)'
'define e3=mk(t=6)'
'define e2=mk(t=9)'
'define e4=mk(t=12)'
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
  tlx=xmin+1.5
  tly=ymin-0.1
  tlx2=xmin+1.5
  tly2=ymax+0.0
  tlx3=xmin-0.65
  tly3=ymax-1.75
*
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
'set x 5 30'
'set xaxis 5 30 5'
if(iframe > 2); 'set ylops 0. r'; endif;
'set yaxis 1990 2011 5'
if(iframe > 2); 'set ylops 0. r'; endif;
'set string 1 tc 5 90'
'set strsiz 0.12 0.12'
if(iframe <= 2);
'draw string 'tlx3' 'tly3' End Year of Test Window'
endif
'set string 1 tc 5 0'
'set gxout shaded'
'set clevs  4 6 8 10 12 14 16 18 20 22 24 26 28 30'
'set ccols  0 31 32 33 34 35 37 39 21 22 23 24 25 27 29' 
'd e'%iframe
'set string 1 tc 5'
'set strsiz 0.12 0.12'
'draw string 'tlx' 'tly' Width of Test Window (year)'
*
if(iframe = 1); 'draw string 'tlx2' 'tly2' MAM'; endif;
if(iframe = 2); 'draw string 'tlx2' 'tly2' SON'; endif;
if(iframe = 3); 'draw string 'tlx2' 'tly2' JJA'; endif;
if(iframe = 4); 'draw string 'tlx2' 'tly2' DJF'; endif;
iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 1.0 0 4.5 1.75'
'print'
'printim ocn.ltp_vs_time.png gif x600 y800'
*'set vpage off'
