#!/bin/sh

set -eaux

lcdir=/cpc/save/wx52pp/project/ca_prd/pen_prd
tmpdir=/ptmp/wx52pp
datadir=/gpfs/d/cpc/noscrub/wx52pp/obs/olr_raw
outdata=/gpfs/d/cpc/noscrub/wx52pp/CA_pen

iskip=0
season=ass
nseason=27 #79-05
#
year_ic=2007
mon_ic=07
day_ic=12
#
for modemax in 10; do
mm_sk=10  #mode# kept for verification

cp $lcdir/mjo_idx_realtime_prd.ass.3v.f $tmpdir/mjo_prd.f
cp $lcdir/eof_4_ca.s.f $tmpdir/eof_4_ca.s.f
cd $tmpdir

#
cat > parm.h << eof
      parameter(imin=144,jmin=25)  !input dimension
      parameter(imax=144,jmax=25)  !out or work dimension
      parameter(lons=1,lone=144)    !domain for EOFs analysis (0-360)
      parameter(imp=lone-lons+1,jmp=1) ! jmp=1 means 15S-15N averaged
      parameter(modemax=$modemax)
      parameter(nseason=$nseason)
      parameter(mm_sk=$mm_sk)
      parameter(nps=73)
      parameter(icmon=$mon_ic,icday=$day_ic)
eof
#

xlf -qrealsize=4 -lessl -o ca.x mjo_prd.f eof_4_ca.s.f 
echo "done compiling"

/bin/rm $tmpdir/fort.*
#
 ln -s $datadir/noenso_u200_pentad.ibm.dat fort.11
 ln -s $datadir/noenso_u850_pentad.ibm.dat fort.12
 ln -s $datadir/noenso_olr_pentad.ibm.dat fort.13
#
ln -s $outdata//mjo_pc1.80-05$season.CA_prd.3v.i3e   fort.60
ln -s $outdata//mjo_pc2.80-05$season.CA_prd.3v.i3e   fort.61
#
ln -s $outdata/ceof.mjo.79-05${season}_4_skill.1D.i3e   fort.70
#
ca.x > $outdata/ca_mjo_pc12.79-05$season.1D.3v.out

cat>$outdata/ceof.mjo.79-05${season}_4_skill.1D.ctl<<EOF
dset ^ceof.mjo.79-05${season}_4_skill.1D.i3e
options yrev big_endian
undef -9.99E+33
title EXP1
xdef  144 linear   0 2.5
ydef   1  linear  -30 2.5
zdef     1 levels 500
tdef 999 linear     jan94     1mon
vars  3
u20   1 99 eof of velocity potential
u85   1 99 eof of velocity potential
olr   1 99 eof of velocity potential
endvars
EOF

#
cat>$outdata/mjo_pc1.80-05$season.CA_prd.3v.ctl<<EOF
dset ^mjo_pc1.80-05$season.CA_prd.3v.i3e
options big_endian
undef -9.99E+33
title EXP1
xdef  1 linear  0  1.
ydef  1 linear 1 1
zdef  1 linear  0 1
tdef 9999 linear 03jan1980   1dy
vars  7
obs   1 99 observed
ca    1 99 from CA
p5    1 99 5-day prd
p10   1 99 10-day prd
p15   1 99 15-day prd
p20   1 99 20-day prd
p25   1 99 25-day prd
endvars
EOF
#
#
cat>$outdata/mjo_pc2.80-05$season.CA_prd.3v.ctl<<EOF
dset ^mjo_pc2.80-05$season.CA_prd.3v.i3e
options big_endian
undef -9.99E+33
title EXP1
xdef  1 linear  0  1.
ydef  1 linear 1 1
zdef  1 linear  0 1
tdef 9999 linear 03jan1980   1dy
vars  7
obs   1 99 observed
ca    1 99 from CA
p5    1 99 5-day prd
p10   1 99 10-day prd
p15   1 99 15-day prd
p20   1 99 20-day prd
p25   1 99 25-day prd
endvars
EOF
#
done
