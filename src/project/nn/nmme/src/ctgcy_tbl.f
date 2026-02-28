CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  3x3(a,n,b) Contengency Table
C==========================================================
      include "parm.h"
      dimension obs(nyr),nobs(nyr)
      dimension prd(nyr),nprd(nyr)
      dimension ann(nyr),nann(nyr)
      dimension nwk(nyr)

      real na,nn,nb
      real na_t,nn_t,nb_t
c
      open(unit=11,form='unformatted',access='direct',recl=4) !obs
      open(unit=12,form='unformatted',access='direct',recl=4) !nmme
      open(unit=13,form='unformatted',access='direct',recl=4) !ann
      open(unit=51,form='formatted')
c
c= read in obs & prd data
      do it=1,nyr
        read(11,rec=it) obs(it)
        read(12,rec=it) prd(it)
        read(13,rec=it) ann(it)
      enddo
        call change_numb(obs,nobs,cr,nyr) !convertto -1,0,+1
        call change_numb(prd,nprd,cr,nyr) !convertto -1,0,+1
        call change_numb(ann,nann,cr,nyr) !convertto -1,0,+1
      write(6,*) 'obs=',nobs
      write(6,*) 'prd=',nprd
      write(6,*) 'ann=',nann
c
cc and have contengency table for A. N, and B
c
      Do idata=1,2
      aa_t=0
      an_t=0
      ab_t=0
      na_t=0
      nn_t=0
      nb_t=0
      ba_t=0
      bn_t=0
      bb_t=0

      at=0.
      nt=0.
      bt=0.

      if(idata.eq.1) then
        do it=1,nyr
          nwk(it)=nprd(it)
        enddo
      end if
      if(idata.eq.2) then
        do it=1,nyr
          nwk(it)=nann(it)
        enddo
      end if
        

      DO it=1,nyr

      call count_3ctg(nwk(it),nobs(it),
     &aa,an,ab,na,nn,nb,ba,bn,bb,a,n,b)
      aa_t=aa_t+aa
      an_t=an_t+an
      ab_t=ab_t+ab
      na_t=na_t+na
      nn_t=nn_t+nn
      nb_t=nb_t+nb
      ba_t=ba_t+ba
      bn_t=bn_t+bn
      bb_t=bb_t+bb

      at=at+a
      nt=nt+n
      bt=bt+b

      ENDDO

      tot=aa_t+an_t+ab_t+na_t+nn_t+nb_t+ba_t+bn_t+bb_t

c     aa_t=100*aa_t/tot
c     an_t=100*an_t/tot
c     ab_t=100*ab_t/tot
c     na_t=100*na_t/tot
c     nn_t=100*nn_t/tot
c     nb_t=100*nb_t/tot
c     ba_t=100*ba_t/tot
c     bn_t=100*bn_t/tot
c     bb_t=100*bb_t/tot
 
      write(50,888)aa_t,an_t,ab_t
      write(50,888)na_t,nn_t,nb_t
      write(50,888)ba_t,bn_t,bb_t

      write(50,*) 'a_tot=',at
      write(50,*) 'n_tot=',nt
      write(50,*) 'b_tot=',bt
      write(50,*) 'tot=',tot

      ENDDO

 888  format(3f10.1)
     
      stop
      end
        
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine change_numb(din,kdin,cr,m)
      dimension din(m),kdin(m)
c
      do i=1,m

      if(din(i).gt.cr) kdin(i)=1
      if (din(i).le.cr.and.din(it).ge.-cr) kdin(i)=0
      if (din(i).lt.-cr) kdin(i)=-1

      end do
c
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  set array zero
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine setzero2(a,m,n)
      real a(m,n)
c
      do i=1,m
      do j=1,n
        a(i,j)=0.
      end do
      end do
c
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  set array zero
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine setzero(a,n)
      real a(n)
      do 5 i=1,n
      a(i)=0.
  5   continue
      return
      end

      SUBROUTINE terc102(t,a,b,it3) 
c* transforms 102 temperatures into 102 terciled values 
      DIMENSION t(102),it3(102) 
      DO 11 i=1,102 
      icd=i 
      IF (t(icd).le.b)it3(i)=-1 
      IF (t(icd).ge.a)it3(i)=1 
      IF (t(icd).lt.a.and.t(icd).gt.b)it3(i)=0 
11    CONTINUE 
      RETURN 
      END 

      subroutine count_3ctg(mw1,mw2,
     &aa,an,ab,na,nn,nb,ba,bn,bb,at,nt,bt) 
      real na,nn,nb
c    
      aa=0. 
      an=0. 
      ab=0. 
      na=0. 
      nn=0. 
      nb=0. 
      ba=0. 
      bn=0. 
      bb=0. 
      ic1=1
      ic2=0
      ic3=-1
c
      at=0
      nt=0
      bt=0

      if(mw2.eq.ic1) at=at+1
      if(mw2.eq.ic2) nt=nt+1
      if(mw2.eq.ic3) bt=bt+1

      if(mw1.eq.ic1.and.mw2.eq.ic1) aa=aa+1
      if(mw1.eq.ic1.and.mw2.eq.ic2) an=an+1
      if(mw1.eq.ic1.and.mw2.eq.ic3) ab=ab+1

      if(mw1.eq.ic2.and.mw2.eq.ic1) na=na+1
      if(mw1.eq.ic2.and.mw2.eq.ic2) nn=nn+1
      if(mw1.eq.ic2.and.mw2.eq.ic3) nb=nb+1

      if(mw1.eq.ic3.and.mw2.eq.ic1) ba=ba+1
      if(mw1.eq.ic3.and.mw2.eq.ic2) bn=bn+1
      if(mw1.eq.ic3.and.mw2.eq.ic3) bb=bb+1

      return 
      end 

