      subroutine uv_2_psidivT40(uin,vin,vor,psi,div,vlp)
C. imax=128 jmax=64   mp=41    for T40
C. imax=128 jmax=108  mp=41    for R40
C. imax=192 jmax=96   mp=63    for T62
C. imax=256 jmax=128  mp=81    for T80
C. imax=384 jmax=192  mp=127   for T126
      PARAMETER (imax=128,jmax=64,mp=41,lromb=0,
     %           itr=(imax+2)/4*6)
      parameter(kmax=mp*(mp+1)*(1-lromb)/2+mp*mp*lromb,
     %          mmax=imax/2)
C
      common /gausin/ glat(jmax),coa(jmax),sia(jmax),gw(jmax)
      common /fftcom/ ifax(10),trigs(itr),wk(imax,jmax)
      common /legply/ p(jmax,kmax),dp(jmax,kmax)
      real    grid(imax,jmax),
     %        uin(imax,jmax),vin(imax,jmax),
     %        ud(imax,jmax),vd(imax,jmax),
     %        ur(imax,jmax),vr(imax,jmax),
     %        vor(imax,jmax),div(imax,jmax),
     %        psi(imax,jmax),vlp(imax,jmax)
      complex wave(kmax),
     %        fac(kmax),fac1(kmax),fac2(kmax),
     %        fac3(kmax),fac4(kmax),wave1(kmax),wave2(kmax)
C
      er=6371.0*1000.0
      k=0   
      do 10 m=1,mp
      fm=float(m-1)
      lmp=(m-1)*lromb
      do 10 n=m,mp+lmp
      k=k+1
      fn=-1.0*float(n*(n-1))
      xn=0.0
      if (n.ne.1) xn=er/fn  
      fac(k)=cmplx(er*xn,0.0)
      fac1(k)=cmplx(xn,0.0)
      fac2(k)=cmplx(0.0,fm*xn)
      fac3(k)=cmplx(0.0,fm)
 10   continue
C
c     call fftfax(imax,ifax,trigs)
c     call gaussl(sia,coa,glat,gw,jmax)
c     call legpol(p,sia,coa,kmax,mp,mp,jmax,lromb)
c     call difp(sia,coa,p,dp,kmax,mp,mp,jmax,lromb)
c
c==== have psi from u and v
c
          do i=1,imax
          do j=1,jmax
             if(coa(j).ne.0.) grid(i,j)=vin(i,j)/coa(j)
          enddo
          enddo
c
      call grdcof(wave,grid,p,wk,ifax,trigs,imax,jmax,
     &            kmax,mmax,mp,itr,gw,lromb)
c
          do i=1,imax
          do j=1,jmax
             grid(i,j)=uin(i,j)*coa(j)
          enddo
          enddo
c
      call grdcof(wave1,grid,dp,wk,ifax,trigs,imax,jmax,
     &            kmax,mmax,mp,itr,gw,lromb)
          do n=1,kmax
                wave2(n)=(wave(n)*fac3(n)+wave1(n))*fac1(n)
          enddo
      call cofgrd(wave2,psi,p,wk,ifax,trigs,imax,jmax,
     &            kmax,mmax,mp,itr,lromb)
c
c==== have vort from u & v
c
          do n=1,kmax
                wave2(n)=(wave(n)*fac3(n)+wave1(n))/er
          enddo
      call cofgrd(wave2,vor,p,wk,ifax,trigs,imax,jmax,
     &            kmax,mmax,mp,itr,lromb)
c
c==== have vlp from u and v
c
          do i=1,imax
          do j=1,jmax
             if(coa(j).ne.0.) grid(i,j)=uin(i,j)/coa(j)
          enddo
          enddo
c
        call grdcof(wave,grid,p,wk,ifax,trigs,imax,jmax,
     &            kmax,mmax,mp,itr,gw,lromb)
          do i=1,imax
          do j=1,jmax
             grid(i,j)=vin(i,j)*coa(j)
          enddo
          enddo
c
      call grdcof(wave1,grid,dp,wk,ifax,trigs,imax,jmax,
     &            kmax,mmax,mp,itr,gw,lromb)
          do n=1,kmax
             wave2(n)=(wave(n)*fac3(n)-wave1(n))*fac1(n)
          enddo
      call cofgrd(wave2,vlp,p,wk,ifax,trigs,imax,jmax,
     &            kmax,mmax,mp,itr,lromb)
c
c==== have div from u and v
c
          do n=1,kmax
             wave2(n)=(wave(n)*fac3(n)-wave1(n))/er
          enddo
      call cofgrd(wave2,div,p,wk,ifax,trigs,imax,jmax,
     &            kmax,mmax,mp,itr,lromb)
           print *, uin(37,15),psi(37,15),div(37,15)


      RETURN
      END
