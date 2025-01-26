* hss map
'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print roc.temp.comp.6p.mega'
*
*---------------------------string/caption
'set string 1 tc 6 0'
'set strsiz 0.13 0.13'
'draw string 5.5 7.7 ROC Score of Seasonal Temp Forecast'
'draw string 2.5 7.2 CFSv1'
'draw string 5.85 7.2 CFSv2'
'draw string 9.15 7.2 CPC'
*---------------------------set dimsnesion, page size and style
nframe=6
nframe2=2
nframe3=4
xmin0=0.5;  xlen=3.5;  xgap=-0.2
ymax0=7.0; ylen=-3.2;  ygap=-0.0
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  if (iframe > nframe3); icx=3; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  if (iframe > nframe3); icy=iframe-nframe3; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin-0.35
  titly=ymax-0.85
  lsx=xmin
  lsy=ymin
  lex=xmax
  ley=ymax
*
  'set vpage 'xmin' 'xmax' 'ymin' 'ymax''
*
'set strsiz 0.2 0.2'
if(iframe=1);
'/cpc/home/wd52pp/project/CFS_skill/plot/xyplot_roc.upper.temp.gs /cpc/home/wd52pp/project/CFS_skill/plot/roc_a_temp.95-cur.txt'
endif
if(iframe=2);
'/cpc/home/wd52pp/project/CFS_skill/plot/xyplot_roc.lower.temp.gs /cpc/home/wd52pp/project/CFS_skill/plot/roc_b_temp.95-cur.txt'
endif
if(iframe=3);
'/cpc/home/wd52pp/project/CFSv2_skill/plot/xyplot_roc.upper.temp.gs /cpc/home/wd52pp/project/CFSv2_skill/plot/roc_a_temp.95-cur.txt'
endif
if(iframe=4);
'/cpc/home/wd52pp/project/CFSv2_skill/plot/xyplot_roc.lower.temp.gs /cpc/home/wd52pp/project/CFSv2_skill/plot/roc_b_temp.95-cur.txt'
endif
if(iframe=5);
'/cpc/home/wd52pp/project/cpc_skill/plot_vfc/xyplot_roc.upper.temp.gs /cpc/home/wd52pp/project/cpc_skill/plot_vfc/roc_a_temp.95-cur.cpc.txt'
endif
if(iframe=6);
'/cpc/home/wd52pp/project/cpc_skill/plot_vfc/xyplot_roc.lower.temp.gs /cpc/home/wd52pp/project/cpc_skill/plot_vfc/roc_b_temp.95-cur.cpc.txt'
endif
 'close 1'
  iframe=iframe+1
'set vpage off'
endwhile
'set string 1 tl 6 90'
'set strsiz 0.15 0.15'
'draw string 0.6 4.75 Upper Tercile'
'draw string 0.6 1.65 Lower Tercile'
 'set string 1 tc 5 0'
*'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 0 5.5 3.1'
'print'
'printim roc.temp.comp.6p.png gif x800 y600'
*'c'
 'set vpage off'
*----------
