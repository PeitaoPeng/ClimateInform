#!/bin/sh

set -eaux

# have uv10m from ERA

tmp=/cpc/home/wd52pp/tmp
datadir=/cpc/home/wd52pp/data/attr/sst14-15
cd $tmp
#\rm *gs
#
tmax=450

cat >int<<fEOF
run temp.gs
fEOF

cat >temp.gs<<EOF
    'reinit'
    'set display color white'
    'c'
* open ctl file
'open /cpc/cfsr/reanalyses/era-interim/monthly_pgb/erai.2_5.ctl'
    'set x 1 144'
    'set y 1  73'
    'set z 1'
    'set gxout fwrite'
    'set fwrite /cpc/home/wd52pp/data/attr/sst14-15/uv.1000mb.ERA.jan1979-cur.mon.gr'
* have 1981-2010 clim
    'set t 1 12'
    'define uc=ave(UGRDprs,t+24,t=384,1yr)'
    'modify uc seasonal'
*
    'set t 1 12'
    'define vc=ave(VGRDprs,t+24,t=384,1yr)'
    'modify vc seasonal'
*
    'set t 1'

    nt=1
    while(nt<=$tmax)
    'set t 'nt''
*
    'd UGRDprs-uc'
    'd VGRDprs-vc'
*
    nt=nt+1
    endwhile
EOF
 
grads -pb <int

cat>$datadir/uv.1000mb.ERA.jan1979-cur.mon.ctl<<EOF
dset ^uv.1000mb.ERA.jan1979-cur.mon.gr
undef -9999.
ydef 73 linear -90.000000 2.5
xdef 144 linear 0.000000 2.500000
tdef 999 linear 00Z01jan1979 1mo
zdef 1 levels 1
vars 2
u  0 99 u at 1000mb
v  0 99 v at 1000mb
ENDVARS
EOF
