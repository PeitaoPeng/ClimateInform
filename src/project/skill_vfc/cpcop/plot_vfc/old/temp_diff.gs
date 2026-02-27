'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /cpc/home/wd52pp/data/prd_skill/temp_obs.jfm31-dec11.2x2.ctl'
'open /cpc/home/wd52pp/data/CFSv2_vfc/0data/temp.jfm82-djf09.cfsv2.esm_anom.us.ctl'
'open /cpc/home/wd52pp/data/CFS_vfc/0data/temp.fma1981-jfm2005.cfs.esm_anom.us.ctl'
'open /cpc/home/wd52pp/data/CFS_vfc/0data/temp.jfm1995-jfm2011.cfs.esm_anom.us.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print meta.fig18'
*
*---------------------------string/caption
*'define t1s=ave(t,t=614,t=672)'
*'define t1e=ave(t,t=889,t=948)'
*'define t2s=ave(t.2,t=614,t=672)'
*'define t2e=ave(t.2,t=889,t=948)'
*'define t3s=ave(t.3,t=614,t=672)'
*'define t3e=ave(t.4,t=889,t=948)'
*
 'define t1s=ave(t,t=614,t=732)'
 'define t1e=ave(t,t=829,t=948)'
 'define t2s=ave(t.2,t=614,t=732)'
 'define t2e=ave(t.2,t=829,t=948)'
 'define t3s=ave(t.3,t=614,t=732)'
 'define t3e=ave(t.4,t=829,t=948)'
'define temp1=t1e-t1s'
'define temp3=t2e-t2s'
'define temp2=t3e-t3s'
*
'set string 1 tc 4'
'set strsiz 0.18 0.18'
*'draw string 4.25 10.5 Temp Diff (05-09 minus 82-86)'
'draw string 4.25 10.5 Temp Diff (00-09 minus 82-91)'
*---------------------------set dimsnesion, page size and style
nframe=3
nframe2=3
xmin0=1.5;  xlen=5.5;  xgap=0.5
ymax0=9.75; ylen=-2.5;  ygap=-0.75
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+2.75
  titly=ymax+0.225
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
*'set lat 20 56'
*'set lon 230 300'
*'set frame off'
'set grads off'
'set grid off'
*'set map 15 1 2'
*'set gxout shaded'
'set gxout grfill'
'set mpdset mres'
'set clevs   -0.2 0 0.2 0.4 0.6 0.8 1.0'
'set ccols   42 41 21 22 23 24 25 26'
*'set xlab off'
*'set ylab off'
'set xlabs 130W | 120W | 110W | 100W | 90W | 80W | 70W | 60W'
*'set yaxis -80 80 20'
'd temp'%iframe
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout contour'
*'set csmooth on'
*'set cint 0.5'
*'set ccolor 1'
* if(iframe = 6); 'set xlab on'; endif
* if(iframe = 12); 'set xlab on'; endif
*'set clopts -1 3 0.05'
*'set cthick 4'
*'d hds'%iframe
 'set string 1 tc 4'
 'set strsiz 0.16 0.16'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly' OBS'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' CFSv1'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' CFSv2'; endif
*
  iframe=iframe+1
'run /cpc/home/wd52pp/bin/cbarn2.gs 1 1 7. 5.25'
endwhile
'print'
*'printim avg_temp.gocn.map.paper.png gif x600 y800'
'printim Fig18.png gif x600 y800'
*'c'
* 'set vpage off'
*----------
