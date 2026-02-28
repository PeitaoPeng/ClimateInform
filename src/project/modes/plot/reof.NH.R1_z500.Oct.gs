'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'

mon=Oct
ye1=2020
ye2=2000

'open /cpc/consistency/telecon/reof.NH.R1_z500.'mon'.mtx2.yre'ye1'.ctl'
'open /cpc/consistency/telecon/reof.NH.R1_z500.'mon'.mtx2.yre'ye2'.ctl'

*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.12 0.12'
 'draw string 4.25 10.95 REOF Patterns of 'mon' NH Z500(R1)'
 'draw string 2.5 10.6 1950-2020'
 'draw string 5.75 10.6 1950-2000'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
*
nframe=8
nframe2=4

xmin0=1.;  xlen=3.;  xgap=0.2
ymax0=10.25; ylen=-2.4; ygap=-0.1
*
'set poli on'
'set mproj nps'
'set lat 20 90'
'set lon -270 90'
'set poli on'
*
'define p1=-eof2'
'define p2=eof3'
'define p3=eof7'
'define p4=-eof9'
'define p5=-eof2.2'
'define p6=eof4.2'
'define p7=-eof6.2'
'define p8=-eof9.2'

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
  xstr=xmin + 3.0
  ystr=ymax + 0.
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
*'set clevs  -90 -80 -70 -60 -50 -40 -30 -20 -10 10 20 30 40 50 60 70 80 90'
*'set ccols  49 48 47 46 45 44 43 42 41 0 21 22 23 24 25 26 27 28 29'
'set clevs  -60 -45 -30 -15 15 30 45 60'
'set ccols  48 46 44 42 0 22 24 26 28'
'd 100*p'%iframe
*'d p'%iframe
'set string 1 tl 5 0'
'set strsiz 0.11 0.11'
if(iframe = 1);'draw string 'xstr' 'ystr' NAO'; endif
if(iframe = 2);'draw string 'xstr' 'ystr' PNA'; endif
if(iframe = 3);'draw string 'xstr' 'ystr' TNH'; endif
if(iframe = 4);'draw string 'xstr' 'ystr' WP'; endif
*endif
*----------
'set string 1 tl 5 0'
if(iframe = 8);'run /cpc/home/wd52pp/bin/cbarn.gs 0.9 1 7.5 5.25';endif
*

iframe=iframe+1

endwhile
'printim reof.NH.R1_z500.'mon'.mtx2.2ye_compare.png gif x600 y800'
*'c'
