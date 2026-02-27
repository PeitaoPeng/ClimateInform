'reinit'
icseason=son
lasticmon=Nov
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/casst/avgac1d.hadoisst.'icseason'.tp_ml.ctl'
'open /cpc/home/wd52pp/data/casst/avgac1d.ersst.'icseason'.tp_ml.ctl'
*
*---------------------------string/caption
'set string 1 tc 5'
'set strsiz 0.14 0.14'
'draw string 4.25 9.75 ICs through 'lasticmon''
'draw string 4.25 10 Skill(AC) for Ensemble Mean over all EOF Cutoffs'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.13 0.13'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
xmin0=1.25;  xlen=6.;  xgap=0.6
ymax0=9.25; ylen=-3;  ygap=-0.8
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  tlx=xmin+0.0
  tly=ymax+0.2
  xx=xmin+3.5
  y1=ymax-0.5
  y2=ymax-0.7
  y3=ymax-0.9
  y4=ymax-1.1
  y5=ymax-1.3
  xlabx=xmin+3.
  xlaby=ymin-0.25
  ylabx=xmin-0.65
  ylaby=ymin+1.5
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set mproj scaled'
'set x 1'
'set y 1'
'set grads off'
'set vrange 0.4 0.8'
*'set grid off'
*'set xlabs  JAS | ASO | SON | OND | NDJ | DJF | JFM | FMA '
'set xaxis 0 7 1'
'set x 4 11'
if(iframe = 1);
ii=1
'set ccolor 1'
'set cmark 0'
'set cthick 20'
'd ac'
'set cthick 7'
'set ccolor 2'
'set cmark 0'
'd ac1'
'set ccolor 3'
'set cmark 0'
'd ac2'
'set ccolor 4'
'set cmark 0'
'd ac3'
'set ccolor 5'
'set cmark 0'
'd ac4'
 'set string 1 tc 5 90'
 'set strsiz 0.13 0.13'
 'set string 2 tl 5 0'
 'draw string 'xx' 'y1' 1-season ICs'
 'set string 3 tl 5 0'
 'draw string 'xx' 'y2' 2-season ICs'
 'set string 4 tl 5 0'
 'draw string 'xx' 'y3' 3-season ICs'
 'set string 5 tl 5 0'
 'draw string 'xx' 'y4' 4-season ICs'
 'set string 1 tl 6 0'
 'draw string 'xx' 'y5' ensemble mean'
 'set string 1 tl 5 0'
 'draw string 'tlx' 'tly' a) HADOI-SST'
endif
if(iframe = 2);
ii=1
'set ccolor 1'
'set cmark 0'
'set cthick 20'
'd ac.2'
'set cthick 7'
'set ccolor 2'
'set cmark 0'
'd ac1.2'
'set ccolor 3'
'set cmark 0'
'd ac2.2'
'set ccolor 4'
'set cmark 0'
'd ac3.2'
'set ccolor 5'
'set cmark 0'
'd ac4.2'
 'set string 1 tc 5 90'
 'set strsiz 0.13 0.13'
 'set string 2 tl 5 0'
 'draw string 'xx' 'y1' 1-season ICs'
 'set string 3 tl 5 0'
 'draw string 'xx' 'y2' 2-season ICs'
 'set string 4 tl 5 0'
 'draw string 'xx' 'y3' 3-season ICs'
 'set string 5 tl 5 0'
 'draw string 'xx' 'y4' 4-season ICs'
 'set string 1 tl 6 0'
 'draw string 'xx' 'y5' ensemble mean'
 'set string 1 tl 5 0'
 'draw string 'tlx' 'tly' b) ERSST'
endif
 'set string 1 tc 5 0'
'draw string 'xlabx' 'xlaby' Lead (month)'
'set string 1 tc 5 90'
'draw string 'ylabx' 'ylaby' AC Skill'
  iframe=iframe+1
endwhile
'printim avgac1d.'icseason'.png gif x1200 y1600'
'print'
*
*'c'
'set vpage off'
