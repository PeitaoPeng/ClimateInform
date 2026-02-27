#!/bin/sh
set -xe

export GADDIR=/u/wx52cm/grads/dat
export GAUDFT=/u/wx52cm/grads/udf/udf.txt
export GASCRP=/u/wx52cm/grads/scripts

cat >regrid.gs<<gsEOF
* write to big endian 
'open LandMaskCONUSdeg0.5pnt.big.glb.ctl'
'set gxout fwrite'
'set fwrite LandMaskCONUSdeg2.5.big.glb'
'set lat -90 90'
'set lon  0 360'
'set gxout fwrite'
'd regrid2(land,2.5,2.5)'
gsEOF

cat >in.dat<< inEOF
reinit
run regrid.gs
quit
inEOF

/usrx/local/grads/bin/grads -pb <in.dat
rm regrid.gs in.dat udf.regrid.dat udf.regrid.out


cat >LandMaskCONUSdeg2.5.big.glb.ctl <<ctlEOF
dset ^LandMaskCONUSdeg2.5.big.glb
options big_endian
undef -9999.00
title CONUS land mask
xdef 144 linear 0.000000 2.500000
ydef 73 linear -90.000000 2.5
zdef 1 levels 1
tdef 1 linear jan1979 1mo
vars 1
land     1  00 land=1.0
ENDVARS
ctlEOF
