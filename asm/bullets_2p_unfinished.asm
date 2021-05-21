FireBullets proc near
	                   
	                      mov   ah,1
	                      int   16h
	                      jnz    FIREPRESS                    	;if no key pressed, exit the fire function
                   
 
								   mov dx,3fdh
	in al,dx
	test al,1
	jz nofire
    mov dx , 03F8H
	in al , dx 
	mov ah , al
	jmp dontsendFIRE


	
FIREPRESS:
cmp ah,46d
je contfirepress
cmp ah,50d
je contfirepress
jmp exitfire
contfirepress:
mov dx , 3F8H		; Transmit data register
    mov al,ah
  	out dx , al 

			dontsendFIRE:	   
	                      xor   si,si                     	;used as Jet Pointer for code-reuse
	                      cmp   ah,46d
	                      jz    jetfire                   	;if 'C' pressed, jet 1 fires

	                      add   si,2
	                      cmp   ah,50d
	                      jz    jetfire                   	;if 'M' pressed, jet 2 fires
	nofire:               jmp   exitfire                  	;else, a third key was pressed, so exit the fire function

	jetfire:              
	                      cmp   Jet1Reload[si],0          	;check if jet reload time is 0
	                      jnz   nofire                    	;if not, exit the fire function
					   
	                      lea   di,bulletsZ               	;set ES:DI to bulletsZ location
	                      cmp   si,0
	                      je    FirstFire
	
	SecondFire:           add   di,maxBullets             	;second jet bullets are second half of array

	FirstFire:            xor   ax,ax
	                      mov   cx, maxBullets/2
	                      repne scasw                     	;Look for AX (=0) in bulletZ - an empty spot in the bullets array
	                      jnz   exitfire                  	;if none found, exit the fire function
	                      sub   di,offset bulletsZ+2      	;set DI to a ptr at first empty spot in array

	                      mov   bx, JetW                  	;bullet coordinates, further adjusted later in code
	                      mov   cx, JetH/2

	                      mov   dx,Jet1Z[si]              	;jet direction to be used as bullet direction
	                      cmp   Jet1Power[si],4
	                      jnz   OneBullet                 	;if double bullet not on, jump
	                      mov   ax,1                      	;else set AX
	                      dec   cx                        	;move first bullet one pixel

	OneBullet:            test  dx,10000000b
	                      jz    RightDownBullet
	
	LeftUpBullet:         
	                      xor   bx,bx                     	;if Jet to left or up, remove coordinate offset
						  
	RightDownBullet:      test  dx,1
	                      jz    Reload

	VertBullet:           
	                      xchg  bx,cx                     	;if jet to up or down, exchange offsets

	Reload:               
	                      add   bx,Jet1X[si]              	;finalize bullet coordinates
	                      add   cx,Jet1Y[si]
	                      mov   Jet1Reload[si],ReloadTime 	;set reload time

	contfire:             
	                      mov   bulletsX[di],bx
	                      mov   bulletsY[di],cx
	                      mov   bulletsZ[di],dx           	;initialize bullet X,Y,Z

	                      cmp   al,0
	                      je    fired                     	;if ax not set, one bullet only, so we are done

	                      test  dx,1                      	;else check orientation to adjust second bullet coordinates
	                      jnz   Vertical2ndReAdjust
					   
	Horizontal2ndReAdjust:
	                      add   cx,2
	                      jmp   cont2nd
	
	Vertical2ndReAdjust:  
	                      add   bx,2

	cont2nd:              
	                      push  cx
	                      lea   di,bulletsZ               	;set ES:DI to bulletsZ location
	                      cmp   si,0
	                      je    FirstFire2nd

	SecondFire2nd:        add   di,maxBullets             	;second jet bullets are second half of array
	
	FirstFire2nd:         xor   ax,ax
	                      mov   cx, maxBullets/2
	                      repne scasw                     	;Look for AX (=0) in bulletZ - an empty spot in the bullets array
	                      jnz   exitfire                  	;if none found, exit the fire function
	                      sub   di,offset bulletsZ+2      	;set DI to a ptr at first empty spot in array
	                      pop   cx
	                      jmp   contfire

	fired:                                                	;take 'C' or 'M' out of keyboard buffers
	                      int   16h
	
	exitfire:             
	                      ret
FireBullets endp

