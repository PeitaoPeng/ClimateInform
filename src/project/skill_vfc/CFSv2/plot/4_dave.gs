* hss map
'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /cpc/home/wd52pp/data/CFS_vfc/skill/hss_prec_t.95-cur.cfs.ctl'
'open /cpc/home/wd52pp/data/CFSv2_vfc/skill/hss_prec_t.95-cur.cfsv2.ctl'
'open /cpc/home/wd52pp/data/cpc_vfc/skill/hss_prec_t.95-cur.cpc.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print hss.map.prec.9p.mega'
*
*---------------------------string/caption
*
'define sk1=hs1'
'define sk2=hs1s'
'define sk3=hs1w'
'define hss1=hs1w'
'define sk4=hs1.2'
'define sk5=hs1s.2'
'define sk6=hs1w.2'
'define hss2=hs1w.2'
'define sk7=hs1.3'
'define sk8=hs1s.3'
'define sk9=hs1w.3'

'set string 1 tc 5 0'
'set strsiz 0.18 0.18'
'draw string 5.5 7.5 HSS of Prec for Winter Season (1995-2009)'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=1
nframe3=2
xmin0=1.;  xlen=4.45;  xgap=0.1
ymax0=7.0; ylen=-3.;  ygap=-0.
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
  titlx=xmin+2
  titly=ymax+0.1
  xbar=xmin+1.375
  ybar=ymin-0.5
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
'd hss'%iframe
 'set string 1 tc 5 0'
 'set strsiz 0.15 0.15'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly' CFSv1'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' CFSv2'; endif
*
  iframe=iframe+1
endwhile
 'set string 1 tc 5 0'
 'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 0 5.5 3.75'
'print'
'printim hss.map.prec.2p.png gif x800 y600'
*'c'
 'set vpage off'
*----------
