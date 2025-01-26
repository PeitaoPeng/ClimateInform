#!/bin/sh
set -eaux
#
# interpolate flx data to the grid of corresponding obs data
#
tmax=441  #441=sep2015

inpfile=uv.10m.cfsr.jan1979-cur.mon
outfile=uv.10m.cfsr.jan1979-cur.mon.2.5x2.5
outfile2=uv.10m.cfsr.jan1979-cur.3mon.2.5x2.5

tmpdir=/cpc/home/wd52pp/tmp
datadir=/cpc/home/wd52pp/data/attr/sst14-15

cd $tmpdir

cat >int<<fEOF
reinit
run regrid.gs
fEOF

cat >regrid.gs<<gsEOF
'reinit'
'open $datadir/$inpfile.ctl'
'open /cpc/home/wd52pp/data/CFSv2_bias/out2.2.5x2.5.ctl'
'set gxout fwrite'
'set fwrite $outfile.gr'
nt=1
while ( nt <= $tmax)

'set t 'nt
say 'time='nt
'set lon 0 357.5'
'set lat -90 90'
'd lterp(u,z.2(t=1))'
'd lterp(v,z.2(t=1))'

nt=nt+1
endwhile
gsEOF

grads -pb <int

cat>$datadir/$outfile.ctl<<EOF
dset ^$outfile.gr
undef -9.99E+8
*
options little_endian
*
ydef  73 linear -90.  2.5
xdef 144 linear   0.  2.5
tdef 1200 linear jan1979 1mo
*
ZDEF 1 LEVELS 1
*
VARS 2
u 1  99   u10m
v 1  99   v10m
ENDVARS
EOF

#=======================================
# have 3-mon avg anomalies
#=======================================
ts=2
te=`expr $tmax - 1`
#
cat >3mavg<<EOF
run have3mavg.gs
EOF
#
cat >have3mavg.gs<<EOF
'reinit'
'open $datadir/$outfile.ctl'
'set x 1 144'
'set y 1  73'
'set gxout fwrite'
'set fwrite $datadir/$outfile2.gr'
k=$ts
while ( k <= $te)
'set t 'k''
'd ave(u,t-1,t+1)'
'd ave(v,t-1,t+1)'
k=k+1
endwhile
'c'
EOF
#
grads -l <3mavg
#
cat>$datadir/$outfile2.ctl<<EOF
dset ^$datadir/$outfile2.gr
undef -9.99E+8
ydef  73 linear -90.  2.5
xdef 144 linear   0.  2.5
tdef 1200 linear feb1979 1mo
zdef 1 levels 1
vars 2
u  0 99 u10m
v  0 99 v10m
ENDVARS
EOF

mv $outfile.*  $datadir
mv $outfile2.* $datadir

