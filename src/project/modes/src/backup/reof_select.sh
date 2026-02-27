#!/bin/sh

set -eaux

#=========================================================
# ANN down scaling for NMME forecasted USAPI T&P 
#=========================================================
lcdir=/cpc/home/wd52pp/project/modes/src
tmp=/cpc/home/wd52pp/tmp
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
cd $tmp

datadir=/cpc/consistency/telecon
end_yr=2000
outfile=reof.NH.z500.1950-${end_yr}.select
#
cat > parm.h << eof
       parameter(imx=144,jmx=28)
eof
undefdata=-9.99e+8
#
cat > select.f << EOF
      program select_reof
      include "parm.h"
      dimension f2d(imx,jmx),f2d2(imx,jmx)
C
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=12,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=13,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=14,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=15,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=16,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=17,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=18,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=19,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=20,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=21,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=22,form='unformatted',access='direct',recl=4*imx*jmx)
C
      open(unit=50,form='unformatted',access='direct',recl=4*imx*jmx)
c*************************************************
C
C mon from Jan to Apr
      iw=0
      do mon=1,4
      iu=10+mon
      do ir=1,10
      read(iu,rec=ir) f2d
      iw=iw+1
      write(50,rec=iw) f2d
      enddo
      enddo
C mon=May
      mon=5
      iu=10+mon
      do ir=1,13
      if(ir.ne.1.and.ir.ne.9.and.ir.ne.13) then
      read(iu,rec=ir) f2d
      iw=iw+1
      write(50,rec=iw) f2d
      endif
      enddo
C mon=Jun
      mon=6
      iu=10+mon
      do ir=1,13
      if(ir.ne.1.and.ir.ne.6.and.ir.ne.13) then
      read(iu,rec=ir) f2d
      iw=iw+1
      write(50,rec=iw) f2d
      endif
      enddo
C mon=Jul
      mon=7
      iu=10+mon
      do ir=1,13
      if(ir.ne.1.and.ir.ne.2.and.ir.ne.13) then
      read(iu,rec=ir) f2d
      iw=iw+1
      write(50,rec=iw) f2d
      endif
      enddo
C mon=Aug
      mon=8
      iu=10+mon
      do ir=1,11
      if(ir.ne.1) then
      read(iu,rec=ir) f2d
      iw=iw+1
      write(50,rec=iw) f2d
      endif
      enddo
C mon from Sep to Dec
      do mon=9,12
      iu=10+mon
      do ir=1,10
      read(iu,rec=ir) f2d
      iw=iw+1
      write(50,rec=iw) f2d
      enddo
      enddo

      stop
      end
EOF
#
\rm fort.*
gfortran -o select.x select.f
#
 ln -s $datadir/reof.NH.R1_z500.Jan.mtx1.nmod10.yre2000.gr fort.11
 ln -s $datadir/reof.NH.R1_z500.Feb.mtx1.nmod10.yre2000.gr fort.12
 ln -s $datadir/reof.NH.R1_z500.Mar.mtx1.nmod10.yre2000.gr fort.13
 ln -s $datadir/reof.NH.R1_z500.Apr.mtx1.nmod10.yre2000.gr fort.14
 ln -s $datadir/reof.NH.R1_z500.May.mtx1.nmod13.yre2000.gr fort.15
 ln -s $datadir/reof.NH.R1_z500.Jun.mtx1.nmod13.yre2000.gr fort.16
 ln -s $datadir/reof.NH.R1_z500.Jul.mtx1.nmod13.yre2000.gr fort.17
 ln -s $datadir/reof.NH.R1_z500.Aug.mtx1.nmod11.yre2000.gr fort.18
 ln -s $datadir/reof.NH.R1_z500.Sep.mtx1.nmod10.yre2000.gr fort.19
 ln -s $datadir/reof.NH.R1_z500.Oct.mtx1.nmod10.yre2000.gr fort.20
 ln -s $datadir/reof.NH.R1_z500.Nov.mtx1.nmod10.yre2000.gr fort.21
 ln -s $datadir/reof.NH.R1_z500.Dec.mtx1.nmod10.yre2000.gr fort.22
#
 ln -s $datadir/$outfile.gr fort.50
select.x
#
#
cat>$datadir/$outfile.ctl<<EOF
dset $datadir/$outfile.gr
undef $undefdata
title Realtime Surface Obs
xdef  144 linear 0 2.5
ydef   28 linear 20 2.5
zdef    1 levels 500
tdef 999 linear jan1950  1yr
vars   1
e   1 99 spatially normalized reof pattern
endvars
EOF
#
cat >have_plot<<EOF
run plot_may.gs
EOF
cat >plot_may.gs<<EOF
'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'

