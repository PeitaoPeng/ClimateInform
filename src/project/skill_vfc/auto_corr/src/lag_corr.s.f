      SUBROUTINE lag_corr(ltime,fin,fot)
      DIMENSION fin(ltime),fot(ltime)
      DIMENSION wk(ltime)
c
      lh=ltime/2
      write(6,*) 'lh=',lh
      DO i=0,lh
      ll=ltime-i
       do j=1,ll
         wk(j)=fin(j+i)
       enddo
       call corr(ll,fin,wk,fot(i+1))
      ENDDO
c
      RETURN
      END
c
      SUBROUTINE corr(lt,x,y,c)
      DIMENSION x(lt),y(lt)
c
      xm=0
      ym=0
      do i=1,lt
        xm=xm+x(i)/float(lt)
        ym=ym+y(i)/float(lt)
      enddo
      do i=1,lt
        x(i)=x(i)-xm
        y(i)=y(i)-ym
      enddo
      xx=0
      yy=0
      xy=0
      do i=1,lt
        xx=xx+x(i)*x(i)/float(lt)
        yy=yy+y(i)*y(i)/float(lt)
        xy=xy+x(i)*y(i)/float(lt)
      enddo
      c=xy/sqrt(xx*yy)
      return
      end

