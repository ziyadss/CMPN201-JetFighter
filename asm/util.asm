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
;------------------- Status Bar----------------------------------------
				 mov ah,2
	             mov  dl,StatusBarX
	             mov  dh,StatusBarHeight2   	;Move cursor to the secound second location
	             int 10h

	             mov ah, 9
	             lea dx, StatusBarPlayMsg     	;Print player2 Name
	             int 21h
				
				mov  ah,02h
	            mov  dl,41
	            mov  dh,StatusBarHeight2
	            int  10h                  	;moves cursor

				mov  ah,9
	            lea  dx, Name2
	            int  21h                  	;prints Other player's name Name

				mov  ah,02h
	            mov  dl,StatusBarX
	            mov  dh,StatusBarHeight
	            int  10h                  	;moves cursor

				mov  ah,9
	            lea  dx, StatusBarPlayMsg2
	            int  21h                  	;prints Other player's name Name
			
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

	              mov     Health1,15
	              mov     Health2,15
	              mov     LastTime,0
	              mov     Jet1X,10h
	              mov     Jet2X,0220h
	              mov     Jet1Y,30h
	              mov     Jet2Y,30h
	              mov     Jet1Z,2
	              mov     Jet2Z,-2
	              mov     Jet1Reload,0
	              mov     Jet2Reload,0
					   
	              mov     Jet1Power,0
	              mov     Jet2Power,0
	              mov     Jet1Timer,0
	              mov     Jet2Timer,0
					   
	              mov     POWER_UP,0
	
	              mov     bx,7
	HealthLoop:   
	              mov     Score1[bx],219
	              mov     Score2[bx],219
	              inc     bx
	              cmp     bx,15
	              jnz     HealthLoop
	              xor     bx,bx
	ResetLoop:    
	              mov     bulletsZ[bx],0
	              inc     bx
	              cmp     bx,maxBullets
	              jnz     ResetLoop
				 
	              cmp Won,0
				  je EndGameDone
				  
				  mov     ax,12h
	              int     10h
        
	              mov     ah,2
	              mov     dx,0C20h      	;Move cursor to location
	              int     10h

				  cmp Won,2    ; If win=1 -> player 1 won , win=2 -> player 2 won
				  Je Player2win

				  mov ah,9
				  lea dx,Name2
				  int 21h

				  jmp Print_Win_msg

				  Player2win:

				  mov ah,9
				  lea dx,Name1
				  int 21h

				  Print_Win_msg:

	              mov     ah, 9
	              lea     dx,WinMessage 	;Check Won variable, get message
	              int     21h

	              mov ah,2ch
				  int 21h
				  mov LastTime,dh
				  add LastTime,5
				  cmp LastTime,59
				  jng WaitEndMessage
				  sub LastTime,60
				  
				  WaitEndMessage:
				  mov ah,2ch
				  int 21h
				  cmp LastTime,dh
				  jne WaitEndMessage
				  
				  EndGameDone:
				  
				  mov     Won,0
	              ret

EndGame endp

ExchangeNames proc near
	              xor     bx,bx
	
	NSendByte:    
	              mov     dx,3fdh      	;Line Status Register
	NagainS:      
	              in      al,dx        	;Read Line Status
	              test    al,00100000b
	              jz      NagainS      	;Transmitter Holding Register not empty

	              mov     dx,3f8h      	;Transmit Data Register
	              mov     al,Name1[bx]
	              out     dx,al        	;send character

	              mov     dx,3fdh      	;Line Status Register
	NagainR:      
	              in      al,dx        	;Read Line Status
	              test    al,1
	              jz      NagainR      	;Data not ready

	              mov     dx,3f8h
	              in      al,dx
	              mov     Name2[bx],al 	;if received, mov character to ValR
	              inc     bx
	              cmp     bx,16
	              jne     NSendByte
	
	              ret
ExchangeNames endp