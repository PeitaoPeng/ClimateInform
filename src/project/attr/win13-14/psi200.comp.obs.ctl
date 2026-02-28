dset ^psi200.comp.obs.gr
undef -9.99e+08
*
options little_endian
*
ydef  73 linear -90. 2.5
xdef 144 linear   0. 2.5
tdef 999 linear jan1949 1yr
*
ZDEF 1 LEVELS 1
*
VARS 3
cp 1 99 comp on positive cor
cn 1 99 comp on negative cor
psi200 1 99 of 2013/14 winter
ENDVARS
