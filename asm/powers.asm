FirstPowerSpawnTime proc near
            mov ah,2ch              	;get system time
	        int 21h   
            add dh,20                 ;to wait X sec in this case 20 sec
            cmp dh,60
            jb WithInRange
            sub dh,60                   ;correction of secound if it's above 60 after setting delay
            WithInRange:
            mov NextPowerCallTime,dh
            ret
FirstPowerSpawnTime endp

PowerPosition proc near

            mov ah,2ch              	;get system time
	        int 21h                 	;CH = hour, CL = minute, DH = second, DL = millisecond
              
            cmp dh,NextPowerCallTime   
            jg proceed

            ret

        proceed: 
            mov NextPowerCallTime,dh
            add NextPowerCallTime,5           ;Time X Delay between each function call     	
            cmp NextPowerCallTime,60

            jb Keep
            sub NextPowerCallTime,60        ;to prevent seconds from exceeding 59 sec

        Keep:

            mov ah,2ch              	;get system time
	        int 21h               	    ;CH = hour, CL = minute, DH = second, DL = millisecond
            add cx,dx
            mov ax,cx                   ;RES= 640*480
            Xor bx,bx                   ;reset bx
            mov bl,DL
            Xor dx,dx                   ;reset dx
            mul bx                      ;DXAX=AX*BX
            mov bx,550
            xor dx,dx                   ;reset bx
            div bx                      ;DX = 0~550
            add dx,50                   ;DX = 50~600
            mov SpawnX,dx               ; random location of SpawnX = 50~600

            mov ah,2ch              	;get system time
            int 21h               	    ;CH = hour, CL = minute, DH = second, DL = millisecond
            add cx,dx
            mov ax,cx                
            Xor bx,bx
            mov bl,dh
            Xor dx,dx
            mul bx                     ;DXAX=AX*BX
            mov bx,400
            xor dx,dx
            div bx                     ;DX = 0~400
            add dx,40                  ;DX = 40~440
            mov SpawnY,dx              ;random location of SpawnY = 40~440

            mov ah,2ch                 ;get system time
	        int 21h                    ;CH = hour, CL = minute, DH = second, DL = millisecond
            add cx,dx
            mov ax,cx                
            Xor bx,bx
            mov bl,dh
            Xor dx,dx
            mul bx                     ;DXAX=AX*BX
            mov bx,6
            xor dx,dx
            div bx                     ;DX = 0~5
            inc dx                     ;DX = 1~6 
            mov SpawnPower,dx          ;Random Powerup = 1~6
            ret
PowerPosition endp

DrawPower proc near
    cmp SpawnPower,0
    je NoPower
    
    mov ax,0C0Fh
    mov cx,SpawnX
    add cx,7
    mov bx,cx
    mov dx,SpawnY
    add dx,7
    
    PowerSquare:
    DrawLine:
    int 10h
    dec cx  
    cmp cx,SpawnX
    jne DrawLine 
    mov cx,bx  
    dec dx
    cmp dx,SpawnY 
    jne PowerSquare
    
    NoPower:
    ret
DrawPower endp