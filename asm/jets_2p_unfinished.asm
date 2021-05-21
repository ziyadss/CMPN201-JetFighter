MoveJets proc near 
	;--------LEFT Jet Movement---------------
	;check if any key is pressed(Y-> continue N-> Check other Jet)
	                               mov  ah,01h
	                               int  16h
	                               jnz sendove
								   mov dx,3fdh
	in al,dx
	test al,1
	jz Done
    mov dx , 03F8H
	in al , dx 
	mov ah , al
	jmp dontsendove
								   
		


	;check which key is pressed-After Excution (ah=scancode) ; remove from buffer
						sendove:			mov  ah,00h
									int  16h
	

	mov dx , 3F8H		; Transmit data register
    mov al,ah
  	out dx , al 

cmp ah,46d
									je Done
									cmp ah,50d
									je Done

	dontsendove:
	;-------- JET 1 Freeze-----------
									cmp Jet2Power,5
									je Check_Right_Jet_Movement

	;check if power up is speedup velocity for jet1
									cmp Jet1Power,2
									jne Check_Dizzy
									Mov Dx, Jet1V
									add Dx, speedUpVelocity
									mov Jet1V, Dx

	;Check if the Powerup dizzy is On Y->flip moves N-> use Normal Moves
Check_Dizzy:					   cmp  Jet2Power, 3
								   jne	Normal1
					;if keypress "W"=Up   make it Down
									cmp  ah, 11h  		
									je   Move_Left_Jet_Down 
					;if keypress "S"=Down   make it Up
									cmp  ah, 1Fh
									je   Move_Left_Jet_Up

					;if keypress "A"=Left   make it Right
									cmp  ah, 1Eh
									je   Move_Left_Jet_Right_PASS
					;if keypress "D"=Right   make it Left
									cmp  ah, 20h
									je   Move_Left_Jet_Left

	;if it's 'W' or 'w' move left jet Up
	 Normal1:                       cmp  ah, 11h                       	;'w'/'W'
	                               je   Move_Left_Jet_Up

	;if it's 'S' or 's' move left jet Down
	                               cmp  ah, 1Fh                       	;'s'/'S'
	                               je   Move_Left_Jet_Down

	;if it's 'A' or 'a' move left jet Left
	                               cmp  ah, 1Eh                       	;'a'/'A'
	                               je   Move_Left_Jet_Left

	;if it's 'D' or 'd' move left jet Right
	                               cmp  ah, 20h                       	;'d'/'D'
	Move_Left_Jet_Right_PASS:      je   Move_Left_Jet_Right

							   
	LR1:                           jmp  Check_Right_Jet_Movement

	Move_Left_Jet_Up:            ;Move Left Jet upwards  
								   cmp  Jet1Z,-1  						;check if the Jet's orientation is like the key press(Up)
								   je	Move_Left_Up					;if Y-> move jet , N-> set the jet's orientation (Z) to -1 (Up) then move
								   mov  Jet1Z,-1 
			Move_Left_Up:		   mov  ax,Jet1V
	                               sub  Jet1Y,ax

	                               mov  ax,Window_Score              	;To make sure that the when the left jet moves up it doesn't move past the window
	                               cmp  Jet1Y,ax
	                               jl   Fix_Jet_Left_Top_Position
	                               jmp  Check_Right_Jet_Movement

		Fix_Jet_Left_Top_Position:     
	                               mov  ax,Window_Score
	                               mov  Jet1Y,ax
	                               jmp  Check_Right_Jet_Movement

	Move_Left_Jet_Down:            
								   cmp  Jet1Z,1  						;check if the Jet's orientation is like the key press(Down)
								   je	Move_Left_Down					;if Y-> move jet , N-> set the jet's orientation (Z) to 1 (Down) then move
								   mov  Jet1Z,1 
			Move_Left_Down:		   mov  ax,Jet1V
	                               add  Jet1Y,ax

	                               mov  ax,Window_Height              	;To make sure that the when the left jet moves Down it doesn't move past the window
	                               sub  ax,Window_Bounds
								   sub  ax,Window_Status_Bar
	                               sub  ax,JetH
	                               cmp  Jet1Y,ax
	                               jg   Fix_Jet_Left_Bottom_Position
	                               jmp  Check_Right_Jet_Movement

		Fix_Jet_Left_Bottom_Position:  
	                               mov  Jet1Y,ax
	                               jmp  Check_Right_Jet_Movement


	Move_Left_Jet_Left:            
								   cmp  Jet1Z,-2  						;check if the Jet's orientation is like the key press(Left)
								   je	Move_Left_Left					;if Y-> move jet , N-> set the jet's orientation (Z) to -2 (Left) then move
								   mov  Jet1Z,-2 
			Move_Left_Left:		   mov  ax,Jet1V
	                               sub  Jet1X,ax

	                               mov  ax,Window_Bounds
	                               cmp  Jet1X,ax
	                               jl   Fix_Jet_Left_Left_Position
	                               jmp  Check_Right_Jet_Movement
		Fix_Jet_Left_Left_Position:    
	                               mov  jet1X,ax
	                               jmp  Check_Right_Jet_Movement

    
	Move_Left_Jet_Right:           
								   cmp  Jet1Z,2  						;check if the Jet's orientation is like the key press(Right)
								   je	Move_Left_Right					;if Y-> move jet , N-> set the jet's orientation (Z) to 2 (Right) then move
								   mov  Jet1Z,2 
			Move_Left_Right:	   mov  ax,Jet1V
	                               add  Jet1X,ax

	                               mov  ax,Window_Width               	;To make sure that the when the left jet moves Down it doesn't move past the window
	                               sub  ax,Window_Bounds
	                               sub  ax,JetW
	                               cmp  Jet1X,ax
	                               jg   Fix_Jet_Left_Right_Position
	                               jmp  Check_Right_Jet_Movement
		Fix_Jet_Left_Right_Position:   
	                               mov  Jet1X,ax
	                               jmp  Check_Right_Jet_Movement

	;--------Right Jet Movement---------------
	Check_Right_Jet_Movement:      
	                               Call Check_Right_Jet_Movement_Proc


	            					MOV Jet1V, 4
									Mov Jet2V, 4
	                                Done: ret
