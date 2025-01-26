      program test_data
      include "parm.h"
      dimension wk1(4,nt,12),wk2(4,nld,12)

      open(unit=10,form='unformatted',access='direct',recl=4)
C
      open(unit=40,form='unformatted',access='direct',recl=4)
c*************************************************
C read skill
      undef=-9.99e+8

      ir=0
      do ie=1,12
         do it=1,nt
         do iv=1,4
         ir=ir+1
         read(10,rec=ir) wk1(iv,it,ie)
         enddo
         enddo
      enddo

C arrange skill according to tgtss
         do itgt=1,6
           ld=0
           do ie=itgt,1,-1
            ld=ld+1
             do iv=1,4
             wk2(iv,ld,itgt)=wk1(iv,ie+ld-1,ie)
             enddo
           enddo
           nes=nld+itgt-1
           do ie=12,nes,-1
           ld=ld+1
             do iv=1,4
             wk2(iv,ld,itgt)=wk1(iv,ie+ld-1,ie)
             enddo
           enddo
         enddo

         do itgt=7,12
           ld=0
           do ie=itgt,ld+1,-1
            ld=ld+1
             do iv=1,4
             wk2(iv,ld,itgt)=wk1(iv,ie+ld-1,ie)
             enddo
           enddo
         enddo
          
C write out
      iw=0
      do itgt=1,12
         do ld=1,nld
         do iv=1,4

         iw=iw+1
         write(40,rec=iw) wk2(iv,ld,itgt)

         enddo
         enddo
      enddo

      stop
      end