DrawBullets proc near
	                      mov   ah,0ch                    	;draw parameters
	                      mov   al,Colour1
	                      xor   si,si

	StartDraw:            xor   bx,bx                     	;bx=0

	draw:                 
	                      cmp   bulletsZ[bx][si],0        	;check if bullet spot is empty - bulletZ=0 bullet time ended
	                      jz    nextbull
	                      mov   cx,bulletsX[bx][si]       	;coordinates of bullet in the array
	                      mov   dx,bulletsY[bx][si]
	                      int   10h                       	;draw bullet
	nextbull:             
	                      add   bx,2                      	;proceed to next bullet
	                      cmp   bx,maxBullets             	;checks first half of array
	                      jnz   draw

	                      cmp   si,maxBullets             	;if drew all array, done
	                      je    DrawDone
					   
	                      mov   al,Colour2                	;else change color and draw second half
	                      mov   si,maxBullets
	                      jmp   StartDraw
					   
	DrawDone:             
	                      ret
DrawBullets endp

AdvanceBullets proc near

	                      xor   bx,bx

	bullets:              
   
	                      cmp   bulletsZ[bx],0            	;if no bullet, check next one
	                      jz    nohit
	                      mov   ax,bulletsZ[bx]				;gets the direction of the bullet and puts it in ax(1,-1,2,-2) 
	                      ;///////////////////////////////////////	  
						  cmp   Jet1Power[si],6				;added power up
						  jnz   NoFasterBullets
						  add   ax,AddedBulletSpeed
						  NoFasterBullets:
					      ;////////////////////////////////////////	  
						  test  ax,1
	                      jnz   vert                      	;if direction is -1 or 1 bullet is vertical

	hori:                                                 	;else it is horizontal(2 or-2)
	                      sal   ax,1						; multiply it by 2
	                      add   bulletsX[bx],ax           	;add +4/-4 to its X depending on direction
	                      cmp   bulletsX[bx],0
	                      jle   removeBullet              	;if hit boundary, remove it
	                      cmp   bulletsX[bx],Window_Width
	                      jge   removeBullet              	;if hit boundary, remove it
	                      jmp   cont

	vert:                 
	                      sal 	ax,1						;(1 or -1)
	                      sal   ax,1						;multiply it by 4
	                      add   bulletsY[bx],ax           	;add +4/-4 to its Y depending on direction
	                      cmp   bulletsY[bx],0
	                      jle   removeBullet              	;if hit boundary, remove it
	                      cmp   bulletsY[bx],Window_Height
	                      jge   removeBullet              	;if hit boundary, remove it
	                      jmp   cont

	cont:                 
	                      push  bx
	                      call  CheckHit                  	;collision check
	                      pop   bx
	                      cmp   bp,0                      	;bp being 1 indicated a hit happened, to remove bullet
	                      je    nohit
   
	removeBullet:         
	                      mov   bulletsZ[bx],0            	;set its direction to 0, prevents it from being drawn and allows overwrite

	nohit:                
	                      add   bx,2
	                      cmp   bx,maxBullets*2
	                      jnz   bullets                   	;if haven't checked all bullets, check next one


	                      cmp   Jet1Reload,0
	                      jng   check2nd
	                      dec   Jet1Reload                	;if jet1 is reloading, dec its timer
								   
	check2nd:             
	                      cmp   Jet2Reload,0
	                      jng   exitAdvance
	                      dec   Jet2Reload                	;if jet2 is reloading, dec its timer

	exitAdvance:          
	                      ret
AdvanceBullets endp

CrossProduct proc near                                		;cx bx = Vx*Wy-Vy*Wx
	                      mov   ax,Vx
	                      imul  Wy
	                      mov   cx,dx
	                      mov   bx,ax
	          
	                      mov   ax,Vy
	                      imul  Wx
	          
	                      sub   bx,ax
	                      sbb   cx,dx
	                      ret
CrossProduct endp

FixWPerZ proc near                                    		;Fixed Wx,Wy per jet[si] orientation
	                      test  Jet1Z[si],1
	                      jz    ContinueFix
    
	UpOrDown:                                             	;if Z=+1 or -1, exchange coordinates and negate Wx
	                      mov   ax,Wx
	                      xchg  ax,Wy
	                      mov   Wx,ax
	                      neg   Wx
        
	ContinueFix:          
	                      cmp   Jet1Z[si],0
	                      jg    FixDone
            
	                      neg   Wx                        	;if Z= -1 or -2, negate Wx and Wy
	                      neg   Wy
	FixDone:              
	                      ret
FixWPerZ endp

