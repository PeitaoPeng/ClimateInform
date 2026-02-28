#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/ca_prd/pent_prd/src
tmpdir=/cpc/home/wd52pp/tmp
datadir=/cpc/home/wd52pp/data/ca_prd
outdata=/cpc/home/wd52pp/data/ca_prd

iskip=0
nps=36   #pent number: NDJFMA=36; MJJASO=37
season=winter
nseason=34
npp=`expr $nps - 5`
#
for modemax in 10; do
mm_sk=10  #mode# kept for verification

cp $lcdir/olr_prd.skill.2D.ass.f $tmpdir/olr_prd.skill.f
cp $lcdir/eof_4_ca.s.f $tmpdir/eof_4_ca.s.f
cd $tmpdir

#
cat > parm.h << eof
      parameter(imin=72,jmin=37)  !input dimension
      parameter(imax=72,jmax=13)  !out or work dimension
      parameter(lons=1,lone=72)    !domain for EOFs analysis (0-360)
      parameter(imp=lone-lons+1,jmp=jmax) !30S-30N
      parameter(modemax=$modemax)
      parameter(nseason=$nseason)
      parameter(mm_sk=$mm_sk)
      parameter(nps=$nps)
eof
#

gfortran -o ca.x olr_prd.skill.f eof_4_ca.s.f
echo "done compiling"

/bin/rm $tmpdir/fort.*
#
ln -s $datadir/pent.olra.1979-curr.gr fort.11
#ln -s $datadir/pent.olra.1979-curr.gr fort.12
#
ln -s $outdata/olr_pent.$season.cnst.i3e  fort.60
ln -s $outdata/olr_pent.$season.prd1.i3e  fort.61
ln -s $outdata/olr_pent.$season.prd2.i3e  fort.62
ln -s $outdata/olr_pent.$season.prd3.i3e  fort.63
ln -s $outdata/olr_pent.$season.prd4.i3e  fort.64
ln -s $outdata/olr_pent.$season.prd5.i3e  fort.65
#ln -s $outdata/olr_pent.$season.prd6.i3e  fort.66
ln -s $outdata/eof.olr_pent.${season}_4_skill.i3e   fort.70
ln -s $outdata/alpha.olr_pent.$season.mm$modemax.i3e fort.75
ln -s $outdata/ac_1d_ca_olr_pent.$season.mm$modemax.i3e fort.76
ln -s $outdata/ac_2d_ca_olr_pent.$season.mm$modemax.msk$mm_sk.i3e fort.80
ca.x > $lcdir/ca_olr_pent.$season.out

cat>$outdata/eof.olr_pent.${season}_4_skill.ctl<<EOF
dset ^eof.olr_pent.${season}_4_skill.i3e
options yrev
undef -9.99E+33
title EXP1
xdef  72 linear    0.  5.
ydef  13 linear  -30.  5.
zdef     1 levels 500
tdef 999 linear     jan94     1mon
vars  1
eof   1 99 pent olr
endvars
EOF

cat>$outdata/ac_1d_ca_olr_pent.$season.mm$modemax.ctl<<EOF
dset ^ac_1d_ca_olr_pent.$season.mm$modemax.i3e
options big_endian
undef -9.99E+33
title EXP1
xdef  $npp linear  0  1.
ydef  1 linear 1 1
zdef  6 linear  0 1
tdef 999 linear jan79     1yr
vars  4
ac1    6 99 against raw olr
ac2    6 99 against EOF resolved olr
rms1   6 99 against raw olr
rms2   6 99 against EOF resolved olr
endvars
EOF

cat>$outdata/ac_2d_ca_olr_pent.$season.mm$modemax.msk$mm_sk.ctl<<EOF
dset ^ac_2d_ca_olr_pent.$season.mm$modemax.msk$mm_sk.i3e
options big_endian
undef -9.99E+33
title EXP1
xdef  72 linear   0 5
ydef  13 linear  -30 5
zdef   1 levels 500
tdef 99 linear     jan94     1mon
vars  4
ac1    1 99 against raw olr
ac2    1 99 against EOF resolved olr
rms1   1 99 against raw olr
rms2   1 99 against EOF resolved olr
endvars
EOF


#
done
