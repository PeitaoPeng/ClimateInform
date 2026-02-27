      program test_data
      include "parm.h"
      dimension rout1(nt)
      dimension rout2(nt)
      dimension rout3(nt)
      dimension rout4(nt)
      real rmse
      open(unit=10,file = "data_test.csv")
c*************************************************
      write(10,777) 'input1,input2,output'
      do it=1,nt
        CALL RANDOM_NUMBER(rand)
        rout1(it)=((rand-0.5)*2)
        CALL RANDOM_NUMBER(rand)
        rout2(it)=(1-wt)*rout1(it)+wt*((rand-0.5)*2)
        CALL RANDOM_NUMBER(rand)
        rout3(it)=(1-wt)*rout2(it)+wt*((rand-0.5)*2)
      enddo

      call normal(rout1,nt)
      call normal(rout2,nt)
      call normal(rout3,nt)

      do it=1,nt
      write(10,888) rout1(it),",",rout2(it),",",rout3(it)
      enddo

      call rms_err(rout1,rout3,nt,rmse)

      write(6,*) 'rmse=',rmse

777   format(A16)
888   format(f7.4,A1,f7.4,A1,f7.4,A1,f7.4)

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
      
