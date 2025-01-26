      program test_data
      include "parm.h"
      dimension rout1(nt)
      dimension rout2(nt)
      dimension wk(nfld)
      real rmse
      open(unit=10,form='unformatted',access='direct',recl=4*nfld)
c*************************************************
      TP=10
      PI=3.14159265359
      do it=1,nt
        CALL RANDOM_NUMBER(rand)
        rout1(it)=cos(2*PI*it/TP)+((rand-0.5)*2)
        CALL RANDOM_NUMBER(rand)
c       rout2(it)=sin(2*PI*it/TP)+(1-alpha)*rout1(it)+alpha*
        rout2(it)=cos(2*PI*it/TP)+
     &((rand-0.5)*2)
      enddo

      call normal(rout1,nt)
      call normal(rout2,nt)

      do it=1,nt
      wk(1)=rout2(it)
      wk(2)=rout1(it)
      write(10,rec=it) wk
      enddo

      call rms_ac_err(rout1,rout2,nt,ac,rmse)

      write(6,*) 'ac=',ac,'  rmse=',rmse

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

      subroutine rms_ac_err(x1,x2,n,ac,rmse)
      dimension x1(n),x2(n)
      rv=0.
      ac=0
      do i=1,n
        rv=rv+(x1(i)-x2(i))*(x1(i)-x2(i))
        ac=ac+x1(i)*x2(i)
      enddo
      rmse=sqrt(rv/float(n))
      ac=ac/float(n)
      return
      end
      
