#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/modes/src
tmp=/cpc/home/wd52pp/tmp
datadir=/cpc/consistency/telecon
#
var=z500
start_yr=1950
end_yr=2020
#
totyr=`expr ${end_yr} - ${start_yr} + 1`
ntotm=`expr $totyr \* 12`
ltime=`expr $totyr \* 12`
clm_s=1 # =1 -> 1950; =51 -> 2020
nmode=13
eof_area=NH
mtx=1 # =1 for standardized data; =2 for raw data
#
undefdata=-9.99e+8
#
js=45;je=72;lats=20
is=1;ie=144;lons=0
nj=`expr $je - $js + 1`
ni=`expr $ie - $is + 1`

cp $lcdir/reof.z500.allmon.f $tmp/pure_eof.f
cp $lcdir/reof.s.f  $tmp/reof.s.f
cd $tmp
#
#
/bin/rm $tmp/fort.*         
#
 infile=R1.z500.jan1950-jun2022
 outfile1=reof.${eof_area}.R1_$var.allmon.mtx$mtx.yre${end_yr}.nmod$nmode
 outfile2=reof.${eof_area}.R1_$var.allmon.mtx$mtx.yre${end_yr}.nmod$nmode.glb
 outfile3=rpc.${eof_area}.R1_$var.allmon.mtx$mtx.yre${end_yr}.nmod$nmode
#
cat > parm.h << eof
       parameter(ny=$totyr)
       parameter(ntotm=$ntotm,clm_s=$clm_s)
       parameter(imx=144,jmx=73)
       parameter(nmod=$nmode)
       parameter(is=$is,ie=$ie,js=$js,je=$je)
       parameter(mtx=$mtx,id=0)
       parameter(undef=$undefdata)
eof
gfortran -o pure_eof.x reof.s.f pure_eof.f
echo "done compiling"

#
 ln -s $datadir/$infile.gr         fort.10
#
 ln -s $datadir/$outfile1.gr    fort.50
 ln -s $datadir/$outfile2.gr    fort.51
 ln -s $datadir/$outfile3.gr    fort.52
#
#pure_eof.x > $datadir/$outfile1.out
pure_eof.x 
#
cat>$datadir/$outfile1.ctl<<EOF
dset $datadir/$outfile1.gr
undef $undefdata
title Realtime Surface Obs
xdef  $ni linear $lons 2.5
ydef  $nj linear $lats 2.5
zdef    1 levels 500
tdef 999 linear jan1950  1yr
vars   1
e  0 99 reof pattern
endvars
EOF

cat>$datadir/$outfile2.ctl<<EOF
dset $datadir/$outfile2.gr
undef $undefdata
title Realtime Surface Obs
xdef  144 linear   0 2.5
ydef   73 linear -90 2.5
zdef    1 levels 500
tdef 999 linear jan1950  1yr
vars   2
e   0 99 reof pattern
re  0 99 reof pattern
endvars
EOF

cat>$datadir/$outfile3.ctl<<EOF2
dset $datadir/$outfile3.gr
undef $undefdata
title Realtime Surface Obs
xdef   $ltime linear 0 1.
ydef    1 linear -90 2.8125
zdef    1 levels 500
tdef 999 linear jan1950 1yr
vars   1
rpc   0 99 rpc
endvars
EOF2
#
#=======================================
# plot eofs
#=======================================
cat >have_plot<<EOF
run plot_reof.gs
EOF
#

cat >plot_reof.gs<<EOF
'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'

mtx=var
eof_range=tp

'open /cpc/consistency/telecon/$outfile1.ctl'

*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.12 0.12'
 'draw string 4.25 10.95 REOF Pattern of allmon Z500 (1950-${end_yr})'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
*
nframe=12
nframe2=6

xmin0=1.;  xlen=3.;  xgap=0.2
ymax0=10.75; ylen=-1.75; ygap=-0.05
*
'set poli on'
'set mproj nps'
'set lat 20 90'
'set lon -270 90'
'set poli on'
*
'define p1=e(t=2)'
'define p2=e(t=3)'
'define p3=e(t=4)'
'define p4=e(t=5)'
'define p5=e(t=6)'
'define p6=e(t=7)'
'define p7=e(t=8)'
'define p8=e(t=9)'
'define p9=e(t=10)'
'define p10=e(t=11)'
'define p11=e(t=12)'
'define p12=e(t=13)'
#
'set t 1'
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  if(iframe >  6); ylen=-1.75; endif
  if(iframe >  6); xlen=3.; endif
  if(iframe >  6); ygap=-0.05; endif
  if(iframe >  6); ymax0=10.75; endif
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
if(iframe = 1);'draw string 'xstr' 'ystr' a)REOF2'; endif
if(iframe = 2);'draw string 'xstr' 'ystr' b)REOF3'; endif
if(iframe = 3);'draw string 'xstr' 'ystr' c)REOF4'; endif
if(iframe = 4);'draw string 'xstr' 'ystr' d)REOF5'; endif
if(iframe = 5);'draw string 'xstr' 'ystr' e)REOF6'; endif
if(iframe = 6);'draw string 'xstr' 'ystr' f)REOF7'; endif
if(iframe = 7);'draw string 'xstr' 'ystr' g)REOF8'; endif
if(iframe = 8);'draw string 'xstr' 'ystr' h)REOF9'; endif
if(iframe = 9);'draw string 'xstr' 'ystr' i)REOF10'; endif
if(iframe = 10);'draw string 'xstr' 'ystr' j)REOF11'; endif
if(iframe = 11);'draw string 'xstr' 'ystr' k)REOF12'; endif
if(iframe = 12);'draw string 'xstr' 'ystr' l)REOF13'; endif
*endif
*----------
'set string 1 tl 5 0'
if(iframe = 10);'run /cpc/home/wd52pp/bin/cbarn.gs 0.9 1 7.5 5.25';endif
*

iframe=iframe+1

endwhile
'printim /cpc/home/wd52pp/project/modes/plot/$outfile1.png gif x600 y800'
'c'
EOF
/usr/local/bin/grads -pb <have_plot
#