PointAtoV proc near                                   		;Puts pointA of jet[si] in Vx,Vy
    
	                      mov   ax,Jet1X[si]              	;X
	                      mov   cx,Jet1Y[si]              	;Y
	
	                      cmp   Jet1Z[si],2
	                      je    ContPointA                	;For Z=2, done
	
	                      cmp   Jet1Z[si],1
	                      je    PointADown
	
	                      cmp   Jet1Z[si],-1
	                      je    PointAUp
		
	PointALeft:                                           	;For Z=-2, add (W,H)
	                      add   ax,JetW
	                      add   cx,JetH
	                      jmp   ContPointA
	
	PointADown:                                           	;For Z=1, add (H,0)
	                      add   ax,JetH
	                      jmp   ContPointA
	
	PointAUp:                                             	;For Z=-1, add (0,W)
	                      add   cx,JetW
	                      jmp   ContPointA
    
	ContPointA:           
	                      mov   Vx,ax
	                      mov   Vy,cx
	                      ret
PointAtoV endp

CheckHit proc near
	                      xor   bp,bp
	                      cmp   bx,maxBullets             	;bullet by which jet, si used as jet ptr
	                      jl    SecondJetCheck

	FirstJetCheck:        
	                      xor   si,si
	                      jmp   CheckCollide

	SecondJetCheck:       
	                      mov   si,2
					   
	CheckCollide:         
	;-------(Bullet-PointA)----------
	                      call  PointAtoV
	                      neg   Vx
	                      neg   Vy
	                      mov   ax,bulletsX[bx]
	                      add   Vx,ax
	                      mov   ax,bulletsY[bx]
	                      add   Vy,ax


	;-------(PointB-PointA)-----------
	                      mov   Wx,0                      	;Wx=0
	                      mov   Wy,JetH                   	;Wy=JetH
                 
	                      call  FixWPerZ
	                      call  CrossProduct              	;Call First Cross Product
                 
	                      push  cx
                 		
	;-------(Bullet-PointB)-----------
	;Subtract vector ba from vector Ba to get vector Bb
	                      mov   ax,Wy
	                      sub   Vy,ax
	                      mov   ax,Wx
	                      sub   Vx,ax
	;-------(PointC-PointB)-----------
	                      mov   Wx,JetH/2+1               	;Wx=JetH/2+1
	                      mov   Wy,-JetH/2                	;Wy= -JetH/2
                 
	                      call  FixWPerZ
	                      call  CrossProduct              	;Call 2nd Cross Product
                 
	                      pop   ax
                 
	                      mov   cl,7
	                      shr   ah,cl                     	;shift ah to get sign bit
	                      shr   ch,cl                     	;shift ch to get Sign bit
	                      cmp   ah,ch                     	;compare ch & ah if not equal (Diff Signs)->Outside triangle
	                      jne   CollisionCheckDone        	;check is done
	;If equal (Can be inside the Triange ) need to check the last side


	                      push  ax
	;-------(Bullet-PointC)-----------
	;Subtract vector cb from vector Bb to get vector Bc
	                      mov   ax,Wx
	                      sub   Vx,ax
	                      mov   ax,Wy
	                      sub   Vy,ax
	                   
	;-------(PointA-PointC)-----------
	                      mov   Wx,-JetH/2-1
	                      mov   Wy,-JetH/2

	                      call  FixWPerZ
	                      call  CrossProduct              	;Call 3rd Cross Product
                 
	                      pop   ax
                 
	                      mov   cl,7
	                      shr   ch,cl                     	;shift ch to get sign bit
	                      cmp   ah,ch                     	;compare ch & ah if not equal (Diff Signs)->Outside triangle
	                      jne   CollisionCheckDone        	;check is done
	;If equal (Bullet is inside the Triange )
                 
	                      add   bp,1                      	;hit indicator, to remove bullet in AdvanceBullets
	                   	  cmp   Jet1Power[si],1
						  je  	CollisionCheckDone
	                      dec   Health1[si]               	;decrements Health of correct jet
	                      cmp   Health1[si],7             	;if health lost all 8 bars (15 to 7), game ends
	                      jne   CollisionCheckDone        	;game not over

	                      cmp   si,2                      	;game over, check which jet won
	                      je    SecondWon

	                      mov   Won,1
	                      jmp   CollisionCheckDone
						  
	SecondWon:            mov   Won,2

	CollisionCheckDone:   
	                      ret
CheckHit endp