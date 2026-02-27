'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/prd_test/gocn.ocn.vs.cd_ss_t.rms.2x2.ctl'
*
*'enable print meta.rms.ltp_vs_time'
*
*---------------------------string/caption
'set string 1 tc 5'
'set strsiz 0.18 0.18'
'draw string 4.45 10.25 OCN(years)'
*---------------------------set dimsnesion, page size and style
nframe=8
nframe2=4
nframe3=8
nframe4=8
xmin0=1.;  xlen=3.5;  xgap=0.1
ymax0=9.65; ylen=-2; ygap=-0.
'set t 1'
'define m12=ave(k,t=12,t=264,1yr)'
'define m3=ave(k,t=3,t=264,1yr)'
'define m6=ave(k,t=6,t=264,1yr)'
'define m9=ave(k,t=9,t=264,1yr)'
'define sd12=sqrt(ave((k-m12)*(k-m12),t=12,t=264,1yr))'
'define sd3=sqrt(ave((k-m3)*(k-m3),t=3,t=264,1yr))'
'define sd6=sqrt(ave((k-m6)*(k-m6),t=6,t=264,1yr))'
'define sd9=sqrt(ave((k-m9)*(k-m9),t=9,t=264,1yr))'
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  if (iframe > nframe3); icx=3; endif
  if (iframe > nframe4); icx=4; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  if (iframe > nframe3); icy=iframe-nframe3; endif
  if (iframe > nframe4); icy=iframe-nframe4; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  tlx=xmin-0.35
  tly=ymin+1
  tlx2=xmin+1.75
  tly2=ymax+0.2
  tlx3=xmin+1.75
  tly3=ymin-0.35
*
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
'set xlab off'
'set ylab off'
'set lat 24 50'
'set x 3 33'
'set gxout shaded'
'set clevs  5 10 15 20 25'
'set ccols  0 41 43 45 47 49' 
if(iframe > 4)
*'set clevs  2 4 6 8'
'set clevs  10 20 30 40'
'set ccols  0 22 24 26 28' 
endif
if(iframe = 1); 'd m12'; endif;
if(iframe = 2); 'd m3'; endif;
if(iframe = 3); 'd m6'; endif;
if(iframe = 4); 'd m9'; endif;
if(iframe = 5); 'd 100*sd12/m12'; endif;
if(iframe = 6); 'd 100*sd3/m3'; endif;
if(iframe = 7); 'd 100*sd6/m6'; endif;
if(iframe = 8); 'd 100*sd9/m9'; endif;
'set string 1 tc 5 90'
if(iframe = 1); 'draw string 'tlx' 'tly' DJF'; endif;
if(iframe = 2); 'draw string 'tlx' 'tly' MAM'; endif;
if(iframe = 3); 'draw string 'tlx' 'tly' JJA'; endif;
if(iframe = 4); 'draw string 'tlx' 'tly' SON'; endif;
'set string 1 tc 5 0'
if(iframe = 1); 'draw string 'tlx2' 'tly2' MEAN'; endif;
if(iframe = 5); 'draw string 'tlx2' 'tly2' STDV/MEAN(%)'; endif;
if(iframe = 4);'run /cpc/home/wd52pp/bin/cbarn2.gs 0.6 0 'tlx3' 'tly3''; endif
if(iframe = 8);'run /cpc/home/wd52pp/bin/cbarn2.gs 0.6 0 'tlx3' 'tly3''; endif
iframe=iframe+1
'set strsiz 0.18 0.18'
endwhile
'print'
'printim k.mean_stdv.png gif x600 y800'
*'set vpage off'
