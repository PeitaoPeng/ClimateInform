      program test_data
      include "parm.h"
      dimension on34(nt)
      dimension out(nfld)
      dimension wk(narea,nt),w2d(imx,jmx),w3d(imx,jmx,nt)
      real rmse
      open(unit=10,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=20,form='unformatted',access='direct',recl=4)
C
      open(unit=30,form='unformatted',access='direct',recl=4*nfld)
c*************************************************
C read nmme sst anom

      ir=nld
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

c have area avg of SST
      do it=1,nt
        do i=1,imx
        do j=1,jmx
          w2d(i,j)=w3d(i,j,it)
        enddo
        enddo
        call area_avg(w2d,imx,jmx,is1,ie1,js1,je1,wk(1,it))
        call area_avg(w2d,imx,jmx,is2,ie2,js2,je2,wk(2,it))
        call area_avg(w2d,imx,jmx,is3,ie3,js3,je3,wk(3,it))
        call area_avg(w2d,imx,jmx,is4,ie4,js4,je4,wk(4,it))
        call area_avg(w2d,imx,jmx,is5,ie5,js5,je5,wk(5,it))
        call area_avg(w2d,imx,jmx,is6,ie6,js6,je6,wk(6,it))
        call area_avg(w2d,imx,jmx,is7,ie7,js7,je7,wk(7,it))
        call area_avg(w2d,imx,jmx,is8,ie8,js8,je8,wk(8,it))
        call area_avg(w2d,imx,jmx,is9,ie9,js9,je9,wk(9,it))
        call area_avg(w2d,imx,jmx,is10,ie10,js10,je10,wk(10,it))
        call area_avg(w2d,imx,jmx,is11,ie11,js11,je11,wk(10,it))
        call area_avg(w2d,imx,jmx,is12,ie12,js12,je12,wk(10,it))
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

      subroutine area_avg(fld,imx,jmx,is,ie,js,je,avg)
      dimension fld(imx,jmx)
      avg=0.
      ig=0
      do i=is,ie
      do j=js,je
        if(abs(fld(i,j)).lt.1000) then
        ig=ig+1
        avg=avg+fld(i,j)
        endif
      enddo
      enddo
      avg=avg/float(ig)

      return
      end
      
