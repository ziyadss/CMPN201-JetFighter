MoveJets proc near
	;--------LEFT Jet Movement---------------
	;check if any key is pressed(Y-> continue N-> Check other Jet)
	                               mov  ah,01h
	                               int  16h
	                               jz   LR1                           	;if ZF=1 JZ->Jump if Zero to next Jet // if ZF=0 a key is pressed (check which key)

	;check which key is pressed-After Excution (ah=scancode)
	;if it's 'W' or 'w' move left jet Up
	                               cmp  ah, 11h                       	;'w'/'W'
	                               je   Move_Left_Jet_Up

	;if it's 'S' or 's' move left jet Down
	                               cmp  ah, 1Fh                       	;'s'/'S'
	                               je   Move_Left_Jet_Down

	;if it's 'A' or 'a' move left jet Left
	                               cmp  ah, 1Eh                       	;'a'/'A'
	                               je   Move_Left_Jet_Left

	;if it's 'D' or 'd' move left jet Right
	                               cmp  ah, 20h                       	;'d'/'D'
	                               je   Move_Left_Jet_Right

	LR1:                           jmp  Check_Right_Jet_Movement

	Move_Left_Jet_Up:            ;Move Left Jet upwards  
	                               call Empty_Buffer
								   cmp  Jet1Z,-1  						;check if the Jet's orientation is like the key press(Up)
								   je	Move_Left_Up					;if Y-> move jet , N-> set the jet's orientation (Z) to -1 (Up) then move
								   mov  Jet1Z,-1 
			Move_Left_Up:		   mov  ax,JetV
	                               sub  Jet1Y,ax

	                               mov  ax,Window_Bounds              	;To make sure that the when the left jet moves up it doesn't move past the window
	                               cmp  Jet1Y,ax
	                               jl   Fix_Jet_Left_Top_Position
	                               jmp  Check_Right_Jet_Movement

		Fix_Jet_Left_Top_Position:     
	                               mov  ax,Window_Bounds
	                               mov  Jet1Y,ax
	                               jmp  Check_Right_Jet_Movement

	Move_Left_Jet_Down:            
	                               call Empty_Buffer
								   cmp  Jet1Z,1  						;check if the Jet's orientation is like the key press(Down)
								   je	Move_Left_Down					;if Y-> move jet , N-> set the jet's orientation (Z) to 1 (Down) then move
								   mov  Jet1Z,1 
			Move_Left_Down:		   mov  ax,JetV
	                               add  Jet1Y,ax

	                               mov  ax,Window_Height              	;To make sure that the when the left jet moves Down it doesn't move past the window
	                               sub  ax,Window_Bounds
	                               sub  ax,JetH
	                               cmp  Jet1Y,ax
	                               jg   Fix_Jet_Left_Bottom_Position
	                               jmp  Check_Right_Jet_Movement

		Fix_Jet_Left_Bottom_Position:  
	                               mov  Jet1Y,ax
	                               jmp  Check_Right_Jet_Movement


	Move_Left_Jet_Left:            
	                               Call Empty_Buffer
								   cmp  Jet1Z,-2  						;check if the Jet's orientation is like the key press(Left)
								   je	Move_Left_Left					;if Y-> move jet , N-> set the jet's orientation (Z) to -2 (Left) then move
								   mov  Jet1Z,-2 
			Move_Left_Left:		   mov  ax,JetV
	                               sub  Jet1X,ax

	                               mov  ax,Window_Bounds
	                               cmp  Jet1X,ax
	                               jl   Fix_Jet_Left_Left_Position
	                               jmp  Check_Right_Jet_Movement
		Fix_Jet_Left_Left_Position:    
	                               mov  jet1X,ax
	                               jmp  Check_Right_Jet_Movement

    
	Move_Left_Jet_Right:           
	                               Call Empty_Buffer
								   cmp  Jet1Z,2  						;check if the Jet's orientation is like the key press(Right)
								   je	Move_Left_Right					;if Y-> move jet , N-> set the jet's orientation (Z) to 2 (Right) then move
								   mov  Jet1Z,2 
			Move_Left_Right:	   mov  ax,JetV
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


	            
	                               ret
MoveJets endp

