 open /export-1/sgi59/wd52pp/data/b9x/z500_int_smp_50_94jfm.run2.ctl
 open /export-1/sgi59/wd52pp/data/b9x/z500_int_smp_50_94jfm.run3.ctl
 open /export-1/sgi59/wd52pp/data/b9x/z500_int_smp_50_94jfm.run4.ctl
 open /export-1/sgi59/wd52pp/data/b9x/z500_int_smp_50_94jfm.run5.ctl
 open /export-1/sgi59/wd52pp/data/b9x/z500_int_smp_50_94jfm.run6.ctl
 open /export-1/sgi59/wd52pp/data/b9x/z500_int_smp_50_94jfm.run7.ctl
 open /export-1/sgi59/wd52pp/data/b9x/z500_int_smp_50_94jfm.run8.ctl
 open /export-1/sgi59/wd52pp/data/b9x/z500_int_smp_50_94jfm.run9.ctl
 open /export-1/sgi59/wd52pp/data/b9x/z500_int_smp_50_94jfm.run10.ctl
 open /export-1/sgi59/wd52pp/data/b9x/z500_int_smp_50_94jfm.run11.ctl
 open /export-1/sgi59/wd52pp/data/b9x/z500_int_smp_50_94jfm.run12.ctl
 open /export-1/sgi59/wd52pp/data/b9x/z500_int_smp_50_94jfm.run13.ctl
 open /export-1/sgi59/wd52pp/data/b9x/z500_esm_50_94jfm.ctl
 reset
 enable print  meta.stdv
*===========================
* tropical heating
*===========================
run /export/sgi57/wd52pp/bin/rgbset.gs
set csmooth on
set grid on
*----------
set lat -90 90
set lon 0 360
*********
define v1=ave(z*z,t=1,t=45)
define v2=ave(z.2*z.2,t=1,t=45)
define v3=ave(z.3*z.3,t=1,t=45)
define v4=ave(z.4*z.4,t=1,t=45)
define v5=ave(z.5*z.5,t=1,t=45)
define v6=ave(z.6*z.6,t=1,t=45)
define v7=ave(z.7*z.7,t=1,t=45)
define v8=ave(z.8*z.8,t=1,t=45)
define v9=ave(z.9*z.9,t=1,t=45)
define v10=ave(z.10*z.10,t=1,t=45)
define v11=ave(z.11*z.11,t=1,t=45)
define v12=ave(z.12*z.12,t=1,t=45)
define ve=ave(z.13*z.13,t=1,t=45)
define se=sqrt(ve)
define vt=(v1+v2+v3+v4+v5+v6+v7+v8+v9+v10+v11+v12)/12.
define st=sqrt(vt)
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.0 10.8 b9x Z(500mb) JFM 50-94 
set vpage 1 7 7 10.5
set grads off
set gxout shaded
*set clevs   30 60      
set ccols   0 33 38
d st
set gxout contour
*set cint 10
d st
draw title VT:total variance  
*----------
set vpage 1 7 4 7.5 
set grads off
set gxout shaded
*set clevs   30 60      
set ccols   0 33 38
d se
set gxout contour
*set cint 10
d se
draw title VE: Variance of ensemble avg  
*----------
set vpage 1 7 1 4.5 
set grads off
set gxout shaded
*set clevs   30 60      
set ccols   0 33 38
d ve/vt
set gxout contour
*set cint 10
d ve/vt
draw title VE/VT   
*----------
run cbarn.gs 1 0 4.3 
run /export-1/sgi59/wd52pp/bin/cbarn.gs
*print
c
*----------
reset
*----------
disable print
