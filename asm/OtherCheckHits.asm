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
