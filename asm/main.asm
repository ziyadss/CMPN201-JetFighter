;Jet Fighter Game
;Authors:
;		Khaled Mahmoud Mohamed
;		Salma Mohamed Shehatta
;		Sandy Samir Demian Nashed
;		Sarah Osama Osman
;		Zeyad Sameh Sobhy
.model huge
.stack 64
.data

	ValR              db      ?
	
	Backspace         equ     0Eh                                     	;Backspace scancode, to delete last character
	Escape            equ     1                                       	;Escape key to exit program
	Whitespace        equ     32                                      	;Whitespace ascii, to overwrite deleted character
	Return            equ     1ch                                     	;Enter key scancode

	ScreenWidth       equ     80                                      	;In characters
	ScreenHeight      equ     30

	MaxX              equ     75                                      	;Right boundary
	MaxY              equ     40                                      	;Lower boundary -- still unused

	MinX              equ     2                                       	;Left boundary
	MinY              equ     1                                       	;Upper boundary

	MsgMinX           equ     5                                       	;Boundary for messages

	CursorSX          db      MinX                                    	;Cursor for upper half of window
	CursorSY          db      MinY

	CursorRX          db      MinX                                    	;Cursor for bottom half of window
	CursorRY          db      MinY + ScreenHeight/2
	
	MsgLength         dw      0                                       	;Length of message typed

	Msg               db      MaxX-MsgMinX dup(?)                     	;Array holding the message (note: message is limited to one line of 70 characters)

	                  include pics.asm

	POWER_UP          DW      ?                                       	;intially there is no power up
	XPOSITION         DW      ?
	YPOSITION         DW      ?

	AddedBulletSpeed  equ     4                                       	;must be even
	
	NextPowerCallTime db      ?                                       	;value from 0~59 ie:time in sec
	InitialPowerDelay equ     5                                       	;the time before the first powerup spawn
	PowerCallDelay    equ     9                                       	;the delay between each powerup call
	;----------- variables for the first screen-----------------
	; 2 variables for each player to enter their names in
	; the max allowed # of char is 15
	CursorX           db      9
      
	msg1              db      'Please enter your name:','$'
	msg2              db      'Press any key to continue:','$'
	
	Name1             db      17 DUP('$')
	Name2             db      17 DUP('$')
	
	;------------variables for the second screen----------------
	; the menus the player will choose from
	Option1           db      'To start chatting press F1','$'
	Option2           db      'To start playing press F2','$'
	Option3           db      'To end the program press ESC','$'
	
	Vx                dw      ?
	Vy                dw      ?
	Wx                dw      ?
	Wy                dw      ?

	Won               dw      0
	WinMessage        db      'PLAYERX WON! PRESS ANY KEY TO EXIT','$'

	Score1            db      'Health ', 8 dup(219) ,'$'
	Score2            db      'Health ', 8 dup(219) ,'$'
	
	Health1           dw      15                                      	;where 15 = Health + barCount = 7 + 8
	Health2           dw      15                                      	;where 15 = Health + barCount = 7 + 8

	LastTime          db      0                                       	;used to check if time has passed

	Jet1X             dw      10h                                     	;X Position (Column) of Jet
	Jet2X             dw      0220h                                   	;X Position (Column) of Jet (300 pixels)
	Jet1Y             dw      30h                                     	;Y Position (Line) of Jet
	Jet2Y             dw      30h                                     	;Y Position (Line) of Jet
	Jet1Z             dw      2                                       	;-1 up, 1 down, 2 right, -2 left
	Jet2Z             dw      -2                                      	;-1 up, 1 down, 2 right, -2 left
	
	Jet1Reload        dw      0
	Jet2Reload        dw      0

	;PowerUP (1->Shield , 2->Speed up jet , 3->Dizzy , 4-> Double bullets , 5->Freeze , 6->Faster bullets )
	Jet1Power         dw      ?                                       	;PowerUP Variable for Jet1
	Jet2Power         dw      ?                                       	;PowerUP Variable for Jet2

	Jet1Timer         dw      0
	Jet2Timer         dw      10

	Colour1           equ     0fh
	Colour2           equ     0fh
	ReloadTime        equ     5
	PowerupTime       equ     5

	Window_Width      equ     280h                                    	;the width of the window (640 pixels)
	Window_Height     equ     1E0h                                    	;the height of the window (480 pixels)
	Window_Bounds     equ     6                                       	;variable used to check collisions early
	Window_Score      equ     50
	
	JetW              equ     25                                      	;Jet Width
	JetH              equ     25                                      	;Jet Height
	Jet1V             DW      4                                       	;Jet1 Velocity
	Jet2V             DW      4                                       	; Jet2 Velocity
	speedUpVelocity   equ     4                                       	;speedup velocity
	maxBullets        equ     16                                      	;Maximum number of bullets
	
	bulletsX          dw      maxBullets dup (?)                      	;Array of X locations of the bullets
	bulletsY          dw      maxBullets dup (?)                      	;Array of Y locations of the bullets
	bulletsZ          dw      maxBullets dup (?)                      	;bulletsZ   db  num dup(?)     	;-1 up, 1 down, 2 right, -2 left
	;note: current bullet speed is 2 pix/ms, probably too slow?
	;it is done using SAR on bulletsZ, should a variable-using implementation be found?

.code

	         include util.asm
	         include jets.asm
	         include bullets.asm
	         include modes.asm
	         include powers.asm
	         include drawp.asm
	         include chat.asm

main proc far
	         mov     ax,@data
	         mov     ds,ax
	         mov     es,ax
	       
	         call    NameEntry
		   
	Choice:  
	         call    Options

	         mov     ah,0
	         int     16h

	         cmp     ah,59      	;scancode for F1			TODO
	         jmp     Chatting

	         cmp     ah,60      	;scancode for F2
	         je      Game
	       
	         cmp     ah,1       	;scancode for Esc
	         je      Exit

	         jmp     Choice     	;none of the three options, wait for other input
	       
	Game:    
	         call    Play
	         jmp     Choice

	Chatting:
	         call    Chat
	         jmp     Choice
		   
	Exit:    
	         mov     ax,4C00h
	         int     21h        	;terminates the application
		   
main endp
end main