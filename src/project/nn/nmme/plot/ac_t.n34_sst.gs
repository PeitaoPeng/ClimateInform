'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/nn/nmme/ac_t.mlp_bp.CV.grdsst_2_n34.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 4.25 10.3 AC(NINO34 vs SST) DJF 1983-2020'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=4
nframe3=4
xmin0=1.5;  xlen=5.5;  xgap=0.2
ymax0=10.; ylen=-2.2;  ygap=-0.05
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
  tlx=xmin
  tly=ymax-0.1
  bx=4.25
  by=ymin-0.4
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'define p1=oo'
'define p2=mm'
'define p3=om'
'define p4=cm'
'set t 1'
'set lon 120 285'
'set lat  -20 20'
'set yaxis -20 20 10'
*'set frame off'
'set grads off'
*'set grid off'
*'set xlab off'
*if(iframe = 3); 'set xlab on'; endif
*'set map 15 1 2'
'set gxout shaded'
'set clevs  -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9'
'set ccols   47 46 45 44 43 42 0 21 22 23 24 25 26 27 29'
'd p'%iframe
'run /cpc/home/wd52pp/bin/dline.gs 120 0 285 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -20 180 20'
'set string 1 tl 5 0'
'set strsiz 0.13 0.13'
if(iframe = 1); 'draw string 'tlx' 'tly' a) OBS vs OBS'; endif
if(iframe = 2); 'draw string 'tlx' 'tly' b) NMME vs NMME'; endif
if(iframe = 3); 'draw string 'tlx' 'tly' c) OBS vs NMME'; endif
if(iframe = 4); 'draw string 'tlx' 'tly' d) NN vs NMME'; endif
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.85 0 'bx' 'by''
'print'
'printim ac_t.n34_sst.png gif x600 y800'

