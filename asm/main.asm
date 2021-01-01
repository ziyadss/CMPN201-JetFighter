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

	Won           db  0

	Name1         db  'Player1NameZZZZ$'                      	;change to dp 16 dup ($)
	Score1        db  'Health ', 8 dup(219) ,'$'
	Health1       dw  15                                      	;where 15 = Health + barCount = 7 + 8
	
	Name2         db  'Player2NameZZZZ$'                     	;change to dp 16 dup ($)
	Score2        db  'Health ', 8 dup(219) ,'$'
	Health2       dw  15                                      	;where 15 = Health + barCount = 7 + 8
	
	WinMessage    db  'PLAYERX WON! PRESS ANY KEY TO EXIT','$'


	ReloadTime    equ 3

	Window_Width  equ 280h                                    	;the width of the window (640 pixels)
	Window_Height equ 1E0h                                    	;the height of the window (480 pixels)
	Window_Bounds dw  6                                       	;variable used to check collisions early
    
	LastTime      db  0                                       	;used to check if time has passed

	Jet1X         dw  10h                                     	;X Position (Column) of Jet
	Jet1Y         dw  30h                                     	;Y Position (Line) of Jet
	Jet1Z         dw  -1                                      	;-1 up, 1 down, 2 right, -2 left
	Jet1Reload    db  0

	Jet2X         dw  0220h                                   	;X Position (Column) of Jet (300 pixels)
	Jet2Y         dw  30h                                     	;Y Position (Line) of Jet
	Jet2Z         dw  -1                                      	;-1 up, 1 down, 2 right, -2 left
	Jet2Reload    db  0

	JetW          equ 10                                    	;Jet Width
	JetH          equ 10                                     	;Jet Height
	JetV          equ 5                                     	;Jet Velocity

	maxBullets    equ 16                                      	;Maximum number of bullets
	bulletsX      dw  maxBullets dup (?)                      	;Array of X locations of the bullets
	bulletsY      dw  maxBullets dup (?)                      	;Array of Y locations of the bullets
	bulletsZ      dw  maxBullets dup (?)                      	;bulletsZ   db  num dup(?)     	;-1 up, 1 down, 2 right, -2 left
	;note: current bullet speed is 2 pix/ms, probably too slow?
	;it is done using SAR on bulletsZ, should a variable-using implementation be found?

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
                
	
	          mov     ax,12h
	          int     10h           	;Sets video mode to 640*480 / Clear screen
                                   
	          call    AdvanceBullets

	          call    DisplayNames
	          call    DrawLives     	;call    DrawScores
	          call    DRAW__JET     	;Sandy's draw	-Ziyad's is DrawJets
	          call    DrawBullets

	          cmp     Won,0
	          jz      CheckTime     	;If no winner yet, continue game loop

	          call    EndGame       	;Else, end the game
main endp

	          include util.asm
	          include jets.asm
	          include bullets.asm

end main