'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/attr/sst14-15/corr.nino34.vs.sz.1949-cur.djf.ctl'
'open /cpc/home/wd52pp/data/attr/sst14-15/psi_hgt.200mb.R1.feb1949-cur.3mon.ctl'
'open /cpc/home/wd52pp/data/attr/sst14-15/corr.nino34.vs.prate.1979-cur.djf.ctl'
'open /cpc/home/wd52pp/data/attr/sst14-15/prate.1979-cur.cmap.3mon.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
*'draw string 5.5 7.8 PSI200 2013-2015'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
nframe3=2
xmin0=1.25;  xlen=6.;  xgap=0.5
ymax0=10; ylen=-3.0;  ygap=-0.
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
  tlx=xmin+0.
  tly=ymax-0.1
  lx1=xmin+0.5
  ly1=ymax-0.2
  ly2=ymax-0.4
  bx=xmax+0.3
  by=ymin+3
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
*'set frame off'
'set grads off'
*'set grid off'
*'set map 15 1 2'
'set lon 0 360'
'set lat  -30 90'
'set yaxis -30 90 15'
if(iframe = 1)
'set gxout shaded'
'set clevs   -4 -3 -2 -1 -0.5 0.5 1 2 3 4'
'set ccols   79 77 75 73 72 0 32 33 35 37 39'
'd p.4(time=jan2015)'
'set gxout contour'
'set cint 2'
'd 0.000001*s.2(time=jan2015)'
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -30 180 90'
*'run /cpc/home/wd52pp/bin/cbarn2.gs 0.75 0 'bx' 'by''
endif
if(iframe = 2)
'set gxout shaded'
'set clevs   -4 -3 -2 -1 -0.5 0.5 1 2 3 4'
'set ccols   79 77 75 73 72 0 32 33 35 37 39'
'd preg.3(t=1)'
'set gxout contour'
'set cint 2'
'd 0.000001*sreg(t=1)'
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -30 180 90'
endif
'set string 1 tl 5 0'
'set strsiz 0.12 0.12'
if(iframe = 1); 'draw string 'tlx' 'tly'  a) OBS'; endif
if(iframe = 2); 'draw string 'tlx' 'tly'  b) Nino3.4 regressed'; endif
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.75 1 'bx' 'by''
'print'
'printim fig1.2.png gif x1200 y1600'

