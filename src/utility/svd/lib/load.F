      subroutine load(a,npt,iu,iuout)
#include "parm.h"
      real a(nmax,nmon,nyr)
      read(iu) npt,nummo,numyr
      
      nmaxpr=nmax
      write(*,1) iu,npt,nummo,numyr
    1 format('READ FIELD from UNIT',i3,' #pts= ',i4,
     * ' #mons=',i4,' #yrs=',i4)
      if(npt.gt.nmax.or.nummo.ne.nmon.or.numyr.ne.nyr) then
         print *,'ERROR!! Check parameter settings and retry.'
         print *,'nmax=',nmaxpr,' npt=',npt
         stop
      endif
      read(iu) (((a(n,im,iy),n=1,npt),im=1,nummo),iy=1,numyr)
      return
      end