MoveJets endp

Check_Right_Jet_Movement_Proc proc near

;-------- JET 2	 Freeze-----------
cmp Jet1Power,5
je Exit_Jet_Movement

;check if power up is speedup velocity for jet2
									cmp Jet2Power,2
									jne Check_Dizzy2
									Mov Dx, Jet2V
									add Dx, speedUpVelocity
									mov Jet2V, Dx

	;Check if the Powerup dizzy is On Y->flip moves N-> use Normal Moves
Check_Dizzy2:					   cmp  Jet1Power, 3
								   jne	Normal2
					;if keypress Up   make it Down
									cmp  ah, 48h  		
									je   Move_Right_Jet_Down 
					;if keypress Down   make it Up
									cmp  ah, 50h
									je   Move_Right_Jet_Up

					;if keypress Left   make it Right
									cmp  ah, 4Bh
									je   Move_To_Right
					;if keypress Right   make it Left
									cmp  ah, 4Dh
									je   Move_Right_Jet_Left


	;if it's 'Up arrow' move right jet Up
	 Normal2:                      cmp  ah, 48h                       	;'Up'
	                               je   Move_Right_Jet_Up

	;if it's 'Down arrow' move right jet Down
	                               cmp  ah, 50h                       	;'Down'
	                               je   Move_Right_Jet_Down

	;if it's 'Left arrow' move right jet Left
	                               cmp  ah, 4Bh                       	;'Left'
	                               je   Move_Right_Jet_Left

	;if it's 'Right arrow' move right jet Right
	                               cmp  ah, 4Dh                       	;'Right'
	                               je   Move_To_Right

	                               jmp  Exit_Jet_Movement

	Move_Right_Jet_Up:             

								   cmp  Jet2Z,-1  						;check if the Jet's orientation is like the key press(Up)
								   je	Move_Right_Up					;if Y-> move jet , N-> set the jet's orientation (Z) to -1 (Up) then move
								   mov  Jet2Z,-1 
			Move_Right_Up:		   mov  ax,Jet2V
	                               sub  Jet2Y,ax

	                               mov  ax,Window_Score              	;To make sure that the when the left jet moves up it doesn't move past the window
	                               cmp  Jet2Y,ax
	                               jl   Fix_Jet_Right_Top_Position
	                               jmp  Exit_Jet_Movement

		Fix_Jet_Right_Top_Position:    
	                               mov  ax,Window_Score
	                               mov  Jet2Y,ax
	                               jmp  Exit_Jet_Movement
		
		Move_To_Right: 
						jmp Move_Right_Jet_Right

	Move_Right_Jet_Down:           
								   cmp  Jet2Z,1  						;check if the Jet's orientation is like the key press(Down)
								   je	Move_Right_Down					;if Y-> move jet , N-> set the jet's orientation (Z) to 1 (Down) then move
								   mov  Jet2Z,1 
			Move_Right_Down: 	   mov  ax,Jet2V
	                               add  Jet2Y,ax

	                               mov  ax,Window_Height              	;To make sure that the when the left jet moves Down it doesn't move past the window
	                               sub  ax,Window_Bounds
								   sub  ax,Window_Status_Bar
	                               sub  ax,JetH
	                               cmp  Jet2Y,ax
	                               jg   Fix_Jeft_Right_Bottom_Position
	                               jmp  Exit_Jet_Movement

		Fix_Jeft_Right_Bottom_Position:
	                               mov  Jet2Y,ax
	                               jmp  Exit_Jet_Movement

	Move_Right_Jet_Left:           
								   cmp  Jet2Z,-2  						;check if the Jet's orientation is like the key press(Left)
								   je	Move_Right_Left					;if Y-> move jet , N-> set the jet's orientation (Z) to -2 (Left) then move
								   mov  Jet2Z,-2 
			Move_Right_Left:	   mov  ax,Jet2V
	                               sub  Jet2X,ax

	                               mov  ax,Window_Bounds
	                               cmp  Jet2X,ax
	                               jl   Fix_Jet_Right_Left_Position
	                               jmp  Exit_Jet_Movement
		Fix_Jet_Right_Left_Position:   
	                               mov  jet2X,ax
	                               jmp  Exit_Jet_Movement
    
	Move_Right_Jet_Right:          
								   cmp  Jet2Z,2  						;check if the Jet's orientation is like the key press(Right)
								   je	Move_Right_Right					;if Y-> move jet , N-> set the jet's orientation (Z) to 2 (Right) then move
								   mov  Jet2Z,2 
			Move_Right_Right:	   mov  ax,Jet2V
	                               add  Jet2X,ax

	                               mov  ax,Window_Width               	;To make sure that the when the left jet moves Down it doesn't move past the window
	                               sub  ax,Window_Bounds
								   sub  ax, JetW
	                               cmp  Jet2X,ax
	                               jg   Fix_Jet_Right_Right_Position
	                               jmp  Exit_Jet_Movement
		Fix_Jet_Right_Right_Position:  
	                               mov  Jet2X,ax
	                               jmp  Exit_Jet_Movement
	Exit_Jet_Movement:             
	                               
								   ret
