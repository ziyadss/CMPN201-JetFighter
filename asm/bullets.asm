FireBullets proc near
	                   
	                      mov     ah,1
	                      int     16h
	                      jz      nofire                   	;if no key pressed, exit the fire function
                   
	                      xor     si,si
	                      cmp     ah,46d
	                      jz      jetfire                  	;if 'C' pressed, jet 1 fires

	                      add     si,2
	                      cmp     ah,50d
	                      jz      jetfire                  	;if 'M' pressed, jet 2 fires
	nofire:               jmp     exitfire                 	;else, a third key was pressed, so exit the fire function

	jetfire:              
	                      cmp     Jet1Reload[si],0         	;check if jet reload time is 0
	                      jnz     nofire                   	;if not, exit the fire function
					   
	                      lea     di,bulletsZ              	;set ES:DI to bulletsZ location
	                      cmp     si,0
	                      je      FirstFire
	SecondFire:           add     di,maxBullets
	FirstFire:            xor     ax,ax
	                      mov     cx, maxBullets/2
	                      repne   scasw                    	;Look for AX (=0) in bulletZ - an empty spot in the bullets array
	                      jnz     exitfire                 	;if none found, exit the fire function
	                      sub     di,offset bulletsZ+2     	;set DI to a ptr at first empty spot in array

	                      mov     bx, JetW                 	;mov bx,Jet1X
	                      mov     cx, JetH/2               	;mov cx,Jet1Y

	                      mov     dx,Jet1Z[si]             	;jet direction to be used as bullet direction
	                      cmp     Jet1State[si],4
	                      jnz     OneBullet					;if double bullet not on, jump
	                      mov     ax,1						;else set AX
	                      sub     cx,ax						;move first bullet one pixel

	OneBullet:            test    dx,10000000b
	                      jz      RightDownBullet
	
	LeftUpBullet:         
	                      xor     bx,bx						;if Jet to left or up, remove coordinate offset
						  
	RightDownBullet:      test    dx,1
	                      jz      Reload

	VertBullet:           
	                      xchg    bx,cx						;if jet to up or down, exchange offsets

	Reload:               
	                      add     bx,Jet1X[si]
	                      add     cx,Jet1Y[si]
	                      mov     Jet1Reload[si],ReloadTime	;set its reload time

	contfire:             
	                      mov     bulletsX[di],bx
	                      mov     bulletsY[di],cx
	                      mov     bulletsZ[di],dx          	;initialize bullet X,Y,Z

	                      cmp     al,0
	                      je      fired

	                      test    dx,1
	                      jnz     Vertical2ndReAdjust
					   
	Horizontal2ndReAdjust:
	                      add     cx,2
	                      jmp     cont2nd
	
	Vertical2ndReAdjust:  
	                      add     bx,2

	cont2nd:              
	                      push    cx
	                      lea     di,bulletsZ              	;set ES:DI to bulletsZ location
	                      cmp     si,0
	                      je      FirstFire2nd
	SecondFire2nd:        add     di,maxBullets
	FirstFire2nd:         xor     ax,ax
	                      mov     cx, maxBullets/2
	                      repne   scasw                    	;Look for AX (=0) in bulletZ - an empty spot in the bullets array
	                      jnz     exitfire                 	;if none found, exit the fire function
	                      sub     di,offset bulletsZ+2     	;set DI to a ptr at first empty spot in array
	                      pop     cx
	                      jmp     contfire

	fired:                                                 	;take 'C' or 'M' out of keyboard buffers
	                      int     16h
	
	exitfire:             
	                      ret
FireBullets endp

DrawBullets proc near
	                   mov     ah,0ch                  	;draw parameters
					   mov 	   al,Colour1
					   xor     si,si

	StartDraw:		   xor     bx,bx                     	;bx=0

	draw:              
	                   cmp     bulletsZ[bx][si],0            	;check if bullet is empty - bulletZ=0 bullet time ended
	                   jz      nextbull
	                   mov     cx,bulletsX[bx][si]           	;order of bullet in the array
	                   mov     dx,bulletsY[bx][si]
	                   int     10h                       	;draw bullet
	nextbull:          
	                   add     bx,2                      	;proceed to next bullet
	                   cmp     bx,maxBullets      	  	;Max bullet capacity
	                   jnz     draw

					   cmp 	   si,maxBullets
					   je	   DrawDone
					   
					   mov     al,Colour2
					   mov 	   si,maxBullets
					   jmp     StartDraw
					   
	                   DrawDone:
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


	cont:
	                   push    bx
	                   call    CheckHit
	                   pop     bx
	                   cmp     bp,0
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

