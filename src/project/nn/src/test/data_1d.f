      program test_data
      include "parm.h"
      dimension rout1(nt)
      dimension rout2(nt)
      real rmse
      open(unit=10,file = "data_test.csv")
c*************************************************
      write(10,777) 'input,validation'
      do it=1,nt
        CALL RANDOM_NUMBER(rand)
        rout1(it)=((rand-0.5)*2)
        CALL RANDOM_NUMBER(rand)
        rout2(it)=(1-alpha)*rout1(it)+alpha*((rand-0.5)*2)
      enddo

      call normal(rout1,nt)
      call normal(rout2,nt)

      iw=0
      do it=1,nt
      iw=iw+1
      write(10,rec=iw) rout2(it)
      iw=iw+1
      write(10,rec=iw) rout1(it)
      enddo

      call rms_err(rout1,rout2,nt,rmse)

      write(6,*) 'rmse=',rmse

777   format(A16)
888   format(f7.4,A1,f7.4)

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
      
