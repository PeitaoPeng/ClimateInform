#average the pressure sfc history data of GCM in NERSC     
# QSUB -eo -o log.gtwv87 -lM 10Mw -lT 20:00 -q medium
# QSUB -ln 8
cd /work2/u70260/batchdir1
set echo
set timestamp
ja ja.out
cp /work2/u70260/gtwv87.f gtwv87.f      
chmod g+r,o+r gtwv87.f
chmod g+w,o+w gtwv87.f
#
# get old (CTSS) files 
#
cfs get prhst1.dat:/000733/ppr40l18/config2/run3/s040188e041588
cfs get prhst2.dat:/000733/ppr40l18/config2/run3/s041688e043088
cfs get prhst3.dat:/000733/ppr40l18/config2/run3/s050188e051088
cfs get prhst4.dat:/000733/ppr40l18/config2/run3/s051188e052088
cfs get prhst5.dat:/000733/ppr40l18/config2/run3/s052188e053188
cfs get prhst6.dat:/000733/ppr40l18/config2/run3/s060188e061588
cfs get prhst7.dat:/000733/ppr40l18/config2/run3/s061688e063088
cfs get glats.o:/000733/unicos/object/glats.o
cfs get fft991.o:/000733/unicos/object/fftgcm.o
cfs get arrpck.o:/000733/unicos/object/arrpck.o
cp  /work2/u70260/genpnme.o genpnme.o
cp /work2/u70260/fft.o fft.o
#
# convert CTSS files to UNICOS files
#
unform prhst1.dat fort.61
unform prhst2.dat fort.62
unform prhst3.dat fort.63
unform prhst4.dat fort.64
unform prhst5.dat fort.65
unform prhst6.dat fort.66
unform prhst7.dat fort.67
ls -l *.dat
ls -l fort.* 
#
# ISSUE ASSIGNS
#
assign -F null -N ieee fort.40
#
# compile,load and excute the program
#
cft77 -ei -a static gtwv87.f
segldr -o gtwv87.x glats.o genpnme.o fft.o arrpck.o fft991.o gtwv87.o
gtwv87.x 
#
# ftp data to cola peng       
#
ftp -n -v << -- 
 open cola.umd.edu               
 user peng 4daves    
 binary
 put fort.40 /homes/cola/peng/ppt/gcm1/gtwv87.hp 
 quit
--
rm *.dat fort.*
rm gtwv87.x *.o *.f 
ja -cst ja.out
