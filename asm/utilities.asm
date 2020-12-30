	;Sets video mode to 640*480
ClearScreen proc near
	                               mov  ax,12h
	                               int  10h
	                               ret
ClearScreen endp

DrawScore proc near

	                               mov  ah,2
	                               mov  dx,0106h                      	;Move cursor to the first score location
	                               int  10h

	                               mov  ah, 9
	                               lea  dx, Score1                    	;Print player1 Score
	                               int  21h

	                               mov  ah,2
	                               mov  dx,0116h                      	;Move cursor to the secound score location
	                               int  10h

	                               mov  ah, 9
	                               lea  dx, score2                    	;Print player2 Score
	                               int  21h

	                               mov  ah,1                          	;Change score action  // change later
	                               int  16h                           	;for not (,) increments player1 score and (.) increments player2 score
	                               cmp  al,46
	                               jnz  nochange
	                               inc  Score2  +10                   	;where +9 score degit
        
	                               mov  ah,0
	                               int  16h

	nochange:                      

	                               cmp  al,44
	                               jnz  nochange2

	                               inc  Score1 +10
	                               mov  ah,0
	                               int  16h

	nochange2:                     
	                               ret

DrawScore endp