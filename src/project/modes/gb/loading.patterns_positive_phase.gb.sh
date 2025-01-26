#!/bin/sh
#==========================================================
# have positive loading paterns
#=========================================

set -eaux

lcdir=/cpc/home/wd52pp/project/modes/gb
tmp=/cpc/home/wd52pp/tmp
datadir=/cpc/consistency/telecon/gb
datadir2=/cpc/prod/cwlinks/indices_RH6/data
#
endyr=2000
undefdata=-9.99e+8
#
cd $tmp
\rm fort.*
#
cp $lcdir/loading.patterns_positive_phase.gb.f pat.f
f77 -o pat.x pat.f
echo "done compiling"
#
ln -s $datadir2/500z.loading.patterns                 fort.10
ln -s $datadir/reof.positive_phase.z500.1950-$endyr.gb.gr  fort.11
#
pat.x
#
cat>reof.positive_phase.z500.1950-$endyr.gb.ctl<<EOF
dset ^reof.positive_phase.z500.1950-$endyr.gb.gr
undef -9.99E+8
options little_endian
title REOF(500za) for each season (50-2000)
*These are the 500z covariance based loading patterns from the Varimax code
*These patterns are used by the operational FORTRAN code to compute the teleconnection indices
* Grids show the positive phase for each pattern.
*
xdef 144 linear  0.0  2.5
ydef  28 linear 20.0  2.5
zdef  1 levels  500
tdef  12 linear  jan1950   1mo
vars   10
nao    1   99   North Atlantic Oscillation
ea     1   99   East Atlantic Pattern
wp     1   99   West Pacific Oscillation
epnp   1   99   East Pacific/ North Pacific Pattern
pna    1   99   Pacific/ North America Pattern
eawr   1   99   East Atlantic/ Western Russia Pattern
scand  1   99   Scandinavia Pattern
tnh    1   99   Tropical/ Northern Hemisphere Pattern
poleur 1   99   Polar/ Eurasian  Pattern
pt     1   99   Pacific transition pattern
endvars
EOF
#
mv reof.positive_phase.z500.1950-$endyr.gb.ctl $datadir
