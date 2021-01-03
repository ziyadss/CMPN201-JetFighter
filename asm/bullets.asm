FireBullets proc near                                		;DOUBLE BULLETS
	                   mov     ax,@data
	                   mov     es,ax
	                   lea     di,bulletsZ               	;set ES:DI to bulletsZ location

	                   xor     ax,ax
	                   mov     cx, maxBullets
	                   repne   scasw                     	;Look for AX (=0) in bulletZ - an empty spot in the bullets array
	                   jnz     nofire                    	;if none found, exit the fire function

	                   mov     ah,1
	                   int     16h
	                   jz      nofire                    	;if no key pressed, exit the fire function
                   
	                   mov     bx,JetW/2
	                   mov     cx,JetH/2                 	;so bullet would be in center of jet

	                   cmp     ah,46d
	                   jz      jet1fire                  	;if 'C' pressed, jet 1 fires

	                   cmp     ah,50d
	                   jz      jet2fire                  	;if 'M' pressed, jet 2 fires
	                   jmp     exitfire                  	;else, a third key was pressed, so exit the fire function

	jet1fire:          
	                   cmp     Jet1Reload,0              	;check if jet reload time is 0
	                   jnz     nofire                    	;if not, exit the fire function
	                   add     bx,Jet1X                  	;jetX + Width/2 to be used as bulletX
	                   add     cx,Jet1Y                  	;jetY + Height/2 to be used as bulletY
	                   mov     dx,Jet1Z                  	;jet direction to be used as bullet direction
	                   mov     Jet1Reload,ReloadTime     	;set its reload time

	                   cmp     Jet1State,4               	;check is double bullet is on
	                   je      DoubleBulletAdjust        	;if yes, go adjust coordinates
	                   jmp     contfire                  	;if not, go fire the bullet
   
	jet2fire:          
	                   cmp     Jet2Reload,0
	                   jnz     nofire
	                   add     bx,Jet2X
	                   add     cx,Jet2Y
	                   mov     dx,Jet2Z
	                   mov     Jet2Reload,ReloadTime

	                   cmp     Jet2State,4
	                   je      DoubleBulletAdjust
	                   jmp     contfire

	nofire:            jmp     exitfire

	DoubleBulletAdjust:
	                   mov     ax,1                      	;if yes, set AX to remember to fire a second bullet
	                   test    dx,1                      	;test orientation, to correctly adjust bullet coordinates
	                   jnz     VerticalJetSub
	                   dec     cx                        	;move first bullet up if jet horizontal
	                   jmp     contfire

	VerticalJetSub:    
	                   dec     bx                        	;move first bullet left if jet vertical
	                   jmp     contfire
	
	contfire:          
	                   push    di
	                   sub     di,offset bulletsZ+2      	;set DI to a ptr at first empty spot in array
	                   mov     bulletsX[di],bx
	                   mov     bulletsY[di],cx
	                   mov     bulletsZ[di],dx           	;initialize bullet X,Y,Z
	                
	                   pop     di
	                   cmp     ax,1                      	;check if need to fire second bullet
	                   jne     fired                     	;if not, we're done

	                   test    dx,1                      	;test orientation, to correctly adjust bullet coordinates
	                   jnz     VerticalJetAdd

	                   add     cx,2                      	;move second bullet down if jet horizontal
	                   jmp     cont2ndBullAdd

	VerticalJetAdd:    
	                   add     bx,2                      	;move second bullet right if jet vertical
	
	cont2ndBullAdd:    
	                   xor     ax,ax
	                   push    cx
	                   mov     cx, maxBullets
	                   repne   scasw                     	;Look for AX (=0) in bulletZ - an empty spot in the bullets array
	                   pop     cx
	                   jnz     fired                     	;if none found, exit the fire function
	                   jmp     contfire

	fired:                                               	;take 'C' or 'M' out of keyboard buffer
	                   xor     ah,ah
	                   int     16h
	
	exitfire:          
	                   ret
FireBullets endp

DrawBullets proc near
	                   mov     ax,0c0fh                  	;draw parameters
	                   xor     bx,bx                     	;bx=0

	draw:              
	                   cmp     bulletsZ[bx],0            	;check if bullet is empty - bulletZ=0 bullet time ended
	                   jz      nextbull
	                   mov     cx,bulletsX[bx]           	;order of bullet in the array
	                   mov     dx,bulletsY[bx]
	                   int     10h                       	;draw bullet
	nextbull:          
	                   add     bx,2                      	;proceed to next bullet
	                   cmp     bx,maxBullets*2           	;Max bullet capacity
	                   jnz     draw

	                   ret
