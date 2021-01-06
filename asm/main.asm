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

	                  include pics.asm

	POWER_UP          DW      2
	XPOSITION         DW      20H
	YPOSITION         DW      20H
	
	NextPowerCallTime db      ?                                       	;value from 0~59 ie:time in sec
	
	;----------- variables for the first screen-----------------
	; 2 variables for each player to enter their names in
	; the max allowed # of char is 15
	MinX              equ     9
	CursorX           db      MinX
      
	msg1              db      'Please enter your name:','$'
	msg2              db      'Press any key to continue:','$'
	
	Name1             db      16 DUP(?),'$'
	Name2             db      16 DUP(?),'$'
	
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
	Jet1State         dw      4                                       	;PowerUP Variable for Jet1
	Jet2State         dw      3                                       	;PowerUP Variable for Jet2

	Colour1           equ     0fh
	Colour2           equ     0fh
	ReloadTime        equ     5

	Window_Width      equ     280h                                    	;the width of the window (640 pixels)
	Window_Height     equ     1E0h                                    	;the height of the window (480 pixels)
	Window_Bounds     equ     6                                       	;variable used to check collisions early
	Window_Score      equ     50
	
	JetW              equ     20                                      	;Jet Width
	JetH              equ     20                                      	;Jet Height
	JetV              equ     4                                       	;Jet Velocity

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

main proc far
	       mov     ax,@data
	       mov     ds,ax
	       mov     es,ax
	       
	       call    MainMenu
		   
	Choice:
	       mov     ah,0
	       int     16h

	       cmp     ah,59      	;scancode for F1			TODO
	       
	       cmp     ah,60      	;scancode for F2
	       je      Game
	       
	       cmp     ah,1       	;scancode for Esc
	       je      Exit

	       jmp     Choice     	;none of the three options, wait for other input
	       
	Game:  
	       call    Play
		   
	Exit:  
	       mov     ax,4C00h
	       int     21h        	;terminates the application
		   

main endp
end main