DrawPower PROC near
		   CMP POWER_UP, 5
		   JE FREEZE
		   JMP POWER2
		   FREEZE:
		    CALL DRAW_FREEZE
			
		POWER2:
		   CMP POWER_UP, 1
		   JE SHIELD
		   JMP POWER3
		   SHIELD:
		    CALL DRAW_SHIELD

		POWER3:
			CMP POWER_UP, 2
		   JE SPEEDUP
		   JMP POWER4
		   SPEEDUP:
		    CALL DRAW_SPEEDUP

		POWER4:
		   CMP POWER_UP, 3
		   JE DIZZY
		   JMP POWER5
		   DIZZY:
		    CALL DRAW_DIZZY

		POWER5:
		   CMP POWER_UP, 6
		   JE FASTERBULLET
		   JMP POWER6
		   FASTERBULLET:
		    CALL DRAW_FASTERBULLET

		POWER6:
		   CMP POWER_UP, 4
		   JE DOUBLEBULLET
		   JMP OUTT
		   DOUBLEBULLET:
		    CALL DRAW_DOUBLEBULLETS
			

OUTT:
	ret			
	DrawPower ENDP
;-------------------------FREEZE--------------------------------------------------
	DRAW_FREEZE PROC NEAR

	       MOV AH,0Bh   	;set the configuration
	       MOV CX, XPOSITION  	;set the width (X) up to image width (based on image resolution)
		   ADD CX, imgW1
	       MOV DX, YPOSITION  	;set the hieght (Y) up to image height (based on image resolution)
		   ADD DX, imgH1
	       mov DI, offset img1  ; to iterate over the pixels
	       jmp Start    	;Avoid drawing before the calculations
	Drawit:
	       MOV AH,0Ch   		;set the configuration to writing a pixel
               mov al, [DI]     ; color of the current coordinates
	       MOV BH,00h   		;set the page number
	       INT 10h      		;execute the configuration
	Start: 
		   inc DI
	       DEC Cx       	;  loop iteration in x direction
		   CMP CX, XPOSITION
	       JNZ Drawit      	;  check if we can draw c urrent x and y and excape the y iteration
	       ADD Cx, imgW1 	;  if loop iteration in y direction, then x should start over so that we sweep the grid
	       DEC DX       	;  loop iteration in y direction
		   CMP DX, YPOSITION
	       JZ  ENDING   	;  both x and y reached 00 so end program
		   Jmp Drawit

	ENDING:
	RET
	DRAW_FREEZE  ENDP
;---------------------SHIELD------------------------------------------
DRAW_SHIELD PROC NEAR

	       MOV AH,0Bh   	;set the configuration
	       MOV CX, XPOSITION  	;set the width (X) up to image width (based on image resolution)
		   ADD CX, imgW2
	       MOV DX, YPOSITION  	;set the hieght (Y) up to image height (based on image resolution)
		   ADD DX, imgH2
	       mov DI, offset img2  ; to iterate over the pixels
	       jmp Start2    	;Avoid drawing before the calculations
	Drawit2:
	       MOV AH,0Ch   	;set the configuration to writing a pixel
               mov al, [DI]     ; color of the current coordinates
	       MOV BH,00h   	;set the page number
	       INT 10h      	;execute the configuration
	Start2: 
		   inc DI
	       DEC Cx       	;  loop iteration in x direction
	       CMP CX, XPOSITION
	       JNZ Drawit2      	;  check if we can draw c urrent x and y and excape the y iteration
	       ADD Cx, imgW2 	;  if loop iteration in y direction, then x should start over so that we sweep the grid
	       DEC DX       	;  loop iteration in y direction
		   CMP DX, YPOSITION
	       JZ  ENDING2   	;  both x and y reached 00 so end program
		   Jmp Drawit2

	ENDING2:
	RET
	DRAW_SHIELD  ENDP
;---------------------------SPEEDUP--------------------------------------------------

DRAW_SPEEDUP PROC NEAR

	       MOV AH,0Bh   	;set the configuration
	       MOV CX, XPOSITION  	;set the width (X) up to image width (based on image resolution)
		   ADD CX, imgW3
	       MOV DX, YPOSITION  	;set the hieght (Y) up to image height (based on image resolution)
		   ADD DX, imgH3
	       mov DI, offset img3  ; to iterate over the pixels
	       jmp Start3    	;Avoid drawing before the calculations
	Drawit3:
	       MOV AH,0Ch   	;set the configuration to writing a pixel
               mov al, [DI]     ; color of the current coordinates
	       MOV BH,00h   	;set the page number
	       INT 10h      	;execute the configuration
	Start3: 
		   inc DI
	       DEC Cx       	;  loop iteration in x direction
	        CMP CX, XPOSITION
	       JNZ Drawit3      	;  check if we can draw c urrent x and y and excape the y iteration
	       ADD Cx, imgW3 	;  if loop iteration in y direction, then x should start over so that we sweep the grid
	       DEC DX       	;  loop iteration in y direction
		   CMP DX, YPOSITION
	       JZ  ENDING3   	;  both x and y reached 00 so end program
		   Jmp Drawit3

	ENDING3:
	RET
	DRAW_SPEEDUP  ENDP
