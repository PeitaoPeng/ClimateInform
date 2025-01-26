#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/modes/src
tmp=/cpc/home/wd52pp/tmp
datadir=/cpc/consistency/telecon
#
var=z500
start_yr=1950
end_yr=2021
#
totyr=`expr ${end_yr} - ${start_yr} + 1`
ntotm=`expr $totyr \* 12`
ltime=`expr $totyr \* 3`
clm_s=1 # =1 -> 1950; =51 -> 2020
nmode=10
eof_area=NH
mtx=1 # =1 for standardized data; =2 for raw data
mrsd=1 # =0 no rsd; =1 has rsd
#
undefdata=-9.99e+8
#
js=45;je=72;lats=20
if [ ${eof_area} == NH ]; then is=1;ie=144;lons=0; fi
if [ ${eof_area} == PNA ]; then is=49;ie=120;lons=120; fi
if [ ${eof_area} == NA ]; then is=115;ie=144;lons=285; fi
nj=`expr $je - $js + 1`
ni=`expr $ie - $is + 1`

cp $lcdir/reof.z500.na.f $tmp/pure_eof.f
cp $lcdir/reof.s.f  $tmp/reof.s.f
cd $tmp
#
#
#for mon in Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec; do
#for mon in Jan Apr Jul Oct; do
for mon in  Jul; do
/bin/rm $tmp/fort.*         
#
if [ $mon == Jan ]; then imon=1; imm=12; imp=2; fi
#if [ $mon == Jan ]; then imon=13; imm=12; imp=14; fi
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
if [ $mon == Dec ]; then imon=12; imm=11; imp=13; fi
#
 infile=R1.z500.jan1950-jun2022
 outfile1=reof.${eof_area}.R1_$var.$mon.mtx$mtx.yre${end_yr}.mrsd$mrsd
 outfile2=reof.${eof_area}.R1_$var.$mon.mtx$mtx.yre${end_yr}.mrsd$mrsd.glb
 outfile3=rpc.${eof_area}.R1_$var.$mon.mtx$mtx.yre${end_yr}.mrsd$mrsd
#
cat > parm.h << eof
       parameter(mons=$imon,ny=$totyr)
       parameter(imm=$imm, imp=$imp)
       parameter(ntotm=$ntotm,clm_s=$clm_s)
       parameter(imx=144,jmx=73)
       parameter(nmod=$nmode)
       parameter(is=$is,ie=$ie,js=$js,je=72)
       parameter(mtx=$mtx,id=0)
       parameter(undef=$undefdata)
       parameter(mrsd=$mrsd)
       parameter(imx2=60,jmx2=28)
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
#
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