'open /cpc/consistency/telecon/$outfile.ctl'

*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.12 0.12'
 'draw string 4.25 10.95 REOF Pattern of May Z500 (1950-${end_yr})'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
nframe=10
nframe2=5

xmin0=1.;  xlen=3.;  xgap=0.2
ymax0=10.5; ylen=-2.0; ygap=-0.05
*
'set poli on'
'set mproj nps'
'set lat 20 90'
'set lon -270 90'
'set poli on'
*
'define p1=e(t=41)'
'define p2=e(t=42)'
'define p3=e(t=43)'
'define p4=e(t=44)'
'define p5=e(t=45)'
'define p6=e(t=46)'
'define p7=e(t=47)'
'define p8=e(t=48)'
'define p9=e(t=49)'
'define p10=e(t=50)'
*
'set t 1'
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  if(iframe >  5); ylen=-2.0; endif
  if(iframe >  4); xlen=3.; endif
  if(iframe >  5); ygap=-0.05; endif
  if(iframe >  5); ymax0=10.5; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
* if(iframe = 7); ymax=ymax0+(icy-1)*(ylen+ygap)-0.1; endif
  ymin=ymax+ylen
  xstr=xmin + 0.04
  ystr=ymax + 0.
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
'set frame off'
'set xlab off'
'set ylab off'
'set poli on'
*
'set gxout shaded'
 'set clevs  -3 -2.5 -2. -1.5 -1 -0.5 0.5 1 1.5 2 2.5 3'
 'set ccols  49 47 45 44 43 42 0 22 23 24 25 27 29'
'd p'%iframe
'set string 1 tl 5 0'
'set strsiz 0.11 0.11'
if(iframe = 1);'draw string 'xstr' 'ystr' a)REOF1'; endif
if(iframe = 2);'draw string 'xstr' 'ystr' b)REOF2'; endif
if(iframe = 3);'draw string 'xstr' 'ystr' c)REOF3'; endif
if(iframe = 4);'draw string 'xstr' 'ystr' d)REOF4'; endif
if(iframe = 5);'draw string 'xstr' 'ystr' e)REOF5'; endif
if(iframe = 6);'draw string 'xstr' 'ystr' f)REOF6'; endif
if(iframe = 7);'draw string 'xstr' 'ystr' g)REOF7'; endif
if(iframe = 8);'draw string 'xstr' 'ystr' h)REOF8'; endif
if(iframe = 6);'draw string 'xstr' 'ystr' f)REOF6'; endif
if(iframe = 7);'draw string 'xstr' 'ystr' g)REOF7'; endif
if(iframe = 8);'draw string 'xstr' 'ystr' h)REOF8'; endif
if(iframe = 9);'draw string 'xstr' 'ystr' i)REOF9'; endif
if(iframe = 10);'draw string 'xstr' 'ystr' j)REOF10'; endif
*endif
*----------
'set string 1 tl 5 0'
if(iframe = 10);'run /cpc/home/wd52pp/bin/cbarn.gs 0.9 1 7.5 5.25';endif
*

iframe=iframe+1

endwhile
'printim /cpc/home/wd52pp/project/modes/plot/$outfile.may.png gif x600 y800'
'c'
EOF
/usr/local/bin/grads -pb <have_plot
#
cat >have_plot<<EOF
run plot_Jun.gs
EOF
cat >plot_Jun.gs<<EOF
'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'

'open /cpc/consistency/telecon/$outfile.ctl'

*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.12 0.12'
 'draw string 4.25 10.95 REOF Pattern of Jun Z500 (1950-${end_yr})'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
nframe=10
nframe2=5

xmin0=1.;  xlen=3.;  xgap=0.2
ymax0=10.5; ylen=-2.0; ygap=-0.05
*
'set poli on'
'set mproj nps'
'set lat 20 90'
'set lon -270 90'
'set poli on'
*
'define p1=e(t=51)'
'define p2=e(t=52)'
'define p3=e(t=53)'
'define p4=e(t=54)'
'define p5=e(t=55)'
'define p6=e(t=56)'
'define p7=e(t=57)'
'define p8=e(t=58)'
'define p9=e(t=59)'
'define p10=e(t=60)'
*
'set t 1'
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  if(iframe >  5); ylen=-2.0; endif
  if(iframe >  4); xlen=3.; endif
  if(iframe >  5); ygap=-0.05; endif
  if(iframe >  5); ymax0=10.5; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
