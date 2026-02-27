* hss map
'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print roc.prec.comp.6p.2.mega'
*
*---------------------------string/caption
'set string 1 tc 6 0'
'set strsiz 0.15 0.15'
'draw string 4.6 10.7 ROC Score of Seasonal Prec Forecast'
'set string 1 tc 6 90'
'draw string 1. 8.65 CFSv1'
'draw string 1. 5.75 CFSv2'
'draw string 1. 2.85 CPC'
'set string 1 tc 6 0'
*---------------------------set dimsnesion, page size and style
nframe=6
nframe2=3
nframe3=6
xmin0=1.0;  xlen=3.2;  xgap=-0.0
ymax0=10.0; ylen=-3.0;  ygap=0.1
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
'/cpc/home/wd52pp/project/CFS_skill/plot/xyplot_roc.gs /cpc/home/wd52pp/project/CFS_skill/plot/roc_a_prec.95-cur.txt'
endif
if(iframe=4);
'/cpc/home/wd52pp/project/CFS_skill/plot/xyplot_roc.gs /cpc/home/wd52pp/project/CFS_skill/plot/roc_b_prec.95-cur.txt'
endif
if(iframe=2);
'/cpc/home/wd52pp/project/CFS_skill/plot/xyplot_roc.gs /cpc/home/wd52pp/project/CFSv2_skill/plot/roc_a_prec.95-cur.txt'
endif
if(iframe=5);
'/cpc/home/wd52pp/project/CFS_skill/plot/xyplot_roc.gs /cpc/home/wd52pp/project/CFSv2_skill/plot/roc_b_prec.95-cur.txt'
endif
if(iframe=3);
'/cpc/home/wd52pp/project/CFS_skill/plot/xyplot_roc.cpc.gs /cpc/home/wd52pp/project/cpc_skill/plot_vfc/roc_a_prec.95-cur.cpc.txt'
endif
if(iframe=6);
'/cpc/home/wd52pp/project/CFS_skill/plot/xyplot_roc.cpc.gs /cpc/home/wd52pp/project/cpc_skill/plot_vfc/roc_b_prec.95-cur.cpc.txt'
endif
 'close 1'
  iframe=iframe+1
'set vpage off'
endwhile
'set string 1 tl 6 0'
'set strsiz 0.15 0.15'
'draw string 2.2 10.2 Upper Tercile'
'draw string 5.5 10.2 Lower Tercile'
 'set string 1 tc 5 0'
*'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 0 5.5 3.1'
'print'
'printim roc.prec.comp.6p.2.png gif x600 y800'
*'c'
 'set vpage off'
*----------
