'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/non-EC_hss.vs.non-EC_season.cpc.temp.ctl'
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/non-EC_hss.vs.non-EC_season.cpc.prec.ctl'
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/nec.with.nino34.95-cur.cpc.ctl'
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/hss.with.nino34.95-cur.cpc.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print meta.fig12'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.14 0.14'
 'draw string 5.5 8.1 Fraction of non-EC forecast vs the corresponding HSS'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=2
xmin0=1.;  xlen=4.;  xgap=1.
ymax0=7.5; ylen=-2.75;  ygap=-1.
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+2.
  titly=ymax+0.2
  stx1=xmin+2.
  sty1=ymin-0.3
  stx2=xmin-0.55
  sty2=ymax-1.375
  stx3=xmin+3.25
  sty3=ymin+0.25
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
 'set string 1 tc 4 90'
 'set strsiz 0.12 0.12'
if(iframe = 1)
'set grads off'
'set gxout scatter'
'set ccolor 1'
'set cmark 5'
'set vrange 0 100'
'set vrange2 -50 100'
'set t 1 232'
'd nec;hs2'
'draw string 'stx2' 'sty2' non-EC HSS' 
endif
*
if(iframe = 2)
'set grads off'
'set gxout scatter'
'set ccolor 1'
'set cmark 5'
'set vrange 0 100'
'set vrange2 -50 100'
'set t 1 232'
'd nec.2;hs2.2'
'draw string 'stx2' 'sty2' non-EC HSS' 
endif
*
if(iframe = 3)
'set t 1'
'set grads off'
'set gxout scatter'
'set t 1 181'
'set vrange 0 100'
'set vrange2 -50 100'
'set t 1 181'
'set ccolor 2'
'set cmark 5'
'd tw.3;tw.4'
'set ccolor 1'
'set cmark 5'
'd tn.3;tn.4'
'set ccolor 4'
'set cmark 5'
'd tc.3;tc.4'
'draw string 'stx2' 'sty2' non-EC HSS' 
endif
*
if(iframe = 4)
'set t 1'
'set grads off'
'set gxout scatter'
'set t 1 181'
'set vrange 0 100'
'set vrange2 -50 100'
'set t 1 181'
'set ccolor 2'
'set cmark 5'
'd pw.3;pw.4'
'set ccolor 1'
'set cmark 5'
'd pn.3;pn.4'
'set ccolor 4'
'set cmark 5'
'd pc.3;pc.4'
'draw string 'stx2' 'sty2' non-EC HSS' 
endif
*
 'set string 1 tc 4 0'
 'set strsiz 0.12 0.12'
if(iframe = 1); 'draw string 'titlx' 'titly' Temp forecast'; endif
if(iframe = 1); 'draw string 'stx1' 'sty1' fraction(%) of non-EC forecast in time'; endif
if(iframe = 1); 'draw string 'stx3' 'sty3' cor=0.6'; endif
if(iframe = 2); 'draw string 'titlx' 'titly' Prec forecast'; endif
if(iframe = 2); 'draw string 'stx1' 'sty1' fraction(%) of non-EC forecast in time'; endif
if(iframe = 2); 'draw string 'stx3' 'sty3' cor=0.45'; endif
if(iframe = 3); 'draw string 'titlx' 'titly' Temp forecast'; endif
if(iframe = 3); 'draw string 'stx1' 'sty1' fraction(%) of non-EC forecast in grid'; endif
if(iframe = 3); 'draw string 'stx3' 'sty3' cor=-0.03'; endif
if(iframe = 4); 'draw string 'titlx' 'titly' Prec forecast'; endif
if(iframe = 4); 'draw string 'stx1' 'sty1' fraction(%) of non-EC forecast in grid'; endif
if(iframe = 4); 'draw string 'stx3' 'sty3' cor=-0.12'; endif
  iframe=iframe+1
endwhile
'print'
'printim Fig12.png gif x800 y600'
*'c'
 'set vpage off'
*----------
