DisplayNames proc near

	             mov ah,2
	             mov dx,0110h      	;Move cursor to the first Name location
	             int 10h

	             mov ah, 9
	             lea dx,Name1    	;Print player1 Name
	             int 21h

	             mov ah,2
	             mov dx,0132h      	;Move cursor to the secound second location
	             int 10h

	             mov ah, 9
	             lea dx, Name2     	;Print player2 Name
	             int 21h

	             ret
        
DisplayNames endp

DrawLives proc near

	             mov bx,Health1
	             mov Score1[bx],"$"	;to decrease healthbar

	             mov ah,2
	             mov dx,0210h      	;Move cursor to the first score location
	             int 10h

	             mov ah, 9
	             lea dx, Score1    	;Print player1 Score
	             int 21h

	             mov bx,Health2
	             mov Score2[bx],"$"
        
	             mov ah,2
	             mov dx,0232h      	;Move cursor to the second score location
	             int 10h

	             mov ah, 9
	             lea dx, Score2    	;Print player2 Score
	             int 21h

	             ret

DrawLives endp
    
EndGame proc near

	             mov ax,12h
	             int 10h
        
	             mov ah,2
	             mov dx,0C10h      	;Move cursor to location
	             int 10h

	             mov ah, 9
	             lea dx,WinMessage 	;Check Won variable, get message
	             int 21h

	             mov ah,0
	             int 16h
	;then?
	             ret

EndGame endp