;Jet Fighter Game
;Authors:
;		Khaled Mahmoud Mohamed
;		Sandy Samir Demian Nashed
;		Sarah Osama Osman
;		Zeyad Sameh Sobhy
.model huge
.stack 64
.data

	Window_Width  dw  140h              	;the width of the window (320 pixels)
	Window_Height dw  0C8h              	;the height of the window (200 pixels)
	Window_Bounds dw  6                 	;variable used to check collisions early
	
	LastTime      db  0                 	;used to check if time has passed
	Score1        db  "Player 1: 0$"
	Score2        db  "Player 2: 0$"

	Jet1X         dw  02h               	;X Position (Column) of Jet
	Jet1Y         dw  0Ah               	;Y Position (Line) of Jet
	Jet1Z         dw  -1                	;-1 up, 1 down, 2 right, -2 left

	Jet2X         dw  0120h             	;X Position (Column) of Jet (300 pixels)
	Jet2Y         dw  0Ah               	;Y Position (Line) of Jet
	Jet2Z         dw  -1                	;-1 up, 1 down, 2 right, -2 left

	JetW          equ 11                	;JetW     DW 15h  	;Jet Width
	JetH          equ 6                 	;JetH    DW 10h  	;Jet Height
	JetV          equ 5                 	;Jet Velocity

	bulletPtr     dw  0
	maxBullets    equ 16                	;Maximum number of bullets
	bulletsX      dw  maxBullets dup (?)	;Array of X locations of the bullets
	bulletsY      dw  maxBullets dup (?)	;Array of Y locations of the bullets
	bulletsZ      dw  maxBullets dup (?)	;bulletsZ   db  num dup(?)     	;-1 up, 1 down, 2 right, -2 left

.code
main proc far
	          mov     ax,@data
	          mov     ds,ax

	CheckTime:
	          call    FireBullets
	          call    MoveJets
								   
	          mov     ah,2ch        	;get system time
	          int     21h           	;CH = hour, CL = minute, DH = second, DL = millisecond
	          cmp     dl,LastTime   	;is current time = previous time?
	          je      CheckTime     	;if yes, check again later
	          mov     LastTime,dl   	;update last time
				
	          call    ClearScreen
	                               
	          call    AdvanceBullets

	          call    DrawScore
	          call    DrawJets
	          call    DrawBullets

	          jmp     CheckTime
main endp

	          include utilities.asm
	          include jets.asm
	          include bullets.asm

end main