CrossProduct proc near                      		;result in cx bx
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

FixWPerZ proc near
	                   test    Jet1Z[si],1
	                   jz      ContinueFix
    
	UpOrDown:          
	                   mov     ax,Wx
	                   xchg    ax,Wy
	                   mov     Wx,ax
	                   neg     Wx
        
	ContinueFix:       
	                   cmp     Jet1Z[si],0
	                   jg      FixDone
            
	                   neg     Wx
	                   neg     Wy
	FixDone:           
	                   ret
FixWPerZ endp

PointAtoV proc near
    
	                   mov     ax,Jet1X[si]
	                   mov     cx,Jet1Y[si]
	
	                   cmp     Jet1Z[si],2
	                   je      ContPointA
	
	                   cmp     Jet1Z[si],1
	                   je      PointADown
	
	                   cmp     Jet1Z[si],-1
	                   je      PointAUp
		
	PointALeft:        
	                   add     ax,JetW
	                   add     cx,JetH
	                   jmp     ContPointA
	
	PointADown:        
	                   add     ax,JetH
	                   jmp     ContPointA
	
	PointAUp:          
	                   add     cx,JetW
	                   jmp     ContPointA
    
	                   test    Jet1Z[si],1
	                   jz      ContinueFix
    
	ContPointA:        
	                   mov     Vx,ax
	                   mov     Vy,cx
	                   ret
PointAtoV endp

CheckHit proc near
	                   xor     bp,bp
	                   cmp     bx,maxBullets
	                   jl      SecondJetCheck

	FirstJetCheck:     
	                   xor     si,si
	                   jmp     CheckCollide

	SecondJetCheck:    
	                   mov     si,2
					   
	CheckCollide:      
	                   call    PointAtoV
	                   neg     Vx
	                   neg     Vy
	                   mov     ax,bulletsX[bx]
	                   add     Vx,ax
	                   mov     ax,bulletsY[bx]
	                   add     Vy,ax


	;-------(PointB-PointA)-----------
	                   mov     Wx,0              	;Wx=0
	                   mov     Wy,JetH           	;Wy=JetH
                 
	                   call    FixWPerZ
	                   call    CrossProduct      	;Call First Cross Product
                 
	                   push    cx
                 		
	;-------(Bullet-PointB)-----------
	;Vx= The Same (BulletX-JetX)
	                   mov     ax,Wy
	                   sub     Vy,ax             	;Vy= BulletY-JetY-JetH
	                   mov     ax,Wx
	                   sub     Vx,ax
	;-------(PointC-PointB)-----------

	                   mov     Wx,JetH/2+1       	;?Wx=
	                   mov     Wy,-JetH/2        	;Wy= -JetH/2
                 
	                   call    FixWPerZ
	                   call    CrossProduct      	;Call 2nd Cross Product
                 
	                   pop     ax
                 
	                   mov     cl,7
	                   shr     ah,cl             	;shift ah to get sign bit
	                   shr     ch,cl             	;shift ch to get Sign bit
	                   cmp     ah,ch             	;compare ch & ah if not equal (Diff Signs)->Outside triangle
	                   jne     CollisionCheckDone	;check is done
	;If equal (Can be inside the Triange ) need to check the last side


	                   push    ax
	;-------(Bullet-PointC)-----------
	                   mov     ax,Wx
	                   sub     Vx,ax             	;?Vx= The Same (BulletX-JetX) -
	                   mov     ax,Wy
	                   sub     Vy,ax             	;?Vy= BulletY-JetY-JetH/2
	                   
	                   mov     Wx,-JetH/2-1
	                   mov     Wy,-JetH/2

	                   call    FixWPerZ
	                   call    CrossProduct      	;Call 3rd Cross Product
                 
	                   pop     ax
                 
	                   mov     cl,7
	                   shr     ch,cl             	;shift ch to get sign bit
	                   cmp     ah,ch             	;compare ch & ah if not equal (Diff Signs)->Outside triangle
	                   jne     CollisionCheckDone	;check is done
	;If equal (Bullet is inside the Triange )
                 
	                   add     bp,1
	                   
	                   dec     Health1[si]
	                   cmp     Health1[si],7
	                   jne     CollisionCheckDone
	                   cmp     si,2
	                   je      SecondWon
	                   mov     Won,1
	                   jmp     CollisionCheckDone
	SecondWon:         mov     Won,2

	CollisionCheckDone:
	                   ret
CheckHit endp