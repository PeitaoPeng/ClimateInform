      program test_data
      include "parm.h"
      dimension rn12(nt,nld),rn3(nt,nld),rn4(nt,nld),rn34(nt,nld)
      dimension on34(nt)
      dimension out1(nfld1),out2(nfld2)
      real rmse
      open(unit=10,form='unformatted',access='direct',recl=4)
      open(unit=20,form='unformatted',access='direct',recl=4)
C
      open(unit=30,form='unformatted',access='direct',recl=4*nfld1)
      open(unit=40,form='unformatted',access='direct',recl=4*nfld2)
c*************************************************
C read nmme nino indices
      ir=0
      do it=1,nt

        do ld=1,nld
        ir=ir+1
        read(10,rec=ir) rn12(it,ld)
        enddo

        do ld=1,nld
        ir=ir+1
        read(10,rec=ir) rn3(it,ld)
        enddo
      
        do ld=1,nld
        ir=ir+1
        read(10,rec=ir) rn4(it,ld)
        enddo

        do ld=1,nld
        ir=ir+1
        read(10,rec=ir) rn34(it,ld)
        enddo
      enddo ! it loop

C read obs nino34
      do it=1,nt
        read(20,rec=it) on34(it)
      enddo
c write out nino1-2
      do it=1,nt
        out1(1)=rn34(it,nld)
        out1(2)=on34(it)
        write(30,rec=it) out1

        out2(1)=rn12(it,nld)
        out2(2)=rn3(it,nld)
        out2(3)=rn4(it,nld)
        out2(4)=rn34(it,nld)
        out2(5)=on34(it)
        write(40,rec=it) out2
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
      
