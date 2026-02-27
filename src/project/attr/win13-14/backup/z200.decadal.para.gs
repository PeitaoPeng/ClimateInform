'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/para/sst.ndjfm1957-2013.mon.para.ctl'
'open /cpc/home/wd52pp/data/para/z200.ndjfm1957-2013.mon.esm.ctl'
*
'set string 1 tc 5'
'set strsiz 0.13 0.13'
'draw string 4.25 10.25 AMIP DJFM Z200 & SST'
*---------------------------set dimsnesion, page size and style
nframe=3
nframe2=3
nframe3=3
xmin0=1.5;  xlen=5.5;  xgap=0.2
ymax0=9.8; ylen=-2.0;  ygap=-0.5
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
  tlx=xmin+0.3
  tly=ymax+0.2
  bx=xmax+0.
  by=ymax+1.65
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 57'
'define st1=(td+tj+tf+tm)/5-ave((td+tj+tf+tm)/5,t=25,t=54)'
'define st2=ave((td+tj+tf+tm)/5,t=47,t=56)-ave((td+tj+tf+tm)/5,t=25,t=54)'
'define st3=ave((td+tj+tf+tm)/5,t=39,t=56)-ave((td+tj+tf+tm)/5,t=1,t=19)'
'define zz1=(zd.2+zj.2+zf.2+zm.2)/5-ave((zd.2+zj.2+zf.2+zm.2)/5,t=25,t=54)'
'define zz2=ave((zd.2+zj.2+zf.2+zm.2)/5,t=47,t=56)-ave((zd.2+zj.2+zf.2+zm.2)/5,t=25,t=54)'
'define zz3=ave((zd.2+zj.2+zf.2+zm.2)/5,t=39,t=56)-ave((zd.2+zj.2+zf.2+zm.2)/5,t=1,t=19)'
'set t 1'
'set lon 0 360'
'set lat  -40 90'
'set yaxis -40 90 30'
*'set frame off'
'set grads off'
*'set grid off'
'set xlab off'
if(iframe = 4); 'set xlab on'; endif
*'set map 15 1 2'
'set gxout shaded'
'set clevs   -1. -0.8 -0.4 -0.20 0.2 0.4 0.8 1 2 4 6 8 10'
'set ccols    45 44 43 42 0 22 23 23 25 26 27 28 29 69'
'd st'%iframe
'set gxout contour'
'set ccolor 1'
'set cint 5'
if(iframe = 1); 'set cint 10'; endif
'd zz'%iframe
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -30 180 90'
'set string 1 tl 1 0'
'set strsiz 0.12 0.12'
if(iframe = 1); 'draw string 'tlx' 'tly' (a) 2013/14 minus 1981-2010 ClIM'; endif
if(iframe = 2); 'draw string 'tlx' 'tly' (b) (2003-2012)AVG - (1981-1990)AVG'; endif
if(iframe = 3); 'draw string 'tlx' 'tly' (c) (1995-2012)AVG - (1957-1975)AVG'; endif
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 1 'bx' 'by''
'print'
'printim sst_z200.decadal.para.png gif x600 y800'

