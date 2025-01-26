      program uv2psidiv
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. imx=128 jmx=64   mp=41    for T40
C. imx=128 jmx=108  mp=41    for R40
C. imx=192 jmx=96   mp=63    for T62
C. imx=256 jmx=128  mp=81    for T80
C. imx=384 jmx=192  mp=127   for T126
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      include "parm.h"
      PARAMETER (imx=128,jmx=64,mp=41,lromb=0,
     %  itr=(imx+2)/4*6,imx2=64,jmx2=40)
      parameter(kmax=mp*(mp+1)*(1-lromb)/2+mp*mp*lromb,
     %          mmax=imx/2)
C
      real*8 glat8(jmx),coa8(jmx),sia8(jmx),gw8(jmx)
      common /gausin/ glat(jmx),coa(jmx),sia(jmx),gw(jmx)
      common /fftcom/ ifax(10),trigs(itr),wk(imx,jmx)
      common /legply/ p(jmx,kmax),dp(jmx,kmax)
c
      real psi(imx,jmx),vlp(imx,jmx)
      real vor(imx,jmx),div(imx,jmx)
      real ur(imx,jmx),vr(imx,jmx)
      real ud(imx,jmx),vd(imx,jmx)
      real ug(imx,jmx),vg(imx,jmx)
c
      real fout(imx2,jmx2)
C
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=60,form='unformatted',access='direct',
     +             recl=4*imx*jmx)
C
      call fftfax(imx,ifax,trigs)
      call gaussl(sia8,coa8,glat8,gw8,jmx)
           do j=1,jmx
              glat(j)=glat8(j)
              coa(j) =coa8(j)
              sia(j) =sia8(j)
              gw(j) =gw8(j)
           end do
      call legpol(p,sia,coa,kmax,mp,mp,jmx,lromb)
      call difp(sia,coa,p,dp,kmax,mp,mp,jmx,lromb)
c
      do j=1,jmx
      write(*,999)' j=',j,' glat=',glat(j),'  sia=',sia(j),
     +'  coa=',coa(j),'  gw=',gw(j)
      end do
 999  format(1x,A4,I3,24(A6,f6.3))
c
            read(11,rec=1) ug
            read(11,rec=2) vg
c
      call uv_2_psidivT40(ug,vg,vor,psi,div,vlp)
c
           iw=iw+1
           write(60,rec=1) psi
c
      stop
      END
