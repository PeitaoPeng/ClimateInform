'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'

mtx=var
eof_range=tp

'open /cpc/home/wd52pp/data/attr/win15-16/z200_16.djf.contrib.ctl'

*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.12 0.12'
 'draw string 4.25 10.75 Reconstruction of Z200 for 2015/16 DJF'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
*
nframe=10
nframe2=5

xmin0=1.;  xlen=3.25;  xgap=0.2
ymax0=10.25; ylen=-1.5; ygap=-0.3
*
'define p1=obs'
'define p2=n34'
'define p3=c1'
'define p4=c2'
'define p5=c3'
'define p6=c4'
'define p7=trd'
'define p8=trd+n34'
'define p9=c3+c4+p8'
'define p10=p9+c1+c2'

'set t 1'
*
iframe=1
ieof=1
ipc=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  if(iframe >  5); ylen=-1.5; endif
  if(iframe >  4); xlen=3.25; endif
  if(iframe >  5); ygap=-0.3; endif
  if(iframe >  5); ymax0=10.25; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
* if(iframe = 7); ymax=ymax0+(icy-1)*(ylen+ygap)-0.1; endif
  ymin=ymax+ylen
* if(iframe = 6); titly=ymax+0.1; endif
* if(iframe = 7); titly=ymax+0.1; endif
  xstr=xmin + 0.04
  ystr=ymax + 0.15
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
*if(iframe < 6);
*'set mproj scaled'
'set lat -0 90'
'set ylint 30'
'set lon 120 360'
'set xlint 60'
'set grid on'
*'set poli on'
*'set mpdset mres'
*'set gxout grfill'
'set xlab off'
'set ylab off'
if(iframe<= 5);'set ylab on';endif
if(iframe=5);'set xlab on';endif
if(iframe=10);'set xlab on';endif
*
'set gxout shaded'
*'set clevs  -0.3 0.3'
*'set ccols  22 0 22'
*'d c'%ieof
*'set gxout contour'
*'set cint 5'
'set clevs  -90 -60 -40 -20 -15 -10 -5 -1 1 5 10 15 20 40 60 90'
'set ccols  49 47 46 45 44 43 42 41 0 21 22 23 24 25 26 27 29'
'd p'%ieof
*'run /cpc/home/wd52pp/bin/dline.gs 120 0 360 0'
*'run /cpc/home/wd52pp/bin/dline.gs 180 0 180 90'
'set string 1 tl 5 0'
'set strsiz 0.11 0.11'
if(iframe = 1);'draw string 'xstr' 'ystr' a)OBS'; endif
if(iframe = 2);'draw string 'xstr' 'ystr' b)Nino3.4'; endif
if(iframe = 3);'draw string 'xstr' 'ystr' c)PC1'; endif
if(iframe = 4);'draw string 'xstr' 'ystr' d)PC2'; endif
if(iframe = 5);'draw string 'xstr' 'ystr' e)PC3'; endif
if(iframe = 6);'draw string 'xstr' 'ystr' f)PC4'; endif
if(iframe = 7);'draw string 'xstr' 'ystr' g)Trend'; endif
if(iframe = 8);'draw string 'xstr' 'ystr' h)Nino34+Trend'; endif
if(iframe = 9);'draw string 'xstr' 'ystr' i)Nino34+Trend+PC3+PC4'; endif
if(iframe = 10);'draw string 'xstr' 'ystr' j)All'; endif
*endif
*----------
'set string 1 tl 5 0'
if(iframe = 10);'run /cpc/home/wd52pp/bin/cbarn.gs 0.9 0 4.25 1.0';endif
*

iframe=iframe+1
ieof=ieof+1
ipc=iframe-5

endwhile
*
'printim z200.contrib.16.png gif x600 y800'