Check_Right_Jet_Movement_Proc endp

DrawJets PROC near

			XOR SI,SI			;Set SI 0


			MOV CX, Jet1X
			MOV DX, Jet1Y
			MOV BX, DX
			MOV DI, JetH
			
			CMP Jet1Z,-2
			JE DRAW_LEFT
			
			CMP Jet1Z,2
			JE DRAW_RIGHT

			CMP Jet1Z,-1
			JE DRAW_UP
			
			CMP Jet1Z,1
			JE DRAW_DOWN

			CALL DRAW_RIGHT_JET_PROC

			
		;----------------------------------RIGHT-------------------------------------------------
			DRAW_RIGHT:                     ;DRAW JET DIRECTED TOWARD RIGHT POSITION
				MOV AH,0ch
				MOV AL,Colour1
				INT 10h
				INC DX
				MOV AX, DX
				SUB AX, Jet1Y
				CMP AX, DI
				JNG DRAW_RIGHT
				MOV DX, BX
				INC DX
				MOV BX, DX
				INC CX
				MOV AX, DX
				DEC DI
				SUB AX, Jet1Y
				CMP AX, DI
				JNG DRAW_RIGHT
				DEC DX
				
				LINE_RIGHT:
				MOV AH,0ch
				MOV AL,Colour1
				INT 10H
				INC CX 
				MOV AX, CX
				SUB AX, Jet1X
				CMP AX, JetW
				JNG LINE_RIGHT 
				CAll DRAW_RIGHT_JET_PROC
				RET
				
				DRAW_DOWN:     ; Double jump ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				jmp DRAW_DOWN2

				DRAW_UP:        ; Double jump ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				JMP DRAW_UP2

		;----------------------------LEFT---------------------------------------
			DRAW_LEFT:
				ADD CX, JetW           ;CHANGE COORDINATE TO DRAW JETS IN THE SAME AREA IN ALL PRIANTATIONS
				MOV BP, CX                  ; STORE THE CX WHERE IT STARTS DRAWING

				DRAW_LEFT_ORIANTATION:                  ;DRAW JET DIRACTED TOWARD LEFT
				MOV AH,0ch
				MOV AL,Colour1
				INT 10h
				INC DX
				MOV AX, DX
				SUB AX, Jet1Y
				CMP AX, DI
				JNG DRAW_LEFT_ORIANTATION
				MOV DX, BX
				INC DX
				MOV BX, DX
				DEC CX
				MOV AX, DX
				DEC DI 
				SUB AX, Jet1Y
				CMP AX, DI
				JNG DRAW_LEFT_ORIANTATION
				DEC DX

			LINE_LEFT:
				MOV AH,0ch
				MOV AL,Colour1
				INT 10H
				DEC CX 
				MOV AX, BP
				SUB AX, CX
				CMP AX, JetW
				JNG LINE_LEFT
				CAll DRAW_RIGHT_JET_PROC
				RET
		;------------------------------UP---------------------------
			DRAW_UP2:
				ADD DX, JetW           
				MOV BX, CX 
				MOV BP, DX              

				DRAW_UP_ORIANTATION:                  
				MOV AH,0ch
				MOV AL,Colour1
				INT 10h
				INC CX
				MOV AX, CX
				SUB AX, Jet1X
				CMP AX, DI
				JNG DRAW_UP_ORIANTATION
				MOV CX, BX
				INC CX
				MOV BX, CX
				DEC DX
				MOV AX, CX
				DEC DI 
				SUB AX, Jet1X
				CMP AX, DI
				JNG DRAW_UP_ORIANTATION
				DEC CX

			LINE_UP:
				MOV AH,0ch
				MOV AL,Colour1
				INT 10H
				DEC DX 
				MOV AX, BP
				SUB AX, DX
				CMP AX, JetW
				JNG LINE_UP
				CAll DRAW_RIGHT_JET_PROC
				RET
		;----------------------DOWN--------------------------------------------
			DRAW_DOWN2:
				MOV BX,CX

			DRAW_DOWN_ORINTATION:                     

				MOV AH,0ch
				MOV AL,Colour1
				INT 10h
				INC CX
				MOV AX, CX
				SUB AX, Jet1X
				CMP AX, DI
				JNG DRAW_DOWN_ORINTATION
				MOV CX, BX
				INC CX
				MOV BX, CX
				INC DX
				MOV AX, CX
				DEC DI
				SUB AX, Jet1X
				CMP AX, DI
				JNG DRAW_DOWN_ORINTATION
				DEC CX
				
			LINE_DOWN:
				MOV AH,0ch
				MOV AL,Colour1
				INT 10H
				INC DX 
				MOV AX, DX
				SUB AX, Jet1Y
				CMP AX, JetW
				JNG LINE_DOWN

				CAll DRAW_RIGHT_JET_PROC
				RET

			

		RET
