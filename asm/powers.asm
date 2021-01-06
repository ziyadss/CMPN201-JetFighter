FirstPowerSpawnTime proc near
            mov ah,2ch              	;get system time
	        int 21h   
            add dh,InitialPowerDelay                 ;to wait X sec in this case 20 sec
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
            je proceed

            ret

        proceed: 
            mov NextPowerCallTime,dh
            add NextPowerCallTime,PowerCallDelay           ;Time X Delay between each function call     	
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
            mov XPOSITION,dx            ; random location of XPOSITION = 50~600

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
            mov YPOSITION,dx           ;random location of YPOSITION = 40~440

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
            mov POWER_UP,dx            ;Random Powerup = 1~6
            ret
PowerPosition endp