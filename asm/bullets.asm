FireBullets proc near
	               mov     ax,@data
                   mov     es,ax
	               lea     di,bulletsZ			;set ES:DI to bulletsZ location

	               xor     ax,ax
	               mov     cx, maxBullets
	               repne   scasw				;Look for AX (=0) in bulletZ - an empty spot in the bullets array
	               jnz     exitfire				;if none found, exit the fire function

	               mov     ah,1
	               int     16h
	               jz      exitfire				;if no key pressed, exit the fire function
                   
                   cmp     ah,46d
	               jz      jet1fire				;if 'C' pressed, jet 1 fires

	               cmp     ah,50d
	               jz      jet2fire				;if 'M' pressed, jet 2 fires
	               jmp     exitfire				;else, a third key was pressed, so exit the fire function
	jet1fire:      
				   cmp	   Jet1Reload,0			;check if jet reload time is 0
				   jnz     exitfire				;if not, exit the fire function
	               mov     bx,Jet1X
	               add     bx,JetW/2			;jetX + Width/2 to be used as bulletX, TODO: change if in different orientation
	               mov     cx,Jet1Y				;jetY to be used as bulletY, TODO: change if in different orientation
	               mov     dx,Jet1Z				;jet direction to be used as bullet direction
				   mov     Jet1Reload,ReloadTime	;set its reload time
	               jmp     contfire
   
	jet2fire:    
				   cmp	   Jet2Reload,0
				   jnz     exitfire  
	               mov     bx,Jet2X
	               add     bx,JetW/2
	               mov     cx,Jet2Y
	               mov     dx,Jet2Z
				   mov     Jet2Reload,ReloadTime

	contfire:      
                   sub     di,offset bulletsZ+2	;set DI to a ptr at first empty spot in array
	               mov     bulletsX[di],bx
	               mov     bulletsY[di],cx
	               mov     bulletsZ[di],dx		;initialize bullet X,Y,Z
	               xor     ah,ah
	               int     16h					;take 'C' or 'M' out of keyboard buffer

	exitfire:      
	               ret
FireBullets endp

DrawBullets proc near
	               mov     ax,0c0fh
	               xor     bx,bx

	draw:          
	               cmp     bulletsZ[bx],0
	               jz      nextbull
	               mov     cx,bulletsX[bx]
	               mov     dx,bulletsY[bx]
	               int     10h
	nextbull:      
	               add     bx,2
	               cmp     bx,maxBullets*2
	               jnz     draw

	               ret
DrawBullets endp

AdvanceBullets proc near

	               xor     bx,bx

	bullets:       
   
	               cmp     bulletsZ[bx],0		;if no bullet, check next one
	               jz      nohit
                   mov     ax,bulletsZ[bx]
	               test    ax,1
	               jnz     vert					;if direction is -1 or 1 bullet is vertical

	hori:          								;else it is horizontal
	               add     bulletsX[bx],ax		;add +1/-1 to its X depending on direction
	               cmp     bulletsX[bx],0
	               jle      removeBullet		;if hit boundary, remove it
                   cmp     bulletsX[bx],Window_Width
                   jge      removeBullet		;if hit boundary, remove it
                   jmp     cont

	vert:          
	               sal	   ax,1
				   add     bulletsY[bx],ax		;add +1/-1 to its X depending on direction
	               cmp     bulletsY[bx],0
	               jle      removeBullet		;if hit boundary, remove it
                   cmp     bulletsY[bx],Window_Height
                   jge      removeBullet		;if hit boundary, remove it
                   jmp     cont


	cont:          jmp nohit 					;no collision check, TODO: re-do with new jet drawing and orientations
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
                   mov     bulletsZ[bx],0		;set its direction to 0, prevents it from being drawn and allows overwrite

	nohit:         
	               add     bx,2
	               cmp     bx,maxBullets*2
	               jnz     bullets				;if haven't checked all bullets, check next one


	               cmp Jet1Reload,0
				   jng check2nd
				   dec Jet1Reload				;if jet1 is reloading, dec its timer
								   
	check2nd:
				   cmp Jet2Reload,0
				   jng exitAdvance
				   dec Jet2Reload				;if jet2 is reloading, dec its timer

	exitAdvance:			   
				   ret
AdvanceBullets endp