DrawJets ENDP


;----------------------RIGHT JET DRAWING--------------------------------------------

DRAW_RIGHT_JET_PROC proc near

		RIGHT_CHECK:
	    MOV CX, Jet2X
        MOV DX, Jet2Y
        MOV BX, DX
        MOV DI, JetH

        CMP Jet2Z,-2
        JE RIGHT_DRAW_LEFT
        
        CMP Jet2Z,2
        JE RIGHT_DRAW_RIGHT

        CMP Jet2Z,-1
        JE RIGHT_DRAW_UP
        
        CMP Jet2Z,1
        JE RIGHT_DRAW_DOWN
    
;----------------------------------RIGHT-------------------------------------------------
    RIGHT_DRAW_RIGHT:                     ;DRAW JET DIRECTED TOWARD RIGHT POSITION
        MOV AH,0ch
        MOV AL,Colour2
        INT 10h
        INC DX
        MOV AX, DX
        SUB AX, Jet2Y
        CMP AX, DI
        JNG RIGHT_DRAW_RIGHT
        MOV DX, BX
        INC DX
        MOV BX, DX
        INC CX
        MOV AX, DX
        DEC DI
        SUB AX, Jet2Y
        CMP AX, DI
        JNG RIGHT_DRAW_RIGHT
        DEC DX
        
     RIGHT_LINE_RIGHT:
        MOV AH,0ch
        MOV AL,Colour2
        INT 10H
        INC CX 
        MOV AX, CX
        SUB AX, Jet2X
        CMP AX, JetW
        JNG RIGHT_LINE_RIGHT 
		INC SI
		CMP SI,2
		;JE RIGHT_CHECK
        RET
        
	RIGHT_DRAW_DOWN:     ; Double jump ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	jmp RIGHT_DRAW_DOWN2

	RIGHT_DRAW_UP:        ; Double jump ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	JMP RIGHT_DRAW_UP2

