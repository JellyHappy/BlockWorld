 rem Reference fragment extracted from main.bas. Do not compile or include separately.
 rem Edit main.bas as the authoritative game source.

hero
 player1:
 %01100110
 %01100110
 %01100110
 %00111100
 %01111110
 %11011011
 %11011011
 %00111100
 %00100100
 %00111100
 %00111100
 %00011000
end
 if tick{3} && grounded=1 then player1:
 %11000011
 %01100110
 %01100110
 %00111100
 %01111110
 %11011011
 %11011011
 %00111100
 %00100100
 %00111100
 %00111100
 %00011000
end
 player1color:
 $86
 $86
 $86
 $46
 $46
 $46
 $46
 $1C
 $1C
 $1C
 $1C
 $1C
end
 return

