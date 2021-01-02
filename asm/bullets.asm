FireBullets proc near                             		;DOUBLE BULLETS
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
	                je		DoubleBulletAdjust			;if yes, go adjust coordinates
					jmp     contfire                  	;if not, go fire the bullet
   
	jet2fire:       
	                cmp     Jet2Reload,0
	                jnz     nofire
	                add     bx,Jet2X
	                add     cx,Jet2Y
	                mov     dx,Jet2Z
	                mov     Jet2Reload,ReloadTime

	                cmp     Jet2State,4
					je		DoubleBulletAdjust
	                jmp     contfire

	nofire:         jmp     exitfire

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

	fired:                                            	;take 'C' or 'M' out of keyboard buffer
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

	hori:                                             	;else it is horizontal
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


	cont:           jmp     nohit                     	;no collision check, TODO: re-do with new jet drawing and orientations
	                mov     cx,bulletsY[bx]
	                sub     cx,Jet1Y
	                cmp     cx,JetH-1
	                jg      nohit
   
   
	                mov     ax,2*(1-JetH)/(JetW-1)
	                mov     dx,bulletsX[bx]
	                sub     dx,Jet1X
	                imul    dx
	                add     ax,JetH-1
   
	                cmp     ax,cx
	                jg      nohit

	                neg     ax
	                cmp     ax,cx
	                jg      nohit
   
	                inc     Score2 +10
   
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