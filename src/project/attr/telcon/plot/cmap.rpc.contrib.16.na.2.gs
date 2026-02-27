'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'

mtx=var
eof_range=tp
ts=rsd_rpc

'open /cpc/home/wd52pp/data/attr/telcon/cmap_16.'ts'.djf.contrib.ctl'

*---------------------------string/caption
 'set string 1 tc 5 0'
 'set strsiz 0.12 0.12'
 'draw string 4.25 10.75 Reconstruction of Prate for 2015/16 DJF'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
*
nframe=10
nframe2=5

xmin0=1.55 ;  xlen=2.75;  xgap=0.0
ymax0=10.25; ylen=-1.5; ygap=-0.3
*
'define p1=obs'
'define p2=n34'
'define p3=c1'
'define p4=c2'
'define p5=c3'
'define p6=c4'
'define p7=c1+c2+c3+c4'
'define p8=trd'
'define p9=trd+n34'
'define p10=p8+p9'

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
  if(iframe >  4); xlen=2.75; endif
  if(iframe >  5); ygap=-0.3; endif
  if(iframe >  5); ymax0=10.25; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
* if(iframe = 7); ymax=ymax0+(icy-1)*(ylen+ygap)-0.1; endif
  ymin=ymax+ylen
* if(iframe = 6); titly=ymax+0.1; endif
* if(iframe = 7); titly=ymax+0.1; endif
  xstr=xmin + 0.25
  ystr=ymax + 0.15
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
*if(iframe < 6);
*'set mproj scaled'
'set lat 25. 65'
'set ylint 10'
'set lon 200 270'
'set xlint 20'
'set grid on'
'set poli on'
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
'set clevs  -2.0 -1.6 -1.2 -0.8 -0.4 -0.1 0.1 0.4 0.8 1.2 1.6 2'
'set ccols  79 77 76 75 74 72 0 32 34 35 36 37 39'
'd p'%ieof
*'run /cpc/home/wd52pp/bin/dline.gs 120 0 360 0'
*'run /cpc/home/wd52pp/bin/dline.gs 180 0 180 90'
'set string 1 tl 5'
'set strsiz 0.11 0.11'
if(iframe = 1);'draw string 'xstr' 'ystr' a)OBS'; endif
if(iframe = 2);'draw string 'xstr' 'ystr' b)Nino3.4'; endif
if(iframe = 3);'draw string 'xstr' 'ystr' c)RPC1'; endif
if(iframe = 4);'draw string 'xstr' 'ystr' d)RPC2'; endif
if(iframe = 5);'draw string 'xstr' 'ystr' e)RPC3'; endif
if(iframe = 6);'draw string 'xstr' 'ystr' f)RPC4'; endif
if(iframe = 7);'draw string 'xstr' 'ystr' g)RPC1-4'; endif
if(iframe = 8);'draw string 'xstr' 'ystr' h)Trend'; endif
if(iframe = 9);'draw string 'xstr' 'ystr' i)Nino34+Trend'; endif
if(iframe = 10);'draw string 'xstr' 'ystr' j)All'; endif
*endif
*----------
'set string 1 tl 5'
if(iframe = 10);'run /cpc/home/wd52pp/bin/cbarn.gs 0.9 0 4.3 1.0';endif
*

iframe=iframe+1
ieof=ieof+1
ipc=iframe-5

endwhile
*
*'printim cmap.'ts'.contrib.16.na.png gif x1200 y1600'
'printim Fig9.png x1200 y1600'
