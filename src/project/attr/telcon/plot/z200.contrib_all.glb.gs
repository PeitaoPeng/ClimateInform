'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'

zonal=raw
area=glb
mtx=var
ts=rsd_rpc

'open /cpc/home/wd52pp/data/attr/telcon/cor_t.z200_contrib_all.rsd_rpc.djf.raw.ctl'

*---------------------------string/caption
 'set string 1 tc 5 0'
 'set strsiz 0.12 0.12'
 'draw string 4.25 10.75 COR of Reconstructed Z200 to OBS (1980-2021)'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
*
nframe=8
nframe2=4

xmin0=1.25;  xlen=3.25;  xgap=-0.5
ymax0=10.25; ylen=-1.5; ygap=-0.3
*
'define p1=cn'
'define p2=c1'
'define p3=c2'
'define p4=c3'
'define p5=c4'
'define p6=c14'
'define p7=ct'
'define p8=ca'

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
  if(iframe >  4); ylen=-1.5; endif
  if(iframe >  4); xlen=3.25; endif
  if(iframe >  4); ygap=-0.3; endif
  if(iframe >  4); ymax0=10.25; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
* if(iframe = 7); ymax=ymax0+(icy-1)*(ylen+ygap)-0.1; endif
  ymin=ymax+ylen
* if(iframe = 6); titly=ymax+0.1; endif
* if(iframe = 7); titly=ymax+0.1; endif
  xstr=xmin + 0.4
  ystr=ymax + 0.15
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
*if(iframe < 6);
*'set mproj scaled'
*'set lat 20. 70'
'set lat -90. 90'
'set ylint 30'
*'set lon 190 300'
'set lon 0 360'
'set xlint 60'
'set grid on'
*'set poli on'
*'set mpdset mres'
*'set gxout grfill'
'set xlab off'
'set ylab off'
*if(iframe<= 5);'set ylab on';endif
if(iframe< 5);'set ylab on';endif
if(iframe=4);'set xlab on';endif
if(iframe=8);'set xlab on';endif
*
'set gxout shaded'
*'set clevs  -0.3 0.3'
*'set ccols  22 0 22'
*'d c'%ieof
*'set gxout contour'
*'set cint 5'
'set clevs  -90 -80 -70 -60 -50 -40 -30 -20 -10 10 20 30 40 50 60 70 80 90'
'set ccols 49 48 47 46 45 44 43 42 41 0 21 22 23 24 25 26 27 28 29'
'd 100*p'%ieof
*'run /cpc/home/wd52pp/bin/dline.gs  0 0 360 0'
*'run /cpc/home/wd52pp/bin/dline.gs 180 -90 180 90'
'set string 1 tl 5'
'set strsiz 0.11 0.11'
if(iframe = 1);'draw string 'xstr' 'ystr' a)Nino3.4'; endif
if(iframe = 2);'draw string 'xstr' 'ystr' b)RPC1'; endif
if(iframe = 3);'draw string 'xstr' 'ystr' c)RPC2';endif
if(iframe = 4);'draw string 'xstr' 'ystr' d)RPC3'; endif
if(iframe = 5);'draw string 'xstr' 'ystr' e)RPC4'; endif
if(iframe = 6);'draw string 'xstr' 'ystr' f)RPC1-4'; endif
if(iframe = 7);'draw string 'xstr' 'ystr' g)Trend'; endif
if(iframe = 8);'draw string 'xstr' 'ystr' h)All'; endif
*endif
*----------
'set string 1 tl 5'
if(iframe = 8);'run /cpc/home/wd52pp/bin/cbarn.gs 0.8 0 4.25 2.75';endif
*

iframe=iframe+1
ieof=ieof+1
ipc=iframe-4

endwhile
*
*'printim z200.'ts'.contrib_all.'area'.'zonal'.png gif x1200 y1600'
'printim Fig10.png x1200 y1600'
