      program test_data
      include "parm.h"
      dimension on34(nt),xn34(nt)
      dimension out(nfld)
      dimension w2d(imx,jmx),w2d2(imx,jmx)
      dimension wk(ngrd,nt),w3d(imx,jmx,nt),w3d2(imx,jmx,nt)
      dimension corr(imx,jmx),regr(imx,jmx)
      dimension ts1(nt),ts2(nt),ts3(nt)
      real rmse
      open(unit=10,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=15,form='unformatted',access='direct',recl=4)
      open(unit=20,form='unformatted',access='direct',recl=4)
C
      open(unit=30,form='unformatted',access='direct',recl=4*nfld)
c*************************************************
C read nmme sst anom

      ir=ld
      do it=1,nt

        read(10,rec=ir) w2d

          do i=1,imx
          do j=1,jmx
            w3d(i,j,it)=w2d(i,j)
          enddo
          enddo

        print *, 'ir=',ir
        ir=ir+nld
      enddo ! it loop
c
c read nino34
      do it=1,nt
        read(20,rec=it) on34(it)
        read(15,rec=it) xn34(it)
      enddo
c
c== regr model xn34 to data
      do j=1,jmx
      do i=1,imx

      if(w2d(i,j).gt.-1000) then

      do it=1,nt
        ts1(it)=w3d(i,j,it)
      enddo

      call regr_t(xn34,ts1,nt,corr(i,j),regr(i,j))
      else

        corr(i,j)= -9.99E+8
        regr(i,j)= -9.99E+8

      endif

      enddo
      enddo
c
c     iw=1
c     write(40,rec=iw) corr
c     iw=iw+1
c     write(40,rec=iw) regr
c
c have residual
c
      do it=1,nt
        do i=1,imx
        do j=1,jmx
        if(w2d(i,j).gt.-1000) then
          w3d2(i,j,it)=w3d(i,j,it)-xn34(it)*regr(i,j)
        else
          w3d2(i,j,it)=w3d(i,j,it)
        endif
        enddo
        enddo
      enddo

c have grid SST
      do it=1,nt
      ig=0
      do i=is,ie,4
      do j=js,je,2
        if(abs(w2d(i,j)).lt.100) then
        ig=ig+1
        wk(ig,it)=w3d2(i,j,it)
        endif
      enddo
      enddo
      print *, 'ngrd=',ig
      enddo

C write out grid SST and obs nino34
      do it=1,nt

          out(1)=xn34(it)

        do i=1,ngrd
          out(i+1)=wk(i,it)
        enddo
          out(nfld)=on34(it)

        write(30,rec=it) out
      enddo

      stop
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
      
