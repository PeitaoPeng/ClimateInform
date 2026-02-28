open /export-6/cacsrv1/wd52pp/modes/rsd_reof.z500.5001djfm.ntd.ctl
*===========================
set x 1
set y 1
set t 1
 d aave(regr*regr,lon=0,lon=360,lat=20,lat=90)
