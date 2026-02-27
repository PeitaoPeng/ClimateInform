      program RWT
      include "parm.h"
C===========================================================)
c
      real hs1(nss),hs2(nss)
      real corlag(nss)

      open(11,form='unformatted',access='direct',recl=4)
c
      ir=0
      do it=1,nss

        do ik=1,9
        ir=ir+1
          read(11,rec=ir) xhss
          if(ik.eq.1) hs2(it)=xhss
          if(ik.eq.2) hs1(it)=xhss
        enddo
      enddo
cc lagged corr of skill
      call lag_corr(nss,hs1,corlag)
      write(6,*)'lagcor of hs1=',corlag
      call lag_corr(nss,hs2,corlag)
      write(6,*)'lagcor of hs2=',corlag
      
      stop
      END
c


