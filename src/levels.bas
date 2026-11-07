 rem Reference fragment extracted from main.bas. Do not compile or include separately.
 rem Edit main.bas as the authoritative game source.

loadworld
 player0y=200 : player1y=200 : bally=200
 pfclear
 drawscreen
 COLUBK=sky[world] : COLUPF=land[world]
 CTRLPF=$21
 scorecolor=$0E
 pfhline 0 10 12 on
 pfhline 23 10 31 on
 drawscreen
 pfhline 0 11 12 on
 pfhline 23 11 31 on
 drawscreen
 pfvline 31 8 9 on
 ledgex=ledgeleft[world] : ledgeend=ledgex+24
 temp1=ledgex-16 : temp1=temp1/4
 temp2=temp1+6
 pfhline temp1 7 temp2 on
 drawscreen
 for temp3=0 to world
 temp1=temp3*2
 pfpixel temp1 0 on
 next
 temp1=hearts+27
 pfhline 28 0 temp1 on
 if mode=1 && turn=1 then scorecolor=$9E
 player1x=22 : player1y=80
 player0x=122 : player0y=80
 player0:
 %01000010
 %01111110
 %00111100
 %01111110
 %01011010
 %01111110
 %00100100
 %00010000
end
 COLUP0=$46
 NUSIZ0=0 : NUSIZ1=0
 missile0y=200
 velocity=0 : grounded=1 : hp=1 : direction=0
 if world=5 then hp=3
 bricks=0 : bridge=0 : rescued=0 : invincible=50
 soundtime=12 : soundkind=6
 gosub placebrick
 return

placebrick
 brickx=30 : bricky=75
 if bricks=1 then brickx=ledgex+8 : bricky=50
 if bricks=2 then brickx=62 : bricky=50
 return

