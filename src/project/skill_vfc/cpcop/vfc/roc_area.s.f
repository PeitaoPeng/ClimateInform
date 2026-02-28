       subroutine roca(hr,fa,im,area)
       dimension hr(im),fa(im)

       area = 0.0
       do k = 2, im
        x1 = fa(k-1)
        y1 = hr(k-1)
        x2 = fa(k)
        y2 = hr(k)
        area=area+0.5*(y1+y2)*(x2-x1)
       enddo
       return
       end

