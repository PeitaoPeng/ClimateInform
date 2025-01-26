* hss map
'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /cpc/home/wd52pp/data/CFS_vfc/skill/hss_temp_t.95-cur.cfs.ctl'
'open /cpc/home/wd52pp/data/CFSv2_vfc/skill/hss_temp_t.95-cur.cfsv2.ctl'
'open /cpc/home/wd52pp/data/cpc_vfc/skill/hss_temp_t.95-cur.cpc.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print hss.map.temp.9p.mega'
*
*---------------------------string/caption
*
'define sk1=hs1'
'define sk2=hs1s'
'define sk3=hs1w'
'define sk4=hs1.2'
'define sk5=hs1s.2'
'define sk6=hs1w.2'
'define sk7=hs1.3'
'define sk8=hs1s.3'
'define sk9=hs1w.3'

'set string 1 tc 6 0'
'set strsiz 0.18 0.18'
'draw string 5.5 7.8 HSS of Temp'
'draw string 2.7 7.3 CFSv1'
'draw string 5.5 7.3 CFSv2'
'draw string 8.2 7.3 CPC'
*---------------------------set dimsnesion, page size and style
nframe=9
nframe2=3
nframe3=6
xmin0=1.35;  xlen=2.75;  xgap=0.
ymax0=7.0; ylen=-1.71;  ygap=-0.
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
  xbar=xmin+1.375
  ybar=ymin-1.5
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
*'set frame off'
'set xlab off'
'set ylab off'
'set grads off'
'set grid off'
'set gxout grfill'
'set mpdset mres'
'set clevs   0 10 20 30 40 50 60'
'set ccols   0 22 23 24 25 26 27 29'
'd sk'%iframe
 'set string 1 tc 6 90'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly' All Seasons'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' Summer'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' Winter'; endif
*
  iframe=iframe+1
endwhile
 'set string 1 tc 5 0'
 'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 0 5.5 1.35'
'print'
'printim hss.map.temp.9p.png gif x800 y600'
*'c'
 'set vpage off'
*----------
