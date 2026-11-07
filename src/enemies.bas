 rem Reference fragment extracted from main.bas. Do not compile or include separately.
 rem Edit main.bas as the authoritative game source.

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
