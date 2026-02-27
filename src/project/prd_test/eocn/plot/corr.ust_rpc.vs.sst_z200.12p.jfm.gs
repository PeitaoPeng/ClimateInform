'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print corr.ust_rpc.vs.sst_z200.jfm.mega'
*
*---------------------------string/caption
*
'set string 1 tc 4 0'
'set strsiz 0.12 0.12'
'draw string 4.25 10.8 Corr of RPCs of US Temp vs SST(left) and Z200(right) for JFM'
*---------------------------set dimsnesion, page size and style
nframe=12
nframe2=6
xmin0=1.;  xlen=3.75;  xgap=-0.2
ymax1=10.5; ylen1=-1.5;  ygap1= 0.00
ylen2=-1.25; ymax2=10.4; ygap2=-0.255
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
  tx=xmin-0.2
  ty=ymax-0.75
if(iframe < 7);
'open /cpc/home/wd52pp/data/prd_skill/corr.ust_rpc.vs.sst.1931-2011jfm.ctl'
endif
if(iframe > 6);
'open /cpc/home/wd52pp/data/prd_skill/corr.ust_rpc.vs.z200.49-11jfm.ctl'
endif
*
*'set vpage 'xmin' 'xmax' 'ymin' 'ymax''
'set vpage  0 8.5 0 11'
'set parea 'xmin' 'xmax' 'ymin' 'ymax''
*
if(iframe < 7);
'set lon 0 360'
'set lat -65 65'
'set yaxis -65 65 20'
'set xlab off'
'set ylab off'
endif
if(iframe > 6);
'set lon 0 360'
'set lat -60 90'
'set yaxis -60 90 20'
endif
'define cor1=cor(t=1)'
'define cor2=cor(t=2)'
'define cor3=cor(t=3)'
'define cor4=cor(t=4)'
'define cor5=-cor(t=5)'
'define cor6=cor(t=6)'
'define cor7=cor(t=1)'
'define cor8=cor(t=2)'
'define cor9=cor(t=3)'
'define cor10=cor(t=4)'
'define cor11=-cor(t=5)'
'define cor12=cor(t=6)'
'set grads off'
*'set grid off'
'set xlab off'
'set ylab off'
if(iframe = 6 | iframe = 12);
'set xlab on'
*'set ylab on'
endif
'set mpdset mres'
'set gxout shaded'
'set clevs  -0.5 -0.4 -0.3 -0.2 0.2 0.3 0.4 0.5'
'set ccols 48 46 44 42 0 22 24 26 28'
'd cor'%iframe
'set string 1 tc 4'
'set strsiz 0.13 0.13'
'close 1'
*----------
if(iframe=12);
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.8 0 4.4 1.'
endif
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
if(iframe < 7); 'run /cpc/home/wd52pp/bin/dline.gs 180 65 180 -65'; endif
if(iframe > 6); 'run /cpc/home/wd52pp/bin/dline.gs 180 90 180 -60'; endif
'set string 1 tc 4 90'
'set strsiz 0.12 0.12'
if(iframe < 7); 'draw string 'tx' 'ty' vs RPC'iframe''; endif
'set string 1 tc 4 0'
*
iframe=iframe+1
endwhile
'print'
'printim corr.ust_rpc.vs.sst_z200.jfm.png gif x600 y800'
* 'c'  
* 'set vpage off'
*----------
