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
'set strsiz 0.15 0.15'
'draw string 5.5 10.5 OCN of Seasonal Mean Temp'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
nframe3=2
nframe4=2
xmin0=1.25;  xlen=6.;  xgap=0.5
ymax0=9.75; ylen=-3.5;  ygap=-1.
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
  tlx=xmin+3
  tly=ymin-0.3
  tlx2=xmin+0.
  tly2=ymax+0.2
  tlx3=xmin-0.65
  tly3=ymax-1.75
*
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
'set x 5 30'
'set t 1 22'
'set xaxis 5 30 5'
if(iframe > 2); 'set ylops 0. r'; endif;
'set yaxis 1990 2011 5'
if(iframe > 2); 'set ylops 0. r'; endif;
'set string 1 tc 5 90'
'set strsiz 0.13 0.13'
if(iframe <= 2);
'draw string 'tlx3' 'tly3' End Year of Test Window'
endif
'set string 1 tc 5 0'
'set gxout shaded'
'set clevs  7 8 9 10 11 12 13 14 15 16 17 18 19 20'
'set ccols  0 31 33 34 35 37 38 39 21 23 24 25 27 28 29' 
if(iframe = 1);'d mk'; endif
if(iframe = 2);'d mk.2'; endif
'set string 1 tc 5'
'set strsiz 0.12 0.12'
'draw string 'tlx' 'tly' Width of Test Window (year)'
*
'set string 1 tl 5'
if(iframe = 1); 'draw string 'tlx2' 'tly2' (a) From ACC metrics'; endif;
if(iframe = 2); 'draw string 'tlx2' 'tly2' (b) From RMS metrics'; endif;
iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 1.0 0 4.25 0.8'
'print'
'printim ocn.ltp_vs_time.noss.png gif x600 y800'
*'set vpage off'
