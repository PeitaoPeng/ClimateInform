#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/modes/src
tmp=/cpc/home/wd52pp/tmp
datadir=/cpc/consistency/telecon
#
var=z500
start_yr=1950
end_yr=2000
#
totyr=`expr ${end_yr} - ${start_yr} + 1`
ntotm=`expr $totyr \* 12`
ltime=`expr $totyr \* 3`
clm_s=1 # =1 -> 1950; =42 -> 1991
nmode=10
eof_area=NH
#eof_area=TNH
mtx=1 # =1 for standardized data; =2 for raw data
#
undefdata=-9.99e+8
#
if [ ${eof_area} == NH ]; then js=45; fi
if [ ${eof_area} == TNH ]; then js=37; fi

cp $lcdir/SVD_REOF.z500.cpc.f $tmp/pure_eof.f
cp $lcdir/SVD_varimax_REOF.s.f $tmp/reof.s.f
cd $tmp
#
#
#for mon in Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec; do
#for mon in Jan Apr Jul Oct; do
for mon in Jun; do
/bin/rm $tmp/fort.*         
#
if [ $mon == Jan ]; then imon=1; imm=12; imp=2; fi
if [ $mon == Feb ]; then imon=2; imm=1; imp=3; fi
if [ $mon == Mar ]; then imon=3; imm=2; imp=4; fi
if [ $mon == Apr ]; then imon=4; imm=3; imp=5; fi
if [ $mon == May ]; then imon=5; imm=4; imp=6; fi
if [ $mon == Jun ]; then imon=6; imm=5; imp=7; fi
if [ $mon == Jul ]; then imon=7; imm=6; imp=8; fi
if [ $mon == Aug ]; then imon=8; imm=7; imp=9; fi
if [ $mon == Sep ]; then imon=9; imm=8; imp=10; fi
if [ $mon == Oct ]; then imon=10; imm=9; imp=11; fi
if [ $mon == Nov ]; then imon=11; imm=10; imp=12; fi
if [ $mon == Dec ]; then imon=12; imm=11; imp=1; fi
#
#infile=corefv3.z500.jan1950-dec2020.2.5x2.5
#outfile1=reof.${eof_area}.core_$var.$mon.mtx$mtx.yre${end_yr}
#outfile2=rpc.${eof_area}.core_$var.$mon.mtx$mtx.yre${end_yr}
#outfile3=clm_std.${eof_area}.core_$var.$mon.mtx$mtx.yre${end_yr}
#
 infile=R1.z500.jan1950-dec2020
 outfile1=reof.${eof_area}.R1_$var.$mon.mtx$mtx.yre${end_yr}
 outfile2=rpc.${eof_area}.R1_$var.$mon.mtx$mtx.yre${end_yr}
 outfile3=clm_std.${eof_area}.R1_$var.$mon.mtx$mtx.yre${end_yr}
#
cat > parm.h << eof
       parameter(mons=$imon,ny=$totyr)
       parameter(imm=$imm, imp=$imp)
       parameter(ntotm=$ntotm,clm_s=$clm_s)
       parameter(imx=144,jmx=73)
       parameter(nmod=$nmode)
       parameter(is=1,ie=144,js=$js,je=72)
       parameter(mtx=$mtx,id=0)
       parameter(undef=$undefdata)
eof
gfortran -o pure_eof.x reof.s.f pure_eof.f
echo "done compiling"

#
 ln -s $datadir/$infile.gr         fort.10
#
 ln -s $datadir/$outfile1.gr    fort.51
 ln -s $datadir/$outfile2.gr    fort.52
 ln -s $datadir/$outfile3.gr    fort.53
#
pure_eof.x > $datadir/$outfile1.out
#
cat>$datadir/$outfile1.ctl<<EOF
dset $datadir/$outfile1.gr
undef $undefdata
title Realtime Surface Obs
xdef  144 linear 0 2.5
ydef   29 linear 20 2.5
*ydef   73 linear -90 2.5
zdef    1 levels 500
tdef 999 linear jan1950  1yr
vars   20
eof1   0 99 corr of mode 1
reg1   0 99 regr of mode 1
eof2   0 99 corr of mode 2
reg2   0 99 regr of mode 2
eof3   0 99 corr of mode 3
reg3   0 99 regr of mode 3
eof4   0 99 corr of mode 4
reg4   0 99 regr of mode 4
eof5   0 99 corr of mode 5
reg5   0 99 regr of mode 5
eof6   0 99 corr of mode 6
reg6   0 99 regr of mode 6
eof7   0 99 corr of mode 7
reg7   0 99 regr of mode 7
eof8   0 99 corr of mode 8
reg8   0 99 regr of mode 8
eof9   0 99 corr of mode 9
reg9   0 99 regr of mode 9
eof10   0 99 corr of mode 10
reg10   0 99 regr of mode 10
endvars
EOF

cat>$datadir/$outfile2.ctl<<EOF2
dset $datadir/$outfile2.gr
undef $undefdata
title Realtime Surface Obs
xdef   $ltime linear 0 1.
ydef    1 linear -90 2.8125
zdef    1 levels 500
tdef 999 linear jan1991 1yr
vars   10
cf1   0 99 rpc of mode 1
cf2   0 99 rpc of mode 2
cf3   0 99 rpc
cf4   0 99 rpc
cf5   0 99 rpc
cf6   0 99 rpc
cf7   0 99 rpc
cf8   0 99 rpc
cf9   0 99 rpc
cf10   0 99 rpc
endvars
EOF2
#
cat>$datadir/$outfile3.ctl<<EOF
dset $datadir/$outfile3.gr
undef $undefdata
title Realtime Surface Obs
xdef  144 linear 0 2.5
ydef   73 linear -90 2.5
zdef    1 levels 500
tdef 999 linear jan1950  1yr
vars   2
clm   0 99 corr of mode 1
std   0 99 regr of mode 1
endvars
EOF
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
 'draw string 4.25 10.95 REOF Pattern of $mon Z500 (1950-${end_yr})'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
*
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
'define p1=eof1'
'define p2=eof2'
'define p3=eof3'
'define p4=eof4'
'define p5=eof5'
'define p6=eof6'
'define p7=eof7'
'define p8=eof8'
'define p9=eof9'
'define p10=eof10'

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
*'set clevs  -90 -80 -70 -60 -50 -40 -30 -20 -10 10 20 30 40 50 60 70 80 90'
*'set ccols  49 48 47 46 45 44 43 42 41 0 21 22 23 24 25 26 27 28 29'
 'set clevs  -16 -12 -8 -4 -2 2 4 8 12 16'
 'set ccols  49 47 45 44 42 0 22 24 25 27 29'
*'set clevs  -60 -45 -30 -15 15 30 45 60'
*'set ccols  48 46 44 42 0 22 24 26 28'
'd 300*p'%iframe
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
if(iframe = 9);'draw string 'xstr' 'ystr' i)REOF9'; endif
if(iframe = 10);'draw string 'xstr' 'ystr' j)REOF10'; endif
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
done # mon loop
#
#