Check_Right_Jet_Movement_Proc proc near

	;if it's 'Up arrow' move right jet Up
	                               cmp  ah, 48h                       	;'Up'
	                               je   Move_Right_Jet_Up

	;if it's 'Down arrow' move right jet Down
	                               cmp  ah, 50h                       	;'Down'
	                               je   Move_Right_Jet_Down

	;if it's 'Left arrow' move right jet Left
	                               cmp  ah, 4Bh                       	;'Left'
	                               je   Move_Right_Jet_Left

	;if it's 'Right arrow' move right jet Right
	                               cmp  ah, 4Dh                       	;'Right'
	                               je   Move_Right_Jet_Right

	                               jmp  Exit_Jet_Movement

	Move_Right_Jet_Up:             

	                               Call Empty_Buffer			;Remove Jet from buffer before moving the jet
								   cmp  Jet2Z,-1  						;check if the Jet's orientation is like the key press(Up)
								   je	Move_Right_Up					;if Y-> move jet , N-> set the jet's orientation (Z) to -1 (Up) then move
								   mov  Jet2Z,-1 
			Move_Right_Up:		   mov  ax,JetV
	                               sub  Jet2Y,ax

	                               mov  ax,Window_Bounds              	;To make sure that the when the left jet moves up it doesn't move past the window
	                               cmp  Jet2Y,ax
	                               jl   Fix_Jet_Right_Top_Position
	                               jmp  Exit_Jet_Movement

		Fix_Jet_Right_Top_Position:    
	                               mov  ax,Window_Bounds
	                               mov  Jet2Y,ax
	                               jmp  Exit_Jet_Movement

	Move_Right_Jet_Down:           

	                               Call Empty_Buffer
								   cmp  Jet2Z,1  						;check if the Jet's orientation is like the key press(Down)
								   je	Move_Right_Down					;if Y-> move jet , N-> set the jet's orientation (Z) to 1 (Down) then move
								   mov  Jet2Z,1 
			Move_Right_Down: 	   mov  ax,JetV
	                               add  Jet2Y,ax

	                               mov  ax,Window_Height              	;To make sure that the when the left jet moves Down it doesn't move past the window
	                               sub  ax,Window_Bounds
	                               sub  ax,JetH
	                               cmp  Jet2Y,ax
	                               jg   Fix_Jeft_Right_Bottom_Position
	                               jmp  Exit_Jet_Movement

		Fix_Jeft_Right_Bottom_Position:
	                               mov  Jet2Y,ax
	                               jmp  Exit_Jet_Movement

	Move_Right_Jet_Left:           
	                               Call Empty_Buffer
								   cmp  Jet2Z,-2  						;check if the Jet's orientation is like the key press(Left)
								   je	Move_Right_Left					;if Y-> move jet , N-> set the jet's orientation (Z) to -2 (Left) then move
								   mov  Jet2Z,-2 
			Move_Right_Left:	   mov  ax,JetV
	                               sub  Jet2X,ax

	                               mov  ax,Window_Bounds
	                               add  ax,JetW
	                               cmp  Jet2X,ax
	                               jl   Fix_Jet_Right_Left_Position
	                               jmp  Exit_Jet_Movement
		Fix_Jet_Right_Left_Position:   
	                               mov  jet2X,ax
	                               jmp  Exit_Jet_Movement
    
	Move_Right_Jet_Right:          
	                               Call Empty_Buffer
								   cmp  Jet2Z,2  						;check if the Jet's orientation is like the key press(Right)
								   je	Move_Right_Right					;if Y-> move jet , N-> set the jet's orientation (Z) to 2 (Right) then move
								   mov  Jet2Z,2 
			Move_Right_Right:	   mov  ax,JetV
	                               add  Jet2X,ax

	                               mov  ax,Window_Width               	;To make sure that the when the left jet moves Down it doesn't move past the window
	                               sub  ax,Window_Bounds
	                               cmp  Jet2X,ax
	                               jg   Fix_Jet_Right_Right_Position
	                               jmp  Exit_Jet_Movement
		Fix_Jet_Right_Right_Position:  
	                               mov  Jet2X,ax
	                               jmp  Exit_Jet_Movement
	Exit_Jet_Movement:             
	                               
								   ret
Check_Right_Jet_Movement_Proc endp

