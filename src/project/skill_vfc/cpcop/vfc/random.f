      parameter(nsp=100000,nbin=25)
      dimension rbin(nbin),rand(nsp)
c
      open (10,file='ran-pdf.gr',access='direct',
     x   form='unformatted',recl=nbin*4)
c
c
c
      ir=1
      do i=1,nsp
      ir=ir+1
          rand(i)=ran1(ir)
      enddo
      write(6,*) rand

      call ranbin(rand,rbin,nsp,nbin)
      write(10,rec=1) rbin

      stop
      end
c
      FUNCTION ran1(idum)
      INTEGER idum,IA,IM,IQ,IR,NTAB,NDIV
      REAL ran1,AM,EPS,RNMX
      PARAMETER (IA=16807,IM=2147483647,AM=1./IM,IQ=127773,IR=2836,
     *NTAB=32,NDIV=1+(IM-1)/NTAB,EPS=1.2e-7,RNMX=1.-EPS)
      INTEGER j,k,iv(NTAB),iy
      SAVE iv,iy
      DATA iv /NTAB*0/, iy /0/
      if (idum.le.0.or.iy.eq.0) then
        idum=max(-idum,1)
        do 11 j=NTAB+8,1,-1
          k=idum/IQ
          idum=IA*(idum-k*IQ)-IR*k
          if (idum.lt.0) idum=idum+IM
          if (j.le.NTAB) iv(j)=idum
11      continue
        iy=iv(1)
      endif
      k=idum/IQ
      idum=IA*(idum-k*IQ)-IR*k
      if (idum.lt.0) idum=idum+IM
      j=1+iy/NDIV
      iy=iv(j)
      iv(j)=idum
      ran1=min(AM*iy,RNMX)
      return
      END

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  put random data into a bin
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine ranbin(wk,bin,m,n)
      dimension wk(m),bin(n)
c
      do j=1,n
        bin(j)=0.
      enddo
c
      bs=-0.04
      be=0
      xnc=0.04  !increment of hs

      do j=1,n

      bs=bs+xnc
      be=be+xnc

      do i=1,m
        if(wk(i).gt.bs.and.wk(i).le.be) bin(j)=bin(j)+1
      enddo
c     write(6,*) 'bs&be=',bs,be
c
      end do
c
      return
      end
