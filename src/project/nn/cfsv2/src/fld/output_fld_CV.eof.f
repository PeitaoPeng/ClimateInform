      program test_data
      include "parm.h"
      dimension ts(nt),wk(imx,jmx)
      real coef(nmodo,nt),regr(nmodo,imx,jmx)
      real out(imx,jmx)
      open(unit=11,form='unformatted',access='direct',recl=4*nt)
      open(unit=12,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=13,form='unformatted',access='direct',recl=4*imx*jmx)
C
C have OBS patterns
      do m=1,nmodo

        read(11,rec=m) ts
c       call normal(ts,nt)
        do it=1,nt
          coef(m,it)=ts(it)
        enddo

        read(12,rec=m) wk
        do i=1,imx
        do j=1,jmx
          regr(m,i,j)=wk(i,j)
        enddo
        enddo

      enddo ! m loop

c
C construct mlp forecast
      do it=1,nt

        do i=1,imx
        do j=1,jmx

        if(abs(wk(i,j)).lt.1000) then
           out(i,j)=0.
        do m=1,nmodo
          out(i,j)=out(i,j)+coef(m,it)*regr(m,i,j)
        enddo
        else
          out(i,j)= -9.99E+8
        endif
        enddo
        enddo

        write(13,rec=it) out

      enddo  ! it loop
C
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

