CheckHit_Left proc near
	                   mov     di,1
	                   xor     si,si

					   mov     bp,bx			
					   
	                   mov     ax,Jet1X				; mov Jet X-coordinates to AX
	                   mov     cx,Jet1Y				; mov Jet Y-coordinates to CX
	                   
	CheckCollide_Left:      
	                   ;-------(Bullet-PointA)-----------
					   mov     bx,bp
	                   mov     dx,bulletsX[bx]
	                   mov     Vx,dx				;Vx=Curret Bullet's X
                 
	                   mov     dx,bulletsY[bx]
	                   mov     Vy,dx				;Vy=Current Bullet's Y
					   
	                   sub     Vx,ax				;Vx= BulletX-JetX
	                   sub     Vy,cx				;Vy= BulletY-JetY
						;-------(PointB-PointA)-----------
	                   mov     Wx,0					;Wx=0
	                   mov     Wy,JetH				;Wy=JetH
                 
	                   call    CrossProduct			;Call First Cross Product
                 
	                   push    cx
                 		
						;-------(Bullet-PointB)-----------
													;Vx= The Same (BulletX-JetX)
	                   sub     Vy,JetH				;Vy= BulletY-JetY-JetH
						;-------(PointC-PointB)-----------

	                   mov     Wx,-(JetH/2+1)		;?Wx= ..........
	                   mov     Wy,-JetH/2			;Wy= -JetH/2
                 
	                   call    CrossProduct			;Call 2nd Cross Product
                 
	                   pop     ax
                 
	                   mov     cl,7
	                   shr     ah,cl				;shift ah to get sign bit
	                   shr     ch,cl				;shift ch to get Sign bit
	                   cmp     ah,ch				;compare ch & ah if not equal (Diff Signs)->Outside triangle 
	                   jne     CollisionCheckDone_Left	;check is done
													;If equal (Can be inside the Triange ) need to check the last side 


	                   push    ax
					   ;-------(Bullet-PointC)-----------
	                   sub     Vx,JetH/2+1			;?Vx= The Same (BulletX-JetX) -
	                   add     Vy,JetH/2			;?Vy= BulletY-JetY-JetH/2
	                   neg     Wx					;Wx= -ve previous Wx
					   								;Wy= -JetH/2  Same Wy
                 
	                   call    CrossProduct			;Call 3rd Cross Product
                 
	                   pop     ax
                 
	                   mov     cl,7
	                   shr     ch,cl				;shift ch to get sign bit
	                   cmp     ah,ch				;compare ch & ah if not equal (Diff Signs)->Outside triangle 
	                   jne     CollisionCheckDone_Left	;check is done
													;If equal (Bullet is inside the Triange ) 
                 
	                   add     si,1
	                   cmp     di,1
	                   jne     HurtTwo_Left

	                   dec     Health1
	                   cmp     Health1,7
	                   jne     CollisionCheckDone_Left
	                   mov     Won,di
	                   jmp     CollisionCheckDone_Left
					   
	CheckCollide2_Left:     jmp     CheckCollide_Left
		
	HurtTwo_Left:           
	                   dec     Health2
	                   cmp     Health2,7
	                   jne     CollisionCheckDone_Left
	                   mov     Won,di
	                   jmp     CollisionCheckDone_Left
					   
	CollisionCheckDone_Left:
	                   inc     di
	                   cmp     di,2
	                   mov     ax,Jet2X
	                   mov     cx,Jet2Y
	                   je      CheckCollide2_Left
	                   ret
CheckHit_Left endp


CheckHit_UP proc near
	                   mov     di,1
	                   xor     si,si

					   mov     bp,bx			
					   
	                   mov     ax,Jet1X				; mov Jet X-coordinates to AX
	                   mov     cx,Jet1Y				; mov Jet Y-coordinates to CX
	                   
	CheckCollide_UP:      
	                   ;-------(Bullet-PointA)-----------
					   mov     bx,bp
	                   mov     dx,bulletsX[bx]
	                   mov     Vx,dx				;Vx=Curret Bullet's X
                 
	                   mov     dx,bulletsY[bx]
	                   mov     Vy,dx				;Vy=Current Bullet's Y
					   
	                   sub     Vx,ax				;Vx= BulletX-JetX
	                   sub     Vy,cx				;Vy= BulletY-JetY
						;-------(PointB-PointA)-----------
	                   mov     Wx,JetH				;Wx=JetH
	                   mov     Wy,0					;Wy=0
                 
	                   call    CrossProduct			;Call First Cross Product
                 
	                   push    cx
                 		
						;-------(Bullet-PointB)-----------
													;Vy= The Same (BulletY-JetY)
	                   sub     Vx,JetH				;Vx= BulletX-JetX-JetH
						;-------(PointC-PointB)-----------

	                   mov     Wx,-JetH/2			;?Wx= -JetH/2
	                   mov     Wy,-(JetH/2+1)		;Wy= ...?.....
                 
	                   call    CrossProduct			;Call 2nd Cross Product
                 
	                   pop     ax
                 
	                   mov     cl,7
	                   shr     ah,cl				;shift ah to get sign bit
	                   shr     ch,cl				;shift ch to get Sign bit
	                   cmp     ah,ch				;compare ch & ah if not equal (Diff Signs)->Outside triangle 
	                   jne     CollisionCheckDone_UP	;check is done
													;If equal (Can be inside the Triange ) need to check the last side 


	                   push    ax
					   ;-------(Bullet-PointC)-----------
	                   sub     Vx,JetH/2			;?Vx= The Same (BulletX-JetX) -
	                   add     Vy,JetH/2			;?Vy= BulletY-JetY-JetH/2 ---- need edit--------
	                   neg     Wy					;Wy= -ve previous Wy
					   								;Wx= -JetH/2  Same Wx
                 
	                   call    CrossProduct			;Call 3rd Cross Product
                 
	                   pop     ax
                 
	                   mov     cl,7
	                   shr     ch,cl				;shift ch to get sign bit
	                   cmp     ah,ch				;compare ch & ah if not equal (Diff Signs)->Outside triangle 
	                   jne     CollisionCheckDone_UP	;check is done
													;If equal (Bullet is inside the Triange ) 
                 
	                   add     si,1
	                   cmp     di,1
	                   jne     HurtTwo_UP 

	                   dec     Health1
	                   cmp     Health1,7
	                   jne     CollisionCheckDone_UP
	                   mov     Won,di
	                   jmp     CollisionCheckDone_UP
					   
	CheckCollide2_UP:     jmp     CheckCollide_UP
		
	HurtTwo_UP:           
	                   dec     Health2
	                   cmp     Health2,7
	                   jne     CollisionCheckDone_UP
	                   mov     Won,di
	                   jmp     CollisionCheckDone_UP
					   
	CollisionCheckDone_UP:
	                   inc     di
	                   cmp     di,2
	                   mov     ax,Jet2X
	                   mov     cx,Jet2Y
	                   je      CheckCollide2_UP
	                   ret
