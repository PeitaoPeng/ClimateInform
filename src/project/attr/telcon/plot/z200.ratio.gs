'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'

zonal=raw
area=glb
mtx=var
ts=rsd_rpc

'open /cpc/home/wd52pp/data/attr/telcon/corr.cmaprsd_rpc_vs_z200.djf.wtd.raw.ctl'
'open /cpc/home/wd52pp/data/attr/telcon/z200.raw.djf.80-cur.ctl'

*---------------------------string/caption
 'set string 1 tc 5 0'
 'set strsiz 0.12 0.12'
 'draw string 4.25 10.5 Fraction (%) of Variance Explained By Indices'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
*
nframe=2
nframe2=2

xmin0=2.5;  xlen=3.5;  xgap=-0.5
ymax0=10.; ylen=-2.5; ygap=-0.1
*
*'set mproj nps'
*'set lat 20 90'
*'set lon -270 90'
*
'define venso=reg1*reg1'
'define veofs=reg2*reg2+reg3*reg3+reg4*reg4+reg5*reg5'
'define vtot=ave(z.2*z.2,t=1,t=42)'
'define r2=100*venso/vtot'
'define r1=100*veofs/vtot'

'set t 1'
*
iframe=1
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
  xstr=xmin + 0.0
  ystr=ymax + 0.
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
'set grads off'
'set frame off'
*
'set grads off'
*if(iframe < 6);
'set lat -90. 90'
'set ylint 30'
*'set lon 190 300'
'set lon 0 360'
'set xlint 60'
'set grid on'
'set poli on'
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
*'set clevs  5 10 15 20 25 30 35 40 45 50'
*'set clevs  5 10 15 20 25 30 35 40 45'
'set clevs  10 20 30 40 60 80'
'set ccols 0 22 23 24 25 26 27 28 29'
'd r'%iframe
*'run /cpc/home/wd52pp/bin/dline.gs  0 0 360 0'
*'run /cpc/home/wd52pp/bin/dline.gs 180 -90 180 90'
'set string 1 tl 5'
'set strsiz 0.11 0.11'
if(iframe = 1);'draw string 'xstr' 'ystr' a)RPC1-4'; endif
if(iframe = 2);'draw string 'xstr' 'ystr' b)Nino3.4'; endif
*endif
*----------
'set string 1 tl 5'
if(iframe = 2);'run /cpc/home/wd52pp/bin/cbarn.gs 0.6 0 4.25 4.75';endif
*

iframe=iframe+1

endwhile
*
'printim z200.ratio.png gif x1200 y1600'
