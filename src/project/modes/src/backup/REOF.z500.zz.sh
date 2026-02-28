#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/modes/src
tmp=/cpc/home/wd52pp/tmp
datadir=/cpc/consistency/telecon/gb
#
var=z500
start_yr=1949
end_yr=2000
#
totyr=`expr ${end_yr} - ${start_yr} + 2`
ntotm=`expr $totyr \* 12`
nyr=`expr $totyr - 2`
ltime=`expr $nyr \* 3`
nmode=10
eof_area=NH
mtx=1 # =1 for standardized data; =2 for raw data
#
undefdata=-9.99e+8
#
cp $lcdir/REOF.z500.zz.f $tmp/eof.f
cp $lcdir/IMSL.REOF.s.f $tmp/reof.s.f
cd $tmp
#
#
#for mon in Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec; do
#for mon in Jan Apr Jul Oct; do
for mon in Jul; do
/bin/rm $tmp/fort.*         
#
if [ $mon == Jan ]; then imon=13; imm=12; imp=14; fi
if [ $mon == Feb ]; then imon=14; imm=13; imp=15; fi
if [ $mon == Mar ]; then imon=15; imm=14; imp=16; fi
if [ $mon == Apr ]; then imon=16; imm=15; imp=17; fi
if [ $mon == May ]; then imon=17; imm=16; imp=18; fi
if [ $mon == Jun ]; then imon=18; imm=17; imp=19; fi
if [ $mon == Jul ]; then imon=19; imm=18; imp=20; fi
if [ $mon == Aug ]; then imon=20; imm=19; imp=21; fi
if [ $mon == Sep ]; then imon=21; imm=20; imp=22; fi
if [ $mon == Oct ]; then imon=22; imm=21; imp=23; fi
if [ $mon == Nov ]; then imon=23; imm=22; imp=24; fi
if [ $mon == Dec ]; then imon=24; imm=23; imp=25; fi
#
#infile=monthly_tele_indices_1949-2001.in
 infile=monthly_tele_indices_1949-2001.no_cos.in
#infile=monthly.500za_1949-2001.in
 outfile1=reof.${eof_area}.R1_$var.$mon.mtx$mtx.yre${end_yr}
 outfile2=rpc.${eof_area}.R1_$var.$mon.mtx$mtx.yre${end_yr}
#
cat > parm.h << eof
       parameter(mons=$imon,ny=$nyr)
       parameter(imm=$imm, imp=$imp)
       parameter(ntotm=$ntotm)
       parameter(imx=144,jmx=28)
       parameter(nmod=$nmode)
       parameter(is=1,ie=144,js=1,je=28)
       parameter(mtx=$mtx,id=0)
       parameter(undef=$undefdata)
eof
gfortran -o eof.x reof.s.f eof.f
echo "done compiling"

#
 ln -s $datadir/$infile         fort.10
#
 ln -s $datadir/$outfile1.gr    fort.51
 ln -s $datadir/$outfile2.gr    fort.52
#
#eof.x > $datadir/$outfile1.out
eof.x 
#
cat>$datadir/$outfile1.ctl<<EOF
dset $datadir/$outfile1.gr
undef $undefdata
title Realtime Surface Obs
xdef  144 linear 0 2.5
ydef   28 linear 20 2.5
*ydef   73 linear -90 2.5
zdef    1 levels 500
tdef 999 linear jan1950  1yr
vars   1
e   0 99 eof pattern
endvars
EOF

cat>$datadir/$outfile2.ctl<<EOF2
dset $datadir/$outfile2.gr
undef $undefdata
title Realtime Surface Obs
xdef   $ltime linear 0 1.
ydef    1 linear -90 2.5
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

'open $datadir/$outfile1.ctl'

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
'define p1=e(t=1)'
'define p2=e(t=2)'
'define p3=e(t=3)'
'define p4=e(t=4)'
'define p5=e(t=5)'
'define p6=e(t=6)'
'define p7=e(t=7)'
'define p8=e(t=8)'
'define p9=e(t=9)'
'define p10=e(t=10)'

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
*'set clevs  -16 -12 -8 -4 -2 2 4 8 12 16'
*'set ccols  49 47 45 44 42 0 22 24 25 27 29'
 'set clevs  -60 -45 -30 -15 15 30 45 60'
 'set ccols  48 46 44 42 0 22 24 26 28'
'd 100*p'%iframe
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
'printim $datadir/$outfile1.png gif x600 y800'
'c'
EOF
/usr/local/bin/grads -pb <have_plot
#
done # mon loop
#
#
