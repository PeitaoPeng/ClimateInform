      program correlation
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. correlation between tropical area averaged sst and global field
C===========================================================
      real s1(nt),s2(nt),cor1(nlag),cor2(nlag),cor(2*nlag+1)
      real w1(nt),w2(nt)
c
      open(unit=10,form='unformatted',access='direct',recl=4)
      open(unit=11,form='unformatted',access='direct',recl=4)
      open(unit=50,form='unformatted',access='direct',recl=4)
c
c read in pc
      ir=0
      do iy=1,nt
        ir=ir+1
        read(10,rec=ir) s1(ir)
        read(11,rec=ir) s2(ir)
      end do
c
c s1 lag s2
      do lag=1,nlag
      it=0
      do iy=lag+1,nt
      it=it+1
        w1(it)=s1(iy)
        w2(it)=s2(it)
      enddo

      ntw=nt-lag
      
        call anom(w1,nt,ntw)
        call anom(w2,nt,ntw)
        call cor_t(w1,w2,nt,ntw,cor1(lag))

      enddo ! lag loop
c s1 lead s2
      do lag=1,nlag
      it=0
      do iy=lag+1,nt
      it=it+1
        w1(it)=s1(it)
        w2(it)=s2(iy)
      enddo

      ntw=nt-lag
      
        call anom(w1,nt,ntw)
        call anom(w2,nt,ntw)
        call cor_t(w1,w2,nt,ntw,cor2(lag))

      enddo ! lag loop

c lag=0
      call cor_t(s1,s2,nt,nt,cor(nlag+1))
      do lag=1,nlag
        cor(lag)=cor1(nlag-lag+1)
        cor(nlag+1+lag)=cor2(lag)
      enddo
      write(6,*) 'cor=',cor
      nl=2*nlag+1
      do k=1,nl
      write(50,rec=k) cor(k)
      enddo

      stop
      END


      SUBROUTINE normal(rot,rot2,sd,ltime)
      DIMENSION rot(ltime),rot2(ltime)
      avg=0.
      do i=1,ltime
         avg=avg+rot(i)/float(ltime)
      enddo
      do i=1,ltime
        rot2(i)=rot(i)-avg
      enddo
c
      sd=0.
      do i=1,ltime
        sd=sd+rot2(i)*rot2(i)/float(ltime)
      enddo
        sd=sqrt(sd)
      do i=1,ltime
        rot2(i)=rot2(i)/sd
      enddo
      return
      end


      SUBROUTINE anom(rot,ltime,ltw)
      DIMENSION rot(ltime)
      avg=0.
      do i=1,ltw
         avg=avg+rot(i)/float(ltw)
      enddo
      do i=1,ltw
        rot(i)=rot(i)-avg
      enddo
c
      return
      end

      SUBROUTINE cor_t(f1,f2,nt,ntw,cor)

      real f1(nt),f2(nt)

      cor=0.
      sd1=0.
      sd2=0.

      do it=1,ntw
         cor=cor+f1(it)*f2(it)/float(ntw)
         sd1=sd1+f1(it)*f1(it)/float(ntw)
         sd2=sd2+f2(it)*f2(it)/float(ntw)
      enddo

      sd1=sd1**0.5
      sd2=sd2**0.5
      reg=cor/(sd1)
      cor=cor/(sd1*sd2)

      return
      end


      SUBROUTINE setzero(fld,n,m)
      DIMENSION fld(n,m)
      do i=1,n
      do j=1,m
         fld(i,j)=0.0
      enddo
      enddo
      return
      end
