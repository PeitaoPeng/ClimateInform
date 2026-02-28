c utility for neighbour search
c see  H. Kantz, T. Schreiber, Nonlinear Time Series Analysis, Cambridge
c      University Press (1997)
c Copyright (C) T. Schreiber (1997)

      subroutine neigh(nmax,y,n,nlast,id,m,jh,jpntr,eps,nlist,nfound)
      parameter(im=100,ii=100000000) 
      dimension y(nmax),jh(0:im*im),jpntr(nmax),nlist(nmax)

      nfound=0
      jj=int(y(n)/eps)
      kk=int(y(n-(m-1)*id)/eps)
      do 10 j=jj-1,jj+1                               ! scan neighbouring boxes
         do 20 k=kk-1,kk+1
            jk=im*mod(j+ii,im)+mod(k+ii,im)
            do 30 ip=jh(jk+1),jh(jk)+1,-1               ! this is in time order
               np=jpntr(ip)
               if(np.gt.nlast) goto 20
               do 40 i=0,m-1
 40               if(abs(y(n-i*id)-y(np-i*id)).ge.eps) goto 30
               nfound=nfound+1
               nlist(nfound)=np                       ! make list of neighbours
 30            continue
 20         continue
 10      continue
      end
