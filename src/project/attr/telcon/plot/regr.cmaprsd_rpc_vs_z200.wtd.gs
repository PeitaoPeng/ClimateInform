'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'

mtx=var
eof_range=tp

*'open /cpc/home/wd52pp/data/attr/telcon/corr.cmaprsd_rpc_vs_z200.djf.wtd.raw.ctl'
'open /cpc/home/wd52pp/data/attr/telcon/corr.cmaprsd_rpc_vs_z200.djf.wtd.eddy.ctl'

*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.12 0.12'
* 'draw string 4.25 10.75 DJF Z200 vs CMAP RSD_RPC'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
*
nframe=6
nframe2=3

xmin0=1.25;  xlen=2.75;  xgap=0.5
ymax0=10.25; ylen=-2.75; ygap=-0.4
*
'set mproj nps'
'set lat 20 90'
'set lon -270 90'
'define p1=-reg2'
'define p2=reg3'
'define p3=reg4'
'define p4=reg5'
'define p5=reg6'
'define p6=reg7'
'define c1=cor2'
'define c2=cor3'
'define c3=cor4'
'define c4=cor5'
'define c5=cor6'
'define c6=cor7'

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
  if(iframe >  3); ylen=-2.75; endif
*  if(iframe >  4); xlen=2.75; endif
  if(iframe >  3); ygap=-0.4; endif
  if(iframe >  3); ymax0=10.25; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
* if(iframe = 7); ymax=ymax0+(icy-1)*(ylen+ygap)-0.1; endif
  ymin=ymax+ylen
  if(iframe = 6); titly=ymax+0.1; endif
  if(iframe = 7); titly=ymax+0.1; endif
  xstr=xmin + 1.5
  ystr=ymax + 0.2
  if(iframe > 3);
  xstr=xmin + 1.25
  bx=4.25
  by=0.85
  endif
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
'set frame off'
if(iframe < 7);
'set grid on'
*if(iframe=5);'set xlab on';endif
*
'set gxout shaded'
'set clevs  -40 -30 -25 -20 -15 -10 -5 5 10 15 20 25 30 40'
'set ccols  49 48 47 46 45 44 42 0 22 24 25 26 27 28 29'
'd p'%ieof
*'set gxout contour'
*'set clevs -0.5 -0.4 -0.3 0.3 0.4 0.5'
'set gxout grid'
'set gridln off'
'set digsize 0.03'
'set cthick 8'
'set ccolor 0'
if(iframe = 1); 'define cc=maskout(c1,abs(c1)-0.3)'; endif
if(iframe = 2); 'define cc=maskout(c2,abs(c2)-0.3)'; endif
if(iframe = 3); 'define cc=maskout(c3,abs(c3)-0.3)'; endif
if(iframe = 4); 'define cc=maskout(c4,abs(c4)-0.3)'; endif
if(iframe = 5); 'define cc=maskout(c5,abs(c5)-0.3)'; endif
if(iframe = 6); 'define cc=maskout(c6,abs(c6)-0.3)'; endif
'd skip(cc-cc,4,2)'
*'set string 1 tc 5 90'
'set string 1 tc 5 0'
'set strsiz 0.12 0.12'
if(iframe = 1);'draw string 'xstr' 'ystr' a)RPC1'; endif
if(iframe = 2);'draw string 'xstr' 'ystr' b)RPC2'; endif
if(iframe = 3);'draw string 'xstr' 'ystr' c)RPC3'; endif
if(iframe = 4);'draw string 'xstr' 'ystr' d)RPC4'; endif
if(iframe = 5);'draw string 'xstr' 'ystr' e)RPC5'; endif
if(iframe = 6);'draw string 'xstr' 'ystr' f)RPC6'; endif
endif
*----------
'set string 1 tc 5 0'
if(iframe = 6);'run /cpc/home/wd52pp/bin/cbarn.gs 0.8 0 'bx' 'by'';endif
*

iframe=iframe+1
ieof=ieof+1
ipc=iframe-3

endwhile
*
*'printim regr.cmaprsd_rpc.vs.z200.wtd.png gif x600 y800'
'printim regr.cmaprsd_rpc.vs.z200.wtd.eddy.png gif x600 y800'
