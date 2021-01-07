FirstPowerSpawnTime proc near
	                    mov  ah,2ch                          	;get system time
	                    int  21h
	                    add  dh,InitialPowerDelay            	;to wait X sec in this case 20 sec
	                    cmp  dh,60
	                    jb   WithInRange
	                    sub  dh,60                           	;correction of secound if it's above 60 after setting delay
	WithInRange:        
	                    mov  NextPowerCallTime,dh
	                    ret
FirstPowerSpawnTime endp

PowerPosition proc near

	                    mov  ah,2ch                          	;get system time
	                    int  21h                             	;CH = hour, CL = minute, DH = second, DL = millisecond
              
	                    cmp  dh,NextPowerCallTime
	                    je   proceed

	                    ret

	proceed:            
	                    mov  NextPowerCallTime,dh
	                    add  NextPowerCallTime,PowerCallDelay	;Time X Delay between each function call
	                    cmp  NextPowerCallTime,60

	                    jb   Keep
	                    sub  NextPowerCallTime,60            	;to prevent seconds from exceeding 59 sec

	Keep:               

	                    mov  ah,2ch                          	;get system time
	                    int  21h                             	;CH = hour, CL = minute, DH = second, DL = millisecond
	                    add  cx,dx
	                    mov  ax,cx                           	;RES= 640*480
	                    Xor  bx,bx                           	;reset bx
	                    mov  bl,DL
	                    Xor  dx,dx                           	;reset dx
	                    mul  bx                              	;DXAX=AX*BX
	                    mov  bx,550
	                    xor  dx,dx                           	;reset bx
	                    div  bx                              	;DX = 0~550
	                    add  dx,50                           	;DX = 50~600
	                    mov  XPOSITION,dx                    	; random location of XPOSITION = 50~600

	                    mov  ah,2ch                          	;get system time
	                    int  21h                             	;CH = hour, CL = minute, DH = second, DL = millisecond
	                    add  cx,dx
	                    mov  ax,cx
	                    Xor  bx,bx
	                    mov  bl,dh
	                    Xor  dx,dx
	                    mul  bx                              	;DXAX=AX*BX
	                    mov  bx,400
	                    xor  dx,dx
	                    div  bx                              	;DX = 0~400
	                    add  dx,40                           	;DX = 40~440
	                    mov  YPOSITION,dx                    	;random location of YPOSITION = 40~440

	                    mov  ah,2ch                          	;get system time
	                    int  21h                             	;CH = hour, CL = minute, DH = second, DL = millisecond
	                    add  cx,dx
	                    mov  ax,cx
	                    Xor  bx,bx
	                    mov  bl,dh
	                    Xor  dx,dx
	                    mul  bx                              	;DXAX=AX*BX
	                    mov  bx,6
	                    xor  dx,dx
	                    div  bx                              	;DX = 0~5
	                    inc  dx                              	;DX = 1~6
	                    mov  POWER_UP,dx                     	;Random Powerup = 1~6
	                    ret
PowerPosition endp

PowerChecks proc near
	                    xor  si,si								;Jet ptr
    
	JetCheck:           
	                    cmp  Jet1Power[si],0
	                    je   NoTimer							;If power=0, then don't look at timer

	                    cmp  Jet1Timer[si],0
	                    je   RemovePower						;if timer=0, then remove power

	                    dec  Jet1Timer[si]
	                    jmp  NoTimer

	RemovePower:        
	                    mov  Jet1Power[si],0					;removes power

	NoTimer:            
	                    cmp  POWER_UP,0
	                    je   NoPowerHit							;if no powerup, don't check for hit
                                
	                    mov  bx, JetW                        	;gun coordinates, further adjusted later in code
	                    mov  cx, JetH/2

	                    test Jet1Z[si],10000000b
	                    jz   RightDownJet
	
	LeftUpJet:          
	                    xor  bx,bx                           	;if Jet to left or up, remove coordinate offset
						  
	RightDownJet:       test Jet1Z[si],1
	                    jz   GUNXY

	VertJet:            
	                    xchg bx,cx                           	;if jet to up or down, exchange offsets

	GunXY:              
	                    add  bx,Jet1X[si]                    	;finalize gun coordinates
	                    add  cx,Jet1Y[si]

	                    cmp  bx,XPOSITION						;check gun is after XPOS
	                    jl   NoPowerHit

	                    sub  bx,ImgW
	                    cmp  bx,XPOSITION						;check gun is before XPOS+Width
	                    jg   NoPowerHit

	                    cmp  cx,YPOSITION						;check gun is after YPOS
	                    jl   NoPowerHit

	                    sub  cx,ImgH
	                    cmp  cx,YPOSITION						;check gun is before YPOS+Height
	                    jg   NoPowerHit

	                    mov  ax,POWER_UP
	                    mov  Jet1Power[si],ax					;give powerup to jet
	                    mov  Jet1Timer[si],PowerupTime*100		;start powerup timer
	                    mov  POWER_UP,0							;remove powerup from screen

	NoPowerHit:         

	                    cmp  si,2
	                    je   CheckedBoth
	                    mov  si,2
	                    jmp  JetCheck							;check second jet

	CheckedBoth:        
	                    ret
PowerChecks endp

	;DrawPower PROC near
	;	              cmp     POWER_UP,0
	;	              je      ENDING
	;
	;	              MOV     AX,ImgH*ImgW
	;	              mov     cx,1
	;	              mov     DI, offset img1	; to iterate over the pixels
	;	              cmp     POWER_UP,1
	;	              je      FirstPic
	;
	;	drawpowerloop:
	;	              add     di,ax
	;	              inc     cx
	;	              cmp     cx,POWER_UP
	;	              jnz     drawpowerloop
	;
	;	FirstPic:
	;
	;	              MOV     CX, XPOSITION  	;set the width (X) up to image width (based on image resolution)
	;	              ADD     CX, imgW
	;	              MOV     DX, YPOSITION  	;set the hieght (Y) up to image height (based on image resolution)
	;	              ADD     DX, imgH
	;
	;	              jmp     Start          	;Avoid drawing before the calculations
	;	Drawit:
	;	              MOV     AH,0Ch         	;set the configuration to writing a pixel
	;	              mov     al, [DI]       	; color of the current coordinates
	;	              MOV     BH,00h         	;set the page number
	;	              INT     10h            	;execute the configuration
	;	Start:
	;	              inc     DI
	;	              DEC     Cx             	;  loop iteration in x direction
	;	              CMP     CX, XPOSITION
	;	              JNZ     Drawit         	;  check if we can draw c urrent x and y and excape the y iteration
	;	              ADD     Cx, imgW       	;  if loop iteration in y direction, then x should start over so that we sweep the grid
	;	              DEC     DX             	;  loop iteration in y direction
	;	              CMP     DX, YPOSITION
	;	              JZ      ENDING         	;  both x and y reached 00 so end program
	;	              Jmp     Drawit
	;
	;	ENDING:
	;	              RET
;DrawPower ENDP