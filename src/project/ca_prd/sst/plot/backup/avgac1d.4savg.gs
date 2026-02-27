'reinit'
eof_range=tp_ml
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/casst/avgac1d.hadoisst.mam.'eof_range'.ctl'
'open /cpc/home/wd52pp/data/casst/avgac1d.hadoisst.jja.'eof_range'.ctl'
'open /cpc/home/wd52pp/data/casst/avgac1d.hadoisst.son.'eof_range'.ctl'
'open /cpc/home/wd52pp/data/casst/avgac1d.hadoisst.djf.'eof_range'.ctl'
'open /cpc/home/wd52pp/data/casst/avgac1d.ersst.mam.'eof_range'.ctl'
'open /cpc/home/wd52pp/data/casst/avgac1d.ersst.jja.'eof_range'.ctl'
'open /cpc/home/wd52pp/data/casst/avgac1d.ersst.son.'eof_range'.ctl'
'open /cpc/home/wd52pp/data/casst/avgac1d.ersst.djf.'eof_range'.ctl'
*
'define sk=(ac+ac.2+ac.3+ac.4)/4.'
'define sk1=(ac1+ac1.2+ac1.3+ac1.4)/4.'
'define sk2=(ac2+ac2.2+ac2.3+ac2.4)/4.'
'define sk3=(ac3+ac3.2+ac3.3+ac3.4)/4.'
'define sk4=(ac4+ac4.2+ac4.3+ac4.4)/4.'
'define s2k=(ac.5+ac.6+ac.7+ac.8)/4.'
'define s2k1=(ac1.5+ac1.6+ac1.7+ac1.8)/4.'
'define s2k2=(ac2.5+ac2.6+ac2.7+ac2.8)/4.'
'define s2k3=(ac3.5+ac3.6+ac3.7+ac3.8)/4.'
'define s2k4=(ac4.5+ac4.6+ac4.7+ac4.8)/4.'
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
'd sk'
'set cthick 7'
'set ccolor 2'
'set cmark 0'
'd sk1'
'set ccolor 3'
'set cmark 0'
'd sk2'
'set ccolor 4'
'set cmark 0'
'd sk3'
'set ccolor 5'
'set cmark 0'
'd sk4'
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
'd s2k'
'set cthick 7'
'set ccolor 2'
'set cmark 0'
'd s2k1'
'set ccolor 3'
'set cmark 0'
'd s2k2'
'set ccolor 4'
'set cmark 0'
'd s2k3'
'set ccolor 5'
'set cmark 0'
'd s2k4'
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
'printim avgac1d.4savg.'eof_range'.png gif x1200 y1600'
'print'
*
*'c'
'set vpage off'
