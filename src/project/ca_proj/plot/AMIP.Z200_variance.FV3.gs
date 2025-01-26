'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'

mtx=var
eof_range=tp

'open /cpc/home/wd52pp/data/ca_proj/FV3amip30runs.z200.djf.ensm_anom.79-22.ctl'
'open /cpc/home/wd52pp/data/ca_proj/FV3amip100runs.z200.djf.ensm_anom.ctl'

*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.12 0.12'
 'draw string 5.5 8.25 STDV of DJF Z200'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
*
nframe=2
nframe2=2

xmin0=3.5;  xlen=4.5;  xgap=0.1
ymax0=8.; ylen=-3.5; ygap= 0.2
*
'define v1=sqrt(ave(z200*z200,time=dec1979,time=dec2021))'
'define v2=sqrt(ave(z200.2*z200.2,time=dec1979,time=dec2021))'
*
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
* if(iframe >  5); ylen=-1.2; endif
* if(iframe >  4); xlen=3.5; endif
* if(iframe >  5); ygap=-0.2; endif
* if(iframe >  5); ymax0=10.25; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
* if(iframe = 7); ymax=ymax0+(icy-1)*(ylen+ygap)-0.1; endif
  ymin=ymax+ylen
* if(iframe = 6); titly=ymax+0.1; endif
* if(iframe = 7); titly=ymax+0.1; endif
  xstr=xmin+0.
  ystr=ymax-0.15
  if(iframe > 4);
  xstr=xmax + 0.25
  endif
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
if(iframe < 5);
*'set mproj scaled'
'set lat -90 90'
*'set vrange -45 90'
'set ylint 30'
'set lon 0 360'
'set xlint 60'
'set grid on'
*'set poli on'
*'set mpdset mres'
*'set gxout grfill'
'set xlab off'
'set ylab off'
if(iframe=2);'set xlab on';endif
if(iframe=4);'set xlab on';endif
if(iframe<=2);'set ylab on';endif
*
'set gxout shaded'
'set clevs 10 15 20 25 30 35 40 45 50 55 60 65 70'
'set ccols  0 21 22 23 24 25 26 27 28 29 73 75 77 79'
'd v'%ieof
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -90 180 90'
'set string 1 tl 5 0'
'set strsiz 0.13 0.13'
if(iframe = 1);'draw string 'xstr' 'ystr' a)FV3_30runs'; endif
if(iframe = 2);'draw string 'xstr' 'ystr' b)FV3_100runs'; endif
if(iframe = 3);'draw string 'xstr' 'ystr' c)CFS_30runs'; endif
if(iframe = 4);'draw string 'xstr' 'ystr' d)CFS_100runs'; endif
endif
*----------
'set string 1 tc 5 0'
if(iframe = 4);'run /cpc/home/wd52pp/bin/cbarn.gs 0.75 0 5.5 1.';endif
*

iframe=iframe+1
ieof=ieof+1
ipc=iframe-2

endwhile
*
'printim FV3_AMIP.Z200_variance.2m.png gif x800 y600'
