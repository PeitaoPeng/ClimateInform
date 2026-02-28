open /export-1/sgi57/ocean/wd52pp/echam/corr.z500_vs_tpsst.jfm.ctl
set x 1 128
set y 1 64
set t 11
set gxout fwrite
set fwrite /export/sgi57/wd52pp/data/ak_data/corr_stdv.echam.gr
d corr
d stdv
