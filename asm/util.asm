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

	nochange2:                     
	                               ret

DrawScore endp