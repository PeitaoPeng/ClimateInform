'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'

'open /cpc/home/wd52pp/data/ca_proj/corr.z200rpc_vs_sst.djf.yb1979.79-22.ctl'

*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
 'draw string 5.5 8.5 Regr of SST to RPC of Z200 (AMIP30_esm,1979-2022)'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
*
nframe=6
nframe2=3

xmin0=0.75;  xlen=4.25;  xgap=0.5
ymax0=8.0; ylen=-2.35;  ygap=-0.1
*
iframe=1
ieof=1
ipc=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  if(iframe >= 3); ylen=-2.35; endif
  if(iframe >= 3); ygap=-0.1; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
* if(iframe = 3); ymax=ymax0+(icy-1)*(ylen+ygap)-0.1; endif
  ymin=ymax+ylen
  titlx=xmin+0.5
  titly=ymax-1.8
* if(iframe = 6); titly=ymax+0.2; endif
* if(iframe = 7); titly=ymax+0.1; endif
* barx=xmin+4.1
  barx=5.25
  bary=ymin-0.45
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set lat -89.5 89.5'
'set ylint 30'
'set lon 0 360'
'set xlint 60'
'set grads off'
'set grid on'
'set poli on'
'set xlab off'
if(iframe = 3); 'set xlab on'; endif
if(iframe = 6); 'set xlab on'; endif
*'set mpdset mres'
*'set gxout grfill'
*
'set gxout shaded'
'set clevs  -0.9 -0.7 -0.5 -0.3 -0.1 0.1 0.3 0.5 0.7 0.9'
'set ccols  49 47 45 43 42 0 22 23 25 27 29'
'set t '%ieof 
if(iframe = 3 | iframe = 6);
'd reg';
else
'd -reg'
endif
'set gxout contour'
'set cint 0.2'
*'d -reg'
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -90 180 90'
 'set string 1 tl 4'
 'set strsiz 0.12 0.12'
*----------
if(iframe = 1); 'draw string 'titlx' 'titly' RPC1 11.5%'; endif
if(iframe = 2); 'draw string 'titlx' 'titly' RPC2 5.3%'; endif
if(iframe = 3); 'draw string 'titlx' 'titly' RPC3 3.5%'; endif
if(iframe = 4); 'draw string 'titlx' 'titly' RPC4 1.6%'; endif
if(iframe = 5); 'draw string 'titlx' 'titly' RPC5 1.6%'; endif
if(iframe = 6); 'draw string 'titlx' 'titly' RPC6 1.3%'; endif
*
*
if(iframe = 3); 'run /cpc/home/wd52pp/bin/cbarn.gs 0.75 0 'barx' 'bary''; endif

iframe=iframe+1
ieof=ieof+1
ipc=iframe-3

endwhile

'printim corr.amip30esm_z200rpc_2_sst.djf.79-22.png gif x1600 y1200'
