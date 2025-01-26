#!/bin/sh

set -eaux

# have 0.5-month lead seasonal esm forecast from ${var}_hcst.jfm1982-djf2009.ind.ctl

#var=T2m
 var=Prec

#
datadir=/export-12/cacsrv1/wd52pp/CFSv2_vfc/0data
tmp=/export/hobbes/wd52pp/tmp
 
cd $tmp
#
cat >int<<fEOF
reinit
run temp.gs
fEOF

#  --------------------------------
cat >temp.gs<<EOF
    'reinit'
    'set display color white'
    'c'
* open ctl file
    'open $datadir/${var}_hcst.jfm1982-djf2009.ind.2x2.ctl'
    'set gxout fwrite'
    'set x 1 180'
    'set y 1 91'
* nt=1: jan1982, nt=336: djf2009
    nt=1
    while(nt<=336)
    'set t 'nt''
* z=2: 1-month lead, for the first month of the season
    'define em1=(f1+f2+f3+f4)/4.'
    'define em2=(f5+f6+f7+f8)/4.'
    'define em3=(f9+f10+f11+f12)/4.'
    'define em4=(f13+f14+f15+f16)/4.'
    'define em5=(f17+f18+f19+f20)/4.'
    'd em1'
    'd em2'
    'd em3'
    'd em4'
    'd em5'
    nt=nt+1
    endwhile
EOF

/usr/local/bin/grads -pb <int

mv grads.fwrite ${var}_hcst.jfm1982-djf2009.esm.2x2.gr

cat>$tmp/${var}_hcst.jfm1982-djf2009.esm.2x2.ctl<<EOF2
dset ^${var}_hcst.jfm1982-djf2009.esm.2x2.gr
undef -99999.00
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

mv ${var}_hcst.jfm1982-djf2009.esm.2x2.gr $datadir
mv ${var}_hcst.jfm1982-djf2009.esm.2x2.ctl $datadir
