dset ^hrcn_oisst.apr.pat.gr
undef -999000000
*
TITLE pls cor pattern
*
xdef  360 linear 0 1.
ydef  180 linear -89.5 1.
zdef   1 linear 1 1
tdef  5 linear jan1979 1mo
vars 2
r1  1 99 reg from residuals
r2  1 99 reg from stadardized original data
ENDVARS
