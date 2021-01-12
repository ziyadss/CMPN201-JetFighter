Chat proc near
    
	            mov  cx,1                 	;to print each character only once when using int 10h / ah=0ah
    
	            mov ax,12h
				int  10h
				
				
	            call ScreenPrepS          	;print Player1 name, set cursorS
	            Call ScreenPrepR          	;print Player2 name, set 

	L:          

                mov  ah,1
	            int  16h
	            jz   NoInput             	;if nothing in keyboard buffer, no input

	            cmp  ah,Escape            	;if Esc, exit
	            jz   LeaveChat

	            call Input                	;Takes input from user
	NoInput:    call Output               	;Receives and prints from port
	            jmp  L

    LeaveChat:
               mov  ah,0
	           int  16h                  	;else take key from buffer
	           ret
 
Chat endp

Output proc near

	            mov  ah,02h
	            mov  dl,CursorRX
	            mov  dh,CursorRY
	            int  10h                  	;moves cursor to correct location
				
	            call Receive              	;receives a character
	            cmp  ValR,0
	            je   NoOut                	;if it is NULL, exit function

	            cmp  ValR,10d
	            je   EOM                  	;if it is EOM, jump

	            mov  ah,0ah
	            mov  al,ValR
	            mov  bx,0fh
	            int  10h                  	;else, print the character

	            inc  CursorRX
	            jmp  NoOut                	;increment X coordinate and exit function

	EOM:        inc  CursorRY
	            mov  CursorRX,MsgMinX

	NoOut:      
	            ret
Output endp

Receive proc near

	            mov  dx,3fdh              	;Line Status Register
	againR:     
	            in   al,dx                	;Read Line Status
	            test al,1
	            jz   NoRec                	;Data not ready

	            mov  dx,3f8h
	            in   al,dx
	            mov  ValR,al              	;if received, mov character to ValR
	            jmp  Rec

	NoRec:      mov  ValR,0               	;if no received, set to NULL

	Rec:        ret
Receive endp

Input proc near
	            mov  ah,02h
	            mov  dl,CursorSX
	            mov  dh,CursorSY
	            int  10h                  	;moves cursor to correct location
                       
	ReadKey:    mov  ah,0
	            int  16h                  	;take key from buffer
	           
	            cmp  ah,Return            	;if Enter, send message
	            jz   Send
				
	            call ProcessKey           	;else process key then exit function
	            jmp  KeyTaken
 
	Send:       
	            cmp  MsgLength,0
	            jz   KeyTaken             	;if no message, exit function
	            call SendMessage
	            
	            mov  CursorSX,MsgMinX
	            inc  CursorSY             	;go to next line

	            jmp  KeyTaken
	KeyTaken:   ret
	
Input endp

SendMessage proc near

	            mov  bx,MsgLength
	            mov  Msg[bx],10
	            inc  MsgLength
	            xor  bx,bx

	SendByte:   
	            mov  dx,3fdh              	;Line Status Register
	againS:     
	            in   al,dx                	;Read Line Status
	            test al,00100000b
	            jz   againS               	;Transmitter Holding Register not empty

	            mov  dx,3f8h              	;Transmit Data Register
	            mov  al,Msg[bx]
	            out  dx,al                	;send character

	            inc  bx
	            cmp  bx,MsgLength         	;loops over all array
	            jnz  SendByte
	            
	            mov  MsgLength,0
	            ret
SendMessage endp

InitUART proc near
	;Set Divisor Latch Access Bit
	            mov  dx,3fbh              	;Line Control Register
	            mov  al,10000000b
	            out  dx,al

	;Set LSB of Baud Rate Divisor Latch register
	            mov  dx,3f8h
	            mov  al,0ch
	            out  dx,al

	;Set MSB of Baud Rate Divisor Latch register
	            mov  dx,3f9h
	            mov  al,00h
	            out  dx,al

	;Set port configuration
	            mov  dx,3fbh
	            mov  al,00011011b
	;0      access R/T buffer
	;0      set break disabled
	;011    even parity bit
	;0      1 stop bit
	;11     8 bit word
	            out  dx,al

	            ret
InitUART endp

ProcessKey proc near
	            cmp  ah,Backspace	;If Backspace pressed, check if we can erase
	            jz   EraseCheck

	            cmp  CursorSX,MaxX	;If line full, exit function
	            je   NextKey

	            mov  bx,MsgLength
	            mov  Msg[bx],al		;Put character in Msg array

	            mov  ah,0ah
	            mov  bx,0fh
	            int  10h			;Print the character
	           
	            inc  CursorSX		;Move cursor forward
	            inc  MsgLength		;Inc message length

	            jmp  NextKey

	EraseCheck: 
	            cmp  CursorSX,MsgMinX
	            jz   NextKey		;If at beginning of line, exit function
	           
	Erase:      
	            dec  MsgLength
				
	            dec  CursorSX
	            mov  ah,02h
	            mov  dl,CursorSX
	            mov  dh,CursorSY
	            int  10h          	;Moves cursor one step back
 
	            mov  ah,0ah
	            mov  al,Whitespace
	            int  10h          	;Draws empty space over the character we need to delete
	NextKey:    
	            ret
ProcessKey endp

ScreenPrepS proc near
	            mov  ah,2h
	            mov  dl,CursorSX
	            mov  dh,CursorSY
	            int  10h                  	;moves cursor
				
	            mov  ah,9
	            lea  dx, Name1
	            int  21h                  	;prints P1 Name
				
	            mov  ah,2
	            mov  dl,':'
	            int  21h                  	;prints ':'
				
	            add  CursorSX,MsgMinX-MinX
	            inc  CursorSY             	;changes cursor to first message location
	            ret
ScreenPrepS endp

ScreenPrepR proc near
	            mov  ah,02h
	            mov  dl,CursorRX
	            mov  dh,CursorRY
	            int  10h                  	;moves cursor
				
	            mov  ah,9
	            lea  dx, Name2
	            int  21h                  	;prints P2 Name
				
	            mov  ah,2
	            mov  dl,':'
	            int  21h                  	;prints ':'
				
	            add  CursorRX,MsgMinX-MinX
	            inc  CursorRY             	;changes cursor to first message location

;------------------- Status Bar----------------------------------------				
				mov  ah,02h
	            mov  dl,StatusBarX
	            mov  dh,StatusBarHeight
	            int  10h                  	;moves cursor

				mov  ah,9
	            lea  dx,StatusBarChatMsg
	            int  21h                  	;prints Message

				mov  ah,02h
	            mov  dl,45
	            mov  dh,StatusBarHeight
	            int  10h                  	;moves cursor

				mov  ah,9
	            lea  dx, Name2
	            int  21h                  	;prints Other player's name Name
			
	EXITHALABO2A:     ret
ScreenPrepR endp



