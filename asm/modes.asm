MainMenu proc near
	                      mov  ax,12h
	                      int  10h

	; set cursor position to the center of the screen
	                      mov  ah,2                 	;set cursor position
	                      mov  bh,0                 	;page 0
	                      mov  dl,9                 	; x=9  center column position
	                      mov  dh,9                 	; y=9 center row position
	                      int  10h


	; display the first message (please enter your name)
	                      mov  ah,9
	                      lea  dx,msg1              	; move the offset msg1 to dx
	                      int  21h

	; set cursor position to the next line still at the center of the screen
	                      mov  ah,2                 	;set cursor position
	                      mov  bh,0                 	;page 0
	                      mov  dl,9                 	; x=9  center column position
	                      mov  dh,10                	; y=10  center row position
	                      int  10h


	; making a loop to read the names from the user
	                      mov  SI,0
	                      mov  cx,0

	take_name:            
	                      MOV  AH, 8                	; accepts the character from keyboard with echo and stores it in al register  ; read a character
	                      INT  21h
	                      cmp  cx,0
	                      jz   check_name           	; if cx=0(reading the first char from player->go check it is not digit or special)
	                      cmp  al,13
	                      jz   name_done
	                      cmp  al,8                 	;If Backspace pressed,  erase
	                      jz   Erase
	                      jmp  names_array
	                      jz   name_done
              
	Erase:                


	                      dec  SI
	                      mov  bx,si

	                      mov  Name1[bx],'$'        	;Puts '$' instead of last character typed
	                      mov  ah,2
	                      mov  dl,32

	                      INT  21H                  	;Draws empty space over the character we need to delete
	                      dec  cx
	                      dec  cursorX
	; set cursor position to the center of the screen
	                      mov  ah,2                 	;set cursor position
	                      mov  bh,0                 	;page 0
	                      mov  dl,cursorX           	; x=9  center column position
	                      mov  dh,10                	; y=9 center row position
	                      int  10h
	; jmp  take_name
                 
	; check that the user doesn't start with a digit or a special char

	check_name:           

	                      cmp  al,41h               	;ascii for A
	                      jb   take_name            	;jump if below 41h
	                      cmp  al,7ah               	;ascii for z
	                      ja   take_name            	;jump if above  7ah   //////

	                      cmp  al,90                	; 90 is the ascii for Z letter (91 is special, 90 is not)
	                      ja   complete_reading_name
	                      jmp  names_array

	complete_reading_name:
	                      cmp  al,97
	                      jb   take_name
              
	; continue loop is entered if the first char is not special

	names_array:          
	                      MOV  AH, 2                	; display the character stored in dl
	                      MOV  DL, al
	                      INT  21H
	                      mov  Name1[SI],al
                   	
	                      inc  si
	                      inc  cx
	                      inc  cursorx
	                      cmp  cx,15
	                      jnz  take_name

	name_done:            


	; set cursor position to the next line still at the center of the screen
	                      mov  ah,2                 	;set cursor position
	                      mov  bh,0                 	;page 0
	                      mov  dl,9                 	; x=9  center column position
	                      mov  dh,11                	; y=11  center row position
	                      int  10h

	; display the second message (press any key to continue)
	                      mov  ah,9
	                      lea  dx,msg2              	; move the offset msg1 to dx
	                      int  21h

	;get key pressed (wait for the key)
	                      mov  ah,0
	                      int  16h
	                      mov  ax,12h
	                      int  10h

	; set cursor position to the center of the screen
	                      mov  ah,2                 	;set cursor position
	                      mov  bh,0                 	;page 0
	                      mov  dl,9                 	; x=9  center column position
	                      mov  dh,9                 	; y=9 center row position
	                      int  10h

	; display the second screen messages (3 options)
	                      mov  ah,9
	                      lea  dx,Option1
	                      int  21h

	; set cursor position to the next line of the screen
	                      mov  ah,2                 	;set cursor position
	                      mov  bh,0                 	;page 0
	                      mov  dl,9                 	; x=9  center column position
	                      mov  dh,10                	; y=10 center row position
	                      int  10h

	                      mov  ah,9
	                      lea  dx,Option2
	                      int  21h

	; set cursor position to the next line of the screen
	                      mov  ah,2                 	;set cursor position
	                      mov  bh,0                 	;page 0
	                      mov  dl,9                 	; x=9  center column position
	                      mov  dh,11                	; y=11 center row position

	                      int  10h
	                      mov  ah,9
	                      lea  dx,Option3
	                      int  21h

	                      ret
MainMenu endp

Play proc near
	;Call FirstPowerSpawnTime
	CheckTime:            
	                      call FireBullets
	                      call MoveJets
                                   
	                      mov  ah,2ch               	;get system time
	                      int  21h                  	;CH = hour, CL = minute, DH = second, DL = millisecond
	                      cmp  dl,LastTime          	;is current time = previous time?
	                      je   CheckTime            	;if yes, check again later
	                      mov  LastTime,dl          	;update last time
	
	                      mov  AX,4F02h
						  mov  bx,101h
	                      int  10h                  	;graph 640x480   256 colors
                                   
	                      call AdvanceBullets

	                      call DisplayNames
	                      call DrawLives
	                      call DrawJets
	                      call DrawBullets
			  
						  call PowerPosition
						  call DrawPower

	                      cmp  Won,0
	                      jz   CheckTime            	;If no winner yet, continue game loop

	                      call EndGame              	;Else, end the game
	                      ret
Play endp