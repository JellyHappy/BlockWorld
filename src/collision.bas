 rem Reference fragment extracted from main.bas. Do not compile or include separately.
 rem Edit main.bas as the authoritative game source.

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

