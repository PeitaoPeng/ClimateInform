#average the pressure sfc history data of GCM in NERSC     
# QSUB -eo -o log.gt8788vt -lM 10Mw -lT 60:00 -q medium
# QSUB -ln 8
cd /work1/u3197/batchdir1
set echo
set timestamp
ja ja.out
cp /work1/u3197/gt8788vt.f gt8788vt.f      
chmod g+r,o+r gt8788vt.f
chmod g+w,o+w gt8788vt.f
#
# get old (CTSS) files 
#
cfs get prhst1.dat:/000733/ppr40l18/config2/run3/s110188e111588
cfs get prhst2.dat:/000733/ppr40l18/config2/run3/s111688e113088
cfs get prhst3.dat:/000733/ppr40l18/config2/run3/s120188e121588
cfs get prhst4.dat:/000733/ppr40l18/config2/run3/s121688e123188
cfs get glats.o:/000733/unicos/object/glats.o
cfs get fft991.o:/000733/unicos/object/fftgcm.o
cp  /work1/u3197/genpnme.o genpnme.o
cp /work1/u3197/fft.o fft.o
#
# convert CTSS files to UNICOS files
#
unform prhst1.dat fort.61
unform prhst2.dat fort.62
unform prhst3.dat fort.63
unform prhst4.dat fort.64
mv ndmn87 fort.50
mv ndmn88 fort.51
ls -l *.dat
ls -l fort.* 
#
# ISSUE ASSIGNS
#
assign -F null -N ieee fort.40
#
# compile,load and excute the program
#
cft77 -ei -a static gt8788vt.f
segldr -o gt8788vt.x glats.o genpnme.o fft.o fft991.o gt8788vt.o
gt8788vt.x 
#
# ftp data to cola peng       
#
ftp -n -v << -- 
 open cola.umd.edu               
 user peng 4daves    
 binary
 put fort.40 /homes/cola/peng/ppt/gcm1/gt88vt.hp 
 quit
--
mv fort.50 ndmn87
mv fort.51 ndmn88
rm *.dat fort.*
rm gt8788vt.x *.o *.f 
ja -cst ja.out
