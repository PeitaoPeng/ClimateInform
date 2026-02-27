c  Gaussian white noise generator using uniformly distributed white
c  noise generator
c

      FUNCTION GASDEV(IDUM)
      DATA ISET/0/
      IF (ISET.EQ.0) THEN
1       V1=2.*RAN2(IDUM)-1.
        V2=2.*RAN2(IDUM)-1.
        R=V1**2+V2**2
        IF(R.GE.1.)GO TO 1
        FAC=SQRT(-2.*LOG(R)/R)
        GSET=V1*FAC
        GASDEV=V2*FAC
        ISET=1
      ELSE
        GASDEV=GSET
        ISET=0
      ENDIF
      RETURN
      END

C*********************************************************************
      function ran2(idum)
c
c  See NUMERICAL RECIPES for detail of the function under the same
c  name
c
      integer idum,im1,im2,imm1,ia1,ia2,iq1,iq2,ir1,ir2,ntba,ndiv
      real ran2,am,eps,rnmx
      parameter(im1=2147483563,im2=2147483399,am=1./im1,imm1=im1-1,
     *    ia1=40014,ia2=40692,iq1=53668,iq2=52774,ir1=12211,
     *    ir2=3791,ntab=32,ndiv=1+imm1/ntab,eps=1.2e-7,rnmx=1.-eps)
      integer idum2,j,k,iv(ntab),iy
      save iv,iy,idum2
      data idum2/123456789/,iv/ntab*0/,iy/0/
c
      if(idum.le.0) then
        idum=max(-idum,1)
        idum2=idum
        do j=ntab+8,1,-1
          k=idum/iq1
          idum=ia1*(idum-k*iq1)-k*ir1
          if(idum.lt.0) idum=idum+im1
          if(j.le.ntab) iv(j)=idum
        enddo
        iy=iv(1)
      endif
      k=idum/iq1
      idum=ia1*(idum-k*iq1)-k*ir1
      if(idum.lt.0) idum=idum+im1
      k=idum2/iq2
      idum2=ia2*(idum2-k*iq2)-k*ir2
      if(idum2.lt.0) idum2=idum2+im2
      j=1+iy/ndiv
      iy=iv(j)-idum2
      iv(j)=idum
      if(iy.lt.1) iy=iy+imm1
      ran2=min(am*iy,rnmx)
      return
      end
