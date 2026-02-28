#average the pressure sfc history data of GCM in NERSC     
# QSUB -eo -o log.gt8788mn -lM 10Mw -lT 20:00 -q medium
# QSUB -ln 8
cd /work1/u3197/batchdir1
set echo
set timestamp
ja ja.out
cp /work1/u3197/gt8788mn.f gt8788mn.f      
chmod g+r,o+r gt8788mn.f
chmod g+w,o+w gt8788mn.f
#
# get old (CTSS) files 
#
cfs get prhst1.dat:/000733/ppr40l18/config2/run3/s040187e041587
cfs get prhst2.dat:/000733/ppr40l18/config2/run3/s041687e043087
cfs get prhst3.dat:/000733/ppr40l18/config2/run3/s050187e051587
cfs get prhst4.dat:/000733/ppr40l18/config2/run3/s051687e053187
cfs get prhst5.dat:/000733/ppr40l18/config2/run3/s060187e061587
cfs get prhst6.dat:/000733/ppr40l18/config2/run3/s061687e063087
cfs get prhst7.dat:/000733/ppr40l18/config2/run3/s040188e041588
cfs get prhst8.dat:/000733/ppr40l18/config2/run3/s041688e043088
cfs get prhst9.dat:/000733/ppr40l18/config2/run3/s050188e051088
cfs get prhst10.dat:/000733/ppr40l18/config2/run3/s051188e052088
cfs get prhst11.dat:/000733/ppr40l18/config2/run3/s052188e053188
cfs get prhst12.dat:/000733/ppr40l18/config2/run3/s060188e061588
cfs get prhst13.dat:/000733/ppr40l18/config2/run3/s061688e063088
cfs get glats.o:/000733/unicos/object/glats.o
cfs get fft991.o:/000733/unicos/object/fftgcm.o
cp  /work1/u3197/genpnme.o genpnme.o
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
unform prhst8.dat fort.68
unform prhst9.dat fort.69
unform prhst10.dat fort.70
unform prhst11.dat fort.71
unform prhst12.dat fort.72
unform prhst13.dat fort.73
ls -l *.dat
ls -l fort.* 
#
# ISSUE ASSIGNS
#
assign -F null -N ieee fort.40
#
# compile,load and excute the program
#
cft77 -ei -a static gt8788mn.f
segldr -o gt8788mn.x glats.o genpnme.o fft991.o gt8788mn.o
gt8788mn.x 
#
# ftp data to cola peng       
#
ftp -n -v << -- 
 open cola.umd.edu               
 user peng 4daves    
 binary
 put fort.40 /homes/cola/peng/ppt/gcm1/mn8788    
 quit
--
rm *.dat fort.*
rm gt8788mn.x *.o *.f 
ja -cst ja.out
