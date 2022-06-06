.MODEL SMALL
.STACK 64
.DATA
;these vriables are for the first page 
chooseMessage   DB 'choose$'
yesOrNoMessage  DB 'is there is a bracket$'
commandList     DB '01) ADD,02) ADC,03) SUB,04) SBB,05) DIV,06) MUL,07) MOV,08) XOR,09) AND,10) OR,11) NOP,12) SHR,13) SHL,14) SAR,15) CLC,16) ROR,17) ROL,18) PUSH,19) POP,20) INC,21) DEC,22) IMUL,23) IDIV,24) RCL ,25) RCR$'
isBracketList   DB '1) yes,2) No$'
OperandList     DB '1) AX,2) BX,3) CX,4) DX,5) SI,6) DI,7) SP,8) BP,9) AH,10) AL,11) BH,12) BL,13) CH,14) CL,15) DH,16) DL$' 
powerUpsList    DB '1) Executing a command on your own processor,(consumes 5 points),2) Changing the forbidden character only once,(consumes 8 points),3) Making one of the data lines stuck at zero or,at one for a single instruction,(consumes 2 points),4) Clearing all registers at once.,(Consumes 30 points and could be used only once)$'
instructionList DB 'use left and right arrow to edit your command,use up and down arrows to scroll pages,use f2 to switch to chatting,use f3 to exit chatting,after you write the message press enter to send the message$'

;variables to be used later in execution
commandIndex        DB ?
isFirstOpBracket    DB ?
firstOperandIndex   DB ?
isSecondOpBracket   DB ?
secondOperandIndex  DB ?

powerUpIndex        DB ?

messageToBeSend     DB 200 DUP('$')
messageRecieved     DB 200 DUP('$')

;variables to be used in other things
navigate    DB  1H
PageNumber  DB  0H


.CODE


;==================================MACRO===================================
;this is a macro to change foreground and background color of a screen
changeForBackColor MACRO forColor,BackColor
    MOV AH,06H
    ;use BH as register to put the 2 values sticked together
    MOV BH,BackColor
    SHL BH,4
    OR  BH,forColor
    
    XOR AL, AL     ; Clear entire screen    => same as MOV al,0
    XOR CX, CX     ; Upper left corner CH=row, CL=column  => same as MOV cx, 0
    MOV DX, 184FH  ; lower right corner DH=row, DL=column
    INT 10H    
        
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
displayHorizontalLine MACRO rowNum,startPos,endPos,pageNum 
    ;set the cursor to the desired position
    MOV BH,pageNum  ;page   
    MOV DH,rowNum   ;Y
    MOV DL,startPos ;X
    MOV AH,2
    INT 10h     
    
    ;display the line 
    MOV AH,9H       ;Display
    MOV BH,pageNum  ;Page 
    MOV AL,'='      ;char to be displayed
    MOV CX,endPos   ;number of times 
    SUB CX,startPos
    MOV BL,0F1h     ;blue (1) on white(F) background
    INT 10h
    
ENDM 

displayVerticalLine MACRO columnNum,startPos,endPos,pageNum 
    local L
    ;set the cursor to the desired position
    MOV BH,pageNum  ;page   
    MOV DH,startPos ;Y
    MOV DL,columnNum;X
    MOV AH,2
    INT 10h     
    L:
    ;display the line 
    MOV AH,9H       ;Display
    MOV BH,pageNum  ;Page 
    MOV AL,'|'      ;char to be displayed  
    MOV CX,1        ;number of times      
    MOV BL,0F1h     ;blue (1) on white(F) background
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

