#!/bin/sh

set -eaux

#
#var=Prec
 var=T2m
#
 datadir=/export-12/cacsrv1/wd52pp/CFSv2_vfc/0data
 lcdir=/export/hobbes/wd52pp/project/CFSv2_skill/data_proc
 tmp=/export/hobbes/wd52pp/tmp
#
 cp tercile_boundary.f $tmp/tercile_boundary.f
 cd $tmp
\rm -f fort.*
#
cat > parm.h << eof
       parameter(imx=180,jmx=91)
       parameter(nyr=28,mmx=20) !mmx=ind #
       parameter(ltime=336,nesm=5) !nyrx12=336, nesm=ensemble #
eof
#
f77 -o tercile_boundary.x tercile_boundary.f
#
#
   ln -s $datadir/${var}_hcst.jfm1982-djf2009.esm.2x2.gr      fort.10
   ln -s $datadir/${var}_hcst.jfm1982-djf2009.ind.2x2.gr      fort.11
#
   ln -s $datadir/${var}.3mon-clim.1982-2009.gr               fort.20
   ln -s $datadir/${var}_hcst.jfm1982-djf2009.ind.anom.gr     fort.21
   ln -s $datadir/${var}_hcst.jfm1995-djf2009.ind.anom.gr     fort.22
   ln -s $datadir/${var}.tercile_bnd.gr                       fort.23
#
#
 tercile_boundary.x > $lcdir/out
#
cat>$datadir/${var}.3mon-clim.1982-2009.ctl<<EOF2
dset ^${var}.3mon-clim.1982-2009.gr
undef -99999.00
options little_endian
*
xdef 180 linear   0.0 2.0
*
ydef  91 linear -90.0 2.0
*
ZDEF 1 LEVELS 1
*
TDEF 999 LINEAR jan1982 1mo
*
*
VARS 5
e1  1   99   esm of f1-f4
e2  1   99   esm of f5-f8
e3  1   99   esm of f9-12
e4  1   99   esm of f13-16
e5  1   99   esm of f17-20
ENDVARS
EOF2
#
cat>$datadir/${var}_hcst.jfm1982-djf2009.ind.anom.ctl<<EOF3
dset ^${var}_hcst.jfm1982-djf2009.ind.anom.gr
undef -99999.00
options little_endian
*
xdef 180 linear   0.0 2.0
*
ydef  91 linear -90.0 2.0
*
ZDEF 1 LEVELS 1
*
TDEF 999 LINEAR jan1982 1mo
*
VARS 20
f1  1   99   w.r.t. e1 clim
f2  1   99   same  
f3  1   99   same
f4  1   99   same
f5  1   99   w.r.t. e2 clim
f6  1   99   same
f7  1   99   same
f8  1   99   same
f9  1   99   w.r.t. e3 clim
f10 1   99   same
f11 1   99   same
f12 1   99   same
f13 1   99   w.r.t. e4 clim
f14 1   99   same
f15 1   99   same
f16 1   99   same
f17 1   99   w.r.t. e5 clim
f18 1   99   same
f19 1   99   same
f20 1   99   same
ENDVARS
EOF3
#
cat>$datadir/${var}_hcst.jfm1995-djf2009.ind.anom.ctl<<EOF4
dset ^${var}_hcst.jfm1995-djf2009.ind.anom.gr
undef -99999.00
options little_endian
*
xdef 180 linear   0.0 2.0
*
ydef  91 linear -90.0 2.0
*
ZDEF 1 LEVELS 1
*
TDEF 999 LINEAR jan1995 1mo
*
VARS 20
f1  1   99   w.r.t. e1 clim
f2  1   99   same  
f3  1   99   same
f4  1   99   same
f5  1   99   w.r.t. e2 clim
f6  1   99   same
f7  1   99   same
f8  1   99   same
f9  1   99   w.r.t. e3 clim
f10 1   99   same
f11 1   99   same
f12 1   99   same
f13 1   99   w.r.t. e4 clim
f14 1   99   same
f15 1   99   same
f16 1   99   same
f17 1   99   w.r.t. e5 clim
f18 1   99   same
f19 1   99   same
f20 1   99   same
ENDVARS
EOF4
#
cat>$datadir/${var}.tercile_bnd.ctl<<EOF5
dset ^${var}.tercile_bnd.gr
undef -99999.00
options little_endian
*
*
xdef 180 linear   0.0 2.0
*
ydef  91 linear -90.0 2.0
*
ZDEF 1 LEVELS 1
*
TDEF 999 LINEAR jan1982 1mo
*
VARS 2
a  1   99   upper border of normal
b  1   99   lower border of normal
ENDVARS
EOF5
