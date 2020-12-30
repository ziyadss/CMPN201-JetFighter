FireBullets proc near
	                               mov  bx,bulletPtr
	                               mov  ah,1
	                               int  16h
	                               jz   exitfire

	                               cmp  ah,46d
	                               jz   jet1fire

	                               cmp  ah,50d
	                               jz   jet2fire
	                               jmp  exitfire
	jet1fire:                      

	                               mov  ax,Jet1X
	                               add  ax,JetW/2
	                               mov  cx,Jet1Y
	                               mov  dx,Jet1Z
	                               jmp  contfire
	                               
	jet2fire:                      
	                               mov  ax,Jet2X
	                               add  ax,JetW/2
	                               mov  cx,Jet2Y
	                               mov  dx,Jet2Z

	contfire:                      mov  bulletsX[bx],ax
	                               mov  bulletsY[bx],cx
	                               mov  bulletsZ[bx],dx
	                               add  bulletPtr,2
	                               xor  ah,ah
	                               int  16h

	exitfire:                      
	                               ret
FireBullets endp

DrawBullets proc near
	                               mov  ax,0c0fh
	                               xor  bx,bx
																
	draw:                          
	                               cmp  bulletsZ[bx],0
	                               jz   nextbull
	                               mov  cx,bulletsX[bx]
	                               mov  dx,bulletsY[bx]
	                               int  10h
	nextbull:                      
	                               add  bx,2
	                               cmp  bx,maxBullets*2
	                               jnz  draw
				
	                               ret
DrawBullets endp

AdvanceBullets proc near
    
	                               xor  bx,bx
    
	bullets:                       
	                               
	                               cmp  bulletsZ[bx],0
	                               jz   nohit
	                               test bulletsZ[bx],1
	                               jnz  vert
    
	hori:                          
	                               mov  ax,bulletsZ[bx]
	                               shr  ax,1
	                               add  bulletsX[bx],ax
	                               jmp  cont
    
	vert:                          
	                               mov  ax,bulletsZ[bx]
	                               add  bulletsY[bx],ax
    
	cont:                          
	                               mov  cx,bulletsY[bx]
	                               sub  cx,Jet1Y
	                               cmp  cx,JetH-1
	                               jg   nohit
	                               
	                               
	                               mov  ax,2*(1-JetH)/(JetW-1)
	                               mov  dx,bulletsX[bx]
	                               sub  dx,Jet1X
	                               imul dx
	                               add  ax,JetH-1
	                               
	                               cmp  ax,cx
	                               jg   nohit
	                                
	                               neg  ax
	                               cmp  ax,cx
	                               jg   nohit
	                               
	                               inc  Score2 +10
	                               mov  bulletsZ[bx],0
	                               
	                               
	nohit:                         
	                               add  bx,2
	                               cmp  bx,maxBullets*2
	                               jnz  bullets
    
    
	                               ret
AdvanceBullets endp