;==================================MACRO===================================
;this macro is to navigate
navigateBetweenScreens MACRO scanCode
    Local LEFTARROW,RIGHTARROW,UPARROW,DOWNARROW,ENDARROW,DONOTHING,ENDPAGE
    ;store registers
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    ;check for entered arrow
    ;left arrow was clicked
    CMP scanCode,4BH
    JE LEFTARROW
    ;right arrow was clicked
    CMP scanCode,4DH
    JE RIGHTARROW 
    ;up arrow was clicked
    CMP scanCode,48H
    JE UPARROW
    ;down arrow was clicked    
    CMP scanCode,50H
    JE DOWNARROW
    ;F2 was clicked
    CMP scanCode,3CH 
    JNE DONOTHING
    readAndSendMassages 51,22,PageNumber
    JMP DONOTHING     
    
     
    
    LEFTARROW:
    DEC navigate
    JMP ENDARROW
     
    RIGHTARROW: 
    INC navigate
    JMP ENDARROW
     
    UPARROW:
    DEC PageNumber
    JMP ENDPAGE 
    
    DOWNARROW:
    INC PageNumber
    JMP ENDPAGE
    
    
    ENDPAGE:
    ;look for page to switch to
    CMP PageNumber,0
    JE PAGEZERO 
    
    CMP PageNumber,1
    JE PAGEONE
    
    
    ENDARROW:
    ;look for the navigator to see what page to navigate to
    CMP navigate,1
    JE FIRSTINCOMMAND
    
    CMP navigate,2
    JE SECONDINCOMMAND
    
    CMP navigate,3
    JE THIRDINCOMMAND
    
    CMP navigate,4
    JE FOURTHINCOMMAND
   
    CMP navigate,5
    JE FIFTHINCOMMAND
   
    
    DONOTHING:
    ;restore registers
    POP DX
    POP CX
    POP BX
    POP AX                
ENDM
;==========================================================================


;==================================MACRO===================================
;this is amacro for massaging purposes
readAndSendMassages  MACRO cursorX,cursorY,pageNum
    Local L,M,SAMEROW,NEWROW,NEWROW1,MESSAGE,SENDMESSAGE
    ;move cursor to the required position
    MOV BH,pageNum    ;page
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
    JE FIRSTINCOMMAND
    
    CMP navigate,2
    JE SECONDINCOMMAND
    
    CMP navigate,3
    JE THIRDINCOMMAND
    
    CMP navigate,4
    JE FOURTHINCOMMAND
   
    CMP navigate,5
    JE FIFTHINCOMMAND 
    ;check if enter is clicked to send the message
    CMP AH,1CH
    ;----------------------------------------
    ;TODO : WRITE THE CODE TO SEND A MESSAGE |
    ;----------------------------------------    
    SENDMESSAGE:    
    ;set the cursor position
    MOV BH,pageNum    ;page
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
    MOV BH,pageNum  ;DH : row , DL : column
    MOV AH,03H
    INT 10H
    
    ;check X reached the end
    CMP DL,80
    JE NEWROW1
    NEWROW1:
    ;adjust cursor to a new row
    MOV BH,pageNum    ;page
    INC DH            ;Y
    MOV DL,cursorX    ;X
    MOV AH,2
    INT 10h    
        
    ;reset cursor to the start position of the message type space
    MOV BH,pageNum    ;page
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
    MOV BH,pageNum  ;DH : row , DL : column
    MOV AH,03H
    INT 10H
    ;check X reached the end
    CMP DL,80
    JE NEWROW
    JNE SAMEROW
    
    NEWROW:
    ;adjust cursor to a new row
    MOV BH,pageNum    ;page
    INC DH            ;Y
    MOV DL,cursorX    ;X
    MOV AH,2
    INT 10h
    
    SAMEROW:

    CMP AH,1CH
    JNE L 
    POP SI
    
ENDM


;==========================================================================

          
;==================================MACRO===================================
;this macro is to read from the user
readNumFromUserIntoVar MACRO var,numOfDigits
    Local L1
    MOV var,0H
    MOV CL,numOfDigits

    L1:
    ;reading number enter from the user and display it 
    MOV AH,0H   ;get key pressed : AH : scancode , AL : Ascii code
    INT 16H
    ;check for the input value if it was a navigation button
    navigateBetweenScreens AH
    ;display the entered character
    MOV DL,AL
    MOV AH,2
    INT 21H
    ;store the entered value
    MOV CH,AL
    SUB CH,48 
    MOV BL,var
    ;shifting by multiplication
    MOV AL,10
    MUL BL      ;AX = AL * BL
    ADD Al,CH
    MOV var,AL
    
    DEC CL
    JNZ L1
          
    INC navigate
    