* if(iframe = 7); ymax=ymax0+(icy-1)*(ylen+ygap)-0.1; endif
  ymin=ymax+ylen
  xstr=xmin + 0.04
  ystr=ymax + 0.
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
'set frame off'
'set xlab off'
'set ylab off'
'set poli on'
*
'set gxout shaded'
 'set clevs  -3 -2.5 -2. -1.5 -1 -0.5 0.5 1 1.5 2 2.5 3'
 'set ccols  49 47 45 44 43 42 0 22 23 24 25 27 29'
'd p'%iframe
'set string 1 tl 5 0'
'set strsiz 0.11 0.11'
if(iframe = 1);'draw string 'xstr' 'ystr' a)REOF1'; endif
if(iframe = 2);'draw string 'xstr' 'ystr' b)REOF2'; endif
if(iframe = 3);'draw string 'xstr' 'ystr' c)REOF3'; endif
if(iframe = 4);'draw string 'xstr' 'ystr' d)REOF4'; endif
if(iframe = 5);'draw string 'xstr' 'ystr' e)REOF5'; endif
if(iframe = 6);'draw string 'xstr' 'ystr' f)REOF6'; endif
if(iframe = 7);'draw string 'xstr' 'ystr' g)REOF7'; endif
if(iframe = 8);'draw string 'xstr' 'ystr' h)REOF8'; endif
if(iframe = 6);'draw string 'xstr' 'ystr' f)REOF6'; endif
if(iframe = 7);'draw string 'xstr' 'ystr' g)REOF7'; endif
if(iframe = 8);'draw string 'xstr' 'ystr' h)REOF8'; endif
if(iframe = 9);'draw string 'xstr' 'ystr' i)REOF9'; endif
if(iframe = 10);'draw string 'xstr' 'ystr' j)REOF10'; endif
*endif
*----------
'set string 1 tl 5 0'
if(iframe = 10);'run /cpc/home/wd52pp/bin/cbarn.gs 0.9 1 7.5 5.25';endif
*

iframe=iframe+1

endwhile
'printim /cpc/home/wd52pp/project/modes/plot/$outfile.jun.png gif x600 y800'
'c'
EOF
/usr/local/bin/grads -pb <have_plot
#
cat >have_plot<<EOF
run plot_Jul.gs
EOF
cat >plot_Jul.gs<<EOF
'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'

'open /cpc/consistency/telecon/$outfile.ctl'

*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.12 0.12'
 'draw string 4.25 10.95 REOF Pattern of Jul Z500 (1950-${end_yr})'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
nframe=10
nframe2=5

xmin0=1.;  xlen=3.;  xgap=0.2
ymax0=10.5; ylen=-2.0; ygap=-0.05
*
'set poli on'
'set mproj nps'
'set lat 20 90'
'set lon -270 90'
'set poli on'
*
'define p1=e(t=61)'
'define p2=e(t=62)'
'define p3=e(t=63)'
'define p4=e(t=64)'
'define p5=e(t=65)'
'define p6=e(t=66)'
'define p7=e(t=67)'
'define p8=e(t=68)'
'define p9=e(t=69)'
'define p10=e(t=70)'
*
'set t 1'
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  if(iframe >  5); ylen=-2.0; endif
  if(iframe >  4); xlen=3.; endif
  if(iframe >  5); ygap=-0.05; endif
  if(iframe >  5); ymax0=10.5; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
* if(iframe = 7); ymax=ymax0+(icy-1)*(ylen+ygap)-0.1; endif
  ymin=ymax+ylen
  xstr=xmin + 0.04
  ystr=ymax + 0.
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
'set frame off'
'set xlab off'
'set ylab off'
'set poli on'
*
'set gxout shaded'
 'set clevs  -3 -2.5 -2. -1.5 -1 -0.5 0.5 1 1.5 2 2.5 3'
 'set ccols  49 47 45 44 43 42 0 22 23 24 25 27 29'
