'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'

mon=Apr
ye1=2020
ye2=2000

'open /cpc/consistency/telecon/gb//monthly_tele_indices_1950-pres.ctl'

*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.12 0.12'
 'draw string 4.25 10.5 stardardized & cos(lat)**0.5 Weighted Z200 Anom'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
*
nframe=2
nframe2=2

xmin0=2.25;  xlen=4.;  xgap=0.2
ymax0=9.5; ylen=-4; ygap=-0.5
*
'set poli on'
'set mproj nps'
'set lat 20 90'
'set lon -270 90'
'set poli on'
*
'define p1=z(time=jul2010)'
'define p2=z(time=jul2019)'

'set t 1'
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  if(iframe >  5); ylen=-2.4; endif
  if(iframe >  4); xlen=3.; endif
  if(iframe >  5); ygap=-0.1; endif
  if(iframe >  5); ymax0=10.25; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
* if(iframe = 7); ymax=ymax0+(icy-1)*(ylen+ygap)-0.1; endif
  ymin=ymax+ylen
  xstr=xmin + 2.
  ystr=ymax + 0.2
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
'set frame off'
'set xlab off'
'set ylab off'
'set poli on'
*
'set gxout shaded'
     'set grads off'
     'set ccols 48 46 45 44 43 42 41 21 22 23 24 25 26 28'
     'set clevs -3 -2.5 -2. -1.5 -1 -0.5 0 0.5 1 1.5 2 2.5 3'
'd p'%iframe
'set string 1 tc 5 0'
'set strsiz 0.11 0.11'
if(iframe = 1);'draw string 'xstr' 'ystr' Jul2010'; endif
if(iframe = 2);'draw string 'xstr' 'ystr' Jul2019'; endif
*endif
*----------
'set string 1 tl 5 0'
if(iframe = 2);'run /cpc/home/wd52pp/bin/cbarn.gs 0.9 1 7.5 5.25';endif
*

iframe=iframe+1

endwhile
'printim z200.nps.choose.png gif x600 y800'
*'c'