ENDM
;==========================================================================

                 
;this is the code of 1st page                                      
MAIN PROC FAR
    MOV AX,@DATA
    MOV DS,AX
    
    PAGEZERO:
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<FIRST INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>   
    FIRSTINCOMMAND:        
    MOV commandIndex,0H
    ;set the background and the forground color 
    changeForBackColor 4H,0FH
  
  
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
    displayHorizontalLine 16,0,50,0 
    displayHorizontalLine 18,0,50,0 
    displayHorizontalLine 21,51,79,0     
    displayVerticalLine 50,0,25,0    
    
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
    
  
    readNumFromUserIntoVar commandIndex,2
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<FIRST INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>   
    
    
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<SECOND INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
    SECONDINCOMMAND:
    MOV isFirstOpBracket,0H
    ;set the background and the forground color  
    changeForBackColor 4H,0FH
    
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
    displayHorizontalLine 16,0,50,0 
    displayHorizontalLine 18,0,50,0
    displayHorizontalLine 21,51,79,0      
    displayVerticalLine 50,0,25,0
    
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

    readNumFromUserIntoVar isFirstOpBracket,1 
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<SECOND INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      
    
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<THIRD INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
    THIRDINCOMMAND:
    MOV firstOperandIndex,0H
    ;set the background and the forground color    
    changeForBackColor 4H,0FH
  
  
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
    displayHorizontalLine 16,0,50,0 
    displayHorizontalLine 18,0,50,0
    displayHorizontalLine 21,51,79,0      
    displayVerticalLine 50,0,25,0 
    
    ;set the cursor to the begin of the window
    MOV AH,2H
    MOV DH,2
    MOV DL,0
    INT 10H
    displayList OperandList 
    
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
    
  
    readNumFromUserIntoVar firstOperandIndex,2
    
    
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<THIRD INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<FOURTH INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
    FOURTHINCOMMAND:
    MOV isSecondOpBracket,0H
    ;set the background and the forground color
    changeForBackColor 4H,0FH
    
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
    displayHorizontalLine 16,0,50,0 
    displayHorizontalLine 18,0,50,0
    displayHorizontalLine 21,51,79,0      
    displayVerticalLine 50,0,25,0 
    
    
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

    readNumFromUserIntoVar isSecondOpBracket,1 
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<FOURTH INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
    
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<FIFTH INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
    FIFTHINCOMMAND: 
    MOV secondOperandIndex,0H
    ;set the background and the forground color
    changeForBackColor 4H,0FH
  
  
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
    displayHorizontalLine 16,0,50,0 
    displayHorizontalLine 18,0,50,0
    displayHorizontalLine 21,51,79,0      
    displayVerticalLine 50,0,25,0 
       
    ;set the cursor to the begin of the window
    MOV AH,2H
    MOV DH,2
    MOV DL,0
    INT 10H
    displayList OperandList 
    
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
    
  
    readNumFromUserIntoVar secondOperandIndex,2   
    
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<FIFTH INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>   
    
    
    PAGEONE:
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<POWER UP INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  
    MOV powerUpIndex,0H
    ;set the background and the forground color
    changeForBackColor 4H,0FH
  
  
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
    displayHorizontalLine 16,0,50,0 
    displayHorizontalLine 18,0,50,0
    displayHorizontalLine 21,51,79,0      
    displayVerticalLine 50,0,25,0 
       
    ;set the cursor to the begin of the window
    MOV AH,2H
    MOV DH,2
    MOV DL,0
    INT 10H
    displayList powerUpsList 
    
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
    
  
    readNumFromUserIntoVar powerUpIndex,1   
    
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<POWER UP INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
MAIN ENDP
END MAIN                             