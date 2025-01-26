'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'

mon=Jul
ye1=2020
ye2=2000

'open /cpc/consistency/telecon/rpc.NH.R1_z500.'mon'.mtx2.yre'ye1'.ctl'

*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.12 0.12'
 'draw string 4.25 10.65 RPC of 'mon' NH Z500(R1)'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
*
nframe=4
nframe2=4

xmin0=0.85;  xlen=7.;  xgap=0.2
ymax0=10.25; ylen=-2.; ygap=-0.4
*
'set x 72 142'
'set line 0 1 6'
'run /cpc/home/wd52pp/bin/dline.gs 71 0 141 0'
*
'define p1=cf1'
'define p2=-cf5'
'define p3=-cf10'
'define p4=cf9'
'set xaxis 1950 2020 5'

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
  xstr=xmin + 0.25
  ystr=ymax-0.2
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
*'set frame off'
*'set xlab off'
*'set ylab off'
*'set poli on'
*
'set line 0 1 6'
'run /cpc/home/wd52pp/bin/dline.gs 71 0 141 0'
'set gxout line'
'set vrange -3 3'
'set xaxis 1950 2020 5'
'd p'%iframe
'set string 1 tl 5 0'
'set strsiz 0.11 0.11'
if(iframe = 1);'draw string 'xstr' 'ystr' NAO'; endif
if(iframe = 2);'draw string 'xstr' 'ystr' PNA'; endif
if(iframe = 3);'draw string 'xstr' 'ystr' TNH'; endif
if(iframe = 4);'draw string 'xstr' 'ystr' WP'; endif
*endif
*----------
'set string 1 tl 5 0'
*

iframe=iframe+1

endwhile
'printim rpcf.NH.R1_z500.'mon'.mtx2.png gif x600 y800'
*'c'
