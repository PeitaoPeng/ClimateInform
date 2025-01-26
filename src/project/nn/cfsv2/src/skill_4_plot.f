      program test_data
      include "parm.h"
      dimension on34(nt),w1(nt),w2(nt),w3(nt)
      dimension f2dm(nt,nld),f2dn(nt,nld),f2dr(nt,nld)
      dimension acm(nld),rmsm(nld),acn(nld),rmsn(nld)
      dimension acr(nld),rmsr(nld)
      open(unit=10,form='unformatted',access='direct',recl=4)

      open(unit=11,form='unformatted',access='direct',recl=4)
      open(unit=12,form='unformatted',access='direct',recl=4)
      open(unit=13,form='unformatted',access='direct',recl=4)
      open(unit=14,form='unformatted',access='direct',recl=4)
      open(unit=15,form='unformatted',access='direct',recl=4)
      open(unit=16,form='unformatted',access='direct',recl=4)
      open(unit=17,form='unformatted',access='direct',recl=4)
C
      open(unit=21,form='unformatted',access='direct',recl=4)
      open(unit=22,form='unformatted',access='direct',recl=4)
      open(unit=23,form='unformatted',access='direct',recl=4)
      open(unit=24,form='unformatted',access='direct',recl=4)
      open(unit=25,form='unformatted',access='direct',recl=4)
      open(unit=26,form='unformatted',access='direct',recl=4)
      open(unit=27,form='unformatted',access='direct',recl=4)
C
      open(unit=31,form='unformatted',access='direct',recl=4)
      open(unit=32,form='unformatted',access='direct',recl=4)
      open(unit=33,form='unformatted',access='direct',recl=4)
      open(unit=34,form='unformatted',access='direct',recl=4)
      open(unit=35,form='unformatted',access='direct',recl=4)
      open(unit=36,form='unformatted',access='direct',recl=4)
      open(unit=37,form='unformatted',access='direct',recl=4)

      open(unit=40,form='unformatted',access='direct',recl=4)
c*************************************************
C read nmme nino indices
      do it=1,nt
        read(10,rec=it) on34(it)
      enddo

      icm=18
      icn=28
      icr=38
      do ld=1,nld
        icm=icm-1
        icn=icn-1
        icr=icr-1

        do it=1,nt
        read(icm,rec=it) f2dm(it,ld)
        read(icn,rec=it) f2dn(it,ld)
        ir=it*2
        read(icr,rec=ir) f2dr(it,ld)
        enddo
      enddo
C have ac and rms
      iw=0
      do ld=1,nld
        do it=1,nt
          w1(it)=f2dm(it,ld)
          w2(it)=f2dn(it,ld)
          w3(it)=f2dr(it,ld)
        enddo
        call ac_rms(on34,w1,nt,acm(ld),rmsm(ld))
        call ac_rms(on34,w2,nt,acn(ld),rmsn(ld))
        call ac_rms(on34,w3,nt,acr(ld),rmsr(ld))
        iw=iw+1
        write(40,rec=iw) acm(ld)
        iw=iw+1
        write(40,rec=iw) acn(ld)
        iw=iw+1
        write(40,rec=iw) acr(ld)
        iw=iw+1
        write(40,rec=iw) rmsm(ld)
        iw=iw+1
        write(40,rec=iw) rmsn(ld)
        iw=iw+1
        write(40,rec=iw) rmsr(ld)
      enddo
C
      write(6,*) 'acm=',acm
      write(6,*) 'acn=',acn
      write(6,*) 'acr=',acr
      write(6,*) 'rmsm=',rmsm
      write(6,*) 'rmsn=',rmsn
      write(6,*) 'rmsr=',rmsr

C avg skill
      avacm=0
      avacn=0
      avacr=0
      avrmsm=0
      avrmsn=0
      avrmsr=0
      do i=1,nld
      avacm=avacm+acm(i)/float(nld)
      avacn=avacn+acn(i)/float(nld)
      avacr=avacr+acr(i)/float(nld)
      avrmsm=avrmsm+rmsm(i)/float(nld)
      avrmsn=avrmsn+rmsn(i)/float(nld)
      avrmsr=avrmsr+rmsr(i)/float(nld)
      enddo
      write(6,*)'avgacm=',avacm,'avgacn=',avacn,'avgacr=',avacr
      write(6,*)'avrmsm=',avrmsm,'avrmsn=',avrmsn,'avrmsr=',avrmsr
      
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

      subroutine ac_rms(x1,x2,n,ac,rms)
      dimension x1(n),x2(n)
      sd1=0.
      sd2=0.
      ac=0.
      rms=0.
      do i=1,n
        sd1=sd1+x1(i)*x1(i)
        sd2=sd2+x2(i)*x2(i)
        ac=ac+x1(i)*x2(i)
        rms=rms+(x1(i)-x2(i))**2
      enddo
      sd1=sqrt(sd1/float(n))
      sd2=sqrt(sd2/float(n))
      ac=ac/float(n)
      ac=ac/(sd1*sd2)
      rms=sqrt(rms/float(n))
      return
      end