'd p'%iframe
'set string 1 tl 5 0'
'set strsiz 0.11 0.11'
if(iframe = 1);'draw string 'xstr' 'ystr' a)REOF1'; endif
if(iframe = 2);'draw string 'xstr' 'ystr' b)REOF2'; endif
if(iframe = 3);'draw string 'xstr' 'ystr' c)REOF3'; endif
if(iframe = 4);'draw string 'xstr' 'ystr' d)REOF4'; endif
if(iframe = 5);'draw string 'xstr' 'ystr' e)REOF5'; endif
if(iframe = 6);'draw string 'xstr' 'ystr' f)REOF6'; endif
if(iframe = 7);'draw string 'xstr' 'ystr' g)REOF7'; endif
if(iframe = 8);'draw string 'xstr' 'ystr' h)REOF8'; endif
if(iframe = 6);'draw string 'xstr' 'ystr' f)REOF6'; endif
if(iframe = 7);'draw string 'xstr' 'ystr' g)REOF7'; endif
if(iframe = 8);'draw string 'xstr' 'ystr' h)REOF8'; endif
if(iframe = 9);'draw string 'xstr' 'ystr' i)REOF9'; endif
if(iframe = 10);'draw string 'xstr' 'ystr' j)REOF10'; endif
*endif
*----------
'set string 1 tl 5 0'
if(iframe = 10);'run /cpc/home/wd52pp/bin/cbarn.gs 0.9 1 7.5 5.25';endif
*

iframe=iframe+1

endwhile
'printim /cpc/home/wd52pp/project/modes/plot/$outfile.jul.png gif x600 y800'
'c'
EOF
/usr/local/bin/grads -pb <have_plot
#
cat >have_plot<<EOF
run plot_Aug.gs
EOF
cat >plot_Aug.gs<<EOF
'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'

'open /cpc/consistency/telecon/$outfile.ctl'

*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.12 0.12'
 'draw string 4.25 10.95 REOF Pattern of Aug Z500 (1950-${end_yr})'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
nframe=10
nframe2=5

xmin0=1.;  xlen=3.;  xgap=0.2
ymax0=10.5; ylen=-2.0; ygap=-0.05
*
'set poli on'
'set mproj nps'
'set lat 20 90'
'set lon -270 90'
'set poli on'
*
'define p1=e(t=71)'
'define p2=e(t=72)'
'define p3=e(t=73)'
'define p4=e(t=74)'
'define p5=e(t=75)'
'define p6=e(t=76)'
'define p7=e(t=77)'
'define p8=e(t=78)'
'define p9=e(t=79)'
'define p10=e(t=80)'
*
'set t 1'
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  if(iframe >  5); ylen=-2.0; endif
  if(iframe >  4); xlen=3.; endif
  if(iframe >  5); ygap=-0.05; endif
  if(iframe >  5); ymax0=10.5; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
* if(iframe = 7); ymax=ymax0+(icy-1)*(ylen+ygap)-0.1; endif
  ymin=ymax+ylen
  xstr=xmin + 0.04
  ystr=ymax + 0.
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
'set frame off'
'set xlab off'
'set ylab off'
'set poli on'
*
'set gxout shaded'
 'set clevs  -3 -2.5 -2. -1.5 -1 -0.5 0.5 1 1.5 2 2.5 3'
 'set ccols  49 47 45 44 43 42 0 22 23 24 25 27 29'
'd p'%iframe
'set string 1 tl 5 0'
'set strsiz 0.11 0.11'
if(iframe = 1);'draw string 'xstr' 'ystr' a)REOF1'; endif
if(iframe = 2);'draw string 'xstr' 'ystr' b)REOF2'; endif
if(iframe = 3);'draw string 'xstr' 'ystr' c)REOF3'; endif
if(iframe = 4);'draw string 'xstr' 'ystr' d)REOF4'; endif
if(iframe = 5);'draw string 'xstr' 'ystr' e)REOF5'; endif
if(iframe = 6);'draw string 'xstr' 'ystr' f)REOF6'; endif
if(iframe = 7);'draw string 'xstr' 'ystr' g)REOF7'; endif
if(iframe = 8);'draw string 'xstr' 'ystr' h)REOF8'; endif
if(iframe = 6);'draw string 'xstr' 'ystr' f)REOF6'; endif
if(iframe = 7);'draw string 'xstr' 'ystr' g)REOF7'; endif
if(iframe = 8);'draw string 'xstr' 'ystr' h)REOF8'; endif
if(iframe = 9);'draw string 'xstr' 'ystr' i)REOF9'; endif
if(iframe = 10);'draw string 'xstr' 'ystr' j)REOF10'; endif
*endif
*----------
'set string 1 tl 5 0'
if(iframe = 10);'run /cpc/home/wd52pp/bin/cbarn.gs 0.9 1 7.5 5.25';endif
*

iframe=iframe+1

endwhile
'printim /cpc/home/wd52pp/project/modes/plot/$outfile.aug.png gif x600 y800'
'c'
EOF
/usr/local/bin/grads -pb <have_plot
