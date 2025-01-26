'open grads.ctl'
'open grads_br.ctl'

istday=2
iedday=2

while (istday <= iedday)

iday=istday

'clear'
'set vpage 0.0 11.0 0.0 8.5'
'enable print gmeta'iday''
'xyplot plot_1line'iday''
'set vpage 1.7 4.7 5.5 8.0'
'set grads off'
'set xlab off'
'set t 'iday''
'set vrange 0.0 4000.'
'set gxout bar'
'set bargap 20'
'set ccolor 2'
'd xxx.1'
'print'
'disable print'

say 'type in c to continue or quit to exit'
pull corquit
corquit

istday=istday+1

endwhile

