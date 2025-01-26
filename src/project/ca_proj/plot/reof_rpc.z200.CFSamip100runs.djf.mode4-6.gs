'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'

'open /cpc/home/wd52pp/data/ca_proj/reof.CFSamip100runs.z200.djf.ensm_anom.ctl'
'open /cpc/home/wd52pp/data/ca_proj/rpc.CFSamip100runs.z200.djf.ensm_anom.ctl'

*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
 'draw string 5.5 8.5 REOF&RPC of Z200 (CFS_AMIP100_esm,1981-2021)'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
*
nframe=6
nframe2=3

xmin0=0.75;  xlen=4.25;  xgap=0.5
ymax0=8.0; ylen=-2.35;  ygap=-0.1
*
iframe=1
ieof=4
ipc=4
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
  titlx=xmin+1.5
  titly=ymax-0.2
* if(iframe = 6); titly=ymax+0.2; endif
* if(iframe = 7); titly=ymax+0.1; endif
  barx=xmin+2.1
  bary=ymin-0.45
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
if(iframe < 4);
'set lat -89.5 89.5'
'set ylint 30'
'set lon 0 360'
'set xlint 60'
'set grads off'
'set grid on'
'set poli on'
'set xlab off'
if(iframe = 3); 'set xlab on'; endif
*'set mpdset mres'
*'set gxout grfill'
*
'set gxout shaded'
'set clevs -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 0.2 0.3 0.4 0.5 0.6 0.7 0.8'
'set ccols  49 48 47 46 45 43 42 0 22 23 25 26 27 28 29';
'set t '%ieof 
'd eof'
'set gxout contour'
'set cint 5'
'd reg'
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -90 180 90'
endif
if(iframe > 3);
'set xlab off'
if(iframe = 6); 'set xlab on'; endif
'set gxout bar'
'set barbase 0'
'set vrange -3.5 3.5'
'set ylint 0.5'
'set y 1'
'set x 1'
'set grid on'
'set grads off'
'set xaxis 1981 2022 5'
'set bargap 30'
'set e '%ipc
'set t 0 41'
'set ccolor 29'
'd maskout(cf.2,cf.2)'
'set ccolor 49'
'd maskout(cf.2, -cf.2)'
endif
 'set string 1 tl 4'
 'set strsiz 0.12 0.12'
*----------
if(iframe = 4); 'draw string 'titlx' 'titly' RPC4 7.2%'; endif
if(iframe = 5); 'draw string 'titlx' 'titly' RPC5 1.8%'; endif
if(iframe = 6); 'draw string 'titlx' 'titly' RPC6 1.7%'; endif
*
*
if(iframe = 3); 'run /cpc/home/wd52pp/bin/cbarn.gs 0.5 0 'barx' 'bary''; endif

iframe=iframe+1
ieof=ieof+1
ipc=iframe

endwhile

'printim reof_rpc.z200.CFSamip100runs.djf.m4-6.png gif x1600 y1200'