CheckHit_UP endp


CheckHit_Down proc near
	                   mov     di,1
	                   xor     si,si

					   mov     bp,bx			
					   
	                   mov     ax,Jet1X				; mov Jet X-coordinates to AX
	                   mov     cx,Jet1Y				; mov Jet Y-coordinates to CX
	                   
	CheckCollide_Down:      
	                   ;-------(Bullet-PointA)-----------
					   mov     bx,bp
	                   mov     dx,bulletsX[bx]
	                   mov     Vx,dx				;Vx=Curret Bullet's X
                 
	                   mov     dx,bulletsY[bx]
	                   mov     Vy,dx				;Vy=Current Bullet's Y
					   
	                   sub     Vx,ax				;Vx= BulletX-JetX
	                   sub     Vy,cx				;Vy= BulletY-JetY
						;-------(PointB-PointA)-----------
	                   mov     Wx,JetH				;Wx=JetH
	                   mov     Wy,0					;Wy=0
                 
	                   call    CrossProduct			;Call First Cross Product
                 
	                   push    cx
                 		
						;-------(Bullet-PointB)-----------
													;Vy= The Same (BulletY-JetY)
	                   sub     Vx,JetH				;Vx= BulletX-JetX-JetH
						;-------(PointC-PointB)-----------

	                   mov     Wx,-JetH/2			;?Wx= -JetH/2
	                   mov     Wy,(JetH/2+1)		;Wy= ...?.....
                 
	                   call    CrossProduct			;Call 2nd Cross Product
                 
	                   pop     ax
                 
	                   mov     cl,7
	                   shr     ah,cl				;shift ah to get sign bit
	                   shr     ch,cl				;shift ch to get Sign bit
	                   cmp     ah,ch				;compare ch & ah if not equal (Diff Signs)->Outside triangle 
	                   jne     CollisionCheckDone_Down	;check is done
													;If equal (Can be inside the Triange ) need to check the last side 


	                   push    ax
					   ;-------(Bullet-PointC)-----------
	                   sub     Vx,JetH/2			;?Vx= The Same (BulletX-JetX) -
	                   add     Vy,-(JetH/2+1)		;?Vy= BulletY-JetY-JetH/2 ---- need edit--------
	                   neg     Wy					;Wy= -ve previous Wy
					   								;Wx= -JetH/2  Same Wx
                 
	                   call    CrossProduct			;Call 3rd Cross Product
                 
	                   pop     ax
                 
	                   mov     cl,7
	                   shr     ch,cl				;shift ch to get sign bit
	                   cmp     ah,ch				;compare ch & ah if not equal (Diff Signs)->Outside triangle 
	                   jne     CollisionCheckDone_Down	;check is done
													;If equal (Bullet is inside the Triange ) 
                 
	                   add     si,1
	                   cmp     di,1
	                   jne     HurtTwo_Down

	                   dec     Health1
	                   cmp     Health1,7
	                   jne     CollisionCheckDone_Down
	                   mov     Won,di
	                   jmp     CollisionCheckDone_Down
					   
	CheckCollide2_Down:     jmp     CheckCollide_Down
		
	HurtTwo_Down:           
	                   dec     Health2
	                   cmp     Health2,7
	                   jne     CollisionCheckDone_Down
	                   mov     Won,di
	                   jmp     CollisionCheckDone_Down
					   
	CollisionCheckDone_Down:
	                   inc     di
	                   cmp     di,2
	                   mov     ax,Jet2X
	                   mov     cx,Jet2Y
	                   je      CheckCollide2_Down
	                   ret
CheckHit_Down endp


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