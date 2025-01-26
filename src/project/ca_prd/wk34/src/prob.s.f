c calculating 2-class prob for CA forecast
      subroutine prob(x1,n,xx,yy,pp,pn)
      dimension xx(n),yy(n)

      call pdf_tab(xx,yy,xde,n)

      call prob(x,n,xx,xde,yy,pr)

      stop
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  calculate normal distribution PDF from -5 to 5 (unit=std)
C  have it as a table for later integration
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine pdf_tab(xx,yy,xde,n)
      real xx(n),yy(n)
      pi=3.14159
      coef=1./sqrt(2*pi)
      xde=0.1
      xx(1)=-5+xde/2
      do i=2,n
      xx(i)= xx(i-1)+xde
      enddo
      do i=1,n
      yy(i)=coef*exp(-xx(i)*xx(i)/2)
      enddo
      return
      end
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  Have prob by integratinge PDF 
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine prob(x1,n,xx,xde,yy,pr)
      real xx(n),yy(n)
      pp=0
      do i=1,n
      if(xx(i).gt.x1) go to 111
      pp=pp+xde*yy(i)
      enddo
  111 continue
      if(x1.gt.0) then
      pr=pp
      else
      pr=1-pp
      endif
      return
      end  
