      program test_data
      include "parm.h"
      dimension on34in(nt),on34(nt),idx(nt)
      dimension out(nfld)
      dimension w3din(imx,jmx,nt)
      dimension w2d(imx,jmx),w3d(imx,jmx,nt)
      dimension ts1(nt),ts2(nt),ts3(nt)
      dimension aaa(ngrd,nt),wk(nt,ngrd)
      dimension xlat(jmx),coslat(jmx),cosr(jmx)
      dimension eval(nt),evec(ngrd,nt),coef(nt,nt)
      real weval(nt),wevec(ngrd,nt),wcoef(nt,nt)
      real reval(nmod),revec(ngrd,nmod),rcoef(nmod,nt)
      real rwk(ngrd),rwk2(ngrd,nmod)
      real corr(imx,jmx),regr(imx,jmx)
      open(unit=10,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=20,form='unformatted',access='direct',recl=4)
      open(unit=25,form='unformatted',access='direct',recl=4)
C
      open(unit=30,form='unformatted',access='direct',recl=4*nfld)
      open(unit=40,form='unformatted',access='direct',recl=4*imx*jmx)
C*************************************************
C
C== have coslat
C
      do j=1,jmx
        xlat(j)=-90+(j-1)*2.5
        coslat(j)=cos(xlat(j)*3.14159/180)  !for EOF use
        cosr(j)=sqrt(coslat(j))  !for EOF use
      enddo
C read sst anom

      ir=1
      do it=1,nt

        read(10,rec=ir) w2d

          do i=1,imx
          do j=1,jmx
            w3din(i,j,it)=w2d(i,j)
          enddo
          enddo

        print *, 'ir=',ir
        ir=ir+1
      enddo ! it loop

C read obs nino34
      do it=1,nt
        read(20,rec=it) on34in(it)
      enddo

c have data randomly ordered
      call re_order(nt,idx)
      do it=1,nt
          do i=1,imx
          do j=1,jmx
            w3d(i,j,it)=w3din(i,j,idx(it))
          enddo
          enddo
        on34(it)=on34in(idx(it))
      print *, 'idx=',idx(it)
      enddo 
C write out re-ordereed n34
      do it=1,nt
        write(25,rec=it) on34(it)
      enddo

c eof input
      do it=1,nt
      ig=0
      do i=is,ie
      do j=js,je
        if(abs(w3d(i,j,it)).lt.100) then
        ig=ig+1
        aaa(ig,it)=w3d(i,j,it)*cosr(j)
        endif
      enddo
      enddo
      print *, 'ngrd=',ig
      enddo
C
C EOF analysis
      call eofs(aaa,ngrd,nt,nt,eval,evec,coef,wk,id)
      call REOFS(aaa,ngrd,nt,nt,wk,id,weval,wevec,wcoef,
     &           nmod,reval,revec,rcoef,tt,rwk,rwk2)
      print *, 'eval=',eval
C
C normalize coef and have patterns
      iw=0
      do m=1,nmod
        do it=1,nt
        ts1(it)=coef(m,it)
        ts2(it)=rcoef(m,it)
        enddo
        call normal(ts1,nt)
        call normal(ts2,nt)

        do it=1,nt
        coef(m,it)=ts1(it)
        rcoef(m,it)=ts2(it)
        enddo
c
        do j=1,jmx
        do i=1,imx

        if(abs(w2d(i,j)).lt.1000) then

        do it=1,nt
        ts3(it)=w3d(i,j,it)
        enddo

        call regr_t(ts2,ts3,nt,corr(i,j),regr(i,j))
        else

        corr(i,j)= -9.99E+8
        regr(i,j)= -9.99E+8

        endif

        enddo
        enddo

        iw=iw+1
        write(40,rec=iw) corr
        iw=iw+1
        write(40,rec=iw) regr
      enddo
C
C write out grid SST and obs nino34
      do it=1,nt

        do i=1,nmod
          out(i)=coef(i,it)
        enddo
          out(nfld)=on34(it)

        write(30,rec=it) out
      enddo

      stop
      end

      subroutine normal(x,n)
      dimension x(n)
      avg=0
      do i=1,n
        avg=avg+x(i)/float(n)
      enddo
      var=0
      do i=1,n
        var=var+(x(i)-avg)*(x(i)-avg)/float(n)
      enddo
      std=sqrt(var)
      do i=1,n
        x(i)=(x(i)-avg)/std
      enddo
      return
      end

      subroutine rms_err(x1,x2,n,rmse)
      dimension x1(n),x2(n)
      rv=0.
      do i=1,n
        rv=rv+(x1(i)-x2(i))*(x1(i)-x2(i))
      enddo
      rmse=sqrt(rv/float(n))
      return
      end

      SUBROUTINE regr_t(f1,f2,ltime,cor,reg)

      real f1(ltime),f2(ltime)

      cor=0.
      sd1=0.
      sd2=0.

      do it=1,ltime
         cor=cor+f1(it)*f2(it)/float(ltime)
         sd1=sd1+f1(it)*f1(it)/float(ltime)
         sd2=sd2+f2(it)*f2(it)/float(ltime)
      enddo

      sd1=sd1**0.5
      sd2=sd2**0.5
      reg=cor/(sd1)
      cor=cor/(sd1*sd2)

      return
      end

      subroutine re_order(nt,idx)
CC============================================================
CC In time domain, randomly re-ordered data
CC============================================================
      dimension rdx(nt),idx(nt),ran(nt)
C randolmly re-order index
c have random #
      ir=1
      do i=1,nt 
      ir=ir+1
         ran(i)=ran1(ir)
         rdx(i)=i
         print*, 'rdx=',rdx(i),'ran=',ran(i)
      enddo
      print*, 'start sort'
      call hpsort(nt,nt,ran,rdx)
         do i=1,nt
         print*, 'rdx=',rdx(i),'ran=',ran(i)
         enddo
c
      do i=1,nt
        idx(i)=rdx(i)
      enddo

      return
      end

      SUBROUTINE hpsort(n,n2,ra,rb)
      INTEGER n,n2
      REAL ra(n),rb(n)
      INTEGER i,ir,j,l
      REAL rra
      if (n2.lt.2) return
      l=n2/2+1
      ir=n2
10    continue
        if(l.gt.1)then
          l=l-1
          rra=ra(l)
          rrb=rb(l)
        else
          rra=ra(ir)
          rrb=rb(ir)
          ra(ir)=ra(1)
          rb(ir)=rb(1)
          ir=ir-1
          if(ir.eq.1)then
            ra(1)=rra
            rb(1)=rrb
            return
          endif
        endif
        i=l
        j=l+l
20      if(j.le.ir)then
          if(j.lt.ir)then
            if(ra(j).lt.ra(j+1))j=j+1
          endif
          if(rra.lt.ra(j))then
            ra(i)=ra(j)
            rb(i)=rb(j)
            i=j
            j=j+j
          else
            j=ir+1
          endif
        goto 20
        endif
        ra(i)=rra
        rb(i)=rrb
      goto 10
      END

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