;--------------------------------DIZZY--------------------
DRAW_DIZZY PROC NEAR

	       MOV AH,0Bh   	;set the configuration
	      MOV CX, XPOSITION  	;set the width (X) up to image width (based on image resolution)
		   ADD CX, imgW4
	       MOV DX, YPOSITION  	;set the hieght (Y) up to image height (based on image resolution)
		   ADD DX, imgH4
	       mov DI, offset img4  ; to iterate over the pixels
	       jmp Start4   	;Avoid drawing before the calculations
	Drawit4:
	       MOV AH,0Ch   	;set the configuration to writing a pixel
               mov al, [DI]     ; color of the current coordinates
	       MOV BH,00h   	;set the page number
	       INT 10h      	;execute the configuration
	Start4: 
		   inc DI
	       DEC Cx       	;  loop iteration in x direction
	       CMP CX, XPOSITION
	       JNZ Drawit4      	;  check if we can draw c urrent x and y and excape the y iteration
	       ADD Cx, imgW4 	;  if loop iteration in y direction, then x should start over so that we sweep the grid
	       DEC DX       	;  loop iteration in y direction
		   CMP DX, YPOSITION
	       JZ  ENDING4   	;  both x and y reached 00 so end program
		   Jmp Drawit4

	ENDING4:
	RET
	DRAW_DIZZY  ENDP
;-------------------------FASTERBULLET------------------------------------
DRAW_FASTERBULLET PROC NEAR

	       MOV AH,0Bh   	;set the configuration
	      MOV CX, XPOSITION  	;set the width (X) up to image width (based on image resolution)
		   ADD CX, imgW5
	       MOV DX, YPOSITION  	;set the hieght (Y) up to image height (based on image resolution)
		   ADD DX, imgH5
	       mov DI, offset img5  ; to iterate over the pixels
	       jmp Start5   	;Avoid drawing before the calculations
	Drawit5:
	       MOV AH,0Ch   	;set the configuration to writing a pixel
               mov al, [DI]     ; color of the current coordinates
	       MOV BH,00h   	;set the page number
	       INT 10h      	;execute the configuration
	Start5: 
		   inc DI
	       DEC Cx       	;  loop iteration in x direction
	       CMP CX, XPOSITION
	       JNZ Drawit5      	;  check if we can draw c urrent x and y and excape the y iteration
	       ADD Cx, imgW5 	;  if loop iteration in y direction, then x should start over so that we sweep the grid
	       DEC DX       	;  loop iteration in y direction
		   CMP DX, YPOSITION
	       JZ  ENDING5   	;  both x and y reached 00 so end program
		   Jmp Drawit5

	ENDING5:
	RET
	DRAW_FASTERBULLET  ENDP
	;-----------------------------DOUBLEBULLETS----------------------
	DRAW_DOUBLEBULLETS PROC NEAR

	       MOV AH,0Bh   	;set the configuration
	     MOV CX, XPOSITION  	;set the width (X) up to image width (based on image resolution)
		   ADD CX, imgW6
	       MOV DX, YPOSITION  	;set the hieght (Y) up to image height (based on image resolution)
		   ADD DX, imgH6
	       mov DI, offset img6  ; to iterate over the pixels
	       jmp Start6   	;Avoid drawing before the calculations
	Drawit6:
	       MOV AH,0Ch   	;set the configuration to writing a pixel
               mov al, [DI]     ; color of the current coordinates
	       MOV BH,00h   	;set the page number
	       INT 10h      	;execute the configuration
	Start6: 
		   inc DI
	       DEC Cx       	;  loop iteration in x direction
	      CMP CX, XPOSITION
	       JNZ Drawit6      	;  check if we can draw c urrent x and y and excape the y iteration
	       ADD Cx, imgW6 	;  if loop iteration in y direction, then x should start over so that we sweep the grid
	       DEC DX       	;  loop iteration in y direction
		   CMP DX, YPOSITION
	       JZ  ENDING6   	;  both x and y reached 00 so end program
		   Jmp Drawit6

	ENDING6:
	RET
	DRAW_DOUBLEBULLETS  ENDP
