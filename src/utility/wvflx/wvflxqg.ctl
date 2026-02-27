DSET    /data/pool/peng/pbhp1587qg.fonly     
UNDEF   -9.99E33
TITLE wave fluxes computed with u,v & T          
*
XDEF  48 LINEAR   0.0  7.5    
*
YDEF  40 GAUSR15   1           
*
ZDEF   7 LEVELS  1000 850 700 500 300 200 100
* 
TDEF   1 LINEAR  JAN1988 1MO
*
VARS  33
avu    7    99     avg U                      
avv    7    99     avg V                      
avt    7    99     avg PTT
arv    7    99     avg relative vorticity 
edu    7    99     last eddy u             
edv    7    99     last eddy v             
epv    7    99     last eddy ptv           
erv    7    99     last eddy rv            
xmm    7    99     M       
vt3    7    99     term3 of avg PTV       
ens    7    99     avg eddy enstrophy            
ptv    7    99     avg potential vorticity       
evx    7    99     x component of E              
evy    7    99     y component of E              
mrx    7    99     x component of MR             
mry    7    99     y component of MR             
mrz    7    99     z component of MR             
mtx    7    99     x component of MT             
mty    7    99     y component of MT             
mtz    7    99     z component of MT             
uq     7    99     avg eddy uq                   
vq     7    99     avg eddy vq                   
pvx    7    99     gradient of ptv in x dir      
pvy    7    99     gradient of ptv in y dir      
esx    7    99     gradient of ens in x dir      
esy    7    99     gradient of ens in y dir      
ggqx   7    99     gradient of grq in x dir      
ggqy   7    99     gradient of grq in y dir      
dmr    7    99     divergence of MR              
dmt    7    99     divergence of MT              
cmr    7    99     quantity compared with dmr    
cmt    7    99     quantity compared with dmt    
ugq    7    99     lhs-rhs of eq(3.6)                      
ENDVARS
