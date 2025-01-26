      SUBROUTINE GETFRC(nfrc,F,N,K)
      include "comphc"
      DIMENSION F(N,5)                
      COMMON/FRCSCL/scales(5)
c
      dzdt = twomg**2
      ddidt = twomg**2
      dsigdt= twomg
      dtdt = twomg**3 * er**2 / gasr
      zscl = twomg**2 * er**2 / grav
      scales(1) = dzdt
      scales(2) = ddidt
      scales(3) = dtdt
      scales(4) = zscl
      scales(5) = dsigdt
c  
c  nondimensionalize input forcing assuming geopotential forcing in
c   topographic height
c
      read(nfrc) f
      do 10 kfld=1,5
      do 10 i=1,n
      f(i,kfld) = f(i,kfld)/scales(kfld)
  10  continue 
c
      RETURN
      END
