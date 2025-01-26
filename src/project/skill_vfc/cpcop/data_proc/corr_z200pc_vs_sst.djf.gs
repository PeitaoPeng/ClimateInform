'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
mtx=cor
*
'open /cpc/home/wd52pp/data/attr/trend/corr.z200pc_vs_sst.djf.'mtx'.ctl'
*
*'enable print z200_eof12.djf.gr'
*
*---------------------------string/caption
'set string 1 tc 5'
'set strsiz 0.14 0.14'
'draw string 4.25 10.25 AC(%) of PCs to SST ('mtx')'
*---------------------------set dimsnesion, page size and style
*
'define e1=cor1'
'define e2=cor2'
'define e3=cor3'

nframe=2
nframe2=2
nframe3=11
xmin0=1.5;  xlen=5.5;  xgap=0.75
ymax0=9.75; ylen=-2.5;  ygap=-0.25
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
  tlx=xmin+0.08
  tly=ymax+0.05
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
*'set mproj nps'
*'set map 1 1 1'
*'set frame off'
*'set font 0'
'set lat -90 90'
'set ylint 30'
'set lon 0 360'
'set xlint 60'
'set grads off'
'set grid off'
'set gxout shaded'
'set clevs  -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9'
'set ccols 49 48 47 46 45 44 43 42 0 22 23 24 25 26 27 28 29' 
*'set xlab off'
*'set ylab off'
'd e'%iframe

*'set string 1 tc 5 90'
'set string 1 tl 5'
'set strsiz 0.13 0.13'
if(iframe = 1); 'draw string 'tlx' 'tly' a)PC1'; endif
if(iframe = 2); 'draw string 'tlx' 'tly' b)PC2'; endif
if(iframe = 3); 'draw string 'tlx' 'tly' c)PC3'; endif

'set string 1 tc 5 0'

'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
*'run /cpc/home/wd52pp/bin/dline.gs 180 -20 180 80'

iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.85 0 4.25 1.25'
'print'
'printim corr_z200pc_vs_sst.djf.'mtx'.png gif x600 y800'
*'c'
*'set vpage off'
*----------
