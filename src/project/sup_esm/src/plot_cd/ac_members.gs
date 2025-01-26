'reinit'
'open grid.ctl'
'open maskus.ctl'
'open /export-12/cacsrv1/wd52pp/super_esm/skill_spd_t2m_jfm_1982-2006.ctl'
*
'enable print ac_members.gr'
*
'set display color white'
'clear'
'run /export/hobbes/wd52pp/bin/rgbset.gs'
*
'define fd1=oacres(grid.1(t=1),z.3(t=9))'
'define ff1=maskout(fd1,mask.2(t=1)-1)'
'define fd3=oacres(grid.1(t=1),z.3(t=11))'
'define ff3=maskout(fd3,mask.2(t=1)-1)'
'define fd2=oacres(grid.1(t=1),z.3(t=10))'
'define ff2=maskout(fd2,mask.2(t=1)-1)'
'define fd4=oacres(grid.1(t=1),z.3(t=8))'
'define ff4=maskout(fd4,mask.2(t=1)-1)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
 'draw string 5.5 8.2 AC skill of CPC tools for T2m (82-06 JFM)'
*---------------------------set dimsnesion, page size and style
nframe=3
nframe2=2
xmin0=0.5;  xlen=4.75;  xgap=0.75
ymax0=7.5; ylen=-2.75;  ygap=-0.5
*
*'set frame off'
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx1=xmin+2.2
  titlx2=xmin+2.2
  titlx3=xmin+2.3
  titlx4=xmin+2.3
  titly=ymax+0.1
  barx=xmin+2.25
  bary=ymax-2.9
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set lat 24 51'
'set ylint 5'
'set lon -129 -65'
'set xlint 10'
'set grads off'
'set grid off'
'set poli on'
'set mpdset mres'
'set map 1 1 1'
*
'set gxout shaded'
'set grads off'
'set clevs  0.2 0.4 0.6'
'set ccols  0 22 24 27';
'set csmooth on'
'd ff'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
if(iframe = 1); 'draw string 'titlx1' 'titly' CCA'; endif
if(iframe = 2); 'draw string 'titlx2' 'titly' CFS'; endif
if(iframe = 3); 'draw string 'titlx3' 'titly' SMLR'; endif
if(iframe = 4); 'draw string 'titlx4' 'titly' EW ensemble'; endif
*
  iframe=iframe+1
endwhile
'run /export/hobbes/wd52pp/bin/cbarn.gs 1. 0 5.5 0.75'
'printim ac_members.png gif x800 y600'
'print'
*'c'
 'set vpage off'
