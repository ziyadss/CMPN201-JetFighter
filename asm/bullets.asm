FireBullets proc near
	               mov     ax,@data
                   mov     es,ax
	               lea     di,bulletsZ
	               xor     ax,ax
	               mov     cx, maxBullets
	               repne   scasw
	               jnz     exitfire

	               mov     ah,1
	               int     16h
	               jz      exitfire
                   
                   cmp     ah,46d
	               jz      jet1fire

	               cmp     ah,50d
	               jz      jet2fire
	               jmp     exitfire
	jet1fire:      
				   cmp	   Jet1Reload,0
				   jnz     exitfire
	               mov     bx,Jet1X
	               add     bx,JetW/2
	               mov     cx,Jet1Y
	               mov     dx,Jet1Z
				   mov     Jet1Reload,ReloadTime
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
                   sub     di,offset bulletsZ+2
	               mov     bulletsX[di],bx
	               mov     bulletsY[di],cx
	               mov     bulletsZ[di],dx
	               xor     ah,ah
	               int     16h

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
   
	               cmp     bulletsZ[bx],0
	               jz      nohit
                   mov     ax,bulletsZ[bx]
	               test    ax,1
	               jnz     vert

	hori:          
	               add     bulletsX[bx],ax
	               cmp     bulletsX[bx],0
	               jz      removeBullet
                   cmp     bulletsX[bx],Window_Width
                   jz      removeBullet
                   jmp     cont

	vert:          
	               sal	   ax,1
				   add     bulletsY[bx],ax
	               cmp     bulletsY[bx],0
	               jz      removeBullet
                   cmp     bulletsY[bx],Window_Height
                   jz      removeBullet
                   jmp     cont


	cont:          jmp nohit ;no collision check
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
                   mov     bulletsZ[bx],0

	nohit:         
	               add     bx,2
	               cmp     bx,maxBullets*2
	               jnz     bullets


	               cmp Jet1Reload,0
				   jng check2nd
				   dec Jet1Reload
								   
	check2nd:
				   cmp Jet2Reload,0
				   jng exitAdvance
				   dec Jet2Reload

	exitAdvance:			   
				   ret
AdvanceBullets endp