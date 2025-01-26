* clim of itcz prate
'reinit'
'run /export-6/sgi9/wd52pp/bin/white.gs'
*
'open /export-6/cacsrv1/wd52pp/LF_prd/reof.gpsst.5002jfm.wang_HP.ntd.ctl'
'open /export-6/cacsrv1/wd52pp/LF_prd/reof.gpsst.5002jfm.wang_LP.ntd.ctl'
'open /export-6/cacsrv1/wd52pp/LF_prd/corr.sst_jfm_5002.vs.trend.ctl'
'open /export-6/cacsrv1/wd52pp/LF_prd/var_sst_jfm5002.ctl'
'enable print  meta.clim'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
*
  'define v1=regr.3*regr.3'
  'define v2=rregr(t=1)*rregr(t=1)'
  'define v3=rregr.2(t=1)*rregr.2(t=1)'
  'define v4=rregr.2(t=2)*rregr.2(t=2)'
  'define vt=var.4'
  'define stdv1=100*v1/vt'
  'define stdv2=100*v2/vt'
  'define stdv3=100*v3/vt'
  'define stdv4=100*v4/vt'
  'define stdv5=100*(v1+v2+v3+v4)/vt'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
 'draw string 4.25 10.8 percentage of variance explained by indices'
 'draw string 4.25 10.5 JFM SST 50-02'
*'draw string 5.5 7.5 cmap prate clim (79-01) (mm/day)'
*---------------------------set dimsnesion, page size and style
nframe=5
nframe2=5
xmin0=2.0;  xlen=4.5;  xgap=0.5
ymax0=10.0; ylen=-1.3;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+0.90
  titly=ymax+0.20
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set mproj nps'
'set lat -30 70'
'set lon 0 360'
'set yaxis -30 70 20'
*if(iframe > 8); 'set lat 0 80'; endif
*if(iframe > 8); 'set yaxis 0 80 20'; endif
'set gxout shaded'
*'set frame off'
'set grads off'
*'set grid off'
*'set map 15 1 2'
*'set gxout shaded'
'set clevs 10 20 30 40 50 60 70 80 90'
'set ccols 0 21 22 23 24 25 26 27 28 29'
*'set ccols 47 45 43 41 21 23 25 27 29'
*'set xlab off'
*'set ylab off'
'd stdv'%iframe
'set gxout contour'
'set csmooth on'
*'set cint 0.5'
*'set ccolor 1'
* if(iframe = 6); 'set xlab on'; endif
* if(iframe = 12); 'set xlab on'; endif
*if(iframe > 8); 'set clevs -1 -0.8 -0.6 -0.4 -0.2 0.2 0.4 0.6 0.8 1'; endif
'set clopts -1 3 0.05'
'set cthick 4'
* 'd stdv'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly' linear trend'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' RPC1 of HP'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' RPC1 of LP'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly' RPC2 of LP'; endif
 if(iframe = 5); 'draw string 'titlx' 'titly' SUM'; endif
*
  iframe=iframe+1
'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.7 0 4.25 1.0'
endwhile
'print'
*'c'
 'set vpage off'
*----------
