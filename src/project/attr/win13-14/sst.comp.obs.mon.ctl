dset ^sst.comp.obs.mon.gr
undef -999
*
options little_endian
*
XDEF 180 LINEAR   0.  2.0
*
YDEF  89 LINEAR -88.  2.0
*
ZDEF  1 LINEAR 1 1.
*
tdef 999 linear jan1949 1yr
*
ZDEF 1 LEVELS 1
*
VARS 3
cp 1 99 comp on positive cor
cn 1 99 comp on negative cor
obs 1 99 sst of 2013/14 winter
ENDVARS
