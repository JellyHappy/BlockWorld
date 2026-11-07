 rem LEGO Minifigure: Block World Adventures - unofficial fan homebrew
 rem Standalone batari Basic source. NTSC, 4K, standard kernel.
 set romsize 4k
 set smartbranching on
 set kernel_options player1colors
 dim world=a
 dim bricks=b
 dim bridge=c
 dim rescued=d
 dim hp=e
 dim direction=f
 dim velocity=g
 dim grounded=h
 dim oldy=i
 dim tick=j
 dim hearts=k
 dim invincible=l
 dim soundtime=m
 dim firelock=n
 dim state=o
 dim brickx=p
 dim bricky=q
 dim ledgex=r
 dim ledgeend=s
 dim soundkind=t
 dim mode=u
 dim turn=v
 dim selectlock=w
 dim deaths=x
 dim oldx=y
 dim spare=z

 CTRLPF=$21 : ballheight=3
 mode=0 : turn=0 : selectlock=0
 score=0 : state=0 : tick=0
 gosub hero
 goto titleinit

titleinit
 pfclear
 playfield:
......XX..X...XXX.XXX.X.X.......
......X.X.X...X.X.X...XX........
......XX..X...X.X.X...X.........
......X.X.X...X.X.X...XX........
......XX..XXX.XXX.XXX.X.X.......
................................
.....X...X.XXX.XX..X...XX.......
.....X...X.X.X.X.X.X...X.X......
.....X.X.X.X.X.XX..X...X.X......
.....X.X.X.X.X.X.X.X...X.X......
......X.X..XXX.X.X.XXX.XX.......
................................
end
 player0y=200 : player1y=200 : bally=200
 missile0y=200
 COLUPF=$1C : COLUBK=$82 : scorecolor=$0E
titleloop
 tick=tick+1
 if switchreset then reboot
 if !switchselect then selectlock=0
 if switchselect && selectlock=0 then mode=mode^1 : selectlock=1
 score=1
 if mode=1 then score=2
 drawscreen
 if !joy0fire then goto titleloop
 score=0 : world=0 : hearts=3 : deaths=0 : turn=0 : state=1
 gosub loadworld
 firelock=1
 goto mainloop

mainloop
 if switchreset then reboot
 tick=tick+1
 if invincible>0 then invincible=invincible-1
 if soundtime>0 then soundtime=soundtime-1
 AUDV0=0
 if soundtime>0 then AUDV0=5 : AUDC0=4 : AUDF0=soundkind
 if soundtime>0 && soundkind=25 then AUDC0=8
 gosub hero
 oldx=player1x : oldy=player1y
 if joy0left && player1x>18 then player1x=player1x-1 : REFP1=8
 if joy0right && player1x<142 then player1x=player1x+1 : REFP1=0
 if !joy0fire then firelock=0
 if joy0fire && firelock=0 && grounded=1 then velocity=252 : grounded=0 : firelock=1 : soundtime=5 : soundkind=12
 if grounded=0 then player1y=player1y+velocity
 if grounded=0 && tick{1} && !tick{0} && velocity<>6 then velocity=velocity+1
 if grounded=1 then velocity=0
 grounded=0
 rem One-way ledge. Feet cross its top while descending.
 if velocity>127 then skiplanding
 if oldy>56 then checkfloor
 if player1y<56 then checkfloor
 if player1x<ledgex then checkfloor
 if player1x>ledgeend then checkfloor
 player1y=56 : velocity=0 : grounded=1
checkfloor
 if player1y<80 then skiplanding
 if oldy>80 then skiplanding
 if player1x>67 && player1x<105 && bridge=0 then skiplanding
 player1y=80 : velocity=0 : grounded=1
skiplanding
 if player1y>98 && player1y<200 then goto losehit
 rem Three sequential construction bricks use the TIA ball.
 bally=200
 if bricks<3 then ballx=brickx : bally=bricky
 if bricks=3 then skipbrick
 temp1=player1x+7
 if temp1<brickx then skipbrick
 temp1=brickx+4
 if player1x>temp1 then skipbrick
 if player1y<bricky then skipbrick
 temp1=bricky+14
 if player1y>temp1 then skipbrick
 bricks=bricks+1 : score=score+100 : soundtime=8 : soundkind=4
 gosub placebrick