DrawJets proc near
                         
	                               mov  ax,0c0fh                      	;drawing configuration
	;-------------------Left-------------

	                               mov  cx,Jet1X                      	;cx has starting x coordinate (left-most point)
	                               mov  dx,Jet1Y                      	;dx has ending y coordinate (highest point)
	                               add  dx,JetH                       	;dx now has starting y coordinate (lowest point)
    
	                               mov  bx,Jet1X
	                               add  bx,JetW                       	;bx now has ending x coordinate (right-most point)
    
	height1:                       
	                               push cx                            	;stores column (x coordinate) we started drawing line on
	wid1:                          
	                               int  10h
	                               inc  cx
	                               cmp  cx,bx
	                               jnz  wid1                          	;loop draws line from cx to bx (start to end)
        
	                               dec  bx                            	;decrement ending x coordinate
	                               pop  cx                            	;reset cx to starting x coordinate
	                               inc  cx                            	;increment it to draw next line from next point
	                               dec  dx                            	;decrement y coordinate (go up to draw line above)
	                               cmp  dx,Jet1Y
	                               jnz  height1                       	;loop draws triangle
        
	                               dec  cx                            	;decrement column to be on center of jet
	                               mov  bx,dx
	                               sub  bx,3                          	;store ending row of cannnon in bx (3 steps above current dx)
	gun1:                          
	                               int  10h
	                               dec  dx
	                               cmp  dx,bx
	                               jnz  gun1                          	;loop draws cannon

	;-------------------Right-------------
	                               mov  cx,Jet2X
	                               mov  dx,Jet2Y
	                               add  dx,JetH
    
	                               mov  bx,Jet2X
	                               add  bx,JetW
    
	height2:                       
	                               push cx
	wid2:                          
	                               int  10h
	                               inc  cx
	                               cmp  cx,bx
	                               jnz  wid2
        
	                               dec  bx
	                               pop  cx
	                               inc  cx
	                               dec  dx
	                               cmp  dx,Jet2Y
	                               jnz  height2
        
	                               dec  cx
	                               mov  bx,dx
	                               sub  bx,3
	gun2:                          
	                               int  10h
	                               dec  dx
	                               cmp  dx,bx
	                               jnz  gun2
	                               ret
DrawJets endp

Draw_Jets proc near

	;-------------------Left-------------

	                               MOV  CX, Jet1X
	                               MOV  DX, Jet1Y
	                               MOV  BX, DX

	DRAW_LEFT_JET:                 
	                               MOV  AH,0ch
	                               MOV  AL,08h
	                               INT  10h
	                               INC  DX
	                               MOV  AX, DX
	                               SUB  AX, Jet1Y
	                               CMP  AX, JetH
	                               JNG  DRAW_LEFT_JET
	                               MOV  DX, BX
	                               INC  DX
	                               MOV  BX, DX
	                               INC  CX
	                               MOV  AX, DX
	                               SUB  AX, Jet1Y
	                               CMP  AX, JetH
	                               JNG  DRAW_LEFT_JET

	LINE:                          
	                               MOV  AH,0ch
	                               MOV  AL,0fh
	                               INT  10H
	                               INC  CX
	                               MOV  AX, CX
	                               SUB  AX, Jet1X
	                               CMP  AX, JetW
	                               JNG  LINE

	;-------------------Right-------------
	;-------------------------------------------

	                               MOV  CX, Jet2X
	                               MOV  DX, Jet2Y
	                               MOV  BX, DX

	DRAW_RIGHT_JET:                
	                               MOV  AH,0ch
	                               MOV  AL,04h
	                               INT  10h
	                               INC  DX
	                               MOV  AX, DX
	                               SUB  AX, Jet2Y
	                               CMP  AX, JetH
	                               JNG  DRAW_RIGHT_JET
	                               MOV  DX, BX
	                               INC  DX
	                               MOV  BX, DX
	                               DEC  CX
	                               MOV  AX, DX
	                               SUB  AX, Jet2Y
	                               CMP  AX, JetH
	                               JNG  DRAW_RIGHT_JET

	LINE_2:                        
	                               MOV  AH,0ch
	                               MOV  AL,0fh
	                               INT  10H
	                               DEC  CX
	                               MOV  AX, Jet2X
	                               SUB  AX, CX
	                               CMP  AX, JetW
	                               JNG  LINE_2
	                               ret
Draw_Jets endp

Empty_Buffer proc near
		mov  ah,00h
		int  16h
	ret
Empty_Buffer endp