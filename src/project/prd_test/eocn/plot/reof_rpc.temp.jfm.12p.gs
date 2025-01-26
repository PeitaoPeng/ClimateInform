'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print reof_rpc.temp.jfm.mega'
*
*---------------------------string/caption
*
'set string 1 tc 4'
'set strsiz 0.13 0.13'
*'draw string 4.2 10.75 REOF and RPC of Temp Variability'
*---------------------------set dimsnesion, page size and style
nframe=12
nframe2=6
xmin0=0.25;  xlen=3.5;  xgap=0.75
ymax1=10.75; ylen1=-1.5;  ygap1=-0.3
ylen2=-1.25; ymax2=10.62; ygap2=-0.532
*
iframe=1
while ( iframe <= nframe )

if(iframe < 7); ylen=ylen1; ymax0=ymax1; ygap=ygap1; endif
if(iframe > 6); ylen=ylen2; ymax0=ymax2; ygap=ygap2; endif

  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  ymin2=ymax+ylen
  titlx=xmin+1.75
  titly1=ymax+0.15
  titly2=ymax+0.17
if(iframe < 7);
'open /cpc/home/wd52pp/data/prd_skill/reof.temp_102_anom_1931-2011.jfm.2x2.ctl'
endif
if(iframe > 6);
'open /cpc/home/wd52pp/data/prd_skill/rpc.temp_102_anom_1931-2011.jfm.ctl'
endif
*
*'set vpage 'xmin' 'xmax' 'ymin' 'ymax''
'set vpage  0 8.5 0 11'
'set parea 'xmin' 'xmax' 'ymin' 'ymax''
*
if(iframe < 7);
'set x 3 33'
'set y 3 16'
'define cor1=cor(t=1)'
'define cor2=cor(t=2)'
'define cor3=cor(t=3)'
'define cor4=cor(t=4)'
'define cor5=-cor(t=5)'
'define cor6=cor(t=6)'
'set grads off'
*'set grid off'
'set xlab off'
'set ylab off'
'set mpdset mres'
'set gxout shaded'
'set clevs  -0.9 -0.7 -0.5 -0.3 -0.1 0.1 0.3 0.5 0.7 0.9'
'set ccols 49 47 45 43 41 0 21 23 25 27 29'
'd cor'%iframe
'set string 1 tc 4'
'set strsiz 0.13 0.13'
'close 1'
endif
*----------
if(iframe=3);
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.8 1 3.75 5.55'
endif
'set string 1 tc 4'
'set strsiz 0.12 0.12'
 if(iframe = 1); 'draw string 'titlx' 'titly1' REOF1 40%'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly1' REOF2 25%'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly1' REOF3 18%'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly1' REOF4  4%'; endif
 if(iframe = 5); 'draw string 'titlx' 'titly1' REOF5  2%'; endif
 if(iframe = 6); 'draw string 'titlx' 'titly1' REOF6  2%'; endif
if(iframe > 6) ;
'set xaxis 1931 2011 10'
'set t 1 81'
*'set xlab off'
*if(iframe = 3); 'set xlab on'; endif
'set grads off'
'set yaxis -2.5 2.5 1'
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 1'
'set xlab on'
'set ylab on'
if(iframe = 7); 'd pc1'; endif
if(iframe = 8); 'd pc2'; endif
if(iframe = 9); 'd pc3'; endif
if(iframe = 10); 'd pc4'; endif
if(iframe = 11); 'd -pc5'; endif
if(iframe = 12); 'd pc6'; endif
'set t 4 78'
'define pc1m=ave(pc1,t-3,t+3)'
'define pc2m=ave(pc2,t-3,t+3)'
'define pc3m=ave(pc3,t-3,t+3)'
'define pc4m=ave(pc4,t-3,t+3)'
'define pc5m=ave(pc5,t-3,t+3)'
'define pc6m=ave(pc6,t-3,t+3)'
'set t 1 81'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 3'
if(iframe = 7); 'd pc1m'; endif
if(iframe = 8); 'd pc2m'; endif
if(iframe = 9); 'd pc3m'; endif
if(iframe = 10); 'd pc4m'; endif
if(iframe = 11); 'd -pc5m'; endif
if(iframe = 12); 'd pc6m'; endif
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
'define zero=0.0'
'd zero'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 7); 'draw string 'titlx' 'titly2'  RPC1'; endif
 if(iframe = 8); 'draw string 'titlx' 'titly2'  RPC2'; endif
 if(iframe = 9); 'draw string 'titlx' 'titly2'  RPC3'; endif
 if(iframe = 10); 'draw string 'titlx' 'titly2'  RPC4'; endif
 if(iframe = 11); 'draw string 'titlx' 'titly2'  RPC5'; endif
 if(iframe = 12); 'draw string 'titlx' 'titly2'  RPC6'; endif
'close 1'
'set string 1 tc 4'
'set strsiz 0.12 0.12'
endif
*
iframe=iframe+1
endwhile
'print'
'printim reof_rpc.temp.jfm.png gif x600 y800'
* 'c'  
* 'set vpage off'
*----------