skipbrick
 if joy0up && bricks=3 && bridge=0 then bridge=1 : pfhline 13 10 22 on : soundtime=14 : soundkind=8 : score=score+200
 rem A patrol bot becomes a friend after a stomp. Fortress boss has 3 HP.
 if hp=0 then friend
 if tick{0} then patrolend
 if direction=0 then player0x=player0x+1 else player0x=player0x-1
 if player0x>134 then direction=1
 if player0x<110 then direction=0
patrolend
 REFP0=tick
 COLUP0=$46
 if world=5 then COLUP0=$36
 if invincible>0 then enemyend
 temp1=player1x+7
 if temp1<player0x then enemyend
 temp1=player0x+7
 if player1x>temp1 then enemyend
 if player1y<69 then enemyend
 if player1y>85 then enemyend
 if velocity>127 then goto losehit
 if oldy>72 then goto losehit
 hp=hp-1 : velocity=252 : grounded=0 : invincible=25
 soundtime=10 : soundkind=18 : score=score+300
 if hp=0 then player0x=126
 goto enemyend
friend
 COLUP0=$CE
 player0:
 %00100100
 %00100100
 %00111100
 %01111110
 %01011010
 %00011000
 %00111100
 %00111100
end
 if rescued=1 then player0y=200
 if !joy0up then enemyend
 if player1x<116 then enemyend
 if player1x>136 then enemyend
 if player1y<70 then enemyend
 if rescued=0 then rescued=1 : score=score+500 : soundtime=16 : soundkind=2
enemyend
 rem Right edge is a portal. Building, rescue and a fresh Up are sufficient.
 rem Portal is the vertical playfield marker at the right edge.
 if player1x<138 then render
 if player1y<70 then render
 if !joy0up then render
 if rescued=0 || bridge=0 then render
 world=world+1
 if world=6 then goto victoryinit
 gosub loadworld
render
 drawscreen
 goto mainloop

losehit
 hearts=hearts-1 : deaths=deaths+1
 temp1=hearts+28 : pfpixel temp1 0 off
 if mode=1 then scorecolor=scorecolor^$90
 if mode=1 then turn=turn^1
 AUDC0=8 : AUDF0=25 : AUDV0=7
 if hearts=0 then goto gameoverinit
 player1x=22 : player1y=80 : velocity=0 : grounded=1
 invincible=90 : soundtime=20 : soundkind=25
 goto render

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

gameoverinit
 state=2 : COLUPF=$46
 goto finishscreen
victoryinit
 state=3 : score=score+2000 : COLUPF=$1E
finishscreen
 player0y=200 : player1y=200 : bally=200
 AUDV0=0
 playfield:
..........X.X.XXX.X.X...........
..........X.X.X.X.X.X...........
...........X..X.X.X.X...........
...........X..X.X.X.X...........
...........X..XXX.XXX...........
................................
.........X...X.XXX.X.X..........
.........X...X..X..XXX..........
.........X.X.X..X..XXX..........
.........X.X.X..X..XXX..........
..........X.X..XXX.X.X..........
................................
end
 if state<>2 then finishart
 pfclear
finishart
 rem Game over shows a red cross; victory reads YOU WIN with a golden brick.
 if state=2 then pfvline 16 2 8 on : pfhline 12 5 20 on
 if state=3 then ballx=126 : bally=62
 firelock=1
finishloop
 tick=tick+1
 if switchreset then reboot
 if !joy0fire then firelock=0
 if joy0fire && firelock=0 then reboot
 if state=3 && tick{4} then AUDV0=3 : AUDC0=4 : AUDF0=8 else AUDV0=0
 drawscreen
 goto finishloop

 data sky
 $82,$D2,$92,$22,$62,$02
end
 data land
 $0A,$C6,$AE,$3A,$08,$46
end
 data ledgeleft
 36,40,32,44,36,40
end
