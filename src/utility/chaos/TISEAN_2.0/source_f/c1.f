c data for information dimension, fixed mass
c see  H. Kantz, T. Schreiber, Nonlinear Time Series Analysis, Cambridge
c      University Press (1997)
c Copyright (C) T. Schreiber (1997)

      parameter(nx=1000000,mp=1000)
      dimension x(nx),rln(mp),pln(mp)
      character*72 file, fout
      data kmax/100/, res/2./
      data iverb/1/

      call whatido("fixed mass approach to d1 estimation",iverb)
      id=imust("d")
      mfrom=max(imust("m"),2)
      mto=imust("M")
      ntmin=imust("t")
      ncmin=imust("n")
      res=fcan("#",res)
      kmax=ican("K",kmax)
      resl=log(2.)/res
      nmax=ican("l",nx)
      nexcl=ican("x",0)
      jcol=ican("c",0)
      isout=igetout(fout,iverb)
      if(fout.eq." ") isout=1

      call nthstring(1,file)
      call readfile(nmax,x,nexcl,jcol,file,iverb)
      if(file.eq."-") file="stdin"
      if(isout.eq.1) call addsuff(fout,file,"_c1")
      call outfile(fout,iunit,iverb)
      do 10 m=mfrom,mto
         write(iunit,'(4h#m= ,i5)') m
         it=0
         pr=0.
         do 20 pl=log(1./(nmax-(m-1)*id)),0.,resl
            pln(it+1)=pl
            call d1(nmax,x,id,m,ncmin,pr,pln(it+1),rln(it+1),ntmin,kmax)
            if(pln(it+1).eq.pr) goto 20
            it=it+1
            pr=pln(it)
            write(iunit,*)   exp(rln(it)), exp(pln(it))
 20         continue
         write(iunit,'()')
 10      write(iunit,'()')
      end

      subroutine usage()
c usage message

      call whatineed(
     .   "-d# -m# -M# -t# -n# "//
     .   "[-## -K# -o outfile -l# -x# -c# -V# -h] file")
      call popt("d","delay")
      call popt("m","minimal embedding dimension (at least 2)")
      call popt("M","maximal embedding dimension (at least 2)")
      call popt("t","minimal time separation")
      call popt("n","minimal number of center points")
      call popt("#","resolution, values per octave (2)")
      call popt("K","maximal number of neighbours (100)")
      call popt("l","number of values to be read (all)")
      call popt("x","number of values to be skipped (0)")
      call popt("c","column to be read (1 or file,#)")
      call pout("file_c1")
      call pall()
      stop
      end

      subroutine d1(nmax,y,id,m,ncmin,pr,pln,eln,nmin,kmax)
      parameter(im=100,ii=100000000,nx=1000000,tiny=1e-20) 
      dimension y(nmax),jh(0:im*im),ju(nx),d(nx),jpntr(nx),
     .   nlist(nx),nwork(nx)

      if(nmax.gt.nx) stop "d1: make nx larger."
      ncomp=nmax-(m-1)*id
      kpr=int(exp(pr)*(ncomp-2*nmin-1))+1
      k=int(exp(pln)*(ncomp-2*nmin-1))+1
      if(k.gt.kmax) then
         ncomp=real(ncomp-2*nmin-1)*real(kmax)/k+2*nmin+1
         k=kmax
      endif         
      pln=psi(k)-log(real(ncomp-2*nmin-1))
      if(k.eq.kpr) return
      write(istderr(),*) 'Mass ', exp(pln),': k=', k, ', N=', ncomp 
      call rms(nmax,y,sc,sd)
      eps=exp(pln/m)*sd
      iu=ncmin-(m-1)*id
      do 10 i=1,iu
 10      ju(i)=i+(m-1)*id
      eln=0
 1    call base(ncomp+(m-1)*id,y,id,m,jh,jpntr,eps)
      iunp=0
      do 20 nn=1,iu                                           ! find neighbours
         n=ju(nn)
         call neigh(nmax,y,n,nmax,id,m,jh,jpntr,eps,nlist,nfound)
         nf=0
         do 30 ip=1,nfound
            np=nlist(ip)
            nmd=mod(abs(np-n),ncomp)
            if(nmd.le.nmin.or.nmd.ge.ncomp-nmin) goto 30  ! temporal neighbours
            nf=nf+1
            dis=0
            do 40 i=0,m-1
 40            dis=max(dis,abs(y(n-i*id)-y(np-i*id)))
            d(nf)=dis
 30         continue
         if(nf.lt.k) then
            iunp=iunp+1                                   ! mark for next sweep
            ju(iunp)=n
         else
            e=which(nf,d,k,nwork)
            eln=eln+log(max(e,tiny))
         endif
 20      continue
      iu=iunp
      eps=eps*sqrt(2.)
      if(iunp.ne.0) goto 1
      eln=eln/(ncmin-(m-1)*id)
      end

c digamma function
c Copyright (C) T. Schreiber (1997)

      function psi(i)
      dimension p(0:20)
      data p/0., 
     .  -0.57721566490,  0.42278433509,  0.92278433509,  1.25611766843,
     .   1.50611766843,  1.70611766843,  1.87278433509,  2.01564147795,
     .   2.14064147795,  2.25175258906,  2.35175258906,  2.44266167997,
     .   2.52599501330,  2.60291809023,  2.67434666166,  2.74101332832,
     .   2.80351332832,  2.86233685773,  2.91789241329,  2.97052399224/

      if(i.le.20) then
         psi=p(i)
      else
         psi=log(real(i))-1/(2.*i)
      endif
      end
