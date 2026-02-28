      program test_data
      include "parm.h"
      dimension on34(nt)
      dimension out(nfld)
      dimension wk(ngrd,nt),w2d(imx,jmx),w3d(imx,jmx,nt)
      real rmse
      open(unit=10,form='unformatted',access='direct',recl=4*imx*jmx)
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

C read obs nino34
      do it=1,nt
        read(20,rec=it) on34(it)
      enddo

c have grid SST
      do it=1,nt
      ig=0
      do i=is,ie,idel
      do j=js,je,jdel
        if(abs(w3d(i,j,it)).lt.100) then
        ig=ig+1
        wk(ig,it)=w3d(i,j,it)
        endif
      enddo
      enddo
      print *, 'ngrd=',ig
      enddo

C write out grid SST and obs nino34
      do it=1,nt

        do i=1,ngrd
          out(i)=wk(i,it)
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
      
