.MODEL SMALL 
.STACK 128
.DATA

;--------------------------------- data for InGame ---------------------------------
	WINDOW_WIDTH equ 320
    WINDOW_HEIGHT equ 200                

    FRAMES_DELAY equ 41 ;24 fps
    
    current_time db ?   ;used in delay function
    initial_time db ?   ;used in delay function

    ball_center_x dw 0
    ball_center_y dw 0
    ball_radius dw 5
    ball_radius_square dw ? ;will be calculated in main
    
    ball_velocity_x dw 1 ;-5
    ball_velocity_y dw 2 ;2
    
    ball_color_random db 0Fh
    
    right_margin dw 10
    top_margin dw 10
    bottom_margin dw 10
    left_margin dw 10
    border_width dw 1
    
    racket_margin dw 30
    racket_start_x dw ?     ;will set to window_width - racket_margin - racket_width later
    racket_start_y dw 180
    racket_width dw 25
    racket_height dw 5
    racket_move_velocity dw 10
    
    shootcenter_x dw ?
    shootcenter_y dw ?
    chk   db ?
    dummy1 dw ?
    dummy2 dw ?
	dummy3 DB 0
;--------------------------------- data for InGame ---------------------------------	

;SI -> registers , DI -> Indices
;these vriables are for the first page 
;1 -> 15 (2 operands) , 16 -> 23 (1 operand) , 24 -> 25 (no operands) : important for command index
;note for the commandListNames : we can access the string of the command chosen by the following equation : command index * 4 + offset commandListNames
;note for the OperandListNames : we can access the string of the command chosen by the following equation : command index * 2 + offset OperandListNames

chooseMessage       DB 'choose$'
yesOrNoMessage      DB 'is there is a bracket$'
enterANumber        DB ',enter a number : $'
enterNameMessage    DB 'Please Enter Your Name : $'
enterPointsMessage  DB 'Initial Points : $'
pressEnterMessage   DB 'Press Enter To Continue : $'
sendMessageEnter    DB 'Press Enter to execute this command : $'
enterForbiddenMsg   DB 'Forbidden Character : $'
commandList         DB '01) ADD,02) ADC,03) SUB,04) SBB,05) RCR,06) RCL,07) MOV,08) XOR,09) AND,10) OR,11) SHR,12) SHL,13) SAR,14) ROL,15) ROR,16) PUSH,17) POP,18) INC,19) DEC,20) IMUL,21) IDIV,22) MUL,23) DIV,24) NOP,25) CLC$'
isBracketList       DB '1) yes,2) No$'
firstOperandList    DB '01) AX,02) BX,03) CX,04) DX,05) SI,06) DI,07) SP,08) BP,09) AH,10) AL,11) BH,12) BL,13) CH,14) CL,15) DH,16) DL$' 
secondOperandList   DB '01) AX,02) BX,03) CX,04) DX,05) SI,06) DI,07) SP,08) BP,09) AH,10) AL,11) BH,12) BL,13) CH,14) CL,15) DH,16) DL,17) enter a number$'
powerUpsList1       DB '1) Executing a command on your own processor,(consumes 5 points),2) Executing a command on your processor and your,opponent processor at the same time,(consumes 3 points),3) Changing the forbidden character only once,(consumes 8 points),$'
powerUpsList2       DB '4) Making one of the data lines stuck at zero or,at one for a single instruction,(consumes 2 points),5) Clearing all registers at once.,(Consumes 30 points and could be used only once)$'
instructionList     DB 'use left and right arrow to edit your command,use up and down arrows to scroll pages,use f2 to in game chatting,use f3 to out game chatting,press f4 to exit chatting$'
addressListHeaders  DB '  0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F$'
noticationsTitle    DB 'notifications ',1,'$'
powerUpsInfo		DB 'Power Up info : $'
registersList       DB '  AX    BX    CX    DX    SI    DI    SP    BP $'
commandListNames    DB 'ADD ','ADC ','SUB ','SBB ','RCR ','RCL ','MOV ','XOR ','AND ','OR  ','SHR ','SHL ','SAR ','ROL ','ROR ','PUSH','POP ','INC ','DEC ','IMUL','IDIV','MUL ','DIV ','NOP ','CLC '
OperandListNames    DB 'AX','BX','CX','DX','SI','DI','SP','BP','AH','AL','BH','BL','CH','CL','DH','DL'
enterGameLevelMsg   DB 'enter game Level : $'
gameLevelMsg        DB 'game Level : $'
ForbiddebCharMsg    DB 'Forbidden Char is : $'
flagsList           DB 'CF : ,PF : ,AF : ,ZF : ,SF : ,OF : $'
WinnerMessage       DB 'the winner is : $'
loserMessage        DB 'the loser is : $'
EnterNewForbidden   DB ' ,New Forbidden Char : $'
TargetMessage       DB 'Target:$'
enterRegisterVal    DB 'AX : ,BX : ,CX : ,DX : ,SI : ,DI : ,SP : ,BP : , $'
extraPowerUp        DB '6) Change target Value$'
enterNewTargerMsg   DB ',new Target : $'
inGameChatReqMsg	DB 'the other player wants to InGame chat with you, press 1 to accept$'
outGameChatReqMsg	DB 'the other player wants to outGame chat with you, press 1 to accept$'

personTurnIndex     DB 1    ; if 0 then its my turn on my device , if 1 then its opponent turn on his device (used in communication)

isThereAChatting	DB 0
;for chat type
;0 : inGameChatting
;1 : outGameChatting
chatType			DB 0

;for messageing
messageToBeSend     DB 200 DUP('$')
messageRecieved     DB 200 DUP('$')

messageToBeSendRow	DB 22
messageToBeSendCol	DB 51

messageRecievedRow	DB 0
messageRecievedCOL	DB 51		

;variables to be used later in execution
commandIndex        DB ?
isFirstOpBracket    DB ?
firstOperandIndex   DB ?
isSecondOpBracket   DB ?
secondOperandIndex  DB ?
numberEntered       DW 0H
commandEntered      DB 15 DUP('$')

pointsAddress       DW ?
addressesAddress    DW ?
registersAddress    DW ?
forbiddentCharAdd   DW ?
flagAddress         DW ?

gameLevel           DB 5
personTurn          DB 0    ; if personTurn = 0 then you , if personTurn = 1 then opponent
isGameEnded         DB 0    ; if 1 then stop executing and end game
loserNameAddress    DW ?
winnerNameAddress   DW ?

addedValueToSIDest        DW ?
addedValueToSISource      DW ?
targetValue               DW 105EH
tempNewTarget             DW 0

;Variables for level 2
TargetPerson        DB 1    ;if 1 then execute on me , if 2 then execute at oponent


;for navigation index
;1 : left arrow
;2 : right arrow
;3 : up arrow
;4 : down arrow
;5 : f2 
;6 : f3
;7 : ENTER
;8 : f4
isANavigateButton   DB 0H
navigationIndex     DB 0H

dummyVariable       DB 0H

powerUpIndex        DB 0

;variables to be used in other things
navigate        DB  1H
PageNumber      DB  0H  
cursorY         DB  0H
cursorX         DB  0H
isFirstTime     DB  1H
InitialPoints   DB  0
tempForbChar    DB  0
regisetAdd      DW  ?

NUMtoBeDisplayed DB 4 DUP('$')

;YOUR VARIABLES
yourAddressesList       DB  16 DUP(0)
yourFlags               DW  0
youchangedForbiddenKey  DB  0 ;IF 1 then you cannot change opponent key again
youMadeRegWithZero      DB  0 ;If 1 then you canot use this power up again 
youchangedTargetValue   DB  0 ;If 1 then you canot use this power up again  

;yourRegistersValues[0] = AX
;yourRegistersValues[1] = BX
;yourRegistersValues[2] = CX
;yourRegistersValues[3] = DX
;yourRegistersValues[4] = SI
;yourRegistersValues[5] = DI
;yourRegistersValues[6] = SP
;yourRegistersValues[7] = BP
yourRegistersValues DW  8 DUP(0)

yourPoints          DB  0
yourName            DB  10 DUP('$')
yourForbiddenChar       DB  1  DUP('$')  

;OPPONENT VARIABLES
opponentAddressesList       DB  16 DUP(0)
opponentFlags               DW 0
opponentchangedForbiddenKey DB 0 ;IF 1 then opponent cannot change opponent key again
opponentMadeRegWithZero     DB 0 ;If 1 then opponent canot use this power up again 
opponentchangedTargetValue  DB 0

;opponentRegistersValues[0] = AX
;opponentRegistersValues[1] = BX
;opponentRegistersValues[2] = CX
;opponentRegistersValues[3] = DX
;opponentRegistersValues[4] = SI
;opponentRegistersValues[5] = DI
;opponentRegistersValues[6] = SP
;opponentRegistersValues[7] = BP
opponentRegistersValues DW  8 DUP(0)    

opponentPoints              DB  0
opponentName                DB  10 DUP('$')
opponentForbiddenChar       DB  1  DUP('$')

.CODE   

;this segemnt is for for inGame game
;=========================================================================
;---------------------
DRAW_SHOOT PROC 

;call SET_GRAPHIC_MODE
       
    mov dx, shootcenter_y       ;
    sub dx, 1         ;Initial row for drawing the ball
    
    draw_sh_loop1:
        mov cx, shootcenter_x   ;
        sub cx, 1     ;initial column for drawing the ball
        
        draw_sh_loop2:
        call CHECK_INSIDE_SHOOT
            cmp bx, 0000h
            je pass_this_pixel            
            mov al, ball_color_random   ;color (random)
            mov ah, 0ch         ;code for drawing pixel
            int 10h             ;interupt
            pass_this_pixel:
                inc cx              ;go to next column
                mov ax, shootcenter_x    ;checking if code reached end of column
                add ax, 1    
                cmp cx, ax
                jne draw_sh_loop2
                
                inc dx                  ;go to next row
                mov ax, shootcenter_y   ;checking if code reached end of row
                add ax, 1
                cmp dx, ax
                jne draw_sh_loop1
                       
             RET

DRAW_SHOOT ENDP
DRAW_BALL   PROC
    
    ;call SET_GRAPHIC_MODE
       
    mov dx, ball_center_y       ;
    sub dx, ball_radius         ;Initial row for drawing the ball
    
    draw_ball_loop1:
        mov cx, ball_center_x   ;
        sub cx, ball_radius     ;initial column for drawing the ball
        
        draw_ball_loop2:
            call CHECK_INSIDE_BALL
            cmp bx, 0000h
            je pass_this_pixel_SH            
            mov al, ball_color_random   ;color (random)
            mov ah, 0ch         ;code for drawing pixel
            int 10h             ;interupt
            pass_this_pixel_SH:
                inc cx              ;go to next column
                mov ax, ball_center_x    ;checking if code reached end of column
                add ax, ball_radius    
                cmp cx, ax
                jne draw_ball_loop2
                
                inc dx                  ;go to next row
                mov ax, ball_center_y   ;checking if code reached end of row
                add ax, ball_radius
                cmp dx, ax
                jne draw_ball_loop1
            
                
            
    RET
            
DRAW_BALL   ENDP    
;---------------------
GET_RANDOM_COLOR    PROC
    
    push cx
    push dx 
    
    mov ah, 2ch
    int 21h         ;get current time miliseconds in al
    mov al, dl
    mov ah, 0
    mov cl, 15
    div cl          ;we have our random number inside ah (modulus)          
    inc ah          ;to avoid black color for ball!
    
    mov ball_color_random, ah
    pop dx
    pop cx  
    
    RET
    
GET_RANDOM_COLOR    ENDP
;---------------------
CHECK_INSIDE_BALL   PROC ;checks if coordinate inside cx and dx is inside the ball's circle. bx=1 for yes, bx=0 for no
    
    push cx     
    push dx     ;keep row and column inside stack
    
    cmp cx, ball_center_x   ;check if current point is left or right of center
    jge cx_is_positive
    
    mov ax, ball_center_x
    sub ax, cx
    xchg ax, cx                 ;now center_x - current_x is in cx
    jmp delta_x_is_calculated
        
    cx_is_positive: 
        sub cx, ball_center_x   ;now current_x - center_x is in cx
        jmp delta_x_is_calculated
    
    delta_x_is_calculated:
        mov al, cl
        mul cl          ;delta_x^2 inside ax
        push ax         ;push ax to stack
        
    cmp dx, ball_center_y   ;check if current point is up or down of center
    jge dx_is_positive
    
    mov ax, ball_center_y
    sub ax, dx
    xchg ax, dx                 ;now center_y - current_y is in cx
    jmp delta_y_is_calculated
    
    dx_is_positive:
        sub dx, ball_center_y   ;now current_y - center_y is in cx
        jmp delta_y_is_calculated
    
    delta_y_is_calculated:
        mov al, dl
        mul dl          ;delta_y^2 is inside ax
        push ax         ;push ax to stack
        
    calculate_distance_squared:
        pop bx                          
        pop ax
        add bx, ax                      ;calculate delta_x^2 + delta_y^2
        cmp bx, ball_radius_square
        jle point_is_inside_circle
        jg point_is_outside_circle
        
    point_is_inside_circle:
        mov bx, 1
        jmp check_inside_ball_exit
    
    point_is_outside_circle:
        mov bx, 0
        jmp check_inside_ball_exit         

    check_inside_ball_exit:
        pop dx
        pop cx    
        RET
    
CHECK_INSIDE_BALL   ENDP    
;---------------------
CHECK_INSIDE_SHOOT   PROC ;checks if coordinate inside cx and dx is inside the ball's circle. bx=1 for yes, bx=0 for no
    
    push cx     
    push dx     ;keep row and column inside stack
    
    cmp cx, shootcenter_x   ;check if current point is left or right of center
    jge cx_is_positiveSH
    
    mov ax, shootcenter_x
    sub ax, cx
    xchg ax, cx                 ;now center_x - current_x is in cx
    jmp delta_x_is_calculatedSH
        
    cx_is_positiveSH: 
        sub cx, shootcenter_x   ;now current_x - center_x is in cx
        jmp delta_x_is_calculatedSH
    
        delta_x_is_calculatedSH:
        mov al, cl
        mul cl          ;delta_x^2 inside ax
        push ax         ;push ax to stack
        
        cmp dx, shootcenter_y   ;check if current point is up or down of center
        jge dx_is_positiveSH
    
    mov ax, shootcenter_y
    sub ax, dx
    xchg ax, dx                 ;now center_y - current_y is in cx
    jmp delta_y_is_calculatedSH
    
    dx_is_positiveSH:
    sub dx, shootcenter_y   ;now current_y - center_y is in cx
    jmp delta_y_is_calculatedSH
    
    delta_y_is_calculatedSH:
        mov al, dl
        mul dl          ;delta_y^2 is inside ax
        push ax         ;push ax to stack
        
        calculate_distance_squaredSH:
        pop bx                          
        pop ax
        add bx, ax                      ;calculate delta_x^2 + delta_y^2
        cmp bx, ball_radius_square
        jle point_is_inside_circleSH
        jg point_is_outside_circleSH
        
        point_is_inside_circleSH:
        mov bx, 1
        jmp check_inside_ball_exitSH
    
        point_is_outside_circleSH:
        mov bx, 0
        jmp check_inside_ball_exitSH         

        check_inside_ball_exitSH:
        pop dx
        pop cx
        RET
    
        CHECK_INSIDE_SHOOT   ENDP 
;---------------------
MOVE_BALL   PROC       
    
    mov ax, ball_velocity_x
    add ball_center_x, ax
    mov ax, ball_velocity_y
    add ball_center_y, ax
    
    RET
    
MOVE_BALL   ENDP
;--------------------
MOVE_SHOOT   PROC       
    
    mov ax, 0
    sub shootcenter_x, ax
    mov ax, 6
    sub shootcenter_y, ax
    
    RET
    
    MOVE_SHOOT   ENDP
;---------------------
   
CHECK_KEYBOARD_EVENTS   PROC
   mov si,0
    mov ah, 01h
    int 16h
    jnz lg ;jz
     jmp racket_movement_end
     lg:
    mov ah, 00h
    int 16h
    
    cmp ah,4bh
    je racket_move_up

    cmp ah, 4dh
    
    je racket_move_down
    
    cmp al,32
   je lbl
    
   cmp al, 'q'
   jne L_g
   mov dummy3,1
   jmp  end_Subprogram
   L_g:
    racket_move_up:                       
        mov ax, racket_move_velocity
        sub racket_start_x, ax
        mov ax, right_margin
        cmp racket_start_x, ax
        jl dum1
		jmp racket_movement_end
		dum1:
        mov ax, right_margin
        mov racket_start_x, ax
        jmp racket_movement_end
    
    racket_move_down:
        mov ax, racket_move_velocity
        add racket_start_x, ax
        mov ax, WINDOW_WIDTH
        sub ax, left_margin
        sub ax, racket_height
        cmp racket_start_x, ax
        jle racket_movement_end
        mov ax, WINDOW_WIDTH
        sub ax, left_margin
        sub ax, racket_height
        mov racket_start_x, ax
        jmp racket_movement_end
        lbl:
        whil :
           cmp shootcenter_y,0
           je chfirst
           ;here check collosion with shot or not
           mov ax,ball_center_x
          cmp ax,shootcenter_x
          je xeqx
          jmp loklok
          xeqx:
		  mov ax,ball_center_y
          cmp  ax,shootcenter_y
            jne loklok
            inc opponentPoints
		 jmp racket_movement_end
           ;----------------
   loklok: CALL CLEAR_SHOOT
           CALL CLEAR_RACKET
           
           CALL CLEAR_BALL
           
           CALL MOVE_SHOOT
           CALL MOVE_BALL
           CALL CHECK_BALL_COLLISION
           CALL DRAW_SHOOT
           CALL DRAW_RACKET
           CALL DRAW_BALL
           CALL DELAY
           JMP whil
           
           chfirst: 
           mov ax,racket_start_x
           mov bx, racket_start_y
           mov shootcenter_x,ax
           mov shootcenter_y,bx
 CALL CLEAR_BALL
 CALL CLEAR_SHOOT
  racket_movement_end:
   mov ax,racket_start_x
           mov bx, racket_start_y
         ;  add ax,5
         ;
        ; add bx,10
           mov shootcenter_x,ax
           mov shootcenter_y,bx
           CALL CLEAR_BALL
           CALL CLEAR_SHOOT
           
		   
		end_Subprogram: 
        RET
    
CHECK_KEYBOARD_EVENTS   ENDP    
;---------------------
CHECK_BALL_COLLISION PROC
    call CHECK_BALL_RIGHT_COLLISION
    call CHECK_BALL_LEFT_COLLISION
    call CHECK_BALL_TOP_COLLISION
    call CHECK_BALL_BOTTOM_COLLISION
    
    RET
    
CHECK_BALL_COLLISION ENDP
;---------------------
CHECK_BALL_LEFT_COLLISION PROC
    
    mov bx, ball_center_x
    sub bx, ball_radius
    cmp bx, left_margin     ;did the ball touch the left border?
    jle left_collided
    jg left_collision_end
    
    left_collided:
        mov ax, left_margin
        mov ball_center_x, ax
        mov ax, ball_radius
        add ball_center_x, ax   ;putting ball on the left border (in case it passed it)
         call GET_RANDOM_COLOR
        not ball_velocity_x
        add ball_velocity_x, 1  ;multiplied the x velocity by -1, so the direction of it changes.        
    
    left_collision_end:    
        RET
    
CHECK_BALL_LEFT_COLLISION ENDP
;----------------------------------
CHECK_BALL_RIGHT_COLLISION PROC
    
    mov bx, ball_center_x
    add bx, ball_radius
    mov ax ,WINDOW_WIDTH
    sub ax, bx
    cmp ax, right_margin     ;did the ball touch the left border?
    jle rihgt_collided
    jg right_collision_end
    
    rihgt_collided:
    mov ax,right_margin
    sub ball_center_x,ax
   call GET_RANDOM_COLOR
        not ball_velocity_x
        add ball_velocity_x, 1  ;multiplied the x velocity by -1, so the direction of it changes.        
    
        right_collision_end:    
        RET
    
 CHECK_BALL_RIGHT_COLLISION ENDP
 ;---------------------*------------
CHECK_BALL_TOP_COLLISION PROC
    
    mov bx, ball_center_y
    sub bx, ball_radius
    cmp bx, top_margin      ;did the ball touch the top border?
    jle top_collided
    jg top_collision_end
    
    top_collided:
        mov ax, top_margin
        mov ball_center_y, ax
        mov ax, ball_radius
        add ball_center_y, ax   ;putting ball on the top border (in case it passed it)
        call GET_RANDOM_COLOR 
        not ball_velocity_y
        add ball_velocity_y, 1  ;multiplied the y velocity by -1, so the direction of it changes.
        
    top_collision_end:     
        RET
    
CHECK_BALL_TOP_COLLISION ENDP
;---------------------       
CHECK_BALL_BOTTOM_COLLISION PROC
    
    mov bx, ball_center_y
    add bx, ball_radius
    mov cx, WINDOW_HEIGHT
    sub cx, bottom_margin
    cmp bx, cx   ;did the ball touch the bottom border?
    jge bottom_collided
    jl bottom_collision_end
    
    bottom_collided:
        mov ax, WINDOW_HEIGHT
        sub ax, bottom_margin
        mov ball_center_y, ax
        mov ax, ball_radius
        sub ball_center_y, ax   ;putting ball on the bottom border (in case it passed it)
         call GET_RANDOM_COLOR
        not ball_velocity_y
        add ball_velocity_y, 1  ;multiplied the y velocity by -1, so the direction of it changes.
        
    bottom_collision_end:
        RET
    
CHECK_BALL_BOTTOM_COLLISION ENDP    
;--------------------
DELAY PROC       
        
    mov ah, 86h
    mov cx, 0h
     mov dx, 0a028h  ;wait for 41 miliseconds (for 24 fps)
    int 15h
    
    RET
    
DELAY ENDP
;------------------
CLEAR_BALL  PROC    ;same as draw ball, with black color
    
    mov dx, ball_center_y        
    sub dx, ball_radius         ;Initial row for drawing the ball
    
    clear_ball_loop1:
        mov cx, ball_center_x    
        sub cx, ball_radius     
        
        clear_ball_loop2:
            mov ah, 0ch         ;code for drawing pixel
            mov al, 00h         ;color (black)
            int 10h             ;interupt
            inc cx              ;go to next column
            mov ax, ball_center_x    ;checking if code reached end of column
            add ax, ball_radius    
            cmp cx, ax
            jnz clear_ball_loop2
            
            inc dx                  ;go to next tow
            mov ax, ball_center_y    ;checking if code reached end of row
            add ax, ball_radius
            cmp dx, ax
            jnz clear_ball_loop1    
    RET  
CLEAR_BALL  ENDP 
;---------------------
CLEAR_SHOOT  PROC    ;same as draw ball, with black color
    
    mov dx, shootcenter_y        ;
    sub dx, ball_radius         ;Initial row for drawing the ball
    
    clear_ball_loop1SH:
    mov cx, shootcenter_x    ;
        sub cx, ball_radius     ;initial column for drawing the ball
        
        clear_ball_loop2SH:
            mov ah, 0ch         ;code for drawing pixel
            mov al, 00h         ;color (black)
            int 10h             ;interupt
            inc cx              ;go to next column
            mov ax, shootcenter_x    ;checking if code reached end of column
            add ax, ball_radius    
            cmp cx, ax
            jnz clear_ball_loop2SH
            
            inc dx                  ;go to next tow
            mov ax, shootcenter_y    ;checking if code reached end of row
            add ax, ball_radius
            cmp dx, ax
            jnz clear_ball_loop1SH
    
    RET
    
    CLEAR_SHOOT  ENDP    
;---------------------
CLEAR_RACKET    PROC
    
    mov dx, racket_start_y  ;initial row for drawing the racket
    
    clear_racket_loop1:
        mov cx, racket_start_x  ;initial column for drawing the ball
        
        clear_racket_loop2:
            mov ah, 0ch
            mov al, 00h
            int 10h
            inc cx
            mov ax, racket_start_x
            add ax, racket_width
            cmp cx, ax
            jnz clear_racket_loop2
            
            inc dx
            mov ax, racket_start_y
            add ax, racket_height
            cmp dx, ax
            jnz clear_racket_loop1     
    RET
    
CLEAR_RACKET    ENDP
;---------------------
DRAW_RACKET PROC
    
    mov dx, racket_start_y
    
    draw_racket_loop1:
        mov cx, racket_start_x
        
        draw_racket_loop2:
            mov ah, 0ch
            mov al, 25h
            int 10h
            
            inc cx
            mov ax, racket_start_x
            add ax, racket_width
            cmp cx, ax
            jnz draw_racket_loop2
            
            inc dx
            mov ax, racket_start_y
            add ax, racket_height
            cmp dx, ax
            jnz draw_racket_loop1
    
    RET
    
DRAW_RACKET ENDP    
;---------------------
CLEAR_SCREEN    PROC
    
    mov ah, 06H     ;scroll up
    mov al, 00h     ;clear entire window
    mov bh, 00h     ;color    
    mov cx, 0000    ;start row, column
    mov dx, 184fh   ;end  row, column
    int 10h
      
    RET
    
CLEAR_SCREEN    ENDP
;---------------------
SET_GRAPHIC_MODE    PROC
       
    mov ah, 00h     ;setting video mode
    mov al, 13h     ;320x200 256 colors 
    int 10h         ;call interruption
    
    mov ax, 1003h
    mov bl, 00h
    mov bh, 00h
    int 10h         ;disable blinking for background      
    
    RET
    
    SET_GRAPHIC_MODE    ENDP  
;---------------------
InitGame	PROC
	mov ax, ball_radius
    mul ball_radius
    mov ball_radius_square, ax  ;initializing ball_radius_square
    
    mov ax, WINDOW_WIDTH
    sub ax, racket_margin
    sub ax, racket_width
    mov racket_start_x, 150      
	;----------------   
	mov ax, racket_start_x

    mov bx,racket_start_y
    
     mov shootcenter_x,ax
     mov shootcenter_y,bx
     ;-----------------
    CALL SET_GRAPHIC_MODE    
    
    move_ball_loop:   
      call CLEAR_BALL
        call MOVE_BALL       
        call CLEAR_RACKET        
        call CHECK_KEYBOARD_EVENTS         
		cmp dummy3,1
		je end_program
        call CHECK_BALL_COLLISION      
        call DRAW_RACKET
        call DRAW_BALL        
        call DELAY              
        jmp move_ball_loop
    
    end_program:
	mov dummy3,0
	RET
InitGame	ENDP
;=========================================================================

;==================================MACRO===================================
;this is a macro to change foreground and background color of a screen
changeForBackColor MACRO forColor,BackColor
    MOV AH,06H
    ;use BH as register to put the 2 values sticked together
    MOV BH,BackColor  
    MOV CL,4
    SHL BH,CL
    OR  BH,forColor
    
    XOR AL, AL     ; Clear entire screen    => same as MOV al,0
    XOR CX, CX     ; Upper left corner CH=row, CL=column  => same as MOV cx, 0
    MOV DX, 184FH  ; lower right corner DH=row, DL=column
    INT 10H    
        
ENDM 
;==========================================================================  


;==================================MACRO===================================
;this is a macro to display a byte
displayByteByConvertingItToAscii    MACRO   num,forColor,BackColor
    LOCAL BEGINTOPRINTTHENEXTNUM,MULTIPLYBWITHFACTOR,EXITMULTIPLYINGBBYAFACTOR
    ;the idea of this function is that it takes a nuumber like 232 , it divides it first by 100 then it pints 2
    ;then the remainder is 32 , it takes this remainder and divides it by 10 then it prints 3
    ;then the remainder is 2 , t takes this remainder and divide it by 1 and then it prints 2

    MOV DL,3
    MOV DH,num
    
    BEGINTOPRINTTHENEXTNUM:
    ;calculate the vale of divisor
    MOV BH,DL
    SUB BH,01H
    MOV AL,1
    MOV CL,10
    MULTIPLYBWITHFACTOR: 
    CMP BH,0H
    JE  EXITMULTIPLYINGBBYAFACTOR   
    MUL CL
    DEC BH                  
    JMP MULTIPLYBWITHFACTOR 
    EXITMULTIPLYINGBBYAFACTOR:
    MOV BL,AL
    
    ;calculate the result of division
    MOV AL,DH  
    MOV AH,0H
    DIV BL          ;AL = AX/BL , AH = AX%BL
    MOV DH,AH
    ADD AL,'0'
    
    ;print the number on the screen
    MOV AH,09H
    MOV BH,0H
    MOV BL,BackColor
    MOV CL,4
    SHL BL,CL
    OR BL,forColor
    MOV CX,1H
    INT 10H
    
    PUSH DX
    ;get the cursor position and adjust it
    MOV BH,0H
    MOV AH,03H      ;DH : row ,DL : column
    INT 10H 
    ;then increment the column number and set the new cursor position to it
    INC DL
    MOV AH,02H
    INT 10H    
    POP DX 
    
    ;repeat
    DEC DL
    JNZ BEGINTOPRINTTHENEXTNUM

ENDM
;========================================================================== 

;==================================MACRO===================================
;this is a macro to display a word
displayWordByConvertingItToAscii    MACRO   num,forColor,BackColor

    ;the idea of this function is that it takes a nuumber like 232 , it divides it first by 100 then it pints 2
    ;then the remainder is 32 , it takes this remainder and divides it by 10 then it prints 3
    ;then the remainder is 2 , t takes this remainder and divide it by 1 and then it prints 2
    LOCALS @@      ;this will define any lable with prefix @@ to be a local variable
    
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV DX,num
    MOV BL,5
    
    @@BEGINTOPRINTTHENEXTNUM:
    ;calculate the vale of divisor 
    MOV AH,0H
    MOV BH,BL
    SUB BH,01H
    MOV AL,1
    MOV CX,10
    @@MULTIPLYBWITHFACTOR: 
    CMP BH,0H
    JE  @@EXITMULTIPLYINGBBYAFACTOR    
    PUSH DX
    MUL CX 
    POP DX
    DEC BH                  
    JMP @@MULTIPLYBWITHFACTOR 
    @@EXITMULTIPLYINGBBYAFACTOR:
    PUSH BX
    
    MOV BX,AX
    
    ;calculate the result of division
    MOV AX,DX                                  
    MOV DX,0
    DIV BX          ;AX = (DX AX)/BX , DX = (DX AX)%BX
    ADD AL,'0'
    
    
    ;print the number on the screen
    MOV AH,09H
    MOV BH,0H
    MOV BL,BackColor
    MOV CL,4
    SHL BL,CL
    OR BL,forColor
    MOV CX,1H
    INT 10H
    
    PUSH DX
    ;get the cursor position and adjust it
    MOV BH,0H
    MOV AH,03H      ;DH : row ,DL : column
    INT 10H 
    ;then increment the column number and set the new cursor position to it
    INC DL
    MOV AH,02H
    INT 10H    
    POP DX 
    
    POP BX
    ;repeat
    DEC BL
    JNZ @@BEGINTOPRINTTHENEXTNUM
    
    POP DX
    POP CX
    POP BX
    POP AX

ENDM
;========================================================================== 

;==================================MACRO===================================
;this is a macro to display a word => this is a special micro 
displaySourceNumberByConvertingItToAscii    MACRO   num,forColor,BackColor

    ;the idea of this function is that it takes a nuumber like 232 , it divides it first by 100 then it pints 2
    ;then the remainder is 32 , it takes this remainder and divides it by 10 then it prints 3
    ;then the remainder is 2 , t takes this remainder and divide it by 1 and then it prints 2
    ;DI must be entered with pointer to the address of place to store command 4
    
    LOCALS @@      ;this will define any lable with prefix @@ to be a local variable
    
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    ;check how many digits in num to display
    MOV AX,num
    MOV CX,10
    MOV DX,0
    MOV BL,0
    @@GetNumOfDigitsForWord:
    INC BL
    DIV CX      ;AX = (DX AX)/BX , DX : remainder
    MOV DX,0
    CMP AX,0
    JNE @@GetNumOfDigitsForWord
    
    MOV DX,num
    
    @@BEGINTOPRINTTHENEXTNUM:
    ;calculate the vale of divisor 
    MOV AH,0H
    MOV BH,BL
    SUB BH,01H
    MOV AL,1
    MOV CX,10
    @@MULTIPLYBWITHFACTOR: 
    CMP BH,0H
    JE  @@EXITMULTIPLYINGBBYAFACTOR    
    PUSH DX
    MUL CX 
    POP DX
    DEC BH                  
    JMP @@MULTIPLYBWITHFACTOR 
    @@EXITMULTIPLYINGBBYAFACTOR:
    PUSH BX
    
    MOV BX,AX
    
    ;calculate the result of division
    MOV AX,DX                                  
    MOV DX,0
    DIV BX          ;AX = (DX AX)/BX , DX = (DX AX)%BX
    ADD AL,'0'
    
    MOV [DI],AL
    INC DI
    
    ;print the number on the screen
    MOV AH,09H
    MOV BH,0H
    MOV BL,BackColor
    MOV CL,4
    SHL BL,CL
    OR BL,forColor
    MOV CX,1H
    INT 10H
    
    PUSH DX
    ;get the cursor position and adjust it
    MOV BH,0H
    MOV AH,03H      ;DH : row ,DL : column
    INT 10H 
    ;then increment the column number and set the new cursor position to it
    INC DL
    MOV AH,02H
    INT 10H    
    POP DX 
    
    POP BX
    ;repeat
    DEC BL
    JNZ @@BEGINTOPRINTTHENEXTNUM
    
    POP DX
    POP CX
    POP BX
    POP AX

ENDM
;========================================================================== 

;================================== PROCEDURE ===================================
;this procedure is to display the registers with its values in it
displayRegistersListInHorizontal    PROC 
    ;the address of the list will be passed by the user through SI

    ;display the list headers
    MOV DX,OFFSET registersList
    MOV AH,09H
    INT 21H
    
    ;get the cursor place
    MOV AH,03H      ;DH = row , DL = column
    MOV BH,0H
    INT 10H

    ;set the cursor to a new line
    MOV DL,10H
    INC DH
    MOV AH,02H
    INT 10H
    
    ;print the | in the current position
    MOV AH,02H
    MOV DL,'|'
    INT 21H    
    
    ;print the values in the array
    MOV CL,8
    
    ;print the numbers in the array word by word
    DISPLAYLISTLOOPINHOROZONTAL:
    PUSH CX
    displayWordByConvertingItToAscii    [SI],0FH,6
    
    ;display | as a separtion between addresses
    ;print the | in the current position
    MOV AH,02H
    MOV DL,'|'
    INT 21H
    
    POP CX
    INC SI
    INC SI
    DEC CL
    JNZ DISPLAYLISTLOOPINHOROZONTAL   

    RET
displayRegistersListInHorizontal ENDP
;================================================================================

;==================================MACRO===================================
displayAddressesListInHorozontal    MACRO    addressListValues
    LOCAL DISPLAYLISTLOOPINHOROZONTAL
    ;display the list headers
    MOV DX,OFFSET addressListHeaders
    MOV AH,09H
    INT 21H
    
    ;get the cursor place
    MOV AH,03H      ;DH = row , DL = column
    MOV BH,0H
    INT 10H

    ;set the cursor to a new line
    MOV DL,7
    INC DH
    MOV AH,02H
    INT 10H
    
    ;print '|'
    MOV AH,02H
    MOV DL,'|'
    INT 21H
    
    ;print the values in the array
    MOV CL,16
    
    ;print the numbers in the array byte by byte
    PUSH SI
    MOV SI,OFFSET addressListValues
    DISPLAYLISTLOOPINHOROZONTAL:
    PUSH CX
    displayByteByConvertingItToAscii    [SI],0FH,6
    ;display | as a separtion between addresses
    ;print the | in the current position
    MOV AH,02H
    MOV DL,'|'
    INT 21H
    
    POP CX
    INC SI
    DEC CL
    
    JNZ DISPLAYLISTLOOPINHOROZONTAL
    POP SI
    
ENDM

;========================================================================== 

;==================================MACRO===================================
displayUserNameWithHisPoints  MACRO  name,Points
    LOCAL PRINTPOINTSFORUSERNAME    

    ;display the name
    MOV DX,OFFSET name
    MOV AH,9H
    INT 21H
    
    ;display the space with :
    MOV DL,' '  ;character to display , after execution AL = DL
    MOV AH,2H
    INT 21H

    MOV DL,':'  ;character to display , after execution AL = DL
    MOV AH,2H
    INT 21H

    MOV DL,' '  ;character to display , after execution AL = DL
    MOV AH,2H
    INT 21H   
    
    PUSH SI
    ;convert the points number into ascii
    MOV SI,OFFSET NUMtoBeDisplayed
    
    ;get the hundredth
    MOV AL,Points
    MOV AH,0H
    MOV BL,100      
    DIV BL
    ADD AL,'0'
    MOV [SI],AL
    INC SI
    
    ;get the tenths
    MOV AL,Points
    MOV AH,0H
    MOV BL,10     
    DIV BL
    MOV BL,AL
    MOV AX,0H
    MOV AL,BL
    MOV BL,10
    DIV BL
    ADD AH,'0'
    MOV [SI],AH
    INC SI 
   
    ;get the units
    MOV AL,Points
    MOV AH,0H
    MOV BL,10     
    DIV BL
    ADD AH,'0'
    MOV [SI],AH
    INC SI 
    
    ;display the points  
    MOV SI,OFFSET NUMtoBeDisplayed
    MOV DH,03H
    
    PRINTPOINTSFORUSERNAME:
    MOV AL,[SI]  ;character to display    
    MOV BH,0     ;page number
    MOV BL,21H   ;color
    MOV CX,1H    ;numebr of tinmes to repeat the character
    MOV AH,09H  
    INT 10H

    ;get the cursor position
    MOV BL,DH
    MOV AH,03H
    MOV BH,0H
    INT 10H
    
    ;increment the cursor
    INC DL
    MOV AH,02H
    INT 10H
    MOV DH,BL
    
    INC SI  
    DEC DH  
    JNZ PRINTPOINTSFORUSERNAME
    
    POP SI
    
ENDM
;========================================================================== 

;==================================MACRO===================================
;this is a mcro to display a list , where ',' is the considered the delimit char to define a new line
displayList MACRO listName 
    local DISPLAY,NEWLINE,NEWCOLUMN,CURRENTCOLUMN,PRINT,DISP,NEXT 
    
    ;use DH as temp register to store the character to display in it
    MOV SI,OFFSET listName   
    MOV BL,0H ;temp register for column place
    
    DISPLAY: 
    ;check for a new line
    CMP DH,','     
    JE NEWLINE
    JNE DISP 
    
    NEWLINE:
    ;get cursor position (saved in DL(X),DH(Y))
    MOV AH,3H
    MOV BH,0H   ;BH represent page number
    INT 10H                           
    
    ;increment the y of the cursor to a new line 
    ;see if y reached a certain row value (15) then we will make a new column else we will complete the current column 
    CMP DH,0FH
    JNE CURRENTCOLUMN
    
    NEWCOLUMN:
    MOV DH,2H
    ADD BL,25
    MOV DL,BL 
    JMP PRINT
    
    CURRENTCOLUMN:    
    INC DH      
    MOV DL,BL   
    
    PRINT:
    MOV AH,2H
    INT 10H
    JMP NEXT
    
    DISP:
    MOV AH,2
    MOV DL,[SI]
    INT 21H 
    NEXT:
    INC SI
    MOV DH,[SI]
    CMP DH,'$'
    JNE DISPLAY

ENDM 
;========================================================================== 
                      
;==================================MACRO===================================                      
;these are two micros to display horizontal and vertical dashed lines
displayHorizontalLine MACRO rowNum,startPos,endPos,pageNum,forColor,BackColor 
    
    ;set the cursor to the desired position
    MOV BH,pageNum  ;page   
    MOV DH,rowNum   ;Y
    MOV DL,startPos ;X
    MOV AH,2
    INT 10h     
    
    
    ;display the line 
    MOV CL,4
    MOV BL,BackColor     ;white(F) on blue (1) background
    SHL BL,CL
    OR BL,forColor
    MOV AH,9H       ;Display
    MOV BH,pageNum  ;Page 
    MOV AL,'='      ;char to be displayed
    MOV CX,endPos   ;number of times 
    SUB CX,startPos
    INT 10h
    
ENDM 

displayVerticalLine MACRO columnNum,startPos,endPos,pageNum,forColor,BackColor 
    local L
    ;set the cursor to the desired position
    MOV BH,pageNum  ;page   
    MOV DH,startPos ;Y
    MOV DL,columnNum;X
    MOV AH,2
    INT 10h 
    
    L:
    ;display the line
    MOV CL,4
    MOV BL,BackColor     ;white(F) on blue (1) background
    SHL BL,CL
    OR BL,forColor    
    MOV AH,9H       ;Display
    MOV BH,pageNum  ;Page 
    MOV AL,'|'      ;char to be displayed  
    MOV CX,1        ;number of times   
    INT 10h      
    
    ;get cursor position (saved in DL(X),DH(Y))
    MOV AH,3H
    MOV BH,pageNum  ;BH represent page number
    INT 10H
    
    ;set the cursor to next row
    MOV BH,pageNum  ;page   
    INC DH          ;Y
    MOV DL,columnNum;X
    MOV AH,2
    INT 10h    
    ;see if we reached the desired location
    CMP DH,endPos
    JNE L
    
ENDM

;==========================================================================


;================================== PROCEDURE ===================================  
displayFlagsNames    PROC

    ;first print the names of flags
    MOV SI,OFFSET flagsList
    
    ;use DH as temp register to store the character to display in it
    DisplayFlagSName: 
    ;check for a new line
    CMP DH,','     
    JE NEWLINE1
    JNE DISP1 
    
    NEWLINE1:
    ;get cursor position (saved in DL(X),DH(Y))
    MOV AH,3H
    MOV BH,0H   ;BH represent page number
    INT 10H                           
    ;move to new line 
    INC DH      
    SUB DL,5   
    
    ;print the character
    MOV AH,2H
    INT 10H
    JMP NEXT1
    
    DISP1:
    MOV AH,2
    MOV DL,[SI]
    INT 21H 
    
    NEXT1:
    INC SI
    MOV DH,[SI]
    CMP DH,'$'
    JNE DisplayFlagSName
   
    RET
displayFlagsNames   ENDP
;==========================================================================

;================================== PROCEDURE =================================== 
displayFlagsValues  PROC     
    ;CF = BIT0  (flagsName)
    ;PF = BIT2  (flagsName)
    ;AF = BIT4  (flagsName)
    ;ZF = BIT6  (flagsName)
    ;SF = BIT7  (flagsName)
    ;OF = BIT11 (flagsName)
    
    ;SI will hold the address of the flags
    
    ;second print the values in these flags
    

    ;display CF value
    MOV DX,[SI]
    AND DX,1
    ;print on screen
    MOV AL,DL
    ADD AL,'0'  ;character to display
    MOV BH,0    ;page number
    MOV CX,1    
    MOV BL,5FH  ;background
    MOV AH,09H
    INT 10H
    ;get cursor value 
    MOV BH,0        ;DH : row , DL : Column
    MOV AH,03H
    INT 10H
    ;set the cursor position to a new line
    INC DH
    MOV AH,2
    INT 10H
    
    ;display PF Value
    MOV DX,[SI]
    AND DX,4
    MOV CL,2
    SHR DX,CL
    ;print on screen
    MOV AL,DL
    ADD AL,'0'  ;character to display
    MOV BH,0    ;page number
    MOV CX,1    
    MOV BL,5FH  ;background
    MOV AH,09H
    INT 10H
    ;get cursor value 
    MOV BH,0        ;DH : row , DL : Column
    MOV AH,03H
    INT 10H
    ;set the cursor position to a new line
    INC DH
    MOV AH,2
    INT 10H
    
    ;display AF Value
    MOV DX,[SI]
    AND DX,16
    MOV CL,4
    SHR DX,CL
    ;print on screen
    MOV AL,DL
    ADD AL,'0'  ;character to display
    MOV BH,0    ;page number
    MOV CX,1    
    MOV BL,5FH  ;background
    MOV AH,09H
    INT 10H
    ;get cursor value 
    MOV BH,0        ;DH : row , DL : Column
    MOV AH,03H
    INT 10H
    ;set the cursor position to a new line
    INC DH
    MOV AH,2
    INT 10H
    
    ;display ZF Value
    MOV DX,[SI]
    AND DX,64
    MOV CL,6
    SHR DX,CL
    ;print on screen
    MOV AL,DL
    ADD AL,'0'  ;character to display
    MOV BH,0    ;page number
    MOV CX,1    
    MOV BL,5FH  ;background
    MOV AH,09H
    INT 10H
    ;get cursor value 
    MOV BH,0        ;DH : row , DL : Column
    MOV AH,03H
    INT 10H
    ;set the cursor position to a new line
    INC DH
    MOV AH,2
    INT 10H
    
    ;display SF Value
    MOV DX,[SI]
    AND DX,128
    MOV CL,7
    SHR DX,CL
    ;print on screen
    MOV AL,DL
    ADD AL,'0'  ;character to display
    MOV BH,0    ;page number
    MOV CX,1    
    MOV BL,5FH  ;background
    MOV AH,09H
    INT 10H
    ;get cursor value 
    MOV BH,0        ;DH : row , DL : Column
    MOV AH,03H
    INT 10H
    ;set the cursor position to a new line
    INC DH
    MOV AH,2
    INT 10H
    
    ;display OF Value
    MOV DX,[SI]
    AND DX,2048
    MOV CL,11
    SHR DX,CL
    ;print on screen
    MOV AL,DL
    ADD AL,'0'  ;character to display
    MOV BH,0    ;page number
    MOV CX,1    
    MOV BL,5FH  ;background
    MOV AH,09H
    INT 10H
    ;get cursor value 
    MOV BH,0        ;DH : row , DL : Column
    MOV AH,03H
    INT 10H
    ;set the cursor position to a new line
    INC DH
    MOV AH,2
    INT 10H
    
    RET
displayFlagsValues ENDP
;==========================================================================

;==================================MACRO===================================  
checkWhichChatToNavigateTo	MACRO
LOCAL NO3,NO4,NO5,NO6
	ENDARROW:
    ;look for the navigator to see what screen to navigate to
    CMP navigate,1
    JNE NO3
    JMP FIRSTCOMMAND
    
    NO3:
    CMP navigate,2
    JNE NO4
    JMP SECONDCOMMAND
    
    NO4:
    CMP navigate,3
    JNE NO5
    JMP THIRDCOMMAND
    
    NO5:
    CMP navigate,4
    JNE NO6
    JMP FOURTHCOMMAND
   
    NO6:
    CMP navigate,5
    JMP FIFTHCOMMAND
ENDM
;==========================================================================

;==================================MACRO===================================   
checkWhichPlaceToNavigateTo  MACRO
LOCAL ENDPAGE,NO12,NO1,ENDARROW,NO3,NO4,NO5,NO6,UNKNOWNNAVIGATOR,NO123

    ;left arrow or right is pressed
    CMP navigationIndex,2H
    JLE ENDARROW
    ;up arrow or down is pressed
    CMP navigationIndex,4H
    JLE ENDPAGE
    ;TODO : add f2 and f3
    
    ENDPAGE:
    ;look for page to switch to
    CMP PageNumber,0
    JNE NO12
    JMP FIRSTCOMMAND
    
    NO12:
    CMP PageNumber,1
    JNE NO1
    JMP PAGEONE_MAIN
    
    NO1:
    CMP PageNumber,2
    JNE NO123
    JMP PAGETWO_MAIN
	
	NO123:
	CMP PageNumber,3
    JNE UNKNOWNNAVIGATOR
    JMP InGameWindow
    
    
    ENDARROW:
    ;look for the navigator to see what screen to navigate to
    CMP navigate,1
    JNE NO3
    JMP FIRSTCOMMAND
    
    NO3:
    CMP navigate,2
    JNE NO4
    JMP SECONDCOMMAND
    
    NO4:
    CMP navigate,3
    JNE NO5
    JMP THIRDCOMMAND
    
    NO5:
    CMP navigate,4
    JNE NO6
    JMP FOURTHCOMMAND
   
    NO6:
    CMP navigate,5
    JMP FIFTHCOMMAND
    
    UNKNOWNNAVIGATOR:

ENDM
;==========================================================================


;================================== PROCEDURE ===================================
;this is a procedure to  display the command that the user have chosen
;it doesn't matter whether the user is you or the enemy
displayCommandThatTheUserChose  PROC

    ;store the entered command for execution (forbidden char)
    MOV DI,OFFSET commandEntered
    ;first we will display the choosend command -> can be extracted as follows : 
    ;index of command : command index * 4 + offset commandListNames
    MOV SI,OFFSET commandListNames
    MOV BL,4
    MOV AL,commandIndex
    SUB AL,1
    MUL BL      ;AX = AL * BL
    ADD SI,AX
    ;display the command
    MOV DH,4
    DISPLAYCOMMANDLOOP:
    MOV AL,[SI]
    ;to store the command
    MOV [DI],AL
    INC DI
    
    MOV BH,0
    MOV BL,3FH
    MOV CX,1
    MOV AH,09H
    INT 10H
    ;get cursor position
    PUSH DX
    MOV BH,0
    MOV AH,03H
    INT 10H     ;DH : row , DL : Column
    ;increment the cursor position
    INC DL
    MOV AH,2
    INT 10H
    POP DX
    ;get the next char
    INC SI
    DEC DH
    JNZ DISPLAYCOMMANDLOOP
    
    ;second check whether the command takes (0 operand or 1 operand or 2 operand)
    ;(24,25) => no operand 
    CMP commandIndex,24
    JL  AFIRSTORSECONDOPERANDSCOMMAND
    JMP ENDDISPLAYCOMMANDFORUSEPROC
    
    AFIRSTORSECONDOPERANDSCOMMAND:
    ;(16 -> 23) one operand
    CMP commandIndex,16
    JGE ThenGoTo1Operands
    JMP TWOOPERANDSSHOW
    
    ThenGoTo1Operands:
    ;index of operand : operand index * 2 + offset OperandListNames
    MOV SI,OFFSET OperandListNames
    MOV BL,2
    MOV AL,firstOperandIndex
    SUB AL,1
    MUL BL      ;AX = AL * BL
    ADD SI,AX
    ;put space to serpate command from first command
    MOV AL,' '
    MOV BH,0
    MOV BL,3FH
    MOV CX,1
    MOV AH,09H
    INT 10H
    ;get cursor position
    PUSH DX
    MOV BH,0
    MOV AH,03H
    INT 10H     ;DH : row , DL : Column
    ;increment the cursor position
    INC DL
    MOV AH,2
    INT 10H
    POP DX
    ;check if there is brackets in the first operand
    CMP isFirstOpBracket,1
    JNE DONTDISPLAYLEFTBRACKETFORFIRSTOPERAND1
    ;put left bracket to first operand
    MOV AL,'['
    MOV [DI],AL
    INC DI
    MOV BH,0
    MOV BL,3FH
    MOV CX,1
    MOV AH,09H
    INT 10H
    ;get cursor position
    PUSH DX
    MOV BH,0
    MOV AH,03H
    INT 10H     ;DH : row , DL : Column
    ;increment the cursor position
    INC DL
    MOV AH,2
    INT 10H
    POP DX     
    DONTDISPLAYLEFTBRACKETFORFIRSTOPERAND1:
    
    ;display the command
    MOV DH,2    
    DISPLAYFIRSTOPERANDFORONEOPERANDCOM:
    MOV AL,[SI]
    MOV [DI],AL
    INC DI
    MOV BH,0
    MOV BL,3FH
    MOV CX,1
    MOV AH,09H
    INT 10H
    ;get cursor position
    PUSH DX
    MOV BH,0
    MOV AH,03H
    INT 10H     ;DH : row , DL : Column
    ;increment the cursor position
    INC DL
    MOV AH,2
    INT 10H
    POP DX
    ;get the next char
    INC SI
    DEC DH
    JNZ DISPLAYFIRSTOPERANDFORONEOPERANDCOM
    ;check if there is brackets in the first operand
    CMP isFirstOpBracket,1 
    JNE DONTDISPLAYRIGHTBRACKETFORFIRSTOPERAND1
    ;put right bracket to first operand
    MOV AL,']'
    MOV [DI],AL
    INC DI
    MOV BH,0
    MOV BL,3FH
    MOV CX,1
    MOV AH,09H
    INT 10H
    ;get cursor position
    PUSH DX
    MOV BH,0
    MOV AH,03H
    INT 10H     ;DH : row , DL : Column
    ;increment the cursor position
    INC DL
    MOV AH,2
    INT 10H
    POP DX    
    
    DONTDISPLAYRIGHTBRACKETFORFIRSTOPERAND1: 
    
    JMP ENDDISPLAYCOMMANDFORUSEPROC
    
    ;(1 -> 15) one operand
    TWOOPERANDSSHOW:
    ;display the first operand
    ;index of operand : operand index * 2 + offset OperandListNames
    MOV SI,OFFSET OperandListNames
    MOV BL,2
    MOV AL,firstOperandIndex
    SUB AL,1
    MUL BL      ;AX = AL * BL
    ADD SI,AX
    ;put space to serpate command from first command
    MOV AL,' '
    MOV BH,0
    MOV BL,3FH
    MOV CX,1
    MOV AH,09H
    INT 10H
    ;get cursor position
    PUSH DX
    MOV BH,0
    MOV AH,03H
    INT 10H     ;DH : row , DL : Column
    ;increment the cursor position
    INC DL
    MOV AH,2
    INT 10H
    POP DX
    ;check if there is brackets in the first operand
    CMP isFirstOpBracket,1
    JNE DONTDISPLAYLEFTBRACKETFORFIRSTOPERAND
    ;put left bracket to first operand
    MOV AL,'['
    MOV [DI],AL
    INC DI
    MOV BH,0
    MOV BL,3FH
    MOV CX,1
    MOV AH,09H
    INT 10H
    ;get cursor position
    PUSH DX
    MOV BH,0
    MOV AH,03H
    INT 10H     ;DH : row , DL : Column
    ;increment the cursor position
    INC DL
    MOV AH,2
    INT 10H
    POP DX    
    
    DONTDISPLAYLEFTBRACKETFORFIRSTOPERAND:
    ;display the first operand
    MOV DH,2    
    DISPLAYFIRSTOPERANDFORTWOOPERANDCOM:
    MOV AL,[SI]
    MOV [DI],AL
    INC DI
    MOV BH,0
    MOV BL,3FH
    MOV CX,1
    MOV AH,09H
    INT 10H
    ;get cursor position
    PUSH DX
    MOV BH,0
    MOV AH,03H
    INT 10H     ;DH : row , DL : Column
    ;increment the cursor position
    INC DL
    MOV AH,2
    INT 10H
    POP DX
    ;get the next char
    INC SI
    DEC DH
    JNZ DISPLAYFIRSTOPERANDFORTWOOPERANDCOM   
   
    ;check if there is brackets in the first operand
    CMP isFirstOpBracket,1 
    JNE DONTDISPLAYRIGHTBRACKETFORFIRSTOPERAND
    ;put right bracket to first operand
    MOV AL,']'
    MOV [DI],AL
    INC DI
    MOV BH,0
    MOV BL,3FH
    MOV CX,1
    MOV AH,09H
    INT 10H
    ;get cursor position
    PUSH DX
    MOV BH,0
    MOV AH,03H
    INT 10H     ;DH : row , DL : Column
    ;increment the cursor position
    INC DL
    MOV AH,2
    INT 10H
    POP DX    
    
    DONTDISPLAYRIGHTBRACKETFORFIRSTOPERAND:    
    
    ;display the comma
    ;put comma to serpate command from first command
    MOV AL,','
    MOV [DI],AL
    INC DI
    MOV BH,0
    MOV BL,3FH
    MOV CX,1
    MOV AH,09H
    INT 10H
    ;get cursor position
    PUSH DX
    MOV BH,0
    MOV AH,03H
    INT 10H     ;DH : row , DL : Column
    ;increment the cursor position
    INC DL
    MOV AH,2
    INT 10H
    POP DX    
    
    ;display the second operand 
    
    ;first check if the source is a register or a number
    CMP secondOperandIndex,17
    JNE THESOURCEISAREGISTERTODISPLAY
    JMP DISPLAYANUMBERENTERED
    
    THESOURCEISAREGISTERTODISPLAY:
    ;check if there is brackets in the first operand
    CMP isSecondOpBracket,1 
    JNE DONTDISPLAYLEFTBRACKETFORSECONDOPERAND
    ;put left bracket to second operand
    MOV AL,'['
    MOV [DI],AL
    INC DI
    MOV BH,0
    MOV BL,3FH
    MOV CX,1
    MOV AH,09H
    INT 10H
    ;get cursor position
    PUSH DX
    MOV BH,0
    MOV AH,03H
    INT 10H     ;DH : row , DL : Column
    ;increment the cursor position
    INC DL
    MOV AH,2
    INT 10H
    POP DX    
    
    DONTDISPLAYLEFTBRACKETFORSECONDOPERAND: 
    
    ;index of operand : operand index * 2 + offset OperandListNames
    MOV SI,OFFSET OperandListNames
    MOV BL,2
    MOV AL,secondOperandIndex
    SUB AL,1
    MUL BL      ;AX = AL * BL
    ADD SI,AX
    ;display the command
    MOV DH,2    
    DISPLAYSECONDOPERANDFORTWOOPERANDCOM:
    MOV AL,[SI]
    MOV [DI],AL
    INC DI
    MOV BH,0
    MOV BL,3FH
    MOV CX,1
    MOV AH,09H
    INT 10H
    ;get cursor position
    PUSH DX
    MOV BH,0
    MOV AH,03H
    INT 10H     ;DH : row , DL : Column
    ;increment the cursor position
    INC DL
    MOV AH,2
    INT 10H
    POP DX
    ;get the next char
    INC SI
    DEC DH
    JNZ DISPLAYSECONDOPERANDFORTWOOPERANDCOM     
    
    ;check if there is brackets in the first operand
    CMP isSecondOpBracket,1 
    JNE DONTDISPLAYRIGHTBRACKETFORSECONDOPERAND
    ;put right bracket to second operand
    MOV AL,']'
    MOV [DI],AL
    INC DI
    MOV BH,0
    MOV BL,3FH
    MOV CX,1
    MOV AH,09H
    INT 10H
    ;get cursor position
    PUSH DX
    MOV BH,0
    MOV AH,03H
    INT 10H     ;DH : row , DL : Column
    ;increment the cursor position
    INC DL
    MOV AH,2
    INT 10H
    POP DX    
    
    DONTDISPLAYRIGHTBRACKETFORSECONDOPERAND:
    JMP ENDDISPLAYCOMMANDFORUSEPROC
   
    DISPLAYANUMBERENTERED:
    ;check if there is brackets in the first operand
    CMP isSecondOpBracket,1 
    JNE DONTDISPLAYLEFTBRACKETFORSECONDOPERAND1
    ;put left bracket to second operand
    MOV AL,'['
    MOV [DI],AL
    INC DI
    MOV BH,0
    MOV BL,3FH
    MOV CX,1
    MOV AH,09H
    INT 10H
    ;get cursor position
    PUSH DX
    MOV BH,0
    MOV AH,03H
    INT 10H     ;DH : row , DL : Column
    ;increment the cursor position
    INC DL
    MOV AH,2
    INT 10H
    POP DX    
    DONTDISPLAYLEFTBRACKETFORSECONDOPERAND1:
    displaySourceNumberByConvertingItToAscii numberEntered,0FH,3
    
    CMP isSecondOpBracket,1 
    JNE DONTDISPLAYRIGHTBRACKETFORSECONDOPERAND1
    ;put right bracket to second operand
    MOV AL,']'
    MOV [DI],AL
    INC DI
    MOV BH,0
    MOV BL,3FH
    MOV CX,1
    MOV AH,09H
    INT 10H
    ;get cursor position
    PUSH DX
    MOV BH,0
    MOV AH,03H
    INT 10H     ;DH : row , DL : Column
    ;increment the cursor position
    INC DL
    MOV AH,2
    INT 10H
    POP DX 
    DONTDISPLAYRIGHTBRACKETFORSECONDOPERAND1:
    
    ENDDISPLAYCOMMANDFORUSEPROC:
    MOV AH,'$';
    MOV [DI],AH
    RET
displayCommandThatTheUserChose ENDP
;================================================================================


;================================== PROCEDURE ===================================
;this macro is to navigate
navigateBetweenScreens PROC 

    ;check for entered arrow
    ;left arrow was clicked
    CMP AH,4BH
    JE LEFTARROW
    ;right arrow was clicked
    CMP AH,4DH
    JE RIGHTARROW 
    ;up arrow was clicked
    CMP AH,48H
    JE UPARROW
    ;down arrow was clicked    
    CMP AH,50H
    JE DOWNARROW    
    ;ENTER IS PRESSED
    CMP AL,13
    JE ENTERKEY
    ;F2 was clicked
    CMP AH,3CH 
    JE F2Key
	;F3 was clicked
    CMP AH,3DH 
    JE F3Key	
    ;F4 was clicked
    CMP AH,3EH 
    JE F4Key
    JMP NOTANAVIGATEBUTTON
    
    LEFTARROW:
    MOV isANavigateButton,01H
    DEC navigate
    MOV navigationIndex,1
    JMP DONOTHING
     
    RIGHTARROW: 
    MOV isANavigateButton,01H
    INC navigate
    MOV navigationIndex,2
    JMP DONOTHING
     
    UPARROW:
    MOV isANavigateButton,01H
    DEC PageNumber
    MOV navigationIndex,3
    JMP DONOTHING 
    
    DOWNARROW:
    MOV isANavigateButton,01H
    INC PageNumber
    MOV navigationIndex,4
    JMP DONOTHING
    
    ENTERKEY:
    MOV navigationIndex,7
    JMP DONOTHING
	
	F2Key:
	MOV isANavigateButton,01H
	MOV navigationIndex,5
    JMP DONOTHING
 
	F3KEY:
	MOV isANavigateButton,01H
	MOV navigationIndex,6
    JMP DONOTHING

	F4KEY:
	MOV isANavigateButton,01H
	MOV navigationIndex,8
    JMP DONOTHING

	
    NOTANAVIGATEBUTTON:
    MOV isANavigateButton,0H
    
    NO2:
    DONOTHING:
    RET            
navigateBetweenScreens ENDP
;================================================================================
 

;================================== PROCEDURE ===================================
;this is amacro for massaging purposes
readAndSendMassages  PROC

    ;move cursor to the required position
    MOV BH,PageNumber ;page
    MOV DH,cursorY    ;Y
    MOV DL,cursorX    ;X
    MOV AH,2
    INT 10h 
    
    PUSH SI
    MOV SI,OFFSET messageToBeSend 
    ;while the user didn't press enter we will enter the message 
    L:
    ;reading number enter from the user and display it 
    MOV AH,0H   ;get key pressed : AH : scancode , AL : Ascii code
    INT 16H 
    ;check if f3 is pressed to exit cahtting mode
    CMP AH,3DH
    JNE MESSAGE
    
    ;return to command screen
    CMP navigate,1
    JNE NO7
    ;CALL firstInputCommand
    
    NO7:
    CMP navigate,2
    JNE NO8
    ;CALL secondInputCommand
    
    NO8:
    CMP navigate,3
    JNE NO9
    ;CALL thirdInputCommand
    
    NO9:
    CMP navigate,4
    JNE NO10
    ;CALL fourthInputCommand
   
    NO10:
    CMP navigate,5
    JNE NO11
    ;CALL fifthInputCommand
    
    NO11:
    ;check if enter is clicked to send the message
    CMP AH,1CH
    ;----------------------------------------
    ;TODO : WRITE THE CODE TO SEND A MESSAGE |
    ;----------------------------------------    
    ;SENDMESSAGE:    
    ;set the cursor position
    MOV BH,PageNumber ;page
    MOV DH,cursorY    ;Y
    MOV DL,cursorX    ;X
    MOV AH,2
    INT 10h
    M:    
    ;clear the screen of the message typed
    MOV DL,' '
    MOV AH,2
    INT 21H     ;afer execution => AL = DL
    
    ;adjust the cursor if it reached the end of the window
    ;get cursor position
    MOV BH,PageNumber  ;DH : row , DL : column
    MOV AH,03H
    INT 10H
    
    ;check X reached the end
    CMP DL,80
    JE NEWROW1
    NEWROW1:
    ;adjust cursor to a new row
    MOV BH,PageNumber ;page
    INC DH            ;Y
    MOV DL,cursorX    ;X
    MOV AH,2
    INT 10h    
        
    ;reset cursor to the start position of the message type space
    MOV BH,PageNumber ;page
    MOV DH,cursorY    ;Y
    MOV DL,cursorX    ;X
    MOV AH,2
    INT 10h  
    
    JMP L
            
    MESSAGE:
    ;display the entered character
    MOV DL,AL
    MOV AH,2
    INT 21H     ;afer execution => AL = DL    
    ;store the entered value
    MOV [SI],AL
    INC SI
    ;adjust the cursor if it reached the end of the window
    ;get cursor position
    MOV BH,PageNumber  ;DH : row , DL : column
    MOV AH,03H
    INT 10H
    ;check X reached the end
    CMP DL,80
    JE NEWROW
    JNE SAMEROW
    
    NEWROW:
    ;adjust cursor to a new row
    MOV BH,PageNumber ;page
    INC DH            ;Y
    MOV DL,cursorX    ;X
    MOV AH,2
    INT 10h
    
    SAMEROW:

    CMP AH,1CH
    JNE NOGOTOBACKTOL 
    JMP L
    NOGOTOBACKTOL:
    POP SI
    RET
readAndSendMassages ENDP

;================================================================================

;================================== PROCEDURE ===================================
;these are procedures for chatting
recieveMessage	PROC
	PUSH SI
	MOV SI,OFFSET messageRecieved
	MOV CL,200
		
	;send 2
	MOV DX,03F8H
	MOV AL,2
	OUT DX,AL
	
	RecieveMessageLoop:
	
	;check if data ready
	MOV DX,3FDH
	CHK4:
	IN AL,DX
	AND AL,1
	JZ CHK4
	
	;if data is ready store it in the string messageRecieved
	MOV DX,03F8H
	IN AL,DX
	MOV [SI],AL
	
	;next char
	INC SI
	DEC CL
	JNZ RecieveMessageLoop
	
	POP SI
	RET
recieveMessage	ENDP
;---------------------------------------------------------------------
sendMessage		PROC
	PUSH SI
	MOV SI,OFFSET messageToBeSend
	MOV CL,200
	
	SendMessageLoop:
	
	;check if data ready
	MOV DX,3FDH
	AGAIN5:
	IN AL,DX
	AND AL,00100000B
	JZ AGAIN5
	
	;if data is ready store it in the string messageToBeSend
	MOV DX,03F8H
	MOV AL,[SI]
	OUT DX,AL
	
	;next char
	INC SI
	DEC CL
	JNZ SendMessageLoop
	
	POP SI

	RET
sendMessage		ENDP
;---------------------------------------------------------------------
sendInGameChatRquest	MACRO
LOCAL CHK6,DonotInGameChatting
	;first of all you must send a request
	;requests as follows :	=> 200 inGameChatRequest
	;						=> 201 outGameChatRequest
	;						=> 202 exitChattingInfo
	
	;send 200 as InGameRequest
	MOV DX,3F8H
	MOV AL,200
	OUT DX,AL
	
	;wait for response : if 1 -> then lets chat else he refused
	MOV DX,3FDH
	CHK6:
	IN AL,DX
	AND AL,1
	JZ CHK6
	;check for response
	MOV DX,03F8H
	IN AL,DX
	CMP AL,1
	JNE DonotInGameChatting
	;send to him whch page we will chat on
	MOV DX,03F8H 
	MOV AL,navigationIndex
	OUT DX,AL
	MOV isThereAChatting,1
	DonotInGameChatting:
	
ENDM

sendOutGameChatRquest	MACRO
LOCAL CHK6,DonotInGameChatting
	;first of all you must send a request
	;requests as follows :	=> 200 inGameChatRequest
	;						=> 201 outGameChatRequest
	;						=> 202 exitChattingInfo
	
	;send 201 as OutGameRequest
	MOV DX,3F8H
	MOV AL,201
	OUT DX,AL
	
	;wait for response : if 1 -> then lets chat else he refused
	MOV DX,3FDH
	CHK6:
	IN AL,DX
	AND AL,1
	JZ CHK6
	;check for response
	MOV DX,03F8H
	IN AL,DX
	CMP AL,1
	JNE DonotInGameChatting
	
	MOV isThereAChatting,1
	
	DonotInGameChatting:
	
ENDM
;---------------------------------------------------------------------
;------------------- UseFul Macros -------------------
checkForANewRow		MACRO	ColumnVar,RowVar
LOCAL SameR
	CMP ColumnVar,80
	JNE SameR
	MOV ColumnVar,51
	INC RowVar
	;set cursor
	MOV BH,0
	MOV DL,ColumnVar
	MOV DH,RowVar
	MOV AH,2
	INT 10H
	SameR:
ENDM
printMessage	MACRO	message,playerName,RowVar,ColumnVar
LOCAL InFinityMessage,DisplayNameLoop	
	
	PUSH SI
	MOV SI,OFFSET playerName
	;first display Name
	DisplayNameLoop:
	MOV AL,[SI]
	MOV AH,0EH
	INT 10H
	INC ColumnVar
	INC SI
	MOV AL,[SI]
	CMP AL,'$'
	JNE DisplayNameLoop
	
	
	MOV AL,' '
	MOV AH,0EH
	INT 10H
	INC ColumnVar
	
	MOV AL,':'
	MOV AH,0EH
	INT 10H
	INC ColumnVar
	
	MOV AL,' '
	MOV AH,0EH
	INT 10H
	INC ColumnVar
	
	MOV SI,OFFSET message
	InFinityMessage:
	MOV AL,[SI]
	MOV AH,0EH
	INT 10H
	INC ColumnVar
	checkForANewRow ColumnVar,RowVar
	INC SI
	MOV AL,[SI]
	CMP AL,'$'
	JNE InFinityMessage

	POP SI
ENDM

sendF4ToExitChatting	MACRO
	;send 3 to tell him I exited
	MOV DX,3F8H
	MOV AL,3
	OUT DX,AL
	
	
ENDM

backSpaceAChar	MACRO	
	MOV AL,'$'
	MOV [SI],AL
	DEC SI
	;get the cursor position
	MOV BH,0
	MOV AH,3
	INT 10H
	;decrement the cursor and set its new position
	DEC DL
	MOV AH,2
	INT 10H
	;clear the char from screen
	MOV DL,' '
	MOV AH,2
	INT 21H
	;get the cursor position
	MOV BH,0
	MOV AH,3
	INT 10H
	;decrement the cursor and set its new position
	DEC DL
	MOV AH,2
	INT 10H
	MOV messageToBeSendCol,DL
ENDM
;-----------------------------------------------------
inGameChat	PROC
	MOV SI,OFFSET messageToBeSend
	
	InGameChatLoop:
	
	;first check if there is 2 in the recieved buffer so that recieve a message and print it
	MOV DX,3FDH
	IN AL,DX
	AND AL,1
	JNZ ThereIsSomethingHere
	JMP NothingIsSentToMe
	ThereIsSomethingHere:
	
	MOV DX,03F8H
	IN AL,DX
	;3 -> the other person exited chatting
	CMP AL,3
	JNE NoHeDidnotExit
	JMP ExitInGameChatting
	NoHeDidnotExit:
	;2 -> there is message to be recieved
	CMP AL,2
	JE ThereIsSomethingHere1
	JMP NothingIsSentToMe
	ThereIsSomethingHere1:
	
	;wait till sending buffer is ready
	MOV DX,3FDH
	AGAIN6:
	IN AL,DX
	AND AL,00100000B
	JZ AGAIN6
	
	
	;wait to recieve message 
	CALL recieveMessage
	
	;set cursor
	MOV BH,0	;page Number
	MOV DL,messageRecievedCOL	;column
	MOV DH,messageRecievedRow	;row
	MOV AH,2
	INT 10H
	
	;print the recieved message
	printMessage messageRecieved,yourName,messageRecievedRow,messageRecievedCOL
	MOV messageRecievedCOL,51
	INC messageRecievedRow
	
	NothingIsSentToMe:
	;get cursor
	
	;set cursor
	MOV BH,0	;page Number
	MOV DL,messageToBeSendCol	;column
	MOV DH,messageToBeSendRow	;row
	MOV AH,2
	INT 10H
	
	;check if there is keystroke in the buffer
	MOV AH,01H		;ZF = 1 if keystroke isnot avaialable
	INT 16H			;ZF = 0 if keystroke is avaialable
	JNZ ThereIsSomethingInBuffer
	JMP NothingInTheBuffer
	ThereIsSomethingInBuffer:
	;get the char from the buffer & remove it
	MOV AH,0		;AL = ASCII code
	INT 16H
	;check if the entered chat to be BackSpace
	CMP AL,8
	JNE NotABackSpace
	backSpaceAChar
	JMP NothingInTheBuffer
	NotABackSpace:
	;check if the entered char to be f4 then exit the chat
	CMP AH,03EH
	JNE DonotExitInGameChat
	sendF4ToExitChatting
	JMP ExitInGameChatting
	DonotExitInGameChat:
	;check if the entered char to be ENTER then send the message
	CMP AL,13
	JE SendTheEnteredMessage
	;store the char in the message to be send and display the char
	MOV [SI],AL
	INC SI
	;display the char
	MOV AH,0EH	;AL = character to display
	INT 10H		;AH = scan code
	INC messageToBeSendCol
	checkForANewRow messageToBeSendCol,messageToBeSendRow
	JMP NothingInTheBuffer
	
	SendTheEnteredMessage:
	MOV AL,'$'
	MOV [SI],AL
	
	;TODO : this is for collide -> the two players pressed ENTER at the same time
	
	;send 2
	MOV DX,03F8H
	MOV AL,2
	OUT DX,AL
	
	;wait till he sends 2 to tell me that he is ready
	;check if data ready
	MOV DX,3FDH
	CHK5:
	IN AL,DX
	AND AL,1
	JZ CHK5
	
	;if data is ready store it in the string messageRecieved
	MOV DX,03F8H
	IN AL,DX
	CMP AL,2
	JE ValidReply
	JMP NotAValidReply
	ValidReply:
	
	CALL sendMessage
	
	;display the message I sent
	;set cursor
	MOV BH,0	;page Number
	MOV DL,messageRecievedCOL	;column
	MOV DH,messageRecievedRow	;row
	MOV AH,2
	INT 10H
	
	;display the message to be send 
	printMessage messageToBeSend,opponentName,messageRecievedRow,messageRecievedCOL
	MOV messageRecievedCOL,51
	INC messageRecievedRow
	
	;clear the screen and reset every thing for a new transmission
	;set cursor
	MOV DH,22
	MOV DL,51
	MOV BH,0
	MOV AH,2
	INT 10H
	;clear writing area
	MOV AL,' '
	MOV BH,0
	MOV CX,29
	MOV AH,0AH
	INT 10H
	;set cursor
	MOV DH,23
	MOV DL,51
	MOV BH,0
	MOV AH,2
	INT 10H
	;clear writing area
	MOV AL,' '
	MOV BH,0
	MOV CX,29
	MOV AH,0AH
	INT 10H

	
	MOV SI,OFFSET messageToBeSend
	MOV messageToBeSendCol,51
	MOV messageToBeSendRow,22
	
	NotAValidReply:
		
	NothingInTheBuffer:
	;if the other player presses enter then he will send 2 
	;to tell me that he will send me message then when I read 2 in my buffer 
	;I will send to him 2 to tell him I am ready, send me all of what you got
	
	
	JMP InGameChatLoop
	
	ExitInGameChatting:
	MOV messageToBeSendRow,22
	MOV messageToBeSendCol,51
	MOV messageRecievedRow,0
	MOV messageRecievedCOL,51
	
	;set the cursor between 2 lines
    MOV BH,0    ;page
    MOV DH,17   ;Y
    MOV DL,0    ;X
    MOV AH,2
    INT 10H
	
	RET
inGameChat	ENDP
;---------------------------------------------------------------------
;================================================================================


;================================== PROCEDURE ===================================
readWordFromUserIntoVar PROC
    ;SI will hold the address of the variable to store the enter variable in it
    ;it will read numbers from the user untill he press enter            

    L1:
    ;reading number enter from the user and display it 
    MOV AH,0H   ;get key pressed : AH : scancode , AL : Ascii code
    INT 16H     
    
    
    ;check for the input value if it was a navigation button
    ;store registers
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    CALL navigateBetweenScreens    
    ;restore registers
    POP SI
    POP DX
    POP CX
    POP BX  
    
    CMP isANavigateButton,0H
    JE ITSNOTANAVIGATIONBUTTON
    JNE ITSANAVIGATIONBUTTON
    
    ITSNOTANAVIGATIONBUTTON:
    CMP isFirstTime,1
    JNE NOITSNOYFIRSTNUM
    PUSH AX
    MOV AX,0H
    MOV [SI],AX
    POP AX
    MOV isFirstTime,0
    NOITSNOYFIRSTNUM:
    
    ;display the entered character
    CMP AL,13
    JE ITSANAVIGATIONBUTTON
    MOV DL,AL
    MOV AH,2
    INT 21H

    ;store the entered value
    MOV AH,0
    MOV CX,AX
    SUB CX,48 
    MOV Bx,[SI] 
    
    ;shifting by multiplication
    MOV AH,0
    MOV AL,10
    MUL BX      ;DX : AX = AX * BX
    ADD AX,CX
    MOV [SI],AX

    JMP L1
    
    ITSANAVIGATIONBUTTON:
    MOV isFirstTime,1

    RET
readWordFromUserIntoVar ENDP
;================================================================================


;================================== PROCEDURE ===================================
;this a procedure is to read from the user
readNumFromUserIntoVar PROC
    
    ;SI will hold the address of the variable to store the enter variable in it
    ;it will read numbers from the user untill he press enter            
    
    L1_1:
    ;reading number enter from the user and display it 
    MOV AH,0H   ;get key pressed : AH : scancode , AL : Ascii code
    INT 16H     
    
    ;check for the input value if it was a navigation button
    ;store registers
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    CALL navigateBetweenScreens    
    ;restore registers
    POP SI
    POP DX
    POP CX
    POP BX  
    
    CMP isANavigateButton,0H
    JE ITSNOTANAVIGATIONBUTTON1
    JNE ITSANAVIGATIONBUTTON1
    
    ITSNOTANAVIGATIONBUTTON1:
    CMP isFirstTime,1
    JNE NOITSNOYFIRSTNUM1
    PUSH AX
    MOV AL,0
    MOV [SI],AL
    POP AX
    MOV isFirstTime,0
    NOITSNOYFIRSTNUM1:
    
    ;display the entered character
    ;see if the enetered key is ENTER
    CMP AL,13
    JE ITSANAVIGATIONBUTTON1
    MOV DL,AL
    MOV AH,2
    INT 21H  
    
    ;store the entered value
    MOV CH,AL
    SUB CH,48 
    MOV BL,[SI] 
    
    ;shifting by multiplication
    MOV AL,10
    MUL BL      ;AX = AL * BL
    ADD Al,CH
    MOV [SI],AL

    JMP L1_1
    
    ITSANAVIGATIONBUTTON1:
    MOV isFirstTime,1
    RET
    
readNumFromUserIntoVar ENDP
;================================================================================

;================================== PROCEDURES for execution ===================================
pushIntoStack   PROC
    MOV SI,registersAddress  
    MOV DI,addressesAddress 
    ;get SP from registersAddress
    ADD SI,12
    MOV AX,[SI]
    ;increment SP
    INC AX
    MOV [SI],AX
    DEC AX
    ;get the place in Memort to push into it
    ADD DI,AX
    ADD DI,AX
    MOV SI,registersAddress 
    ADD SI,addedValueToSIDest
    MOV AX,[SI]
    MOV [DI],AX   
    RET 
pushIntoStack ENDP
;-------------------------------------------------------------------------------------------
popFromStack    PROC
    MOV SI,registersAddress  
    MOV DI,addressesAddress  
    ;get SP from registersAddress
    ADD SI,12
    MOV AX,[SI]
    ;increment SP
    DEC AX
    MOV [SI],AX
   ;get the place in Memort to pop from it
    ADD DI,AX
    ADD DI,AX
    MOV SI,registersAddress 
    ADD SI,addedValueToSIDest
    MOV AX,[DI]
    MOV [SI],AX
    
    RET
popFromStack ENDP
;-------------------------------------------------------------------------------------------
increment8BitReg    PROC  
    ;get register value in registersAddress
    MOV SI,registersAddress  
    ADD SI,addedValueToSIDest
    MOV AX,[SI]
    ;increment its value
    ;change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    INC AX
    PUSHF
    POP [DI]
    MOV [SI],AX
    
    RET
increment8BitReg ENDP

increment4BitReg    PROC
    ;get register value in registersAddress
    MOV SI,registersAddress  
    ADD SI,addedValueToSIDest
    MOV AL,[SI]
    ;increment its value
    ;change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    INC AL
    PUSHF
    POP [DI]
    MOV [SI],AL
    
    RET
increment4BitReg ENDP

incrementPointer    PROC   
    ;get address that SI points 
    MOV SI,registersAddress 
    MOV DI,addressesAddress 
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV AX,[SI]
    ;AX is holding address in addresses list
    ADD DI,AX
    ;get value from addresses and increment it
    MOV AL,[DI]
    ;change flags
    MOV SI,flagAddress
    MOV DX,[SI]
    PUSH DX
    POPF
    INC AL
    PUSHF
    POP DX
    MOV [SI],DX
    MOV [DI],AL

    RET
incrementPointer ENDP
;-------------------------------------------------------------------------------------------
decrement8BitReg    PROC  
    ;get register value in registersAddress
    MOV SI,registersAddress  
    ADD SI,addedValueToSIDest
    MOV AX,[SI]
    ;decrement its value
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    DEC AX
    PUSHF
    POP [DI]
    MOV [SI],AX  
    
    RET 
decrement8BitReg ENDP

decrement4BitReg    PROC
    ;get register value in registersAddress
    MOV SI,registersAddress  
    ADD SI,addedValueToSIDest
    MOV AL,[SI]
    ;decrement its value
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    DEC AL
    PUSHF
    POP [DI]  
    MOV [SI],AL
    
    RET
decrement4BitReg ENDP

decrementPointer    PROC   
    ;get address that SI points 
    MOV SI,registersAddress 
    MOV DI,addressesAddress 
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV AX,[SI]
    ;AX is holding address in addresses list
    ADD DI,AX
    ;get value from addresses and decrement it
    MOV AL,[DI]
    ;change flags
    MOV SI,flagAddress
    PUSH [SI]
    POPF
    DEC AL
    PUSHF
    POP [SI] 
    MOV [DI],AL
    
    RET
decrementPointer ENDP
;-------------------------------------------------------------------------------------------
multiplyByWord  PROC
    ;get store value in AX
    MOV SI,registersAddress 
    MOV AX,[SI]
    ;get source to be multiply
    ADD SI,addedValueToSIDest
    MOV BX,[SI]
    ;multipley and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MUL BX  ;(DX AX) = AX * BX
    PUSHF
    POP [DI]    
    ;store the calculated values
    MOV SI,registersAddress
    MOV [SI],AX
    ADD SI,6
    MOV [SI],DX
    
    RET 
multiplyByWord ENDP

multiplyByByte  PROC
    ;get store value in AL
    MOV SI,registersAddress 
    MOV AL,[SI]
    ;get source to be multiply
    ADD SI,addedValueToSIDest
    MOV BL,[SI]
    ;multiply and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MUL BL  ;(AX) = AL * BL
    PUSHF
    POP [DI]
    ;store the calculated values
    MOV SI,registersAddress
    MOV [SI],AX
    
    RET
multiplyByByte ENDP

multiplyByValueInAddress  PROC
    ;get store value in AL
    MOV SI,registersAddress 
    MOV AL,[SI]
    ;get address that the pointer points to
    MOV SI,registersAddress 
    MOV DI,addressesAddress 
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV CX,[SI]
    ;CX is holding address in addresses list
    ADD DI,CX
    ;store the value to be multiplyed
    MOV BL,[DI]
    ;multiply and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MUL BL  ;(AX) = AL * BL
    PUSHF
    POP [DI]
    ;store the calculated values
    MOV SI,registersAddress
    MOV [SI],AX
    
    RET
multiplyByValueInAddress ENDP
;-------------------------------------------------------------------------------------------
divideByWord  PROC

    ;get store value in AX
    MOV SI,registersAddress 
    MOV AX,[SI]
    ;get stored value in DX
    MOV SI,registersAddress 
    ADD SI,6
    MOV DX,[SI]
    ;get source to be divided by
    MOV SI,registersAddress 
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV BX,[SI]
    ;divide and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    DIV BX  ;(AX) = (DX AX) / BX , DX : REMAINDER
    PUSHF
    POP [DI]
    ;store the calculated values
    MOV SI,registersAddress
    MOV [SI],AX
    ADD SI,6
    MOV [SI],DX
   
    RET 
divideByWord ENDP

divideByByte    PROC
    ;get store value in AX
    MOV SI,registersAddress 
    MOV AX,[SI]
    ;get source to be divided by
    ADD SI,addedValueToSIDest
    MOV BL,[SI]
    ;divide and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    DIV BL  ;(AL) = AX / BL , AH : Remainder
    PUSHF
    POP [DI]  
    ;store the calculated values
    MOV SI,registersAddress
    MOV [SI],AL
    INC SI
    MOV [SI],AH
    
    RET
divideByByte ENDP

divideByValueInAddress  PROC
    ;get store value in AX
    MOV SI,registersAddress 
    MOV AX,[SI]
    ;get address that the pointer points to
    MOV SI,registersAddress 
    MOV DI,addressesAddress 
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV CX,[SI]
    ;CX is holding address in addresses list
    ADD DI,CX
    ;store the value to be multiplyed
    MOV BL,[DI]
    ;divide and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    DIV BL  ;(AL) = AX / BL , AH : remainder
    PUSHF
    POP [DI]  
    ;store the calculated values
    MOV SI,registersAddress
    MOV [SI],AX
    
    RET
divideByValueInAddress ENDP
;-------------------------------------------------------------------------------------------
signedMultiplyByWord  PROC
    ;get store value in AX
    MOV SI,registersAddress 
    MOV AX,[SI]
    ;get source to be multiply
    ADD SI,addedValueToSIDest
    MOV BX,[SI]
    ;multipley and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    IMUL BX  ;(DX AX) = AX * BX
    PUSHF
    POP [DI]    
    ;store the calculated values
    MOV SI,registersAddress
    MOV [SI],AX
    ADD SI,6
    MOV [SI],DX 

    RET
signedMultiplyByWord    ENDP

signedMultiplyByByte  PROC
    ;get store value in AL
    MOV SI,registersAddress 
    MOV AL,[SI]
    ;get source to be multiply
    ADD SI,addedValueToSIDest
    MOV BL,[SI]
    ;multiply and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    IMUL BL  ;(AX) = AL * BL
    PUSHF
    POP [DI]
    ;store the calculated values
    MOV SI,registersAddress
    MOV [SI],AX
    
    RET
signedMultiplyByByte ENDP

signedMultiplyByValueInAddress  PROC
    ;get store value in AL
    MOV SI,registersAddress 
    MOV AL,[SI]
    ;get address that the pointer points to
    MOV SI,registersAddress 
    MOV DI,addressesAddress 
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV CX,[SI]
    ;CX is holding address in addresses list
    ADD DI,CX
    ;store the value to be multiplyed
    MOV BL,[DI]
    ;multiply and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    IMUL BL  ;(AX) = AL * BL
    PUSHF
    POP [DI]
    ;store the calculated values
    MOV SI,registersAddress
    MOV [SI],AX
    
    RET
signedMultiplyByValueInAddress ENDP
;-------------------------------------------------------------------------------------------
signedDivideByWord  PROC

    ;get store value in AX
    MOV SI,registersAddress 
    MOV AX,[SI]
    ;get stored value in DX
    MOV SI,registersAddress 
    ADD SI,6
    MOV DX,[SI]
    ;get source to be divided by
    MOV SI,registersAddress 
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV BX,[SI]
    ;divide and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    IDIV BX  ;(AX) = (DX AX) / BX , DX : REMAINDER
    PUSHF
    POP [DI]
    
    ;store the calculated values
    MOV SI,registersAddress
    MOV [SI],AX
    ADD SI,6
    MOV [SI],DX 
    
    RET
signedDivideByWord ENDP

signedDivideByByte  PROC
    ;get store value in AX
    MOV SI,registersAddress 
    MOV AX,[SI]
    ;get source to be divided by
    ADD SI,addedValueToSIDest
    MOV BL,[SI]
    ;divide and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    IDIV BL  ;(AL) = AX / BL , AH : Remainder
    PUSHF
    POP [DI]  
    ;store the calculated values
    MOV SI,registersAddress
    MOV [SI],AL
    INC SI
    MOV [SI],AH

    RET    
signedDivideByByte ENDP

signedDivideByValueInAddress  PROC
    ;get store value in AX
    MOV SI,registersAddress 
    MOV AX,[SI]
    ;get address that the pointer points to
    MOV SI,registersAddress 
    MOV DI,addressesAddress 
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV CX,[SI]
    ;CX is holding address in addresses list
    ADD DI,CX
    ;store the value to be multiplyed
    MOV BL,[DI]
    ;divide and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    IDIV BL  ;(AL) = AX / BL , AH : remainder
    PUSHF
    POP [DI]  
    ;store the calculated values
    MOV SI,registersAddress
    MOV [SI],AX
    
    RET
signedDivideByValueInAddress ENDP
;-------------------------------------------------------------------------------------------
RORARegisterWordByNum PROC
    
    ;get the register to rotate it
    MOV SI,registersAddress 
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV AX,[SI]
    ;ROR AX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,byte ptr numberEntered
    ROR AX,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AX
    
    RET
RORARegisterWordByNum ENDP

RORARegisterByteByNum   proc

    ;get the register to rotate it
    MOV SI,registersAddress 
    ADD SI,addedValueToSIDest
    MOV AL,[SI]
    ;ROR AL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,byte ptr numberEntered
    ROR AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AL
    
    RET
RORARegisterByteByNum   ENDP

RORARegisterWordByCL PROC
    ;get CL
    MOV SI,registersAddress
    ADD SI,4
    MOV CL,[SI]
    ;get the register to rotate it
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV AX,[SI]
    ;ROR AX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    ROR AX,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AX
    
    RET
RORARegisterWordByCL ENDP

RORARegisterByteByCL PROC
    ;get CL
    MOV SI,registersAddress
    ADD SI,4
    MOV CL,[SI]
    ;get the register to rotate it
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    MOV AL,[SI]
    ;ROR AX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    ROR AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AX
    
    RET 
RORARegisterByteByCL ENDP

RORAMemoryByCL PROC
    ;get CL
    MOV SI,registersAddress
    ADD SI,4
    MOV CL,[SI]
    ;get the address that the pointer register points to
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV DX,[SI]
    ;get the actual value to rotate
    MOV SI,addressesAddress
    ADD SI,DX
    MOV AL,[SI]
    ;ROR AL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    ROR AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AL
    
    RET
RORAMemoryByCL ENDP

RORAMemoryByNum PROC

    ;get the address that the pointer register points to
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV DX,[SI]
    ;get the actual value to rotate
    MOV SI,addressesAddress
    ADD SI,DX
    MOV AL,[SI]
    ;ROR AL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,byte ptr numberEntered
    ROR AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AL
    
    RET
RORAMemoryByNum ENDP
;-------------------------------------------------------------------------------------------
ROLARegisterWordByNum PROC

    ;get the register to rotate it
    MOV SI,registersAddress 
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV AX,[SI]
    ;ROL AX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,byte ptr numberEntered
    ROL AX,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AX
    
    RET
ROLARegisterWordByNum ENDP

ROLARegisterByteByNum PROC

    ;get the register to rotate it
    MOV SI,registersAddress 
    ADD SI,addedValueToSIDest
    MOV AL,[SI]
    ;ROL AL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,byte ptr numberEntered
    ROL AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AL

    RET
ROLARegisterByteByNum ENDP

ROLARegisterWordByCL PROC
    ;get CL
    MOV SI,registersAddress
    ADD SI,4
    MOV CL,[SI]
    ;get the register to rotate it
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV AX,[SI]
    ;ROL AX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    ROL AX,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AX
    
    RET
ROLARegisterWordByCL ENDP

ROLARegisterByteByCL PROC
    ;get CL
    MOV SI,registersAddress
    ADD SI,4
    MOV CL,[SI]
    ;get the register to rotate it
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    MOV AL,[SI]
    ;ROL AX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    ROL AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AX
    
    RET
ROLARegisterByteByCL ENDP

ROLAMemoryByCL PROC
    ;get CL
    MOV SI,registersAddress
    ADD SI,4
    MOV CL,[SI]
    ;get the address that the pointer register points to
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV DX,[SI]
    ;get the actual value to rotate
    MOV SI,addressesAddress
    ADD SI,DX
    MOV AL,[SI]
    ;ROL AL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    ROL AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AL
    
    RET
ROLAMemoryByCL ENDP

ROLAMemoryByNum PROC

    ;get the address that the pointer register points to
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV DX,[SI]
    ;get the actual value to rotate
    MOV SI,addressesAddress
    ADD SI,DX
    MOV AL,[SI]
    ;ROL AL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,byte ptr numberEntered
    ROL AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AL
    
    RET
ROLAMemoryByNum ENDP
;-------------------------------------------------------------------------------------------
RCRARegisterWordByNum PROC
    
    ;get the register to rotate it
    MOV SI,registersAddress 
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV AX,[SI]
    ;ROR AX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,byte ptr numberEntered
    RCR AX,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AX
    
    RET
RCRARegisterWordByNum ENDP

RCRARegisterByteByNum   proc

    ;get the register to rotate it
    MOV SI,registersAddress 
    ADD SI,addedValueToSIDest
    MOV AL,[SI]
    ;ROR AL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,byte ptr numberEntered
    RCR AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AL
    
    RET
RCRARegisterByteByNum   ENDP

RCRARegisterWordByCL PROC
    ;get CL
    MOV SI,registersAddress
    ADD SI,4
    MOV CL,[SI]
    ;get the register to rotate it
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV AX,[SI]
    ;ROR AX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    RCR AX,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AX
    
    RET
RCRARegisterWordByCL ENDP

RCRARegisterByteByCL PROC
    ;get CL
    MOV SI,registersAddress
    ADD SI,4
    MOV CL,[SI]
    ;get the register to rotate it
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    MOV AL,[SI]
    ;ROR AX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    RCR AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AX
    
    RET 
RCRARegisterByteByCL ENDP

RCRAMemoryByCL PROC
    ;get CL
    MOV SI,registersAddress
    ADD SI,4
    MOV CL,[SI]
    ;get the address that the pointer register points to
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV DX,[SI]
    ;get the actual value to rotate
    MOV SI,addressesAddress
    ADD SI,DX
    MOV AL,[SI]
    ;ROR AL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    RCR AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AL
    
    RET
RCRAMemoryByCL ENDP

RCRAMemoryByNum PROC

    ;get the address that the pointer register points to
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV DX,[SI]
    ;get the actual value to rotate
    MOV SI,addressesAddress
    ADD SI,DX
    MOV AL,[SI]
    ;ROR AL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,byte ptr numberEntered
    RCR AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AL
    
    RET
RCRAMemoryByNum ENDP
;-------------------------------------------------------------------------------------------
RCLARegisterWordByNum PROC

    ;get the register to rotate it
    MOV SI,registersAddress 
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV AX,[SI]
    ;ROL AX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,byte ptr numberEntered
    RCL AX,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AX
    
    RET
RCLARegisterWordByNum ENDP

RCLARegisterByteByNum PROC

    ;get the register to rotate it
    MOV SI,registersAddress 
    ADD SI,addedValueToSIDest
    MOV AL,[SI]
    ;ROL AL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,byte ptr numberEntered
    RCL AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AL

    RET
RCLARegisterByteByNum ENDP

RCLARegisterWordByCL PROC
    ;get CL
    MOV SI,registersAddress
    ADD SI,4
    MOV CL,[SI]
    ;get the register to rotate it
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV AX,[SI]
    ;ROL AX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    RCL AX,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AX
    
    RET
RCLARegisterWordByCL ENDP

RCLARegisterByteByCL PROC
    ;get CL
    MOV SI,registersAddress
    ADD SI,4
    MOV CL,[SI]
    ;get the register to rotate it
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    MOV AL,[SI]
    ;ROL AX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    RCL AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AX
    
    RET
RCLARegisterByteByCL ENDP

RCLAMemoryByCL PROC
    ;get CL
    MOV SI,registersAddress
    ADD SI,4
    MOV CL,[SI]
    ;get the address that the pointer register points to
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV DX,[SI]
    ;get the actual value to rotate
    MOV SI,addressesAddress
    ADD SI,DX
    MOV AL,[SI]
    ;ROL AL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    RCL AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AL
    
    RET
RCLAMemoryByCL ENDP

RCLAMemoryByNum PROC

    ;get the address that the pointer register points to
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV DX,[SI]
    ;get the actual value to rotate
    MOV SI,addressesAddress
    ADD SI,DX
    MOV AL,[SI]
    ;ROL AL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,byte ptr numberEntered
    RCL AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AL
    
    RET
RCLAMemoryByNum ENDP
;-------------------------------------------------------------------------------------------
SHLARegisterWordByNum PROC

    ;get the register to rotate it
    MOV SI,registersAddress 
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV AX,[SI]
    ;ROL AX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,byte ptr numberEntered
    SHL AX,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AX
    
    RET
SHLARegisterWordByNum ENDP

SHLARegisterByteByNum PROC

    ;get the register to rotate it
    MOV SI,registersAddress 
    ADD SI,addedValueToSIDest
    MOV AL,[SI]
    ;ROL AL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,byte ptr numberEntered
    SHL AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AL

    RET
SHLARegisterByteByNum ENDP

SHLARegisterWordByCL PROC
    ;get CL
    MOV SI,registersAddress
    ADD SI,4
    MOV CL,[SI]
    ;get the register to rotate it
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV AX,[SI]
    ;ROL AX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    SHL AX,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AX
    
    RET
SHLARegisterWordByCL ENDP

SHLARegisterByteByCL PROC
    ;get CL
    MOV SI,registersAddress
    ADD SI,4
    MOV CL,[SI]
    ;get the register to rotate it
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    MOV AL,[SI]
    ;ROL AX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    SHL AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AX
    
    RET
SHLARegisterByteByCL ENDP

SHLAMemoryByCL PROC
    ;get CL
    MOV SI,registersAddress
    ADD SI,4
    MOV CL,[SI]
    ;get the address that the pointer register points to
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV DX,[SI]
    ;get the actual value to rotate
    MOV SI,addressesAddress
    ADD SI,DX
    MOV AL,[SI]
    ;ROL AL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    SHL AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AL
    
    RET
SHLAMemoryByCL ENDP

SHLAMemoryByNum PROC

    ;get the address that the pointer register points to
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV DX,[SI]
    ;get the actual value to rotate
    MOV SI,addressesAddress
    ADD SI,DX
    MOV AL,[SI]
    ;ROL AL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,byte ptr numberEntered
    SHL AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AL
    
    RET
SHLAMemoryByNum ENDP
;-------------------------------------------------------------------------------------------
SHRARegisterWordByNum PROC
    
    ;get the register to rotate it
    MOV SI,registersAddress 
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV AX,[SI]
    ;SHR AX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,byte ptr numberEntered
    SHR AX,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AX
    
    RET
SHRARegisterWordByNum ENDP

SHRARegisterByteByNum   proc

    ;get the register to rotate it
    MOV SI,registersAddress 
    ADD SI,addedValueToSIDest
    MOV AL,[SI]
    ;SHR AL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,byte ptr numberEntered
    SHR AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AL
    
    RET
SHRARegisterByteByNum   ENDP

SHRARegisterWordByCL PROC
    ;get CL
    MOV SI,registersAddress
    ADD SI,4
    MOV CL,[SI]
    ;get the register to rotate it
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV AX,[SI]
    ;SHR AX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    SHR AX,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AX
    
    RET
SHRARegisterWordByCL ENDP

SHRARegisterByteByCL PROC
    ;get CL
    MOV SI,registersAddress
    ADD SI,4
    MOV CL,[SI]
    ;get the register to rotate it
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    MOV AL,[SI]
    ;SHR AX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    SHR AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AX
    
    RET 
SHRARegisterByteByCL ENDP

SHRAMemoryByCL PROC
    ;get CL
    MOV SI,registersAddress
    ADD SI,4
    MOV CL,[SI]
    ;get the address that the pointer register points to
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV DX,[SI]
    ;get the actual value to rotate
    MOV SI,addressesAddress
    ADD SI,DX
    MOV AL,[SI]
    ;SHR AL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    SHR AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AL
    
    RET
SHRAMemoryByCL ENDP

SHRAMemoryByNum PROC

    ;get the address that the pointer register points to
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV DX,[SI]
    ;get the actual value to rotate
    MOV SI,addressesAddress
    ADD SI,DX
    MOV AL,[SI]
    ;SHR AL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,byte ptr numberEntered
    SHR AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AL
    
    RET
SHRAMemoryByNum ENDP
;-------------------------------------------------------------------------------------------
SARARegisterWordByNum PROC
    
    ;get the register to rotate it
    MOV SI,registersAddress 
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV AX,[SI]
    ;SAR AX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,byte ptr numberEntered
    SAR AX,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AX
    
    RET
SARARegisterWordByNum ENDP

SARARegisterByteByNum   proc

    ;get the register to rotate it
    MOV SI,registersAddress 
    ADD SI,addedValueToSIDest
    MOV AL,[SI]
    ;SAR AL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,byte ptr numberEntered
    SAR AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AL
    
    RET
SARARegisterByteByNum   ENDP

SARARegisterWordByCL PROC
    ;get CL
    MOV SI,registersAddress
    ADD SI,4
    MOV CL,[SI]
    ;get the register to rotate it
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV AX,[SI]
    ;SAR AX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    SAR AX,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AX
    
    RET
SARARegisterWordByCL ENDP

SARARegisterByteByCL PROC
    ;get CL
    MOV SI,registersAddress
    ADD SI,4
    MOV CL,[SI]
    ;get the register to rotate it
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    MOV AL,[SI]
    ;SAR AX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    SAR AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AX
    
    RET 
SARARegisterByteByCL ENDP

SARAMemoryByCL PROC
    ;get CL
    MOV SI,registersAddress
    ADD SI,4
    MOV CL,[SI]
    ;get the address that the pointer register points to
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV DX,[SI]
    ;get the actual value to rotate
    MOV SI,addressesAddress
    ADD SI,DX
    MOV AL,[SI]
    ;SAR AL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    SAR AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AL
    
    RET
SARAMemoryByCL ENDP

SARAMemoryByNum PROC

    ;get the address that the pointer register points to
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV DX,[SI]
    ;get the actual value to rotate
    MOV SI,addressesAddress
    ADD SI,DX
    MOV AL,[SI]
    ;SAR AL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,byte ptr numberEntered
    SAR AL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],AL
    
    RET
SARAMemoryByNum ENDP
;-------------------------------------------------------------------------------------------
ANDAWordRegWithMemory   PROC
    
    ;get the number stored in address numberEntered
    MOV SI,addressesAddress
    ADD SI,numberEntered
    MOV AX,[SI]
    ;get the register to operate on
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV BX,[SI]
    ;AND BX,[NUM] and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    AND BX,AX
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BX
    
    RET
ANDAWordRegWithMemory   ENDP

ANDAWordRegWithNUM   PROC

    ;get the register to operate on
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV BX,[SI]
    ;AND BX,NUM and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    AND BX,numberEntered
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BX
    
    RET
ANDAWordRegWithNUM   ENDP

ANDAWordRegWithPointer   PROC

    ;get the address that the pointer points to
    MOV SI,registersAddress
    ADD SI,addedValueToSISource
    ADD SI,addedValueToSISource
    MOV BX,[SI]
    ;get the number stored in the address
    MOV SI,addressesAddress
    ADD SI,BX
    MOV AX,[SI]
    ;get the register to operate on
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV BX,[SI]
    ;AND BX,[SI] and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    AND BX,AX
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BX

    RET
ANDAWordRegWithPointer   ENDP

ANDAWordRegWithWordReg   PROC
    
    ;get the source register
    MOV SI,registersAddress
    ADD SI,addedValueToSISource
    ADD SI,addedValueToSISource
    MOV AX,[SI]
    ;get the destination register
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV BX,[SI]
    ;AND BX,AX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    AND BX,AX
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BX
    
    RET
ANDAWordRegWithWordReg   ENDP
;============================
ANDAByteRegWithMemory   PROC

    ;get the number stored in address numberEntered
    MOV SI,addressesAddress
    ADD SI,numberEntered
    MOV AL,[SI]
    ;get the register to operate on
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    MOV BL,[SI]
    ;AND BL,[NUM] and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    AND BL,AL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BL
    
    RET
ANDAByteRegWithMemory   ENDP

ANDAByteRegWithNUM   PROC

    ;get the register to operate on
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    MOV BL,[SI]
    ;AND BL,NUM and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,BYTE PTR numberEntered
    AND BL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BL
    
    RET
ANDAByteRegWithNUM   ENDP

ANDAByteRegWithPointer   PROC

    ;get the address that the pointer points to
    MOV SI,registersAddress
    ADD SI,addedValueToSISource
    ADD SI,addedValueToSISource
    MOV BX,[SI]
    ;get the number stored in the address
    MOV SI,addressesAddress
    ADD SI,BX
    MOV AL,[SI]
    ;get the register to operate on
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    MOV BL,[SI]
    ;AND BL,[SI] and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    AND BL,AL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BL
    
    RET
ANDAByteRegWithPointer   ENDP

ANDAByteRegWithByteReg   PROC

    ;get the source register
    MOV SI,registersAddress
    ADD SI,addedValueToSISource
    MOV AL,[SI]
    ;get the destination register
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    MOV BL,[SI]
    ;AND BL,AL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    AND BL,AL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BL
    
    RET
ANDAByteRegWithByteReg   ENDP
;============================
ANDAPointerRegWithNUM   PROC
    
    ;get the address that the pointer points to
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV BX,[SI]
    ;get the number stored in the address
    MOV SI,addressesAddress
    ADD SI,BX
    MOV BL,[SI]
    ;AND [SI],NUM and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,BYTE PTR numberEntered
    AND BL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BL
    
    RET
ANDAPointerRegWithNUM   ENDP

ANDAPointerRegWithWordReg   PROC

    ;get the source register
    MOV SI,registersAddress
    ADD SI,addedValueToSISource
    ADD SI,addedValueToSISource
    MOV BX,[SI]
    ;get the address that the pointer points to
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV CX,[SI]
    ;get the number stored in the address
    MOV SI,addressesAddress
    ADD SI,CX
    MOV CX,[SI]
    ;AND [SI],BX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    AND CX,BX
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],CX
    
    
    RET
ANDAPointerRegWithWordReg   ENDP

ANDAPointerRegWithByteReg   PROC
    
    ;get the source register
    MOV SI,registersAddress
    ADD SI,addedValueToSISource
    MOV BL,[SI]
    ;get the address that the pointer points to
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV CX,[SI]
    ;get the number stored in the address
    MOV SI,addressesAddress
    ADD SI,CX
    MOV CH,[SI]
    ;AND [SI],BL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    AND CH,BL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],CH
    
    RET
ANDAPointerRegWithByteReg   ENDP
;-------------------------------------------------------------------------------------------
ORAWordRegWithMemory   PROC
    
    ;get the number stored in address numberEntered
    MOV SI,addressesAddress
    ADD SI,numberEntered
    MOV AX,[SI]
    ;get the register to operate on
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV BX,[SI]
    ;OR BX,[NUM] and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    OR BX,AX
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BX
    
    RET
ORAWordRegWithMemory   ENDP

ORAWordRegWithNUM   PROC

    ;get the register to operate on
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV BX,[SI]
    ;OR BX,NUM and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    OR BX,numberEntered
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BX
    
    RET
ORAWordRegWithNUM   ENDP

ORAWordRegWithPointer   PROC

    ;get the address that the pointer points to
    MOV SI,registersAddress
    ADD SI,addedValueToSISource
    ADD SI,addedValueToSISource
    MOV BX,[SI]
    ;get the number stored in the address
    MOV SI,addressesAddress
    ADD SI,BX
    MOV AX,[SI]
    ;get the register to operate on
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV BX,[SI]
    ;OR BX,[SI] and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    OR BX,AX
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BX

    RET
ORAWordRegWithPointer   ENDP

ORAWordRegWithWordReg   PROC
    
    ;get the source register
    MOV SI,registersAddress
    ADD SI,addedValueToSISource
    ADD SI,addedValueToSISource
    MOV AX,[SI]
    ;get the destination register
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV BX,[SI]
    ;OR BX,AX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    OR BX,AX
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BX
    
    RET
ORAWordRegWithWordReg   ENDP
;============================
ORAByteRegWithMemory   PROC

    ;get the number stored in address numberEntered
    MOV SI,addressesAddress
    ADD SI,numberEntered
    MOV AL,[SI]
    ;get the register to operate on
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    MOV BL,[SI]
    ;OR BL,[NUM] and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    OR BL,AL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BL
    
    RET
ORAByteRegWithMemory   ENDP

ORAByteRegWithNUM   PROC

    ;get the register to operate on
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    MOV BL,[SI]
    ;OR BL,NUM and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,BYTE PTR numberEntered
    OR BL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BL
    
    RET
ORAByteRegWithNUM   ENDP

ORAByteRegWithPointer   PROC

    ;get the address that the pointer points to
    MOV SI,registersAddress
    ADD SI,addedValueToSISource
    ADD SI,addedValueToSISource
    MOV BX,[SI]
    ;get the number stored in the address
    MOV SI,addressesAddress
    ADD SI,BX
    MOV AL,[SI]
    ;get the register to operate on
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    MOV BL,[SI]
    ;OR BL,[SI] and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    OR BL,AL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BL
    
    RET
ORAByteRegWithPointer   ENDP

ORAByteRegWithByteReg   PROC

    ;get the source register
    MOV SI,registersAddress
    ADD SI,addedValueToSISource
    MOV AL,[SI]
    ;get the destination register
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    MOV BL,[SI]
    ;OR BL,AL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    OR BL,AL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BL
    
    RET
ORAByteRegWithByteReg   ENDP
;============================
ORAPointerRegWithNUM   PROC
    
    ;get the address that the pointer points to
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV BX,[SI]
    ;get the number stored in the address
    MOV SI,addressesAddress
    ADD SI,BX
    MOV BL,[SI]
    ;OR [SI],NUM and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,BYTE PTR numberEntered
    OR BL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BL
    
    RET
ORAPointerRegWithNUM   ENDP

ORAPointerRegWithWordReg   PROC

    ;get the source register
    MOV SI,registersAddress
    ADD SI,addedValueToSISource
    ADD SI,addedValueToSISource
    MOV BX,[SI]
    ;get the address that the pointer points to
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV CX,[SI]
    ;get the number stored in the address
    MOV SI,addressesAddress
    ADD SI,CX
    MOV CX,[SI]
    ;OR [SI],BX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    OR CX,BX
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],CX
    
    
    RET
ORAPointerRegWithWordReg   ENDP

ORAPointerRegWithByteReg   PROC
    
    ;get the source register
    MOV SI,registersAddress
    ADD SI,addedValueToSISource
    MOV BL,[SI]
    ;get the address that the pointer points to
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV CX,[SI]
    ;get the number stored in the address
    MOV SI,addressesAddress
    ADD SI,CX
    MOV CH,[SI]
    ;OR [SI],BL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    OR CH,BL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],CH
    
    RET
ORAPointerRegWithByteReg   ENDP

;-------------------------------------------------------------------------------------------
MOVAWordRegWithMemory   PROC
    
    ;get the number stored in address numberEntered
    MOV SI,addressesAddress
    ADD SI,numberEntered
    MOV AX,[SI]
    ;get the register to operate on
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV BX,[SI]
    ;MOV BX,[NUM] MOV change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV BX,AX
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BX
    
    RET
MOVAWordRegWithMemory   ENDP

MOVAWordRegWithNUM   PROC

    ;get the register to operate on
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV BX,[SI]
    ;MOV BX,NUM MOV change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV BX,numberEntered
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BX
    
    RET
MOVAWordRegWithNUM   ENDP

MOVAWordRegWithPointer   PROC

    ;get the address that the pointer points to
    MOV SI,registersAddress
    ADD SI,addedValueToSISource
    ADD SI,addedValueToSISource
    MOV BX,[SI]
    ;get the number stored in the address
    MOV SI,addressesAddress
    ADD SI,BX
    MOV AX,[SI]
    ;get the register to operate on
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV BX,[SI]
    ;MOV BX,[SI] MOV change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV BX,AX
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BX

    RET
MOVAWordRegWithPointer   ENDP

MOVAWordRegWithWordReg   PROC
    
    ;get the source register
    MOV SI,registersAddress
    ADD SI,addedValueToSISource
    ADD SI,addedValueToSISource
    MOV AX,[SI]
    ;get the destination register
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV BX,[SI]
    ;MOV BX,AX MOV change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV BX,AX
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BX
    
    RET
MOVAWordRegWithWordReg   ENDP
;============================
MOVAByteRegWithMemory   PROC

    ;get the number stored in address numberEntered
    MOV SI,addressesAddress
    ADD SI,numberEntered
    MOV AL,[SI]
    ;get the register to operate on
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    MOV BL,[SI]
    ;MOV BL,[NUM] MOV change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV BL,AL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BL
    
    RET
MOVAByteRegWithMemory   ENDP

MOVAByteRegWithNUM   PROC

    ;get the register to operate on
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    MOV BL,[SI]
    ;MOV BL,NUM MOV change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,BYTE PTR numberEntered
    MOV BL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BL
    
    RET
MOVAByteRegWithNUM   ENDP

MOVAByteRegWithPointer   PROC

    ;get the address that the pointer points to
    MOV SI,registersAddress
    ADD SI,addedValueToSISource
    ADD SI,addedValueToSISource
    MOV BX,[SI]
    ;get the number stored in the address
    MOV SI,addressesAddress
    ADD SI,BX
    MOV AL,[SI]
    ;get the register to operate on
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    MOV BL,[SI]
    ;MOV BL,[SI] MOV change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV BL,AL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BL
    
    RET
MOVAByteRegWithPointer   ENDP

MOVAByteRegWithByteReg   PROC

    ;get the source register
    MOV SI,registersAddress
    ADD SI,addedValueToSISource
    MOV AL,[SI]
    ;get the destination register
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    MOV BL,[SI]
    ;MOV BL,AL MOV change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV BL,AL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BL
    
    RET
MOVAByteRegWithByteReg   ENDP
;============================
MOVAPointerRegWithNUM   PROC
    
    ;get the address that the pointer points to
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV BX,[SI]
    ;get the number stored in the address
    MOV SI,addressesAddress
    ADD SI,BX
    MOV BL,[SI]
    ;MOV [SI],NUM MOV change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,BYTE PTR numberEntered
    MOV BL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BL
    
    RET
MOVAPointerRegWithNUM   ENDP

MOVAPointerRegWithWordReg   PROC

    ;get the source register
    MOV SI,registersAddress
    ADD SI,addedValueToSISource
    ADD SI,addedValueToSISource
    MOV BX,[SI]
    ;get the address that the pointer points to
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV CX,[SI]
    ;get the number stored in the address
    MOV SI,addressesAddress
    ADD SI,CX
    MOV CX,[SI]
    ;MOV [SI],BX MOV change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CX,BX
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],CX
    
    
    RET
MOVAPointerRegWithWordReg   ENDP

MOVAPointerRegWithByteReg   PROC
    
    ;get the source register
    MOV SI,registersAddress
    ADD SI,addedValueToSISource
    MOV BL,[SI]
    ;get the address that the pointer points to
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV CX,[SI]
    ;get the number stored in the address
    MOV SI,addressesAddress
    ADD SI,CX
    MOV CH,[SI]
    ;MOV [SI],BL MOV change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CH,BL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],CH
    
    RET
MOVAPointerRegWithByteReg   ENDP
;-------------------------------------------------------------------------------------------
XORAWordRegWithMemory   PROC
    
    ;get the number stored in address numberEntered
    MOV SI,addressesAddress
    ADD SI,numberEntered
    MOV AX,[SI]
    ;get the register to operate on
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV BX,[SI]
    ;XOR BX,[NUM] and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    XOR BX,AX
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BX
    
    RET
XORAWordRegWithMemory   ENDP

XORAWordRegWithNUM   PROC

    ;get the register to operate on
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV BX,[SI]
    ;XOR BX,NUM and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    XOR BX,numberEntered
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BX
    
    RET
XORAWordRegWithNUM   ENDP

XORAWordRegWithPointer   PROC

    ;get the address that the pointer points to
    MOV SI,registersAddress
    ADD SI,addedValueToSISource
    ADD SI,addedValueToSISource
    MOV BX,[SI]
    ;get the number stored in the address
    MOV SI,addressesAddress
    ADD SI,BX
    MOV AX,[SI]
    ;get the register to operate on
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV BX,[SI]
    ;XOR BX,[SI] and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    XOR BX,AX
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BX

    RET
XORAWordRegWithPointer   ENDP

XORAWordRegWithWordReg   PROC
    
    ;get the source register
    MOV SI,registersAddress
    ADD SI,addedValueToSISource
    ADD SI,addedValueToSISource
    MOV AX,[SI]
    ;get the destination register
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV BX,[SI]
    ;XOR BX,AX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    XOR BX,AX
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BX
    
    RET
XORAWordRegWithWordReg   ENDP
;============================
XORAByteRegWithMemory   PROC

    ;get the number stored in address numberEntered
    MOV SI,addressesAddress
    ADD SI,numberEntered
    MOV AL,[SI]
    ;get the register to operate on
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    MOV BL,[SI]
    ;XOR BL,[NUM] and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    XOR BL,AL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BL
    
    RET
XORAByteRegWithMemory   ENDP

XORAByteRegWithNUM   PROC

    ;get the register to operate on
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    MOV BL,[SI]
    ;XOR BL,NUM and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,BYTE PTR numberEntered
    XOR BL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BL
    
    RET
XORAByteRegWithNUM   ENDP

XORAByteRegWithPointer   PROC

    ;get the address that the pointer points to
    MOV SI,registersAddress
    ADD SI,addedValueToSISource
    ADD SI,addedValueToSISource
    MOV BX,[SI]
    ;get the number stored in the address
    MOV SI,addressesAddress
    ADD SI,BX
    MOV AL,[SI]
    ;get the register to operate on
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    MOV BL,[SI]
    ;XOR BL,[SI] and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    XOR BL,AL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BL
    
    RET
XORAByteRegWithPointer   ENDP

XORAByteRegWithByteReg   PROC

    ;get the source register
    MOV SI,registersAddress
    ADD SI,addedValueToSISource
    MOV AL,[SI]
    ;get the destination register
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    MOV BL,[SI]
    ;XOR BL,AL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    XOR BL,AL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BL
    
    RET
XORAByteRegWithByteReg   ENDP
;============================
XORAPointerRegWithNUM   PROC
    
    ;get the address that the pointer points to
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV BX,[SI]
    ;get the number stored in the address
    MOV SI,addressesAddress
    ADD SI,BX
    MOV BL,[SI]
    ;XOR [SI],NUM and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    MOV CL,BYTE PTR numberEntered
    XOR BL,CL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],BL
    
    RET
XORAPointerRegWithNUM   ENDP

XORAPointerRegWithWordReg   PROC

    ;get the source register
    MOV SI,registersAddress
    ADD SI,addedValueToSISource
    ADD SI,addedValueToSISource
    MOV BX,[SI]
    ;get the address that the pointer points to
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV CX,[SI]
    ;get the number stored in the address
    MOV SI,addressesAddress
    ADD SI,CX
    MOV CX,[SI]
    ;XOR [SI],BX and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    XOR CX,BX
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],CX
    
    
    RET
XORAPointerRegWithWordReg   ENDP

XORAPointerRegWithByteReg   PROC
    
    ;get the source register
    MOV SI,registersAddress
    ADD SI,addedValueToSISource
    MOV BL,[SI]
    ;get the address that the pointer points to
    MOV SI,registersAddress
    ADD SI,addedValueToSIDest
    ADD SI,addedValueToSIDest
    MOV CX,[SI]
    ;get the number stored in the address
    MOV SI,addressesAddress
    ADD SI,CX
    MOV CH,[SI]
    ;XOR [SI],BL and change flags
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    XOR CH,BL
    PUSHF
    POP [DI] 
    ;store the calculated values
    MOV [SI],CH
    
    RET
XORAPointerRegWithByteReg   ENDP

;============================================================================
;================================== MACRO ===================================
validateEnteredNumToBeByte  MACRO
    LOCAL NumberEnteredIsByte
    CMP numberEntered,255
    JLE NumberEnteredIsByte     
    JMP NOTAVAILIDCOMMAND
    NumberEnteredIsByte:
ENDM
;============================================================================

;================================== PROCEDURE ===================================
executeCommand  PROC 

    
    ;loop to check if there is a forbidden character
    MOV SI,OFFSET commandEntered
    MOV DI,forbiddentCharAdd
    MOV AH,[DI]
    ;AH will hold the forbidden char value
    LoopForForbiddenChar:
    MOV AL,'$'
    CMP [SI],AL
    JE StartExecutingCommand
    CMP [SI],AH
    JNE RemainInTheLoopForForbiddenChar
    JMP NOTAVAILIDCOMMAND    
    RemainInTheLoopForForbiddenChar:
    INC SI
    JMP LoopForForbiddenChar
    
    StartExecutingCommand:
    
;------------------------------------------------------------------------------------------------   
    ;this is ADD command
    ADDCOMMAND:
    CMP commandIndex,1
    JE ADDCOMMAND1
    JMP ADCCOMMAND
    ADDCOMMAND1:
;------------------------------------------------------------------------------------------------  
    ;this is ADC command
    ADCCOMMAND:
    CMP commandIndex,2
    JE ADCCOMMAND1
    JMP SUBCOMMAND
    ADCCOMMAND1:
;------------------------------------------------------------------------------------------------   
    ;this is SUB command
    SUBCOMMAND:
    CMP commandIndex,3
    JE SUBCOMMAND1
    JMP SBBCOMMAND
    SUBCOMMAND1:
;------------------------------------------------------------------------------------------------   
    ;this is SBB command
    SBBCOMMAND:
    CMP commandIndex,4
    JE SBBCOMMAND1
    JMP RCRCOMMAND
    SBBCOMMAND1:
    
    
;------------------------------------------------------------------------------------------------  
    ;this is RCR command
    RCRCOMMAND:
    CMP commandIndex,5
    JE RCRCOMMAND1
    JMP RCLCOMMAND
    RCRCOMMAND1:
    
    ;the second operand mustn't have brackets
    CMP isSecondOpBracket,1
    JNE ValidCommand18
    JMP NOTAVAILIDCOMMAND
    ValidCommand18:
    
    ;the second operand index is either 17 (Num) or 14 (CL) other than that error
    CMP secondOperandIndex,17
    JE ValidCommand19
    
    CMP secondOperandIndex,14
    JE ValidCommand19
    JMP NOTAVAILIDCOMMAND
    ValidCommand19:
    
    ;if there is a bracket then either BX or SI or DI
    CMP isFirstOpBracket,1
    JNE ValidCommand20
    JMP RCRCommandForPointer
    ValidCommand20:
    
    ;internal check ti see if 2nd operand is CL or NUM
    CMP secondOperandIndex,17
    JE RCRRegUsingNum
    JMP RCRRegUsingCl
    RCRRegUsingNum:
    
    ;the Num must be Byte
    CMP numberEntered,255
    JLE AValidNum21
    JMP NOTAVAILIDCOMMAND
    AValidNum21:
    
    ;RCR AX,NUM
    RCRAX1ByNum:
    CMP firstOperandIndex,1
    JNE RCRBX1ByNum
    MOV addedValueToSIDest,0
    CALL RCRARegisterWordByNum
    JMP ENDEXECUTE  
    
    ;RCR BX,NUM
    RCRBX1ByNum:
    CMP firstOperandIndex,2
    JNE RCRCX1ByNum
    MOV addedValueToSIDest,1
    CALL RCRARegisterWordByNum
    JMP ENDEXECUTE
     
    ;RCR CX,NUM
    RCRCX1ByNum:
    CMP firstOperandIndex,3
    JNE RCRDX1ByNum
    MOV addedValueToSIDest,2
    CALL RCRARegisterWordByNum
    JMP ENDEXECUTE
    
    ;RCR DX,NUM
    RCRDX1ByNum:
    CMP firstOperandIndex,4
    JNE RCRSI1ByNum
    MOV addedValueToSIDest,3
    CALL RCRARegisterWordByNum
    JMP ENDEXECUTE
    
    ;RCR SI,NUM
    RCRSI1ByNum:
    CMP firstOperandIndex,5
    JNE RCRDI1ByNum
    MOV addedValueToSIDest,4
    CALL RCRARegisterWordByNum
    JMP ENDEXECUTE
    
    ;RCR DI,NUM
    RCRDI1ByNum:
    CMP firstOperandIndex,6
    JNE RCRSP1ByNum
    MOV addedValueToSIDest,5
    CALL RCRARegisterWordByNum
    JMP ENDEXECUTE
    
    ;RCR SP,NUM
    RCRSP1ByNum:
    CMP firstOperandIndex,7
    JNE RCRBP1ByNum
    MOV addedValueToSIDest,6
    CALL RCRARegisterWordByNum
    JMP ENDEXECUTE
    
    ;RCR BP,NUM
    RCRBP1ByNum:
    CMP firstOperandIndex,8
    JNE RCRAH1ByNum
    MOV addedValueToSIDest,7
    CALL RCRARegisterWordByNum
    JMP ENDEXECUTE
    
    ;RCR AH,NUM
    RCRAH1ByNum:
    CMP firstOperandIndex,9
    JNE RCRAL1ByNum
    MOV addedValueToSIDest,1
    CALL RCRARegisterByteByNum
    JMP ENDEXECUTE
    
    ;RCR AL,NUM
    RCRAL1ByNum:
    CMP firstOperandIndex,10
    JNE RCRBH1ByNum
    MOV addedValueToSIDest,0
    CALL RCRARegisterByteByNum
    JMP ENDEXECUTE
    
    ;RCR BH,NUM
    RCRBH1ByNum:
    CMP firstOperandIndex,11
    JNE RCRBL1ByNum
    MOV addedValueToSIDest,3
    CALL RCRARegisterByteByNum
    JMP ENDEXECUTE
    
    ;RCR BL,NUM
    RCRBL1ByNum:
    CMP firstOperandIndex,12
    JNE RCRCH1ByNum
    MOV addedValueToSIDest,2
    CALL RCRARegisterByteByNum
    JMP ENDEXECUTE
    
    ;RCR CH,NUM
    RCRCH1ByNum:
    CMP firstOperandIndex,13
    JNE RCRCL1ByNum
    MOV addedValueToSIDest,5
    CALL RCRARegisterByteByNum
    JMP ENDEXECUTE
    
    ;RCR CL,NUM
    RCRCL1ByNum:
    CMP firstOperandIndex,14
    JNE RCRDH1ByNum
    MOV addedValueToSIDest,4
    CALL RCRARegisterByteByNum
    JMP ENDEXECUTE
    
    ;RCR DH,NUM
    RCRDH1ByNum:
    CMP firstOperandIndex,15
    JNE RCRDL1ByNum
    MOV addedValueToSIDest,7
    CALL RCRARegisterByteByNum
    JMP ENDEXECUTE
    
    ;RCR DL,NUM
    RCRDL1ByNum:
    CMP firstOperandIndex,16
    JE RCRDL2ByNum
    JMP NOTAVAILIDCOMMAND
    RCRDL2ByNum:
    MOV addedValueToSIDest,6
    CALL RCRARegisterByteByNum
    JMP ENDEXECUTE
    
    
    ;THIS IS FOR ROTATING REG USING CL
    RCRRegUsingCl:
    
    ;RCR AX,CL
    RCRAX1ByCL:
    CMP firstOperandIndex,1
    JNE RCRBX1ByCL
    MOV addedValueToSIDest,0
    CALL RCRARegisterWordByCL
    JMP ENDEXECUTE  
    
    ;RCR BX,CL
    RCRBX1ByCL:
    CMP firstOperandIndex,2
    JNE RCRCX1ByCL
    MOV addedValueToSIDest,1
    CALL RCRARegisterWordByCL
    JMP ENDEXECUTE
     
    ;RCR CX,CL
    RCRCX1ByCL:
    CMP firstOperandIndex,3
    JNE RCRDX1ByCL
    MOV addedValueToSIDest,2
    CALL RCRARegisterWordByCL
    JMP ENDEXECUTE
    
    ;RCR DX,CL
    RCRDX1ByCL:
    CMP firstOperandIndex,4
    JNE RCRSI1ByCL
    MOV addedValueToSIDest,3
    CALL RCRARegisterWordByCL
    JMP ENDEXECUTE
    
    ;RCR SI,CL
    RCRSI1ByCL:
    CMP firstOperandIndex,5
    JNE RCRDI1ByCL
    MOV addedValueToSIDest,4
    CALL RCRARegisterWordByCL
    JMP ENDEXECUTE
    
    ;RCR DI,CL
    RCRDI1ByCL:
    CMP firstOperandIndex,6
    JNE RCRSP1ByCL
    MOV addedValueToSIDest,5
    CALL RCRARegisterWordByCL
    JMP ENDEXECUTE
    
    ;RCR SP,CL
    RCRSP1ByCL:
    CMP firstOperandIndex,7
    JNE RCRBP1ByCL
    MOV addedValueToSIDest,6
    CALL RCRARegisterWordByCL
    JMP ENDEXECUTE
    
    ;RCR BP,CL
    RCRBP1ByCL:
    CMP firstOperandIndex,8
    JNE RCRAH1ByCL
    MOV addedValueToSIDest,7
    CALL RCRARegisterWordByCL
    JMP ENDEXECUTE
    
    ;RCR AH,CL
    RCRAH1ByCL:
    CMP firstOperandIndex,9
    JNE RCRAL1ByCL
    MOV addedValueToSIDest,1
    CALL RCRARegisterByteByCL
    JMP ENDEXECUTE
    
    ;RCR AL,CL
    RCRAL1ByCL:
    CMP firstOperandIndex,10
    JNE RCRBH1ByCL
    MOV addedValueToSIDest,0
    CALL RCRARegisterByteByCL
    JMP ENDEXECUTE
    
    ;RCR BH,CL
    RCRBH1ByCL:
    CMP firstOperandIndex,11
    JNE RCRBL1ByCL
    MOV addedValueToSIDest,3
    CALL RCRARegisterByteByCL
    JMP ENDEXECUTE
    
    ;RCR BL,CL
    RCRBL1ByCL:
    CMP firstOperandIndex,12
    JNE RCRCH1ByCL
    MOV addedValueToSIDest,2
    CALL RCRARegisterByteByCL
    JMP ENDEXECUTE
    
    ;RCR CH,CL
    RCRCH1ByCL:
    CMP firstOperandIndex,13
    JNE RCRCL1ByCL
    MOV addedValueToSIDest,5
    CALL RCRARegisterByteByCL
    JMP ENDEXECUTE
    
    ;RCR CL,CL
    RCRCL1ByCL:
    CMP firstOperandIndex,14
    JNE RCRDH1ByCL
    MOV addedValueToSIDest,4
    CALL RCRARegisterByteByCL
    JMP ENDEXECUTE
    
    ;RCR DH,CL
    RCRDH1ByCL:
    CMP firstOperandIndex,15
    JNE RCRDL1ByCL
    MOV addedValueToSIDest,7
    CALL RCRARegisterByteByCL
    JMP ENDEXECUTE
    
    ;RCR DL,CL
    RCRDL1ByCL:
    CMP firstOperandIndex,16
    JE RCRDL2ByCL
    JMP NOTAVAILIDCOMMAND
    RCRDL2ByCL:
    MOV addedValueToSIDest,6
    CALL RCRARegisterByteByCL
    JMP ENDEXECUTE
    
    
    ;this is the command for SI,BX,DI only
    RCRCommandForPointer:
    ;check if it's rotate by Cl or a number
    CMP secondOperandIndex,17
    JE RCRPointerRegUsingNum
    JMP RCRPointerRegUsingCL
    RCRPointerRegUsingNum:
    
    ;the Num must be Byte
    CMP numberEntered,255
    JLE AValidNum22
    JMP NOTAVAILIDCOMMAND
    AValidNum22:
    
    ;RCR [BX],NUM
    RCRBXPointerByNum:
    CMP firstOperandIndex,2
    JNE RCRSIPointerByNum 
    MOV addedValueToSIDest,1
    CALL RCRAMemoryByNum
    JMP ENDEXECUTE
    
    ;RCR [SI],NUM
    RCRSIPointerByNum:
    CMP firstOperandIndex,5
    JNE RCRDIPointerByNum
    MOV addedValueToSIDest,4
    CALL RCRAMemoryByNum
    JMP ENDEXECUTE
    
    ;RCR [DI],NUM
    RCRDIPointerByNum:
    CMP firstOperandIndex,6
    JE RCRDIPointerByNum1
    JMP NOTAVAILIDCOMMAND
    RCRDIPointerByNum1:
    MOV addedValueToSIDest,5
    CALL RCRAMemoryByNum
    JMP ENDEXECUTE
    
    ;rotate memory using CL
    RCRPointerRegUsingCL:
    
    ;RCR [BX],CL
    RCRBXPointerByCL:
    CMP firstOperandIndex,2
    JNE RCRSIPointerByCL
    MOV addedValueToSIDest,1 
    CALL RCRAMemoryByCL
    JMP ENDEXECUTE
    
    ;RCR [BX],CL
    RCRSIPointerByCL:
    CMP firstOperandIndex,5
    JNE RCRDIPointerByCL
    MOV addedValueToSIDest,4
    CALL RCRAMemoryByCL
    JMP ENDEXECUTE
    
    ;RCR [BX],CL
    RCRDIPointerByCL:
    CMP firstOperandIndex,6
    JE RCRDIPointerByCL1
    JMP NOTAVAILIDCOMMAND
    RCRDIPointerByCL1:
    MOV addedValueToSIDest,5
    CALL RCRAMemoryByCL
    JMP ENDEXECUTE
;------------------------------------------------------------------------------------------------  
    ;this is RCL command
    RCLCOMMAND:
    CMP commandIndex,6
    JE RCLCOMMAND1
    JMP MOVCOMMAND
    RCLCOMMAND1:
    
    ;the second operand mustn't have brackets
    CMP isSecondOpBracket,1
    JNE ValidCommand15
    JMP NOTAVAILIDCOMMAND
    ValidCommand15:
    
    ;the second operand index is either 17 (Num) or 14 (CL) other than that error
    CMP secondOperandIndex,17
    JE ValidCommand16
    
    CMP secondOperandIndex,14
    JE ValidCommand16
    JMP NOTAVAILIDCOMMAND
    ValidCommand16:
    
    ;if there is a bracket then either BX or SI or DI
    CMP isFirstOpBracket,1
    JNE ValidCommand17
    JMP RCLCommandForPointer
    ValidCommand17:
    
    ;internal check ti see if 2nd operand is CL or NUM
    CMP secondOperandIndex,17
    JE RCLRegUsingNum
    JMP RCLRegUsingCl
    RCLRegUsingNum:
    
    ;the Num must be Byte
    CMP numberEntered,255
    JLE AValidNum5
    JMP NOTAVAILIDCOMMAND
    AValidNum5:
    
    ;RCL AX,NUM
    RCLAX1ByNum:
    CMP firstOperandIndex,1
    JNE RCLBX1ByNum
    MOV addedValueToSIDest,0
    CALL RCLARegisterWordByNum
    JMP ENDEXECUTE  
    
    ;RCL BX,NUM
    RCLBX1ByNum:
    CMP firstOperandIndex,2
    JNE RCLCX1ByNum
    MOV addedValueToSIDest,1
    CALL RCLARegisterWordByNum
    JMP ENDEXECUTE
     
    ;RCL CX,NUM
    RCLCX1ByNum:
    CMP firstOperandIndex,3
    JNE RCLDX1ByNum
    MOV addedValueToSIDest,2
    CALL RCLARegisterWordByNum
    JMP ENDEXECUTE
    
    ;RCL DX,NUM
    RCLDX1ByNum:
    CMP firstOperandIndex,4
    JNE RCLSI1ByNum
    MOV addedValueToSIDest,3
    CALL RCLARegisterWordByNum
    JMP ENDEXECUTE
    
    ;RCL SI,NUM
    RCLSI1ByNum:
    CMP firstOperandIndex,5
    JNE RCLDI1ByNum
    MOV addedValueToSIDest,4
    CALL RCLARegisterWordByNum
    JMP ENDEXECUTE
    
    ;RCL DI,NUM
    RCLDI1ByNum:
    CMP firstOperandIndex,6
    JNE RCLSP1ByNum
    MOV addedValueToSIDest,5
    CALL RCLARegisterWordByNum
    JMP ENDEXECUTE
    
    ;RCL SP,NUM
    RCLSP1ByNum:
    CMP firstOperandIndex,7
    JNE RCLBP1ByNum
    MOV addedValueToSIDest,6
    CALL RCLARegisterWordByNum
    JMP ENDEXECUTE
    
    ;RCL BP,NUM
    RCLBP1ByNum:
    CMP firstOperandIndex,8
    JNE RCLAH1ByNum
    MOV addedValueToSIDest,7
    CALL RCLARegisterWordByNum
    JMP ENDEXECUTE
    
    ;RCL AH,NUM
    RCLAH1ByNum:
    CMP firstOperandIndex,9
    JNE RCLAL1ByNum
    MOV addedValueToSIDest,1
    CALL RCLARegisterByteByNum
    JMP ENDEXECUTE
    
    ;RCL AL,NUM
    RCLAL1ByNum:
    CMP firstOperandIndex,10
    JNE RCLBH1ByNum
    MOV addedValueToSIDest,0
    CALL RCLARegisterByteByNum
    JMP ENDEXECUTE
    
    ;RCL BH,NUM
    RCLBH1ByNum:
    CMP firstOperandIndex,11
    JNE RCLBL1ByNum
    MOV addedValueToSIDest,3
    CALL RCLARegisterByteByNum
    JMP ENDEXECUTE
    
    ;RCL BL,NUM
    RCLBL1ByNum:
    CMP firstOperandIndex,12
    JNE RCLCH1ByNum
    MOV addedValueToSIDest,2
    CALL RCLARegisterByteByNum
    JMP ENDEXECUTE
    
    ;RCL CH,NUM
    RCLCH1ByNum:
    CMP firstOperandIndex,13
    JNE RCLCL1ByNum
    MOV addedValueToSIDest,5
    CALL RCLARegisterByteByNum
    JMP ENDEXECUTE
    
    ;RCL CL,NUM
    RCLCL1ByNum:
    CMP firstOperandIndex,14
    JNE RCLDH1ByNum
    MOV addedValueToSIDest,4
    CALL RCLARegisterByteByNum
    JMP ENDEXECUTE
    
    ;RCL DH,NUM
    RCLDH1ByNum:
    CMP firstOperandIndex,15
    JNE RCLDL1ByNum
    MOV addedValueToSIDest,7
    CALL RCLARegisterByteByNum
    JMP ENDEXECUTE
    
    ;RCL DL,NUM
    RCLDL1ByNum:
    CMP firstOperandIndex,16
    JE RCLDL2ByNum
    JMP NOTAVAILIDCOMMAND
    RCLDL2ByNum:
    MOV addedValueToSIDest,6
    CALL RCLARegisterByteByNum
    JMP ENDEXECUTE
    
    
    ;THIS IS FOR ROTATING REG USING CL
    RCLRegUsingCl:
    
    ;RCL AX,CL
    RCLAX1ByCL:
    CMP firstOperandIndex,1
    JNE RCLBX1ByCL
    MOV addedValueToSIDest,0
    CALL RCLARegisterWordByCL
    JMP ENDEXECUTE  
    
    ;RCL BX,CL
    RCLBX1ByCL:
    CMP firstOperandIndex,2
    JNE RCLCX1ByCL
    MOV addedValueToSIDest,1
    CALL RCLARegisterWordByCL
    JMP ENDEXECUTE
     
    ;RCL CX,CL
    RCLCX1ByCL:
    CMP firstOperandIndex,3
    JNE RCLDX1ByCL
    MOV addedValueToSIDest,2
    CALL RCLARegisterWordByCL
    JMP ENDEXECUTE
    
    ;RCL DX,CL
    RCLDX1ByCL:
    CMP firstOperandIndex,4
    JNE RCLSI1ByCL
    MOV addedValueToSIDest,3
    CALL RCLARegisterWordByCL
    JMP ENDEXECUTE
    
    ;RCL SI,CL
    RCLSI1ByCL:
    CMP firstOperandIndex,5
    JNE RCLDI1ByCL
    MOV addedValueToSIDest,4
    CALL RCLARegisterWordByCL
    JMP ENDEXECUTE
    
    ;RCL DI,CL
    RCLDI1ByCL:
    CMP firstOperandIndex,6
    JNE RCLSP1ByCL
    MOV addedValueToSIDest,5
    CALL RCLARegisterWordByCL
    JMP ENDEXECUTE
    
    ;RCL SP,CL
    RCLSP1ByCL:
    CMP firstOperandIndex,7
    JNE RCLBP1ByCL
    MOV addedValueToSIDest,6
    CALL RCLARegisterWordByCL
    JMP ENDEXECUTE
    
    ;RCL BP,CL
    RCLBP1ByCL:
    CMP firstOperandIndex,8
    JNE RCLAH1ByCL
    MOV addedValueToSIDest,7
    CALL RCLARegisterWordByCL
    JMP ENDEXECUTE
    
    ;RCL AH,CL
    RCLAH1ByCL:
    CMP firstOperandIndex,9
    JNE RCLAL1ByCL
    MOV addedValueToSIDest,1
    CALL RCLARegisterByteByCL
    JMP ENDEXECUTE
    
    ;RCL AL,CL
    RCLAL1ByCL:
    CMP firstOperandIndex,10
    JNE RCLBH1ByCL
    MOV addedValueToSIDest,0
    CALL RCLARegisterByteByCL
    JMP ENDEXECUTE
    
    ;RCL BH,CL
    RCLBH1ByCL:
    CMP firstOperandIndex,11
    JNE RCLBL1ByCL
    MOV addedValueToSIDest,3
    CALL RCLARegisterByteByCL
    JMP ENDEXECUTE
    
    ;RCL BL,CL
    RCLBL1ByCL:
    CMP firstOperandIndex,12
    JNE RCLCH1ByCL
    MOV addedValueToSIDest,2
    CALL RCLARegisterByteByCL
    JMP ENDEXECUTE
    
    ;RCL CH,CL
    RCLCH1ByCL:
    CMP firstOperandIndex,13
    JNE RCLCL1ByCL
    MOV addedValueToSIDest,5
    CALL RCLARegisterByteByCL
    JMP ENDEXECUTE
    
    ;RCL CL,CL
    RCLCL1ByCL:
    CMP firstOperandIndex,14
    JNE RCLDH1ByCL
    MOV addedValueToSIDest,4
    CALL RCLARegisterByteByCL
    JMP ENDEXECUTE
    
    ;RCL DH,CL
    RCLDH1ByCL:
    CMP firstOperandIndex,15
    JNE RCLDL1ByCL
    MOV addedValueToSIDest,7
    CALL RCLARegisterByteByCL
    JMP ENDEXECUTE
    
    ;RCL DL,CL
    RCLDL1ByCL:
    CMP firstOperandIndex,16
    JE RCLDL2ByCL
    JMP NOTAVAILIDCOMMAND
    RCLDL2ByCL:
    MOV addedValueToSIDest,6
    CALL RCLARegisterByteByCL
    JMP ENDEXECUTE
    
    
    ;this is the command for SI,BX,DI only
    RCLCommandForPointer:
    ;check if it's rotate by Cl or a number
    CMP secondOperandIndex,17
    JE RCLPointerRegUsingNum
    JMP RCLPointerRegUsingCL
    RCLPointerRegUsingNum:
    
    ;the Num must be Byte
    CMP numberEntered,255
    JLE AValidNum6
    JMP NOTAVAILIDCOMMAND
    AValidNum6:
    
    ;RCL [BX],NUM
    RCLBXPointerByNum:
    CMP firstOperandIndex,2
    JNE RCLSIPointerByNum
    MOV addedValueToSIDest,1 
    CALL RCLAMemoryByNum
    JMP ENDEXECUTE
    
    ;RCL [SI],NUM
    RCLSIPointerByNum:
    CMP firstOperandIndex,5
    JNE RCLDIPointerByNum
    MOV addedValueToSIDest,4
    CALL RCLAMemoryByNum
    JMP ENDEXECUTE
    
    ;RCL [DI],NUM
    RCLDIPointerByNum:
    CMP firstOperandIndex,6
    JE RCLDIPointerByNum1
    JMP NOTAVAILIDCOMMAND
    RCLDIPointerByNum1:
    MOV addedValueToSIDest,5
    CALL RCLAMemoryByNum
    JMP ENDEXECUTE
    
    ;rotate memory using CL
    RCLPointerRegUsingCL:
    
    ;RCL [BX],CL
    RCLBXPointerByCL:
    CMP firstOperandIndex,2
    JNE RCLSIPointerByCL 
    MOV addedValueToSIDest,1
    CALL RCLAMemoryByCL
    JMP ENDEXECUTE
    
    ;RCL [BX],CL
    RCLSIPointerByCL:
    CMP firstOperandIndex,5
    JNE RCLDIPointerByCL
    MOV addedValueToSIDest,4
    CALL RCLAMemoryByCL
    JMP ENDEXECUTE
    
    ;RCL [BX],CL
    RCLDIPointerByCL:
    CMP firstOperandIndex,6
    JE RCLDIPointerByCL1
    JMP NOTAVAILIDCOMMAND
    RCLDIPointerByCL1:
    MOV addedValueToSIDest,5
    CALL RCLAMemoryByCL
    JMP ENDEXECUTE
;------------------------------------------------------------------------------------------------  
    ;this is MOV command
    MOVCOMMAND:
    CMP commandIndex,7
    JE MOVCOMMAND1
    JMP XORCOMMAND
    MOVCOMMAND1:
    
    ;the two operand mustn't have brackets at the same time
    CMP isSecondOpBracket,1
    JE MOVCOMMAND11
    JMP MOVCOMMAND12
    MOVCOMMAND11:
    CMP isFirstOpBracket,1
    JNE MOVCOMMAND12
    JMP NOTAVAILIDCOMMAND
    
    ;Begin executing commands
    MOVCOMMAND12:
    ;2nd operand has bracket 
    CMP isSecondOpBracket,1
    JE MOVCOMMAND13
    JMP MOVCOMMAND14
    MOVCOMMAND13:
    
    ;========================
    ;MOV destination with no bracket,[SI]
    MOV_PTR_SI_SOURCE:
    CMP secondOperandIndex,5
    JE MOV_PTR_SI_SOURCE1
    JMP MOV_PTR_DI_SOURCE
    MOV_PTR_SI_SOURCE1:
    
    ;MOV AX,PTR_SI
    MOV_AX_PTR_SI:
    CMP firstOperandIndex,1
    JE MOV_AX_PTR_SI1
    JMP MOV_BX_PTR_SI
    MOV_AX_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,0
    CALL MOVAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV BX,PTR_SI
    MOV_BX_PTR_SI:
    CMP firstOperandIndex,2
    JE MOV_BX_PTR_SI1
    JMP MOV_CX_PTR_SI
    MOV_BX_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL MOVAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV CX,PTR_SI
    MOV_CX_PTR_SI:
    CMP firstOperandIndex,3
    JE MOV_CX_PTR_SI1
    JMP MOV_DX_PTR_SI
    MOV_CX_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,2
    CALL MOVAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV DX,PTR_SI
    MOV_DX_PTR_SI:
    CMP firstOperandIndex,4
    JE MOV_DX_PTR_SI1
    JMP MOV_SI_PTR_SI
    MOV_DX_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,3
    CALL MOVAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV SI,PTR_SI
    MOV_SI_PTR_SI:
    CMP firstOperandIndex,5
    JE MOV_SI_PTR_SI1
    JMP MOV_DI_PTR_SI
    MOV_SI_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL MOVAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV DI,PTR_SI
    MOV_DI_PTR_SI:
    CMP firstOperandIndex,6
    JE MOV_DI_PTR_SI1
    JMP MOV_SP_PTR_SI
    MOV_DI_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL MOVAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV SP,PTR_SI
    MOV_SP_PTR_SI:
    CMP firstOperandIndex,7
    JE MOV_SP_PTR_SI1
    JMP MOV_BP_PTR_SI
    MOV_SP_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,6
    CALL MOVAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV BP,PTR_SI
    MOV_BP_PTR_SI:
    CMP firstOperandIndex,7
    JE MOV_BP_PTR_SI1
    JMP MOV_AH_PTR_SI
    MOV_BP_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,7
    CALL MOVAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV AH,PTR_SI
    MOV_AH_PTR_SI:
    CMP firstOperandIndex,9
    JE MOV_AH_PTR_SI1
    JMP MOV_BH_PTR_SI
    MOV_AH_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL MOVAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV BH,PTR_SI
    MOV_BH_PTR_SI:
    CMP firstOperandIndex,11
    JE MOV_BH_PTR_SI1
    JMP MOV_CH_PTR_SI
    MOV_BH_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,3
    CALL MOVAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV CH,PTR_SI
    MOV_CH_PTR_SI:
    CMP firstOperandIndex,13
    JE MOV_CH_PTR_SI1
    JMP MOV_DH_PTR_SI
    MOV_CH_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL MOVAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV DH,PTR_SI
    MOV_DH_PTR_SI:
    CMP firstOperandIndex,15
    JE MOV_DH_PTR_SI1
    JMP MOV_AL_PTR_SI
    MOV_DH_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,7
    CALL MOVAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV AL,PTR_SI
    MOV_AL_PTR_SI:
    CMP firstOperandIndex,10
    JE MOV_AL_PTR_SI1
    JMP MOV_BL_PTR_SI
    MOV_AL_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,0
    CALL MOVAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV BL,PTR_SI
    MOV_BL_PTR_SI:
    CMP firstOperandIndex,12
    JE MOV_BL_PTR_SI1
    JMP MOV_CL_PTR_SI
    MOV_BL_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,2
    CALL MOVAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV CL,PTR_SI
    MOV_CL_PTR_SI:
    CMP firstOperandIndex,14
    JE MOV_CL_PTR_SI1
    JMP MOV_DL_PTR_SI
    MOV_CL_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL MOVAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV DL,PTR_SI
    MOV_DL_PTR_SI:
    CMP firstOperandIndex,16
    JE MOV_DL_PTR_SI1
    JMP NOTAVAILIDCOMMAND
    MOV_DL_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,6
    CALL MOVAByteRegWithPointer
    JMP ENDEXECUTE
 
    ;========================
    ;MOV destination with no bracket,[DI]
    MOV_PTR_DI_SOURCE:
    CMP secondOperandIndex,6
    JE MOV_PTR_DI_SOURCE1
    JMP MOV_PTR_BX_SOURCE
    MOV_PTR_DI_SOURCE1:
    
    ;MOV AX,PTR_DI
    MOV_AX_PTR_DI:
    CMP firstOperandIndex,1
    JE MOV_AX_PTR_DI1
    JMP MOV_BX_PTR_DI
    MOV_AX_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,0
    CALL MOVAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV BX,PTR_DI
    MOV_BX_PTR_DI:
    CMP firstOperandIndex,2
    JE MOV_BX_PTR_DI1
    JMP MOV_CX_PTR_DI
    MOV_BX_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,1
    CALL MOVAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV CX,PTR_DI
    MOV_CX_PTR_DI:
    CMP firstOperandIndex,3
    JE MOV_CX_PTR_DI1
    JMP MOV_DX_PTR_DI
    MOV_CX_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,2
    CALL MOVAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV DX,PTR_DI
    MOV_DX_PTR_DI:
    CMP firstOperandIndex,4
    JE MOV_DX_PTR_DI1
    JMP MOV_SI_PTR_DI
    MOV_DX_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,3
    CALL MOVAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV SI,PTR_DI
    MOV_SI_PTR_DI:
    CMP firstOperandIndex,5
    JE MOV_SI_PTR_DI1
    JMP MOV_DI_PTR_DI
    MOV_SI_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,4
    CALL MOVAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV DI,PTR_DI
    MOV_DI_PTR_DI:
    CMP firstOperandIndex,6
    JE MOV_DI_PTR_DI1
    JMP MOV_SP_PTR_DI
    MOV_DI_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,5
    CALL MOVAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV SP,PTR_DI
    MOV_SP_PTR_DI:
    CMP firstOperandIndex,7
    JE MOV_SP_PTR_DI1
    JMP MOV_BP_PTR_DI
    MOV_SP_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,6
    CALL MOVAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV BP,PTR_DI
    MOV_BP_PTR_DI:
    CMP firstOperandIndex,7
    JE MOV_BP_PTR_DI1
    JMP MOV_AH_PTR_DI
    MOV_BP_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,7
    CALL MOVAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV AH,PTR_DI
    MOV_AH_PTR_DI:
    CMP firstOperandIndex,9
    JE MOV_AH_PTR_DI1
    JMP MOV_BH_PTR_DI
    MOV_AH_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,1
    CALL MOVAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV BH,PTR_DI
    MOV_BH_PTR_DI:
    CMP firstOperandIndex,11
    JE MOV_BH_PTR_DI1
    JMP MOV_CH_PTR_DI
    MOV_BH_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,3
    CALL MOVAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV CH,PTR_DI
    MOV_CH_PTR_DI:
    CMP firstOperandIndex,13
    JE MOV_CH_PTR_DI1
    JMP MOV_DH_PTR_DI
    MOV_CH_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,5
    CALL MOVAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV DH,PTR_DI
    MOV_DH_PTR_DI:
    CMP firstOperandIndex,15
    JE MOV_DH_PTR_DI1
    JMP MOV_AL_PTR_DI
    MOV_DH_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,7
    CALL MOVAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV AL,PTR_DI
    MOV_AL_PTR_DI:
    CMP firstOperandIndex,10
    JE MOV_AL_PTR_DI1
    JMP MOV_BL_PTR_DI
    MOV_AL_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,0
    CALL MOVAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV BL,PTR_DI
    MOV_BL_PTR_DI:
    CMP firstOperandIndex,12
    JE MOV_BL_PTR_DI1
    JMP MOV_CL_PTR_DI
    MOV_BL_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,2
    CALL MOVAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV CL,PTR_DI
    MOV_CL_PTR_DI:
    CMP firstOperandIndex,14
    JE MOV_CL_PTR_DI1
    JMP MOV_DL_PTR_DI
    MOV_CL_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,4
    CALL MOVAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV DL,PTR_DI
    MOV_DL_PTR_DI:
    CMP firstOperandIndex,16
    JE MOV_DL_PTR_DI1
    JMP NOTAVAILIDCOMMAND
    MOV_DL_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,6
    CALL MOVAByteRegWithPointer
    JMP ENDEXECUTE

    ;========================
    ;MOV destination with no bracket,[BX]
    MOV_PTR_BX_SOURCE:
    CMP secondOperandIndex,2
    JE MOV_PTR_BX_SOURCE1
    JMP MOV_PTR_NUM_SOURCE
    MOV_PTR_BX_SOURCE1:
    
    ;MOV AX,PTR_BX
    MOV_AX_PTR_BX:
    CMP firstOperandIndex,1
    JE MOV_AX_PTR_BX1
    JMP MOV_BX_PTR_BX
    MOV_AX_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,0
    CALL MOVAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV BX,PTR_BX
    MOV_BX_PTR_BX:
    CMP firstOperandIndex,2
    JE MOV_BX_PTR_BX1
    JMP MOV_CX_PTR_BX
    MOV_BX_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL MOVAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV CX,PTR_BX
    MOV_CX_PTR_BX:
    CMP firstOperandIndex,3
    JE MOV_CX_PTR_BX1
    JMP MOV_DX_PTR_BX
    MOV_CX_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,2
    CALL MOVAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV DX,PTR_BX
    MOV_DX_PTR_BX:
    CMP firstOperandIndex,4
    JE MOV_DX_PTR_BX1
    JMP MOV_SI_PTR_BX
    MOV_DX_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,3
    CALL MOVAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV SI,PTR_BX
    MOV_SI_PTR_BX:
    CMP firstOperandIndex,5
    JE MOV_SI_PTR_BX1
    JMP MOV_DI_PTR_BX
    MOV_SI_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL MOVAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV DI,PTR_BX
    MOV_DI_PTR_BX:
    CMP firstOperandIndex,6
    JE MOV_DI_PTR_BX1
    JMP MOV_SP_PTR_BX
    MOV_DI_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL MOVAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV SP,PTR_BX
    MOV_SP_PTR_BX:
    CMP firstOperandIndex,7
    JE MOV_SP_PTR_BX1
    JMP MOV_BP_PTR_BX
    MOV_SP_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,6
    CALL MOVAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV BP,PTR_BX
    MOV_BP_PTR_BX:
    CMP firstOperandIndex,7
    JE MOV_BP_PTR_BX1
    JMP MOV_AH_PTR_BX
    MOV_BP_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,7
    CALL MOVAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV AH,PTR_BX
    MOV_AH_PTR_BX:
    CMP firstOperandIndex,9
    JE MOV_AH_PTR_BX1
    JMP MOV_BH_PTR_BX
    MOV_AH_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL MOVAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV BH,PTR_BX
    MOV_BH_PTR_BX:
    CMP firstOperandIndex,11
    JE MOV_BH_PTR_BX1
    JMP MOV_CH_PTR_BX
    MOV_BH_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,3
    CALL MOVAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV CH,PTR_BX
    MOV_CH_PTR_BX:
    CMP firstOperandIndex,13
    JE MOV_CH_PTR_BX1
    JMP MOV_DH_PTR_BX
    MOV_CH_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL MOVAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV DH,PTR_BX
    MOV_DH_PTR_BX:
    CMP firstOperandIndex,15
    JE MOV_DH_PTR_BX1
    JMP MOV_AL_PTR_BX
    MOV_DH_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,7
    CALL MOVAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV AL,PTR_BX
    MOV_AL_PTR_BX:
    CMP firstOperandIndex,10
    JE MOV_AL_PTR_BX1
    JMP MOV_BL_PTR_BX
    MOV_AL_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,0
    CALL MOVAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV BL,PTR_BX
    MOV_BL_PTR_BX:
    CMP firstOperandIndex,12
    JE MOV_BL_PTR_BX1
    JMP MOV_CL_PTR_BX
    MOV_BL_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,2
    CALL MOVAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV CL,PTR_BX
    MOV_CL_PTR_BX:
    CMP firstOperandIndex,14
    JE MOV_CL_PTR_BX1
    JMP MOV_DL_PTR_BX
    MOV_CL_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL MOVAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;MOV DL,PTR_BX
    MOV_DL_PTR_BX:
    CMP firstOperandIndex,16
    JE MOV_DL_PTR_BX1
    JMP NOTAVAILIDCOMMAND
    MOV_DL_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,6
    CALL MOVAByteRegWithPointer
    JMP ENDEXECUTE
    
    
    MOV_PTR_NUM_SOURCE:
    ;========================
    ;MOV destination with no bracket,[NUM]
    MOV_PTR_NUM_SOURCE:
    CMP secondOperandIndex,17
    JE MOV_PTR_NUM_SOURCE1
    JMP NOTAVAILIDCOMMAND
    MOV_PTR_NUM_SOURCE1:
    
    ;MOV AX,PTR_NUM
    MOV_AX_PTR_NUM:
    CMP firstOperandIndex,1
    JE MOV_AX_PTR_NUM1
    JMP MOV_BX_PTR_NUM
    MOV_AX_PTR_NUM1:
    MOV addedValueToSIDest,0
    CALL MOVAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;MOV BX,PTR_NUM
    MOV_BX_PTR_NUM:
    CMP firstOperandIndex,2
    JE MOV_BX_PTR_NUM1
    JMP MOV_CX_PTR_NUM
    MOV_BX_PTR_NUM1:
    MOV addedValueToSIDest,1
    CALL MOVAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;MOV CX,PTR_NUM
    MOV_CX_PTR_NUM:
    CMP firstOperandIndex,3
    JE MOV_CX_PTR_NUM1
    JMP MOV_DX_PTR_NUM
    MOV_CX_PTR_NUM1:
    MOV addedValueToSIDest,2
    CALL MOVAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;MOV DX,PTR_NUM
    MOV_DX_PTR_NUM:
    CMP firstOperandIndex,4
    JE MOV_DX_PTR_NUM1
    JMP MOV_SI_PTR_NUM
    MOV_DX_PTR_NUM1:
    MOV addedValueToSIDest,3
    CALL MOVAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;MOV SI,PTR_NUM
    MOV_SI_PTR_NUM:
    CMP firstOperandIndex,5
    JE MOV_SI_PTR_NUM1
    JMP MOV_DI_PTR_NUM
    MOV_SI_PTR_NUM1:
    MOV addedValueToSIDest,4
    CALL MOVAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;MOV DI,PTR_NUM
    MOV_DI_PTR_NUM:
    CMP firstOperandIndex,6
    JE MOV_DI_PTR_NUM1
    JMP MOV_SP_PTR_NUM
    MOV_DI_PTR_NUM1:
    MOV addedValueToSIDest,5
    CALL MOVAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;MOV SP,PTR_NUM
    MOV_SP_PTR_NUM:
    CMP firstOperandIndex,7
    JE MOV_SP_PTR_NUM1
    JMP MOV_BP_PTR_NUM
    MOV_SP_PTR_NUM1:
    MOV addedValueToSIDest,6
    CALL MOVAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;MOV BP,PTR_NUM
    MOV_BP_PTR_NUM:
    CMP firstOperandIndex,7
    JE MOV_BP_PTR_NUM1
    JMP MOV_AH_PTR_NUM
    MOV_BP_PTR_NUM1:
    MOV addedValueToSIDest,7
    CALL MOVAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;MOV AH,PTR_NUM
    MOV_AH_PTR_NUM:
    CMP firstOperandIndex,9
    JE MOV_AH_PTR_NUM1
    JMP MOV_BH_PTR_NUM
    MOV_AH_PTR_NUM1:
    MOV addedValueToSIDest,1
    CALL MOVAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;MOV BH,PTR_NUM
    MOV_BH_PTR_NUM:
    CMP firstOperandIndex,11
    JE MOV_BH_PTR_NUM1
    JMP MOV_CH_PTR_NUM
    MOV_BH_PTR_NUM1:
    MOV addedValueToSIDest,3
    CALL MOVAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;MOV CH,PTR_NUM
    MOV_CH_PTR_NUM:
    CMP firstOperandIndex,13
    JE MOV_CH_PTR_NUM1
    JMP MOV_DH_PTR_NUM
    MOV_CH_PTR_NUM1:
    MOV addedValueToSIDest,5
    CALL MOVAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;MOV DH,PTR_NUM
    MOV_DH_PTR_NUM:
    CMP firstOperandIndex,15
    JE MOV_DH_PTR_NUM1
    JMP MOV_AL_PTR_NUM
    MOV_DH_PTR_NUM1:
    MOV addedValueToSIDest,7
    CALL MOVAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;MOV AL,PTR_NUM
    MOV_AL_PTR_NUM:
    CMP firstOperandIndex,10
    JE MOV_AL_PTR_NUM1
    JMP MOV_BL_PTR_NUM
    MOV_AL_PTR_NUM1:
    MOV addedValueToSIDest,0
    CALL MOVAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;MOV BL,PTR_NUM
    MOV_BL_PTR_NUM:
    CMP firstOperandIndex,12
    JE MOV_BL_PTR_NUM1
    JMP MOV_CL_PTR_NUM
    MOV_BL_PTR_NUM1:
    MOV addedValueToSIDest,2
    CALL MOVAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;MOV CL,PTR_NUM
    MOV_CL_PTR_NUM:
    CMP firstOperandIndex,14
    JE MOV_CL_PTR_NUM1
    JMP MOV_DL_PTR_NUM
    MOV_CL_PTR_NUM1:
    MOV addedValueToSIDest,4
    CALL MOVAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;MOV DL,PTR_NUM
    MOV_DL_PTR_NUM:
    CMP firstOperandIndex,16
    JE MOV_DL_PTR_NUM1
    JMP NOTAVAILIDCOMMAND
    MOV_DL_PTR_NUM1:
    MOV addedValueToSIDest,6
    CALL MOVAByteRegWithMemory
    JMP ENDEXECUTE
    
    
    MOVCOMMAND14:
    ;1nd operand has bracket 
    CMP isFirstOpBracket,1
    JE MOVCOMMAND15
    JMP MOVCOMMAND16
    MOVCOMMAND15:
    
    ;========================
    ;MOV [SI],Source with no bracket
    MOV_PTR_SI_DEST:
    CMP firstOperandIndex,5
    JE MOV_PTR_SI_DEST1
    JMP MOV_PTR_DI_DEST
    MOV_PTR_SI_DEST1:
    
    ;MOV PTR_SI,AX
    MOV_PTR_SI_AX:
    CMP secondOperandIndex,1
    JE MOV_PTR_SI_AX1
    JMP MOV_PTR_SI_BX
    MOV_PTR_SI_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,4
    CALL MOVAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV PTR_SI,BX
    MOV_PTR_SI_BX:
    CMP secondOperandIndex,2
    JE MOV_PTR_SI_BX1
    JMP MOV_PTR_SI_CX
    MOV_PTR_SI_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,4
    CALL MOVAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV PTR_SI,CX
    MOV_PTR_SI_CX:
    CMP secondOperandIndex,3
    JE MOV_PTR_SI_CX1
    JMP MOV_PTR_SI_DX
    MOV_PTR_SI_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,4
    CALL MOVAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV PTR_SI,DX
    MOV_PTR_SI_DX:
    CMP secondOperandIndex,4
    JE MOV_PTR_SI_DX1
    JMP MOV_PTR_SI_SI
    MOV_PTR_SI_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,4
    CALL MOVAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV PTR_SI,SI
    MOV_PTR_SI_SI:
    CMP secondOperandIndex,5
    JE MOV_PTR_SI_SI1
    JMP MOV_PTR_SI_DI
    MOV_PTR_SI_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL MOVAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV PTR_SI,DI
    MOV_PTR_SI_DI:
    CMP secondOperandIndex,6
    JE MOV_PTR_SI_DI1
    JMP MOV_PTR_SI_SP
    MOV_PTR_SI_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,4
    CALL MOVAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV PTR_SI,SP
    MOV_PTR_SI_SP:
    CMP secondOperandIndex,7
    JE MOV_PTR_SI_SP1
    JMP MOV_PTR_SI_BP
    MOV_PTR_SI_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,4
    CALL MOVAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV PTR_SI,BP
    MOV_PTR_SI_BP:
    CMP secondOperandIndex,7
    JE MOV_PTR_SI_BP1
    JMP MOV_PTR_SI_AH
    MOV_PTR_SI_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,4
    CALL MOVAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV PTR_SI,AH
    MOV_PTR_SI_AH:
    CMP secondOperandIndex,9
    JE MOV_PTR_SI_AH1
    JMP MOV_PTR_SI_BH
    MOV_PTR_SI_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,4
    CALL MOVAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV PTR_SI,BH
    MOV_PTR_SI_BH:
    CMP secondOperandIndex,11
    JE MOV_PTR_SI_BH1
    JMP MOV_PTR_SI_CH
    MOV_PTR_SI_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,4
    CALL MOVAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV PTR_SI,CH
    MOV_PTR_SI_CH:
    CMP secondOperandIndex,13
    JE MOV_PTR_SI_CH1
    JMP MOV_PTR_SI_DH
    MOV_PTR_SI_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,4
    CALL MOVAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV PTR_SI,DH
    MOV_PTR_SI_DH:
    CMP secondOperandIndex,15
    JE MOV_PTR_SI_DH1
    JMP MOV_PTR_SI_AL
    MOV_PTR_SI_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,4
    CALL MOVAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV PTR_SI,AL
    MOV_PTR_SI_AL:
    CMP secondOperandIndex,10
    JE MOV_PTR_SI_AL1
    JMP MOV_PTR_SI_BL
    MOV_PTR_SI_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,4
    CALL MOVAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV PTR_SI,BL
    MOV_PTR_SI_BL:
    CMP secondOperandIndex,12
    JE MOV_PTR_SI_BL1
    JMP MOV_PTR_SI_CL
    MOV_PTR_SI_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,4
    CALL MOVAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV PTR_SI,CL
    MOV_PTR_SI_CL:
    CMP secondOperandIndex,14
    JE MOV_PTR_SI_CL1
    JMP MOV_PTR_SI_DL
    MOV_PTR_SI_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL MOVAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV PTR_SI,DL
    MOV_PTR_SI_DL:
    CMP secondOperandIndex,16
    JE MOV_PTR_SI_DL1
    JMP MOV_PTR_SI_NUM
    MOV_PTR_SI_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,4
    CALL MOVAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV PTR_SI,NUM
    MOV_PTR_SI_NUM:
    CMP secondOperandIndex,17
    JE MOV_PTR_SI_NUM1
    JMP NOTAVAILIDCOMMAND
    MOV_PTR_SI_NUM1:
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,4
    CALL MOVAPointerRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;MOV [DI],Source with no bracket
    MOV_PTR_DI_DEST:
    CMP firstOperandIndex,6
    JE MOV_PTR_DI_DEST1
    JMP MOV_PTR_BX_DEST
    MOV_PTR_DI_DEST1:
    
    ;MOV PTR_DI,AX
    MOV_PTR_DI_AX:
    CMP secondOperandIndex,1
    JE MOV_PTR_DI_AX1
    JMP MOV_PTR_DI_BX
    MOV_PTR_DI_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,5
    CALL MOVAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV PTR_DI,BX
    MOV_PTR_DI_BX:
    CMP secondOperandIndex,2
    JE MOV_PTR_DI_BX1
    JMP MOV_PTR_DI_CX
    MOV_PTR_DI_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,5
    CALL MOVAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV PTR_DI,CX
    MOV_PTR_DI_CX:
    CMP secondOperandIndex,3
    JE MOV_PTR_DI_CX1
    JMP MOV_PTR_DI_DX
    MOV_PTR_DI_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,5
    CALL MOVAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV PTR_DI,DX
    MOV_PTR_DI_DX:
    CMP secondOperandIndex,4
    JE MOV_PTR_DI_DX1
    JMP MOV_PTR_DI_SI
    MOV_PTR_DI_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,5
    CALL MOVAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV PTR_DI,SI
    MOV_PTR_DI_SI:
    CMP secondOperandIndex,5
    JE MOV_PTR_DI_SI1
    JMP MOV_PTR_DI_DI
    MOV_PTR_DI_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL MOVAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV PTR_DI,DI
    MOV_PTR_DI_DI:
    CMP secondOperandIndex,6
    JE MOV_PTR_DI_DI1
    JMP MOV_PTR_DI_SP
    MOV_PTR_DI_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,5
    CALL MOVAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV PTR_DI,SP
    MOV_PTR_DI_SP:
    CMP secondOperandIndex,7
    JE MOV_PTR_DI_SP1
    JMP MOV_PTR_DI_BP
    MOV_PTR_DI_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,5
    CALL MOVAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV PTR_DI,BP
    MOV_PTR_DI_BP:
    CMP secondOperandIndex,7
    JE MOV_PTR_DI_BP1
    JMP MOV_PTR_DI_BH
    MOV_PTR_DI_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,5
    CALL MOVAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV PTR_DI,AH
    MOV_PTR_DI_AH:
    CMP secondOperandIndex,9
    JE MOV_PTR_DI_AH1
    JMP MOV_PTR_DI_BH
    MOV_PTR_DI_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,5
    CALL MOVAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV PTR_DI,BH
    MOV_PTR_DI_BH:
    CMP secondOperandIndex,11
    JE MOV_PTR_DI_BH1
    JMP MOV_PTR_DI_CH
    MOV_PTR_DI_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,5
    CALL MOVAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV PTR_DI,CH
    MOV_PTR_DI_CH:
    CMP secondOperandIndex,13
    JE MOV_PTR_DI_CH1
    JMP MOV_PTR_DI_DH
    MOV_PTR_DI_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,5
    CALL MOVAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV PTR_DI,DH
    MOV_PTR_DI_DH:
    CMP secondOperandIndex,15
    JE MOV_PTR_DI_DH1
    JMP MOV_PTR_DI_AL
    MOV_PTR_DI_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,5
    CALL MOVAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV PTR_DI,AL
    MOV_PTR_DI_AL:
    CMP secondOperandIndex,10
    JE MOV_PTR_DI_AL1
    JMP MOV_PTR_DI_BL
    MOV_PTR_DI_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,5
    CALL MOVAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV PTR_DI,BL
    MOV_PTR_DI_BL:
    CMP secondOperandIndex,12
    JE MOV_PTR_DI_BL1
    JMP MOV_PTR_DI_CL
    MOV_PTR_DI_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,5
    CALL MOVAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV PTR_DI,CL
    MOV_PTR_DI_CL:
    CMP secondOperandIndex,14
    JE MOV_PTR_DI_CL1
    JMP MOV_PTR_DI_DL
    MOV_PTR_DI_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL MOVAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV PTR_DI,DL
    MOV_PTR_DI_DL:
    CMP secondOperandIndex,16
    JE MOV_PTR_DI_DL1
    JMP MOV_PTR_DI_NUM
    MOV_PTR_DI_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,5
    CALL MOVAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV PTR_DI,NUM
    MOV_PTR_DI_NUM:
    CMP secondOperandIndex,17
    JE MOV_PTR_DI_NUM1
    JMP NOTAVAILIDCOMMAND
    MOV_PTR_DI_NUM1:
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,5
    CALL MOVAPointerRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;MOV [BX],Source with no bracket
    MOV_PTR_BX_DEST:
    CMP firstOperandIndex,2
    JE MOV_PTR_BX_DEST1
    JMP NOTAVAILIDCOMMAND
    MOV_PTR_BX_DEST1:
    
    ;MOV PTR_BX,AX
    MOV_PTR_BX_AX:
    CMP secondOperandIndex,1
    JE MOV_PTR_BX_AX1
    JMP MOV_PTR_BX_BX
    MOV_PTR_BX_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,1
    CALL MOVAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV PTR_BX,BX
    MOV_PTR_BX_BX:
    CMP secondOperandIndex,2
    JE MOV_PTR_BX_BX1
    JMP MOV_PTR_BX_CX
    MOV_PTR_BX_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,1
    CALL MOVAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV PTR_BX,CX
    MOV_PTR_BX_CX:
    CMP secondOperandIndex,3
    JE MOV_PTR_BX_CX1
    JMP MOV_PTR_BX_DX
    MOV_PTR_BX_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,1
    CALL MOVAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV PTR_BX,DX
    MOV_PTR_BX_DX:
    CMP secondOperandIndex,4
    JE MOV_PTR_BX_DX1
    JMP MOV_PTR_BX_SI
    MOV_PTR_BX_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,1
    CALL MOVAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV PTR_BX,SI
    MOV_PTR_BX_SI:
    CMP secondOperandIndex,5
    JE MOV_PTR_BX_SI1
    JMP MOV_PTR_BX_DI
    MOV_PTR_BX_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL MOVAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV PTR_BX,DI
    MOV_PTR_BX_DI:
    CMP secondOperandIndex,6
    JE MOV_PTR_BX_DI1
    JMP MOV_PTR_BX_SP
    MOV_PTR_BX_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,1
    CALL MOVAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV PTR_BX,SP
    MOV_PTR_BX_SP:
    CMP secondOperandIndex,7
    JE MOV_PTR_BX_SP1
    JMP MOV_PTR_BX_BP
    MOV_PTR_BX_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,1
    CALL MOVAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV PTR_BX,BP
    MOV_PTR_BX_BP:
    CMP secondOperandIndex,7
    JE MOV_PTR_BX_BP1
    JMP MOV_PTR_BX_AH
    
    MOV_PTR_BX_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,1
    CALL MOVAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV PTR_BX,AH
    MOV_PTR_BX_AH:
    CMP secondOperandIndex,9
    JE MOV_PTR_BX_AH1
    JMP MOV_PTR_BX_BH
    MOV_PTR_BX_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,1
    CALL MOVAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV PTR_BX,BH
    MOV_PTR_BX_BH:
    CMP secondOperandIndex,11
    JE MOV_PTR_BX_BH1
    JMP MOV_PTR_BX_CH
    MOV_PTR_BX_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,1
    CALL MOVAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV PTR_BX,CH
    MOV_PTR_BX_CH:
    CMP secondOperandIndex,13
    JE MOV_PTR_BX_CH1
    JMP MOV_PTR_BX_DH
    MOV_PTR_BX_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,1
    CALL MOVAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV PTR_BX,DH
    MOV_PTR_BX_DH:
    CMP secondOperandIndex,15
    JE MOV_PTR_BX_DH1
    JMP MOV_PTR_BX_AL
    MOV_PTR_BX_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,1
    CALL MOVAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV PTR_BX,AL
    MOV_PTR_BX_AL:
    CMP secondOperandIndex,10
    JE MOV_PTR_BX_AL1
    JMP MOV_PTR_BX_BL
    MOV_PTR_BX_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,1
    CALL MOVAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV PTR_BX,BL
    MOV_PTR_BX_BL:
    CMP secondOperandIndex,12
    JE MOV_PTR_BX_BL1
    JMP MOV_PTR_BX_CL
    MOV_PTR_BX_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,1
    CALL MOVAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV PTR_BX,CL
    MOV_PTR_BX_CL:
    CMP secondOperandIndex,14
    JE MOV_PTR_BX_CL1
    JMP MOV_PTR_BX_DL
    MOV_PTR_BX_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL MOVAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV PTR_BX,DL
    MOV_PTR_BX_DL:
    CMP secondOperandIndex,16
    JE MOV_PTR_BX_DL1
    JMP MOV_PTR_BX_NUM
    MOV_PTR_BX_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,1
    CALL MOVAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV PTR_BX,NUM
    MOV_PTR_BX_NUM:
    CMP secondOperandIndex,17
    JE MOV_PTR_BX_NUM1
    JMP NOTAVAILIDCOMMAND
    MOV_PTR_BX_NUM1:
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,1
    CALL MOVAPointerRegWithNUM
    JMP ENDEXECUTE
    
    MOVCOMMAND16:
    ;neither operand has bracket
    ;========================
    ;MOV AX,Source with no bracket
    MOV_AX1:
    CMP firstOperandIndex,1
    JE MOV_AX2
    JMP MOV_BX1
    MOV_AX2:
    
    ;MOV AX,AX
    MOV_AX_AX:
    CMP secondOperandIndex,1
    JE MOV_AX_AX1
    JMP MOV_AX_BX
    MOV_AX_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,0
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV AX,BX
    MOV_AX_BX:
    CMP secondOperandIndex,2
    JE MOV_AX_BX1
    JMP MOV_AX_CX
    MOV_AX_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,0
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV AX,CX
    MOV_AX_CX:
    CMP secondOperandIndex,3
    JE MOV_AX_CX1
    JMP MOV_AX_DX
    MOV_AX_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,0
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV AX,DX
    MOV_AX_DX:
    CMP secondOperandIndex,4
    JE MOV_AX_DX1
    JMP MOV_AX_SI
    MOV_AX_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,0
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV AX,SI
    MOV_AX_SI:
    CMP secondOperandIndex,5
    JE MOV_AX_SI1
    JMP MOV_AX_DI
    MOV_AX_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,0
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV AX,DI
    MOV_AX_DI:
    CMP secondOperandIndex,6
    JE MOV_AX_DI1
    JMP MOV_AX_SP
    MOV_AX_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,0
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV AX,SP
    MOV_AX_SP:
    CMP secondOperandIndex,7
    JE MOV_AX_SP1
    JMP MOV_AX_BP
    MOV_AX_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,0
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV AX,BP
    MOV_AX_BP:
    CMP secondOperandIndex,7
    JE MOV_AX_BP1
    JMP MOV_AX_NUM
    MOV_AX_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,0
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV AX,NUM
    MOV_AX_NUM:
    CMP secondOperandIndex,17
    JE MOV_AX_NUM1
    JMP NOTAVAILIDCOMMAND
    MOV_AX_NUM1:
    MOV addedValueToSIDest,0
    CALL MOVAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;MOV BX,Source with no bracket    
    MOV_BX1:
    CMP firstOperandIndex,2
    JE MOV_BX2
    JMP MOV_CX1
    MOV_BX2:
    
    ;MOV BX,AX
    MOV_BX_AX:
    CMP secondOperandIndex,1
    JE MOV_BX_AX1
    JMP MOV_BX_BX
    MOV_BX_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,1
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV BX,BX
    MOV_BX_BX:
    CMP secondOperandIndex,2
    JE MOV_BX_BX1
    JMP MOV_BX_CX
    MOV_BX_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,1
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV BX,CX
    MOV_BX_CX:
    CMP secondOperandIndex,3
    JE MOV_BX_CX1
    JMP MOV_BX_DX
    MOV_BX_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,1
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV BX,DX
    MOV_BX_DX:
    CMP secondOperandIndex,4
    JE MOV_BX_DX1
    JMP MOV_BX_SI
    MOV_BX_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,1
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV BX,SI
    MOV_BX_SI:
    CMP secondOperandIndex,5
    JE MOV_BX_SI1
    JMP MOV_BX_DI
    MOV_BX_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV BX,DI
    MOV_BX_DI:
    CMP secondOperandIndex,6
    JE MOV_BX_DI1
    JMP MOV_BX_SP
    MOV_BX_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,1
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV BX,SP
    MOV_BX_SP:
    CMP secondOperandIndex,7
    JE MOV_BX_SP1
    JMP MOV_BX_BP
    MOV_BX_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,1
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV BX,BP
    MOV_BX_BP:
    CMP secondOperandIndex,7
    JE MOV_BX_BP1
    JMP MOV_BX_NUM
    MOV_BX_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,1
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV BX,NUM
    MOV_BX_NUM:
    CMP secondOperandIndex,17
    JE MOV_BX_NUM1
    JMP NOTAVAILIDCOMMAND
    MOV_BX_NUM1:
    MOV addedValueToSIDest,1
    CALL MOVAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;MOV CX,Source with no bracket
    MOV_CX1:
    CMP firstOperandIndex,3
    JE MOV_CX2
    JMP MOV_DX1
    MOV_CX2:
    
    ;MOV CX,AX
    MOV_CX_AX:
    CMP secondOperandIndex,1
    JE MOV_CX_AX1
    JMP MOV_CX_BX
    MOV_CX_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,2
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV CX,BX
    MOV_CX_BX:
    CMP secondOperandIndex,2
    JE MOV_CX_BX1
    JMP MOV_CX_CX
    MOV_CX_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,2
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV CX,CX
    MOV_CX_CX:
    CMP secondOperandIndex,3
    JE MOV_CX_CX1
    JMP MOV_CX_DX
    MOV_CX_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,2
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV CX,DX
    MOV_CX_DX:
    CMP secondOperandIndex,4
    JE MOV_CX_DX1
    JMP MOV_CX_SI
    MOV_CX_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,2
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV CX,SI
    MOV_CX_SI:
    CMP secondOperandIndex,5
    JE MOV_CX_SI1
    JMP MOV_CX_DI
    MOV_CX_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,2
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV CX,DI
    MOV_CX_DI:
    CMP secondOperandIndex,6
    JE MOV_CX_DI1
    JMP MOV_CX_SP
    MOV_CX_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,2
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV CX,SP
    MOV_CX_SP:
    CMP secondOperandIndex,7
    JE MOV_CX_SP1
    JMP MOV_CX_BP
    MOV_CX_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,2
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV CX,BP
    MOV_CX_BP:
    CMP secondOperandIndex,7
    JE MOV_CX_BP1
    JMP MOV_CX_NUM
    MOV_CX_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,2
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV CX,NUM
    MOV_CX_NUM:
    CMP secondOperandIndex,17
    JE MOV_CX_NUM1
    JMP NOTAVAILIDCOMMAND
    MOV_CX_NUM1:
    MOV addedValueToSIDest,2
    CALL MOVAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;MOV DX,Source with no bracket
    MOV_DX1:
    CMP firstOperandIndex,4
    JE MOV_DX2
    JMP MOV_SI1
    MOV_DX2:
    
    ;MOV DX,AX
    MOV_DX_AX:
    CMP secondOperandIndex,1
    JE MOV_DX_AX1
    JMP MOV_DX_BX
    MOV_DX_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,3
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV DX,BX
    MOV_DX_BX:
    CMP secondOperandIndex,2
    JE MOV_DX_BX1
    JMP MOV_DX_CX
    MOV_DX_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,3
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV DX,CX
    MOV_DX_CX:
    CMP secondOperandIndex,3
    JE MOV_DX_CX1
    JMP MOV_DX_DX
    MOV_DX_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,3
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV DX,DX
    MOV_DX_DX:
    CMP secondOperandIndex,4
    JE MOV_DX_DX1
    JMP MOV_DX_SI
    MOV_DX_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,3
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV DX,SI
    MOV_DX_SI:
    CMP secondOperandIndex,5
    JE MOV_DX_SI1
    JMP MOV_DX_DI
    MOV_DX_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,3
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV DX,DI
    MOV_DX_DI:
    CMP secondOperandIndex,6
    JE MOV_DX_DI1
    JMP MOV_DX_SP
    MOV_DX_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,3
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV DX,SP
    MOV_DX_SP:
    CMP secondOperandIndex,7
    JE MOV_DX_SP1
    JMP MOV_DX_BP
    MOV_DX_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,3
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV DX,BP
    MOV_DX_BP:
    CMP secondOperandIndex,7
    JE MOV_DX_BP1
    JMP MOV_DX_NUM
    MOV_DX_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,3
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV DX,NUM
    MOV_DX_NUM:
    CMP secondOperandIndex,17
    JE MOV_DX_NUM1
    JMP NOTAVAILIDCOMMAND
    MOV_DX_NUM1:
    MOV addedValueToSIDest,3
    CALL MOVAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;MOV SI,Source with no bracket
    MOV_SI1:
    CMP firstOperandIndex,5
    JE MOV_SI2
    JMP MOV_DI1
    MOV_SI2:
    
    ;MOV SI,AX
    MOV_SI_AX:
    CMP secondOperandIndex,1
    JE MOV_SI_AX1
    JMP MOV_SI_BX
    MOV_SI_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,4
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV SI,BX
    MOV_SI_BX:
    CMP secondOperandIndex,2
    JE MOV_SI_BX1
    JMP MOV_SI_CX
    MOV_SI_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,4
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV SI,CX
    MOV_SI_CX:
    CMP secondOperandIndex,3
    JE MOV_SI_CX1
    JMP MOV_SI_DX
    MOV_SI_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,4
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV SI,DX
    MOV_SI_DX:
    CMP secondOperandIndex,4
    JE MOV_SI_DX1
    JMP MOV_SI_SI
    MOV_SI_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,4
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV SI,SI
    MOV_SI_SI:
    CMP secondOperandIndex,5
    JE MOV_SI_SI1
    JMP MOV_SI_DI
    MOV_SI_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV SI,DI
    MOV_SI_DI:
    CMP secondOperandIndex,6
    JE MOV_SI_DI1
    JMP MOV_SI_SP
    MOV_SI_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,4
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV SI,SP
    MOV_SI_SP:
    CMP secondOperandIndex,7
    JE MOV_SI_SP1
    JMP MOV_SI_BP
    MOV_SI_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,4
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV SI,BP
    MOV_SI_BP:
    CMP secondOperandIndex,7
    JE MOV_SI_BP1
    JMP MOV_SI_NUM
    MOV_SI_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,4
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV SI,NUM
    MOV_SI_NUM:
    CMP secondOperandIndex,17
    JE MOV_SI_NUM1
    JMP NOTAVAILIDCOMMAND
    MOV_SI_NUM1:
    MOV addedValueToSIDest,4
    CALL MOVAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;MOV DI,Source with no bracket
    MOV_DI1:
    CMP firstOperandIndex,6
    JE MOV_DI2
    JMP MOV_SP1
    MOV_DI2:
    
    ;MOV DI,AX
    MOV_DI_AX:
    CMP secondOperandIndex,1
    JE MOV_DI_AX1
    JMP MOV_DI_BX
    MOV_DI_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,5
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV DI,BX
    MOV_DI_BX:
    CMP secondOperandIndex,2
    JE MOV_DI_BX1
    JMP MOV_DI_CX
    MOV_DI_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,5
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV DI,CX
    MOV_DI_CX:
    CMP secondOperandIndex,3
    JE MOV_DI_CX1
    JMP MOV_DI_DX
    MOV_DI_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,5
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV DI,DX
    MOV_DI_DX:
    CMP secondOperandIndex,4
    JE MOV_DI_DX1
    JMP MOV_DI_SI
    MOV_DI_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,5
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV DI,SI
    MOV_DI_SI:
    CMP secondOperandIndex,5
    JE MOV_DI_SI1
    JMP MOV_DI_DI
    MOV_DI_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV DI,DI
    MOV_DI_DI:
    CMP secondOperandIndex,6
    JE MOV_DI_DI1
    JMP MOV_DI_SP
    MOV_DI_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,5
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV DI,SP
    MOV_DI_SP:
    CMP secondOperandIndex,7
    JE MOV_DI_SP1
    JMP MOV_DI_BP
    MOV_DI_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,5
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV DI,BP
    MOV_DI_BP:
    CMP secondOperandIndex,7
    JE MOV_DI_BP1
    JMP MOV_DI_NUM
    MOV_DI_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,5
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV DI,NUM
    MOV_DI_NUM:
    CMP secondOperandIndex,17
    JE MOV_DI_NUM1
    JMP NOTAVAILIDCOMMAND
    MOV_DI_NUM1:
    MOV addedValueToSIDest,5
    CALL MOVAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;MOV SP,Source with no bracket
    MOV_SP1:
    CMP firstOperandIndex,7
    JE MOV_SP2
    JMP MOV_BP1
    MOV_SP2:
    
    ;MOV SP,AX
    MOV_SP_AX:
    CMP secondOperandIndex,1
    JE MOV_SP_AX1
    JMP MOV_SP_BX
    MOV_SP_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,6
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV SP,BX
    MOV_SP_BX:
    CMP secondOperandIndex,2
    JE MOV_SP_BX1
    JMP MOV_SP_CX
    MOV_SP_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,6
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV SP,CX
    MOV_SP_CX:
    CMP secondOperandIndex,3
    JE MOV_SP_CX1
    JMP MOV_SP_DX
    MOV_SP_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,6
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV SP,DX
    MOV_SP_DX:
    CMP secondOperandIndex,4
    JE MOV_SP_DX1
    JMP MOV_SP_SI
    MOV_SP_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,6
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV SP,SI
    MOV_SP_SI:
    CMP secondOperandIndex,5
    JE MOV_SP_SI1
    JMP MOV_SP_DI
    MOV_SP_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,6
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV SP,DI
    MOV_SP_DI:
    CMP secondOperandIndex,6
    JE MOV_SP_DI1
    JMP MOV_SP_SP
    MOV_SP_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,6
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV SP,SP
    MOV_SP_SP:
    CMP secondOperandIndex,7
    JE MOV_SP_SP1
    JMP MOV_SP_BP
    MOV_SP_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,6
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV SP,BP
    MOV_SP_BP:
    CMP secondOperandIndex,7
    JE MOV_SP_BP1
    JMP MOV_SP_NUM
    MOV_SP_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,6
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV SP,NUM
    MOV_SP_NUM:
    CMP secondOperandIndex,17
    JE MOV_SP_NUM1
    JMP NOTAVAILIDCOMMAND
    MOV_SP_NUM1:
    MOV addedValueToSIDest,6
    CALL MOVAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;MOV BP,Source with no bracket
    MOV_BP1:
    CMP firstOperandIndex,8
    JE MOV_BP2
    JMP MOV_AH1
    MOV_BP2:
    
    ;MOV BP,AX
    MOV_BP_AX:
    CMP secondOperandIndex,1
    JE MOV_BP_AX1
    JMP MOV_BP_BX
    MOV_BP_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,7
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV BP,BX
    MOV_BP_BX:
    CMP secondOperandIndex,2
    JE MOV_BP_BX1
    JMP MOV_BP_CX
    MOV_BP_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,7
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV BP,CX
    MOV_BP_CX:
    CMP secondOperandIndex,3
    JE MOV_BP_CX1
    JMP MOV_BP_DX
    MOV_BP_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,7
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV BP,DX
    MOV_BP_DX:
    CMP secondOperandIndex,4
    JE MOV_BP_DX1
    JMP MOV_BP_SI
    MOV_BP_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,7
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV BP,SI
    MOV_BP_SI:
    CMP secondOperandIndex,5
    JE MOV_BP_SI1
    JMP MOV_BP_DI
    MOV_BP_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,7
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV BP,DI
    MOV_BP_DI:
    CMP secondOperandIndex,6
    JE MOV_BP_DI1
    JMP MOV_BP_SP
    MOV_BP_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,7
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV BP,SP
    MOV_BP_SP:
    CMP secondOperandIndex,7
    JE MOV_BP_SP1
    JMP MOV_BP_BP
    MOV_BP_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,7
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV BP,BP
    MOV_BP_BP:
    CMP secondOperandIndex,7
    JE MOV_BP_BP1
    JMP MOV_BP_NUM
    MOV_BP_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,7
    CALL MOVAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;MOV BP,NUM
    MOV_BP_NUM:
    CMP secondOperandIndex,17
    JE MOV_BP_NUM1
    JMP NOTAVAILIDCOMMAND
    MOV_BP_NUM1:
    MOV addedValueToSIDest,7
    CALL MOVAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;MOV AH,Source with no bracket
    MOV_AH1:
    CMP firstOperandIndex,9
    JE MOV_AH2
    JMP MOV_AL1
    MOV_AH2:
    
    ;MOV AH,AH
    MOV_AH_AH:
    CMP secondOperandIndex,9
    JE MOV_AH_AH1
    JMP MOV_AH_BH
    MOV_AH_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,1
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV AH,BH
    MOV_AH_BH:
    CMP secondOperandIndex,11
    JE MOV_AH_BH1
    JMP MOV_AH_CH
    MOV_AH_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,1
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV AH,CH
    MOV_AH_CH:
    CMP secondOperandIndex,13
    JE MOV_AH_CH1
    JMP MOV_AH_DH
    MOV_AH_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,1
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV AH,DH
    MOV_AH_DH:
    CMP secondOperandIndex,15
    JE MOV_AH_DH1
    JMP MOV_AH_AL
    MOV_AH_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,1
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV AH,AL
    MOV_AH_AL:
    CMP secondOperandIndex,10
    JE MOV_AH_AL1
    JMP MOV_AH_BL
    MOV_AH_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,1
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV AH,BL
    MOV_AH_BL:
    CMP secondOperandIndex,12
    JE MOV_AH_BL1
    JMP MOV_AH_CL
    MOV_AH_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,1
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV AH,CL
    MOV_AH_CL:
    CMP secondOperandIndex,14
    JE MOV_AH_CL1
    JMP MOV_AH_DL
    MOV_AH_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV AH,DL
    MOV_AH_DL:
    CMP secondOperandIndex,16
    JE MOV_AH_DL1
    JMP MOV_AH_NUM
    MOV_AH_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,1
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV AH,NUM
    MOV_AH_NUM:
    CMP secondOperandIndex,17
    JE MOV_AH_NUM1
    JMP NOTAVAILIDCOMMAND
    MOV_AH_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,1
    CALL MOVAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;MOV AL,Source with no bracket
    MOV_AL1:
    CMP firstOperandIndex,10
    JE MOV_AL2
    JMP MOV_BH1
    MOV_AL2:
    
    ;MOV AL,AH
    MOV_AL_AH:
    CMP secondOperandIndex,9
    JE MOV_AL_AH1
    JMP MOV_AL_BH
    MOV_AL_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,0
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV AL,BH
    MOV_AL_BH:
    CMP secondOperandIndex,11
    JE MOV_AL_BH1
    JMP MOV_AL_CH
    MOV_AL_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,0
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV AL,CH
    MOV_AL_CH:
    CMP secondOperandIndex,13
    JE MOV_AL_CH1
    JMP MOV_AL_DH
    MOV_AL_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,0
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV AL,DH
    MOV_AL_DH:
    CMP secondOperandIndex,15
    JE MOV_AL_DH1
    JMP MOV_AL_AL
    MOV_AL_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,0
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV AL,AL
    MOV_AL_AL:
    CMP secondOperandIndex,10
    JE MOV_AL_AL1
    JMP MOV_AL_BL
    MOV_AL_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,0
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV AL,BL
    MOV_AL_BL:
    CMP secondOperandIndex,12
    JE MOV_AL_BL1
    JMP MOV_AL_CL
    MOV_AL_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,0
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV AL,CL
    MOV_AL_CL:
    CMP secondOperandIndex,14
    JE MOV_AL_CL1
    JMP MOV_AL_DL
    MOV_AL_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,0
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV AL,DL
    MOV_AL_DL:
    CMP secondOperandIndex,16
    JE MOV_AL_DL1
    JMP MOV_AL_NUM
    MOV_AL_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,0
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV AL,NUM
    MOV_AL_NUM:
    CMP secondOperandIndex,17
    JE MOV_AL_NUM1
    JMP NOTAVAILIDCOMMAND
    MOV_AL_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,0
    CALL MOVAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;MOV BH,Source with no bracket
    MOV_BH1:
    CMP firstOperandIndex,11
    JE MOV_BH2
    JMP MOV_BL1
    MOV_BH2:
    
    ;MOV BH,AH
    MOV_BH_AH:
    CMP secondOperandIndex,9
    JE MOV_BH_AH1
    JMP MOV_BH_BH
    MOV_BH_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,3
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV BH,BH
    MOV_BH_BH:
    CMP secondOperandIndex,11
    JE MOV_BH_BH1
    JMP MOV_BH_CH
    MOV_BH_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,3
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV BH,CH
    MOV_BH_CH:
    CMP secondOperandIndex,13
    JE MOV_BH_CH1
    JMP MOV_BH_DH
    MOV_BH_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,3
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV BH,DH
    MOV_BH_DH:
    CMP secondOperandIndex,15
    JE MOV_BH_DH1
    JMP MOV_BH_AL
    MOV_BH_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,3
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV BH,AL
    MOV_BH_AL:
    CMP secondOperandIndex,10
    JE MOV_BH_AL1
    JMP MOV_BH_BL
    MOV_BH_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,3
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV BH,BL
    MOV_BH_BL:
    CMP secondOperandIndex,12
    JE MOV_BH_BL1
    JMP MOV_BH_CL
    MOV_BH_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,3
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV BH,CL
    MOV_BH_CL:
    CMP secondOperandIndex,14
    JE MOV_BH_CL1
    JMP MOV_BH_DL
    MOV_BH_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,3
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV BH,DL
    MOV_BH_DL:
    CMP secondOperandIndex,16
    JE MOV_BH_DL1
    JMP MOV_BH_NUM
    MOV_BH_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,3
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV BH,NUM
    MOV_BH_NUM:
    CMP secondOperandIndex,17
    JE MOV_BH_NUM1
    JMP NOTAVAILIDCOMMAND
    MOV_BH_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,3
    CALL MOVAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;MOV BL,Source with no bracket
    MOV_BL1:
    CMP firstOperandIndex,12
    JE MOV_BL2
    JMP MOV_CH1
    MOV_BL2:
    
    ;MOV BL,AH
    MOV_BL_AH:
    CMP secondOperandIndex,9
    JE MOV_BL_AH1
    JMP MOV_BL_BH
    MOV_BL_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,2
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV BL,BH
    MOV_BL_BH:
    CMP secondOperandIndex,11
    JE MOV_BL_BH1
    JMP MOV_BL_CH
    MOV_BL_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,2
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV BL,CH
    MOV_BL_CH:
    CMP secondOperandIndex,13
    JE MOV_BL_CH1
    JMP MOV_BL_DH
    MOV_BL_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,2
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV BL,DH
    MOV_BL_DH:
    CMP secondOperandIndex,15
    JE MOV_BL_DH1
    JMP MOV_BL_AL
    MOV_BL_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,2
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV BL,AL
    MOV_BL_AL:
    CMP secondOperandIndex,10
    JE MOV_BL_AL1
    JMP MOV_BL_BL
    MOV_BL_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,2
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV BL,BL
    MOV_BL_BL:
    CMP secondOperandIndex,12
    JE MOV_BL_BL1
    JMP MOV_BL_CL
    MOV_BL_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,2
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV BL,CL
    MOV_BL_CL:
    CMP secondOperandIndex,14
    JE MOV_BL_CL1
    JMP MOV_BL_DL
    MOV_BL_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,2
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV BL,DL
    MOV_BL_DL:
    CMP secondOperandIndex,16
    JE MOV_BL_DL1
    JMP MOV_BL_NUM
    MOV_BL_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,2
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV BL,NUM
    MOV_BL_NUM:
    CMP secondOperandIndex,17
    JE MOV_BL_NUM1
    JMP NOTAVAILIDCOMMAND
    MOV_BL_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,2
    CALL MOVAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;MOV CH,Source with no bracket
    MOV_CH1:
    CMP firstOperandIndex,13
    JE MOV_CH2
    JMP MOV_CL1
    MOV_CH2:
    
    ;MOV CH,AH
    MOV_CH_AH:
    CMP secondOperandIndex,9
    JE MOV_CH_AH1
    JMP MOV_CH_BH
    MOV_CH_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,5
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV CH,BH
    MOV_CH_BH:
    CMP secondOperandIndex,11
    JE MOV_CH_BH1
    JMP MOV_CH_CH
    MOV_CH_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,5
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV CH,CH
    MOV_CH_CH:
    CMP secondOperandIndex,13
    JE MOV_CH_CH1
    JMP MOV_CH_DH
    MOV_CH_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,5
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV CH,DH
    MOV_CH_DH:
    CMP secondOperandIndex,15
    JE MOV_CH_DH1
    JMP MOV_CH_AL
    MOV_CH_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,5
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV CH,AL
    MOV_CH_AL:
    CMP secondOperandIndex,10
    JE MOV_CH_AL1
    JMP MOV_CH_BL
    MOV_CH_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,5
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV CH,BL
    MOV_CH_BL:
    CMP secondOperandIndex,12
    JE MOV_CH_BL1
    JMP MOV_CH_CL
    MOV_CH_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,5
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV CH,CL
    MOV_CH_CL:
    CMP secondOperandIndex,14
    JE MOV_CH_CL1
    JMP MOV_CH_DL
    MOV_CH_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV CH,DL
    MOV_CH_DL:
    CMP secondOperandIndex,16
    JE MOV_CH_DL1
    JMP MOV_CH_NUM
    MOV_CH_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,5
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV CH,NUM
    MOV_CH_NUM:
    CMP secondOperandIndex,17
    JE MOV_CH_NUM1
    JMP NOTAVAILIDCOMMAND
    MOV_CH_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,5
    CALL MOVAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;MOV CL,Source with no bracket
    MOV_CL1:
    CMP firstOperandIndex,14
    JE MOV_CL2
    JMP MOV_DH1
    MOV_CL2:
    
    ;MOV CL,AH
    MOV_CL_AH:
    CMP secondOperandIndex,9
    JE MOV_CL_AH1
    JMP MOV_CL_BH
    MOV_CL_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,4
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV CL,BH
    MOV_CL_BH:
    CMP secondOperandIndex,11
    JE MOV_CL_BH1
    JMP MOV_CL_CH
    MOV_CL_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,4
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV CL,CH
    MOV_CL_CH:
    CMP secondOperandIndex,13
    JE MOV_CL_CH1
    JMP MOV_CL_DH
    MOV_CL_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,4
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV CL,DH
    MOV_CL_DH:
    CMP secondOperandIndex,15
    JE MOV_CL_DH1
    JMP MOV_CL_AL
    MOV_CL_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,4
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV CL,AL
    MOV_CL_AL:
    CMP secondOperandIndex,10
    JE MOV_CL_AL1
    JMP MOV_CL_BL
    MOV_CL_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,4
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV CL,BL
    MOV_CL_BL:
    CMP secondOperandIndex,12
    JE MOV_CL_BL1
    JMP MOV_CL_CL
    MOV_CL_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,4
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV CL,CL
    MOV_CL_CL:
    CMP secondOperandIndex,14
    JE MOV_CL_CL1
    JMP MOV_CL_DL
    MOV_CL_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV CL,DL
    MOV_CL_DL:
    CMP secondOperandIndex,16
    JE MOV_CL_DL1
    JMP MOV_CL_NUM
    MOV_CL_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,4
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV CL,NUM
    MOV_CL_NUM:
    CMP secondOperandIndex,17
    JE MOV_CL_NUM1
    JMP NOTAVAILIDCOMMAND
    MOV_CL_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,4
    CALL MOVAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;MOV DH,Source with no bracket
    MOV_DH1:
    CMP firstOperandIndex,15
    JE MOV_DH2
    JMP MOV_DL1
    MOV_DH2:
    
    ;MOV DH,AH
    MOV_DH_AH:
    CMP secondOperandIndex,9
    JE MOV_DH_AH1
    JMP MOV_DH_BH
    MOV_DH_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,7
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV DH,BH
    MOV_DH_BH:
    CMP secondOperandIndex,11
    JE MOV_DH_BH1
    JMP MOV_DH_CH
    MOV_DH_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,7
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV DH,CH
    MOV_DH_CH:
    CMP secondOperandIndex,13
    JE MOV_DH_CH1
    JMP MOV_DH_DH
    MOV_DH_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,7
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV DH,DH
    MOV_DH_DH:
    CMP secondOperandIndex,15
    JE MOV_DH_DH1
    JMP MOV_DH_AL
    MOV_DH_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,7
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV DH,AL
    MOV_DH_AL:
    CMP secondOperandIndex,10
    JE MOV_DH_AL1
    JMP MOV_DH_BL
    MOV_DH_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,7
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV DH,BL
    MOV_DH_BL:
    CMP secondOperandIndex,12
    JE MOV_DH_BL1
    JMP MOV_DH_CL
    MOV_DH_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,7
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV DH,CL
    MOV_DH_CL:
    CMP secondOperandIndex,14
    JE MOV_DH_CL1
    JMP MOV_DH_DL
    MOV_DH_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,7
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV DH,DL
    MOV_DH_DL:
    CMP secondOperandIndex,16
    JE MOV_DH_DL1
    JMP MOV_DH_NUM
    MOV_DH_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,7
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV DH,NUM
    MOV_DH_NUM:
    CMP secondOperandIndex,17
    JE MOV_DH_NUM1
    JMP NOTAVAILIDCOMMAND
    MOV_DH_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,7
    CALL MOVAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;MOV DL,Source with no bracket
    MOV_DL1:
    CMP firstOperandIndex,15
    JE MOV_DL2
    JMP NOTAVAILIDCOMMAND
    MOV_DL2:
    
    ;MOV DL,AH
    MOV_DL_AH:
    CMP secondOperandIndex,9
    JE MOV_DL_AH1
    JMP MOV_DL_BH
    MOV_DL_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,6
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV DL,BH
    MOV_DL_BH:
    CMP secondOperandIndex,11
    JE MOV_DL_BH1
    JMP MOV_DL_CH
    MOV_DL_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,6
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV DL,CH
    MOV_DL_CH:
    CMP secondOperandIndex,13
    JE MOV_DL_CH1
    JMP MOV_DL_DH
    MOV_DL_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,6
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV DL,DH
    MOV_DL_DH:
    CMP secondOperandIndex,15
    JE MOV_DL_DH1
    JMP MOV_DL_AL
    MOV_DL_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,6
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV DL,AL
    MOV_DL_AL:
    CMP secondOperandIndex,10
    JE MOV_DL_AL1
    JMP MOV_DL_BL
    MOV_DL_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,6
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV DL,BL
    MOV_DL_BL:
    CMP secondOperandIndex,12
    JE MOV_DL_BL1
    JMP MOV_DL_CL
    MOV_DL_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,6
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV DL,CL
    MOV_DL_CL:
    CMP secondOperandIndex,14
    JE MOV_DL_CL1
    JMP MOV_DL_DL
    MOV_DL_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,6
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV DL,DL
    MOV_DL_DL:
    CMP secondOperandIndex,16
    JE MOV_DL_DL1
    JMP MOV_DL_NUM
    MOV_DL_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,6
    CALL MOVAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;MOV DL,NUM
    MOV_DL_NUM:
    CMP secondOperandIndex,17
    JE MOV_DL_NUM1
    JMP NOTAVAILIDCOMMAND
    MOV_DL_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,6
    CALL MOVAByteRegWithNUM
    JMP ENDEXECUTE
;------------------------------------------------------------------------------------------------   
    ;this is XOR command
    XORCOMMAND:
    CMP commandIndex,8
    JE XORCOMMAND1
    JMP ANDCOMMAND
    XORCOMMAND1:
    
        ;the two operand mustn't have brackets at the same time
    CMP isSecondOpBracket,1
    JE XORCOMMAND11
    JMP XORCOMMAND12
    XORCOMMAND11:
    CMP isFirstOpBracket,1
    JNE XORCOMMAND12
    JMP NOTAVAILIDCOMMAND
    
    ;Begin executing commands
    XORCOMMAND12:
    ;2nd operand has bracket 
    CMP isSecondOpBracket,1
    JE XORCOMMAND13
    JMP XORCOMMAND14
    XORCOMMAND13:
    
    ;========================
    ;XOR destination with no bracket,[SI]
    XOR_PTR_SI_SOURCE:
    CMP secondOperandIndex,5
    JE XOR_PTR_SI_SOURCE1
    JMP XOR_PTR_DI_SOURCE
    XOR_PTR_SI_SOURCE1:
    
    ;XOR AX,PTR_SI
    XOR_AX_PTR_SI:
    CMP firstOperandIndex,1
    JE XOR_AX_PTR_SI1
    JMP XOR_BX_PTR_SI
    XOR_AX_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,0
    CALL XORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR BX,PTR_SI
    XOR_BX_PTR_SI:
    CMP firstOperandIndex,2
    JE XOR_BX_PTR_SI1
    JMP XOR_CX_PTR_SI
    XOR_BX_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL XORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR CX,PTR_SI
    XOR_CX_PTR_SI:
    CMP firstOperandIndex,3
    JE XOR_CX_PTR_SI1
    JMP XOR_DX_PTR_SI
    XOR_CX_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,2
    CALL XORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR DX,PTR_SI
    XOR_DX_PTR_SI:
    CMP firstOperandIndex,4
    JE XOR_DX_PTR_SI1
    JMP XOR_SI_PTR_SI
    XOR_DX_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,3
    CALL XORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR SI,PTR_SI
    XOR_SI_PTR_SI:
    CMP firstOperandIndex,5
    JE XOR_SI_PTR_SI1
    JMP XOR_DI_PTR_SI
    XOR_SI_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL XORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR DI,PTR_SI
    XOR_DI_PTR_SI:
    CMP firstOperandIndex,6
    JE XOR_DI_PTR_SI1
    JMP XOR_SP_PTR_SI
    XOR_DI_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL XORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR SP,PTR_SI
    XOR_SP_PTR_SI:
    CMP firstOperandIndex,7
    JE XOR_SP_PTR_SI1
    JMP XOR_BP_PTR_SI
    XOR_SP_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,6
    CALL XORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR BP,PTR_SI
    XOR_BP_PTR_SI:
    CMP firstOperandIndex,7
    JE XOR_BP_PTR_SI1
    JMP XOR_AH_PTR_SI
    XOR_BP_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,7
    CALL XORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR AH,PTR_SI
    XOR_AH_PTR_SI:
    CMP firstOperandIndex,9
    JE XOR_AH_PTR_SI1
    JMP XOR_BH_PTR_SI
    XOR_AH_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL XORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR BH,PTR_SI
    XOR_BH_PTR_SI:
    CMP firstOperandIndex,11
    JE XOR_BH_PTR_SI1
    JMP XOR_CH_PTR_SI
    XOR_BH_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,3
    CALL XORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR CH,PTR_SI
    XOR_CH_PTR_SI:
    CMP firstOperandIndex,13
    JE XOR_CH_PTR_SI1
    JMP XOR_DH_PTR_SI
    XOR_CH_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL XORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR DH,PTR_SI
    XOR_DH_PTR_SI:
    CMP firstOperandIndex,15
    JE XOR_DH_PTR_SI1
    JMP XOR_AL_PTR_SI
    XOR_DH_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,7
    CALL XORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR AL,PTR_SI
    XOR_AL_PTR_SI:
    CMP firstOperandIndex,10
    JE XOR_AL_PTR_SI1
    JMP XOR_BL_PTR_SI
    XOR_AL_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,0
    CALL XORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR BL,PTR_SI
    XOR_BL_PTR_SI:
    CMP firstOperandIndex,12
    JE XOR_BL_PTR_SI1
    JMP XOR_CL_PTR_SI
    XOR_BL_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,2
    CALL XORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR CL,PTR_SI
    XOR_CL_PTR_SI:
    CMP firstOperandIndex,14
    JE XOR_CL_PTR_SI1
    JMP XOR_DL_PTR_SI
    XOR_CL_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL XORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR DL,PTR_SI
    XOR_DL_PTR_SI:
    CMP firstOperandIndex,16
    JE XOR_DL_PTR_SI1
    JMP NOTAVAILIDCOMMAND
    XOR_DL_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,6
    CALL XORAByteRegWithPointer
    JMP ENDEXECUTE
 
    ;========================
    ;XOR destination with no bracket,[DI]
    XOR_PTR_DI_SOURCE:
    CMP secondOperandIndex,6
    JE XOR_PTR_DI_SOURCE1
    JMP XOR_PTR_BX_SOURCE
    XOR_PTR_DI_SOURCE1:
    
    ;XOR AX,PTR_DI
    XOR_AX_PTR_DI:
    CMP firstOperandIndex,1
    JE XOR_AX_PTR_DI1
    JMP XOR_BX_PTR_DI
    XOR_AX_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,0
    CALL XORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR BX,PTR_DI
    XOR_BX_PTR_DI:
    CMP firstOperandIndex,2
    JE XOR_BX_PTR_DI1
    JMP XOR_CX_PTR_DI
    XOR_BX_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,1
    CALL XORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR CX,PTR_DI
    XOR_CX_PTR_DI:
    CMP firstOperandIndex,3
    JE XOR_CX_PTR_DI1
    JMP XOR_DX_PTR_DI
    XOR_CX_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,2
    CALL XORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR DX,PTR_DI
    XOR_DX_PTR_DI:
    CMP firstOperandIndex,4
    JE XOR_DX_PTR_DI1
    JMP XOR_SI_PTR_DI
    XOR_DX_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,3
    CALL XORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR SI,PTR_DI
    XOR_SI_PTR_DI:
    CMP firstOperandIndex,5
    JE XOR_SI_PTR_DI1
    JMP XOR_DI_PTR_DI
    XOR_SI_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,4
    CALL XORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR DI,PTR_DI
    XOR_DI_PTR_DI:
    CMP firstOperandIndex,6
    JE XOR_DI_PTR_DI1
    JMP XOR_SP_PTR_DI
    XOR_DI_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,5
    CALL XORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR SP,PTR_DI
    XOR_SP_PTR_DI:
    CMP firstOperandIndex,7
    JE XOR_SP_PTR_DI1
    JMP XOR_BP_PTR_DI
    XOR_SP_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,6
    CALL XORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR BP,PTR_DI
    XOR_BP_PTR_DI:
    CMP firstOperandIndex,7
    JE XOR_BP_PTR_DI1
    JMP XOR_AH_PTR_DI
    XOR_BP_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,7
    CALL XORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR AH,PTR_DI
    XOR_AH_PTR_DI:
    CMP firstOperandIndex,9
    JE XOR_AH_PTR_DI1
    JMP XOR_BH_PTR_DI
    XOR_AH_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,1
    CALL XORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR BH,PTR_DI
    XOR_BH_PTR_DI:
    CMP firstOperandIndex,11
    JE XOR_BH_PTR_DI1
    JMP XOR_CH_PTR_DI
    XOR_BH_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,3
    CALL XORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR CH,PTR_DI
    XOR_CH_PTR_DI:
    CMP firstOperandIndex,13
    JE XOR_CH_PTR_DI1
    JMP XOR_DH_PTR_DI
    XOR_CH_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,5
    CALL XORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR DH,PTR_DI
    XOR_DH_PTR_DI:
    CMP firstOperandIndex,15
    JE XOR_DH_PTR_DI1
    JMP XOR_AL_PTR_DI
    XOR_DH_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,7
    CALL XORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR AL,PTR_DI
    XOR_AL_PTR_DI:
    CMP firstOperandIndex,10
    JE XOR_AL_PTR_DI1
    JMP XOR_BL_PTR_DI
    XOR_AL_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,0
    CALL XORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR BL,PTR_DI
    XOR_BL_PTR_DI:
    CMP firstOperandIndex,12
    JE XOR_BL_PTR_DI1
    JMP XOR_CL_PTR_DI
    XOR_BL_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,2
    CALL XORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR CL,PTR_DI
    XOR_CL_PTR_DI:
    CMP firstOperandIndex,14
    JE XOR_CL_PTR_DI1
    JMP XOR_DL_PTR_DI
    XOR_CL_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,4
    CALL XORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR DL,PTR_DI
    XOR_DL_PTR_DI:
    CMP firstOperandIndex,16
    JE XOR_DL_PTR_DI1
    JMP NOTAVAILIDCOMMAND
    XOR_DL_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,6
    CALL XORAByteRegWithPointer
    JMP ENDEXECUTE

    ;========================
    ;XOR destination with no bracket,[BX]
    XOR_PTR_BX_SOURCE:
    CMP secondOperandIndex,2
    JE XOR_PTR_BX_SOURCE1
    JMP XOR_PTR_NUM_SOURCE
    XOR_PTR_BX_SOURCE1:
    
    ;XOR AX,PTR_BX
    XOR_AX_PTR_BX:
    CMP firstOperandIndex,1
    JE XOR_AX_PTR_BX1
    JMP XOR_BX_PTR_BX
    XOR_AX_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,0
    CALL XORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR BX,PTR_BX
    XOR_BX_PTR_BX:
    CMP firstOperandIndex,2
    JE XOR_BX_PTR_BX1
    JMP XOR_CX_PTR_BX
    XOR_BX_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL XORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR CX,PTR_BX
    XOR_CX_PTR_BX:
    CMP firstOperandIndex,3
    JE XOR_CX_PTR_BX1
    JMP XOR_DX_PTR_BX
    XOR_CX_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,2
    CALL XORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR DX,PTR_BX
    XOR_DX_PTR_BX:
    CMP firstOperandIndex,4
    JE XOR_DX_PTR_BX1
    JMP XOR_SI_PTR_BX
    XOR_DX_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,3
    CALL XORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR SI,PTR_BX
    XOR_SI_PTR_BX:
    CMP firstOperandIndex,5
    JE XOR_SI_PTR_BX1
    JMP XOR_DI_PTR_BX
    XOR_SI_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL XORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR DI,PTR_BX
    XOR_DI_PTR_BX:
    CMP firstOperandIndex,6
    JE XOR_DI_PTR_BX1
    JMP XOR_SP_PTR_BX
    XOR_DI_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL XORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR SP,PTR_BX
    XOR_SP_PTR_BX:
    CMP firstOperandIndex,7
    JE XOR_SP_PTR_BX1
    JMP XOR_BP_PTR_BX
    XOR_SP_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,6
    CALL XORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR BP,PTR_BX
    XOR_BP_PTR_BX:
    CMP firstOperandIndex,7
    JE XOR_BP_PTR_BX1
    JMP XOR_AH_PTR_BX
    XOR_BP_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,7
    CALL XORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR AH,PTR_BX
    XOR_AH_PTR_BX:
    CMP firstOperandIndex,9
    JE XOR_AH_PTR_BX1
    JMP XOR_BH_PTR_BX
    XOR_AH_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL XORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR BH,PTR_BX
    XOR_BH_PTR_BX:
    CMP firstOperandIndex,11
    JE XOR_BH_PTR_BX1
    JMP XOR_CH_PTR_BX
    XOR_BH_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,3
    CALL XORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR CH,PTR_BX
    XOR_CH_PTR_BX:
    CMP firstOperandIndex,13
    JE XOR_CH_PTR_BX1
    JMP XOR_DH_PTR_BX
    XOR_CH_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL XORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR DH,PTR_BX
    XOR_DH_PTR_BX:
    CMP firstOperandIndex,15
    JE XOR_DH_PTR_BX1
    JMP XOR_AL_PTR_BX
    XOR_DH_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,7
    CALL XORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR AL,PTR_BX
    XOR_AL_PTR_BX:
    CMP firstOperandIndex,10
    JE XOR_AL_PTR_BX1
    JMP XOR_BL_PTR_BX
    XOR_AL_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,0
    CALL XORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR BL,PTR_BX
    XOR_BL_PTR_BX:
    CMP firstOperandIndex,12
    JE XOR_BL_PTR_BX1
    JMP XOR_CL_PTR_BX
    XOR_BL_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,2
    CALL XORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR CL,PTR_BX
    XOR_CL_PTR_BX:
    CMP firstOperandIndex,14
    JE XOR_CL_PTR_BX1
    JMP XOR_DL_PTR_BX
    XOR_CL_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL XORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;XOR DL,PTR_BX
    XOR_DL_PTR_BX:
    CMP firstOperandIndex,16
    JE XOR_DL_PTR_BX1
    JMP NOTAVAILIDCOMMAND
    XOR_DL_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,6
    CALL XORAByteRegWithPointer
    JMP ENDEXECUTE
    
    
    XOR_PTR_NUM_SOURCE:
    ;========================
    ;XOR destination with no bracket,[NUM]
    XOR_PTR_NUM_SOURCE:
    CMP secondOperandIndex,17
    JE XOR_PTR_NUM_SOURCE1
    JMP NOTAVAILIDCOMMAND
    XOR_PTR_NUM_SOURCE1:
    
    ;XOR AX,PTR_NUM
    XOR_AX_PTR_NUM:
    CMP firstOperandIndex,1
    JE XOR_AX_PTR_NUM1
    JMP XOR_BX_PTR_NUM
    XOR_AX_PTR_NUM1:
    MOV addedValueToSIDest,0
    CALL XORAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;XOR BX,PTR_NUM
    XOR_BX_PTR_NUM:
    CMP firstOperandIndex,2
    JE XOR_BX_PTR_NUM1
    JMP XOR_CX_PTR_NUM
    XOR_BX_PTR_NUM1:
    MOV addedValueToSIDest,1
    CALL XORAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;XOR CX,PTR_NUM
    XOR_CX_PTR_NUM:
    CMP firstOperandIndex,3
    JE XOR_CX_PTR_NUM1
    JMP XOR_DX_PTR_NUM
    XOR_CX_PTR_NUM1:
    MOV addedValueToSIDest,2
    CALL XORAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;XOR DX,PTR_NUM
    XOR_DX_PTR_NUM:
    CMP firstOperandIndex,4
    JE XOR_DX_PTR_NUM1
    JMP XOR_SI_PTR_NUM
    XOR_DX_PTR_NUM1:
    MOV addedValueToSIDest,3
    CALL XORAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;XOR SI,PTR_NUM
    XOR_SI_PTR_NUM:
    CMP firstOperandIndex,5
    JE XOR_SI_PTR_NUM1
    JMP XOR_DI_PTR_NUM
    XOR_SI_PTR_NUM1:
    MOV addedValueToSIDest,4
    CALL XORAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;XOR DI,PTR_NUM
    XOR_DI_PTR_NUM:
    CMP firstOperandIndex,6
    JE XOR_DI_PTR_NUM1
    JMP XOR_SP_PTR_NUM
    XOR_DI_PTR_NUM1:
    MOV addedValueToSIDest,5
    CALL XORAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;XOR SP,PTR_NUM
    XOR_SP_PTR_NUM:
    CMP firstOperandIndex,7
    JE XOR_SP_PTR_NUM1
    JMP XOR_BP_PTR_NUM
    XOR_SP_PTR_NUM1:
    MOV addedValueToSIDest,6
    CALL XORAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;XOR BP,PTR_NUM
    XOR_BP_PTR_NUM:
    CMP firstOperandIndex,7
    JE XOR_BP_PTR_NUM1
    JMP XOR_AH_PTR_NUM
    XOR_BP_PTR_NUM1:
    MOV addedValueToSIDest,7
    CALL XORAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;XOR AH,PTR_NUM
    XOR_AH_PTR_NUM:
    CMP firstOperandIndex,9
    JE XOR_AH_PTR_NUM1
    JMP XOR_BH_PTR_NUM
    XOR_AH_PTR_NUM1:
    MOV addedValueToSIDest,1
    CALL XORAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;XOR BH,PTR_NUM
    XOR_BH_PTR_NUM:
    CMP firstOperandIndex,11
    JE XOR_BH_PTR_NUM1
    JMP XOR_CH_PTR_NUM
    XOR_BH_PTR_NUM1:
    MOV addedValueToSIDest,3
    CALL XORAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;XOR CH,PTR_NUM
    XOR_CH_PTR_NUM:
    CMP firstOperandIndex,13
    JE XOR_CH_PTR_NUM1
    JMP XOR_DH_PTR_NUM
    XOR_CH_PTR_NUM1:
    MOV addedValueToSIDest,5
    CALL XORAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;XOR DH,PTR_NUM
    XOR_DH_PTR_NUM:
    CMP firstOperandIndex,15
    JE XOR_DH_PTR_NUM1
    JMP XOR_AL_PTR_NUM
    XOR_DH_PTR_NUM1:
    MOV addedValueToSIDest,7
    CALL XORAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;XOR AL,PTR_NUM
    XOR_AL_PTR_NUM:
    CMP firstOperandIndex,10
    JE XOR_AL_PTR_NUM1
    JMP XOR_BL_PTR_NUM
    XOR_AL_PTR_NUM1:
    MOV addedValueToSIDest,0
    CALL XORAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;XOR BL,PTR_NUM
    XOR_BL_PTR_NUM:
    CMP firstOperandIndex,12
    JE XOR_BL_PTR_NUM1
    JMP XOR_CL_PTR_NUM
    XOR_BL_PTR_NUM1:
    MOV addedValueToSIDest,2
    CALL XORAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;XOR CL,PTR_NUM
    XOR_CL_PTR_NUM:
    CMP firstOperandIndex,14
    JE XOR_CL_PTR_NUM1
    JMP XOR_DL_PTR_NUM
    XOR_CL_PTR_NUM1:
    MOV addedValueToSIDest,4
    CALL XORAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;XOR DL,PTR_NUM
    XOR_DL_PTR_NUM:
    CMP firstOperandIndex,16
    JE XOR_DL_PTR_NUM1
    JMP NOTAVAILIDCOMMAND
    XOR_DL_PTR_NUM1:
    MOV addedValueToSIDest,6
    CALL XORAByteRegWithMemory
    JMP ENDEXECUTE
    
    
    XORCOMMAND14:
    ;1nd operand has bracket 
    CMP isFirstOpBracket,1
    JE XORCOMMAND15
    JMP XORCOMMAND16
    XORCOMMAND15:
    
    ;========================
    ;XOR [SI],Source with no bracket
    XOR_PTR_SI_DEST:
    CMP firstOperandIndex,5
    JE XOR_PTR_SI_DEST1
    JMP XOR_PTR_DI_DEST
    XOR_PTR_SI_DEST1:
    
    ;XOR PTR_SI,AX
    XOR_PTR_SI_AX:
    CMP secondOperandIndex,1
    JE XOR_PTR_SI_AX1
    JMP XOR_PTR_SI_BX
    XOR_PTR_SI_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,4
    CALL XORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR PTR_SI,BX
    XOR_PTR_SI_BX:
    CMP secondOperandIndex,2
    JE XOR_PTR_SI_BX1
    JMP XOR_PTR_SI_CX
    XOR_PTR_SI_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,4
    CALL XORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR PTR_SI,CX
    XOR_PTR_SI_CX:
    CMP secondOperandIndex,3
    JE XOR_PTR_SI_CX1
    JMP XOR_PTR_SI_DX
    XOR_PTR_SI_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,4
    CALL XORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR PTR_SI,DX
    XOR_PTR_SI_DX:
    CMP secondOperandIndex,4
    JE XOR_PTR_SI_DX1
    JMP XOR_PTR_SI_SI
    XOR_PTR_SI_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,4
    CALL XORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR PTR_SI,SI
    XOR_PTR_SI_SI:
    CMP secondOperandIndex,5
    JE XOR_PTR_SI_SI1
    JMP XOR_PTR_SI_DI
    XOR_PTR_SI_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL XORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR PTR_SI,DI
    XOR_PTR_SI_DI:
    CMP secondOperandIndex,6
    JE XOR_PTR_SI_DI1
    JMP XOR_PTR_SI_SP
    XOR_PTR_SI_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,4
    CALL XORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR PTR_SI,SP
    XOR_PTR_SI_SP:
    CMP secondOperandIndex,7
    JE XOR_PTR_SI_SP1
    JMP XOR_PTR_SI_BP
    XOR_PTR_SI_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,4
    CALL XORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR PTR_SI,BP
    XOR_PTR_SI_BP:
    CMP secondOperandIndex,7
    JE XOR_PTR_SI_BP1
    JMP XOR_PTR_SI_AH
    XOR_PTR_SI_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,4
    CALL XORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR PTR_SI,AH
    XOR_PTR_SI_AH:
    CMP secondOperandIndex,9
    JE XOR_PTR_SI_AH1
    JMP XOR_PTR_SI_BH
    XOR_PTR_SI_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,4
    CALL XORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR PTR_SI,BH
    XOR_PTR_SI_BH:
    CMP secondOperandIndex,11
    JE XOR_PTR_SI_BH1
    JMP XOR_PTR_SI_CH
    XOR_PTR_SI_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,4
    CALL XORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR PTR_SI,CH
    XOR_PTR_SI_CH:
    CMP secondOperandIndex,13
    JE XOR_PTR_SI_CH1
    JMP XOR_PTR_SI_DH
    XOR_PTR_SI_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,4
    CALL XORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR PTR_SI,DH
    XOR_PTR_SI_DH:
    CMP secondOperandIndex,15
    JE XOR_PTR_SI_DH1
    JMP XOR_PTR_SI_AL
    XOR_PTR_SI_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,4
    CALL XORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR PTR_SI,AL
    XOR_PTR_SI_AL:
    CMP secondOperandIndex,10
    JE XOR_PTR_SI_AL1
    JMP XOR_PTR_SI_BL
    XOR_PTR_SI_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,4
    CALL XORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR PTR_SI,BL
    XOR_PTR_SI_BL:
    CMP secondOperandIndex,12
    JE XOR_PTR_SI_BL1
    JMP XOR_PTR_SI_CL
    XOR_PTR_SI_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,4
    CALL XORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR PTR_SI,CL
    XOR_PTR_SI_CL:
    CMP secondOperandIndex,14
    JE XOR_PTR_SI_CL1
    JMP XOR_PTR_SI_DL
    XOR_PTR_SI_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL XORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR PTR_SI,DL
    XOR_PTR_SI_DL:
    CMP secondOperandIndex,16
    JE XOR_PTR_SI_DL1
    JMP XOR_PTR_SI_NUM
    XOR_PTR_SI_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,4
    CALL XORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR PTR_SI,NUM
    XOR_PTR_SI_NUM:
    CMP secondOperandIndex,17
    JE XOR_PTR_SI_NUM1
    JMP NOTAVAILIDCOMMAND
    XOR_PTR_SI_NUM1:
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,4
    CALL XORAPointerRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;XOR [DI],Source with no bracket
    XOR_PTR_DI_DEST:
    CMP firstOperandIndex,6
    JE XOR_PTR_DI_DEST1
    JMP XOR_PTR_BX_DEST
    XOR_PTR_DI_DEST1:
    
    ;XOR PTR_DI,AX
    XOR_PTR_DI_AX:
    CMP secondOperandIndex,1
    JE XOR_PTR_DI_AX1
    JMP XOR_PTR_DI_BX
    XOR_PTR_DI_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,5
    CALL XORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR PTR_DI,BX
    XOR_PTR_DI_BX:
    CMP secondOperandIndex,2
    JE XOR_PTR_DI_BX1
    JMP XOR_PTR_DI_CX
    XOR_PTR_DI_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,5
    CALL XORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR PTR_DI,CX
    XOR_PTR_DI_CX:
    CMP secondOperandIndex,3
    JE XOR_PTR_DI_CX1
    JMP XOR_PTR_DI_DX
    XOR_PTR_DI_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,5
    CALL XORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR PTR_DI,DX
    XOR_PTR_DI_DX:
    CMP secondOperandIndex,4
    JE XOR_PTR_DI_DX1
    JMP XOR_PTR_DI_SI
    XOR_PTR_DI_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,5
    CALL XORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR PTR_DI,SI
    XOR_PTR_DI_SI:
    CMP secondOperandIndex,5
    JE XOR_PTR_DI_SI1
    JMP XOR_PTR_DI_DI
    XOR_PTR_DI_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL XORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR PTR_DI,DI
    XOR_PTR_DI_DI:
    CMP secondOperandIndex,6
    JE XOR_PTR_DI_DI1
    JMP XOR_PTR_DI_SP
    XOR_PTR_DI_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,5
    CALL XORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR PTR_DI,SP
    XOR_PTR_DI_SP:
    CMP secondOperandIndex,7
    JE XOR_PTR_DI_SP1
    JMP XOR_PTR_DI_BP
    XOR_PTR_DI_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,5
    CALL XORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR PTR_DI,BP
    XOR_PTR_DI_BP:
    CMP secondOperandIndex,7
    JE XOR_PTR_DI_BP1
    JMP XOR_PTR_DI_BH
    XOR_PTR_DI_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,5
    CALL XORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR PTR_DI,AH
    XOR_PTR_DI_AH:
    CMP secondOperandIndex,9
    JE XOR_PTR_DI_AH1
    JMP XOR_PTR_DI_BH
    XOR_PTR_DI_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,5
    CALL XORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR PTR_DI,BH
    XOR_PTR_DI_BH:
    CMP secondOperandIndex,11
    JE XOR_PTR_DI_BH1
    JMP XOR_PTR_DI_CH
    XOR_PTR_DI_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,5
    CALL XORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR PTR_DI,CH
    XOR_PTR_DI_CH:
    CMP secondOperandIndex,13
    JE XOR_PTR_DI_CH1
    JMP XOR_PTR_DI_DH
    XOR_PTR_DI_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,5
    CALL XORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR PTR_DI,DH
    XOR_PTR_DI_DH:
    CMP secondOperandIndex,15
    JE XOR_PTR_DI_DH1
    JMP XOR_PTR_DI_AL
    XOR_PTR_DI_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,5
    CALL XORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR PTR_DI,AL
    XOR_PTR_DI_AL:
    CMP secondOperandIndex,10
    JE XOR_PTR_DI_AL1
    JMP XOR_PTR_DI_BL
    XOR_PTR_DI_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,5
    CALL XORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR PTR_DI,BL
    XOR_PTR_DI_BL:
    CMP secondOperandIndex,12
    JE XOR_PTR_DI_BL1
    JMP XOR_PTR_DI_CL
    XOR_PTR_DI_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,5
    CALL XORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR PTR_DI,CL
    XOR_PTR_DI_CL:
    CMP secondOperandIndex,14
    JE XOR_PTR_DI_CL1
    JMP XOR_PTR_DI_DL
    XOR_PTR_DI_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL XORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR PTR_DI,DL
    XOR_PTR_DI_DL:
    CMP secondOperandIndex,16
    JE XOR_PTR_DI_DL1
    JMP XOR_PTR_DI_NUM
    XOR_PTR_DI_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,5
    CALL XORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR PTR_DI,NUM
    XOR_PTR_DI_NUM:
    CMP secondOperandIndex,17
    JE XOR_PTR_DI_NUM1
    JMP NOTAVAILIDCOMMAND
    XOR_PTR_DI_NUM1:
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,5
    CALL XORAPointerRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;XOR [BX],Source with no bracket
    XOR_PTR_BX_DEST:
    CMP firstOperandIndex,2
    JE XOR_PTR_BX_DEST1
    JMP NOTAVAILIDCOMMAND
    XOR_PTR_BX_DEST1:
    
    ;XOR PTR_BX,AX
    XOR_PTR_BX_AX:
    CMP secondOperandIndex,1
    JE XOR_PTR_BX_AX1
    JMP XOR_PTR_BX_BX
    XOR_PTR_BX_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,1
    CALL XORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR PTR_BX,BX
    XOR_PTR_BX_BX:
    CMP secondOperandIndex,2
    JE XOR_PTR_BX_BX1
    JMP XOR_PTR_BX_CX
    XOR_PTR_BX_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,1
    CALL XORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR PTR_BX,CX
    XOR_PTR_BX_CX:
    CMP secondOperandIndex,3
    JE XOR_PTR_BX_CX1
    JMP XOR_PTR_BX_DX
    XOR_PTR_BX_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,1
    CALL XORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR PTR_BX,DX
    XOR_PTR_BX_DX:
    CMP secondOperandIndex,4
    JE XOR_PTR_BX_DX1
    JMP XOR_PTR_BX_SI
    XOR_PTR_BX_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,1
    CALL XORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR PTR_BX,SI
    XOR_PTR_BX_SI:
    CMP secondOperandIndex,5
    JE XOR_PTR_BX_SI1
    JMP XOR_PTR_BX_DI
    XOR_PTR_BX_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL XORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR PTR_BX,DI
    XOR_PTR_BX_DI:
    CMP secondOperandIndex,6
    JE XOR_PTR_BX_DI1
    JMP XOR_PTR_BX_SP
    XOR_PTR_BX_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,1
    CALL XORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR PTR_BX,SP
    XOR_PTR_BX_SP:
    CMP secondOperandIndex,7
    JE XOR_PTR_BX_SP1
    JMP XOR_PTR_BX_BP
    XOR_PTR_BX_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,1
    CALL XORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR PTR_BX,BP
    XOR_PTR_BX_BP:
    CMP secondOperandIndex,7
    JE XOR_PTR_BX_BP1
    JMP XOR_PTR_BX_AH
    
    XOR_PTR_BX_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,1
    CALL XORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR PTR_BX,AH
    XOR_PTR_BX_AH:
    CMP secondOperandIndex,9
    JE XOR_PTR_BX_AH1
    JMP XOR_PTR_BX_BH
    XOR_PTR_BX_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,1
    CALL XORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR PTR_BX,BH
    XOR_PTR_BX_BH:
    CMP secondOperandIndex,11
    JE XOR_PTR_BX_BH1
    JMP XOR_PTR_BX_CH
    XOR_PTR_BX_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,1
    CALL XORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR PTR_BX,CH
    XOR_PTR_BX_CH:
    CMP secondOperandIndex,13
    JE XOR_PTR_BX_CH1
    JMP XOR_PTR_BX_DH
    XOR_PTR_BX_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,1
    CALL XORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR PTR_BX,DH
    XOR_PTR_BX_DH:
    CMP secondOperandIndex,15
    JE XOR_PTR_BX_DH1
    JMP XOR_PTR_BX_AL
    XOR_PTR_BX_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,1
    CALL XORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR PTR_BX,AL
    XOR_PTR_BX_AL:
    CMP secondOperandIndex,10
    JE XOR_PTR_BX_AL1
    JMP XOR_PTR_BX_BL
    XOR_PTR_BX_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,1
    CALL XORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR PTR_BX,BL
    XOR_PTR_BX_BL:
    CMP secondOperandIndex,12
    JE XOR_PTR_BX_BL1
    JMP XOR_PTR_BX_CL
    XOR_PTR_BX_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,1
    CALL XORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR PTR_BX,CL
    XOR_PTR_BX_CL:
    CMP secondOperandIndex,14
    JE XOR_PTR_BX_CL1
    JMP XOR_PTR_BX_DL
    XOR_PTR_BX_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL XORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR PTR_BX,DL
    XOR_PTR_BX_DL:
    CMP secondOperandIndex,16
    JE XOR_PTR_BX_DL1
    JMP XOR_PTR_BX_NUM
    XOR_PTR_BX_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,1
    CALL XORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR PTR_BX,NUM
    XOR_PTR_BX_NUM:
    CMP secondOperandIndex,17
    JE XOR_PTR_BX_NUM1
    JMP NOTAVAILIDCOMMAND
    XOR_PTR_BX_NUM1:
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,1
    CALL XORAPointerRegWithNUM
    JMP ENDEXECUTE
    
    XORCOMMAND16:
    ;neither operand has bracket
    ;========================
    ;XOR AX,Source with no bracket
    XOR_AX1:
    CMP firstOperandIndex,1
    JE XOR_AX2
    JMP XOR_BX1
    XOR_AX2:
    
    ;XOR AX,AX
    XOR_AX_AX:
    CMP secondOperandIndex,1
    JE XOR_AX_AX1
    JMP XOR_AX_BX
    XOR_AX_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,0
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR AX,BX
    XOR_AX_BX:
    CMP secondOperandIndex,2
    JE XOR_AX_BX1
    JMP XOR_AX_CX
    XOR_AX_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,0
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR AX,CX
    XOR_AX_CX:
    CMP secondOperandIndex,3
    JE XOR_AX_CX1
    JMP XOR_AX_DX
    XOR_AX_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,0
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR AX,DX
    XOR_AX_DX:
    CMP secondOperandIndex,4
    JE XOR_AX_DX1
    JMP XOR_AX_SI
    XOR_AX_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,0
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR AX,SI
    XOR_AX_SI:
    CMP secondOperandIndex,5
    JE XOR_AX_SI1
    JMP XOR_AX_DI
    XOR_AX_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,0
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR AX,DI
    XOR_AX_DI:
    CMP secondOperandIndex,6
    JE XOR_AX_DI1
    JMP XOR_AX_SP
    XOR_AX_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,0
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR AX,SP
    XOR_AX_SP:
    CMP secondOperandIndex,7
    JE XOR_AX_SP1
    JMP XOR_AX_BP
    XOR_AX_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,0
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR AX,BP
    XOR_AX_BP:
    CMP secondOperandIndex,7
    JE XOR_AX_BP1
    JMP XOR_AX_NUM
    XOR_AX_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,0
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR AX,NUM
    XOR_AX_NUM:
    CMP secondOperandIndex,17
    JE XOR_AX_NUM1
    JMP NOTAVAILIDCOMMAND
    XOR_AX_NUM1:
    MOV addedValueToSIDest,0
    CALL ANDAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;XOR BX,Source with no bracket    
    XOR_BX1:
    CMP firstOperandIndex,2
    JE XOR_BX2
    JMP XOR_CX1
    XOR_BX2:
    
    ;XOR BX,AX
    XOR_BX_AX:
    CMP secondOperandIndex,1
    JE XOR_BX_AX1
    JMP XOR_BX_BX
    XOR_BX_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,1
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR BX,BX
    XOR_BX_BX:
    CMP secondOperandIndex,2
    JE XOR_BX_BX1
    JMP XOR_BX_CX
    XOR_BX_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,1
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR BX,CX
    XOR_BX_CX:
    CMP secondOperandIndex,3
    JE XOR_BX_CX1
    JMP XOR_BX_DX
    XOR_BX_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,1
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR BX,DX
    XOR_BX_DX:
    CMP secondOperandIndex,4
    JE XOR_BX_DX1
    JMP XOR_BX_SI
    XOR_BX_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,1
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR BX,SI
    XOR_BX_SI:
    CMP secondOperandIndex,5
    JE XOR_BX_SI1
    JMP XOR_BX_DI
    XOR_BX_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR BX,DI
    XOR_BX_DI:
    CMP secondOperandIndex,6
    JE XOR_BX_DI1
    JMP XOR_BX_SP
    XOR_BX_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,1
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR BX,SP
    XOR_BX_SP:
    CMP secondOperandIndex,7
    JE XOR_BX_SP1
    JMP XOR_BX_BP
    XOR_BX_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,1
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR BX,BP
    XOR_BX_BP:
    CMP secondOperandIndex,7
    JE XOR_BX_BP1
    JMP XOR_BX_NUM
    XOR_BX_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,1
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR BX,NUM
    XOR_BX_NUM:
    CMP secondOperandIndex,17
    JE XOR_BX_NUM1
    JMP NOTAVAILIDCOMMAND
    XOR_BX_NUM1:
    MOV addedValueToSIDest,1
    CALL XORAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;XOR CX,Source with no bracket
    XOR_CX1:
    CMP firstOperandIndex,3
    JE XOR_CX2
    JMP XOR_DX1
    XOR_CX2:
    
    ;XOR CX,AX
    XOR_CX_AX:
    CMP secondOperandIndex,1
    JE XOR_CX_AX1
    JMP XOR_CX_BX
    XOR_CX_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,2
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR CX,BX
    XOR_CX_BX:
    CMP secondOperandIndex,2
    JE XOR_CX_BX1
    JMP XOR_CX_CX
    XOR_CX_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,2
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR CX,CX
    XOR_CX_CX:
    CMP secondOperandIndex,3
    JE XOR_CX_CX1
    JMP XOR_CX_DX
    XOR_CX_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,2
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR CX,DX
    XOR_CX_DX:
    CMP secondOperandIndex,4
    JE XOR_CX_DX1
    JMP XOR_CX_SI
    XOR_CX_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,2
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR CX,SI
    XOR_CX_SI:
    CMP secondOperandIndex,5
    JE XOR_CX_SI1
    JMP XOR_CX_DI
    XOR_CX_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,2
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR CX,DI
    XOR_CX_DI:
    CMP secondOperandIndex,6
    JE XOR_CX_DI1
    JMP XOR_CX_SP
    XOR_CX_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,2
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR CX,SP
    XOR_CX_SP:
    CMP secondOperandIndex,7
    JE XOR_CX_SP1
    JMP XOR_CX_BP
    XOR_CX_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,2
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR CX,BP
    XOR_CX_BP:
    CMP secondOperandIndex,7
    JE XOR_CX_BP1
    JMP XOR_CX_NUM
    XOR_CX_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,2
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR CX,NUM
    XOR_CX_NUM:
    CMP secondOperandIndex,17
    JE XOR_CX_NUM1
    JMP NOTAVAILIDCOMMAND
    XOR_CX_NUM1:
    MOV addedValueToSIDest,2
    CALL XORAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;XOR DX,Source with no bracket
    XOR_DX1:
    CMP firstOperandIndex,4
    JE XOR_DX2
    JMP XOR_SI1
    XOR_DX2:
    
    ;XOR DX,AX
    XOR_DX_AX:
    CMP secondOperandIndex,1
    JE XOR_DX_AX1
    JMP XOR_DX_BX
    XOR_DX_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,3
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR DX,BX
    XOR_DX_BX:
    CMP secondOperandIndex,2
    JE XOR_DX_BX1
    JMP XOR_DX_CX
    XOR_DX_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,3
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR DX,CX
    XOR_DX_CX:
    CMP secondOperandIndex,3
    JE XOR_DX_CX1
    JMP XOR_DX_DX
    XOR_DX_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,3
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR DX,DX
    XOR_DX_DX:
    CMP secondOperandIndex,4
    JE XOR_DX_DX1
    JMP XOR_DX_SI
    XOR_DX_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,3
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR DX,SI
    XOR_DX_SI:
    CMP secondOperandIndex,5
    JE XOR_DX_SI1
    JMP XOR_DX_DI
    XOR_DX_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,3
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR DX,DI
    XOR_DX_DI:
    CMP secondOperandIndex,6
    JE XOR_DX_DI1
    JMP XOR_DX_SP
    XOR_DX_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,3
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR DX,SP
    XOR_DX_SP:
    CMP secondOperandIndex,7
    JE XOR_DX_SP1
    JMP XOR_DX_BP
    XOR_DX_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,3
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR DX,BP
    XOR_DX_BP:
    CMP secondOperandIndex,7
    JE XOR_DX_BP1
    JMP XOR_DX_NUM
    XOR_DX_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,3
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR DX,NUM
    XOR_DX_NUM:
    CMP secondOperandIndex,17
    JE XOR_DX_NUM1
    JMP NOTAVAILIDCOMMAND
    XOR_DX_NUM1:
    MOV addedValueToSIDest,3
    CALL XORAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;XOR SI,Source with no bracket
    XOR_SI1:
    CMP firstOperandIndex,5
    JE XOR_SI2
    JMP XOR_DI1
    XOR_SI2:
    
    ;XOR SI,AX
    XOR_SI_AX:
    CMP secondOperandIndex,1
    JE XOR_SI_AX1
    JMP XOR_SI_BX
    XOR_SI_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,4
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR SI,BX
    XOR_SI_BX:
    CMP secondOperandIndex,2
    JE XOR_SI_BX1
    JMP XOR_SI_CX
    XOR_SI_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,4
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR SI,CX
    XOR_SI_CX:
    CMP secondOperandIndex,3
    JE XOR_SI_CX1
    JMP XOR_SI_DX
    XOR_SI_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,4
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR SI,DX
    XOR_SI_DX:
    CMP secondOperandIndex,4
    JE XOR_SI_DX1
    JMP XOR_SI_SI
    XOR_SI_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,4
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR SI,SI
    XOR_SI_SI:
    CMP secondOperandIndex,5
    JE XOR_SI_SI1
    JMP XOR_SI_DI
    XOR_SI_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR SI,DI
    XOR_SI_DI:
    CMP secondOperandIndex,6
    JE XOR_SI_DI1
    JMP XOR_SI_SP
    XOR_SI_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,4
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR SI,SP
    XOR_SI_SP:
    CMP secondOperandIndex,7
    JE XOR_SI_SP1
    JMP XOR_SI_BP
    XOR_SI_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,4
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR SI,BP
    XOR_SI_BP:
    CMP secondOperandIndex,7
    JE XOR_SI_BP1
    JMP XOR_SI_NUM
    XOR_SI_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,4
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR SI,NUM
    XOR_SI_NUM:
    CMP secondOperandIndex,17
    JE XOR_SI_NUM1
    JMP NOTAVAILIDCOMMAND
    XOR_SI_NUM1:
    MOV addedValueToSIDest,4
    CALL XORAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;XOR DI,Source with no bracket
    XOR_DI1:
    CMP firstOperandIndex,6
    JE XOR_DI2
    JMP XOR_SP1
    XOR_DI2:
    
    ;XOR DI,AX
    XOR_DI_AX:
    CMP secondOperandIndex,1
    JE XOR_DI_AX1
    JMP XOR_DI_BX
    XOR_DI_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,5
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR DI,BX
    XOR_DI_BX:
    CMP secondOperandIndex,2
    JE XOR_DI_BX1
    JMP XOR_DI_CX
    XOR_DI_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,5
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR DI,CX
    XOR_DI_CX:
    CMP secondOperandIndex,3
    JE XOR_DI_CX1
    JMP XOR_DI_DX
    XOR_DI_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,5
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR DI,DX
    XOR_DI_DX:
    CMP secondOperandIndex,4
    JE XOR_DI_DX1
    JMP XOR_DI_SI
    XOR_DI_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,5
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR DI,SI
    XOR_DI_SI:
    CMP secondOperandIndex,5
    JE XOR_DI_SI1
    JMP XOR_DI_DI
    XOR_DI_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR DI,DI
    XOR_DI_DI:
    CMP secondOperandIndex,6
    JE XOR_DI_DI1
    JMP XOR_DI_SP
    XOR_DI_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,5
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR DI,SP
    XOR_DI_SP:
    CMP secondOperandIndex,7
    JE XOR_DI_SP1
    JMP XOR_DI_BP
    XOR_DI_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,5
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR DI,BP
    XOR_DI_BP:
    CMP secondOperandIndex,7
    JE XOR_DI_BP1
    JMP XOR_DI_NUM
    XOR_DI_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,5
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR DI,NUM
    XOR_DI_NUM:
    CMP secondOperandIndex,17
    JE XOR_DI_NUM1
    JMP NOTAVAILIDCOMMAND
    XOR_DI_NUM1:
    MOV addedValueToSIDest,5
    CALL XORAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;XOR SP,Source with no bracket
    XOR_SP1:
    CMP firstOperandIndex,7
    JE XOR_SP2
    JMP XOR_BP1
    XOR_SP2:
    
    ;XOR SP,AX
    XOR_SP_AX:
    CMP secondOperandIndex,1
    JE XOR_SP_AX1
    JMP XOR_SP_BX
    XOR_SP_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,6
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR SP,BX
    XOR_SP_BX:
    CMP secondOperandIndex,2
    JE XOR_SP_BX1
    JMP XOR_SP_CX
    XOR_SP_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,6
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR SP,CX
    XOR_SP_CX:
    CMP secondOperandIndex,3
    JE XOR_SP_CX1
    JMP XOR_SP_DX
    XOR_SP_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,6
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR SP,DX
    XOR_SP_DX:
    CMP secondOperandIndex,4
    JE XOR_SP_DX1
    JMP XOR_SP_SI
    XOR_SP_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,6
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR SP,SI
    XOR_SP_SI:
    CMP secondOperandIndex,5
    JE XOR_SP_SI1
    JMP XOR_SP_DI
    XOR_SP_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,6
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR SP,DI
    XOR_SP_DI:
    CMP secondOperandIndex,6
    JE XOR_SP_DI1
    JMP XOR_SP_SP
    XOR_SP_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,6
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR SP,SP
    XOR_SP_SP:
    CMP secondOperandIndex,7
    JE XOR_SP_SP1
    JMP XOR_SP_BP
    XOR_SP_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,6
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR SP,BP
    XOR_SP_BP:
    CMP secondOperandIndex,7
    JE XOR_SP_BP1
    JMP XOR_SP_NUM
    XOR_SP_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,6
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR SP,NUM
    XOR_SP_NUM:
    CMP secondOperandIndex,17
    JE XOR_SP_NUM1
    JMP NOTAVAILIDCOMMAND
    XOR_SP_NUM1:
    MOV addedValueToSIDest,6
    CALL XORAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;XOR BP,Source with no bracket
    XOR_BP1:
    CMP firstOperandIndex,8
    JE XOR_BP2
    JMP XOR_AH1
    XOR_BP2:
    
    ;XOR BP,AX
    XOR_BP_AX:
    CMP secondOperandIndex,1
    JE XOR_BP_AX1
    JMP XOR_BP_BX
    XOR_BP_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,7
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR BP,BX
    XOR_BP_BX:
    CMP secondOperandIndex,2
    JE XOR_BP_BX1
    JMP XOR_BP_CX
    XOR_BP_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,7
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR BP,CX
    XOR_BP_CX:
    CMP secondOperandIndex,3
    JE XOR_BP_CX1
    JMP XOR_BP_DX
    XOR_BP_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,7
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR BP,DX
    XOR_BP_DX:
    CMP secondOperandIndex,4
    JE XOR_BP_DX1
    JMP XOR_BP_SI
    XOR_BP_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,7
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR BP,SI
    XOR_BP_SI:
    CMP secondOperandIndex,5
    JE XOR_BP_SI1
    JMP XOR_BP_DI
    XOR_BP_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,7
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR BP,DI
    XOR_BP_DI:
    CMP secondOperandIndex,6
    JE XOR_BP_DI1
    JMP XOR_BP_SP
    XOR_BP_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,7
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR BP,SP
    XOR_BP_SP:
    CMP secondOperandIndex,7
    JE XOR_BP_SP1
    JMP XOR_BP_BP
    XOR_BP_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,7
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR BP,BP
    XOR_BP_BP:
    CMP secondOperandIndex,7
    JE XOR_BP_BP1
    JMP XOR_BP_NUM
    XOR_BP_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,7
    CALL XORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;XOR BP,NUM
    XOR_BP_NUM:
    CMP secondOperandIndex,17
    JE XOR_BP_NUM1
    JMP NOTAVAILIDCOMMAND
    XOR_BP_NUM1:
    MOV addedValueToSIDest,7
    CALL XORAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;XOR AH,Source with no bracket
    XOR_AH1:
    CMP firstOperandIndex,9
    JE XOR_AH2
    JMP XOR_AL1
    XOR_AH2:
    
    ;XOR AH,AH
    XOR_AH_AH:
    CMP secondOperandIndex,9
    JE XOR_AH_AH1
    JMP XOR_AH_BH
    XOR_AH_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,1
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR AH,BH
    XOR_AH_BH:
    CMP secondOperandIndex,11
    JE XOR_AH_BH1
    JMP XOR_AH_CH
    XOR_AH_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,1
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR AH,CH
    XOR_AH_CH:
    CMP secondOperandIndex,13
    JE XOR_AH_CH1
    JMP XOR_AH_DH
    XOR_AH_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,1
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR AH,DH
    XOR_AH_DH:
    CMP secondOperandIndex,15
    JE XOR_AH_DH1
    JMP XOR_AH_AL
    XOR_AH_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,1
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR AH,AL
    XOR_AH_AL:
    CMP secondOperandIndex,10
    JE XOR_AH_AL1
    JMP XOR_AH_BL
    XOR_AH_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,1
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR AH,BL
    XOR_AH_BL:
    CMP secondOperandIndex,12
    JE XOR_AH_BL1
    JMP XOR_AH_CL
    XOR_AH_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,1
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR AH,CL
    XOR_AH_CL:
    CMP secondOperandIndex,14
    JE XOR_AH_CL1
    JMP XOR_AH_DL
    XOR_AH_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR AH,DL
    XOR_AH_DL:
    CMP secondOperandIndex,16
    JE XOR_AH_DL1
    JMP XOR_AH_NUM
    XOR_AH_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,1
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR AH,NUM
    XOR_AH_NUM:
    CMP secondOperandIndex,17
    JE XOR_AH_NUM1
    JMP NOTAVAILIDCOMMAND
    XOR_AH_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,1
    CALL XORAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;XOR AL,Source with no bracket
    XOR_AL1:
    CMP firstOperandIndex,10
    JE XOR_AL2
    JMP XOR_BH1
    XOR_AL2:
    
    ;XOR AL,AH
    XOR_AL_AH:
    CMP secondOperandIndex,9
    JE XOR_AL_AH1
    JMP XOR_AL_BH
    XOR_AL_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,0
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR AL,BH
    XOR_AL_BH:
    CMP secondOperandIndex,11
    JE XOR_AL_BH1
    JMP XOR_AL_CH
    XOR_AL_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,0
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR AL,CH
    XOR_AL_CH:
    CMP secondOperandIndex,13
    JE XOR_AL_CH1
    JMP XOR_AL_DH
    XOR_AL_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,0
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR AL,DH
    XOR_AL_DH:
    CMP secondOperandIndex,15
    JE XOR_AL_DH1
    JMP XOR_AL_AL
    XOR_AL_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,0
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR AL,AL
    XOR_AL_AL:
    CMP secondOperandIndex,10
    JE XOR_AL_AL1
    JMP XOR_AL_BL
    XOR_AL_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,0
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR AL,BL
    XOR_AL_BL:
    CMP secondOperandIndex,12
    JE XOR_AL_BL1
    JMP XOR_AL_CL
    XOR_AL_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,0
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR AL,CL
    XOR_AL_CL:
    CMP secondOperandIndex,14
    JE XOR_AL_CL1
    JMP XOR_AL_DL
    XOR_AL_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,0
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR AL,DL
    XOR_AL_DL:
    CMP secondOperandIndex,16
    JE XOR_AL_DL1
    JMP XOR_AL_NUM
    XOR_AL_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,0
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR AL,NUM
    XOR_AL_NUM:
    CMP secondOperandIndex,17
    JE XOR_AL_NUM1
    JMP NOTAVAILIDCOMMAND
    XOR_AL_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,0
    CALL XORAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;XOR BH,Source with no bracket
    XOR_BH1:
    CMP firstOperandIndex,11
    JE XOR_BH2
    JMP XOR_BL1
    XOR_BH2:
    
    ;XOR BH,AH
    XOR_BH_AH:
    CMP secondOperandIndex,9
    JE XOR_BH_AH1
    JMP XOR_BH_BH
    XOR_BH_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,3
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR BH,BH
    XOR_BH_BH:
    CMP secondOperandIndex,11
    JE XOR_BH_BH1
    JMP XOR_BH_CH
    XOR_BH_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,3
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR BH,CH
    XOR_BH_CH:
    CMP secondOperandIndex,13
    JE XOR_BH_CH1
    JMP XOR_BH_DH
    XOR_BH_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,3
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR BH,DH
    XOR_BH_DH:
    CMP secondOperandIndex,15
    JE XOR_BH_DH1
    JMP XOR_BH_AL
    XOR_BH_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,3
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR BH,AL
    XOR_BH_AL:
    CMP secondOperandIndex,10
    JE XOR_BH_AL1
    JMP XOR_BH_BL
    XOR_BH_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,3
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR BH,BL
    XOR_BH_BL:
    CMP secondOperandIndex,12
    JE XOR_BH_BL1
    JMP XOR_BH_CL
    XOR_BH_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,3
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR BH,CL
    XOR_BH_CL:
    CMP secondOperandIndex,14
    JE XOR_BH_CL1
    JMP XOR_BH_DL
    XOR_BH_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,3
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR BH,DL
    XOR_BH_DL:
    CMP secondOperandIndex,16
    JE XOR_BH_DL1
    JMP XOR_BH_NUM
    XOR_BH_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,3
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR BH,NUM
    XOR_BH_NUM:
    CMP secondOperandIndex,17
    JE XOR_BH_NUM1
    JMP NOTAVAILIDCOMMAND
    XOR_BH_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,3
    CALL XORAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;XOR BL,Source with no bracket
    XOR_BL1:
    CMP firstOperandIndex,12
    JE XOR_BL2
    JMP XOR_CH1
    XOR_BL2:
    
    ;XOR BL,AH
    XOR_BL_AH:
    CMP secondOperandIndex,9
    JE XOR_BL_AH1
    JMP XOR_BL_BH
    XOR_BL_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,2
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR BL,BH
    XOR_BL_BH:
    CMP secondOperandIndex,11
    JE XOR_BL_BH1
    JMP XOR_BL_CH
    XOR_BL_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,2
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR BL,CH
    XOR_BL_CH:
    CMP secondOperandIndex,13
    JE XOR_BL_CH1
    JMP XOR_BL_DH
    XOR_BL_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,2
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR BL,DH
    XOR_BL_DH:
    CMP secondOperandIndex,15
    JE XOR_BL_DH1
    JMP XOR_BL_AL
    XOR_BL_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,2
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR BL,AL
    XOR_BL_AL:
    CMP secondOperandIndex,10
    JE XOR_BL_AL1
    JMP XOR_BL_BL
    XOR_BL_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,2
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR BL,BL
    XOR_BL_BL:
    CMP secondOperandIndex,12
    JE XOR_BL_BL1
    JMP XOR_BL_CL
    XOR_BL_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,2
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR BL,CL
    XOR_BL_CL:
    CMP secondOperandIndex,14
    JE XOR_BL_CL1
    JMP XOR_BL_DL
    XOR_BL_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,2
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR BL,DL
    XOR_BL_DL:
    CMP secondOperandIndex,16
    JE XOR_BL_DL1
    JMP XOR_BL_NUM
    XOR_BL_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,2
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR BL,NUM
    XOR_BL_NUM:
    CMP secondOperandIndex,17
    JE XOR_BL_NUM1
    JMP NOTAVAILIDCOMMAND
    XOR_BL_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,2
    CALL XORAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;XOR CH,Source with no bracket
    XOR_CH1:
    CMP firstOperandIndex,13
    JE XOR_CH2
    JMP XOR_CL1
    XOR_CH2:
    
    ;XOR CH,AH
    XOR_CH_AH:
    CMP secondOperandIndex,9
    JE XOR_CH_AH1
    JMP XOR_CH_BH
    XOR_CH_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,5
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR CH,BH
    XOR_CH_BH:
    CMP secondOperandIndex,11
    JE XOR_CH_BH1
    JMP XOR_CH_CH
    XOR_CH_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,5
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR CH,CH
    XOR_CH_CH:
    CMP secondOperandIndex,13
    JE XOR_CH_CH1
    JMP XOR_CH_DH
    XOR_CH_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,5
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR CH,DH
    XOR_CH_DH:
    CMP secondOperandIndex,15
    JE XOR_CH_DH1
    JMP XOR_CH_AL
    XOR_CH_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,5
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR CH,AL
    XOR_CH_AL:
    CMP secondOperandIndex,10
    JE XOR_CH_AL1
    JMP XOR_CH_BL
    XOR_CH_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,5
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR CH,BL
    XOR_CH_BL:
    CMP secondOperandIndex,12
    JE XOR_CH_BL1
    JMP XOR_CH_CL
    XOR_CH_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,5
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR CH,CL
    XOR_CH_CL:
    CMP secondOperandIndex,14
    JE XOR_CH_CL1
    JMP XOR_CH_DL
    XOR_CH_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR CH,DL
    XOR_CH_DL:
    CMP secondOperandIndex,16
    JE XOR_CH_DL1
    JMP XOR_CH_NUM
    XOR_CH_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,5
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR CH,NUM
    XOR_CH_NUM:
    CMP secondOperandIndex,17
    JE XOR_CH_NUM1
    JMP NOTAVAILIDCOMMAND
    XOR_CH_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,5
    CALL XORAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;XOR CL,Source with no bracket
    XOR_CL1:
    CMP firstOperandIndex,14
    JE XOR_CL2
    JMP XOR_DH1
    XOR_CL2:
    
    ;XOR CL,AH
    XOR_CL_AH:
    CMP secondOperandIndex,9
    JE XOR_CL_AH1
    JMP XOR_CL_BH
    XOR_CL_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,4
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR CL,BH
    XOR_CL_BH:
    CMP secondOperandIndex,11
    JE XOR_CL_BH1
    JMP XOR_CL_CH
    XOR_CL_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,4
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR CL,CH
    XOR_CL_CH:
    CMP secondOperandIndex,13
    JE XOR_CL_CH1
    JMP XOR_CL_DH
    XOR_CL_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,4
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR CL,DH
    XOR_CL_DH:
    CMP secondOperandIndex,15
    JE XOR_CL_DH1
    JMP XOR_CL_AL
    XOR_CL_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,4
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR CL,AL
    XOR_CL_AL:
    CMP secondOperandIndex,10
    JE XOR_CL_AL1
    JMP XOR_CL_BL
    XOR_CL_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,4
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR CL,BL
    XOR_CL_BL:
    CMP secondOperandIndex,12
    JE XOR_CL_BL1
    JMP XOR_CL_CL
    XOR_CL_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,4
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR CL,CL
    XOR_CL_CL:
    CMP secondOperandIndex,14
    JE XOR_CL_CL1
    JMP XOR_CL_DL
    XOR_CL_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR CL,DL
    XOR_CL_DL:
    CMP secondOperandIndex,16
    JE XOR_CL_DL1
    JMP XOR_CL_NUM
    XOR_CL_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,4
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR CL,NUM
    XOR_CL_NUM:
    CMP secondOperandIndex,17
    JE XOR_CL_NUM1
    JMP NOTAVAILIDCOMMAND
    XOR_CL_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,4
    CALL XORAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;XOR DH,Source with no bracket
    XOR_DH1:
    CMP firstOperandIndex,15
    JE XOR_DH2
    JMP XOR_DL1
    XOR_DH2:
    
    ;XOR DH,AH
    XOR_DH_AH:
    CMP secondOperandIndex,9
    JE XOR_DH_AH1
    JMP XOR_DH_BH
    XOR_DH_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,7
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR DH,BH
    XOR_DH_BH:
    CMP secondOperandIndex,11
    JE XOR_DH_BH1
    JMP XOR_DH_CH
    XOR_DH_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,7
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR DH,CH
    XOR_DH_CH:
    CMP secondOperandIndex,13
    JE XOR_DH_CH1
    JMP XOR_DH_DH
    XOR_DH_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,7
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR DH,DH
    XOR_DH_DH:
    CMP secondOperandIndex,15
    JE XOR_DH_DH1
    JMP XOR_DH_AL
    XOR_DH_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,7
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR DH,AL
    XOR_DH_AL:
    CMP secondOperandIndex,10
    JE XOR_DH_AL1
    JMP XOR_DH_BL
    XOR_DH_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,7
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR DH,BL
    XOR_DH_BL:
    CMP secondOperandIndex,12
    JE XOR_DH_BL1
    JMP XOR_DH_CL
    XOR_DH_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,7
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR DH,CL
    XOR_DH_CL:
    CMP secondOperandIndex,14
    JE XOR_DH_CL1
    JMP XOR_DH_DL
    XOR_DH_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,7
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR DH,DL
    XOR_DH_DL:
    CMP secondOperandIndex,16
    JE XOR_DH_DL1
    JMP XOR_DH_NUM
    XOR_DH_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,7
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR DH,NUM
    XOR_DH_NUM:
    CMP secondOperandIndex,17
    JE XOR_DH_NUM1
    JMP NOTAVAILIDCOMMAND
    XOR_DH_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,7
    CALL XORAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;XOR DL,Source with no bracket
    XOR_DL1:
    CMP firstOperandIndex,15
    JE XOR_DL2
    JMP NOTAVAILIDCOMMAND
    XOR_DL2:
    
    ;XOR DL,AH
    XOR_DL_AH:
    CMP secondOperandIndex,9
    JE XOR_DL_AH1
    JMP XOR_DL_BH
    XOR_DL_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,6
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR DL,BH
    XOR_DL_BH:
    CMP secondOperandIndex,11
    JE XOR_DL_BH1
    JMP XOR_DL_CH
    XOR_DL_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,6
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR DL,CH
    XOR_DL_CH:
    CMP secondOperandIndex,13
    JE XOR_DL_CH1
    JMP XOR_DL_DH
    XOR_DL_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,6
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR DL,DH
    XOR_DL_DH:
    CMP secondOperandIndex,15
    JE XOR_DL_DH1
    JMP XOR_DL_AL
    XOR_DL_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,6
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR DL,AL
    XOR_DL_AL:
    CMP secondOperandIndex,10
    JE XOR_DL_AL1
    JMP XOR_DL_BL
    XOR_DL_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,6
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR DL,BL
    XOR_DL_BL:
    CMP secondOperandIndex,12
    JE XOR_DL_BL1
    JMP XOR_DL_CL
    XOR_DL_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,6
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR DL,CL
    XOR_DL_CL:
    CMP secondOperandIndex,14
    JE XOR_DL_CL1
    JMP XOR_DL_DL
    XOR_DL_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,6
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR DL,DL
    XOR_DL_DL:
    CMP secondOperandIndex,16
    JE XOR_DL_DL1
    JMP XOR_DL_NUM
    XOR_DL_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,6
    CALL XORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;XOR DL,NUM
    XOR_DL_NUM:
    CMP secondOperandIndex,17
    JE XOR_DL_NUM1
    JMP NOTAVAILIDCOMMAND
    XOR_DL_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,6
    CALL XORAByteRegWithNUM
    JMP ENDEXECUTE
;------------------------------------------------------------------------------------------------  
    ;this is AND command
    ANDCOMMAND:
    CMP commandIndex,9
    JE ANDCOMMAND1
    JMP ORCOMMAND
    ANDCOMMAND1:
    
    ;the two operand mustn't have brackets at the same time
    CMP isSecondOpBracket,1
    JE ANDCOMMAND11
    JMP ANDCOMMAND12
    ANDCOMMAND11:
    CMP isFirstOpBracket,1
    JNE ANDCOMMAND12
    JMP NOTAVAILIDCOMMAND
    
    ;Begin executing commands
    ANDCOMMAND12:
    ;2nd operand has bracket 
    CMP isSecondOpBracket,1
    JE ANDCOMMAND13
    JMP ANDCOMMAND14
    ANDCOMMAND13:
    
    ;========================
    ;AND destination with no bracket,[SI]
    AND_PTR_SI_SOURCE:
    CMP secondOperandIndex,5
    JE AND_PTR_SI_SOURCE1
    JMP AND_PTR_DI_SOURCE
    AND_PTR_SI_SOURCE1:
    
    ;AND AX,PTR_SI
    AND_AX_PTR_SI:
    CMP firstOperandIndex,1
    JE AND_AX_PTR_SI1
    JMP AND_BX_PTR_SI
    AND_AX_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,0
    CALL ANDAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;AND BX,PTR_SI
    AND_BX_PTR_SI:
    CMP firstOperandIndex,2
    JE AND_BX_PTR_SI1
    JMP AND_CX_PTR_SI
    AND_BX_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL ANDAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;AND CX,PTR_SI
    AND_CX_PTR_SI:
    CMP firstOperandIndex,3
    JE AND_CX_PTR_SI1
    JMP AND_DX_PTR_SI
    AND_CX_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,2
    CALL ANDAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;AND DX,PTR_SI
    AND_DX_PTR_SI:
    CMP firstOperandIndex,4
    JE AND_DX_PTR_SI1
    JMP AND_SI_PTR_SI
    AND_DX_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,3
    CALL ANDAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;AND SI,PTR_SI
    AND_SI_PTR_SI:
    CMP firstOperandIndex,5
    JE AND_SI_PTR_SI1
    JMP AND_DI_PTR_SI
    AND_SI_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL ANDAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;AND DI,PTR_SI
    AND_DI_PTR_SI:
    CMP firstOperandIndex,6
    JE AND_DI_PTR_SI1
    JMP AND_SP_PTR_SI
    AND_DI_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL ANDAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;AND SP,PTR_SI
    AND_SP_PTR_SI:
    CMP firstOperandIndex,7
    JE AND_SP_PTR_SI1
    JMP AND_BP_PTR_SI
    AND_SP_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,6
    CALL ANDAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;AND BP,PTR_SI
    AND_BP_PTR_SI:
    CMP firstOperandIndex,7
    JE AND_BP_PTR_SI1
    JMP AND_AH_PTR_SI
    AND_BP_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,7
    CALL ANDAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;AND AH,PTR_SI
    AND_AH_PTR_SI:
    CMP firstOperandIndex,9
    JE AND_AH_PTR_SI1
    JMP AND_BH_PTR_SI
    AND_AH_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL ANDAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;AND BH,PTR_SI
    AND_BH_PTR_SI:
    CMP firstOperandIndex,11
    JE AND_BH_PTR_SI1
    JMP AND_CH_PTR_SI
    AND_BH_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,3
    CALL ANDAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;AND CH,PTR_SI
    AND_CH_PTR_SI:
    CMP firstOperandIndex,13
    JE AND_CH_PTR_SI1
    JMP AND_DH_PTR_SI
    AND_CH_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL ANDAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;AND DH,PTR_SI
    AND_DH_PTR_SI:
    CMP firstOperandIndex,15
    JE AND_DH_PTR_SI1
    JMP AND_AL_PTR_SI
    AND_DH_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,7
    CALL ANDAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;AND AL,PTR_SI
    AND_AL_PTR_SI:
    CMP firstOperandIndex,10
    JE AND_AL_PTR_SI1
    JMP AND_BL_PTR_SI
    AND_AL_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,0
    CALL ANDAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;AND BL,PTR_SI
    AND_BL_PTR_SI:
    CMP firstOperandIndex,12
    JE AND_BL_PTR_SI1
    JMP AND_CL_PTR_SI
    AND_BL_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,2
    CALL ANDAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;AND CL,PTR_SI
    AND_CL_PTR_SI:
    CMP firstOperandIndex,14
    JE AND_CL_PTR_SI1
    JMP AND_DL_PTR_SI
    AND_CL_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL ANDAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;AND DL,PTR_SI
    AND_DL_PTR_SI:
    CMP firstOperandIndex,16
    JE AND_DL_PTR_SI1
    JMP NOTAVAILIDCOMMAND
    AND_DL_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,6
    CALL ANDAByteRegWithPointer
    JMP ENDEXECUTE
 
    ;========================
    ;AND destination with no bracket,[DI]
    AND_PTR_DI_SOURCE:
    CMP secondOperandIndex,6
    JE AND_PTR_DI_SOURCE1
    JMP AND_PTR_BX_SOURCE
    AND_PTR_DI_SOURCE1:
    
    ;AND AX,PTR_DI
    AND_AX_PTR_DI:
    CMP firstOperandIndex,1
    JE AND_AX_PTR_DI1
    JMP AND_BX_PTR_DI
    AND_AX_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,0
    CALL ANDAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;AND BX,PTR_DI
    AND_BX_PTR_DI:
    CMP firstOperandIndex,2
    JE AND_BX_PTR_DI1
    JMP AND_CX_PTR_DI
    AND_BX_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,1
    CALL ANDAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;AND CX,PTR_DI
    AND_CX_PTR_DI:
    CMP firstOperandIndex,3
    JE AND_CX_PTR_DI1
    JMP AND_DX_PTR_DI
    AND_CX_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,2
    CALL ANDAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;AND DX,PTR_DI
    AND_DX_PTR_DI:
    CMP firstOperandIndex,4
    JE AND_DX_PTR_DI1
    JMP AND_SI_PTR_DI
    AND_DX_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,3
    CALL ANDAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;AND SI,PTR_DI
    AND_SI_PTR_DI:
    CMP firstOperandIndex,5
    JE AND_SI_PTR_DI1
    JMP AND_DI_PTR_DI
    AND_SI_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,4
    CALL ANDAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;AND DI,PTR_DI
    AND_DI_PTR_DI:
    CMP firstOperandIndex,6
    JE AND_DI_PTR_DI1
    JMP AND_SP_PTR_DI
    AND_DI_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,5
    CALL ANDAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;AND SP,PTR_DI
    AND_SP_PTR_DI:
    CMP firstOperandIndex,7
    JE AND_SP_PTR_DI1
    JMP AND_BP_PTR_DI
    AND_SP_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,6
    CALL ANDAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;AND BP,PTR_DI
    AND_BP_PTR_DI:
    CMP firstOperandIndex,7
    JE AND_BP_PTR_DI1
    JMP AND_AH_PTR_DI
    AND_BP_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,7
    CALL ANDAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;AND AH,PTR_DI
    AND_AH_PTR_DI:
    CMP firstOperandIndex,9
    JE AND_AH_PTR_DI1
    JMP AND_BH_PTR_DI
    AND_AH_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,1
    CALL ANDAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;AND BH,PTR_DI
    AND_BH_PTR_DI:
    CMP firstOperandIndex,11
    JE AND_BH_PTR_DI1
    JMP AND_CH_PTR_DI
    AND_BH_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,3
    CALL ANDAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;AND CH,PTR_DI
    AND_CH_PTR_DI:
    CMP firstOperandIndex,13
    JE AND_CH_PTR_DI1
    JMP AND_DH_PTR_DI
    AND_CH_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,5
    CALL ANDAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;AND DH,PTR_DI
    AND_DH_PTR_DI:
    CMP firstOperandIndex,15
    JE AND_DH_PTR_DI1
    JMP AND_AL_PTR_DI
    AND_DH_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,7
    CALL ANDAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;AND AL,PTR_DI
    AND_AL_PTR_DI:
    CMP firstOperandIndex,10
    JE AND_AL_PTR_DI1
    JMP AND_BL_PTR_DI
    AND_AL_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,0
    CALL ANDAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;AND BL,PTR_DI
    AND_BL_PTR_DI:
    CMP firstOperandIndex,12
    JE AND_BL_PTR_DI1
    JMP AND_CL_PTR_DI
    AND_BL_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,2
    CALL ANDAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;AND CL,PTR_DI
    AND_CL_PTR_DI:
    CMP firstOperandIndex,14
    JE AND_CL_PTR_DI1
    JMP AND_DL_PTR_DI
    AND_CL_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,4
    CALL ANDAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;AND DL,PTR_DI
    AND_DL_PTR_DI:
    CMP firstOperandIndex,16
    JE AND_DL_PTR_DI1
    JMP NOTAVAILIDCOMMAND
    AND_DL_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,6
    CALL ANDAByteRegWithPointer
    JMP ENDEXECUTE

    ;========================
    ;AND destination with no bracket,[BX]
    AND_PTR_BX_SOURCE:
    CMP secondOperandIndex,2
    JE AND_PTR_BX_SOURCE1
    JMP AND_PTR_NUM_SOURCE
    AND_PTR_BX_SOURCE1:
    
    ;AND AX,PTR_BX
    AND_AX_PTR_BX:
    CMP firstOperandIndex,1
    JE AND_AX_PTR_BX1
    JMP AND_BX_PTR_BX
    AND_AX_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,0
    CALL ANDAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;AND BX,PTR_BX
    AND_BX_PTR_BX:
    CMP firstOperandIndex,2
    JE AND_BX_PTR_BX1
    JMP AND_CX_PTR_BX
    AND_BX_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL ANDAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;AND CX,PTR_BX
    AND_CX_PTR_BX:
    CMP firstOperandIndex,3
    JE AND_CX_PTR_BX1
    JMP AND_DX_PTR_BX
    AND_CX_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,2
    CALL ANDAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;AND DX,PTR_BX
    AND_DX_PTR_BX:
    CMP firstOperandIndex,4
    JE AND_DX_PTR_BX1
    JMP AND_SI_PTR_BX
    AND_DX_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,3
    CALL ANDAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;AND SI,PTR_BX
    AND_SI_PTR_BX:
    CMP firstOperandIndex,5
    JE AND_SI_PTR_BX1
    JMP AND_DI_PTR_BX
    AND_SI_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL ANDAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;AND DI,PTR_BX
    AND_DI_PTR_BX:
    CMP firstOperandIndex,6
    JE AND_DI_PTR_BX1
    JMP AND_SP_PTR_BX
    AND_DI_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL ANDAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;AND SP,PTR_BX
    AND_SP_PTR_BX:
    CMP firstOperandIndex,7
    JE AND_SP_PTR_BX1
    JMP AND_BP_PTR_BX
    AND_SP_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,6
    CALL ANDAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;AND BP,PTR_BX
    AND_BP_PTR_BX:
    CMP firstOperandIndex,7
    JE AND_BP_PTR_BX1
    JMP AND_AH_PTR_BX
    AND_BP_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,7
    CALL ANDAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;AND AH,PTR_BX
    AND_AH_PTR_BX:
    CMP firstOperandIndex,9
    JE AND_AH_PTR_BX1
    JMP AND_BH_PTR_BX
    AND_AH_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL ANDAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;AND BH,PTR_BX
    AND_BH_PTR_BX:
    CMP firstOperandIndex,11
    JE AND_BH_PTR_BX1
    JMP AND_CH_PTR_BX
    AND_BH_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,3
    CALL ANDAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;AND CH,PTR_BX
    AND_CH_PTR_BX:
    CMP firstOperandIndex,13
    JE AND_CH_PTR_BX1
    JMP AND_DH_PTR_BX
    AND_CH_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL ANDAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;AND DH,PTR_BX
    AND_DH_PTR_BX:
    CMP firstOperandIndex,15
    JE AND_DH_PTR_BX1
    JMP AND_AL_PTR_BX
    AND_DH_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,7
    CALL ANDAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;AND AL,PTR_BX
    AND_AL_PTR_BX:
    CMP firstOperandIndex,10
    JE AND_AL_PTR_BX1
    JMP AND_BL_PTR_BX
    AND_AL_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,0
    CALL ANDAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;AND BL,PTR_BX
    AND_BL_PTR_BX:
    CMP firstOperandIndex,12
    JE AND_BL_PTR_BX1
    JMP AND_CL_PTR_BX
    AND_BL_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,2
    CALL ANDAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;AND CL,PTR_BX
    AND_CL_PTR_BX:
    CMP firstOperandIndex,14
    JE AND_CL_PTR_BX1
    JMP AND_DL_PTR_BX
    AND_CL_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL ANDAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;AND DL,PTR_BX
    AND_DL_PTR_BX:
    CMP firstOperandIndex,16
    JE AND_DL_PTR_BX1
    JMP NOTAVAILIDCOMMAND
    AND_DL_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,6
    CALL ANDAByteRegWithPointer
    JMP ENDEXECUTE
    
    
    AND_PTR_NUM_SOURCE:
    ;========================
    ;AND destination with no bracket,[NUM]
    AND_PTR_NUM_SOURCE:
    CMP secondOperandIndex,17
    JE AND_PTR_NUM_SOURCE1
    JMP NOTAVAILIDCOMMAND
    AND_PTR_NUM_SOURCE1:
    
    ;AND AX,PTR_NUM
    AND_AX_PTR_NUM:
    CMP firstOperandIndex,1
    JE AND_AX_PTR_NUM1
    JMP AND_BX_PTR_NUM
    AND_AX_PTR_NUM1:
    MOV addedValueToSIDest,0
    CALL ANDAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;AND BX,PTR_NUM
    AND_BX_PTR_NUM:
    CMP firstOperandIndex,2
    JE AND_BX_PTR_NUM1
    JMP AND_CX_PTR_NUM
    AND_BX_PTR_NUM1:
    MOV addedValueToSIDest,1
    CALL ANDAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;AND CX,PTR_NUM
    AND_CX_PTR_NUM:
    CMP firstOperandIndex,3
    JE AND_CX_PTR_NUM1
    JMP AND_DX_PTR_NUM
    AND_CX_PTR_NUM1:
    MOV addedValueToSIDest,2
    CALL ANDAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;AND DX,PTR_NUM
    AND_DX_PTR_NUM:
    CMP firstOperandIndex,4
    JE AND_DX_PTR_NUM1
    JMP AND_SI_PTR_NUM
    AND_DX_PTR_NUM1:
    MOV addedValueToSIDest,3
    CALL ANDAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;AND SI,PTR_NUM
    AND_SI_PTR_NUM:
    CMP firstOperandIndex,5
    JE AND_SI_PTR_NUM1
    JMP AND_DI_PTR_NUM
    AND_SI_PTR_NUM1:
    MOV addedValueToSIDest,4
    CALL ANDAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;AND DI,PTR_NUM
    AND_DI_PTR_NUM:
    CMP firstOperandIndex,6
    JE AND_DI_PTR_NUM1
    JMP AND_SP_PTR_NUM
    AND_DI_PTR_NUM1:
    MOV addedValueToSIDest,5
    CALL ANDAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;AND SP,PTR_NUM
    AND_SP_PTR_NUM:
    CMP firstOperandIndex,7
    JE AND_SP_PTR_NUM1
    JMP AND_BP_PTR_NUM
    AND_SP_PTR_NUM1:
    MOV addedValueToSIDest,6
    CALL ANDAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;AND BP,PTR_NUM
    AND_BP_PTR_NUM:
    CMP firstOperandIndex,7
    JE AND_BP_PTR_NUM1
    JMP AND_AH_PTR_NUM
    AND_BP_PTR_NUM1:
    MOV addedValueToSIDest,7
    CALL ANDAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;AND AH,PTR_NUM
    AND_AH_PTR_NUM:
    CMP firstOperandIndex,9
    JE AND_AH_PTR_NUM1
    JMP AND_BH_PTR_NUM
    AND_AH_PTR_NUM1:
    MOV addedValueToSIDest,1
    CALL ANDAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;AND BH,PTR_NUM
    AND_BH_PTR_NUM:
    CMP firstOperandIndex,11
    JE AND_BH_PTR_NUM1
    JMP AND_CH_PTR_NUM
    AND_BH_PTR_NUM1:
    MOV addedValueToSIDest,3
    CALL ANDAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;AND CH,PTR_NUM
    AND_CH_PTR_NUM:
    CMP firstOperandIndex,13
    JE AND_CH_PTR_NUM1
    JMP AND_DH_PTR_NUM
    AND_CH_PTR_NUM1:
    MOV addedValueToSIDest,5
    CALL ANDAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;AND DH,PTR_NUM
    AND_DH_PTR_NUM:
    CMP firstOperandIndex,15
    JE AND_DH_PTR_NUM1
    JMP AND_AL_PTR_NUM
    AND_DH_PTR_NUM1:
    MOV addedValueToSIDest,7
    CALL ANDAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;AND AL,PTR_NUM
    AND_AL_PTR_NUM:
    CMP firstOperandIndex,10
    JE AND_AL_PTR_NUM1
    JMP AND_BL_PTR_NUM
    AND_AL_PTR_NUM1:
    MOV addedValueToSIDest,0
    CALL ANDAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;AND BL,PTR_NUM
    AND_BL_PTR_NUM:
    CMP firstOperandIndex,12
    JE AND_BL_PTR_NUM1
    JMP AND_CL_PTR_NUM
    AND_BL_PTR_NUM1:
    MOV addedValueToSIDest,2
    CALL ANDAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;AND CL,PTR_NUM
    AND_CL_PTR_NUM:
    CMP firstOperandIndex,14
    JE AND_CL_PTR_NUM1
    JMP AND_DL_PTR_NUM
    AND_CL_PTR_NUM1:
    MOV addedValueToSIDest,4
    CALL ANDAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;AND DL,PTR_NUM
    AND_DL_PTR_NUM:
    CMP firstOperandIndex,16
    JE AND_DL_PTR_NUM1
    JMP NOTAVAILIDCOMMAND
    AND_DL_PTR_NUM1:
    MOV addedValueToSIDest,6
    CALL ANDAByteRegWithMemory
    JMP ENDEXECUTE
    
    
    ANDCOMMAND14:
    ;1nd operand has bracket 
    CMP isFirstOpBracket,1
    JE ANDCOMMAND15
    JMP ANDCOMMAND16
    ANDCOMMAND15:
    
    ;========================
    ;AND [SI],Source with no bracket
    AND_PTR_SI_DEST:
    CMP firstOperandIndex,5
    JE AND_PTR_SI_DEST1
    JMP AND_PTR_DI_DEST
    AND_PTR_SI_DEST1:
    
    ;AND PTR_SI,AX
    AND_PTR_SI_AX:
    CMP secondOperandIndex,1
    JE AND_PTR_SI_AX1
    JMP AND_PTR_SI_BX
    AND_PTR_SI_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,4
    CALL ANDAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND PTR_SI,BX
    AND_PTR_SI_BX:
    CMP secondOperandIndex,2
    JE AND_PTR_SI_BX1
    JMP AND_PTR_SI_CX
    AND_PTR_SI_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,4
    CALL ANDAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND PTR_SI,CX
    AND_PTR_SI_CX:
    CMP secondOperandIndex,3
    JE AND_PTR_SI_CX1
    JMP AND_PTR_SI_DX
    AND_PTR_SI_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,4
    CALL ANDAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND PTR_SI,DX
    AND_PTR_SI_DX:
    CMP secondOperandIndex,4
    JE AND_PTR_SI_DX1
    JMP AND_PTR_SI_SI
    AND_PTR_SI_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,4
    CALL ANDAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND PTR_SI,SI
    AND_PTR_SI_SI:
    CMP secondOperandIndex,5
    JE AND_PTR_SI_SI1
    JMP AND_PTR_SI_DI
    AND_PTR_SI_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL ANDAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND PTR_SI,DI
    AND_PTR_SI_DI:
    CMP secondOperandIndex,6
    JE AND_PTR_SI_DI1
    JMP AND_PTR_SI_SP
    AND_PTR_SI_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,4
    CALL ANDAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND PTR_SI,SP
    AND_PTR_SI_SP:
    CMP secondOperandIndex,7
    JE AND_PTR_SI_SP1
    JMP AND_PTR_SI_BP
    AND_PTR_SI_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,4
    CALL ANDAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND PTR_SI,BP
    AND_PTR_SI_BP:
    CMP secondOperandIndex,7
    JE AND_PTR_SI_BP1
    JMP AND_PTR_SI_AH
    AND_PTR_SI_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,4
    CALL ANDAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND PTR_SI,AH
    AND_PTR_SI_AH:
    CMP secondOperandIndex,9
    JE AND_PTR_SI_AH1
    JMP AND_PTR_SI_BH
    AND_PTR_SI_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,4
    CALL ANDAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND PTR_SI,BH
    AND_PTR_SI_BH:
    CMP secondOperandIndex,11
    JE AND_PTR_SI_BH1
    JMP AND_PTR_SI_CH
    AND_PTR_SI_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,4
    CALL ANDAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND PTR_SI,CH
    AND_PTR_SI_CH:
    CMP secondOperandIndex,13
    JE AND_PTR_SI_CH1
    JMP AND_PTR_SI_DH
    AND_PTR_SI_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,4
    CALL ANDAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND PTR_SI,DH
    AND_PTR_SI_DH:
    CMP secondOperandIndex,15
    JE AND_PTR_SI_DH1
    JMP AND_PTR_SI_AL
    AND_PTR_SI_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,4
    CALL ANDAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND PTR_SI,AL
    AND_PTR_SI_AL:
    CMP secondOperandIndex,10
    JE AND_PTR_SI_AL1
    JMP AND_PTR_SI_BL
    AND_PTR_SI_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,4
    CALL ANDAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND PTR_SI,BL
    AND_PTR_SI_BL:
    CMP secondOperandIndex,12
    JE AND_PTR_SI_BL1
    JMP AND_PTR_SI_CL
    AND_PTR_SI_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,4
    CALL ANDAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND PTR_SI,CL
    AND_PTR_SI_CL:
    CMP secondOperandIndex,14
    JE AND_PTR_SI_CL1
    JMP AND_PTR_SI_DL
    AND_PTR_SI_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL ANDAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND PTR_SI,DL
    AND_PTR_SI_DL:
    CMP secondOperandIndex,16
    JE AND_PTR_SI_DL1
    JMP AND_PTR_SI_NUM
    AND_PTR_SI_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,4
    CALL ANDAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND PTR_SI,NUM
    AND_PTR_SI_NUM:
    CMP secondOperandIndex,17
    JE AND_PTR_SI_NUM1
    JMP NOTAVAILIDCOMMAND
    AND_PTR_SI_NUM1:
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,4
    CALL ANDAPointerRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;AND [DI],Source with no bracket
    AND_PTR_DI_DEST:
    CMP firstOperandIndex,6
    JE AND_PTR_DI_DEST1
    JMP AND_PTR_BX_DEST
    AND_PTR_DI_DEST1:
    
    ;AND PTR_DI,AX
    AND_PTR_DI_AX:
    CMP secondOperandIndex,1
    JE AND_PTR_DI_AX1
    JMP AND_PTR_DI_BX
    AND_PTR_DI_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,5
    CALL ANDAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND PTR_DI,BX
    AND_PTR_DI_BX:
    CMP secondOperandIndex,2
    JE AND_PTR_DI_BX1
    JMP AND_PTR_DI_CX
    AND_PTR_DI_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,5
    CALL ANDAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND PTR_DI,CX
    AND_PTR_DI_CX:
    CMP secondOperandIndex,3
    JE AND_PTR_DI_CX1
    JMP AND_PTR_DI_DX
    AND_PTR_DI_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,5
    CALL ANDAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND PTR_DI,DX
    AND_PTR_DI_DX:
    CMP secondOperandIndex,4
    JE AND_PTR_DI_DX1
    JMP AND_PTR_DI_SI
    AND_PTR_DI_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,5
    CALL ANDAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND PTR_DI,SI
    AND_PTR_DI_SI:
    CMP secondOperandIndex,5
    JE AND_PTR_DI_SI1
    JMP AND_PTR_DI_DI
    AND_PTR_DI_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL ANDAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND PTR_DI,DI
    AND_PTR_DI_DI:
    CMP secondOperandIndex,6
    JE AND_PTR_DI_DI1
    JMP AND_PTR_DI_SP
    AND_PTR_DI_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,5
    CALL ANDAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND PTR_DI,SP
    AND_PTR_DI_SP:
    CMP secondOperandIndex,7
    JE AND_PTR_DI_SP1
    JMP AND_PTR_DI_BP
    AND_PTR_DI_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,5
    CALL ANDAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND PTR_DI,BP
    AND_PTR_DI_BP:
    CMP secondOperandIndex,7
    JE AND_PTR_DI_BP1
    JMP AND_PTR_DI_BH
    AND_PTR_DI_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,5
    CALL ANDAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND PTR_DI,AH
    AND_PTR_DI_AH:
    CMP secondOperandIndex,9
    JE AND_PTR_DI_AH1
    JMP AND_PTR_DI_BH
    AND_PTR_DI_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,5
    CALL ANDAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND PTR_DI,BH
    AND_PTR_DI_BH:
    CMP secondOperandIndex,11
    JE AND_PTR_DI_BH1
    JMP AND_PTR_DI_CH
    AND_PTR_DI_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,5
    CALL ANDAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND PTR_DI,CH
    AND_PTR_DI_CH:
    CMP secondOperandIndex,13
    JE AND_PTR_DI_CH1
    JMP AND_PTR_DI_DH
    AND_PTR_DI_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,5
    CALL ANDAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND PTR_DI,DH
    AND_PTR_DI_DH:
    CMP secondOperandIndex,15
    JE AND_PTR_DI_DH1
    JMP AND_PTR_DI_AL
    AND_PTR_DI_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,5
    CALL ANDAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND PTR_DI,AL
    AND_PTR_DI_AL:
    CMP secondOperandIndex,10
    JE AND_PTR_DI_AL1
    JMP AND_PTR_DI_BL
    AND_PTR_DI_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,5
    CALL ANDAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND PTR_DI,BL
    AND_PTR_DI_BL:
    CMP secondOperandIndex,12
    JE AND_PTR_DI_BL1
    JMP AND_PTR_DI_CL
    AND_PTR_DI_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,5
    CALL ANDAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND PTR_DI,CL
    AND_PTR_DI_CL:
    CMP secondOperandIndex,14
    JE AND_PTR_DI_CL1
    JMP AND_PTR_DI_DL
    AND_PTR_DI_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL ANDAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND PTR_DI,DL
    AND_PTR_DI_DL:
    CMP secondOperandIndex,16
    JE AND_PTR_DI_DL1
    JMP AND_PTR_DI_NUM
    AND_PTR_DI_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,5
    CALL ANDAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND PTR_DI,NUM
    AND_PTR_DI_NUM:
    CMP secondOperandIndex,17
    JE AND_PTR_DI_NUM1
    JMP NOTAVAILIDCOMMAND
    AND_PTR_DI_NUM1:
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,5
    CALL ANDAPointerRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;AND [BX],Source with no bracket
    AND_PTR_BX_DEST:
    CMP firstOperandIndex,2
    JE AND_PTR_BX_DEST1
    JMP NOTAVAILIDCOMMAND
    AND_PTR_BX_DEST1:
    
    ;AND PTR_BX,AX
    AND_PTR_BX_AX:
    CMP secondOperandIndex,1
    JE AND_PTR_BX_AX1
    JMP AND_PTR_BX_BX
    AND_PTR_BX_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,1
    CALL ANDAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND PTR_BX,BX
    AND_PTR_BX_BX:
    CMP secondOperandIndex,2
    JE AND_PTR_BX_BX1
    JMP AND_PTR_BX_CX
    AND_PTR_BX_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,1
    CALL ANDAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND PTR_BX,CX
    AND_PTR_BX_CX:
    CMP secondOperandIndex,3
    JE AND_PTR_BX_CX1
    JMP AND_PTR_BX_DX
    AND_PTR_BX_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,1
    CALL ANDAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND PTR_BX,DX
    AND_PTR_BX_DX:
    CMP secondOperandIndex,4
    JE AND_PTR_BX_DX1
    JMP AND_PTR_BX_SI
    AND_PTR_BX_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,1
    CALL ANDAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND PTR_BX,SI
    AND_PTR_BX_SI:
    CMP secondOperandIndex,5
    JE AND_PTR_BX_SI1
    JMP AND_PTR_BX_DI
    AND_PTR_BX_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL ANDAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND PTR_BX,DI
    AND_PTR_BX_DI:
    CMP secondOperandIndex,6
    JE AND_PTR_BX_DI1
    JMP AND_PTR_BX_SP
    AND_PTR_BX_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,1
    CALL ANDAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND PTR_BX,SP
    AND_PTR_BX_SP:
    CMP secondOperandIndex,7
    JE AND_PTR_BX_SP1
    JMP AND_PTR_BX_BP
    AND_PTR_BX_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,1
    CALL ANDAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND PTR_BX,BP
    AND_PTR_BX_BP:
    CMP secondOperandIndex,7
    JE AND_PTR_BX_BP1
    JMP AND_PTR_BX_AH
    
    AND_PTR_BX_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,1
    CALL ANDAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND PTR_BX,AH
    AND_PTR_BX_AH:
    CMP secondOperandIndex,9
    JE AND_PTR_BX_AH1
    JMP AND_PTR_BX_BH
    AND_PTR_BX_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,1
    CALL ANDAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND PTR_BX,BH
    AND_PTR_BX_BH:
    CMP secondOperandIndex,11
    JE AND_PTR_BX_BH1
    JMP AND_PTR_BX_CH
    AND_PTR_BX_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,1
    CALL ANDAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND PTR_BX,CH
    AND_PTR_BX_CH:
    CMP secondOperandIndex,13
    JE AND_PTR_BX_CH1
    JMP AND_PTR_BX_DH
    AND_PTR_BX_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,1
    CALL ANDAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND PTR_BX,DH
    AND_PTR_BX_DH:
    CMP secondOperandIndex,15
    JE AND_PTR_BX_DH1
    JMP AND_PTR_BX_AL
    AND_PTR_BX_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,1
    CALL ANDAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND PTR_BX,AL
    AND_PTR_BX_AL:
    CMP secondOperandIndex,10
    JE AND_PTR_BX_AL1
    JMP AND_PTR_BX_BL
    AND_PTR_BX_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,1
    CALL ANDAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND PTR_BX,BL
    AND_PTR_BX_BL:
    CMP secondOperandIndex,12
    JE AND_PTR_BX_BL1
    JMP AND_PTR_BX_CL
    AND_PTR_BX_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,1
    CALL ANDAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND PTR_BX,CL
    AND_PTR_BX_CL:
    CMP secondOperandIndex,14
    JE AND_PTR_BX_CL1
    JMP AND_PTR_BX_DL
    AND_PTR_BX_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL ANDAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND PTR_BX,DL
    AND_PTR_BX_DL:
    CMP secondOperandIndex,16
    JE AND_PTR_BX_DL1
    JMP AND_PTR_BX_NUM
    AND_PTR_BX_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,1
    CALL ANDAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND PTR_BX,NUM
    AND_PTR_BX_NUM:
    CMP secondOperandIndex,17
    JE AND_PTR_BX_NUM1
    JMP NOTAVAILIDCOMMAND
    AND_PTR_BX_NUM1:
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,1
    CALL ANDAPointerRegWithNUM
    JMP ENDEXECUTE
    
    ANDCOMMAND16:
    ;neither operand has bracket
    ;========================
    ;AND AX,Source with no bracket
    AND_AX1:
    CMP firstOperandIndex,1
    JE AND_AX2
    JMP AND_BX1
    AND_AX2:
    
    ;AND AX,AX
    AND_AX_AX:
    CMP secondOperandIndex,1
    JE AND_AX_AX1
    JMP AND_AX_BX
    AND_AX_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,0
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND AX,BX
    AND_AX_BX:
    CMP secondOperandIndex,2
    JE AND_AX_BX1
    JMP AND_AX_CX
    AND_AX_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,0
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND AX,CX
    AND_AX_CX:
    CMP secondOperandIndex,3
    JE AND_AX_CX1
    JMP AND_AX_DX
    AND_AX_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,0
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND AX,DX
    AND_AX_DX:
    CMP secondOperandIndex,4
    JE AND_AX_DX1
    JMP AND_AX_SI
    AND_AX_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,0
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND AX,SI
    AND_AX_SI:
    CMP secondOperandIndex,5
    JE AND_AX_SI1
    JMP AND_AX_DI
    AND_AX_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,0
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND AX,DI
    AND_AX_DI:
    CMP secondOperandIndex,6
    JE AND_AX_DI1
    JMP AND_AX_SP
    AND_AX_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,0
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND AX,SP
    AND_AX_SP:
    CMP secondOperandIndex,7
    JE AND_AX_SP1
    JMP AND_AX_BP
    AND_AX_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,0
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND AX,BP
    AND_AX_BP:
    CMP secondOperandIndex,7
    JE AND_AX_BP1
    JMP AND_AX_NUM
    AND_AX_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,0
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND AX,NUM
    AND_AX_NUM:
    CMP secondOperandIndex,17
    JE AND_AX_NUM1
    JMP NOTAVAILIDCOMMAND
    AND_AX_NUM1:
    MOV addedValueToSIDest,0
    CALL ANDAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;AND BX,Source with no bracket    
    AND_BX1:
    CMP firstOperandIndex,2
    JE AND_BX2
    JMP AND_CX1
    AND_BX2:
    
    ;AND BX,AX
    AND_BX_AX:
    CMP secondOperandIndex,1
    JE AND_BX_AX1
    JMP AND_BX_BX
    AND_BX_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,1
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND BX,BX
    AND_BX_BX:
    CMP secondOperandIndex,2
    JE AND_BX_BX1
    JMP AND_BX_CX
    AND_BX_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,1
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND BX,CX
    AND_BX_CX:
    CMP secondOperandIndex,3
    JE AND_BX_CX1
    JMP AND_BX_DX
    AND_BX_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,1
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND BX,DX
    AND_BX_DX:
    CMP secondOperandIndex,4
    JE AND_BX_DX1
    JMP AND_BX_SI
    AND_BX_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,1
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND BX,SI
    AND_BX_SI:
    CMP secondOperandIndex,5
    JE AND_BX_SI1
    JMP AND_BX_DI
    AND_BX_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND BX,DI
    AND_BX_DI:
    CMP secondOperandIndex,6
    JE AND_BX_DI1
    JMP AND_BX_SP
    AND_BX_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,1
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND BX,SP
    AND_BX_SP:
    CMP secondOperandIndex,7
    JE AND_BX_SP1
    JMP AND_BX_BP
    AND_BX_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,1
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND BX,BP
    AND_BX_BP:
    CMP secondOperandIndex,7
    JE AND_BX_BP1
    JMP AND_BX_NUM
    AND_BX_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,1
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND BX,NUM
    AND_BX_NUM:
    CMP secondOperandIndex,17
    JE AND_BX_NUM1
    JMP NOTAVAILIDCOMMAND
    AND_BX_NUM1:
    MOV addedValueToSIDest,1
    CALL ANDAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;AND CX,Source with no bracket
    AND_CX1:
    CMP firstOperandIndex,3
    JE AND_CX2
    JMP AND_DX1
    AND_CX2:
    
    ;AND CX,AX
    AND_CX_AX:
    CMP secondOperandIndex,1
    JE AND_CX_AX1
    JMP AND_CX_BX
    AND_CX_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,2
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND CX,BX
    AND_CX_BX:
    CMP secondOperandIndex,2
    JE AND_CX_BX1
    JMP AND_CX_CX
    AND_CX_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,2
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND CX,CX
    AND_CX_CX:
    CMP secondOperandIndex,3
    JE AND_CX_CX1
    JMP AND_CX_DX
    AND_CX_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,2
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND CX,DX
    AND_CX_DX:
    CMP secondOperandIndex,4
    JE AND_CX_DX1
    JMP AND_CX_SI
    AND_CX_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,2
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND CX,SI
    AND_CX_SI:
    CMP secondOperandIndex,5
    JE AND_CX_SI1
    JMP AND_CX_DI
    AND_CX_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,2
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND CX,DI
    AND_CX_DI:
    CMP secondOperandIndex,6
    JE AND_CX_DI1
    JMP AND_CX_SP
    AND_CX_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,2
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND CX,SP
    AND_CX_SP:
    CMP secondOperandIndex,7
    JE AND_CX_SP1
    JMP AND_CX_BP
    AND_CX_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,2
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND CX,BP
    AND_CX_BP:
    CMP secondOperandIndex,7
    JE AND_CX_BP1
    JMP AND_CX_NUM
    AND_CX_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,2
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND CX,NUM
    AND_CX_NUM:
    CMP secondOperandIndex,17
    JE AND_CX_NUM1
    JMP NOTAVAILIDCOMMAND
    AND_CX_NUM1:
    MOV addedValueToSIDest,2
    CALL ANDAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;AND DX,Source with no bracket
    AND_DX1:
    CMP firstOperandIndex,4
    JE AND_DX2
    JMP AND_SI1
    AND_DX2:
    
    ;AND DX,AX
    AND_DX_AX:
    CMP secondOperandIndex,1
    JE AND_DX_AX1
    JMP AND_DX_BX
    AND_DX_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,3
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND DX,BX
    AND_DX_BX:
    CMP secondOperandIndex,2
    JE AND_DX_BX1
    JMP AND_DX_CX
    AND_DX_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,3
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND DX,CX
    AND_DX_CX:
    CMP secondOperandIndex,3
    JE AND_DX_CX1
    JMP AND_DX_DX
    AND_DX_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,3
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND DX,DX
    AND_DX_DX:
    CMP secondOperandIndex,4
    JE AND_DX_DX1
    JMP AND_DX_SI
    AND_DX_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,3
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND DX,SI
    AND_DX_SI:
    CMP secondOperandIndex,5
    JE AND_DX_SI1
    JMP AND_DX_DI
    AND_DX_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,3
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND DX,DI
    AND_DX_DI:
    CMP secondOperandIndex,6
    JE AND_DX_DI1
    JMP AND_DX_SP
    AND_DX_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,3
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND DX,SP
    AND_DX_SP:
    CMP secondOperandIndex,7
    JE AND_DX_SP1
    JMP AND_DX_BP
    AND_DX_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,3
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND DX,BP
    AND_DX_BP:
    CMP secondOperandIndex,7
    JE AND_DX_BP1
    JMP AND_DX_NUM
    AND_DX_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,3
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND DX,NUM
    AND_DX_NUM:
    CMP secondOperandIndex,17
    JE AND_DX_NUM1
    JMP NOTAVAILIDCOMMAND
    AND_DX_NUM1:
    MOV addedValueToSIDest,3
    CALL ANDAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;AND SI,Source with no bracket
    AND_SI1:
    CMP firstOperandIndex,5
    JE AND_SI2
    JMP AND_DI1
    AND_SI2:
    
    ;AND SI,AX
    AND_SI_AX:
    CMP secondOperandIndex,1
    JE AND_SI_AX1
    JMP AND_SI_BX
    AND_SI_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,4
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND SI,BX
    AND_SI_BX:
    CMP secondOperandIndex,2
    JE AND_SI_BX1
    JMP AND_SI_CX
    AND_SI_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,4
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND SI,CX
    AND_SI_CX:
    CMP secondOperandIndex,3
    JE AND_SI_CX1
    JMP AND_SI_DX
    AND_SI_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,4
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND SI,DX
    AND_SI_DX:
    CMP secondOperandIndex,4
    JE AND_SI_DX1
    JMP AND_SI_SI
    AND_SI_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,4
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND SI,SI
    AND_SI_SI:
    CMP secondOperandIndex,5
    JE AND_SI_SI1
    JMP AND_SI_DI
    AND_SI_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND SI,DI
    AND_SI_DI:
    CMP secondOperandIndex,6
    JE AND_SI_DI1
    JMP AND_SI_SP
    AND_SI_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,4
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND SI,SP
    AND_SI_SP:
    CMP secondOperandIndex,7
    JE AND_SI_SP1
    JMP AND_SI_BP
    AND_SI_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,4
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND SI,BP
    AND_SI_BP:
    CMP secondOperandIndex,7
    JE AND_SI_BP1
    JMP AND_SI_NUM
    AND_SI_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,4
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND SI,NUM
    AND_SI_NUM:
    CMP secondOperandIndex,17
    JE AND_SI_NUM1
    JMP NOTAVAILIDCOMMAND
    AND_SI_NUM1:
    MOV addedValueToSIDest,4
    CALL ANDAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;AND DI,Source with no bracket
    AND_DI1:
    CMP firstOperandIndex,6
    JE AND_DI2
    JMP AND_SP1
    AND_DI2:
    
    ;AND DI,AX
    AND_DI_AX:
    CMP secondOperandIndex,1
    JE AND_DI_AX1
    JMP AND_DI_BX
    AND_DI_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,5
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND DI,BX
    AND_DI_BX:
    CMP secondOperandIndex,2
    JE AND_DI_BX1
    JMP AND_DI_CX
    AND_DI_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,5
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND DI,CX
    AND_DI_CX:
    CMP secondOperandIndex,3
    JE AND_DI_CX1
    JMP AND_DI_DX
    AND_DI_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,5
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND DI,DX
    AND_DI_DX:
    CMP secondOperandIndex,4
    JE AND_DI_DX1
    JMP AND_DI_SI
    AND_DI_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,5
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND DI,SI
    AND_DI_SI:
    CMP secondOperandIndex,5
    JE AND_DI_SI1
    JMP AND_DI_DI
    AND_DI_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND DI,DI
    AND_DI_DI:
    CMP secondOperandIndex,6
    JE AND_DI_DI1
    JMP AND_DI_SP
    AND_DI_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,5
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND DI,SP
    AND_DI_SP:
    CMP secondOperandIndex,7
    JE AND_DI_SP1
    JMP AND_DI_BP
    AND_DI_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,5
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND DI,BP
    AND_DI_BP:
    CMP secondOperandIndex,7
    JE AND_DI_BP1
    JMP AND_DI_NUM
    AND_DI_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,5
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND DI,NUM
    AND_DI_NUM:
    CMP secondOperandIndex,17
    JE AND_DI_NUM1
    JMP NOTAVAILIDCOMMAND
    AND_DI_NUM1:
    MOV addedValueToSIDest,5
    CALL ANDAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;AND SP,Source with no bracket
    AND_SP1:
    CMP firstOperandIndex,7
    JE AND_SP2
    JMP AND_BP1
    AND_SP2:
    
    ;AND SP,AX
    AND_SP_AX:
    CMP secondOperandIndex,1
    JE AND_SP_AX1
    JMP AND_SP_BX
    AND_SP_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,6
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND SP,BX
    AND_SP_BX:
    CMP secondOperandIndex,2
    JE AND_SP_BX1
    JMP AND_SP_CX
    AND_SP_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,6
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND SP,CX
    AND_SP_CX:
    CMP secondOperandIndex,3
    JE AND_SP_CX1
    JMP AND_SP_DX
    AND_SP_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,6
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND SP,DX
    AND_SP_DX:
    CMP secondOperandIndex,4
    JE AND_SP_DX1
    JMP AND_SP_SI
    AND_SP_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,6
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND SP,SI
    AND_SP_SI:
    CMP secondOperandIndex,5
    JE AND_SP_SI1
    JMP AND_SP_DI
    AND_SP_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,6
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND SP,DI
    AND_SP_DI:
    CMP secondOperandIndex,6
    JE AND_SP_DI1
    JMP AND_SP_SP
    AND_SP_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,6
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND SP,SP
    AND_SP_SP:
    CMP secondOperandIndex,7
    JE AND_SP_SP1
    JMP AND_SP_BP
    AND_SP_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,6
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND SP,BP
    AND_SP_BP:
    CMP secondOperandIndex,7
    JE AND_SP_BP1
    JMP AND_SP_NUM
    AND_SP_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,6
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND SP,NUM
    AND_SP_NUM:
    CMP secondOperandIndex,17
    JE AND_SP_NUM1
    JMP NOTAVAILIDCOMMAND
    AND_SP_NUM1:
    MOV addedValueToSIDest,6
    CALL ANDAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;AND BP,Source with no bracket
    AND_BP1:
    CMP firstOperandIndex,8
    JE AND_BP2
    JMP AND_AH1
    AND_BP2:
    
    ;AND BP,AX
    AND_BP_AX:
    CMP secondOperandIndex,1
    JE AND_BP_AX1
    JMP AND_BP_BX
    AND_BP_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,7
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND BP,BX
    AND_BP_BX:
    CMP secondOperandIndex,2
    JE AND_BP_BX1
    JMP AND_BP_CX
    AND_BP_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,7
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND BP,CX
    AND_BP_CX:
    CMP secondOperandIndex,3
    JE AND_BP_CX1
    JMP AND_BP_DX
    AND_BP_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,7
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND BP,DX
    AND_BP_DX:
    CMP secondOperandIndex,4
    JE AND_BP_DX1
    JMP AND_BP_SI
    AND_BP_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,7
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND BP,SI
    AND_BP_SI:
    CMP secondOperandIndex,5
    JE AND_BP_SI1
    JMP AND_BP_DI
    AND_BP_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,7
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND BP,DI
    AND_BP_DI:
    CMP secondOperandIndex,6
    JE AND_BP_DI1
    JMP AND_BP_SP
    AND_BP_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,7
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND BP,SP
    AND_BP_SP:
    CMP secondOperandIndex,7
    JE AND_BP_SP1
    JMP AND_BP_BP
    AND_BP_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,7
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND BP,BP
    AND_BP_BP:
    CMP secondOperandIndex,7
    JE AND_BP_BP1
    JMP AND_BP_NUM
    AND_BP_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,7
    CALL ANDAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;AND BP,NUM
    AND_BP_NUM:
    CMP secondOperandIndex,17
    JE AND_BP_NUM1
    JMP NOTAVAILIDCOMMAND
    AND_BP_NUM1:
    MOV addedValueToSIDest,7
    CALL ANDAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;AND AH,Source with no bracket
    AND_AH1:
    CMP firstOperandIndex,9
    JE AND_AH2
    JMP AND_AL1
    AND_AH2:
    
    ;AND AH,AH
    AND_AH_AH:
    CMP secondOperandIndex,9
    JE AND_AH_AH1
    JMP AND_AH_BH
    AND_AH_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,1
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND AH,BH
    AND_AH_BH:
    CMP secondOperandIndex,11
    JE AND_AH_BH1
    JMP AND_AH_CH
    AND_AH_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,1
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND AH,CH
    AND_AH_CH:
    CMP secondOperandIndex,13
    JE AND_AH_CH1
    JMP AND_AH_DH
    AND_AH_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,1
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND AH,DH
    AND_AH_DH:
    CMP secondOperandIndex,15
    JE AND_AH_DH1
    JMP AND_AH_AL
    AND_AH_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,1
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND AH,AL
    AND_AH_AL:
    CMP secondOperandIndex,10
    JE AND_AH_AL1
    JMP AND_AH_BL
    AND_AH_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,1
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND AH,BL
    AND_AH_BL:
    CMP secondOperandIndex,12
    JE AND_AH_BL1
    JMP AND_AH_CL
    AND_AH_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,1
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND AH,CL
    AND_AH_CL:
    CMP secondOperandIndex,14
    JE AND_AH_CL1
    JMP AND_AH_DL
    AND_AH_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND AH,DL
    AND_AH_DL:
    CMP secondOperandIndex,16
    JE AND_AH_DL1
    JMP AND_AH_NUM
    AND_AH_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,1
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND AH,NUM
    AND_AH_NUM:
    CMP secondOperandIndex,17
    JE AND_AH_NUM1
    JMP NOTAVAILIDCOMMAND
    AND_AH_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,1
    CALL ANDAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;AND AL,Source with no bracket
    AND_AL1:
    CMP firstOperandIndex,10
    JE AND_AL2
    JMP AND_BH1
    AND_AL2:
    
        ;AND AL,AH
    AND_AL_AH:
    CMP secondOperandIndex,9
    JE AND_AL_AH1
    JMP AND_AL_BH
    AND_AL_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,0
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND AL,BH
    AND_AL_BH:
    CMP secondOperandIndex,11
    JE AND_AL_BH1
    JMP AND_AL_CH
    AND_AL_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,0
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND AL,CH
    AND_AL_CH:
    CMP secondOperandIndex,13
    JE AND_AL_CH1
    JMP AND_AL_DH
    AND_AL_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,0
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND AL,DH
    AND_AL_DH:
    CMP secondOperandIndex,15
    JE AND_AL_DH1
    JMP AND_AL_AL
    AND_AL_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,0
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND AL,AL
    AND_AL_AL:
    CMP secondOperandIndex,10
    JE AND_AL_AL1
    JMP AND_AL_BL
    AND_AL_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,0
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND AL,BL
    AND_AL_BL:
    CMP secondOperandIndex,12
    JE AND_AL_BL1
    JMP AND_AL_CL
    AND_AL_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,0
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND AL,CL
    AND_AL_CL:
    CMP secondOperandIndex,14
    JE AND_AL_CL1
    JMP AND_AL_DL
    AND_AL_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,0
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND AL,DL
    AND_AL_DL:
    CMP secondOperandIndex,16
    JE AND_AL_DL1
    JMP AND_AL_NUM
    AND_AL_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,0
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND AL,NUM
    AND_AL_NUM:
    CMP secondOperandIndex,17
    JE AND_AL_NUM1
    JMP NOTAVAILIDCOMMAND
    AND_AL_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,0
    CALL ANDAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;AND BH,Source with no bracket
    AND_BH1:
    CMP firstOperandIndex,11
    JE AND_BH2
    JMP AND_BL1
    AND_BH2:
    
    ;AND BH,AH
    AND_BH_AH:
    CMP secondOperandIndex,9
    JE AND_BH_AH1
    JMP AND_BH_BH
    AND_BH_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,3
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND BH,BH
    AND_BH_BH:
    CMP secondOperandIndex,11
    JE AND_BH_BH1
    JMP AND_BH_CH
    AND_BH_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,3
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND BH,CH
    AND_BH_CH:
    CMP secondOperandIndex,13
    JE AND_BH_CH1
    JMP AND_BH_DH
    AND_BH_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,3
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND BH,DH
    AND_BH_DH:
    CMP secondOperandIndex,15
    JE AND_BH_DH1
    JMP AND_BH_AL
    AND_BH_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,3
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND BH,AL
    AND_BH_AL:
    CMP secondOperandIndex,10
    JE AND_BH_AL1
    JMP AND_BH_BL
    AND_BH_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,3
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND BH,BL
    AND_BH_BL:
    CMP secondOperandIndex,12
    JE AND_BH_BL1
    JMP AND_BH_CL
    AND_BH_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,3
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND BH,CL
    AND_BH_CL:
    CMP secondOperandIndex,14
    JE AND_BH_CL1
    JMP AND_BH_DL
    AND_BH_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,3
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND BH,DL
    AND_BH_DL:
    CMP secondOperandIndex,16
    JE AND_BH_DL1
    JMP AND_BH_NUM
    AND_BH_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,3
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND BH,NUM
    AND_BH_NUM:
    CMP secondOperandIndex,17
    JE AND_BH_NUM1
    JMP NOTAVAILIDCOMMAND
    AND_BH_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,3
    CALL ANDAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;AND BL,Source with no bracket
    AND_BL1:
    CMP firstOperandIndex,12
    JE AND_BL2
    JMP AND_CH1
    AND_BL2:
    
    ;AND BL,AH
    AND_BL_AH:
    CMP secondOperandIndex,9
    JE AND_BL_AH1
    JMP AND_BL_BH
    AND_BL_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,2
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND BL,BH
    AND_BL_BH:
    CMP secondOperandIndex,11
    JE AND_BL_BH1
    JMP AND_BL_CH
    AND_BL_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,2
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND BL,CH
    AND_BL_CH:
    CMP secondOperandIndex,13
    JE AND_BL_CH1
    JMP AND_BL_DH
    AND_BL_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,2
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND BL,DH
    AND_BL_DH:
    CMP secondOperandIndex,15
    JE AND_BL_DH1
    JMP AND_BL_AL
    AND_BL_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,2
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND BL,AL
    AND_BL_AL:
    CMP secondOperandIndex,10
    JE AND_BL_AL1
    JMP AND_BL_BL
    AND_BL_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,2
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND BL,BL
    AND_BL_BL:
    CMP secondOperandIndex,12
    JE AND_BL_BL1
    JMP AND_BL_CL
    AND_BL_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,2
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND BL,CL
    AND_BL_CL:
    CMP secondOperandIndex,14
    JE AND_BL_CL1
    JMP AND_BL_DL
    AND_BL_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,2
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND BL,DL
    AND_BL_DL:
    CMP secondOperandIndex,16
    JE AND_BL_DL1
    JMP AND_BL_NUM
    AND_BL_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,2
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND BL,NUM
    AND_BL_NUM:
    CMP secondOperandIndex,17
    JE AND_BL_NUM1
    JMP NOTAVAILIDCOMMAND
    AND_BL_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,2
    CALL ANDAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;AND CH,Source with no bracket
    AND_CH1:
    CMP firstOperandIndex,13
    JE AND_CH2
    JMP AND_CL1
    AND_CH2:
    
    ;AND CH,AH
    AND_CH_AH:
    CMP secondOperandIndex,9
    JE AND_CH_AH1
    JMP AND_CH_BH
    AND_CH_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,5
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND CH,BH
    AND_CH_BH:
    CMP secondOperandIndex,11
    JE AND_CH_BH1
    JMP AND_CH_CH
    AND_CH_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,5
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND CH,CH
    AND_CH_CH:
    CMP secondOperandIndex,13
    JE AND_CH_CH1
    JMP AND_CH_DH
    AND_CH_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,5
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND CH,DH
    AND_CH_DH:
    CMP secondOperandIndex,15
    JE AND_CH_DH1
    JMP AND_CH_AL
    AND_CH_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,5
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND CH,AL
    AND_CH_AL:
    CMP secondOperandIndex,10
    JE AND_CH_AL1
    JMP AND_CH_BL
    AND_CH_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,5
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND CH,BL
    AND_CH_BL:
    CMP secondOperandIndex,12
    JE AND_CH_BL1
    JMP AND_CH_CL
    AND_CH_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,5
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND CH,CL
    AND_CH_CL:
    CMP secondOperandIndex,14
    JE AND_CH_CL1
    JMP AND_CH_DL
    AND_CH_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND CH,DL
    AND_CH_DL:
    CMP secondOperandIndex,16
    JE AND_CH_DL1
    JMP AND_CH_NUM
    AND_CH_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,5
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND CH,NUM
    AND_CH_NUM:
    CMP secondOperandIndex,17
    JE AND_CH_NUM1
    JMP NOTAVAILIDCOMMAND
    AND_CH_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,5
    CALL ANDAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;AND CL,Source with no bracket
    AND_CL1:
    CMP firstOperandIndex,14
    JE AND_CL2
    JMP AND_DH1
    AND_CL2:
    
    ;AND CL,AH
    AND_CL_AH:
    CMP secondOperandIndex,9
    JE AND_CL_AH1
    JMP AND_CL_BH
    AND_CL_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,4
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND CL,BH
    AND_CL_BH:
    CMP secondOperandIndex,11
    JE AND_CL_BH1
    JMP AND_CL_CH
    AND_CL_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,4
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND CL,CH
    AND_CL_CH:
    CMP secondOperandIndex,13
    JE AND_CL_CH1
    JMP AND_CL_DH
    AND_CL_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,4
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND CL,DH
    AND_CL_DH:
    CMP secondOperandIndex,15
    JE AND_CL_DH1
    JMP AND_CL_AL
    AND_CL_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,4
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND CL,AL
    AND_CL_AL:
    CMP secondOperandIndex,10
    JE AND_CL_AL1
    JMP AND_CL_BL
    AND_CL_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,4
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND CL,BL
    AND_CL_BL:
    CMP secondOperandIndex,12
    JE AND_CL_BL1
    JMP AND_CL_CL
    AND_CL_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,4
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND CL,CL
    AND_CL_CL:
    CMP secondOperandIndex,14
    JE AND_CL_CL1
    JMP AND_CL_DL
    AND_CL_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND CL,DL
    AND_CL_DL:
    CMP secondOperandIndex,16
    JE AND_CL_DL1
    JMP AND_CL_NUM
    AND_CL_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,4
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND CL,NUM
    AND_CL_NUM:
    CMP secondOperandIndex,17
    JE AND_CL_NUM1
    JMP NOTAVAILIDCOMMAND
    AND_CL_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,4
    CALL ANDAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;AND DH,Source with no bracket
    AND_DH1:
    CMP firstOperandIndex,15
    JE AND_DH2
    JMP AND_DL1
    AND_DH2:
    
    ;AND DH,AH
    AND_DH_AH:
    CMP secondOperandIndex,9
    JE AND_DH_AH1
    JMP AND_DH_BH
    AND_DH_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,7
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND DH,BH
    AND_DH_BH:
    CMP secondOperandIndex,11
    JE AND_DH_BH1
    JMP AND_DH_CH
    AND_DH_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,7
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND DH,CH
    AND_DH_CH:
    CMP secondOperandIndex,13
    JE AND_DH_CH1
    JMP AND_DH_DH
    AND_DH_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,7
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND DH,DH
    AND_DH_DH:
    CMP secondOperandIndex,15
    JE AND_DH_DH1
    JMP AND_DH_AL
    AND_DH_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,7
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND DH,AL
    AND_DH_AL:
    CMP secondOperandIndex,10
    JE AND_DH_AL1
    JMP AND_DH_BL
    AND_DH_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,7
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND DH,BL
    AND_DH_BL:
    CMP secondOperandIndex,12
    JE AND_DH_BL1
    JMP AND_DH_CL
    AND_DH_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,7
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND DH,CL
    AND_DH_CL:
    CMP secondOperandIndex,14
    JE AND_DH_CL1
    JMP AND_DH_DL
    AND_DH_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,7
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND DH,DL
    AND_DH_DL:
    CMP secondOperandIndex,16
    JE AND_DH_DL1
    JMP AND_DH_NUM
    AND_DH_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,7
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND DH,NUM
    AND_DH_NUM:
    CMP secondOperandIndex,17
    JE AND_DH_NUM1
    JMP NOTAVAILIDCOMMAND
    AND_DH_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,7
    CALL ANDAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;AND DL,Source with no bracket
    AND_DL1:
    CMP firstOperandIndex,15
    JE AND_DL2
    JMP NOTAVAILIDCOMMAND
    AND_DL2:
    
    ;AND DL,AH
    AND_DL_AH:
    CMP secondOperandIndex,9
    JE AND_DL_AH1
    JMP AND_DL_BH
    AND_DL_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,6
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND DL,BH
    AND_DL_BH:
    CMP secondOperandIndex,11
    JE AND_DL_BH1
    JMP AND_DL_CH
    AND_DL_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,6
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND DL,CH
    AND_DL_CH:
    CMP secondOperandIndex,13
    JE AND_DL_CH1
    JMP AND_DL_DH
    AND_DL_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,6
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND DL,DH
    AND_DL_DH:
    CMP secondOperandIndex,15
    JE AND_DL_DH1
    JMP AND_DL_AL
    AND_DL_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,6
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND DL,AL
    AND_DL_AL:
    CMP secondOperandIndex,10
    JE AND_DL_AL1
    JMP AND_DL_BL
    AND_DL_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,6
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND DL,BL
    AND_DL_BL:
    CMP secondOperandIndex,12
    JE AND_DL_BL1
    JMP AND_DL_CL
    AND_DL_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,6
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND DL,CL
    AND_DL_CL:
    CMP secondOperandIndex,14
    JE AND_DL_CL1
    JMP AND_DL_DL
    AND_DL_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,6
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND DL,DL
    AND_DL_DL:
    CMP secondOperandIndex,16
    JE AND_DL_DL1
    JMP AND_DL_NUM
    AND_DL_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,6
    CALL ANDAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;AND DL,NUM
    AND_DL_NUM:
    CMP secondOperandIndex,17
    JE AND_DL_NUM1
    JMP NOTAVAILIDCOMMAND
    AND_DL_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,6
    CALL ANDAByteRegWithNUM
    JMP ENDEXECUTE
    
;------------------------------------------------------------------------------------------------  
    ;this is OR command
    ORCOMMAND:
    CMP commandIndex,10
    JE ORCOMMAND1
    JMP SHRCOMMAND
    ORCOMMAND1:
    
        ;the two operand mustn't have brackets at the same time
    CMP isSecondOpBracket,1
    JE ORCOMMAND11
    JMP ORCOMMAND12
    ORCOMMAND11:
    CMP isFirstOpBracket,1
    JNE ORCOMMAND12
    JMP NOTAVAILIDCOMMAND
    
    ;Begin executing commands
    ORCOMMAND12:
    ;2nd operand has bracket 
    CMP isSecondOpBracket,1
    JE ORCOMMAND13
    JMP ORCOMMAND14
    ORCOMMAND13:
    
    ;========================
    ;OR destination with no bracket,[SI]
    OR_PTR_SI_SOURCE:
    CMP secondOperandIndex,5
    JE OR_PTR_SI_SOURCE1
    JMP OR_PTR_DI_SOURCE
    OR_PTR_SI_SOURCE1:
    
    ;OR AX,PTR_SI
    OR_AX_PTR_SI:
    CMP firstOperandIndex,1
    JE OR_AX_PTR_SI1
    JMP OR_BX_PTR_SI
    OR_AX_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,0
    CALL ORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;OR BX,PTR_SI
    OR_BX_PTR_SI:
    CMP firstOperandIndex,2
    JE OR_BX_PTR_SI1
    JMP OR_CX_PTR_SI
    OR_BX_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL ORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;OR CX,PTR_SI
    OR_CX_PTR_SI:
    CMP firstOperandIndex,3
    JE OR_CX_PTR_SI1
    JMP OR_DX_PTR_SI
    OR_CX_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,2
    CALL ORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;OR DX,PTR_SI
    OR_DX_PTR_SI:
    CMP firstOperandIndex,4
    JE OR_DX_PTR_SI1
    JMP OR_SI_PTR_SI
    OR_DX_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,3
    CALL ORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;OR SI,PTR_SI
    OR_SI_PTR_SI:
    CMP firstOperandIndex,5
    JE OR_SI_PTR_SI1
    JMP OR_DI_PTR_SI
    OR_SI_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL ORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;OR DI,PTR_SI
    OR_DI_PTR_SI:
    CMP firstOperandIndex,6
    JE OR_DI_PTR_SI1
    JMP OR_SP_PTR_SI
    OR_DI_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL ORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;OR SP,PTR_SI
    OR_SP_PTR_SI:
    CMP firstOperandIndex,7
    JE OR_SP_PTR_SI1
    JMP OR_BP_PTR_SI
    OR_SP_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,6
    CALL ORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;OR BP,PTR_SI
    OR_BP_PTR_SI:
    CMP firstOperandIndex,7
    JE OR_BP_PTR_SI1
    JMP OR_AH_PTR_SI
    OR_BP_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,7
    CALL ORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;OR AH,PTR_SI
    OR_AH_PTR_SI:
    CMP firstOperandIndex,9
    JE OR_AH_PTR_SI1
    JMP OR_BH_PTR_SI
    OR_AH_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL ORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;OR BH,PTR_SI
    OR_BH_PTR_SI:
    CMP firstOperandIndex,11
    JE OR_BH_PTR_SI1
    JMP OR_CH_PTR_SI
    OR_BH_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,3
    CALL ORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;OR CH,PTR_SI
    OR_CH_PTR_SI:
    CMP firstOperandIndex,13
    JE OR_CH_PTR_SI1
    JMP OR_DH_PTR_SI
    OR_CH_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL ORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;OR DH,PTR_SI
    OR_DH_PTR_SI:
    CMP firstOperandIndex,15
    JE OR_DH_PTR_SI1
    JMP OR_AL_PTR_SI
    OR_DH_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,7
    CALL ORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;OR AL,PTR_SI
    OR_AL_PTR_SI:
    CMP firstOperandIndex,10
    JE OR_AL_PTR_SI1
    JMP OR_BL_PTR_SI
    OR_AL_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,0
    CALL ORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;OR BL,PTR_SI
    OR_BL_PTR_SI:
    CMP firstOperandIndex,12
    JE OR_BL_PTR_SI1
    JMP OR_CL_PTR_SI
    OR_BL_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,2
    CALL ORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;OR CL,PTR_SI
    OR_CL_PTR_SI:
    CMP firstOperandIndex,14
    JE OR_CL_PTR_SI1
    JMP OR_DL_PTR_SI
    OR_CL_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL ORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;OR DL,PTR_SI
    OR_DL_PTR_SI:
    CMP firstOperandIndex,16
    JE OR_DL_PTR_SI1
    JMP NOTAVAILIDCOMMAND
    OR_DL_PTR_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,6
    CALL ORAByteRegWithPointer
    JMP ENDEXECUTE
 
    ;========================
    ;OR destination with no bracket,[DI]
    OR_PTR_DI_SOURCE:
    CMP secondOperandIndex,6
    JE OR_PTR_DI_SOURCE1
    JMP OR_PTR_BX_SOURCE
    OR_PTR_DI_SOURCE1:
    
    ;OR AX,PTR_DI
    OR_AX_PTR_DI:
    CMP firstOperandIndex,1
    JE OR_AX_PTR_DI1
    JMP OR_BX_PTR_DI
    OR_AX_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,0
    CALL ORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;OR BX,PTR_DI
    OR_BX_PTR_DI:
    CMP firstOperandIndex,2
    JE OR_BX_PTR_DI1
    JMP OR_CX_PTR_DI
    OR_BX_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,1
    CALL ORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;OR CX,PTR_DI
    OR_CX_PTR_DI:
    CMP firstOperandIndex,3
    JE OR_CX_PTR_DI1
    JMP OR_DX_PTR_DI
    OR_CX_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,2
    CALL ORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;OR DX,PTR_DI
    OR_DX_PTR_DI:
    CMP firstOperandIndex,4
    JE OR_DX_PTR_DI1
    JMP OR_SI_PTR_DI
    OR_DX_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,3
    CALL ORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;OR SI,PTR_DI
    OR_SI_PTR_DI:
    CMP firstOperandIndex,5
    JE OR_SI_PTR_DI1
    JMP OR_DI_PTR_DI
    OR_SI_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,4
    CALL ORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;OR DI,PTR_DI
    OR_DI_PTR_DI:
    CMP firstOperandIndex,6
    JE OR_DI_PTR_DI1
    JMP OR_SP_PTR_DI
    OR_DI_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,5
    CALL ORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;OR SP,PTR_DI
    OR_SP_PTR_DI:
    CMP firstOperandIndex,7
    JE OR_SP_PTR_DI1
    JMP OR_BP_PTR_DI
    OR_SP_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,6
    CALL ORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;OR BP,PTR_DI
    OR_BP_PTR_DI:
    CMP firstOperandIndex,7
    JE OR_BP_PTR_DI1
    JMP OR_AH_PTR_DI
    OR_BP_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,7
    CALL ORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;OR AH,PTR_DI
    OR_AH_PTR_DI:
    CMP firstOperandIndex,9
    JE OR_AH_PTR_DI1
    JMP OR_BH_PTR_DI
    OR_AH_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,1
    CALL ORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;OR BH,PTR_DI
    OR_BH_PTR_DI:
    CMP firstOperandIndex,11
    JE OR_BH_PTR_DI1
    JMP OR_CH_PTR_DI
    OR_BH_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,3
    CALL ORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;OR CH,PTR_DI
    OR_CH_PTR_DI:
    CMP firstOperandIndex,13
    JE OR_CH_PTR_DI1
    JMP OR_DH_PTR_DI
    OR_CH_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,5
    CALL ORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;OR DH,PTR_DI
    OR_DH_PTR_DI:
    CMP firstOperandIndex,15
    JE OR_DH_PTR_DI1
    JMP OR_AL_PTR_DI
    OR_DH_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,7
    CALL ORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;OR AL,PTR_DI
    OR_AL_PTR_DI:
    CMP firstOperandIndex,10
    JE OR_AL_PTR_DI1
    JMP OR_BL_PTR_DI
    OR_AL_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,0
    CALL ORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;OR BL,PTR_DI
    OR_BL_PTR_DI:
    CMP firstOperandIndex,12
    JE OR_BL_PTR_DI1
    JMP OR_CL_PTR_DI
    OR_BL_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,2
    CALL ORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;OR CL,PTR_DI
    OR_CL_PTR_DI:
    CMP firstOperandIndex,14
    JE OR_CL_PTR_DI1
    JMP OR_DL_PTR_DI
    OR_CL_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,4
    CALL ORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;OR DL,PTR_DI
    OR_DL_PTR_DI:
    CMP firstOperandIndex,16
    JE OR_DL_PTR_DI1
    JMP NOTAVAILIDCOMMAND
    OR_DL_PTR_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,6
    CALL ORAByteRegWithPointer
    JMP ENDEXECUTE

    ;========================
    ;OR destination with no bracket,[BX]
    OR_PTR_BX_SOURCE:
    CMP secondOperandIndex,2
    JE OR_PTR_BX_SOURCE1
    JMP OR_PTR_NUM_SOURCE
    OR_PTR_BX_SOURCE1:
    
    ;OR AX,PTR_BX
    OR_AX_PTR_BX:
    CMP firstOperandIndex,1
    JE OR_AX_PTR_BX1
    JMP OR_BX_PTR_BX
    OR_AX_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,0
    CALL ORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;OR BX,PTR_BX
    OR_BX_PTR_BX:
    CMP firstOperandIndex,2
    JE OR_BX_PTR_BX1
    JMP OR_CX_PTR_BX
    OR_BX_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL ORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;OR CX,PTR_BX
    OR_CX_PTR_BX:
    CMP firstOperandIndex,3
    JE OR_CX_PTR_BX1
    JMP OR_DX_PTR_BX
    OR_CX_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,2
    CALL ORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;OR DX,PTR_BX
    OR_DX_PTR_BX:
    CMP firstOperandIndex,4
    JE OR_DX_PTR_BX1
    JMP OR_SI_PTR_BX
    OR_DX_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,3
    CALL ORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;OR SI,PTR_BX
    OR_SI_PTR_BX:
    CMP firstOperandIndex,5
    JE OR_SI_PTR_BX1
    JMP OR_DI_PTR_BX
    OR_SI_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL ORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;OR DI,PTR_BX
    OR_DI_PTR_BX:
    CMP firstOperandIndex,6
    JE OR_DI_PTR_BX1
    JMP OR_SP_PTR_BX
    OR_DI_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL ORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;OR SP,PTR_BX
    OR_SP_PTR_BX:
    CMP firstOperandIndex,7
    JE OR_SP_PTR_BX1
    JMP OR_BP_PTR_BX
    OR_SP_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,6
    CALL ORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;OR BP,PTR_BX
    OR_BP_PTR_BX:
    CMP firstOperandIndex,7
    JE OR_BP_PTR_BX1
    JMP OR_AH_PTR_BX
    OR_BP_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,7
    CALL ORAWordRegWithPointer
    JMP ENDEXECUTE
    
    ;OR AH,PTR_BX
    OR_AH_PTR_BX:
    CMP firstOperandIndex,9
    JE OR_AH_PTR_BX1
    JMP OR_BH_PTR_BX
    OR_AH_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL ORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;OR BH,PTR_BX
    OR_BH_PTR_BX:
    CMP firstOperandIndex,11
    JE OR_BH_PTR_BX1
    JMP OR_CH_PTR_BX
    OR_BH_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,3
    CALL ORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;OR CH,PTR_BX
    OR_CH_PTR_BX:
    CMP firstOperandIndex,13
    JE OR_CH_PTR_BX1
    JMP OR_DH_PTR_BX
    OR_CH_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL ORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;OR DH,PTR_BX
    OR_DH_PTR_BX:
    CMP firstOperandIndex,15
    JE OR_DH_PTR_BX1
    JMP OR_AL_PTR_BX
    OR_DH_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,7
    CALL ORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;OR AL,PTR_BX
    OR_AL_PTR_BX:
    CMP firstOperandIndex,10
    JE OR_AL_PTR_BX1
    JMP OR_BL_PTR_BX
    OR_AL_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,0
    CALL ORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;OR BL,PTR_BX
    OR_BL_PTR_BX:
    CMP firstOperandIndex,12
    JE OR_BL_PTR_BX1
    JMP OR_CL_PTR_BX
    OR_BL_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,2
    CALL ORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;OR CL,PTR_BX
    OR_CL_PTR_BX:
    CMP firstOperandIndex,14
    JE OR_CL_PTR_BX1
    JMP OR_DL_PTR_BX
    OR_CL_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL ORAByteRegWithPointer
    JMP ENDEXECUTE
    
    ;OR DL,PTR_BX
    OR_DL_PTR_BX:
    CMP firstOperandIndex,16
    JE OR_DL_PTR_BX1
    JMP NOTAVAILIDCOMMAND
    OR_DL_PTR_BX1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,6
    CALL ORAByteRegWithPointer
    JMP ENDEXECUTE
    
    
    OR_PTR_NUM_SOURCE:
    ;========================
    ;OR destination with no bracket,[NUM]
    OR_PTR_NUM_SOURCE:
    CMP secondOperandIndex,17
    JE OR_PTR_NUM_SOURCE1
    JMP NOTAVAILIDCOMMAND
    OR_PTR_NUM_SOURCE1:
    
    ;OR AX,PTR_NUM
    OR_AX_PTR_NUM:
    CMP firstOperandIndex,1
    JE OR_AX_PTR_NUM1
    JMP OR_BX_PTR_NUM
    OR_AX_PTR_NUM1:
    MOV addedValueToSIDest,0
    CALL ORAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;OR BX,PTR_NUM
    OR_BX_PTR_NUM:
    CMP firstOperandIndex,2
    JE OR_BX_PTR_NUM1
    JMP OR_CX_PTR_NUM
    OR_BX_PTR_NUM1:
    MOV addedValueToSIDest,1
    CALL ORAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;OR CX,PTR_NUM
    OR_CX_PTR_NUM:
    CMP firstOperandIndex,3
    JE OR_CX_PTR_NUM1
    JMP OR_DX_PTR_NUM
    OR_CX_PTR_NUM1:
    MOV addedValueToSIDest,2
    CALL ORAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;OR DX,PTR_NUM
    OR_DX_PTR_NUM:
    CMP firstOperandIndex,4
    JE OR_DX_PTR_NUM1
    JMP OR_SI_PTR_NUM
    OR_DX_PTR_NUM1:
    MOV addedValueToSIDest,3
    CALL ORAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;OR SI,PTR_NUM
    OR_SI_PTR_NUM:
    CMP firstOperandIndex,5
    JE OR_SI_PTR_NUM1
    JMP OR_DI_PTR_NUM
    OR_SI_PTR_NUM1:
    MOV addedValueToSIDest,4
    CALL ORAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;OR DI,PTR_NUM
    OR_DI_PTR_NUM:
    CMP firstOperandIndex,6
    JE OR_DI_PTR_NUM1
    JMP OR_SP_PTR_NUM
    OR_DI_PTR_NUM1:
    MOV addedValueToSIDest,5
    CALL ORAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;OR SP,PTR_NUM
    OR_SP_PTR_NUM:
    CMP firstOperandIndex,7
    JE OR_SP_PTR_NUM1
    JMP OR_BP_PTR_NUM
    OR_SP_PTR_NUM1:
    MOV addedValueToSIDest,6
    CALL ORAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;OR BP,PTR_NUM
    OR_BP_PTR_NUM:
    CMP firstOperandIndex,7
    JE OR_BP_PTR_NUM1
    JMP OR_AH_PTR_NUM
    OR_BP_PTR_NUM1:
    MOV addedValueToSIDest,7
    CALL ORAWordRegWithMemory
    JMP ENDEXECUTE
    
    ;OR AH,PTR_NUM
    OR_AH_PTR_NUM:
    CMP firstOperandIndex,9
    JE OR_AH_PTR_NUM1
    JMP OR_BH_PTR_NUM
    OR_AH_PTR_NUM1:
    MOV addedValueToSIDest,1
    CALL ORAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;OR BH,PTR_NUM
    OR_BH_PTR_NUM:
    CMP firstOperandIndex,11
    JE OR_BH_PTR_NUM1
    JMP OR_CH_PTR_NUM
    OR_BH_PTR_NUM1:
    MOV addedValueToSIDest,3
    CALL ORAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;OR CH,PTR_NUM
    OR_CH_PTR_NUM:
    CMP firstOperandIndex,13
    JE OR_CH_PTR_NUM1
    JMP OR_DH_PTR_NUM
    OR_CH_PTR_NUM1:
    MOV addedValueToSIDest,5
    CALL ORAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;OR DH,PTR_NUM
    OR_DH_PTR_NUM:
    CMP firstOperandIndex,15
    JE OR_DH_PTR_NUM1
    JMP OR_AL_PTR_NUM
    OR_DH_PTR_NUM1:
    MOV addedValueToSIDest,7
    CALL ORAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;OR AL,PTR_NUM
    OR_AL_PTR_NUM:
    CMP firstOperandIndex,10
    JE OR_AL_PTR_NUM1
    JMP OR_BL_PTR_NUM
    OR_AL_PTR_NUM1:
    MOV addedValueToSIDest,0
    CALL ORAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;OR BL,PTR_NUM
    OR_BL_PTR_NUM:
    CMP firstOperandIndex,12
    JE OR_BL_PTR_NUM1
    JMP OR_CL_PTR_NUM
    OR_BL_PTR_NUM1:
    MOV addedValueToSIDest,2
    CALL ORAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;OR CL,PTR_NUM
    OR_CL_PTR_NUM:
    CMP firstOperandIndex,14
    JE OR_CL_PTR_NUM1
    JMP OR_DL_PTR_NUM
    OR_CL_PTR_NUM1:
    MOV addedValueToSIDest,4
    CALL ORAByteRegWithMemory
    JMP ENDEXECUTE
    
    ;OR DL,PTR_NUM
    OR_DL_PTR_NUM:
    CMP firstOperandIndex,16
    JE OR_DL_PTR_NUM1
    JMP NOTAVAILIDCOMMAND
    OR_DL_PTR_NUM1:
    MOV addedValueToSIDest,6
    CALL ORAByteRegWithMemory
    JMP ENDEXECUTE
    
    
    ORCOMMAND14:
    ;1nd operand has bracket 
    CMP isFirstOpBracket,1
    JE ORCOMMAND15
    JMP ORCOMMAND16
    ORCOMMAND15:
    
    ;========================
    ;OR [SI],Source with no bracket
    OR_PTR_SI_DEST:
    CMP firstOperandIndex,5
    JE OR_PTR_SI_DEST1
    JMP OR_PTR_DI_DEST
    OR_PTR_SI_DEST1:
    
    ;OR PTR_SI,AX
    OR_PTR_SI_AX:
    CMP secondOperandIndex,1
    JE OR_PTR_SI_AX1
    JMP OR_PTR_SI_BX
    OR_PTR_SI_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,4
    CALL ORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR PTR_SI,BX
    OR_PTR_SI_BX:
    CMP secondOperandIndex,2
    JE OR_PTR_SI_BX1
    JMP OR_PTR_SI_CX
    OR_PTR_SI_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,4
    CALL ORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR PTR_SI,CX
    OR_PTR_SI_CX:
    CMP secondOperandIndex,3
    JE OR_PTR_SI_CX1
    JMP OR_PTR_SI_DX
    OR_PTR_SI_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,4
    CALL ORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR PTR_SI,DX
    OR_PTR_SI_DX:
    CMP secondOperandIndex,4
    JE OR_PTR_SI_DX1
    JMP OR_PTR_SI_SI
    OR_PTR_SI_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,4
    CALL ORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR PTR_SI,SI
    OR_PTR_SI_SI:
    CMP secondOperandIndex,5
    JE OR_PTR_SI_SI1
    JMP OR_PTR_SI_DI
    OR_PTR_SI_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL ORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR PTR_SI,DI
    OR_PTR_SI_DI:
    CMP secondOperandIndex,6
    JE OR_PTR_SI_DI1
    JMP OR_PTR_SI_SP
    OR_PTR_SI_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,4
    CALL ORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR PTR_SI,SP
    OR_PTR_SI_SP:
    CMP secondOperandIndex,7
    JE OR_PTR_SI_SP1
    JMP OR_PTR_SI_BP
    OR_PTR_SI_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,4
    CALL ORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR PTR_SI,BP
    OR_PTR_SI_BP:
    CMP secondOperandIndex,7
    JE OR_PTR_SI_BP1
    JMP OR_PTR_SI_AH
    OR_PTR_SI_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,4
    CALL ORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR PTR_SI,AH
    OR_PTR_SI_AH:
    CMP secondOperandIndex,9
    JE OR_PTR_SI_AH1
    JMP OR_PTR_SI_BH
    OR_PTR_SI_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,4
    CALL ORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR PTR_SI,BH
    OR_PTR_SI_BH:
    CMP secondOperandIndex,11
    JE OR_PTR_SI_BH1
    JMP OR_PTR_SI_CH
    OR_PTR_SI_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,4
    CALL ORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR PTR_SI,CH
    OR_PTR_SI_CH:
    CMP secondOperandIndex,13
    JE OR_PTR_SI_CH1
    JMP OR_PTR_SI_DH
    OR_PTR_SI_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,4
    CALL ORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR PTR_SI,DH
    OR_PTR_SI_DH:
    CMP secondOperandIndex,15
    JE OR_PTR_SI_DH1
    JMP OR_PTR_SI_AL
    OR_PTR_SI_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,4
    CALL ORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR PTR_SI,AL
    OR_PTR_SI_AL:
    CMP secondOperandIndex,10
    JE OR_PTR_SI_AL1
    JMP OR_PTR_SI_BL
    OR_PTR_SI_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,4
    CALL ORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR PTR_SI,BL
    OR_PTR_SI_BL:
    CMP secondOperandIndex,12
    JE OR_PTR_SI_BL1
    JMP OR_PTR_SI_CL
    OR_PTR_SI_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,4
    CALL ORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR PTR_SI,CL
    OR_PTR_SI_CL:
    CMP secondOperandIndex,14
    JE OR_PTR_SI_CL1
    JMP OR_PTR_SI_DL
    OR_PTR_SI_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL ORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR PTR_SI,DL
    OR_PTR_SI_DL:
    CMP secondOperandIndex,16
    JE OR_PTR_SI_DL1
    JMP OR_PTR_SI_NUM
    OR_PTR_SI_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,4
    CALL ORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR PTR_SI,NUM
    OR_PTR_SI_NUM:
    CMP secondOperandIndex,17
    JE OR_PTR_SI_NUM1
    JMP NOTAVAILIDCOMMAND
    OR_PTR_SI_NUM1:
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,4
    CALL ORAPointerRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;OR [DI],Source with no bracket
    OR_PTR_DI_DEST:
    CMP firstOperandIndex,6
    JE OR_PTR_DI_DEST1
    JMP OR_PTR_BX_DEST
    OR_PTR_DI_DEST1:
    
    ;OR PTR_DI,AX
    OR_PTR_DI_AX:
    CMP secondOperandIndex,1
    JE OR_PTR_DI_AX1
    JMP OR_PTR_DI_BX
    OR_PTR_DI_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,5
    CALL ORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR PTR_DI,BX
    OR_PTR_DI_BX:
    CMP secondOperandIndex,2
    JE OR_PTR_DI_BX1
    JMP OR_PTR_DI_CX
    OR_PTR_DI_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,5
    CALL ORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR PTR_DI,CX
    OR_PTR_DI_CX:
    CMP secondOperandIndex,3
    JE OR_PTR_DI_CX1
    JMP OR_PTR_DI_DX
    OR_PTR_DI_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,5
    CALL ORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR PTR_DI,DX
    OR_PTR_DI_DX:
    CMP secondOperandIndex,4
    JE OR_PTR_DI_DX1
    JMP OR_PTR_DI_SI
    OR_PTR_DI_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,5
    CALL ORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR PTR_DI,SI
    OR_PTR_DI_SI:
    CMP secondOperandIndex,5
    JE OR_PTR_DI_SI1
    JMP OR_PTR_DI_DI
    OR_PTR_DI_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL ORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR PTR_DI,DI
    OR_PTR_DI_DI:
    CMP secondOperandIndex,6
    JE OR_PTR_DI_DI1
    JMP OR_PTR_DI_SP
    OR_PTR_DI_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,5
    CALL ORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR PTR_DI,SP
    OR_PTR_DI_SP:
    CMP secondOperandIndex,7
    JE OR_PTR_DI_SP1
    JMP OR_PTR_DI_BP
    OR_PTR_DI_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,5
    CALL ORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR PTR_DI,BP
    OR_PTR_DI_BP:
    CMP secondOperandIndex,7
    JE OR_PTR_DI_BP1
    JMP OR_PTR_DI_BH
    OR_PTR_DI_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,5
    CALL ORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR PTR_DI,AH
    OR_PTR_DI_AH:
    CMP secondOperandIndex,9
    JE OR_PTR_DI_AH1
    JMP OR_PTR_DI_BH
    OR_PTR_DI_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,5
    CALL ORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR PTR_DI,BH
    OR_PTR_DI_BH:
    CMP secondOperandIndex,11
    JE OR_PTR_DI_BH1
    JMP OR_PTR_DI_CH
    OR_PTR_DI_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,5
    CALL ORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR PTR_DI,CH
    OR_PTR_DI_CH:
    CMP secondOperandIndex,13
    JE OR_PTR_DI_CH1
    JMP OR_PTR_DI_DH
    OR_PTR_DI_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,5
    CALL ORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR PTR_DI,DH
    OR_PTR_DI_DH:
    CMP secondOperandIndex,15
    JE OR_PTR_DI_DH1
    JMP OR_PTR_DI_AL
    OR_PTR_DI_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,5
    CALL ORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR PTR_DI,AL
    OR_PTR_DI_AL:
    CMP secondOperandIndex,10
    JE OR_PTR_DI_AL1
    JMP OR_PTR_DI_BL
    OR_PTR_DI_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,5
    CALL ORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR PTR_DI,BL
    OR_PTR_DI_BL:
    CMP secondOperandIndex,12
    JE OR_PTR_DI_BL1
    JMP OR_PTR_DI_CL
    OR_PTR_DI_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,5
    CALL ORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR PTR_DI,CL
    OR_PTR_DI_CL:
    CMP secondOperandIndex,14
    JE OR_PTR_DI_CL1
    JMP OR_PTR_DI_DL
    OR_PTR_DI_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL ORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR PTR_DI,DL
    OR_PTR_DI_DL:
    CMP secondOperandIndex,16
    JE OR_PTR_DI_DL1
    JMP OR_PTR_DI_NUM
    OR_PTR_DI_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,5
    CALL ORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR PTR_DI,NUM
    OR_PTR_DI_NUM:
    CMP secondOperandIndex,17
    JE OR_PTR_DI_NUM1
    JMP NOTAVAILIDCOMMAND
    OR_PTR_DI_NUM1:
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,5
    CALL ORAPointerRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;OR [BX],Source with no bracket
    OR_PTR_BX_DEST:
    CMP firstOperandIndex,2
    JE OR_PTR_BX_DEST1
    JMP NOTAVAILIDCOMMAND
    OR_PTR_BX_DEST1:
    
    ;OR PTR_BX,AX
    OR_PTR_BX_AX:
    CMP secondOperandIndex,1
    JE OR_PTR_BX_AX1
    JMP OR_PTR_BX_BX
    OR_PTR_BX_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,1
    CALL ORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR PTR_BX,BX
    OR_PTR_BX_BX:
    CMP secondOperandIndex,2
    JE OR_PTR_BX_BX1
    JMP OR_PTR_BX_CX
    OR_PTR_BX_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,1
    CALL ORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR PTR_BX,CX
    OR_PTR_BX_CX:
    CMP secondOperandIndex,3
    JE OR_PTR_BX_CX1
    JMP OR_PTR_BX_DX
    OR_PTR_BX_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,1
    CALL ORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR PTR_BX,DX
    OR_PTR_BX_DX:
    CMP secondOperandIndex,4
    JE OR_PTR_BX_DX1
    JMP OR_PTR_BX_SI
    OR_PTR_BX_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,1
    CALL ORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR PTR_BX,SI
    OR_PTR_BX_SI:
    CMP secondOperandIndex,5
    JE OR_PTR_BX_SI1
    JMP OR_PTR_BX_DI
    OR_PTR_BX_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL ORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR PTR_BX,DI
    OR_PTR_BX_DI:
    CMP secondOperandIndex,6
    JE OR_PTR_BX_DI1
    JMP OR_PTR_BX_SP
    OR_PTR_BX_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,1
    CALL ORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR PTR_BX,SP
    OR_PTR_BX_SP:
    CMP secondOperandIndex,7
    JE OR_PTR_BX_SP1
    JMP OR_PTR_BX_BP
    OR_PTR_BX_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,1
    CALL ORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR PTR_BX,BP
    OR_PTR_BX_BP:
    CMP secondOperandIndex,7
    JE OR_PTR_BX_BP1
    JMP OR_PTR_BX_AH
    
    OR_PTR_BX_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,1
    CALL ORAPointerRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR PTR_BX,AH
    OR_PTR_BX_AH:
    CMP secondOperandIndex,9
    JE OR_PTR_BX_AH1
    JMP OR_PTR_BX_BH
    OR_PTR_BX_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,1
    CALL ORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR PTR_BX,BH
    OR_PTR_BX_BH:
    CMP secondOperandIndex,11
    JE OR_PTR_BX_BH1
    JMP OR_PTR_BX_CH
    OR_PTR_BX_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,1
    CALL ORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR PTR_BX,CH
    OR_PTR_BX_CH:
    CMP secondOperandIndex,13
    JE OR_PTR_BX_CH1
    JMP OR_PTR_BX_DH
    OR_PTR_BX_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,1
    CALL ORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR PTR_BX,DH
    OR_PTR_BX_DH:
    CMP secondOperandIndex,15
    JE OR_PTR_BX_DH1
    JMP OR_PTR_BX_AL
    OR_PTR_BX_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,1
    CALL ORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR PTR_BX,AL
    OR_PTR_BX_AL:
    CMP secondOperandIndex,10
    JE OR_PTR_BX_AL1
    JMP OR_PTR_BX_BL
    OR_PTR_BX_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,1
    CALL ORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR PTR_BX,BL
    OR_PTR_BX_BL:
    CMP secondOperandIndex,12
    JE OR_PTR_BX_BL1
    JMP OR_PTR_BX_CL
    OR_PTR_BX_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,1
    CALL ORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR PTR_BX,CL
    OR_PTR_BX_CL:
    CMP secondOperandIndex,14
    JE OR_PTR_BX_CL1
    JMP OR_PTR_BX_DL
    OR_PTR_BX_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL ORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR PTR_BX,DL
    OR_PTR_BX_DL:
    CMP secondOperandIndex,16
    JE OR_PTR_BX_DL1
    JMP OR_PTR_BX_NUM
    OR_PTR_BX_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,1
    CALL ORAPointerRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR PTR_BX,NUM
    OR_PTR_BX_NUM:
    CMP secondOperandIndex,17
    JE OR_PTR_BX_NUM1
    JMP NOTAVAILIDCOMMAND
    OR_PTR_BX_NUM1:
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,1
    CALL ORAPointerRegWithNUM
    JMP ENDEXECUTE
    
    ORCOMMAND16:
    ;neither operand has bracket
    ;========================
    ;OR AX,Source with no bracket
    OR_AX1:
    CMP firstOperandIndex,1
    JE OR_AX2
    JMP OR_BX1
    OR_AX2:
    
    ;OR AX,AX
    OR_AX_AX:
    CMP secondOperandIndex,1
    JE OR_AX_AX1
    JMP OR_AX_BX
    OR_AX_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,0
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR AX,BX
    OR_AX_BX:
    CMP secondOperandIndex,2
    JE OR_AX_BX1
    JMP OR_AX_CX
    OR_AX_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,0
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR AX,CX
    OR_AX_CX:
    CMP secondOperandIndex,3
    JE OR_AX_CX1
    JMP OR_AX_DX
    OR_AX_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,0
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR AX,DX
    OR_AX_DX:
    CMP secondOperandIndex,4
    JE OR_AX_DX1
    JMP OR_AX_SI
    OR_AX_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,0
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR AX,SI
    OR_AX_SI:
    CMP secondOperandIndex,5
    JE OR_AX_SI1
    JMP OR_AX_DI
    OR_AX_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,0
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR AX,DI
    OR_AX_DI:
    CMP secondOperandIndex,6
    JE OR_AX_DI1
    JMP OR_AX_SP
    OR_AX_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,0
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR AX,SP
    OR_AX_SP:
    CMP secondOperandIndex,7
    JE OR_AX_SP1
    JMP OR_AX_BP
    OR_AX_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,0
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR AX,BP
    OR_AX_BP:
    CMP secondOperandIndex,7
    JE OR_AX_BP1
    JMP OR_AX_NUM
    OR_AX_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,0
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR AX,NUM
    OR_AX_NUM:
    CMP secondOperandIndex,17
    JE OR_AX_NUM1
    JMP NOTAVAILIDCOMMAND
    OR_AX_NUM1:
    MOV addedValueToSIDest,0
    CALL ANDAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;OR BX,Source with no bracket    
    OR_BX1:
    CMP firstOperandIndex,2
    JE OR_BX2
    JMP OR_CX1
    OR_BX2:
    
    ;OR BX,AX
    OR_BX_AX:
    CMP secondOperandIndex,1
    JE OR_BX_AX1
    JMP OR_BX_BX
    OR_BX_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,1
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR BX,BX
    OR_BX_BX:
    CMP secondOperandIndex,2
    JE OR_BX_BX1
    JMP OR_BX_CX
    OR_BX_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,1
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR BX,CX
    OR_BX_CX:
    CMP secondOperandIndex,3
    JE OR_BX_CX1
    JMP OR_BX_DX
    OR_BX_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,1
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR BX,DX
    OR_BX_DX:
    CMP secondOperandIndex,4
    JE OR_BX_DX1
    JMP OR_BX_SI
    OR_BX_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,1
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR BX,SI
    OR_BX_SI:
    CMP secondOperandIndex,5
    JE OR_BX_SI1
    JMP OR_BX_DI
    OR_BX_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR BX,DI
    OR_BX_DI:
    CMP secondOperandIndex,6
    JE OR_BX_DI1
    JMP OR_BX_SP
    OR_BX_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,1
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR BX,SP
    OR_BX_SP:
    CMP secondOperandIndex,7
    JE OR_BX_SP1
    JMP OR_BX_BP
    OR_BX_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,1
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR BX,BP
    OR_BX_BP:
    CMP secondOperandIndex,7
    JE OR_BX_BP1
    JMP OR_BX_NUM
    OR_BX_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,1
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR BX,NUM
    OR_BX_NUM:
    CMP secondOperandIndex,17
    JE OR_BX_NUM1
    JMP NOTAVAILIDCOMMAND
    OR_BX_NUM1:
    MOV addedValueToSIDest,1
    CALL ORAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;OR CX,Source with no bracket
    OR_CX1:
    CMP firstOperandIndex,3
    JE OR_CX2
    JMP OR_DX1
    OR_CX2:
    
    ;OR CX,AX
    OR_CX_AX:
    CMP secondOperandIndex,1
    JE OR_CX_AX1
    JMP OR_CX_BX
    OR_CX_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,2
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR CX,BX
    OR_CX_BX:
    CMP secondOperandIndex,2
    JE OR_CX_BX1
    JMP OR_CX_CX
    OR_CX_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,2
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR CX,CX
    OR_CX_CX:
    CMP secondOperandIndex,3
    JE OR_CX_CX1
    JMP OR_CX_DX
    OR_CX_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,2
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR CX,DX
    OR_CX_DX:
    CMP secondOperandIndex,4
    JE OR_CX_DX1
    JMP OR_CX_SI
    OR_CX_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,2
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR CX,SI
    OR_CX_SI:
    CMP secondOperandIndex,5
    JE OR_CX_SI1
    JMP OR_CX_DI
    OR_CX_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,2
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR CX,DI
    OR_CX_DI:
    CMP secondOperandIndex,6
    JE OR_CX_DI1
    JMP OR_CX_SP
    OR_CX_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,2
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR CX,SP
    OR_CX_SP:
    CMP secondOperandIndex,7
    JE OR_CX_SP1
    JMP OR_CX_BP
    OR_CX_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,2
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR CX,BP
    OR_CX_BP:
    CMP secondOperandIndex,7
    JE OR_CX_BP1
    JMP OR_CX_NUM
    OR_CX_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,2
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR CX,NUM
    OR_CX_NUM:
    CMP secondOperandIndex,17
    JE OR_CX_NUM1
    JMP NOTAVAILIDCOMMAND
    OR_CX_NUM1:
    MOV addedValueToSIDest,2
    CALL ORAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;OR DX,Source with no bracket
    OR_DX1:
    CMP firstOperandIndex,4
    JE OR_DX2
    JMP OR_SI1
    OR_DX2:
    
    ;OR DX,AX
    OR_DX_AX:
    CMP secondOperandIndex,1
    JE OR_DX_AX1
    JMP OR_DX_BX
    OR_DX_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,3
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR DX,BX
    OR_DX_BX:
    CMP secondOperandIndex,2
    JE OR_DX_BX1
    JMP OR_DX_CX
    OR_DX_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,3
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR DX,CX
    OR_DX_CX:
    CMP secondOperandIndex,3
    JE OR_DX_CX1
    JMP OR_DX_DX
    OR_DX_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,3
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR DX,DX
    OR_DX_DX:
    CMP secondOperandIndex,4
    JE OR_DX_DX1
    JMP OR_DX_SI
    OR_DX_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,3
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR DX,SI
    OR_DX_SI:
    CMP secondOperandIndex,5
    JE OR_DX_SI1
    JMP OR_DX_DI
    OR_DX_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,3
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR DX,DI
    OR_DX_DI:
    CMP secondOperandIndex,6
    JE OR_DX_DI1
    JMP OR_DX_SP
    OR_DX_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,3
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR DX,SP
    OR_DX_SP:
    CMP secondOperandIndex,7
    JE OR_DX_SP1
    JMP OR_DX_BP
    OR_DX_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,3
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR DX,BP
    OR_DX_BP:
    CMP secondOperandIndex,7
    JE OR_DX_BP1
    JMP OR_DX_NUM
    OR_DX_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,3
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR DX,NUM
    OR_DX_NUM:
    CMP secondOperandIndex,17
    JE OR_DX_NUM1
    JMP NOTAVAILIDCOMMAND
    OR_DX_NUM1:
    MOV addedValueToSIDest,3
    CALL ORAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;OR SI,Source with no bracket
    OR_SI1:
    CMP firstOperandIndex,5
    JE OR_SI2
    JMP OR_DI1
    OR_SI2:
    
    ;OR SI,AX
    OR_SI_AX:
    CMP secondOperandIndex,1
    JE OR_SI_AX1
    JMP OR_SI_BX
    OR_SI_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,4
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR SI,BX
    OR_SI_BX:
    CMP secondOperandIndex,2
    JE OR_SI_BX1
    JMP OR_SI_CX
    OR_SI_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,4
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR SI,CX
    OR_SI_CX:
    CMP secondOperandIndex,3
    JE OR_SI_CX1
    JMP OR_SI_DX
    OR_SI_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,4
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR SI,DX
    OR_SI_DX:
    CMP secondOperandIndex,4
    JE OR_SI_DX1
    JMP OR_SI_SI
    OR_SI_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,4
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR SI,SI
    OR_SI_SI:
    CMP secondOperandIndex,5
    JE OR_SI_SI1
    JMP OR_SI_DI
    OR_SI_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR SI,DI
    OR_SI_DI:
    CMP secondOperandIndex,6
    JE OR_SI_DI1
    JMP OR_SI_SP
    OR_SI_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,4
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR SI,SP
    OR_SI_SP:
    CMP secondOperandIndex,7
    JE OR_SI_SP1
    JMP OR_SI_BP
    OR_SI_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,4
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR SI,BP
    OR_SI_BP:
    CMP secondOperandIndex,7
    JE OR_SI_BP1
    JMP OR_SI_NUM
    OR_SI_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,4
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR SI,NUM
    OR_SI_NUM:
    CMP secondOperandIndex,17
    JE OR_SI_NUM1
    JMP NOTAVAILIDCOMMAND
    OR_SI_NUM1:
    MOV addedValueToSIDest,4
    CALL ORAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;OR DI,Source with no bracket
    OR_DI1:
    CMP firstOperandIndex,6
    JE OR_DI2
    JMP OR_SP1
    OR_DI2:
    
    ;OR DI,AX
    OR_DI_AX:
    CMP secondOperandIndex,1
    JE OR_DI_AX1
    JMP OR_DI_BX
    OR_DI_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,5
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR DI,BX
    OR_DI_BX:
    CMP secondOperandIndex,2
    JE OR_DI_BX1
    JMP OR_DI_CX
    OR_DI_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,5
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR DI,CX
    OR_DI_CX:
    CMP secondOperandIndex,3
    JE OR_DI_CX1
    JMP OR_DI_DX
    OR_DI_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,5
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR DI,DX
    OR_DI_DX:
    CMP secondOperandIndex,4
    JE OR_DI_DX1
    JMP OR_DI_SI
    OR_DI_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,5
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR DI,SI
    OR_DI_SI:
    CMP secondOperandIndex,5
    JE OR_DI_SI1
    JMP OR_DI_DI
    OR_DI_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR DI,DI
    OR_DI_DI:
    CMP secondOperandIndex,6
    JE OR_DI_DI1
    JMP OR_DI_SP
    OR_DI_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,5
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR DI,SP
    OR_DI_SP:
    CMP secondOperandIndex,7
    JE OR_DI_SP1
    JMP OR_DI_BP
    OR_DI_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,5
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR DI,BP
    OR_DI_BP:
    CMP secondOperandIndex,7
    JE OR_DI_BP1
    JMP OR_DI_NUM
    OR_DI_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,5
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR DI,NUM
    OR_DI_NUM:
    CMP secondOperandIndex,17
    JE OR_DI_NUM1
    JMP NOTAVAILIDCOMMAND
    OR_DI_NUM1:
    MOV addedValueToSIDest,5
    CALL ORAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;OR SP,Source with no bracket
    OR_SP1:
    CMP firstOperandIndex,7
    JE OR_SP2
    JMP OR_BP1
    OR_SP2:
    
    ;OR SP,AX
    OR_SP_AX:
    CMP secondOperandIndex,1
    JE OR_SP_AX1
    JMP OR_SP_BX
    OR_SP_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,6
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR SP,BX
    OR_SP_BX:
    CMP secondOperandIndex,2
    JE OR_SP_BX1
    JMP OR_SP_CX
    OR_SP_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,6
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR SP,CX
    OR_SP_CX:
    CMP secondOperandIndex,3
    JE OR_SP_CX1
    JMP OR_SP_DX
    OR_SP_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,6
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR SP,DX
    OR_SP_DX:
    CMP secondOperandIndex,4
    JE OR_SP_DX1
    JMP OR_SP_SI
    OR_SP_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,6
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR SP,SI
    OR_SP_SI:
    CMP secondOperandIndex,5
    JE OR_SP_SI1
    JMP OR_SP_DI
    OR_SP_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,6
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR SP,DI
    OR_SP_DI:
    CMP secondOperandIndex,6
    JE OR_SP_DI1
    JMP OR_SP_SP
    OR_SP_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,6
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR SP,SP
    OR_SP_SP:
    CMP secondOperandIndex,7
    JE OR_SP_SP1
    JMP OR_SP_BP
    OR_SP_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,6
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR SP,BP
    OR_SP_BP:
    CMP secondOperandIndex,7
    JE OR_SP_BP1
    JMP OR_SP_NUM
    OR_SP_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,6
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR SP,NUM
    OR_SP_NUM:
    CMP secondOperandIndex,17
    JE OR_SP_NUM1
    JMP NOTAVAILIDCOMMAND
    OR_SP_NUM1:
    MOV addedValueToSIDest,6
    CALL ORAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;OR BP,Source with no bracket
    OR_BP1:
    CMP firstOperandIndex,8
    JE OR_BP2
    JMP OR_AH1
    OR_BP2:
    
    ;OR BP,AX
    OR_BP_AX:
    CMP secondOperandIndex,1
    JE OR_BP_AX1
    JMP OR_BP_BX
    OR_BP_AX1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,7
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR BP,BX
    OR_BP_BX:
    CMP secondOperandIndex,2
    JE OR_BP_BX1
    JMP OR_BP_CX
    OR_BP_BX1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,7
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR BP,CX
    OR_BP_CX:
    CMP secondOperandIndex,3
    JE OR_BP_CX1
    JMP OR_BP_DX
    OR_BP_CX1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,7
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR BP,DX
    OR_BP_DX:
    CMP secondOperandIndex,4
    JE OR_BP_DX1
    JMP OR_BP_SI
    OR_BP_DX1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,7
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR BP,SI
    OR_BP_SI:
    CMP secondOperandIndex,5
    JE OR_BP_SI1
    JMP OR_BP_DI
    OR_BP_SI1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,7
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR BP,DI
    OR_BP_DI:
    CMP secondOperandIndex,6
    JE OR_BP_DI1
    JMP OR_BP_SP
    OR_BP_DI1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,7
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR BP,SP
    OR_BP_SP:
    CMP secondOperandIndex,7
    JE OR_BP_SP1
    JMP OR_BP_BP
    OR_BP_SP1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,7
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR BP,BP
    OR_BP_BP:
    CMP secondOperandIndex,7
    JE OR_BP_BP1
    JMP OR_BP_NUM
    OR_BP_BP1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,7
    CALL ORAWordRegWithWordReg
    JMP ENDEXECUTE
    
    ;OR BP,NUM
    OR_BP_NUM:
    CMP secondOperandIndex,17
    JE OR_BP_NUM1
    JMP NOTAVAILIDCOMMAND
    OR_BP_NUM1:
    MOV addedValueToSIDest,7
    CALL ORAWordRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;OR AH,Source with no bracket
    OR_AH1:
    CMP firstOperandIndex,9
    JE OR_AH2
    JMP OR_AL1
    OR_AH2:
    
    ;OR AH,AH
    OR_AH_AH:
    CMP secondOperandIndex,9
    JE OR_AH_AH1
    JMP OR_AH_BH
    OR_AH_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,1
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR AH,BH
    OR_AH_BH:
    CMP secondOperandIndex,11
    JE OR_AH_BH1
    JMP OR_AH_CH
    OR_AH_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,1
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR AH,CH
    OR_AH_CH:
    CMP secondOperandIndex,13
    JE OR_AH_CH1
    JMP OR_AH_DH
    OR_AH_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,1
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR AH,DH
    OR_AH_DH:
    CMP secondOperandIndex,15
    JE OR_AH_DH1
    JMP OR_AH_AL
    OR_AH_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,1
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR AH,AL
    OR_AH_AL:
    CMP secondOperandIndex,10
    JE OR_AH_AL1
    JMP OR_AH_BL
    OR_AH_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,1
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR AH,BL
    OR_AH_BL:
    CMP secondOperandIndex,12
    JE OR_AH_BL1
    JMP OR_AH_CL
    OR_AH_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,1
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR AH,CL
    OR_AH_CL:
    CMP secondOperandIndex,14
    JE OR_AH_CL1
    JMP OR_AH_DL
    OR_AH_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,1
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR AH,DL
    OR_AH_DL:
    CMP secondOperandIndex,16
    JE OR_AH_DL1
    JMP OR_AH_NUM
    OR_AH_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,1
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR AH,NUM
    OR_AH_NUM:
    CMP secondOperandIndex,17
    JE OR_AH_NUM1
    JMP NOTAVAILIDCOMMAND
    OR_AH_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,1
    CALL ORAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;OR AL,Source with no bracket
    OR_AL1:
    CMP firstOperandIndex,10
    JE OR_AL2
    JMP OR_BH1
    OR_AL2:
    
    ;OR AL,AH
    OR_AL_AH:
    CMP secondOperandIndex,9
    JE OR_AL_AH1
    JMP OR_AL_BH
    OR_AL_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,0
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR AL,BH
    OR_AL_BH:
    CMP secondOperandIndex,11
    JE OR_AL_BH1
    JMP OR_AL_CH
    OR_AL_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,0
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR AL,CH
    OR_AL_CH:
    CMP secondOperandIndex,13
    JE OR_AL_CH1
    JMP OR_AL_DH
    OR_AL_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,0
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR AL,DH
    OR_AL_DH:
    CMP secondOperandIndex,15
    JE OR_AL_DH1
    JMP OR_AL_AL
    OR_AL_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,0
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR AL,AL
    OR_AL_AL:
    CMP secondOperandIndex,10
    JE OR_AL_AL1
    JMP OR_AL_BL
    OR_AL_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,0
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR AL,BL
    OR_AL_BL:
    CMP secondOperandIndex,12
    JE OR_AL_BL1
    JMP OR_AL_CL
    OR_AL_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,0
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR AL,CL
    OR_AL_CL:
    CMP secondOperandIndex,14
    JE OR_AL_CL1
    JMP OR_AL_DL
    OR_AL_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,0
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR AL,DL
    OR_AL_DL:
    CMP secondOperandIndex,16
    JE OR_AL_DL1
    JMP OR_AL_NUM
    OR_AL_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,0
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR AL,NUM
    OR_AL_NUM:
    CMP secondOperandIndex,17
    JE OR_AL_NUM1
    JMP NOTAVAILIDCOMMAND
    OR_AL_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,0
    CALL ORAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;OR BH,Source with no bracket
    OR_BH1:
    CMP firstOperandIndex,11
    JE OR_BH2
    JMP OR_BL1
    OR_BH2:
    
    ;OR BH,AH
    OR_BH_AH:
    CMP secondOperandIndex,9
    JE OR_BH_AH1
    JMP OR_BH_BH
    OR_BH_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,3
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR BH,BH
    OR_BH_BH:
    CMP secondOperandIndex,11
    JE OR_BH_BH1
    JMP OR_BH_CH
    OR_BH_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,3
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR BH,CH
    OR_BH_CH:
    CMP secondOperandIndex,13
    JE OR_BH_CH1
    JMP OR_BH_DH
    OR_BH_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,3
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR BH,DH
    OR_BH_DH:
    CMP secondOperandIndex,15
    JE OR_BH_DH1
    JMP OR_BH_AL
    OR_BH_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,3
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR BH,AL
    OR_BH_AL:
    CMP secondOperandIndex,10
    JE OR_BH_AL1
    JMP OR_BH_BL
    OR_BH_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,3
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR BH,BL
    OR_BH_BL:
    CMP secondOperandIndex,12
    JE OR_BH_BL1
    JMP OR_BH_CL
    OR_BH_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,3
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR BH,CL
    OR_BH_CL:
    CMP secondOperandIndex,14
    JE OR_BH_CL1
    JMP OR_BH_DL
    OR_BH_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,3
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR BH,DL
    OR_BH_DL:
    CMP secondOperandIndex,16
    JE OR_BH_DL1
    JMP OR_BH_NUM
    OR_BH_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,3
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR BH,NUM
    OR_BH_NUM:
    CMP secondOperandIndex,17
    JE OR_BH_NUM1
    JMP NOTAVAILIDCOMMAND
    OR_BH_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,3
    CALL ORAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;OR BL,Source with no bracket
    OR_BL1:
    CMP firstOperandIndex,12
    JE OR_BL2
    JMP OR_CH1
    OR_BL2:
    
    ;OR BL,AH
    OR_BL_AH:
    CMP secondOperandIndex,9
    JE OR_BL_AH1
    JMP OR_BL_BH
    OR_BL_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,2
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR BL,BH
    OR_BL_BH:
    CMP secondOperandIndex,11
    JE OR_BL_BH1
    JMP OR_BL_CH
    OR_BL_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,2
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR BL,CH
    OR_BL_CH:
    CMP secondOperandIndex,13
    JE OR_BL_CH1
    JMP OR_BL_DH
    OR_BL_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,2
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR BL,DH
    OR_BL_DH:
    CMP secondOperandIndex,15
    JE OR_BL_DH1
    JMP OR_BL_AL
    OR_BL_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,2
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR BL,AL
    OR_BL_AL:
    CMP secondOperandIndex,10
    JE OR_BL_AL1
    JMP OR_BL_BL
    OR_BL_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,2
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR BL,BL
    OR_BL_BL:
    CMP secondOperandIndex,12
    JE OR_BL_BL1
    JMP OR_BL_CL
    OR_BL_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,2
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR BL,CL
    OR_BL_CL:
    CMP secondOperandIndex,14
    JE OR_BL_CL1
    JMP OR_BL_DL
    OR_BL_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,2
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR BL,DL
    OR_BL_DL:
    CMP secondOperandIndex,16
    JE OR_BL_DL1
    JMP OR_BL_NUM
    OR_BL_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,2
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR BL,NUM
    OR_BL_NUM:
    CMP secondOperandIndex,17
    JE OR_BL_NUM1
    JMP NOTAVAILIDCOMMAND
    OR_BL_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,2
    CALL ORAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;OR CH,Source with no bracket
    OR_CH1:
    CMP firstOperandIndex,13
    JE OR_CH2
    JMP OR_CL1
    OR_CH2:
    
    ;OR CH,AH
    OR_CH_AH:
    CMP secondOperandIndex,9
    JE OR_CH_AH1
    JMP OR_CH_BH
    OR_CH_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,5
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR CH,BH
    OR_CH_BH:
    CMP secondOperandIndex,11
    JE OR_CH_BH1
    JMP OR_CH_CH
    OR_CH_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,5
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR CH,CH
    OR_CH_CH:
    CMP secondOperandIndex,13
    JE OR_CH_CH1
    JMP OR_CH_DH
    OR_CH_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,5
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR CH,DH
    OR_CH_DH:
    CMP secondOperandIndex,15
    JE OR_CH_DH1
    JMP OR_CH_AL
    OR_CH_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,5
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR CH,AL
    OR_CH_AL:
    CMP secondOperandIndex,10
    JE OR_CH_AL1
    JMP OR_CH_BL
    OR_CH_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,5
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR CH,BL
    OR_CH_BL:
    CMP secondOperandIndex,12
    JE OR_CH_BL1
    JMP OR_CH_CL
    OR_CH_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,5
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR CH,CL
    OR_CH_CL:
    CMP secondOperandIndex,14
    JE OR_CH_CL1
    JMP OR_CH_DL
    OR_CH_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,5
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR CH,DL
    OR_CH_DL:
    CMP secondOperandIndex,16
    JE OR_CH_DL1
    JMP OR_CH_NUM
    OR_CH_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,5
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR CH,NUM
    OR_CH_NUM:
    CMP secondOperandIndex,17
    JE OR_CH_NUM1
    JMP NOTAVAILIDCOMMAND
    OR_CH_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,5
    CALL ORAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;OR CL,Source with no bracket
    OR_CL1:
    CMP firstOperandIndex,14
    JE OR_CL2
    JMP OR_DH1
    OR_CL2:
    
    ;OR CL,AH
    OR_CL_AH:
    CMP secondOperandIndex,9
    JE OR_CL_AH1
    JMP OR_CL_BH
    OR_CL_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,4
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR CL,BH
    OR_CL_BH:
    CMP secondOperandIndex,11
    JE OR_CL_BH1
    JMP OR_CL_CH
    OR_CL_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,4
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR CL,CH
    OR_CL_CH:
    CMP secondOperandIndex,13
    JE OR_CL_CH1
    JMP OR_CL_DH
    OR_CL_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,4
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR CL,DH
    OR_CL_DH:
    CMP secondOperandIndex,15
    JE OR_CL_DH1
    JMP OR_CL_AL
    OR_CL_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,4
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR CL,AL
    OR_CL_AL:
    CMP secondOperandIndex,10
    JE OR_CL_AL1
    JMP OR_CL_BL
    OR_CL_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,4
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR CL,BL
    OR_CL_BL:
    CMP secondOperandIndex,12
    JE OR_CL_BL1
    JMP OR_CL_CL
    OR_CL_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,4
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR CL,CL
    OR_CL_CL:
    CMP secondOperandIndex,14
    JE OR_CL_CL1
    JMP OR_CL_DL
    OR_CL_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,4
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR CL,DL
    OR_CL_DL:
    CMP secondOperandIndex,16
    JE OR_CL_DL1
    JMP OR_CL_NUM
    OR_CL_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,4
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR CL,NUM
    OR_CL_NUM:
    CMP secondOperandIndex,17
    JE OR_CL_NUM1
    JMP NOTAVAILIDCOMMAND
    OR_CL_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,4
    CALL ORAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;OR DH,Source with no bracket
    OR_DH1:
    CMP firstOperandIndex,15
    JE OR_DH2
    JMP OR_DL1
    OR_DH2:
    
    ;OR DH,AH
    OR_DH_AH:
    CMP secondOperandIndex,9
    JE OR_DH_AH1
    JMP OR_DH_BH
    OR_DH_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,7
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR DH,BH
    OR_DH_BH:
    CMP secondOperandIndex,11
    JE OR_DH_BH1
    JMP OR_DH_CH
    OR_DH_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,7
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR DH,CH
    OR_DH_CH:
    CMP secondOperandIndex,13
    JE OR_DH_CH1
    JMP OR_DH_DH
    OR_DH_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,7
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR DH,DH
    OR_DH_DH:
    CMP secondOperandIndex,15
    JE OR_DH_DH1
    JMP OR_DH_AL
    OR_DH_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,7
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR DH,AL
    OR_DH_AL:
    CMP secondOperandIndex,10
    JE OR_DH_AL1
    JMP OR_DH_BL
    OR_DH_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,7
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR DH,BL
    OR_DH_BL:
    CMP secondOperandIndex,12
    JE OR_DH_BL1
    JMP OR_DH_CL
    OR_DH_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,7
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR DH,CL
    OR_DH_CL:
    CMP secondOperandIndex,14
    JE OR_DH_CL1
    JMP OR_DH_DL
    OR_DH_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,7
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR DH,DL
    OR_DH_DL:
    CMP secondOperandIndex,16
    JE OR_DH_DL1
    JMP OR_DH_NUM
    OR_DH_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,7
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR DH,NUM
    OR_DH_NUM:
    CMP secondOperandIndex,17
    JE OR_DH_NUM1
    JMP NOTAVAILIDCOMMAND
    OR_DH_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,7
    CALL ORAByteRegWithNUM
    JMP ENDEXECUTE
    
    ;========================
    ;OR DL,Source with no bracket
    OR_DL1:
    CMP firstOperandIndex,15
    JE OR_DL2
    JMP NOTAVAILIDCOMMAND
    OR_DL2:
    
    ;OR DL,AH
    OR_DL_AH:
    CMP secondOperandIndex,9
    JE OR_DL_AH1
    JMP OR_DL_BH
    OR_DL_AH1:
    MOV addedValueToSISource,1
    MOV addedValueToSIDest,6
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR DL,BH
    OR_DL_BH:
    CMP secondOperandIndex,11
    JE OR_DL_BH1
    JMP OR_DL_CH
    OR_DL_BH1:
    MOV addedValueToSISource,3
    MOV addedValueToSIDest,6
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR DL,CH
    OR_DL_CH:
    CMP secondOperandIndex,13
    JE OR_DL_CH1
    JMP OR_DL_DH
    OR_DL_CH1:
    MOV addedValueToSISource,5
    MOV addedValueToSIDest,6
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR DL,DH
    OR_DL_DH:
    CMP secondOperandIndex,15
    JE OR_DL_DH1
    JMP OR_DL_AL
    OR_DL_DH1:
    MOV addedValueToSISource,7
    MOV addedValueToSIDest,6
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR DL,AL
    OR_DL_AL:
    CMP secondOperandIndex,10
    JE OR_DL_AL1
    JMP OR_DL_BL
    OR_DL_AL1:
    MOV addedValueToSISource,0
    MOV addedValueToSIDest,6
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR DL,BL
    OR_DL_BL:
    CMP secondOperandIndex,12
    JE OR_DL_BL1
    JMP OR_DL_CL
    OR_DL_BL1:
    MOV addedValueToSISource,2
    MOV addedValueToSIDest,6
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR DL,CL
    OR_DL_CL:
    CMP secondOperandIndex,14
    JE OR_DL_CL1
    JMP OR_DL_DL
    OR_DL_CL1:
    MOV addedValueToSISource,4
    MOV addedValueToSIDest,6
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR DL,DL
    OR_DL_DL:
    CMP secondOperandIndex,16
    JE OR_DL_DL1
    JMP OR_DL_NUM
    OR_DL_DL1:
    MOV addedValueToSISource,6
    MOV addedValueToSIDest,6
    CALL ORAByteRegWithByteReg
    JMP ENDEXECUTE
    
    ;OR DL,NUM
    OR_DL_NUM:
    CMP secondOperandIndex,17
    JE OR_DL_NUM1
    JMP NOTAVAILIDCOMMAND
    OR_DL_NUM1:
    ;check if the number is byte
    validateEnteredNumToBeByte
    MOV addedValueToSIDest,6
    CALL ORAByteRegWithNUM
    JMP ENDEXECUTE
;------------------------------------------------------------------------------------------------   
    ;this is SHR command
    SHRCOMMAND:
    CMP commandIndex,11
    JE SHRCOMMAND1
    JMP SHLCOMMAND
    SHRCOMMAND1:
    
    ;the second operand mustn't have brackets
    CMP isSecondOpBracket,1
    JNE SHRCOMMAND11
    JMP NOTAVAILIDCOMMAND
    SHRCOMMAND11:
    
    ;the second operand index is either 17 (Num) or 14 (CL) other than that error
    CMP secondOperandIndex,17
    JE SHRCOMMAND12
    
    CMP secondOperandIndex,14
    JE SHRCOMMAND12
    JMP NOTAVAILIDCOMMAND
    SHRCOMMAND12:
    
    ;if there is a bracket then either BX or SI or DI
    CMP isFirstOpBracket,1
    JNE SHRCOMMAND13
    JMP SHRCommandForPointer
    SHRCOMMAND13:
    
    ;internal check ti see if 2nd operand is CL or NUM
    CMP secondOperandIndex,17
    JE SHRRegUsingNum
    JMP SHRRegUsingCl
    SHRRegUsingNum:
    
    ;the Num must be Byte
    CMP numberEntered,255
    JLE SHRCOMMAND14
    JMP NOTAVAILIDCOMMAND
    SHRCOMMAND14:
    
    ;SHR AX,NUM
    SHRAX1ByNum:
    CMP firstOperandIndex,1
    JNE SHRBX1ByNum
    MOV addedValueToSIDest,0
    CALL SHRARegisterWordByNum
    JMP ENDEXECUTE  
    
    ;SHR BX,NUM
    SHRBX1ByNum:
    CMP firstOperandIndex,2
    JNE SHRCX1ByNum
    MOV addedValueToSIDest,1
    CALL SHRARegisterWordByNum
    JMP ENDEXECUTE
     
    ;SHR CX,NUM
    SHRCX1ByNum:
    CMP firstOperandIndex,3
    JNE SHRDX1ByNum
    MOV addedValueToSIDest,2
    CALL SHRARegisterWordByNum
    JMP ENDEXECUTE
    
    ;SHR DX,NUM
    SHRDX1ByNum:
    CMP firstOperandIndex,4
    JNE SHRSI1ByNum
    MOV addedValueToSIDest,3
    CALL SHRARegisterWordByNum
    JMP ENDEXECUTE
    
    ;SHR SI,NUM
    SHRSI1ByNum:
    CMP firstOperandIndex,5
    JNE SHRDI1ByNum
    MOV addedValueToSIDest,4
    CALL SHRARegisterWordByNum
    JMP ENDEXECUTE
    
    ;SHR DI,NUM
    SHRDI1ByNum:
    CMP firstOperandIndex,6
    JNE SHRSP1ByNum
    MOV addedValueToSIDest,5
    CALL SHRARegisterWordByNum
    JMP ENDEXECUTE
    
    ;SHR SP,NUM
    SHRSP1ByNum:
    CMP firstOperandIndex,7
    JNE SHRBP1ByNum
    MOV addedValueToSIDest,6
    CALL SHRARegisterWordByNum
    JMP ENDEXECUTE
    
    ;SHR BP,NUM
    SHRBP1ByNum:
    CMP firstOperandIndex,8
    JNE SHRAH1ByNum
    MOV addedValueToSIDest,7
    CALL SHRARegisterWordByNum
    JMP ENDEXECUTE
    
    ;SHR AH,NUM
    SHRAH1ByNum:
    CMP firstOperandIndex,9
    JNE SHRAL1ByNum
    MOV addedValueToSIDest,1
    CALL SHRARegisterByteByNum
    JMP ENDEXECUTE
    
    ;SHR AL,NUM
    SHRAL1ByNum:
    CMP firstOperandIndex,10
    JNE SHRBH1ByNum
    MOV addedValueToSIDest,0
    CALL SHRARegisterByteByNum
    JMP ENDEXECUTE
    
    ;SHR BH,NUM
    SHRBH1ByNum:
    CMP firstOperandIndex,11
    JNE SHRBL1ByNum
    MOV addedValueToSIDest,3
    CALL SHRARegisterByteByNum
    JMP ENDEXECUTE
    
    ;SHR BL,NUM
    SHRBL1ByNum:
    CMP firstOperandIndex,12
    JNE SHRCH1ByNum
    MOV addedValueToSIDest,2
    CALL SHRARegisterByteByNum
    JMP ENDEXECUTE
    
    ;SHR CH,NUM
    SHRCH1ByNum:
    CMP firstOperandIndex,13
    JNE SHRCL1ByNum
    MOV addedValueToSIDest,5
    CALL SHRARegisterByteByNum
    JMP ENDEXECUTE
    
    ;SHR CL,NUM
    SHRCL1ByNum:
    CMP firstOperandIndex,14
    JNE SHRDH1ByNum
    MOV addedValueToSIDest,4
    CALL SHRARegisterByteByNum
    JMP ENDEXECUTE
    
    ;SHR DH,NUM
    SHRDH1ByNum:
    CMP firstOperandIndex,15
    JNE SHRDL1ByNum
    MOV addedValueToSIDest,7
    CALL SHRARegisterByteByNum
    JMP ENDEXECUTE
    
    ;SHR DL,NUM
    SHRDL1ByNum:
    CMP firstOperandIndex,16
    JE SHRDL2ByNum
    JMP NOTAVAILIDCOMMAND
    SHRDL2ByNum:
    MOV addedValueToSIDest,6
    CALL SHRARegisterByteByNum
    JMP ENDEXECUTE
    
    
    ;THIS IS FOR ROTATING REG USING CL
    SHRRegUsingCl:
    
    ;SHR AX,CL
    SHRAX1ByCL:
    CMP firstOperandIndex,1
    JNE SHRBX1ByCL
    MOV addedValueToSIDest,0
    CALL SHRARegisterWordByCL
    JMP ENDEXECUTE  
    
    ;SHR BX,CL
    SHRBX1ByCL:
    CMP firstOperandIndex,2
    JNE SHRCX1ByCL
    MOV addedValueToSIDest,1
    CALL SHRARegisterWordByCL
    JMP ENDEXECUTE
     
    ;SHR CX,CL
    SHRCX1ByCL:
    CMP firstOperandIndex,3
    JNE SHRDX1ByCL
    MOV addedValueToSIDest,2
    CALL SHRARegisterWordByCL
    JMP ENDEXECUTE
    
    ;SHR DX,CL
    SHRDX1ByCL:
    CMP firstOperandIndex,4
    JNE SHRSI1ByCL
    MOV addedValueToSIDest,3
    CALL SHRARegisterWordByCL
    JMP ENDEXECUTE
    
    ;SHR SI,CL
    SHRSI1ByCL:
    CMP firstOperandIndex,5
    JNE SHRDI1ByCL
    MOV addedValueToSIDest,4
    CALL SHRARegisterWordByCL
    JMP ENDEXECUTE
    
    ;SHR DI,CL
    SHRDI1ByCL:
    CMP firstOperandIndex,6
    JNE SHRSP1ByCL
    MOV addedValueToSIDest,5
    CALL SHRARegisterWordByCL
    JMP ENDEXECUTE
    
    ;SHR SP,CL
    SHRSP1ByCL:
    CMP firstOperandIndex,7
    JNE SHRBP1ByCL
    MOV addedValueToSIDest,6
    CALL SHRARegisterWordByCL
    JMP ENDEXECUTE
    
    ;SHR BP,CL
    SHRBP1ByCL:
    CMP firstOperandIndex,8
    JNE SHRAH1ByCL
    MOV addedValueToSIDest,7
    CALL SHRARegisterWordByCL
    JMP ENDEXECUTE
    
    ;SHR AH,CL
    SHRAH1ByCL:
    CMP firstOperandIndex,9
    JNE SHRAL1ByCL
    MOV addedValueToSIDest,1
    CALL SHRARegisterByteByCL
    JMP ENDEXECUTE
    
    ;SHR AL,CL
    SHRAL1ByCL:
    CMP firstOperandIndex,10
    JNE SHRBH1ByCL
    MOV addedValueToSIDest,0
    CALL SHRARegisterByteByCL
    JMP ENDEXECUTE
    
    ;SHR BH,CL
    SHRBH1ByCL:
    CMP firstOperandIndex,11
    JNE SHRBL1ByCL
    MOV addedValueToSIDest,3
    CALL SHRARegisterByteByCL
    JMP ENDEXECUTE
    
    ;SHR BL,CL
    SHRBL1ByCL:
    CMP firstOperandIndex,12
    JNE SHRCH1ByCL
    MOV addedValueToSIDest,2
    CALL SHRARegisterByteByCL
    JMP ENDEXECUTE
    
    ;SHR CH,CL
    SHRCH1ByCL:
    CMP firstOperandIndex,13
    JNE SHRCL1ByCL
    MOV addedValueToSIDest,5
    CALL SHRARegisterByteByCL
    JMP ENDEXECUTE
    
    ;SHR CL,CL
    SHRCL1ByCL:
    CMP firstOperandIndex,14
    JNE SHRDH1ByCL
    MOV addedValueToSIDest,4
    CALL SHRARegisterByteByCL
    JMP ENDEXECUTE
    
    ;SHR DH,CL
    SHRDH1ByCL:
    CMP firstOperandIndex,15
    JNE SHRDL1ByCL
    MOV addedValueToSIDest,7
    CALL SHRARegisterByteByCL
    JMP ENDEXECUTE
    
    ;SHR DL,CL
    SHRDL1ByCL:
    CMP firstOperandIndex,16
    JE SHRDL2ByCL
    JMP NOTAVAILIDCOMMAND
    SHRDL2ByCL:
    MOV addedValueToSIDest,6
    CALL SHRARegisterByteByCL
    JMP ENDEXECUTE
    
    
    ;this is the command for SI,BX,DI only
    SHRCommandForPointer:
    ;check if it's rotate by Cl or a number
    CMP secondOperandIndex,17
    JE SHRPointerRegUsingNum
    JMP SHRPointerRegUsingCL
    SHRPointerRegUsingNum:
    
    ;the Num must be Byte
    CMP numberEntered,255
    JLE SHRCOMMAND15
    JMP NOTAVAILIDCOMMAND
    SHRCOMMAND15:
    
    ;SHR [BX],NUM
    SHRBXPointerByNum:
    CMP firstOperandIndex,2
    JNE SHRSIPointerByNum 
    MOV addedValueToSIDest,1
    CALL SHRAMemoryByNum
    JMP ENDEXECUTE
    
    ;SHR [SI],NUM
    SHRSIPointerByNum:
    CMP firstOperandIndex,5
    JNE SHRDIPointerByNum
    MOV addedValueToSIDest,4
    CALL SHRAMemoryByNum
    JMP ENDEXECUTE
    
    ;SHR [DI],NUM
    SHRDIPointerByNum:
    CMP firstOperandIndex,6
    JE SHRDIPointerByNum1
    JMP NOTAVAILIDCOMMAND
    SHRDIPointerByNum1:
    MOV addedValueToSIDest,5
    CALL SHRAMemoryByNum
    JMP ENDEXECUTE
    
    ;rotate memory using CL
    SHRPointerRegUsingCL:
    
    ;SHR [BX],CL
    SHRBXPointerByCL:
    CMP firstOperandIndex,2
    JNE SHRSIPointerByCL
    MOV addedValueToSIDest,1 
    CALL SHRAMemoryByCL
    JMP ENDEXECUTE
    
    ;SHR [BX],CL
    SHRSIPointerByCL:
    CMP firstOperandIndex,5
    JNE SHRDIPointerByCL
    MOV addedValueToSIDest,4
    CALL SHRAMemoryByCL
    JMP ENDEXECUTE
    
    ;SHR [BX],CL
    SHRDIPointerByCL:
    CMP firstOperandIndex,6
    JE SHRDIPointerByCL1
    JMP NOTAVAILIDCOMMAND
    SHRDIPointerByCL1:
    MOV addedValueToSIDest,5
    CALL SHRAMemoryByCL
    JMP ENDEXECUTE
;------------------------------------------------------------------------------------------------  
    ;this is SHL command
    SHLCOMMAND:
    CMP commandIndex,12
    JE SHLCOMMAND1
    JMP SARCOMMAND
    SHLCOMMAND1:
    
    ;the second operand mustn't have brackets
    CMP isSecondOpBracket,1
    JNE SHLCOMMAND11
    JMP NOTAVAILIDCOMMAND
    SHLCOMMAND11:
    
    ;the second operand index is either 17 (Num) or 14 (CL) other than that error
    CMP secondOperandIndex,17
    JE SHLCOMMAND12
    
    CMP secondOperandIndex,14
    JE SHLCOMMAND12
    JMP NOTAVAILIDCOMMAND
    SHLCOMMAND12:
    
    ;if there is a bracket then either BX or SI or DI
    CMP isFirstOpBracket,1
    JNE SHLCOMMAND13
    JMP SHLCommandForPointer
    SHLCOMMAND13:
    
    ;internal check ti see if 2nd operand is CL or NUM
    CMP secondOperandIndex,17
    JE SHLRegUsingNum
    JMP SHLRegUsingCl
    SHLRegUsingNum:
    
    ;the Num must be Byte
    CMP numberEntered,255
    JLE SHLCOMMAND14
    JMP NOTAVAILIDCOMMAND
    SHLCOMMAND14:
    
    ;SHL AX,NUM
    SHLAX1ByNum:
    CMP firstOperandIndex,1
    JNE SHLBX1ByNum
    MOV addedValueToSIDest,0
    CALL SHLARegisterWordByNum
    JMP ENDEXECUTE  
    
    ;SHL BX,NUM
    SHLBX1ByNum:
    CMP firstOperandIndex,2
    JNE SHLCX1ByNum
    MOV addedValueToSIDest,1
    CALL SHLARegisterWordByNum
    JMP ENDEXECUTE
     
    ;SHL CX,NUM
    SHLCX1ByNum:
    CMP firstOperandIndex,3
    JNE SHLDX1ByNum
    MOV addedValueToSIDest,2
    CALL SHLARegisterWordByNum
    JMP ENDEXECUTE
    
    ;SHL DX,NUM
    SHLDX1ByNum:
    CMP firstOperandIndex,4
    JNE SHLSI1ByNum
    MOV addedValueToSIDest,3
    CALL SHLARegisterWordByNum
    JMP ENDEXECUTE
    
    ;SHL SI,NUM
    SHLSI1ByNum:
    CMP firstOperandIndex,5
    JNE SHLDI1ByNum
    MOV addedValueToSIDest,4
    CALL SHLARegisterWordByNum
    JMP ENDEXECUTE
    
    ;SHL DI,NUM
    SHLDI1ByNum:
    CMP firstOperandIndex,6
    JNE SHLSP1ByNum
    MOV addedValueToSIDest,5
    CALL SHLARegisterWordByNum
    JMP ENDEXECUTE
    
    ;SHL SP,NUM
    SHLSP1ByNum:
    CMP firstOperandIndex,7
    JNE SHLBP1ByNum
    MOV addedValueToSIDest,6
    CALL SHLARegisterWordByNum
    JMP ENDEXECUTE
    
    ;SHL BP,NUM
    SHLBP1ByNum:
    CMP firstOperandIndex,8
    JNE SHLAH1ByNum
    MOV addedValueToSIDest,7
    CALL SHLARegisterWordByNum
    JMP ENDEXECUTE
    
    ;SHL AH,NUM
    SHLAH1ByNum:
    CMP firstOperandIndex,9
    JNE SHLAL1ByNum
    MOV addedValueToSIDest,1
    CALL SHLARegisterByteByNum
    JMP ENDEXECUTE
    
    ;SHL AL,NUM
    SHLAL1ByNum:
    CMP firstOperandIndex,10
    JNE SHLBH1ByNum
    MOV addedValueToSIDest,0
    CALL SHLARegisterByteByNum
    JMP ENDEXECUTE
    
    ;SHL BH,NUM
    SHLBH1ByNum:
    CMP firstOperandIndex,11
    JNE SHLBL1ByNum
    MOV addedValueToSIDest,3
    CALL SHLARegisterByteByNum
    JMP ENDEXECUTE
    
    ;SHL BL,NUM
    SHLBL1ByNum:
    CMP firstOperandIndex,12
    JNE SHLCH1ByNum
    MOV addedValueToSIDest,2
    CALL SHLARegisterByteByNum
    JMP ENDEXECUTE
    
    ;SHL CH,NUM
    SHLCH1ByNum:
    CMP firstOperandIndex,13
    JNE SHLCL1ByNum
    MOV addedValueToSIDest,5
    CALL SHLARegisterByteByNum
    JMP ENDEXECUTE
    
    ;SHL CL,NUM
    SHLCL1ByNum:
    CMP firstOperandIndex,14
    JNE SHLDH1ByNum
    MOV addedValueToSIDest,4
    CALL SHLARegisterByteByNum
    JMP ENDEXECUTE
    
    ;SHL DH,NUM
    SHLDH1ByNum:
    CMP firstOperandIndex,15
    JNE SHLDL1ByNum
    MOV addedValueToSIDest,7
    CALL SHLARegisterByteByNum
    JMP ENDEXECUTE
    
    ;SHL DL,NUM
    SHLDL1ByNum:
    CMP firstOperandIndex,16
    JE SHLDL2ByNum
    JMP NOTAVAILIDCOMMAND
    SHLDL2ByNum:
    MOV addedValueToSIDest,6
    CALL SHLARegisterByteByNum
    JMP ENDEXECUTE
    
    
    ;THIS IS FOR ROTATING REG USING CL
    SHLRegUsingCl:
    
    ;SHL AX,CL
    SHLAX1ByCL:
    CMP firstOperandIndex,1
    JNE SHLBX1ByCL
    MOV addedValueToSIDest,0
    CALL SHLARegisterWordByCL
    JMP ENDEXECUTE  
    
    ;SHL BX,CL
    SHLBX1ByCL:
    CMP firstOperandIndex,2
    JNE SHLCX1ByCL
    MOV addedValueToSIDest,1
    CALL SHLARegisterWordByCL
    JMP ENDEXECUTE
     
    ;SHL CX,CL
    SHLCX1ByCL:
    CMP firstOperandIndex,3
    JNE SHLDX1ByCL
    MOV addedValueToSIDest,2
    CALL SHLARegisterWordByCL
    JMP ENDEXECUTE
    
    ;SHL DX,CL
    SHLDX1ByCL:
    CMP firstOperandIndex,4
    JNE SHLSI1ByCL
    MOV addedValueToSIDest,3
    CALL SHLARegisterWordByCL
    JMP ENDEXECUTE
    
    ;SHL SI,CL
    SHLSI1ByCL:
    CMP firstOperandIndex,5
    JNE SHLDI1ByCL
    MOV addedValueToSIDest,4
    CALL SHLARegisterWordByCL
    JMP ENDEXECUTE
    
    ;SHL DI,CL
    SHLDI1ByCL:
    CMP firstOperandIndex,6
    JNE SHLSP1ByCL
    MOV addedValueToSIDest,5
    CALL SHLARegisterWordByCL
    JMP ENDEXECUTE
    
    ;SHL SP,CL
    SHLSP1ByCL:
    CMP firstOperandIndex,7
    JNE SHLBP1ByCL
    MOV addedValueToSIDest,6
    CALL SHLARegisterWordByCL
    JMP ENDEXECUTE
    
    ;SHL BP,CL
    SHLBP1ByCL:
    CMP firstOperandIndex,8
    JNE SHLAH1ByCL
    MOV addedValueToSIDest,7
    CALL SHLARegisterWordByCL
    JMP ENDEXECUTE
    
    ;SHL AH,CL
    SHLAH1ByCL:
    CMP firstOperandIndex,9
    JNE SHLAL1ByCL
    MOV addedValueToSIDest,1
    CALL SHLARegisterByteByCL
    JMP ENDEXECUTE
    
    ;SHL AL,CL
    SHLAL1ByCL:
    CMP firstOperandIndex,10
    JNE SHLBH1ByCL
    MOV addedValueToSIDest,0
    CALL SHLARegisterByteByCL
    JMP ENDEXECUTE
    
    ;SHL BH,CL
    SHLBH1ByCL:
    CMP firstOperandIndex,11
    JNE SHLBL1ByCL
    MOV addedValueToSIDest,3
    CALL SHLARegisterByteByCL
    JMP ENDEXECUTE
    
    ;SHL BL,CL
    SHLBL1ByCL:
    CMP firstOperandIndex,12
    JNE SHLCH1ByCL
    MOV addedValueToSIDest,2
    CALL SHLARegisterByteByCL
    JMP ENDEXECUTE
    
    ;SHL CH,CL
    SHLCH1ByCL:
    CMP firstOperandIndex,13
    JNE SHLCL1ByCL
    MOV addedValueToSIDest,5
    CALL SHLARegisterByteByCL
    JMP ENDEXECUTE
    
    ;SHL CL,CL
    SHLCL1ByCL:
    CMP firstOperandIndex,14
    JNE SHLDH1ByCL
    MOV addedValueToSIDest,4
    CALL SHLARegisterByteByCL
    JMP ENDEXECUTE
    
    ;SHL DH,CL
    SHLDH1ByCL:
    CMP firstOperandIndex,15
    JNE SHLDL1ByCL
    MOV addedValueToSIDest,7
    CALL SHLARegisterByteByCL
    JMP ENDEXECUTE
    
    ;SHL DL,CL
    SHLDL1ByCL:
    CMP firstOperandIndex,16
    JE SHLDL2ByCL
    JMP NOTAVAILIDCOMMAND
    SHLDL2ByCL:
    MOV addedValueToSIDest,6
    CALL SHLARegisterByteByCL
    JMP ENDEXECUTE
    
    
    ;this is the command for SI,BX,DI only
    SHLCommandForPointer:
    ;check if it's rotate by Cl or a number
    CMP secondOperandIndex,17
    JE SHLPointerRegUsingNum
    JMP SHLPointerRegUsingCL
    SHLPointerRegUsingNum:
    
    ;the Num must be Byte
    CMP numberEntered,255
    JLE SHLCOMMAND15
    JMP NOTAVAILIDCOMMAND
    SHLCOMMAND15:
    
    ;SHL [BX],NUM
    SHLBXPointerByNum:
    CMP firstOperandIndex,2
    JNE SHLSIPointerByNum
    MOV addedValueToSIDest,1 
    CALL SHLAMemoryByNum
    JMP ENDEXECUTE
    
    ;SHL [SI],NUM
    SHLSIPointerByNum:
    CMP firstOperandIndex,5
    JNE SHLDIPointerByNum
    MOV addedValueToSIDest,4
    CALL SHLAMemoryByNum
    JMP ENDEXECUTE
    
    ;SHL [DI],NUM
    SHLDIPointerByNum:
    CMP firstOperandIndex,6
    JE SHLDIPointerByNum1
    JMP NOTAVAILIDCOMMAND
    SHLDIPointerByNum1:
    MOV addedValueToSIDest,5
    CALL SHLAMemoryByNum
    JMP ENDEXECUTE
    
    ;rotate memory using CL
    SHLPointerRegUsingCL:
    
    ;SHL [BX],CL
    SHLBXPointerByCL:
    CMP firstOperandIndex,2
    JNE SHLSIPointerByCL 
    MOV addedValueToSIDest,1
    CALL SHLAMemoryByCL
    JMP ENDEXECUTE
    
    ;SHL [BX],CL
    SHLSIPointerByCL:
    CMP firstOperandIndex,5
    JNE SHLDIPointerByCL
    MOV addedValueToSIDest,4
    CALL SHLAMemoryByCL
    JMP ENDEXECUTE
    
    ;SHL [BX],CL
    SHLDIPointerByCL:
    CMP firstOperandIndex,6
    JE SHLDIPointerByCL1
    JMP NOTAVAILIDCOMMAND
    SHLDIPointerByCL1:
    MOV addedValueToSIDest,5
    CALL SHLAMemoryByCL
    JMP ENDEXECUTE
;------------------------------------------------------------------------------------------------   
    ;this is SAR command
    SARCOMMAND:
    CMP commandIndex,13
    JE SARCOMMAND1
    JMP ROLCOMMAND
    SARCOMMAND1:
    
    ;the second operand mustn't have brackets
    CMP isSecondOpBracket,1
    JNE SARCOMMAND11
    JMP NOTAVAILIDCOMMAND
    SARCOMMAND11:
    
    ;the second operand index is either 17 (Num) or 14 (CL) other than that error
    CMP secondOperandIndex,17
    JE SARCOMMAND12
    
    CMP secondOperandIndex,14
    JE SARCOMMAND12
    JMP NOTAVAILIDCOMMAND
    SARCOMMAND12:
    
    ;if there is a bracket then either BX or SI or DI
    CMP isFirstOpBracket,1
    JNE SARCOMMAND13
    JMP SARCommandForPointer
    SARCOMMAND13:
    
    ;internal check ti see if 2nd operand is CL or NUM
    CMP secondOperandIndex,17
    JE SARRegUsingNum
    JMP SARRegUsingCl
    SARRegUsingNum:
    
    ;the Num must be Byte
    CMP numberEntered,255
    JLE SARCOMMAND14
    JMP NOTAVAILIDCOMMAND
    SARCOMMAND14:
    
    ;SAR AX,NUM
    SARAX1ByNum:
    CMP firstOperandIndex,1
    JNE SARBX1ByNum
    MOV addedValueToSIDest,0
    CALL SARARegisterWordByNum
    JMP ENDEXECUTE  
    
    ;SAR BX,NUM
    SARBX1ByNum:
    CMP firstOperandIndex,2
    JNE SARCX1ByNum
    MOV addedValueToSIDest,1
    CALL SARARegisterWordByNum
    JMP ENDEXECUTE
     
    ;SAR CX,NUM
    SARCX1ByNum:
    CMP firstOperandIndex,3
    JNE SARDX1ByNum
    MOV addedValueToSIDest,2
    CALL SARARegisterWordByNum
    JMP ENDEXECUTE
    
    ;SAR DX,NUM
    SARDX1ByNum:
    CMP firstOperandIndex,4
    JNE SARSI1ByNum
    MOV addedValueToSIDest,3
    CALL SARARegisterWordByNum
    JMP ENDEXECUTE
    
    ;SAR SI,NUM
    SARSI1ByNum:
    CMP firstOperandIndex,5
    JNE SARDI1ByNum
    MOV addedValueToSIDest,4
    CALL SARARegisterWordByNum
    JMP ENDEXECUTE
    
    ;SAR DI,NUM
    SARDI1ByNum:
    CMP firstOperandIndex,6
    JNE SARSP1ByNum
    MOV addedValueToSIDest,5
    CALL SARARegisterWordByNum
    JMP ENDEXECUTE
    
    ;SAR SP,NUM
    SARSP1ByNum:
    CMP firstOperandIndex,7
    JNE SARBP1ByNum
    MOV addedValueToSIDest,6
    CALL SARARegisterWordByNum
    JMP ENDEXECUTE
    
    ;SAR BP,NUM
    SARBP1ByNum:
    CMP firstOperandIndex,8
    JNE SARAH1ByNum
    MOV addedValueToSIDest,7
    CALL SARARegisterWordByNum
    JMP ENDEXECUTE
    
    ;SAR AH,NUM
    SARAH1ByNum:
    CMP firstOperandIndex,9
    JNE SARAL1ByNum
    MOV addedValueToSIDest,1
    CALL SARARegisterByteByNum
    JMP ENDEXECUTE
    
    ;SAR AL,NUM
    SARAL1ByNum:
    CMP firstOperandIndex,10
    JNE SARBH1ByNum
    MOV addedValueToSIDest,0
    CALL SARARegisterByteByNum
    JMP ENDEXECUTE
    
    ;SAR BH,NUM
    SARBH1ByNum:
    CMP firstOperandIndex,11
    JNE SARBL1ByNum
    MOV addedValueToSIDest,3
    CALL SARARegisterByteByNum
    JMP ENDEXECUTE
    
    ;SAR BL,NUM
    SARBL1ByNum:
    CMP firstOperandIndex,12
    JNE SARCH1ByNum
    MOV addedValueToSIDest,2
    CALL SARARegisterByteByNum
    JMP ENDEXECUTE
    
    ;SAR CH,NUM
    SARCH1ByNum:
    CMP firstOperandIndex,13
    JNE SARCL1ByNum
    MOV addedValueToSIDest,5
    CALL SARARegisterByteByNum
    JMP ENDEXECUTE
    
    ;SAR CL,NUM
    SARCL1ByNum:
    CMP firstOperandIndex,14
    JNE SARDH1ByNum
    MOV addedValueToSIDest,4
    CALL SARARegisterByteByNum
    JMP ENDEXECUTE
    
    ;SAR DH,NUM
    SARDH1ByNum:
    CMP firstOperandIndex,15
    JNE SARDL1ByNum
    MOV addedValueToSIDest,7
    CALL SARARegisterByteByNum
    JMP ENDEXECUTE
    
    ;SAR DL,NUM
    SARDL1ByNum:
    CMP firstOperandIndex,16
    JE SARDL2ByNum
    JMP NOTAVAILIDCOMMAND
    SARDL2ByNum:
    MOV addedValueToSIDest,6
    CALL SARARegisterByteByNum
    JMP ENDEXECUTE
    
    
    ;THIS IS FOR ROTATING REG USING CL
    SARRegUsingCl:
    
    ;SAR AX,CL
    SARAX1ByCL:
    CMP firstOperandIndex,1
    JNE SARBX1ByCL
    MOV addedValueToSIDest,0
    CALL SARARegisterWordByCL
    JMP ENDEXECUTE  
    
    ;SAR BX,CL
    SARBX1ByCL:
    CMP firstOperandIndex,2
    JNE SARCX1ByCL
    MOV addedValueToSIDest,1
    CALL SARARegisterWordByCL
    JMP ENDEXECUTE
     
    ;SAR CX,CL
    SARCX1ByCL:
    CMP firstOperandIndex,3
    JNE SARDX1ByCL
    MOV addedValueToSIDest,2
    CALL SARARegisterWordByCL
    JMP ENDEXECUTE
    
    ;SAR DX,CL
    SARDX1ByCL:
    CMP firstOperandIndex,4
    JNE SARSI1ByCL
    MOV addedValueToSIDest,3
    CALL SARARegisterWordByCL
    JMP ENDEXECUTE
    
    ;SAR SI,CL
    SARSI1ByCL:
    CMP firstOperandIndex,5
    JNE SARDI1ByCL
    MOV addedValueToSIDest,4
    CALL SARARegisterWordByCL
    JMP ENDEXECUTE
    
    ;SAR DI,CL
    SARDI1ByCL:
    CMP firstOperandIndex,6
    JNE SARSP1ByCL
    MOV addedValueToSIDest,5
    CALL SARARegisterWordByCL
    JMP ENDEXECUTE
    
    ;SAR SP,CL
    SARSP1ByCL:
    CMP firstOperandIndex,7
    JNE SARBP1ByCL
    MOV addedValueToSIDest,6
    CALL SARARegisterWordByCL
    JMP ENDEXECUTE
    
    ;SAR BP,CL
    SARBP1ByCL:
    CMP firstOperandIndex,8
    JNE SARAH1ByCL
    MOV addedValueToSIDest,7
    CALL SARARegisterWordByCL
    JMP ENDEXECUTE
    
    ;SAR AH,CL
    SARAH1ByCL:
    CMP firstOperandIndex,9
    JNE SARAL1ByCL
    MOV addedValueToSIDest,1
    CALL SARARegisterByteByCL
    JMP ENDEXECUTE
    
    ;SAR AL,CL
    SARAL1ByCL:
    CMP firstOperandIndex,10
    JNE SARBH1ByCL
    MOV addedValueToSIDest,0
    CALL SARARegisterByteByCL
    JMP ENDEXECUTE
    
    ;SAR BH,CL
    SARBH1ByCL:
    CMP firstOperandIndex,11
    JNE SARBL1ByCL
    MOV addedValueToSIDest,3
    CALL SARARegisterByteByCL
    JMP ENDEXECUTE
    
    ;SAR BL,CL
    SARBL1ByCL:
    CMP firstOperandIndex,12
    JNE SARCH1ByCL
    MOV addedValueToSIDest,2
    CALL SARARegisterByteByCL
    JMP ENDEXECUTE
    
    ;SAR CH,CL
    SARCH1ByCL:
    CMP firstOperandIndex,13
    JNE SARCL1ByCL
    MOV addedValueToSIDest,5
    CALL SARARegisterByteByCL
    JMP ENDEXECUTE
    
    ;SAR CL,CL
    SARCL1ByCL:
    CMP firstOperandIndex,14
    JNE SARDH1ByCL
    MOV addedValueToSIDest,4
    CALL SARARegisterByteByCL
    JMP ENDEXECUTE
    
    ;SAR DH,CL
    SARDH1ByCL:
    CMP firstOperandIndex,15
    JNE SARDL1ByCL
    MOV addedValueToSIDest,7
    CALL SARARegisterByteByCL
    JMP ENDEXECUTE
    
    ;SAR DL,CL
    SARDL1ByCL:
    CMP firstOperandIndex,16
    JE SARDL2ByCL
    JMP NOTAVAILIDCOMMAND
    SARDL2ByCL:
    MOV addedValueToSIDest,6
    CALL SARARegisterByteByCL
    JMP ENDEXECUTE
    
    
    ;this is the command for SI,BX,DI only
    SARCommandForPointer:
    ;check if it's rotate by Cl or a number
    CMP secondOperandIndex,17
    JE SARPointerRegUsingNum
    JMP SARPointerRegUsingCL
    SARPointerRegUsingNum:
    
    ;the Num must be Byte
    CMP numberEntered,255
    JLE SARCOMMAND15
    JMP NOTAVAILIDCOMMAND
    SARCOMMAND15:
    
    ;SAR [BX],NUM
    SARBXPointerByNum:
    CMP firstOperandIndex,2
    JNE SARSIPointerByNum 
    MOV addedValueToSIDest,1
    CALL SARAMemoryByNum
    JMP ENDEXECUTE
    
    ;SAR [SI],NUM
    SARSIPointerByNum:
    CMP firstOperandIndex,5
    JNE SARDIPointerByNum
    MOV addedValueToSIDest,4
    CALL SARAMemoryByNum
    JMP ENDEXECUTE
    
    ;SAR [DI],NUM
    SARDIPointerByNum:
    CMP firstOperandIndex,6
    JE SARDIPointerByNum1
    JMP NOTAVAILIDCOMMAND
    SARDIPointerByNum1:
    MOV addedValueToSIDest,5
    CALL SARAMemoryByNum
    JMP ENDEXECUTE
    
    ;rotate memory using CL
    SARPointerRegUsingCL:
    
    ;SAR [BX],CL
    SARBXPointerByCL:
    CMP firstOperandIndex,2
    JNE SARSIPointerByCL
    MOV addedValueToSIDest,1 
    CALL SARAMemoryByCL
    JMP ENDEXECUTE
    
    ;SAR [BX],CL
    SARSIPointerByCL:
    CMP firstOperandIndex,5
    JNE SARDIPointerByCL
    MOV addedValueToSIDest,4
    CALL SARAMemoryByCL
    JMP ENDEXECUTE
    
    ;SAR [BX],CL
    SARDIPointerByCL:
    CMP firstOperandIndex,6
    JE SARDIPointerByCL1
    JMP NOTAVAILIDCOMMAND
    SARDIPointerByCL1:
    MOV addedValueToSIDest,5
    CALL SARAMemoryByCL
    JMP ENDEXECUTE
;------------------------------------------------------------------------------------------------   
    ;this is ROL command
    ROLCOMMAND:
    CMP commandIndex,14
    JE ROLCOMMAND1
    JMP RORCOMMAND
    ROLCOMMAND1:
    
    ;the second operand mustn't have brackets
    CMP isSecondOpBracket,1
    JNE ValidCommand12
    JMP NOTAVAILIDCOMMAND
    ValidCommand12:
    
    ;the second operand index is either 17 (Num) or 14 (CL) other than that error
    CMP secondOperandIndex,17
    JE ValidCommand13
    
    CMP secondOperandIndex,14
    JE ValidCommand13
    JMP NOTAVAILIDCOMMAND
    ValidCommand13:
    
    ;if there is a bracket then either BX or SI or DI
    CMP isFirstOpBracket,1
    JNE ValidCommand14
    JMP ROLCommandForPointer
    ValidCommand14:
    
    ;internal check ti see if 2nd operand is CL or NUM
    CMP secondOperandIndex,17
    JE ROLRegUsingNum
    JMP ROLRegUsingCl
    ROLRegUsingNum:
    
    ;the Num must be Byte
    CMP numberEntered,255
    JLE AValidNum1
    JMP NOTAVAILIDCOMMAND
    AValidNum1:
    
    ;ROL AX,NUM
    ROLAX1ByNum:
    CMP firstOperandIndex,1
    JNE ROLBX1ByNum
    MOV addedValueToSIDest,0
    CALL ROLARegisterWordByNum
    JMP ENDEXECUTE  
    
    ;ROL BX,NUM
    ROLBX1ByNum:
    CMP firstOperandIndex,2
    JNE ROLCX1ByNum
    MOV addedValueToSIDest,1
    CALL ROLARegisterWordByNum
    JMP ENDEXECUTE
     
    ;ROL CX,NUM
    ROLCX1ByNum:
    CMP firstOperandIndex,3
    JNE ROLDX1ByNum
    MOV addedValueToSIDest,2
    CALL ROLARegisterWordByNum
    JMP ENDEXECUTE
    
    ;ROL DX,NUM
    ROLDX1ByNum:
    CMP firstOperandIndex,4
    JNE ROLSI1ByNum
    MOV addedValueToSIDest,3
    CALL ROLARegisterWordByNum
    JMP ENDEXECUTE
    
    ;ROL SI,NUM
    ROLSI1ByNum:
    CMP firstOperandIndex,5
    JNE ROLDI1ByNum
    MOV addedValueToSIDest,4
    CALL ROLARegisterWordByNum
    JMP ENDEXECUTE
    
    ;ROL DI,NUM
    ROLDI1ByNum:
    CMP firstOperandIndex,6
    JNE ROLSP1ByNum
    MOV addedValueToSIDest,5
    CALL ROLARegisterWordByNum
    JMP ENDEXECUTE
    
    ;ROL SP,NUM
    ROLSP1ByNum:
    CMP firstOperandIndex,7
    JNE ROLBP1ByNum
    MOV addedValueToSIDest,6
    CALL ROLARegisterWordByNum
    JMP ENDEXECUTE
    
    ;ROL BP,NUM
    ROLBP1ByNum:
    CMP firstOperandIndex,8
    JNE ROLAH1ByNum
    MOV addedValueToSIDest,7
    CALL ROLARegisterWordByNum
    JMP ENDEXECUTE
    
    ;ROL AH,NUM
    ROLAH1ByNum:
    CMP firstOperandIndex,9
    JNE ROLAL1ByNum
    MOV addedValueToSIDest,1
    CALL ROLARegisterByteByNum
    JMP ENDEXECUTE
    
    ;ROL AL,NUM
    ROLAL1ByNum:
    CMP firstOperandIndex,10
    JNE ROLBH1ByNum
    MOV addedValueToSIDest,0
    CALL ROLARegisterByteByNum
    JMP ENDEXECUTE
    
    ;ROL BH,NUM
    ROLBH1ByNum:
    CMP firstOperandIndex,11
    JNE ROLBL1ByNum
    MOV addedValueToSIDest,3
    CALL ROLARegisterByteByNum
    JMP ENDEXECUTE
    
    ;ROL BL,NUM
    ROLBL1ByNum:
    CMP firstOperandIndex,12
    JNE ROLCH1ByNum
    MOV addedValueToSIDest,2
    CALL ROLARegisterByteByNum
    JMP ENDEXECUTE
    
    ;ROL CH,NUM
    ROLCH1ByNum:
    CMP firstOperandIndex,13
    JNE ROLCL1ByNum
    MOV addedValueToSIDest,5
    CALL ROLARegisterByteByNum
    JMP ENDEXECUTE
    
    ;ROL CL,NUM
    ROLCL1ByNum:
    CMP firstOperandIndex,14
    JNE ROLDH1ByNum
    MOV addedValueToSIDest,4
    CALL ROLARegisterByteByNum
    JMP ENDEXECUTE
    
    ;ROL DH,NUM
    ROLDH1ByNum:
    CMP firstOperandIndex,15
    JNE ROLDL1ByNum
    MOV addedValueToSIDest,7
    CALL ROLARegisterByteByNum
    JMP ENDEXECUTE
    
    ;ROL DL,NUM
    ROLDL1ByNum:
    CMP firstOperandIndex,16
    JE ROLDL2ByNum
    JMP NOTAVAILIDCOMMAND
    ROLDL2ByNum:
    MOV addedValueToSIDest,6
    CALL ROLARegisterByteByNum
    JMP ENDEXECUTE
    
    
    ;THIS IS FOR ROTATING REG USING CL
    ROLRegUsingCl:
    
    ;ROL AX,CL
    ROLAX1ByCL:
    CMP firstOperandIndex,1
    JNE ROLBX1ByCL
    MOV addedValueToSIDest,0
    CALL ROLARegisterWordByCL
    JMP ENDEXECUTE  
    
    ;ROL BX,CL
    ROLBX1ByCL:
    CMP firstOperandIndex,2
    JNE ROLCX1ByCL
    MOV addedValueToSIDest,1
    CALL ROLARegisterWordByCL
    JMP ENDEXECUTE
     
    ;ROL CX,CL
    ROLCX1ByCL:
    CMP firstOperandIndex,3
    JNE ROLDX1ByCL
    MOV addedValueToSIDest,2
    CALL ROLARegisterWordByCL
    JMP ENDEXECUTE
    
    ;ROL DX,CL
    ROLDX1ByCL:
    CMP firstOperandIndex,4
    JNE ROLSI1ByCL
    MOV addedValueToSIDest,3
    CALL ROLARegisterWordByCL
    JMP ENDEXECUTE
    
    ;ROL SI,CL
    ROLSI1ByCL:
    CMP firstOperandIndex,5
    JNE ROLDI1ByCL
    MOV addedValueToSIDest,4
    CALL ROLARegisterWordByCL
    JMP ENDEXECUTE
    
    ;ROL DI,CL
    ROLDI1ByCL:
    CMP firstOperandIndex,6
    JNE ROLSP1ByCL
    MOV addedValueToSIDest,5
    CALL ROLARegisterWordByCL
    JMP ENDEXECUTE
    
    ;ROL SP,CL
    ROLSP1ByCL:
    CMP firstOperandIndex,7
    JNE ROLBP1ByCL
    MOV addedValueToSIDest,6
    CALL ROLARegisterWordByCL
    JMP ENDEXECUTE
    
    ;ROL BP,CL
    ROLBP1ByCL:
    CMP firstOperandIndex,8
    JNE ROLAH1ByCL
    MOV addedValueToSIDest,7
    CALL ROLARegisterWordByCL
    JMP ENDEXECUTE
    
    ;ROL AH,CL
    ROLAH1ByCL:
    CMP firstOperandIndex,9
    JNE ROLAL1ByCL
    MOV addedValueToSIDest,1
    CALL ROLARegisterByteByCL
    JMP ENDEXECUTE
    
    ;ROL AL,CL
    ROLAL1ByCL:
    CMP firstOperandIndex,10
    JNE ROLBH1ByCL
    MOV addedValueToSIDest,0
    CALL ROLARegisterByteByCL
    JMP ENDEXECUTE
    
    ;ROL BH,CL
    ROLBH1ByCL:
    CMP firstOperandIndex,11
    JNE ROLBL1ByCL
    MOV addedValueToSIDest,3
    CALL ROLARegisterByteByCL
    JMP ENDEXECUTE
    
    ;ROL BL,CL
    ROLBL1ByCL:
    CMP firstOperandIndex,12
    JNE ROLCH1ByCL
    MOV addedValueToSIDest,2
    CALL ROLARegisterByteByCL
    JMP ENDEXECUTE
    
    ;ROL CH,CL
    ROLCH1ByCL:
    CMP firstOperandIndex,13
    JNE ROLCL1ByCL
    MOV addedValueToSIDest,5
    CALL ROLARegisterByteByCL
    JMP ENDEXECUTE
    
    ;ROL CL,CL
    ROLCL1ByCL:
    CMP firstOperandIndex,14
    JNE ROLDH1ByCL
    MOV addedValueToSIDest,4
    CALL ROLARegisterByteByCL
    JMP ENDEXECUTE
    
    ;ROL DH,CL
    ROLDH1ByCL:
    CMP firstOperandIndex,15
    JNE ROLDL1ByCL
    MOV addedValueToSIDest,7
    CALL ROLARegisterByteByCL
    JMP ENDEXECUTE
    
    ;ROL DL,CL
    ROLDL1ByCL:
    CMP firstOperandIndex,16
    JE ROLDL2ByCL
    JMP NOTAVAILIDCOMMAND
    ROLDL2ByCL:
    MOV addedValueToSIDest,6
    CALL ROLARegisterByteByCL
    JMP ENDEXECUTE
    
    
    ;this is the command for SI,BX,DI only
    ROLCommandForPointer:
    ;check if it's rotate by Cl or a number
    CMP secondOperandIndex,17
    JE ROLPointerRegUsingNum
    JMP ROLPointerRegUsingCL
    ROLPointerRegUsingNum:
    
    ;the Num must be Byte
    CMP numberEntered,255
    JLE AValidNum2
    JMP NOTAVAILIDCOMMAND
    AValidNum2:
    
    ;ROL [BX],NUM
    ROLBXPointerByNum:
    CMP firstOperandIndex,2
    JNE ROLSIPointerByNum
    MOV addedValueToSIDest,1 
    CALL ROLAMemoryByNum
    JMP ENDEXECUTE
    
    ;ROL [SI],NUM
    ROLSIPointerByNum:
    CMP firstOperandIndex,5
    JNE ROLDIPointerByNum
    MOV addedValueToSIDest,4
    CALL ROLAMemoryByNum
    JMP ENDEXECUTE
    
    ;ROL [DI],NUM
    ROLDIPointerByNum:
    CMP firstOperandIndex,6
    JE ROLDIPointerByNum1
    JMP NOTAVAILIDCOMMAND
    ROLDIPointerByNum1:
    MOV addedValueToSIDest,5
    CALL ROLAMemoryByNum
    JMP ENDEXECUTE
    
    ;rotate memory using CL
    ROLPointerRegUsingCL:
    
    ;ROL [BX],CL
    ROLBXPointerByCL:
    CMP firstOperandIndex,2
    JNE ROLSIPointerByCL 
    MOV addedValueToSIDest,1
    CALL ROLAMemoryByCL
    JMP ENDEXECUTE
    
    ;ROL [BX],CL
    ROLSIPointerByCL:
    CMP firstOperandIndex,5
    JNE ROLDIPointerByCL
    MOV addedValueToSIDest,4
    CALL ROLAMemoryByCL
    JMP ENDEXECUTE
    
    ;ROL [BX],CL
    ROLDIPointerByCL:
    CMP firstOperandIndex,6
    JE ROLDIPointerByCL1
    JMP NOTAVAILIDCOMMAND
    ROLDIPointerByCL1:
    MOV addedValueToSIDest,5
    CALL ROLAMemoryByCL
    JMP ENDEXECUTE
;------------------------------------------------------------------------------------------------  
    ;this is ROR command
    RORCOMMAND:
    CMP commandIndex,15
    JE RORCOMMAND1
    JMP PUSHCOMMAND
    RORCOMMAND1:
    
    ;the second operand mustn't have brackets
    CMP isSecondOpBracket,1
    JNE ValidCommand11
    JMP NOTAVAILIDCOMMAND
    ValidCommand11:
    
    ;the second operand index is either 17 (Num) or 14 (CL) other than that error
    CMP secondOperandIndex,17
    JE ValidCommand10
    
    CMP secondOperandIndex,14
    JE ValidCommand10
    JMP NOTAVAILIDCOMMAND
    ValidCommand10:
    
    ;if there is a bracket then either BX or SI or DI
    CMP isFirstOpBracket,1
    JNE ValidCommand9
    JMP RORCommandForPointer
    ValidCommand9:
    
    ;internal check ti see if 2nd operand is CL or NUM
    CMP secondOperandIndex,17
    JE RORRegUsingNum
    JMP RORRegUsingCl
    RORRegUsingNum:
    
    ;the Num must be Byte
    CMP numberEntered,255
    JLE AValidNum3
    JMP NOTAVAILIDCOMMAND
    AValidNum3:
    
    ;ROR AX,NUM
    RORAX1ByNum:
    CMP firstOperandIndex,1
    JNE RORBX1ByNum
    MOV addedValueToSIDest,0
    CALL RORARegisterWordByNum
    JMP ENDEXECUTE  
    
    ;ROR BX,NUM
    RORBX1ByNum:
    CMP firstOperandIndex,2
    JNE RORCX1ByNum
    MOV addedValueToSIDest,1
    CALL RORARegisterWordByNum
    JMP ENDEXECUTE
     
    ;ROR CX,NUM
    RORCX1ByNum:
    CMP firstOperandIndex,3
    JNE RORDX1ByNum
    MOV addedValueToSIDest,2
    CALL RORARegisterWordByNum
    JMP ENDEXECUTE
    
    ;ROR DX,NUM
    RORDX1ByNum:
    CMP firstOperandIndex,4
    JNE RORSI1ByNum
    MOV addedValueToSIDest,3
    CALL RORARegisterWordByNum
    JMP ENDEXECUTE
    
    ;ROR SI,NUM
    RORSI1ByNum:
    CMP firstOperandIndex,5
    JNE RORDI1ByNum
    MOV addedValueToSIDest,4
    CALL RORARegisterWordByNum
    JMP ENDEXECUTE
    
    ;ROR DI,NUM
    RORDI1ByNum:
    CMP firstOperandIndex,6
    JNE RORSP1ByNum
    MOV addedValueToSIDest,5
    CALL RORARegisterWordByNum
    JMP ENDEXECUTE
    
    ;ROR SP,NUM
    RORSP1ByNum:
    CMP firstOperandIndex,7
    JNE RORBP1ByNum
    MOV addedValueToSIDest,6
    CALL RORARegisterWordByNum
    JMP ENDEXECUTE
    
    ;ROR BP,NUM
    RORBP1ByNum:
    CMP firstOperandIndex,8
    JNE RORAH1ByNum
    MOV addedValueToSIDest,7
    CALL RORARegisterWordByNum
    JMP ENDEXECUTE
    
    ;ROR AH,NUM
    RORAH1ByNum:
    CMP firstOperandIndex,9
    JNE RORAL1ByNum
    MOV addedValueToSIDest,1
    CALL RORARegisterByteByNum
    JMP ENDEXECUTE
    
    ;ROR AL,NUM
    RORAL1ByNum:
    CMP firstOperandIndex,10
    JNE RORBH1ByNum
    MOV addedValueToSIDest,0
    CALL RORARegisterByteByNum
    JMP ENDEXECUTE
    
    ;ROR BH,NUM
    RORBH1ByNum:
    CMP firstOperandIndex,11
    JNE RORBL1ByNum
    MOV addedValueToSIDest,3
    CALL RORARegisterByteByNum
    JMP ENDEXECUTE
    
    ;ROR BL,NUM
    RORBL1ByNum:
    CMP firstOperandIndex,12
    JNE RORCH1ByNum
    MOV addedValueToSIDest,2
    CALL RORARegisterByteByNum
    JMP ENDEXECUTE
    
    ;ROR CH,NUM
    RORCH1ByNum:
    CMP firstOperandIndex,13
    JNE RORCL1ByNum
    MOV addedValueToSIDest,5
    CALL RORARegisterByteByNum
    JMP ENDEXECUTE
    
    ;ROR CL,NUM
    RORCL1ByNum:
    CMP firstOperandIndex,14
    JNE RORDH1ByNum
    MOV addedValueToSIDest,4
    CALL RORARegisterByteByNum
    JMP ENDEXECUTE
    
    ;ROR DH,NUM
    RORDH1ByNum:
    CMP firstOperandIndex,15
    JNE RORDL1ByNum
    MOV addedValueToSIDest,7
    CALL RORARegisterByteByNum
    JMP ENDEXECUTE
    
    ;ROR DL,NUM
    RORDL1ByNum:
    CMP firstOperandIndex,16
    JE RORDL2ByNum
    JMP NOTAVAILIDCOMMAND
    RORDL2ByNum:
    MOV addedValueToSIDest,6
    CALL RORARegisterByteByNum
    JMP ENDEXECUTE
    
    
    ;THIS IS FOR ROTATING REG USING CL
    RORRegUsingCl:
    
    ;ROR AX,CL
    RORAX1ByCL:
    CMP firstOperandIndex,1
    JNE RORBX1ByCL
    MOV addedValueToSIDest,0
    CALL RORARegisterWordByCL
    JMP ENDEXECUTE  
    
    ;ROR BX,CL
    RORBX1ByCL:
    CMP firstOperandIndex,2
    JNE RORCX1ByCL
    MOV addedValueToSIDest,1
    CALL RORARegisterWordByCL
    JMP ENDEXECUTE
     
    ;ROR CX,CL
    RORCX1ByCL:
    CMP firstOperandIndex,3
    JNE RORDX1ByCL
    MOV addedValueToSIDest,2
    CALL RORARegisterWordByCL
    JMP ENDEXECUTE
    
    ;ROR DX,CL
    RORDX1ByCL:
    CMP firstOperandIndex,4
    JNE RORSI1ByCL
    MOV addedValueToSIDest,3
    CALL RORARegisterWordByCL
    JMP ENDEXECUTE
    
    ;ROR SI,CL
    RORSI1ByCL:
    CMP firstOperandIndex,5
    JNE RORDI1ByCL
    MOV addedValueToSIDest,4
    CALL RORARegisterWordByCL
    JMP ENDEXECUTE
    
    ;ROR DI,CL
    RORDI1ByCL:
    CMP firstOperandIndex,6
    JNE RORSP1ByCL
    MOV addedValueToSIDest,5
    CALL RORARegisterWordByCL
    JMP ENDEXECUTE
    
    ;ROR SP,CL
    RORSP1ByCL:
    CMP firstOperandIndex,7
    JNE RORBP1ByCL
    MOV addedValueToSIDest,6
    CALL RORARegisterWordByCL
    JMP ENDEXECUTE
    
    ;ROR BP,CL
    RORBP1ByCL:
    CMP firstOperandIndex,8
    JNE RORAH1ByCL
    MOV addedValueToSIDest,7
    CALL RORARegisterWordByCL
    JMP ENDEXECUTE
    
    ;ROR AH,CL
    RORAH1ByCL:
    CMP firstOperandIndex,9
    JNE RORAL1ByCL
    MOV addedValueToSIDest,1
    CALL RORARegisterByteByCL
    JMP ENDEXECUTE
    
    ;ROR AL,CL
    RORAL1ByCL:
    CMP firstOperandIndex,10
    JNE RORBH1ByCL
    MOV addedValueToSIDest,0
    CALL RORARegisterByteByCL
    JMP ENDEXECUTE
    
    ;ROR BH,CL
    RORBH1ByCL:
    CMP firstOperandIndex,11
    JNE RORBL1ByCL
    MOV addedValueToSIDest,3
    CALL RORARegisterByteByCL
    JMP ENDEXECUTE
    
    ;ROR BL,CL
    RORBL1ByCL:
    CMP firstOperandIndex,12
    JNE RORCH1ByCL
    MOV addedValueToSIDest,2
    CALL RORARegisterByteByCL
    JMP ENDEXECUTE
    
    ;ROR CH,CL
    RORCH1ByCL:
    CMP firstOperandIndex,13
    JNE RORCL1ByCL
    MOV addedValueToSIDest,5
    CALL RORARegisterByteByCL
    JMP ENDEXECUTE
    
    ;ROR CL,CL
    RORCL1ByCL:
    CMP firstOperandIndex,14
    JNE RORDH1ByCL
    MOV addedValueToSIDest,4
    CALL RORARegisterByteByCL
    JMP ENDEXECUTE
    
    ;ROR DH,CL
    RORDH1ByCL:
    CMP firstOperandIndex,15
    JNE RORDL1ByCL
    MOV addedValueToSIDest,7
    CALL RORARegisterByteByCL
    JMP ENDEXECUTE
    
    ;ROR DL,CL
    RORDL1ByCL:
    CMP firstOperandIndex,16
    JE RORDL2ByCL
    JMP NOTAVAILIDCOMMAND
    RORDL2ByCL:
    MOV addedValueToSIDest,6
    CALL RORARegisterByteByCL
    JMP ENDEXECUTE
    
    
    ;this is the command for SI,BX,DI only
    RORCommandForPointer:
    ;check if it's rotate by Cl or a number
    CMP secondOperandIndex,17
    JE RORPointerRegUsingNum
    JMP RORPointerRegUsingCL
    RORPointerRegUsingNum:
    
    ;the Num must be Byte
    CMP numberEntered,255
    JLE AValidNum4
    JMP NOTAVAILIDCOMMAND
    AValidNum4:
    
    ;ROR [BX],NUM
    RORBXPointerByNum:
    CMP firstOperandIndex,2
    JNE RORSIPointerByNum 
    MOV addedValueToSIDest,1
    CALL RORAMemoryByNum
    JMP ENDEXECUTE
    
    ;ROR [SI],NUM
    RORSIPointerByNum:
    CMP firstOperandIndex,5
    JNE RORDIPointerByNum
    MOV addedValueToSIDest,4
    CALL RORAMemoryByNum
    JMP ENDEXECUTE
    
    ;ROR [DI],NUM
    RORDIPointerByNum:
    CMP firstOperandIndex,6
    JE RORDIPointerByNum1
    JMP NOTAVAILIDCOMMAND
    RORDIPointerByNum1:
    MOV addedValueToSIDest,5
    CALL RORAMemoryByNum
    JMP ENDEXECUTE
    
    ;rotate memory using CL
    RORPointerRegUsingCL:
    
    ;ROR [BX],CL
    RORBXPointerByCL:
    CMP firstOperandIndex,2
    JNE RORSIPointerByCL
    MOV addedValueToSIDest,1 
    CALL RORAMemoryByCL
    JMP ENDEXECUTE
    
    ;ROR [BX],CL
    RORSIPointerByCL:
    CMP firstOperandIndex,5
    JNE RORDIPointerByCL
    MOV addedValueToSIDest,4
    CALL RORAMemoryByCL
    JMP ENDEXECUTE
    
    ;ROR [BX],CL
    RORDIPointerByCL:
    CMP firstOperandIndex,6
    JE RORDIPointerByCL1
    JMP NOTAVAILIDCOMMAND
    RORDIPointerByCL1:
    MOV addedValueToSIDest,5
    CALL RORAMemoryByCL
    JMP ENDEXECUTE
;------------------------------------------------------------------------------------------------
    ;this is a PUSH command
    PUSHCOMMAND:
    CMP commandIndex,16
    JE PUSHCOMMAND1
    JMP POPCOMMAND
    PUSHCOMMAND1:
    
    ;if there is a bracket then error
    CMP isFirstOpBracket,1
    JNE ValidCommand1
    JMP NOTAVAILIDCOMMAND
    ValidCommand1:
    
    ;PUSH AX
    PUSHAX1:
    CMP firstOperandIndex,1
    JNE PUSHBX1
    MOV addedValueToSIDest,0
    CALL pushIntoStack
    JMP ENDEXECUTE
    
    ;PUSH BX
    PUSHBX1:
    CMP firstOperandIndex,2
    JNE PUSHCX1
    MOV addedValueToSIDest,2
    CALL pushIntoStack
    JMP ENDEXECUTE
    
    ;PUSH CX
    PUSHCX1:
    CMP firstOperandIndex,3
    JNE PUSHDX1
    MOV addedValueToSIDest,4
    CALL pushIntoStack
    JMP ENDEXECUTE    
    
    ;PUSH DX
    PUSHDX1:
    CMP firstOperandIndex,4
    JNE PUSHSI1
    MOV addedValueToSIDest,6
    CALL pushIntoStack
    JMP ENDEXECUTE     
    
    ;PUSH SI
    PUSHSI1:
    CMP firstOperandIndex,5
    JNE PUSHDI1
    MOV addedValueToSIDest,8
    CALL pushIntoStack
    JMP ENDEXECUTE      
    
    ;PUSH DI
    PUSHDI1:
    CMP firstOperandIndex,6
    JNE PUSHSP1
    MOV addedValueToSIDest,10
    CALL pushIntoStack
    JMP ENDEXECUTE      
    
    ;PUSH SP
    PUSHSP1:
    CMP firstOperandIndex,7
    JNE PUSHBP1
    MOV addedValueToSIDest,12
    CALL pushIntoStack
    JMP ENDEXECUTE     
    
    ;PUSH BP
    PUSHBP1:
    CMP firstOperandIndex,8
    JE PUSHBP2
    JMP NOTAVAILIDCOMMAND
    PUSHBP2:
    MOV addedValueToSIDest,14
    CALL pushIntoStack
    JMP ENDEXECUTE    
;------------------------------------------------------------------------------------------------    
    ;this is a POP command
    POPCOMMAND:  
    CMP commandIndex,17
    JE POPCOMMAND1
    JMP INCCOMMAND
    POPCOMMAND1:
    
    ;if there is a bracket then error
    CMP isFirstOpBracket,1
    JNE ValidCommand2
    JMP NOTAVAILIDCOMMAND
    ValidCommand2:
    
    ;POP AX
    POPAX1:
    CMP firstOperandIndex,1
    JNE POPBX1
    MOV addedValueToSIDest,0
    CALL popFromStack 
    JMP ENDEXECUTE
    
    ;POP BX
    POPBX1:
    CMP firstOperandIndex,2
    JNE POPCX1
    MOV addedValueToSIDest,2
    CALL popFromStack
    JMP ENDEXECUTE
 
    ;POP CX
    POPCX1:
    CMP firstOperandIndex,3
    JNE POPDX1
    MOV addedValueToSIDest,4
    CALL popFromStack
    JMP ENDEXECUTE 
 
    ;POP DX
    POPDX1:
    CMP firstOperandIndex,4
    JNE POPSI1
    MOV addedValueToSIDest,6
    CALL popFromStack
    JMP ENDEXECUTE 
    
    ;POP SI
    POPSI1:
    CMP firstOperandIndex,5
    JNE POPDI1
    MOV addedValueToSIDest,8
    CALL popFromStack
    JMP ENDEXECUTE 
    
    ;POP DI
    POPDI1:
    CMP firstOperandIndex,6
    JNE POPSP1
    MOV addedValueToSIDest,10
    CALL popFromStack 
    JMP ENDEXECUTE 
 
    ;POPSP
    POPSP1:
    CMP firstOperandIndex,7
    JNE POPBP1
    MOV addedValueToSIDest,12
    CALL popFromStack
    JMP ENDEXECUTE 
    
    ;POP BP
    POPBP1: 
    CMP firstOperandIndex,8
    JE POPBP1
    JMP NOTAVAILIDCOMMAND
    POPBP2:
    MOV addedValueToSIDest,14
    CALL popFromStack
    JMP ENDEXECUTE  
;------------------------------------------------------------------------------------------------    
    ;this is a INC command
    INCCOMMAND:
    CMP commandIndex,18
    JE INCCOMMAND1
    JMP DECCOMMAND
    INCCOMMAND1:
    
    ;if there is a bracket then either BX or SI or DI
    CMP isFirstOpBracket,1
    JNE ValidCommand3
    JMP INCCommandForPointer
    ValidCommand3:
    
    ;INC AX
    INCAX1:
    CMP firstOperandIndex,1
    JNE INCBX1
    MOV addedValueToSIDest,0
    CALL increment8BitReg
    JMP ENDEXECUTE  
    
    ;INC BX
    INCBX1:
    CMP firstOperandIndex,2
    JNE INCCX1
    MOV addedValueToSIDest,2
    CALL increment8BitReg
    JMP ENDEXECUTE
     
    ;INC CX
    INCCX1:
    CMP firstOperandIndex,3
    JNE INCDX1
    MOV addedValueToSIDest,4
    CALL increment8BitReg
    JMP ENDEXECUTE
    
    ;INC DX
    INCDX1:
    CMP firstOperandIndex,4
    JNE INCSI1
    MOV addedValueToSIDest,6
    CALL increment8BitReg
    JMP ENDEXECUTE
    
    ;INC SI
    INCSI1:
    CMP firstOperandIndex,5
    JNE INCDI1
    MOV addedValueToSIDest,8
    CALL increment8BitReg
    JMP ENDEXECUTE
    
    ;INC DI
    INCDI1:
    CMP firstOperandIndex,6
    JNE INCSP1
    MOV addedValueToSIDest,10
    CALL increment8BitReg
    JMP ENDEXECUTE
    
    ;INC SP
    INCSP1:
    CMP firstOperandIndex,7
    JNE INCBP1
    MOV addedValueToSIDest,12
    CALL increment8BitReg 
    JMP ENDEXECUTE
    
    ;INC BP
    INCBP1:
    CMP firstOperandIndex,8
    JNE INCAH1
    MOV addedValueToSIDest,14
    CALL increment8BitReg
    JMP ENDEXECUTE
    
    ;INC AH
    INCAH1:
    CMP firstOperandIndex,9
    JNE INCAL1
    MOV addedValueToSIDest,1
    CALL increment4BitReg
    JMP ENDEXECUTE
    
    ;INC AL
    INCAL1:
    CMP firstOperandIndex,10
    JNE INCBH1
    MOV addedValueToSIDest,0
    CALL increment4BitReg
    JMP ENDEXECUTE
    
    ;INC BH
    INCBH1:
    CMP firstOperandIndex,11
    JNE INCBL1
    MOV addedValueToSIDest,3
    CALL increment4BitReg
    JMP ENDEXECUTE
    
    ;INC BL
    INCBL1:
    CMP firstOperandIndex,12
    JNE INCCH1
    MOV addedValueToSIDest,2
    CALL increment4BitReg
    JMP ENDEXECUTE
    
    ;INC CH
    INCCH1:
    CMP firstOperandIndex,13
    JNE INCCL1
    MOV addedValueToSIDest,5
    CALL increment4BitReg
    JMP ENDEXECUTE
    
    ;INC CL
    INCCL1:
    CMP firstOperandIndex,14
    JNE INCDH1
    MOV addedValueToSIDest,4
    CALL increment4BitReg
    JMP ENDEXECUTE
    
    ;INC DH
    INCDH1:
    CMP firstOperandIndex,15
    JNE INCDL1
    MOV addedValueToSIDest,7
    CALL increment4BitReg
    JMP ENDEXECUTE
    
    ;INC DL
    INCDL1:
    CMP firstOperandIndex,16
    JE INCDL2
    JMP NOTAVAILIDCOMMAND
    INCDL2:
    MOV addedValueToSIDest,6
    CALL increment4BitReg
    JMP ENDEXECUTE
    
    INCCommandForPointer:
    
    ;INC [BX]
    INCBXPOINTER:
    CMP firstOperandIndex,2
    JNE INCSIPOINTER
    MOV addedValueToSIDest,1 
    CALL incrementPointer
    JMP ENDEXECUTE
    
    ;INC [SI]
    INCSIPOINTER:
    CMP firstOperandIndex,5
    JNE INCDIPOINTER
    MOV addedValueToSIDest,4
    CALL incrementPointer
    JMP ENDEXECUTE
    
    ;INC [DI]
    INCDIPOINTER:
    CMP firstOperandIndex,6
    JE INCDIPOINTER1
    JMP NOTAVAILIDCOMMAND
    INCDIPOINTER1:
    MOV addedValueToSIDest,5
    CALL incrementPointer
    JMP ENDEXECUTE
;------------------------------------------------------------------------------------------------    
    ;this is a DEC command
    DECCOMMAND:
    CMP commandIndex,19
    JE DECCOMMAND1
    JMP IMULCOMMAND
    DECCOMMAND1:
    
    ;if there is a bracket then either BX or SI or DI
    CMP isFirstOpBracket,1
    JNE ValidCommand4
    JMP DECCommandForPointer
    ValidCommand4:
        
    ;DEC AX
    DECAX1:
    CMP firstOperandIndex,1
    JNE DECBX1
    MOV addedValueToSIDest,0
    CALL decrement8BitReg
    JMP ENDEXECUTE  
    
    ;DEC BX
    DECBX1:
    CMP firstOperandIndex,2
    JNE DECCX1
    MOV addedValueToSIDest,2
    CALL decrement8BitReg
    JMP ENDEXECUTE    
    
    ;DEC CX
    DECCX1:
    CMP firstOperandIndex,3
    JNE DECDX1
    MOV addedValueToSIDest,4
    CALL decrement8BitReg
    JMP ENDEXECUTE
    
    ;DEC DX
    DECDX1:
    CMP firstOperandIndex,4
    JNE DECSI1
    MOV addedValueToSIDest,6
    CALL decrement8BitReg
    JMP ENDEXECUTE
    
    ;DEC SI
    DECSI1:
    CMP firstOperandIndex,5
    JNE DECDI1
    MOV addedValueToSIDest,8
    CALL decrement8BitReg
    JMP ENDEXECUTE
    
    ;DEC DI
    DECDI1:
    CMP firstOperandIndex,6
    JNE DECSP1
    MOV addedValueToSIDest,10
    CALL decrement8BitReg 
    JMP ENDEXECUTE
    
    ;DEC SP
    DECSP1:
    CMP firstOperandIndex,7
    JNE DECBP1
    MOV addedValueToSIDest,12
    CALL decrement8BitReg 
    JMP ENDEXECUTE
    
    ;DEC BP
    DECBP1:
    CMP firstOperandIndex,8
    JNE DECAH1
    MOV addedValueToSIDest,14
    CALL decrement8BitReg
    JMP ENDEXECUTE
    
    ;DEC AH
    DECAH1:
    CMP firstOperandIndex,9
    JNE DECAL1
    MOV addedValueToSIDest,1
    CALL decrement4BitReg
    JMP ENDEXECUTE
    
    ;DEC AL
    DECAL1:
    CMP firstOperandIndex,10
    JNE DECBH1
    MOV addedValueToSIDest,0
    CALL decrement4BitReg
    JMP ENDEXECUTE
    
    ;DEC BH
    DECBH1:
    CMP firstOperandIndex,11
    JNE DECBL1
    MOV addedValueToSIDest,3
    CALL decrement4BitReg
    JMP ENDEXECUTE
    
    ;DEC BL
    DECBL1:
    CMP firstOperandIndex,12
    JNE DECCH1
    MOV addedValueToSIDest,2
    CALL decrement4BitReg
    JMP ENDEXECUTE
    
    ;DEC CH
    DECCH1:
    CMP firstOperandIndex,13
    JNE DECCL1
    MOV addedValueToSIDest,5
    CALL decrement4BitReg
    JMP ENDEXECUTE
    
    ;DEC CL
    DECCL1:
    CMP firstOperandIndex,14
    JNE DECDH1
    MOV addedValueToSIDest,4
    CALL decrement4BitReg
    JMP ENDEXECUTE
    
    ;DEC DH
    DECDH1:
    CMP firstOperandIndex,15
    JNE DECDL1
    MOV addedValueToSIDest,7
    CALL decrement4BitReg
    JMP ENDEXECUTE
    
    ;DEC DL
    DECDL1:
    CMP firstOperandIndex,16
    JE DECDL2
    JMP NOTAVAILIDCOMMAND
    DECDL2:
    MOV addedValueToSIDest,6
    CALL decrement4BitReg
    JMP ENDEXECUTE    
    
    DECCommandForPointer:
    
    ;DEC [BX]
    DECBXPOINTER:
    CMP firstOperandIndex,2
    JNE DECSIPOINTER
    MOV addedValueToSIDest,1
    CALL decrementPointer
    JMP ENDEXECUTE
    
    ;DEC [SI]
    DECSIPOINTER:
    CMP firstOperandIndex,5
    JNE DECDIPOINTER
    MOV addedValueToSIDest,4
    CALL decrementPointer
    JMP ENDEXECUTE
    
    ;DEC [DI]
    DECDIPOINTER:
    CMP firstOperandIndex,6
    JE DECDIPOINTER1
    JMP NOTAVAILIDCOMMAND
    DECDIPOINTER1:
    MOV addedValueToSIDest,5
    CALL decrementPointer
    JMP ENDEXECUTE
;------------------------------------------------------------------------------------------------    
    ;this is signed MUL command
    IMULCOMMAND:
    CMP commandIndex,20
    JE IMULCOMMAND1
    JMP IDIVCOMMAND
    IMULCOMMAND1:
    
    ;if there is a bracket then either BX or SI or DI
    CMP isFirstOpBracket,1
    JNE ValidCommand7
    JMP IMULAddressStoredInPtr
    ValidCommand7:
    
    ;IMUL AX
    IMULAX1:
    CMP firstOperandIndex,1
    JNE IMULBX1
    MOV addedValueToSIDest,0
    CALL signedMultiplyByWord
    JMP ENDEXECUTE
    
    ;IMUL BX
    IMULBX1:
    CMP firstOperandIndex,2
    JNE IMULCX1
    MOV addedValueToSIDest,2
    CALL signedMultiplyByWord
    JMP ENDEXECUTE
    
    ;IMUL CX
    IMULCX1:
    CMP firstOperandIndex,3
    JNE IMULDX1
    MOV addedValueToSIDest,4
    CALL signedMultiplyByWord
    JMP ENDEXECUTE
    
    ;IMUL DX
    IMULDX1:
    CMP firstOperandIndex,4
    JNE IMULSI1
    MOV addedValueToSIDest,6
    CALL signedMultiplyByWord
    JMP ENDEXECUTE
    
    ;IMUL SI
    IMULSI1:
    CMP firstOperandIndex,5
    JNE IMULDI1
    MOV addedValueToSIDest,8
    CALL signedMultiplyByWord
    JMP ENDEXECUTE
    
    ;IMUL DI
    IMULDI1:
    CMP firstOperandIndex,6
    JNE IMULSP1
    MOV addedValueToSIDest,10
    CALL signedMultiplyByWord 
    JMP ENDEXECUTE
    
    ;IMUL SP
    IMULSP1:
    CMP firstOperandIndex,7
    JNE IMULBP1
    MOV addedValueToSIDest,12
    CALL signedMultiplyByWord
    JMP ENDEXECUTE
    
    ;IMUL BP
    IMULBP1:
    CMP firstOperandIndex,8
    JNE IMULAH1
    MOV addedValueToSIDest,14
    CALL signedMultiplyByWord
    JMP ENDEXECUTE
    
    ;IMUL AH
    IMULAH1:
    CMP firstOperandIndex,9
    JNE IMULAL1
    MOV addedValueToSIDest,1
    CALL signedMultiplyByByte
    JMP ENDEXECUTE

    ;IMUL AL
    IMULAL1:
    CMP firstOperandIndex,10
    JNE IMULBH1
    MOV addedValueToSIDest,0
    CALL signedMultiplyByByte
    JMP ENDEXECUTE
    
    ;IMUL BH
    IMULBH1:
    CMP firstOperandIndex,11
    JNE IMULBL1
    MOV addedValueToSIDest,3
    CALL signedMultiplyByByte
    JMP ENDEXECUTE
    
    ;IMUL BL
    IMULBL1:
    CMP firstOperandIndex,12
    JNE IMULCH1
    MOV addedValueToSIDest,2
    CALL signedMultiplyByByte
    JMP ENDEXECUTE
    
    ;IMUL CH
    IMULCH1:
    CMP firstOperandIndex,13
    JNE IMULCL1
    MOV addedValueToSIDest,5
    CALL signedMultiplyByByte
    JMP ENDEXECUTE
    
    ;IMUL CL
    IMULCL1:
    CMP firstOperandIndex,14
    JNE IMULDH1
    MOV addedValueToSIDest,4
    CALL signedMultiplyByByte
    JMP ENDEXECUTE
    
    ;IMUL DH
    IMULDH1:
    CMP firstOperandIndex,15
    JNE IMULDL1
    MOV addedValueToSIDest,7
    CALL signedMultiplyByByte
    JMP ENDEXECUTE
    
    ;IMUL DL
    IMULDL1:
    CMP firstOperandIndex,16
    JE IMULDL2
    JMP NOTAVAILIDCOMMAND
    IMULDL2:
    MOV addedValueToSIDest,6
    CALL signedMultiplyByByte
    JMP ENDEXECUTE
    
    
    IMULAddressStoredInPtr:
    
    ;IMUL [BX]
    IMULBXPOINTER:
    CMP firstOperandIndex,2
    JNE IMULSIPOINTER
    MOV addedValueToSIDest,1
    CALL signedMultiplyByValueInAddress
    JMP ENDEXECUTE

    ;IMUL [SI]
    IMULSIPOINTER:
    CMP firstOperandIndex,5
    JNE IMULDIPOINTER
    MOV addedValueToSIDest,4
    CALL signedMultiplyByValueInAddress
    JMP ENDEXECUTE
    
    ;IMUL [DI]
    IMULDIPOINTER:
    CMP firstOperandIndex,6
    JE IMULDIPOINTER1
    JMP NOTAVAILIDCOMMAND
    IMULDIPOINTER1:
    MOV addedValueToSIDest,5
    CALL signedMultiplyByValueInAddress
    JMP ENDEXECUTE
;------------------------------------------------------------------------------------------------
    ;this is signed DIV command
    IDIVCOMMAND:
    CMP commandIndex,21
    JE IDIVCOMMAND1
    JMP MULCOMMAND
    IDIVCOMMAND1:
    
    ;if there is a bracket then either BX or SI or DI
    CMP isFirstOpBracket,1
    JNE ValidCommand8
    JMP IDIVAddressStoredInPtr
    ValidCommand8:
    
    ;IDIV AX
    IDIVAX1:
    CMP firstOperandIndex,1
    JNE IDIVBX1
    MOV addedValueToSIDest,0
    CALL signedDivideByWord
    JMP ENDEXECUTE
    
    ;IDIV BX
    IDIVBX1:
    CMP firstOperandIndex,2
    JNE IDIVCX1
    MOV addedValueToSIDest,1
    CALL signedDivideByWord
    JMP ENDEXECUTE
    
    ;IDIV CX
    IDIVCX1:
    CMP firstOperandIndex,3
    JNE IDIVDX1
    MOV addedValueToSIDest,2
    CALL signedDivideByWord
    JMP ENDEXECUTE
    
    ;IDIV DX
    IDIVDX1:
    CMP firstOperandIndex,4
    JNE IDIVSI1
    MOV addedValueToSIDest,3
    CALL signedDivideByWord
    JMP ENDEXECUTE
    
    ;IDIV SI
    IDIVSI1:
    CMP firstOperandIndex,5
    JNE IDIVDI1
    MOV addedValueToSIDest,4
    CALL signedDivideByWord
    JMP ENDEXECUTE
    
    ;IDIV DI
    IDIVDI1:
    CMP firstOperandIndex,6
    JNE IDIVSP1
    MOV addedValueToSIDest,5
    CALL signedDivideByWord
    JMP ENDEXECUTE
    
    ;IDIV SP
    IDIVSP1:
    CMP firstOperandIndex,7
    JNE IDIVBP1
    MOV addedValueToSIDest,6
    CALL signedDivideByWord
    JMP ENDEXECUTE
    
    ;IDIV BP
    IDIVBP1:
    CMP firstOperandIndex,8
    JNE IDIVAH1
    MOV addedValueToSIDest,7
    CALL signedDivideByWord
    JMP ENDEXECUTE

    ;IDIV AH
    IDIVAH1:
    CMP firstOperandIndex,9
    JNE IDIVAL1
    MOV addedValueToSIDest,1
    CALL signedDivideByByte
    JMP ENDEXECUTE

    ;IDIV AL
    IDIVAL1:
    CMP firstOperandIndex,10
    JNE IDIVBH1
    MOV addedValueToSIDest,0
    CALL signedDivideByByte
    JMP ENDEXECUTE
    
    ;IDIV BH
    IDIVBH1:
    CMP firstOperandIndex,11
    JNE IDIVBL1
    MOV addedValueToSIDest,3
    CALL signedDivideByByte
    JMP ENDEXECUTE
    
    ;IDIV BL
    IDIVBL1:
    CMP firstOperandIndex,12
    JNE IDIVCH1
    MOV addedValueToSIDest,2
    CALL signedDivideByByte
    JMP ENDEXECUTE
    
    ;IDIV CH
    IDIVCH1:
    CMP firstOperandIndex,13
    JNE IDIVCL1
    MOV addedValueToSIDest,5
    CALL signedDivideByByte
    JMP ENDEXECUTE
    
    ;IDIV CL
    IDIVCL1:
    CMP firstOperandIndex,14
    JNE IDIVDH1
    MOV addedValueToSIDest,4
    CALL signedDivideByByte
    JMP ENDEXECUTE
    
    ;IDIV DH
    IDIVDH1:
    CMP firstOperandIndex,15
    JNE IDIVDL1
    MOV addedValueToSIDest,7
    CALL signedDivideByByte
    JMP ENDEXECUTE
    
    ;IDIV DL
    IDIVDL1:
    CMP firstOperandIndex,16
    JE IDIVDL2
    JMP NOTAVAILIDCOMMAND
    IDIVDL2:
    MOV addedValueToSIDest,6
    CALL signedDivideByByte
    JMP ENDEXECUTE 
    

    IDIVAddressStoredInPtr:
    
    ;IDIV [BX]
    IDIVBXPOINTER:
    CMP firstOperandIndex,2
    JNE IDIVSIPOINTER
    MOV addedValueToSIDest,1
    CALL signedDivideByValueInAddress
    JMP ENDEXECUTE

    ;IDIV [SI]
    IDIVSIPOINTER:
    CMP firstOperandIndex,5
    JNE IDIVDIPOINTER
    MOV addedValueToSIDest,4
    CALL signedDivideByValueInAddress
    JMP ENDEXECUTE
    
    ;IDIV [DI]
    IDIVDIPOINTER:
    CMP firstOperandIndex,6
    JE IDIVDIPOINTER1
    JMP NOTAVAILIDCOMMAND
    IDIVDIPOINTER1:
    MOV addedValueToSIDest,5
    CALL signedDivideByValueInAddress
    JMP ENDEXECUTE
;------------------------------------------------------------------------------------------------   
    ;this is unsigned MUL command
    MULCOMMAND:
    CMP commandIndex,22
    JE MULCOMMAND1
    JMP DIVCOMMAND
    MULCOMMAND1:
    
    ;if there is a bracket then either BX or SI or DI
    CMP isFirstOpBracket,1
    JNE ValidCommand5
    JMP MULAddressStoredInPtr
    ValidCommand5:
        
    
    ;MUL AX
    MULAX1:
    CMP firstOperandIndex,1
    JNE MULBX1
    MOV addedValueToSIDest,0
    CALL multiplyByWord
    JMP ENDEXECUTE
    
    ;MUL BX
    MULBX1:
    CMP firstOperandIndex,2
    JNE MULCX1
    MOV addedValueToSIDest,2
    CALL multiplyByWord
    JMP ENDEXECUTE
    
    ;MUL CX
    MULCX1:
    CMP firstOperandIndex,3
    JNE MULDX1
    MOV addedValueToSIDest,4
    CALL multiplyByWord
    JMP ENDEXECUTE
    
    ;MUL DX
    MULDX1:
    CMP firstOperandIndex,4
    JNE MULSI1
    MOV addedValueToSIDest,6
    CALL multiplyByWord
    JMP ENDEXECUTE
    
    ;MUL SI
    MULSI1:
    CMP firstOperandIndex,5
    JNE MULDI1
    MOV addedValueToSIDest,8
    CALL multiplyByWord
    JMP ENDEXECUTE
    
    ;MUL DI
    MULDI1:
    CMP firstOperandIndex,6
    JNE MULSP1
    MOV addedValueToSIDest,10
    CALL multiplyByWord
    JMP ENDEXECUTE
    
    ;MUL SP
    MULSP1:
    CMP firstOperandIndex,7
    JNE MULBP1
    MOV addedValueToSIDest,12
    CALL multiplyByWord 
    JMP ENDEXECUTE
    
    ;MUL BP
    MULBP1:
    CMP firstOperandIndex,8
    JNE MULAH1
    MOV addedValueToSIDest,14
    CALL multiplyByWord 
    JMP ENDEXECUTE
    
    ;MUL AH
    MULAH1:
    CMP firstOperandIndex,9
    JNE MULAL1
    MOV addedValueToSIDest,1
    CALL multiplyByByte
    JMP ENDEXECUTE

    ;MUL AL
    MULAL1:
    CMP firstOperandIndex,10
    JNE MULBH1
    MOV addedValueToSIDest,0
    CALL multiplyByByte
    JMP ENDEXECUTE
    
    ;MUL BH
    MULBH1:
    CMP firstOperandIndex,11
    JNE MULBL1
    MOV addedValueToSIDest,3
    CALL multiplyByByte
    JMP ENDEXECUTE
    
    ;MUL BL
    MULBL1:
    CMP firstOperandIndex,12
    JNE MULCH1
    MOV addedValueToSIDest,2
    CALL multiplyByByte
    JMP ENDEXECUTE
    
    ;MUL CH
    MULCH1:
    CMP firstOperandIndex,13
    JNE MULCL1
    MOV addedValueToSIDest,5
    CALL multiplyByByte
    JMP ENDEXECUTE
    
    ;MUL CL
    MULCL1:
    CMP firstOperandIndex,14
    JNE MULDH1
    MOV addedValueToSIDest,4
    CALL multiplyByByte
    JMP ENDEXECUTE
    
    ;MUL DH
    MULDH1:
    CMP firstOperandIndex,15
    JNE MULDL1
    MOV addedValueToSIDest,7
    CALL multiplyByByte
    JMP ENDEXECUTE
    
    ;MUL DL
    MULDL1:
    CMP firstOperandIndex,16
    JE MULDL2
    JMP NOTAVAILIDCOMMAND
    MULDL2:
    MOV addedValueToSIDest,6
    CALL multiplyByByte
    JMP ENDEXECUTE    
    
    MULAddressStoredInPtr:
    
    ;MUL [BX]
    MULBXPOINTER:
    CMP firstOperandIndex,2
    JNE MULSIPOINTER
    MOV addedValueToSIDest,1
    CALL multiplyByValueInAddress
    JMP ENDEXECUTE

    ;MUL [SI]
    MULSIPOINTER:
    CMP firstOperandIndex,5
    JNE MULDIPOINTER
    MOV addedValueToSIDest,4
    CALL multiplyByValueInAddress
    JMP ENDEXECUTE
    
    ;MUL [DI]
    MULDIPOINTER:
    CMP firstOperandIndex,6
    JE MULDIPOINTER1
    JMP NOTAVAILIDCOMMAND
    MULDIPOINTER1:
    MOV addedValueToSIDest,5
    CALL multiplyByValueInAddress
    JMP ENDEXECUTE
;------------------------------------------------------------------------------------------------   
    ;this is unsigned DIV command
    DIVCOMMAND:
    CMP commandIndex,23
    JE DIVCOMMAND1
    JMP NOPCOMMAND
    DIVCOMMAND1:
    
    ;if there is a bracket then either BX or SI or DI
    CMP isFirstOpBracket,1
    JNE ValidCommand6
    JMP DIVAddressStoredInPtr
    ValidCommand6:
    
    ;DIV AX
    DIVAX1:
    CMP firstOperandIndex,1
    JNE DIVBX1
    MOV addedValueToSIDest,0
    CALL divideByWord
    JMP ENDEXECUTE
    
    ;DIV BX
    DIVBX1:
    CMP firstOperandIndex,2
    JNE DIVCX1
    MOV addedValueToSIDest,1
    CALL divideByWord
    JMP ENDEXECUTE
    
    ;DIV CX
    DIVCX1:
    CMP firstOperandIndex,3
    JNE DIVDX1
    MOV addedValueToSIDest,2
    CALL divideByWord
    JMP ENDEXECUTE
    
    ;DIV DX
    DIVDX1:
    CMP firstOperandIndex,4
    JNE DIVSI1
    MOV addedValueToSIDest,3
    CALL divideByWord
    JMP ENDEXECUTE
    
    ;DIV SI
    DIVSI1:
    CMP firstOperandIndex,5
    JNE DIVDI1
    MOV addedValueToSIDest,4
    CALL divideByWord
    JMP ENDEXECUTE
    
    ;DIV DI
    DIVDI1:
    CMP firstOperandIndex,6
    JNE DIVSP1
    MOV addedValueToSIDest,5
    CALL divideByWord
    JMP ENDEXECUTE
    
    ;DIV SP
    DIVSP1:
    CMP firstOperandIndex,7
    JNE DIVBP1
    MOV addedValueToSIDest,6
    CALL divideByWord
    JMP ENDEXECUTE
    
    ;DIV BP
    DIVBP1:
    CMP firstOperandIndex,8
    JNE DIVAH1
    MOV addedValueToSIDest,7
    CALL divideByWord
    JMP ENDEXECUTE

    ;DIV AH
    DIVAH1:
    CMP firstOperandIndex,9
    JNE DIVAL1
    MOV addedValueToSIDest,1
    CALL divideByByte
    JMP ENDEXECUTE

    ;DIV AL
    DIVAL1:
    CMP firstOperandIndex,10
    JNE DIVBH1
    MOV addedValueToSIDest,0
    CALL divideByByte
    JMP ENDEXECUTE
    
    ;DIV BH
    DIVBH1:
    CMP firstOperandIndex,11
    JNE DIVBL1
    MOV addedValueToSIDest,3
    CALL divideByByte
    JMP ENDEXECUTE
    
    ;DIV BL
    DIVBL1:
    CMP firstOperandIndex,12
    JNE DIVCH1
    MOV addedValueToSIDest,2
    CALL divideByByte
    JMP ENDEXECUTE
    
    ;DIV CH
    DIVCH1:
    CMP firstOperandIndex,13
    JNE DIVCL1
    MOV addedValueToSIDest,5
    CALL divideByByte
    JMP ENDEXECUTE
    
    ;DIV CL
    DIVCL1:
    CMP firstOperandIndex,14
    JNE DIVDH1
    MOV addedValueToSIDest,4
    CALL divideByByte
    JMP ENDEXECUTE
    
    ;DIV DH
    DIVDH1:
    CMP firstOperandIndex,15
    JNE DIVDL1
    MOV addedValueToSIDest,7
    CALL divideByByte
    JMP ENDEXECUTE
    
    ;DIV DL
    DIVDL1:
    CMP firstOperandIndex,16
    JE DIVDL2
    JMP NOTAVAILIDCOMMAND
    DIVDL2:
    MOV addedValueToSIDest,6
    CALL divideByByte
    JMP ENDEXECUTE 
    
    
  
    DIVAddressStoredInPtr:
    
    ;DIV [BX]
    DIVBXPOINTER:
    CMP firstOperandIndex,2
    JNE DIVSIPOINTER
    MOV addedValueToSIDest,1
    CALL divideByValueInAddress
    JMP ENDEXECUTE

    ;DIV [SI]
    DIVSIPOINTER:
    CMP firstOperandIndex,5
    JNE DIVDIPOINTER
    MOV addedValueToSIDest,4
    CALL divideByValueInAddress
    JMP ENDEXECUTE
    
    ;DIV [DI]
    DIVDIPOINTER:
    CMP firstOperandIndex,6
    JE DIVDIPOINTER1
    JMP NOTAVAILIDCOMMAND
    DIVDIPOINTER1:
    MOV addedValueToSIDest,5
    CALL divideByValueInAddress
    JMP ENDEXECUTE
;------------------------------------------------------------------------------------------------   
    ;NOP (do nothing)
    NOPCOMMAND:
    CMP commandIndex,24
    JE NOPCOMMAND1
    JMP CLCCOMMAND
    NOPCOMMAND1:
    NOP
    JMP ENDEXECUTE
;------------------------------------------------------------------------------------------------  
    ;CLC (clear carry)
    CLCCOMMAND:
    CMP commandIndex,25
    JE CLCCOMMAND1
    JMP NOTAVAILIDCOMMAND
    CLCCOMMAND1:
    MOV DI,flagAddress
    PUSH [DI]
    POPF
    CLC
    PUSHF
    POP [DI]
    JMP ENDEXECUTE 
;------------------------------------------------------------------------------------------------
    NOTAVAILIDCOMMAND:
    ;if there is anything wrong then ducdate 1 points
    MOV DI,pointsAddress
    MOV DL,1
    SUB [DI],DL
    
    ENDEXECUTE:
    
    RET
executeCommand ENDP
;================================================================================

;================================== PROCEDURE ===================================
;these are procedures for sending and recieving register values and any other values after execution
initializePort  PROC

    ;Set Divisor Latch Access Bit
    mov dx,3fbh             ; Line Control Register
    mov al,10000000b        ;Set Divisor Latch Access Bit
    out dx,al
    
    ;Set LSB byte of the Baud Rate Divisor Latch register.
    mov dx,3f8h         
    mov al,0ch          
    out dx,al

    ;Set MSB byte of the Baud Rate Divisor Latch register.
    mov dx,3f9h
    mov al,00h
    out dx,al

    ;Set port configuration
    mov dx,3fbh
    mov al,00011011b
    out dx,al

    RET
initializePort  ENDP

sendData    PROC
    ;set SI to have addresss of data to be sent
    MOV SI,OFFSET commandIndex
    MOV CX,163
    sendDLoop:
    ;Check that Transmitter Holding Register is Empty
    mov DX , 3FDH       ; Line Status Register
    WaitToSend:  
    IN AL , DX 
    AND AL , 00100000b
    JZ WaitToSend
    ;If empty put the VALUE in Transmit data register
    MOV DX , 3F8H       ;Transmit data register
    MOV AL,[SI]
    out dX , AL 
    
    INC SI
    DEC CX
    JNZ sendDLoop

    RET
sendData    ENDP

recieveData PROC
	
	RecieveDataAgain:
    ;set SI to have addresss of data to be recieved
    MOV SI,OFFSET commandIndex
	
	;check that the data is ready               
    MOV DX,3FDH    
	CHK7:
    IN AL,DX
    AND AL,1
    JZ CHK7
    ;determine whether the first recieved byte was normal byte or chatting request
    MOV DX,03F8H
    IN AL,DX
	;inGameChattingRequest
	CMP AL,200
	JNE CheckIfOutGameRequest
    MOV chatType,0
	;set the cursor
	MOV BH,0
	MOV DL,0
	MOV DH,21
	MOV AH,2
	INT 10H
	;ask him to press 1 to accept invitation
	MOV DX,OFFSET inGameChatReqMsg
	MOV AH,9
	INT 21H
	;Read num from the user 
	MOV AH,7
	INT 21H
	CMP AL,'1'
	JNE DenyInGameChatting
	MOV isThereAChatting,1
	
	MOV DX,3F8H       ;Transmit data register
    MOV AL,1
    OUT dX,AL 
	
	;recieve from him the navigateIndex to navigate to
	;check that the data is ready               
    MOV DX,3FDH    
	CHK8:
    IN AL,DX
    AND AL,1
    JZ CHK8
    ;store the navigate index
    MOV DX,03F8H
    IN AL,DX
	MOV navigationIndex ,AL
	JMP EndRecievingData
	
	DenyInGameChatting:
	
	MOV DX,3F8H       ;Transmit data register
    MOV AL,0
    OUT dX,AL 
	
	;clear the message
	;set the cursor
	MOV BH,0
	MOV DL,0
	MOV DH,21
	MOV AH,2
	INT 10H
	;clear msg
	MOV AL,' '
	MOV BH,0
	MOV CX,79
	MOV AH,0AH
	INT 10H
	JMP RecieveDataAgain
	
	CheckIfOutGameRequest:
	CMP AL,201
	JNE NormalData
	MOV chatType,1
	;set the cursor
	MOV BH,0
	MOV DL,0
	MOV DH,21
	MOV AH,2
	INT 10H
	;ask him to press 1 to accept invitation
	MOV DX,OFFSET outGameChatReqMsg
	MOV AH,9
	INT 21H
	;Read num from the user 
	MOV AH,7
	INT 21H
	CMP AL,'1'
	JNE DenyOutGameChatting
	
	MOV isThereAChatting,1
	
	MOV DX , 3F8H       ;Transmit data register
    MOV AL,1
    out dX , AL 
	
	JMP EndRecievingData
	
	DenyOutGameChatting:
	MOV DX , 3F8H       ;Transmit data register
    MOV AL,0
    out dX , AL 
	
	;clear the message
	;set the cursor
	MOV BH,0
	MOV DL,0
	MOV DH,21
	MOV AH,2
	INT 10H
	;clear msg
	MOV AL,' '
	MOV BH,0
	MOV CX,79
	MOV AH,0AH
	INT 10H
	JMP RecieveDataAgain
	
	NormalData:
	MOV [SI],AL
    INC SI
	;CX = actual data - 1 byte for the first read
    MOV CX,162
    recieveLoop:   
    ;check that the data is ready               
    MOV DX,3FDH
    waitToRecieve:                                                                     
    IN AL,DX
    AND AL,1
    JZ waitToRecieve
    ;if ready read the value in recieve data register
    MOV DX,03F8H
    IN AL,DX
    MOV [SI],AL
    INC SI
    DEC CX
    JNZ recieveLoop
	
	EndRecievingData:
    RET
recieveData ENDP    

sendInitData1	PROC

	;before everything send game level
	SendGameLavel:
	MOV DX,3FDH
	AGAIN3:
	IN AL,DX
	AND AL,00100000B
	JZ AGAIN3
	MOV DX,3F8H
	MOV AL,gameLevel
	OUT DX,AL
	
	;send  points -> name -> forbidden char
	MOV CL,12
	MOV SI,OFFSET opponentPoints
	SendMyInitNecessaryData:
	MOV DX,3FDH
	AGAIN1:
	IN AL,DX
	AND AL,00100000B
	JZ AGAIN1
	MOV DX,3F8H
	MOV AL,[SI]
	OUT DX,AL
	INC SI
	DEC CL
	JNZ SendMyInitNecessaryData
	
	RET
sendInitData1	ENDP

sendInitData2	PROC

	;send  registersValues if level 2
	MOV CL,16
	MOV SI,OFFSET  opponentRegistersValues
	SendMyInitNecessaryData1:
	MOV DX,3FDH
	AGAIN4:
	IN AL,DX
	AND AL,00100000B
	JZ AGAIN4
	MOV DX,3F8H
	MOV AL,[SI]
	OUT DX,AL
	INC SI
	DEC CL
	JNZ SendMyInitNecessaryData1
	
	RET
sendInitData2	ENDP


recieveInitData1	PROC
	;before everything recieve game level
	MOV DX,3FDH
	CHK2:
	IN AL,DX
	AND AL,1
	JZ CHK2
	MOV DX,03F8H
	IN AL,DX
	;see if game level is Lower then store it
	CMP AL,gameLevel
	JG DonotStoreHighLevel
	MOV gameLevel,AL
	DonotStoreHighLevel:
	
	;recieve  points -> name -> forbidden char
	MOV CL,12
	MOV SI,OFFSET yourPoints 
	RecieveMyInitNecessaryData:
	MOV DX,3FDH
	CHK1:
	IN AL,DX
	AND AL,1
	JZ CHK1
	MOV DX,03F8H
	IN AL,DX
	MOV [SI],AL
	INC SI
	DEC CL
	JNZ RecieveMyInitNecessaryData
	RET
recieveInitData1	ENDP

recieveInitData2	PROC

	;recieve  registersValues
	MOV CL,16
	MOV SI,OFFSET yourRegistersValues
	RecieveMyInitNecessaryData1:
	MOV DX,3FDH
	CHK3:
	IN AL,DX
	AND AL,1
	JZ CHK3
	MOV DX,03F8H
	IN AL,DX
	MOV [SI],AL
	INC SI
	DEC CL
	JNZ RecieveMyInitNecessaryData1
	RET
recieveInitData2	ENDP
;================================================================================

;================================== PROCEDURE ===================================
checkForWinnerOrLoser   PROC
    ;two conditions to end game : 
    ;points now is greater than initial points
    ;one of the registers has 105e in it
    
    
    ;check if anyone points become 0
    MOV AH,yourPoints
    CMP AH,0
    JE OpponentIsTheWinner
    MOV AH,opponentPoints
    CMP AH,0
    JE YouAreTheWinner
    
    ;check if anyone points become greater than initial points (overflow)
    MOV AH,InitialPoints
    CMP AH,yourPoints
    JB OpponentIsTheWinner
    CMP AH,opponentPoints
    JB YouAreTheWinner
    
    ;check if one of your registers has 105e in it
    MOV SI,OFFSET yourRegistersValues 
    MOV CL,8
    LoopFor105eInYourRegisters:
    MOV AX,[SI]
    CMP AX,targetValue
    JE OpponentIsTheWinner
    ADD SI,2
    DEC CL
    JNZ LoopFor105eInYourRegisters
    
    ;check if one of opponent registers has 105e in it
    MOV SI,OFFSET opponentRegistersValues 
    MOV CL,8
    LoopFor105eInOpponentRegisters:
    MOV AX,[SI]
    CMP AX,targetValue
    JE YouAreTheWinner
    ADD SI,2
    DEC CL
    JNZ LoopFor105eInOpponentRegisters
    
    JMP NotheGameDidnotEnd
    
    YouAreTheWinner:
    MOV SI,OFFSET yourName
    MOV winnerNameAddress,SI
    MOV SI,OFFSET opponentName
    MOV loserNameAddress,SI
    JMP YesTheGameEnded
    
    OpponentIsTheWinner:
    MOV SI,OFFSET opponentName
    MOV winnerNameAddress,SI
    MOV SI,OFFSET yourName
    MOV loserNameAddress,SI
    JMP YesTheGameEnded
    
    
    YesTheGameEnded:
    MOV isGameEnded,1
    
    NotheGameDidnotEnd:
    
    RET
checkForWinnerOrLoser   ENDP
;================================================================================

;================================== PROCEDURE ===================================
executeAPowerUp     PROC
           
    Option1Selected:
    ;execute command on your processor
    CMP powerUpIndex,1
    JNE Option2Selected
    
    ;is it your turn
    CMP personTurn,0
    JNE ItsOpponentTurnInPowerUp1
    
    ;storing the address of varaiables to operate on
    MOV SI,OFFSET yourPoints           
    MOV pointsAddress,SI
    
    MOV SI,OFFSET yourAddressesList
    MOV addressesAddress,SI
    
    MOV SI,OFFSET yourRegistersValues
    MOV registersAddress,SI
    
    MOV SI,OFFSET opponentForbiddenChar
    MOV forbiddentCharAdd,SI
    
    MOV SI,OFFSET yourFlags
    MOV flagAddress,SI
    
    SUB yourPoints,5
    ;execute command
    CALL executeCommand   
    INC personTurn    
    JMP EndExecutePowerUps   
    
    ItsOpponentTurnInPowerUp1:
    
    ;storing the address of varaiables to operate on
    MOV SI,OFFSET opponentPoints
    MOV pointsAddress,SI
    
    MOV SI,OFFSET opponentAddressesList
    MOV addressesAddress,SI
    
    MOV SI,OFFSET opponentRegistersValues
    MOV registersAddress,SI
    
    MOV SI,OFFSET yourForbiddenChar
    MOV forbiddentCharAdd,SI
    
    MOV SI,OFFSET opponentFlags
    MOV flagAddress,SI
    
    SUB opponentPoints,5
    ;execute command
    CALL executeCommand   
    DEC personTurn  
    JMP EndExecutePowerUps
;---------------------------------------------------         
    Option2Selected:
    ;Executing a command on your processor and your opponent processor
    CMP powerUpIndex,2
    JE Option2Selected1   
    JMP Option3Selected
    Option2Selected1:
    
    ;is it your turn
    CMP personTurn,0
    JNE ItsOpponentTurnInPowerUp2
    
    ;storing the address of varaiables to operate on
    MOV SI,OFFSET yourPoints
    MOV pointsAddress,SI
    
    MOV SI,OFFSET opponentAddressesList
    MOV addressesAddress,SI
    
    MOV SI,OFFSET opponentRegistersValues
    MOV registersAddress,SI
    
    MOV SI,OFFSET opponentForbiddenChar
    MOV forbiddentCharAdd,SI
    
    MOV SI,OFFSET opponentFlags
    MOV flagAddress,SI
    
    ;execute command
    CALL executeCommand
    
    ;storing the address of varaiables to operate on
    MOV SI,OFFSET yourPoints
    MOV pointsAddress,SI
    
    MOV SI,OFFSET yourAddressesList
    MOV addressesAddress,SI
    
    MOV SI,OFFSET yourRegistersValues
    MOV registersAddress,SI
    
    MOV SI,OFFSET opponentForbiddenChar
    MOV forbiddentCharAdd,SI
    
    MOV SI,OFFSET yourFlags
    MOV flagAddress,SI
    
    ;execute command
    CALL executeCommand
    
    SUB yourPoints,3
    INC personTurn  
    JMP EndExecutePowerUps
    
    ItsOpponentTurnInPowerUp2:
    ;storing the address of varaiables to operate on
    MOV SI,OFFSET opponentPoints          
    MOV pointsAddress,SI
    
    MOV SI,OFFSET yourAddressesList
    MOV addressesAddress,SI
    
    MOV SI,OFFSET yourRegistersValues
    MOV registersAddress,SI
    
    MOV SI,OFFSET yourForbiddenChar
    MOV forbiddentCharAdd,SI
    
    MOV SI,OFFSET yourFlags
    MOV flagAddress,SI
    
    ;execute command
    CALL executeCommand
    
    ;storing the address of varaiables to operate on
    MOV SI,OFFSET opponentPoints          
    MOV pointsAddress,SI
    
    MOV SI,OFFSET opponentAddressesList
    MOV addressesAddress,SI
    
    MOV SI,OFFSET opponentRegistersValues
    MOV registersAddress,SI
    
    MOV SI,OFFSET yourForbiddenChar
    MOV forbiddentCharAdd,SI
    
    MOV SI,OFFSET opponentFlags
    MOV flagAddress,SI
    
    ;execute command
    CALL executeCommand  
    
    SUB opponentPoints,3
    DEC personTurn
    JMP EndExecutePowerUps
;---------------------------------------------------      
    Option3Selected:
    ;Changing the forbidden character only once                                                                                                                                                                                                                                    
    CMP powerUpIndex,3
    JNE Option4Selected  
    
    ;is it your turn
    CMP personTurn,0
    JNE ItsOpponentTurnInPowerUp4
    
    ;check to make it only once
    CMP youchangedForbiddenKey,0
    JE ForbiddenKeyChangedByYou
    JMP EndExecutePowerUps
    
    ForbiddenKeyChangedByYou:
    MOV AL,tempForbChar
    MOV opponentForbiddenChar,AL
    
    SUB yourPoints,8
    INC personTurn  
    MOV youchangedForbiddenKey,1
    JMP EndExecutePowerUps
    
    ItsOpponentTurnInPowerUp4:
    
    ;check to make it only once
    CMP opponentchangedForbiddenKey,0
    JE ForbiddenKeyChangedByopponent
    JMP EndExecutePowerUps
    
    ForbiddenKeyChangedByopponent:
    MOV AL,tempForbChar
    MOV yourForbiddenChar,AL
    
    SUB opponentPoints,8
    DEC personTurn  
    MOV opponentchangedForbiddenKey,1
    JMP EndExecutePowerUps
    
    
    JMP EndExecutePowerUps
;---------------------------------------------------      
    ;(TO BE REMOVED)
    Option4Selected:
    ;Making one of the data lines stuck at zero or at one
    CMP powerUpIndex,4
    JNE Option5Selected
    JMP EndExecutePowerUps
;---------------------------------------------------      
    Option5Selected:
    ;Clearing all registers at once
    CMP powerUpIndex,5
    JE Option5Selected1
    CMP gameLevel,2
    JNE ThereIsNoLevel2
    JMP Option6Selected
    ThereIsNoLevel2:
    JMP EndExecutePowerUps
    
    Option5Selected1:
    ;is it your turn
    CMP personTurn,0
    JNE ItsOpponentTurnInPowerUp3
    ;check to make it only once
    CMP youMadeRegWithZero,0
    JE AllRegistersAreZeroByYou
    JMP EndExecutePowerUps
    
    AllRegistersAreZeroByYou:
    ;loop for all registers and make it zero but only once
    MOV SI,OFFSET opponentRegistersValues
    MOV CX,8
    MOV AX,0
    ZeroForOpponentReg:
    MOV [SI],AX
    ADD SI,2
    LOOP ZeroForOpponentReg
    
    MOV SI,OFFSET yourRegistersValues
    MOV CX,8
    MOV AX,0
    ZeroForyourReg:
    MOV [SI],AX
    ADD SI,2
    LOOP ZeroForyourReg
    
    SUB yourPoints,30
    INC personTurn  
    MOV youMadeRegWithZero,1
    JMP EndExecutePowerUps
    
    
    ItsOpponentTurnInPowerUp3:
    ;check to make it only once
    CMP opponentMadeRegWithZero,0
    JE AllRegistersAreZeroByopponent
    JMP EndExecutePowerUps
    
    AllRegistersAreZeroByopponent:
    ;loop for all registers and make it zero but only once
    MOV SI,OFFSET opponentRegistersValues
    MOV CX,8
    MOV AX,0
    ZeroForOpponentReg1:
    MOV [SI],AX
    ADD SI,2
    LOOP ZeroForOpponentReg1
    
    MOV SI,OFFSET yourRegistersValues
    MOV CX,8
    MOV AX,0
    ZeroForyourReg1:
    MOV [SI],AX
    ADD SI,2
    LOOP ZeroForyourReg1
    
    SUB opponentPoints,30
    DEC personTurn
    MOV opponentMadeRegWithZero,1
    JMP EndExecutePowerUps
;---------------------------------------------------              
    Option6Selected:
    ;changing the target value
    CMP powerUpIndex,6
    JNE EndExecutePowerUps
    
    ;Check first if this number isn't already in any register
    MOV SI,OFFSET yourRegistersValues
    MOV CL,8
    LoopForNewTargetSet1:
    MOV AX,[SI]
    CMP AX,tempNewTarget
    JE EndExecutePowerUps
    ADD SI,2
    DEC CL
    JNZ LoopForNewTargetSet1
    
    MOV SI,OFFSET opponentRegistersValues 
    MOV CL,8
    LoopForNewTargetSet2:
    MOV AX,[SI]
    CMP AX,tempNewTarget
    JE EndExecutePowerUps
    ADD SI,2
    DEC CL
    JNZ LoopForNewTargetSet2
    
    ;is it your turn
    CMP personTurn,0
    JNE ItsOpponentTurnInPowerUp5
    
    ;check to make it only once
    CMP youchangedTargetValue,0
    JE TargetValueChangedByYou
    JMP EndExecutePowerUps
    
    TargetValueChangedByYou:
    MOV AX,tempNewTarget
    MOV targetValue,AX
    
    INC personTurn  
    MOV youchangedTargetValue,1
    JMP EndExecutePowerUps
    
    ItsOpponentTurnInPowerUp5:
    
    ;check to make it only once
    CMP opponentchangedTargetValue,0
    JE TargetValueChangedByopponent
    JMP EndExecutePowerUps
    
    TargetValueChangedByopponent:
    MOV AX,tempNewTarget
    MOV targetValue,AX
    
    DEC personTurn  
    MOV opponentchangedForbiddenKey,1
    JMP EndExecutePowerUps
;---------------------------------------------------    

    EndExecutePowerUps:
    MOV powerUpIndex,0
    RET
executeAPowerUp     ENDP
;================================================================================

;================================== PROCEDURE ===================================
enterInitialValuesLv2   PROC

    ; set the cursor
    MOV BH,0
    MOV DL,30
    MOV DH,5
    MOV AH,2
    INT 10H
    
    PUSH SI
    PUSH DI
    ;regisetAdd will hold the address of registers array to operate on
    changeForBackColor 0FH,0H
    MOV DI,regisetAdd
    
    ;use DH as temp register to store the character to display in it
    MOV SI,OFFSET enterRegisterVal   
    MOV BL,30 ;temp register for column place
    
    DISPLAYRegistersForLv2: 
    ;check for a new line
    CMP DH,','     
    JE NEWLINELv2
    JNE DISPLv2 
    
    NEWLINELv2:
    PUSH BX
    L1_Lv2:
    ;reading number enter from the user and display it 
    MOV AH,0H   ;get key pressed : AH : scancode , AL : Ascii code
    INT 16H     
    
    ;display the entered character
    ;see if the enetered key is ENTER
    CMP AL,13
    JE NewL
   
    MOV AH,0EH
    INT 10H  
    
    ;store the entered value
    MOV CH,AL
    SUB CH,48 
    MOV BX,[DI] 
    
    ;shifting by multiplication
    MOV AX,10
    MUL BX      ;DX AX = AX * BX
    ADD AL,CH
    MOV [DI],AX
    
    JMP L1_Lv2
    
    NewL:
    INC SI
    POP BX
    ADD DI,2
    
    ;get cursor position (saved in DL(X),DH(Y))
    MOV AH,3H
    MOV BH,0H   ;BH represent page number
    INT 10H      

    ;set cursor to a new line
    MOV DL,BL
    INC DH
    MOV AH,02  
    INT 10H    
      
    DISPLv2:
    MOV AH,0EH
    MOV AL,[SI]
    INT 10H 
    
    NEXTReg:
    INC SI
    MOV DH,[SI]
    CMP DH,'$'
    JNE DISPLAYRegistersForLv2

    POP DI
    POP SI
    RET
enterInitialValuesLv2   ENDP
;================================================================================
 
;================================== PROCEDURE ===================================
pageZero PROC 

    ;page zero will recieve the name and points as follows 
    ;POP SI 1st Time => gets name address
    ;POP SI 2nd Time => gets points address
    ;POP SI 3rd Time => gets forbidden character address
    
    POP DI
    POP SI
    ;SETTING CURSOR
    MOV AH,2
    MOV DL,22
    MOV DH,7
    MOV BH,0
    INT 10H    

    ;DISPLAY FIRST MESSAGE
    LEA DX,enterNameMessage 
    MOV AH,09H
    INT 21H   
    
    ;reading name     
    READINGNUMFROMUSER: 
    ;wait until user enters key    
    MOV AH,0    ;AL : ascii character , AH : scan code
    INT 16H     
    
    ;print the entered charater 
    MOV AH,0EH
    INT 10H 
    
    CMP AL,13
    JE READNEXTINPUTFROMUSER
    ;store the variable     
    MOV [SI],AL
    INC SI
    JMP  READINGNUMFROMUSER  

    
    READNEXTINPUTFROMUSER:
    POP SI
    ;SETTING CURSOR AGAIN
    MOV AH,2
    MOV BH,0
    MOV DL,22
    MOV DH,10
    INT 10H 
    ;DISPLAY SECOND MESSAGE
    LEA DX,enterPointsMessage 
    MOV AH,09H
    INT 21H
    
    ;reading points
    PUSH AX
    MOV AL,0
    MOV [SI],AL
    POP AX  
    READINGPOINTSFROMUSER:
    MOV AH,0    ;AL : ascii character , AH : scan code
    INT 16H 
    ;check if enter key is entered
    CMP AL,13
    JE READFORBIDDENCHARFROMUSER
    ;write the entered number
    MOV DL,AL 
    MOV AH,2
    INT 21H  
    ;store the variable
    MOV BL,AL
    SUB BL,48 
    MOV AL,[SI] 
    MOV CL,10
    MUL CL
    ADD AL,BL    
    MOV [SI] ,AL
    JMP READINGPOINTSFROMUSER 
    
    READFORBIDDENCHARFROMUSER:
    POP SI
    ;SETTING CURSOR AGAIN
    MOV AH,2
    MOV BH,0
    MOV DL,22
    MOV DH,13
    INT 10H 
    ;dispalying entering forbidden char  
    MOV DX,OFFSET enterForbiddenMsg 
    MOV AH,09H
    INT 21H   
    ;read from the char from the user    
    MOV AH,07
    INT 21h 
    ;check if char was in lower case to convert it to upper one
    CMP AL,97
    JL DonotConvertForbiddenToLower
    CMP AL,122
    JG DonotConvertForbiddenToLower
    SUB AL,32
    DonotConvertForbiddenToLower:
        
    MOV [SI],AL
    ;print the entered char
    MOV AH,2
    MOV DL,AL
    INT 21h 
        
    ;setting cursor      
    MOV AH,2
    MOV BH,0
    MOV DL,22
    MOV DH,16
    INT 10H   
    
    ;DISPLAY SELCT Level MESSAGE
    LEA DX,enterGameLevelMsg 
    MOV AH,09H
    INT 21H
     
    ;read from the char from the user    
    MOV AH,07
    INT 21h
    ;print the entered char
    MOV AH,2
    MOV DL,AL
    INT 21h  
    
    ;store the least entered game level
    SUB AL,'0'
    CMP AL,gameLevel
    JG DonotStoreLevel
    MOV gameLevel,AL
    DonotStoreLevel:
    
    ;setting cursor      
    MOV AH,2
    MOV BH,0
    MOV DL,22
    MOV DH,19
    INT 10H   
    ;displaying 3rd mesasge
    MOV DX,OFFSET pressEnterMessage 
    MOV AH,09H
    INT 21H  
    
    ;wait until user enters key    
    MOV AH,0    ;AL : ascii character , AH : scan code
    INT 16H 
    
    PUSH DI
    RET
pageZero ENDP    
;================================================================================


;================================== PROCEDURE ===================================
pageOne PROC

    ;here is the code of the main game
    changeForBackColor 0FH,2
    ;first center the cursor in the middle of the first row of the screen
    MOV BH,0
    MOV DH,0    ;row
    MOV DL,30   ;column
    MOV AH,2    
    INT 10h   
    displayUserNameWithHisPoints opponentName,opponentPoints
    
    
    ;first center the cursor in the middle of the screen
    MOV BH,0
    MOV DH,9    ;row
    MOV DL,30   ;column
    MOV AH,2    
    INT 10h 
    displayUserNameWithHisPoints yourName,yourPoints
    
    ;display the lines
    displayHorizontalLine 8,0,79,0,06H,2
    displayHorizontalLine 17,0,79,0,06H,2
    
    ;adjust cursor to print the addresses of your list
    MOV BH,0    ;page number   
    MOV DH,15   ;row
    MOV DL,7    ;column
    MOV AH,2    
    INT 10h     
    displayAddressesListinHorozontal    yourAddressesList    
    
    ;adjust cursor to print the addresses of oppoenent list
    MOV BH,0    ;page number   
    MOV DH,6    ;row
    MOV DL,7    ;column
    MOV AH,2    
    INT 10h
    displayAddressesListinHorozontal    opponentAddressesList 
    
    ;display the title of the notification
    ;set the cursor position
    MOV BH,0    ;page number   
    MOV DH,18   ;row
    MOV DL,30   ;column
    MOV AH,2    
    INT 10h 
    
    ;display the word nofications
    MOV DX,OFFSET noticationsTitle
    MOV AH,09H
    INT 21H
    
	CMP powerUpIndex,0
    JNE DisplayPowerUp
    JMP NoPowerUpToDisplay
    DisplayPowerUp:
    ;display the power up if there is any
    ;set the cursor position
    MOV BH,0    ;page number   
    MOV DH,18   ;row
    MOV DL,54   ;column
    MOV AH,2    
    INT 10h 
    
    ;display the word power up
    MOV DX,OFFSET powerUpsInfo
    MOV AH,09H
    INT 21H
    
    ;display the index of the power up
    MOV AL,powerUpIndex
    ADD AL,'0'
    MOV AH,0EH
    INT 10H
    
    ;if the power index is 3 -> display forbidden key to be changed
    CMP powerUpIndex,3
    JNE CheckIfPowerUpIs6
    
    MOV AL,','
    MOV AH,0EH
    INT 10H
    
    MOV AL,tempForbChar
    MOV AH,0EH
    INT 10H
    
    JMP NoPowerUpToDisplay
    CheckIfPowerUpIs6:
    ;if the power index is 6 -> display the target value to be changed
    CMP powerUpIndex,6
    JNE NoPowerUpToDisplay
    
    MOV AL,','
    MOV AH,0EH
    INT 10H
    
    displaySourceNumberByConvertingItToAscii tempNewTarget,0FH,3
    
    NoPowerUpToDisplay:
	
   ;adjust cursor to print the registers of opponent list
    MOV BH,0    ;page number   
    MOV DH,4    ;row
    MOV DL,10H  ;column
    MOV AH,2    
    INT 10h
    
    PUSH SI
    MOV SI,OFFSET opponentRegistersValues
    CALL displayRegistersListInHorizontal    
    POP SI
    
    ;adjust cursor to print the registers of your list
    MOV BH,0    ;page number   
    MOV DH,13   ;row
    MOV DL,10H  ;column
    MOV AH,2    
    INT 10h
    
    PUSH SI
    MOV SI,OFFSET yourRegistersValues
    CALL displayRegistersListInHorizontal   
    POP SI 
  
    ;set the cursor position
    MOV BH,0    ;page number   
    MOV DH,18   ;row
    MOV DL,0   ;column
    MOV AH,2    
    INT 10h 
    
    ;display the word gameLevelMsg
    MOV DX,OFFSET gameLevelMsg
    MOV AH,09H
    INT 21H
    
    ;display the game level
    MOV AL,gameLevel
    ADD AL,'0'
    MOV BH,0
    MOV CX,1
    MOV BL,2FH
    MOV AH,0AH
    INT 10H
        
    ;set the cursor position
    MOV BH,0    ;page number   
    MOV DH,10   ;row
    MOV DL,25   ;column
    MOV AH,2    
    INT 10h 
    
    
    ;display the word gameLevelMsg
    MOV DX,OFFSET ForbiddebCharMsg
    MOV AH,09H
    INT 21H
    
    ;if game level isnot 1 then donot display char
    CMP  gameLevel,1
    JNE HideForbiddenChar1
    
    ;display the forbidden char enter by you
    MOV AL,yourForbiddenChar
    MOV BH,0
    MOV CX,1
    MOV BL,2FH
    MOV AH,0AH
    INT 10H
    HideForbiddenChar1:
    
    ;set the cursor position
    MOV BH,0    ;page number   
    MOV DH,1    ;row
    MOV DL,25   ;column
    MOV AH,2    
    INT 10h 
    
    ;display the word gameLevelMsg
    MOV DX,OFFSET ForbiddebCharMsg
    MOV AH,09H
    INT 21H
    
    ;if game level isnot 1 then donot display char
    CMP  gameLevel,1
    JNE HideForbiddenChar2
    
    ;display the forbidden char enter by you
    MOV AL,opponentForbiddenChar   
    MOV BH,0
    MOV CX,1
    MOV BL,2FH
    MOV AH,0AH
    INT 10H
    HideForbiddenChar2:
    
    ;set the cursor position
    MOV BH,0    ;page number   
    MOV DH,10    ;row
    MOV DL,73   ;column
    MOV AH,2    
    INT 10h 
    
    ;display your flags
    CALL displayFlagsNames   
  
    ;set the cursor position
    MOV BH,0    ;page number   
    MOV DH,10   ;row
    MOV DL,78   ;column
    MOV AH,2    
    INT 10h 
    
    ;display Values of your flags
    MOV SI,OFFSET yourFlags
    CALL displayFlagsValues  
    
    ;set the cursor position
    MOV BH,0    ;page number   
    MOV DH,1    ;row
    MOV DL,73   ;column
    MOV AH,2    
    INT 10h 
    
    ;display opponent flags
    CALL displayFlagsNames   
    
    ;set the cursor position
    MOV BH,0    ;page number   
    MOV DH,1    ;row
    MOV DL,78   ;column
    MOV AH,2    
    INT 10h 
    
    ;display Values of opponent flags
    MOV SI,OFFSET opponentFlags
    CALL displayFlagsValues
    
   RET
pageOne ENDP
;================================================================================
    
   
;================================== PROCEDURE ===================================
pageTwo PROC

    MOV powerUpIndex,0H
    ;set the background and the forground color
    changeForBackColor 0FH,1H
 
    
    ;first center the cursor in the middle of the quarter of screen
    MOV BH,0
    MOV DH,0
    MOV DL,15
    MOV AH,2
    INT 10h

    ;display the choose message string
    MOV DX,offset chooseMessage 
    MOV AH,9
    INT 21h 
    

    ;adjusting display of second page
    displayHorizontalLine 16,0,50,0,0FH,1
    displayHorizontalLine 18,0,50,0,0FH,1
    displayHorizontalLine 21,51,79,0,0FH,1      
    displayVerticalLine 50,0,25,0,0FH,1 
       
    ;set the cursor to the begin of the window
    MOV AH,2H
    MOV DH,2
    MOV DL,0
    INT 10H
    displayList powerUpsList1 
    displayList powerUpsList2
    
    ;adjust the cursor
    MOV BH,0    ;page
    MOV DH,14   ;Y
    MOV DL,0    ;X
    MOV AH,2
    INT 10h   
    ;check if game level is 2 to show extra power up
    CMP gameLevel,1
    JE DonotDisplayExtraPowerUp
    MOV DX,OFFSET extraPowerUp
    MOV AH,9
    INT 21H    
    DonotDisplayExtraPowerUp:
    
    
    ;adjust the cursor
    MOV BH,0    ;page
    MOV DH,19   ;Y
    MOV DL,0    ;X
    MOV AH,2
    INT 10h   
    displayList instructionList   
    
    
    
    ;set the cursor between 2 lines
    MOV BH,0    ;page
    MOV DH,17   ;Y
    MOV DL,0    ;X
    MOV AH,2
    INT 10H
   
    RET                        
pageTwo ENDP
;================================================================================



;================================== PROCEDURE ===================================
firstInputCommand PROC

    ;set the background and the forground color 
    changeForBackColor 0FH,1H
  
  
    ;first center the cursor in the middle of the quarter of screen
    MOV BH,0    ;page
    MOV DH,0    ;Y
    MOV DL,15   ;X
    MOV AH,2
    INT 10h

    ;display the choose message string
    MOV DX,offset chooseMessage 
    MOV AH,9
    INT 21h 
    

    ;adjusting display of first page 1st command
    displayHorizontalLine 16,0,50,0,0FH,1
    displayHorizontalLine 18,0,50,0,0FH,1 
    displayHorizontalLine 21,51,79,0,0FH,1     
    displayVerticalLine 50,0,25,0,0FH,1    
    
    ;set the cursor to the begin of the window
    MOV AH,2H
    MOV DH,2
    MOV DL,0
    INT 10H
    displayList commandList 
    
    ;adjust the cursor
    MOV BH,0    ;page
    MOV DH,19   ;Y
    MOV DL,0    ;X
    MOV AH,2
    INT 10h   
    displayList instructionList
    
    ;set the cursor between 2 lines
    MOV BH,0    ;page
    MOV DH,17   ;Y
    MOV DL,0    ;X
    MOV AH,2
    INT 10H
	
    ;check if there is in game chatting here
	CMP isThereAChatting,1
	JNE NoInGameChattingInFirstinput
    CALL inGameChat
	MOV isThereAChatting,0
	NoInGameChattingInFirstinput:
	
    RET
    
firstInputCommand ENDP 
;================================================================================

;================================== PROCEDURE ===================================
secondInputCommand PROC

    ;set the background and the forground color  
    changeForBackColor 0FH,1H
    
    ;first center the cursor in the middle of the quarter of screen
    MOV BH,0
    MOV DH,0
    MOV DL,15
    MOV AH,2
    INT 10h

    ;display the choose message string
    MOV DX,offset yesOrNoMessage 
    MOV AH,9
    INT 21h 
 
    
    ;adjusting display of first page 1st command
    displayHorizontalLine 16,0,50,0,0FH,1 
    displayHorizontalLine 18,0,50,0,0FH,1
    displayHorizontalLine 21,51,79,0,0FH,1      
    displayVerticalLine 50,0,25,0,0FH,1
    
    ;set the cursor to the begin of the window
    MOV AH,2H
    MOV DH,2
    MOV DL,0
    INT 10H
    displayList isBracketList 
    
    ;adjust the cursor
    MOV BH,0    ;page
    MOV DH,19   ;Y
    MOV DL,0    ;X
    MOV AH,2
    INT 10h   
    displayList instructionList

    
    ;set the cursor between 2 lines
    MOV BH,0    ;page
    MOV DH,17   ;Y
    MOV DL,0    ;X
    MOV AH,2
    INT 10H  
   
    ;check if there is in game chatting here
	CMP isThereAChatting,1
	JNE NoInGameChattingInSecondinput
    CALL inGameChat
	MOV isThereAChatting,0
	NoInGameChattingInSecondinput:
	
    RET 
     
secondInputCommand ENDP
;================================================================================

;================================== PROCEDURE ===================================
thirdInputCommand PROC

    ;set the background and the forground color    
    changeForBackColor 0FH,1H
  
  
    ;first center the cursor in the middle of the quarter of screen
    MOV BH,0
    MOV DH,0
    MOV DL,15
    MOV AH,2
    INT 10h

    ;display the choose message string
    MOV DX,offset chooseMessage 
    MOV AH,9
    INT 21h 
    

    ;adjusting display of first page 1st command
    displayHorizontalLine 16,0,50,0,0FH,1 
    displayHorizontalLine 18,0,50,0,0FH,1
    displayHorizontalLine 21,51,79,0,0FH,1      
    displayVerticalLine 50,0,25,0,0FH,1 
    
    ;set the cursor to the begin of the window
    MOV AH,2H
    MOV DH,2
    MOV DL,0
    INT 10H
    displayList firstOperandList 
    
    ;adjust the cursor
    MOV BH,0    ;page
    MOV DH,19   ;Y
    MOV DL,0    ;X
    MOV AH,2
    INT 10h   
    displayList instructionList

    
    ;set the cursor between 2 lines
    MOV BH,0    ;page
    MOV DH,17   ;Y
    MOV DL,0    ;X
    MOV AH,2
    INT 10H

	;check if there is in game chatting here
	CMP isThereAChatting,1
	JNE NoInGameChattingInThirdinput
    CALL inGameChat
	MOV isThereAChatting,0
	NoInGameChattingInThirdinput:
	
    RET 
     
thirdInputCommand ENDP
;================================================================================

;================================== PROCEDURE ===================================
fourthInputCommand PROC

    ;set the background and the forground color
    changeForBackColor 0FH,1H
    
    ;first center the cursor in the middle of the quarter of screen
    MOV BH,0
    MOV DH,0
    MOV DL,15
    MOV AH,2
    INT 10h

    ;display the choose message string
    MOV DX,offset yesOrNoMessage 
    MOV AH,9
    INT 21h 
    
    ;adjusting display of first page 1st command
    displayHorizontalLine 16,0,50,0,0FH,1 
    displayHorizontalLine 18,0,50,0,0FH,1
    displayHorizontalLine 21,51,79,0,0FH,1      
    displayVerticalLine 50,0,25,0,0FH,1 
    
    
    ;set the cursor to the begin of the window
    MOV AH,2H
    MOV DH,2
    MOV DL,0
    INT 10H
    displayList isBracketList 
    
    ;adjust the cursor
    MOV BH,0    ;page
    MOV DH,19   ;Y
    MOV DL,0    ;X
    MOV AH,2
    INT 10h   
    displayList instructionList

    
    ;set the cursor between 2 lines
    MOV BH,0    ;page
    MOV DH,17   ;Y
    MOV DL,0    ;X
    MOV AH,2
    INT 10H 

	;check if there is in game chatting here
	CMP isThereAChatting,1
	JNE NoInGameChattingInFourthinput
    CALL inGameChat
	MOV isThereAChatting,0
	NoInGameChattingInFourthinput:
	
    RET
    
fourthInputCommand ENDP
;================================================================================

;================================== PROCEDURE ===================================
fifthInputCommand PROC

    ;set the background and the forground color
    changeForBackColor 0FH,1H
  
  
    ;first center the cursor in the middle of the quarter of screen
    MOV BH,0
    MOV DH,0
    MOV DL,15
    MOV AH,2
    INT 10h

    ;display the choose message string
    MOV DX,offset chooseMessage 
    MOV AH,9
    INT 21h 
    

    ;adjusting display of first page 1st command
    displayHorizontalLine 16,0,50,0,0FH,1 
    displayHorizontalLine 18,0,50,0,0FH,1
    displayHorizontalLine 21,51,79,0,0FH,1      
    displayVerticalLine 50,0,25,0,0FH,1 
       
    ;set the cursor to the begin of the window
    MOV AH,2H
    MOV DH,2
    MOV DL,0
    INT 10H
    displayList secondOperandList 
    
    ;adjust the cursor
    MOV BH,0    ;page
    MOV DH,19   ;Y
    MOV DL,0    ;X
    MOV AH,2
    INT 10h   
    displayList instructionList   
    
    ;set the cursor between 2 lines
    MOV BH,0    ;page
    MOV DH,17   ;Y
    MOV DL,0    ;X
    MOV AH,2
    INT 10H

	;check if there is in game chatting here
	CMP isThereAChatting,1
	JNE NoInGameChattingInFifthinput
    CALL inGameChat
	MOV isThereAChatting,0
	NoInGameChattingInFifthinput:
   
    RET

fifthInputCommand ENDP
;================================================================================
                 
;this is the code of 1st page                                      
MAIN PROC FAR
    MOV AX,@DATA
    MOV DS,AX

    ;set video mode to text mode 80x25 
    MOV AL,03H
    MOV AH,0H
    INT 10H
    
    StartGameAgain:
    
    CALL initializePort
    ;<<<<<<<<<page zero>>>>>>>>>
    ;for yourself
    ;for opponent
    changeForBackColor 0FH,0H
    MOV SI,OFFSET opponentForbiddenChar
    PUSH SI
    MOV SI,OFFSET opponentPoints
    PUSH SI
    MOV SI,OFFSET opponentName
    PUSH SI   
    CALL pageZero
    ;<<<<<<<<<page zero>>>>>>>>>
    
	;----------------------------- for sending & recieving	----------------------------- 
    	;here we have 2 cases : 1-> opponent finished data first his so he will send it to me 
	;						2-> I finished data first so I will send him my data first
	; if i finished my data first then I will send 1 to  him telling him that I finished first so that
	; he will give me his data first and I can adjust it and give him all my data background then 
	; so if I finished first and send 1 and wait him to send me his name,points,forbidden char,game leve,registers values
	; then I operate on them and send him the data back
	
	;check for data if any thing is recieved, if there is 1 in data then send him your data
	;else send him 1 and wait for him to send you his data	
	
	MOV DX,03F8H
	IN AL,DX
	CMP AL,1
	JE SendHimMyData
	;send him 1 and wait for him
	MOV DX,3FDH
	AGAIN2:
	IN AL,DX
	AND AL,00100000B
	JZ AGAIN2
	
	MOV DX,3F8H
	MOV AL,1
	OUT DX,AL
	CALL recieveInitData1
	
	;adjust the points of each player
    MOV AH,yourPoints
    CMP AH,opponentPoints
    JL AssignYourPoints
    
    MOV AH,opponentPoints
    MOV yourPoints,AH
    
    JMP EndAssigningPoints
    AssignYourPoints:
    
    MOV AH,yourPoints
    MOV opponentPoints,AH
    
    EndAssigningPoints:
    
    MOV AH,yourPoints
    MOV InitialPoints,AH
	
	;first one to enter his data starts the game first
	MOV personTurn,1
	
	CALL sendData
	
	JMP TEMP
	SendHimMyData:
	CALL sendInitData1
	CALL recieveData
    TEMP:
    
    MOV DI,OFFSET opponentRegistersValues 
    MOV regisetAdd,DI
    ;this is for game level 2
    CMP gameLevel,1
    JE DonotEnterInitialValues2
    CALL enterInitialValuesLv2
	;same thing with sending & recieveing ragisters : first one to finish send 1 and waits for the other to finish
	;if there is value in recieved value buffer
	MOV DX,03F8H
	IN AL,DX
	CMP AL,1
	JE sendMyRegistersValues
	;he didn't finish so I will send him 1
	MOV DX,3F8H
	MOV AL,1
	OUT DX,AL
	;recieve registers data from him and give him all data back
	CALL recieveInitData2
	CALL sendData
	JMP DonotEnterInitialValues2
	sendMyRegistersValues:
	CALL sendInitData2
	CALL recieveData
    DonotEnterInitialValues2:
	
    ;the main will be the manager to decide what window to navigate to 
    INFINITYLOOP1:
	JMP PAGEONE_MAIN
    ;get the entered number from user (2 digits if he didn't press a navigation key)
    ;SI will hold the address of variable to put the index into to
    ;AH will hold the number of digits to be entered
    
    FIRSTCOMMAND:
    MOV navigate,1
    MOV PageNumber,0
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<FIRST INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;display the first screen of input command
    CALL firstInputCommand
    PUSH SI
    MOV SI,OFFSET commandIndex
    MOV AH,2
    CALL readNumFromUserIntoVar
    POP SI
    
    ;check if a navigation button was pressed
    CMP isANavigateButton,01H
	JE firstInputNav
    JMP SECONDCOMMAND
	firstInputNav:
	
	;check if it is a ingame chatting request
	CMP navigationIndex,5
	JNE NoThereIsNoChatting1
	sendInGameChatRquest
	CMP isThereAChatting,1
	JNE NoThereIsNoChatting1
	JMP FIRSTCOMMAND
	MOV isThereAChatting,0
	NoThereIsNoChatting1:
	
	;check if it is out game chat
	CMP navigationIndex,6
	JNE NoThereIsNoOutChatting1
	sendOutGameChatRquest
	CMP isThereAChatting,1
	JNE NoThereIsNoOutChatting1
	JMP OUTGAMECHAT
	NoThereIsNoOutChatting1:

	
    ;clear the variable to be used again
    MOV isANavigateButton,0H
    
    ;macro for navigation purposes
    checkWhichPlaceToNavigateTo
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<FIRST INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
    
    
    SECONDCOMMAND:
    MOV navigate,2
    MOV PageNumber,0
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<SECOND INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;display the second screen of input command
    CALL secondInputCommand
    PUSH SI
    MOV SI,OFFSET isFirstOpBracket
    MOV AH,1
    CALL readNumFromUserIntoVar 
    POP SI
    
    ;check if a navigation button was pressed
    CMP isANavigateButton,01H
    JE secondInputNav
	JMP THIRDCOMMAND
	secondInputNav:
	
	;check if it is a ingame chatting request
	CMP navigationIndex,5
	JNE NoThereIsNoChatting2
	sendInGameChatRquest
	CMP isThereAChatting,1
	JNE NoThereIsNoChatting2
	JMP SECONDCOMMAND
	MOV isThereAChatting,0
	NoThereIsNoChatting2:
	
    ;clear the variable to be used again
    MOV isANavigateButton,0H
    
    ;macro for navigation purposes
    checkWhichPlaceToNavigateTo
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<SECOND INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    

    THIRDCOMMAND:
    MOV navigate,3
    MOV PageNumber,0
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<THIRD INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;display the third screen of input command
    CALL thirdInputCommand
    PUSH SI
    MOV SI,OFFSET firstOperandIndex
    MOV AH,2
    CALL readNumFromUserIntoVar 
    POP SI
    
    ;check if a navigation button was pressed
    CMP isANavigateButton,01H
    JE thirdInputNav
    JMP FOURTHCOMMAND
	thirdInputNav:
	
	;check if it is a ingame chatting request
	CMP navigationIndex,5
	JNE NoThereIsNoChatting3
	sendInGameChatRquest
	CMP isThereAChatting,1
	JNE NoThereIsNoChatting3
	JMP THIRDCOMMAND
	MOV isThereAChatting,0
	NoThereIsNoChatting3:
	
    ;clear the variable to be used again
    MOV isANavigateButton,0H    
    
    ;macro for navigation purposes
    checkWhichPlaceToNavigateTo
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<THIRD INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    
    FOURTHCOMMAND:
    MOV navigate,4
    MOV PageNumber,0
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<FOURTH INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;display the fourth screen of input command
    CALL fourthInputCommand
    PUSH SI
    MOV SI,OFFSET isSecondOpBracket
    MOV AH,1
    CALL readNumFromUserIntoVar 
    POP SI
    
    ;check if a navigation button was pressed
    CMP isANavigateButton,01H
    JE fourthInputNav
    JMP FIFTHCOMMAND
	fourthInputNav:
	
	;check if it is a ingame chatting request
	CMP navigationIndex,5
	JNE NoThereIsNoChatting4
	sendInGameChatRquest
	CMP isThereAChatting,1
	JNE NoThereIsNoChatting4
	JMP FOURTHCOMMAND
	MOV isThereAChatting,0
	NoThereIsNoChatting4:
	
    ;clear the variable to be used again
    MOV isANavigateButton,0H    
    
    ;macro for navigation purposes
    checkWhichPlaceToNavigateTo
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<FOURTH INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    
    FIFTHCOMMAND:
    MOV navigate,5
    MOV PageNumber,0
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<FIFTH INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
    ;display the fifth screen of input command
    CALL fifthInputCommand
    ;first read from source choice from user
    PUSH SI
    MOV SI,OFFSET secondOperandIndex
    MOV AH,2
    CALL readNumFromUserIntoVar 
    POP SI 
    
    ;check if a navigation button was pressed
    CMP isANavigateButton,01H
    JE fIfthInputNav
    JMP CHECKOFTHESOURCEISNUMBER
	fIfthInputNav:
	
	;check if it is a ingame chatting request
	CMP navigationIndex,5
	JNE NoThereIsNoChatting5
	sendInGameChatRquest
	CMP isThereAChatting,1
	JNE NoThereIsNoChatting5
	JMP FIFTHCOMMAND
	MOV isThereAChatting,0
	NoThereIsNoChatting5:
	
    ;clear the variable to be used again
    MOV isANavigateButton,0H  
    
    ;macro for navigation purposes
    checkWhichPlaceToNavigateTo  
    
    CHECKOFTHESOURCEISNUMBER:
    CMP secondOperandIndex,17
	JE sourceIsNum
    JMP THESOURCEISNOTANUMBER
	sourceIsNum:
    ;display the enter message
    MOV DX,OFFSET enterANumber
    MOV AH,9
    INT 21H
    
    PUSH SI
    MOV SI,OFFSET numberEntered
    MOV AH,5
    CALL readWordFromUserIntoVar 
    POP SI  
  
    ;check if a navigation button was pressed
    CMP isANavigateButton,01H
    JNE PAGEONE_MAIN
    ;clear the variable to be used again
    MOV isANavigateButton,0H  
    
    ;macro for navigation purposes
    checkWhichPlaceToNavigateTo 
    
    THESOURCEISNOTANUMBER:  
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<FIFTH INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    
    PAGEONE_MAIN:
	;first check if there is a winner from last round
    CALL checkForWinnerOrLoser
    CMP isGameEnded,0
    JE ContinueTheGame1
    JMP EndTheGame
    ContinueTheGame1:
    MOV navigate,1
    MOV PageNumber,1
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<PAGE 1>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
    ;display the screen of main game
    CALL pageOne
	;if it is not my turn then wait for the other player to execute and send me his data
	MOV AL,personTurnIndex
	CMP AL,personTurn
	JE DonotRecieveValues
	CALL recieveData
	
	;check if there is chatting
	CMP isThereAChatting,1
	JNE DonotRecieveValues
	CMP chatType,0
	JE TypeIsInGameChat
	CMP chatType,1
	JE TypeIsoutGameChat
	JMP DonotRecieveValues
	TypeIsInGameChat:
	checkWhichChatToNavigateTo
	TypeIsoutGameChat:
	JMP OUTGAMECHAT
	DonotRecieveValues: 
	CALL pageOne
	;first check if there is a winner from last round
    CALL checkForWinnerOrLoser
    CMP isGameEnded,0
    JE ContinueTheGame
    JMP EndTheGame
    ContinueTheGame:
    ;check whose turn to adjust the cursor
    CMP personTurn,0
    JNE displayToOpponentScreen1
    ;set the cursor
    MOV BH,0    ;page number
    MOV DL,30   ;column
    MOV DH,12   ;row
    MOV AH,2
    INT 10H
    JMP displayCommandChosen1
    
    displayToOpponentScreen1:
    ;set the cursor
    MOV BH,0    ;page number
    MOV DL,30   ;column
    MOV DH,3    ;row
    MOV AH,2
    INT 10H
    
    displayCommandChosen1:
    ;display the command 
    CALL displayCommandThatTheUserChose
    
    
    ;check whose turn to adjust the cursor
    CMP personTurn,0
    JNE displayToOpponentScreen2
    ;set cursor position 
    MOV BH,0    ;page number
    MOV DL,20   ;COlumn
    MOV DH,11   ;row
    MOV AH,2
    INT 10H
    JMP displayCommandChosen2
    
    displayToOpponentScreen2:
    ;set the cursor
    MOV BH,0    ;page number
    MOV DL,20   ;column
    MOV DH,2    ;row
    MOV AH,2
    INT 10H
    
    displayCommandChosen2:
    ;diplay message to inform him to press enter to execute
    MOV DX,OFFSET sendMessageEnter
    MOV AH,9
    INT 21H
    
    ;check if game level is 1 OR 2
    CMP gameLevel,1
    JE NoGameLevel2Req2
    MOV DX,OFFSET TargetMessage
    MOV AH,9
    INT 21H
    ;read whatever into TargetPerson to check for navigation or target processor
    PUSH SI
    MOV SI,OFFSET TargetPerson
    MOV AH,1
    CALL readNumFromUserIntoVar 
    POP SI
    JMP CheckIfThereIsANavigationInPage1
    
    NoGameLevel2Req2:
    ;read whatever into dummy to check for entered navigation
    PUSH SI
    MOV SI,OFFSET dummyVariable
    MOV AH,1
    CALL readNumFromUserIntoVar 
    POP SI
    
    CheckIfThereIsANavigationInPage1:
    ;check if a navigation button was pressed
    CMP isANavigateButton,01H
    JE SeeWhereToNagigate
    ;clear the variable to be used again
    ;MOV isANavigateButton,0H    
    ;check first if the navigation button was enter and if so then execute command
    CMP navigationIndex,7
    JNE SeeWhereToNagigate
    JMP SENDCOMMAND
    SeeWhereToNagigate:
    ;macro for navigation purposes
    checkWhichPlaceToNavigateTo
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<PAGE 1>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
    
    
    PAGETWO_MAIN:
    MOV navigate,1
    MOV PageNumber,2
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<POWER UP INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
    ;disply the screen of power ups
    CALL pageTwo
    PUSH SI
    MOV SI,OFFSET powerUpIndex
    MOV AH,1
    CALL readNumFromUserIntoVar 
    POP SI
    
    ;check if number is power up number c
    CMP powerUpIndex,3
    JNE ChangeTargetNum
    ;display the message to enter new forbidden Char
    MOV DX,OFFSET EnterNewForbidden
    MOV AH,09H
    INT 21H
    ;read the new forbidden char into temp one
    MOV AH,0
    INT 16H
    ;check if char was in lower case to convert it to upper one
    CMP AL,97
    JL DonotConvertForbiddenToLower1
    CMP AL,122
    JG DonotConvertForbiddenToLower1
    SUB AL,32
    DonotConvertForbiddenToLower1:
    MOV tempForbChar,AL
    
    ;check if power up was 6
    ChangeTargetNum:
    CMP powerUpIndex,6
    JNE NotOptionCInPowerUps
    ;display the message to enter new Target Value
    MOV DX,OFFSET enterNewTargerMsg
    MOV AH,09H
    INT 21H
    ;read the new target num into temp one
    PUSH SI
    MOV SI,OFFSET tempNewTarget
    MOV AH,1
    CALL readWordFromUserIntoVar 
    POP SI
    
    NotOptionCInPowerUps:
    ;check if a navigation button was pressed
    CMP isANavigateButton,01H
    JNE FORPAGETWONOTANAVBUTTON
    ;clear the variable to be used again
    MOV isANavigateButton,0H  
    
    ;macro for navigation purposes
    checkWhichPlaceToNavigateTo 
    FORPAGETWONOTANAVBUTTON:
    JMP INFINITYLOOP1
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<POWER UP INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
	InGameWindow:
	MOV navigate,1
    MOV PageNumber,3 
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<INGAME GAME>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	CALL InitGame
	;set video mode to text mode 80x25 
    MOV AL,03H
    MOV AH,0H
    INT 10H
	JMP PAGEONE_MAIN
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<INGAME GAME>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    SENDCOMMAND:
    
    ;check if there is a power up (default value 0 : no power up) 
    CMP powerUpIndex,0
    JE ThereIsNoPowerUp
    CALL executeAPowerUp
	;TODO
	;after execution , update the values for my opponent
	CALL sendData
    JMP PAGEONE_MAIN
    ThereIsNoPowerUp:
    
    ;check if game level isnot 1 then let you chose target
    CMP gameLevel,1
    JNE YourTurnInLevel2
    JMP ItsYouTurn
    
    YourTurnInLevel2:
    ;see whoose turn
    CMP personTurn,0
    JNE OpponentTurnInLevel2
    ;execute code at my processor
    CMP TargetPerson,1
    JNE ExecuteAtOpponentProcessor
    ;storing the address of varaiables to operate on
    MOV SI,OFFSET yourPoints
    MOV pointsAddress,SI
    
    MOV SI,OFFSET yourAddressesList
    MOV addressesAddress,SI
    
    MOV SI,OFFSET yourRegistersValues
    MOV registersAddress,SI
    
    MOV SI,OFFSET opponentForbiddenChar
    MOV forbiddentCharAdd,SI
    
    MOV SI,OFFSET yourFlags
    MOV flagAddress,SI
    
    ;execute command
    CALL executeCommand
    INC personTurn 
	;TODO
	;after execution , update the values for my opponent
	CALL sendData
    JMP PAGEONE_MAIN
    
    ExecuteAtOpponentProcessor:
    ;storing the address of varaiables to operate on
    MOV SI,OFFSET yourPoints
    MOV pointsAddress,SI
    
    MOV SI,OFFSET opponentAddressesList
    MOV addressesAddress,SI
    
    MOV SI,OFFSET opponentRegistersValues
    MOV registersAddress,SI
    
    MOV SI,OFFSET opponentForbiddenChar
    MOV forbiddentCharAdd,SI
    
    MOV SI,OFFSET opponentFlags
    MOV flagAddress,SI
    
    ;execute command
    CALL executeCommand
    INC personTurn
	;TODO
	;after execution , update the values for my opponent
	CALL sendData
    JMP PAGEONE_MAIN
    
    OpponentTurnInLevel2:
    ;execute code at my processor
    CMP TargetPerson,2
    JNE ExecuteAtOpponentProcessor1
    ;storing the address of varaiables to operate on
    MOV SI,OFFSET opponentPoints          
    MOV pointsAddress,SI
    
    MOV SI,OFFSET yourAddressesList
    MOV addressesAddress,SI
    
    MOV SI,OFFSET yourRegistersValues
    MOV registersAddress,SI
    
    MOV SI,OFFSET yourForbiddenChar
    MOV forbiddentCharAdd,SI
    
    MOV SI,OFFSET yourFlags
    MOV flagAddress,SI
    
    ;execute command
    CALL executeCommand 
    DEC personTurn 
	;TODO
	;after execution , update the values for my opponent
	CALL sendData
    JMP PAGEONE_MAIN
    
    ExecuteAtOpponentProcessor1:
    ;storing the address of varaiables to operate on
    MOV SI,OFFSET opponentPoints          
    MOV pointsAddress,SI
    
    MOV SI,OFFSET opponentAddressesList
    MOV addressesAddress,SI
    
    MOV SI,OFFSET opponentRegistersValues
    MOV registersAddress,SI
    
    MOV SI,OFFSET yourForbiddenChar
    MOV forbiddentCharAdd,SI
    
    MOV SI,OFFSET opponentFlags
    MOV flagAddress,SI
    
    ;execute command
    CALL executeCommand 
    DEC personTurn 
	;TODO
	;after execution , update the values for my opponent
	CALL sendData
    JMP PAGEONE_MAIN
    
    ItsYouTurn:
    ;is it your turn
    CMP personTurn,0
    JNE ItsOpponentTurn
    
    ;storing the address of varaiables to operate on
    MOV SI,OFFSET yourPoints
    MOV pointsAddress,SI
    
    MOV SI,OFFSET opponentAddressesList
    MOV addressesAddress,SI
    
    MOV SI,OFFSET opponentRegistersValues
    MOV registersAddress,SI
    
    MOV SI,OFFSET opponentForbiddenChar
    MOV forbiddentCharAdd,SI
    
    MOV SI,OFFSET opponentFlags
    MOV flagAddress,SI
    
    ;execute command
    CALL executeCommand
    
    INC personTurn
    ;TODO
	;after execution , update the values for my opponent
	CALL sendData
    JMP PAGEONE_MAIN
    
    ItsOpponentTurn:
    
    ;storing the address of varaiables to operate on
    MOV SI,OFFSET opponentPoints          
    MOV pointsAddress,SI
    
    MOV SI,OFFSET yourAddressesList
    MOV addressesAddress,SI
    
    MOV SI,OFFSET yourRegistersValues
    MOV registersAddress,SI
    
    MOV SI,OFFSET yourForbiddenChar
    MOV forbiddentCharAdd,SI
    
    MOV SI,OFFSET yourFlags
    MOV flagAddress,SI
    
    ;execute command
    CALL executeCommand
    
    DEC personTurn
    ;TODO
	;after execution , update the values for my opponent
	CALL sendData
    JMP PAGEONE_MAIN
    
    
    ;the screen of ending the game
    EndTheGame:
   
    changeForBackColor 0FH,6
    ;first center the cursor in the middle of the screen
    MOV BH,0
    MOV DH,10   ;row
    MOV DL,22   ;column
    MOV AH,2    
    INT 10h   
    
    ;display the winner name
    MOV DX,OFFSET WinnerMessage
    MOV AH,9
    INT 21H
    
    MOV DX,winnerNameAddress
    MOV AH,9
    INT 21H
    
    ;first center the cursor in the middle of the screen
    MOV BH,0
    MOV DH,12    ;row
    MOV DL,22    ;column
    MOV AH,2    
    INT 10h 
    
    ;display the loser name
    MOV DX,OFFSET loserMessage
    MOV AH,9
    INT 21H
    
    MOV DX,loserNameAddress
    MOV AH,9
    INT 21H    
    
    ;display the lines
    displayHorizontalLine 9,20,55,0,1,6
    displayHorizontalLine 13,20,55,0,1,6
    displayVerticalLine 19,9,14,0,1,6  
    displayVerticalLine 55,9,14,0,1,6  
    
    ;wait For 15 seconds and then start the game again
    MOV DX,0E1C0H
    MOV CX,00E4H
    MOV AH,86H  ;wait time = (CX DX) in microseconds
    INT 15H

    MOV isGameEnded,0
    
    JMP StartGameAgain
	
	;--------------------------------------------------------------
	OUTGAMECHAT:
	
	changeForBackColor 0FH,6
	displayHorizontalLine	22,0,79,0,0FH,6
	MOV messageToBeSendRow,23
	MOV messageToBeSendCol,0
	MOV messageRecievedRow,0
	MOV messageRecievedCOL,0
	MOV SI,OFFSET messageToBeSend


	OutGameChatLoop:
	
	;first check if there is 2 in the recieved buffer so that recieve a message and print it
	MOV DX,3FDH
	IN AL,DX
	AND AL,1
	JNZ ThereIsSomethingHere_Chat
	JMP NothingIsSentToMe_Chat
	ThereIsSomethingHere_Chat:
	
	MOV DX,03F8H
	IN AL,DX
	;3 -> the other person exited chatting
	CMP AL,3
	JNE NoHeDidnotExit_Chat
	JMP ExitOutGameChatting
	NoHeDidnotExit_Chat:
	;2 -> there is message to be recieved
	CMP AL,2
	JE ThereIsSomethingHere1_Chat
	JMP NothingIsSentToMe_Chat
	ThereIsSomethingHere1_Chat:
	
	;wait till sending buffer is ready
	MOV DX,3FDH
	AGAIN7:
	IN AL,DX
	AND AL,00100000B
	JZ AGAIN7
	
	;wait to recieve message 
	CALL recieveMessage
	
	;set cursor
	MOV BH,0	;page Number
	MOV DL,messageRecievedCOL	;column
	MOV DH,messageRecievedRow	;row
	MOV AH,2
	INT 10H
	
	;print the recieved message
	printMessage messageRecieved,yourName,messageRecievedRow,messageRecievedCOL
	MOV messageRecievedCOL,0
	INC messageRecievedRow
	
	
	
	NothingIsSentToMe_Chat:
	;get cursor
	
	;set cursor
	MOV BH,0	;page Number
	MOV DL,messageToBeSendCol	;column
	MOV DH,messageToBeSendRow	;row
	MOV AH,2
	INT 10H
	
	;check if there is keystroke in the buffer
	MOV AH,01H		;ZF = 1 if keystroke isnot avaialable
	INT 16H			;ZF = 0 if keystroke is avaialable
	JNZ ThereIsSomethingInBuffer_Chat
	JMP NothingInTheBuffer_Chat
	ThereIsSomethingInBuffer_Chat:
	;get the char from the buffer & remove it
	MOV AH,0		;AL = ASCII code
	INT 16H
	;check if the entered chat to be BackSpace
	CMP AL,8
	JNE NotABackSpace_Chat
	backSpaceAChar
	JMP NothingInTheBuffer_Chat
	NotABackSpace_Chat:
	;check if the entered char to be f4 then exit the chat
	CMP AH,03EH
	JNE DonotExitInGameChat_Chat
	sendF4ToExitChatting
	JMP ExitOutGameChatting
	DonotExitInGameChat_Chat:
	;check if the entered char to be ENTER then send the message
	CMP AL,13
	JE SendTheEnteredMessage_Chat
	;store the char in the message to be send and display the char
	MOV [SI],AL
	INC SI
	;display the char
	MOV AH,0EH	;AL = character to display
	INT 10H		;AH = scan code
	INC messageToBeSendCol
	checkForANewRow messageToBeSendCol,messageToBeSendRow
	JMP NothingInTheBuffer_Chat
	
	SendTheEnteredMessage_Chat:
	MOV AL,'$'
	MOV [SI],AL
	
	;TODO : this is for collide -> the two players pressed ENTER at the same time
	
	;send 2
	MOV DX,03F8H
	MOV AL,2
	OUT DX,AL
	
	;wait till he sends 2 to tell me that he is ready
	;check if data ready
	MOV DX,3FDH
	CHK9:
	IN AL,DX
	AND AL,1
	JZ CHK9
	
	;if data is ready store it in the string messageRecieved
	MOV DX,03F8H
	IN AL,DX
	CMP AL,2
	JE ValidReply_Chat
	JMP NotAValidReply_Chat
	ValidReply_Chat:
	CALL sendMessage
	
	;display the message I sent
	;set cursor
	MOV BH,0	;page Number
	MOV DL,messageRecievedCOL	;column
	MOV DH,messageRecievedRow	;row
	MOV AH,2
	INT 10H
	
	;display the message to be send 
	printMessage messageToBeSend,opponentName,messageRecievedRow,messageRecievedCOL
	MOV messageRecievedCOL,0
	INC messageRecievedRow
	
	;clear the screen and reset every thing for a new transmission
	;set cursor
	MOV DH,23
	MOV DL,0
	MOV BH,0
	MOV AH,2
	INT 10H
	;clear writing area
	MOV AL,' '
	MOV BH,0
	MOV CX,80
	MOV AH,0AH
	INT 10H
	;set cursor
	MOV DH,24
	MOV DL,0
	MOV BH,0
	MOV AH,2
	INT 10H
	;clear writing area
	MOV AL,' '
	MOV BH,0
	MOV CX,80
	MOV AH,0AH
	INT 10H

	
	MOV SI,OFFSET messageToBeSend
	MOV messageToBeSendCol,0
	MOV messageToBeSendRow,23
	
	NotAValidReply_Chat:
		
	NothingInTheBuffer_Chat:
	;if the other player presses enter then he will send 2 
	;to tell me that he will send me message then when I read 2 in my buffer 
	;I will send to him 2 to tell him I am ready, send me all of what you got
	
	
	JMP OutGameChatLoop
	
	ExitOutGameChatting:
	MOV messageToBeSendRow,22
	MOV messageToBeSendCol,51
	MOV messageRecievedRow,0
	MOV messageRecievedCOL,51
	
	;set the cursor between 2 lines
    MOV BH,0    ;page
    MOV DH,17   ;Y
    MOV DL,0    ;X
    MOV AH,2
    INT 10H
	
	JMP StartGameAgain
    
MAIN ENDP
END MAIN 