DrawBullets endp

AdvanceBullets proc near

	                   xor     bx,bx

	bullets:           
   
	                   cmp     bulletsZ[bx],0            	;if no bullet, check next one
	                   jz      nohit
	                   mov     ax,bulletsZ[bx]
	                   test    ax,1
	                   jnz     vert                      	;if direction is -1 or 1 bullet is vertical

	hori:                                                	;else it is horizontal
	                   sal     ax,1
	                   add     bulletsX[bx],ax           	;add +4/-4 to its X depending on direction
	                   cmp     bulletsX[bx],0
	                   jle     removeBullet              	;if hit boundary, remove it
	                   cmp     bulletsX[bx],Window_Width
	                   jge     removeBullet              	;if hit boundary, remove it
	                   jmp     cont

	vert:              
	                   mov     cl,2
	                   sal     ax,cl
	                   add     bulletsY[bx],ax           	;add +4/-4 to its X depending on direction
	                   cmp     bulletsY[bx],0
	                   jle     removeBullet              	;if hit boundary, remove it
	                   cmp     bulletsY[bx],Window_Height
	                   jge     removeBullet              	;if hit boundary, remove it
	                   jmp     cont


	cont:                                                	;	jmp     nohit                     	;no collision check, TODO: re-do with new jet drawing and orientations
	                   push    bx
	                   call    CheckHit
	                   pop     bx
	                   cmp     si,0
	                   je      nohit
   
	removeBullet:      
	                   mov     bulletsZ[bx],0            	;set its direction to 0, prevents it from being drawn and allows overwrite

	nohit:             
	                   add     bx,2
	                   cmp     bx,maxBullets*2
	                   jnz     bullets                   	;if haven't checked all bullets, check next one


	                   cmp     Jet1Reload,0
	                   jng     check2nd
	                   dec     Jet1Reload                	;if jet1 is reloading, dec its timer
								   
	check2nd:          
	                   cmp     Jet2Reload,0
	                   jng     exitAdvance
	                   dec     Jet2Reload                	;if jet2 is reloading, dec its timer

	exitAdvance:       
	                   ret
AdvanceBullets endp

CrossProduct proc near                               		;result in cx bx
	                   mov     ax,Vx
	                   imul    Wy
	                   mov     cx,dx
	                   mov     bx,ax
	          
	                   mov     ax,Vy
	                   imul    Wx
	          
	                   sub     bx,ax
	                   sbb     cx,dx
	                   ret
CrossProduct endp

CheckHit proc near
	                   mov     di,1
	                   xor     si,si

					   mov     bp,bx			
					   
	                   mov     ax,Jet1X				; mov Jet X-coordinates to AX
	                   mov     cx,Jet1Y				; mov Jet Y-coordinates to CX
	                   
	CheckCollide:      
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

	                   mov     Wx,JetH/2+1			;?Wx= 
	                   mov     Wy,-JetH/2			;Wy= -JetH/2
                 
	                   call    CrossProduct			;Call 2nd Cross Product
                 
	                   pop     ax
                 
	                   mov     cl,7
	                   shr     ah,cl				;shift ah to get sign bit
	                   shr     ch,cl				;shift ch to get Sign bit
	                   cmp     ah,ch				;compare ch & ah if not equal (Diff Signs)->Outside triangle 
	                   jne     CollisionCheckDone	;check is done
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
	                   jne     CollisionCheckDone	;check is done
													;If equal (Bullet is inside the Triange ) 
                 
	                   add     si,1
	                   cmp     di,1
	                   jne     HurtTwo

	                   dec     Health1
	                   cmp     Health1,7
	                   jne     CollisionCheckDone
	                   mov     Won,di
	                   jmp     CollisionCheckDone
					   
	CheckCollide2:     jmp     CheckCollide
		
	HurtTwo:           
	                   dec     Health2
	                   cmp     Health2,7
	                   jne     CollisionCheckDone
	                   mov     Won,di
	                   jmp     CollisionCheckDone
					   
	CollisionCheckDone:
	                   inc     di
	                   cmp     di,2
	                   mov     ax,Jet2X
	                   mov     cx,Jet2Y
	                   je      CheckCollide2
	                   ret
CheckHit endp


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