;----------------------------LEFT---------------------------------------
RIGHT_DRAW_LEFT:
    ADD CX, JetW           ;CHANGE COORDINATE TO DRAW JETS IN THE SAME AREA IN ALL PRIANTATIONS
    MOV BP, CX                  ; STORE THE CX WHERE IT STARTS DRAWING

    RIGHT_DRAW_LEFT_ORIANTATION:                  ;DRAW JET DIRACTED TOWARD LEFT
        MOV AH,0ch
        MOV AL,Colour2
        INT 10h
        INC DX
        MOV AX, DX
        SUB AX, Jet2Y
        CMP AX, DI
        JNG RIGHT_DRAW_LEFT_ORIANTATION
        MOV DX, BX
        INC DX
        MOV BX, DX
        DEC CX
        MOV AX, DX
        DEC DI 
        SUB AX, Jet2Y
        CMP AX, DI
        JNG RIGHT_DRAW_LEFT_ORIANTATION
        DEC DX

     RIGHT_LINE_LEFT:
        MOV AH,0ch
        MOV AL,Colour2
        INT 10H
        DEC CX 
        MOV AX, BP
        SUB AX, CX
        CMP AX, JetW
        JNG RIGHT_LINE_LEFT
        RET
;------------------------------UP---------------------------
RIGHT_DRAW_UP2:
    ADD DX, JetW           
    MOV BX, CX 
    MOV BP, DX              

    RIGHT_DRAW_UP_ORIANTATION:                  
        MOV AH,0ch
        MOV AL,Colour2
        INT 10h
        INC CX
        MOV AX, CX
        SUB AX, Jet2X
        CMP AX, DI
        JNG RIGHT_DRAW_UP_ORIANTATION
        MOV CX, BX
        INC CX
        MOV BX, CX
        DEC DX
        MOV AX, CX
        DEC DI 
        SUB AX, Jet2X
        CMP AX, DI
        JNG RIGHT_DRAW_UP_ORIANTATION
        DEC CX

     RIGHT_LINE_UP:
        MOV AH,0ch
        MOV AL,Colour2
        INT 10H
        DEC DX 
        MOV AX, BP
        SUB AX, DX
        CMP AX, JetW
        JNG RIGHT_LINE_UP
        RET
;----------------------DOWN--------------------------------------------
RIGHT_DRAW_DOWN2:
    MOV BX,CX

 RIGHT_DRAW_DOWN_ORINTATION:                     

        MOV AH,0ch
        MOV AL,Colour2
        INT 10h
        INC CX
        MOV AX, CX
        SUB AX, Jet2X
        CMP AX, DI
        JNG RIGHT_DRAW_DOWN_ORINTATION
        MOV CX, BX
        INC CX
        MOV BX, CX
        INC DX
        MOV AX, CX
        DEC DI
        SUB AX, Jet2X
        CMP AX, DI
        JNG RIGHT_DRAW_DOWN_ORINTATION
        DEC CX
        
     RIGHT_LINE_DOWN:
        MOV AH,0ch
        MOV AL,Colour2
        INT 10H
        INC DX 
        MOV AX, DX
        SUB AX, Jet2Y
        CMP AX, JetW
        JNG RIGHT_LINE_DOWN
        RET

	ret
DRAW_RIGHT_JET_PROC endp
