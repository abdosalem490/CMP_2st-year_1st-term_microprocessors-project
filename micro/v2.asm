.MODEL SMALL
.STACK 64
.DATA
;(IMUL IDIV SAR ROL ROR PUSH POP ADC SBB) to be removed 
;these vriables are for the first page 
chooseMessage       DB 'choose$'
yesOrNoMessage      DB 'is there is a bracket$'
commandList         DB '01) ADD,02) ADC,03) SUB,04) SBB,05) RCR,06) RCL,07) MOV,08) XOR,09) AND,10) OR,11) NOP,12) SHR,13) SHL,14) SAR,15) ROL,16) ROR,17) CLC,18) PUSH,19) POP,20) INC,21) DEC,22) IMUL,23) IDIV,24) MUL,25) DIV$'
isBracketList       DB '1) yes,2) No$'
OperandList         DB '1) AX,2) BX,3) CX,4) DX,5) SI,6) DI,7) SP,8) BP,9) AH,10) AL,11) BH,12) BL,13) CH,14) CL,15) DH,16) DL,17) enter a number$' 
powerUpsList1       DB '1) Executing a command on your own processor,(consumes 5 points),2) Changing the forbidden character only once,(consumes 8 points),3) Making one of the data lines stuck at zero or,at one for a single instruction,(consumes 2 points),$'
powerUpsList2       DB '4) Clearing all registers at once.,(Consumes 30 points and could be used only once)$'
instructionList     DB 'use left and right arrow to edit your command,use up and down arrows to scroll pages,use f2 to switch to chatting,use f3 to exit chatting,press enter to send the message$'
addressListHeaders  DB '  0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F$'
noticationsTitle    DB 'notifications ',1,'$'
registersList       DB '  AX    BX    CX    DX    SI    DI    SP    BP $'

;variables to be used later in execution
commandIndex        DB ?
isFirstOpBracket    DB ?
firstOperandIndex   DB ?
isSecondOpBracket   DB ?
secondOperandIndex  DB ?

isANavigateButton   DB 0H

numberEntered       DB 0H

powerUpIndex        DB ?

messageToBeSend     DB 200 DUP('$')
messageRecieved     DB 200 DUP('$')

;variables to be used in other things
navigate    DB  1H
PageNumber  DB  0H  
cursorY     DB  0H
cursorX     DB  0H

NUMtoBeDisplayed DB 4 DUP('$')

;YOUR VARIABLES
yourAddressesList   DB  16 DUP(0)

;yourRegistersValues[0] = AX
;yourRegistersValues[1] = BX
;yourRegistersValues[2] = CX
;yourRegistersValues[3] = DX
;yourRegistersValues[4] = SI
;yourRegistersValues[5] = DI
;yourRegistersValues[6] = SP
;yourRegistersValues[7] = BP
yourRegistersValues DW  8 DUP(0)

yourPoints          DB  212
yourName            DB  'ahmed$'

;OPPONENT VARIABLES
opponentAddressesList   DB  16 DUP(0)

;opponentRegistersValues[0] = AX
;opponentRegistersValues[1] = BX
;opponentRegistersValues[2] = CX
;opponentRegistersValues[3] = DX
;opponentRegistersValues[4] = SI
;opponentRegistersValues[5] = DI
;opponentRegistersValues[6] = SP
;opponentRegistersValues[7] = BP
opponentRegistersValues DW  8 DUP(0)    

opponentPoints          DB  15
opponentName            DB  'abdo$'

.CODE


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
    MOV DH,num
    MOV DL,3
    
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
    ;F2 was clicked
    CMP AH,3CH 
    JE F2ISPRESSEDFROMNAVIGATION
    JMP DONOTHING
    F2ISPRESSEDFROMNAVIGATION:
    MOV isANavigateButton,01H
    MOV cursorX,51   ;cursorX  
    MOV cursorY,33   ;cursorY
    CALL readAndSendMassages
    JMP DONOTHING     
    
    
    LEFTARROW:
    MOV isANavigateButton,01H
    DEC navigate
    JMP ENDARROW
     
    RIGHTARROW: 
    MOV isANavigateButton,01H
    INC navigate
    JMP ENDARROW
     
    UPARROW:
    MOV isANavigateButton,01H
    DEC PageNumber
    JMP ENDPAGE 
    
    DOWNARROW:
    MOV isANavigateButton,01H
    INC PageNumber
    JMP ENDPAGE
    
    
    ENDPAGE:
    ;look for page to switch to
    CMP PageNumber,0
    JNE NO12
    CALL pageZero
    
    NO12:
    CMP PageNumber,1
    JNE NO1
    CALL pageOne
    
    NO1:
    CMP PageNumber,2
    JNE NO2
    CALL pageTwo
    
    
    ENDARROW:
    ;look for the navigator to see what screen to navigate to
    CMP navigate,1
    JNE NO3
    CALL firstInputCommand
    
    NO3:
    CMP navigate,2
    JNE NO4
    CALL secondInputCommand
    
    NO4:
    CMP navigate,3
    JNE NO5
    CALL thirdInputCommand
    
    NO5:
    CMP navigate,4
    JNE NO6
    CALL fourthInputCommand
   
    NO6:
    CMP navigate,5
    CALL fifthInputCommand
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
    CALL firstInputCommand
    
    NO7:
    CMP navigate,2
    JNE NO8
    CALL secondInputCommand
    
    NO8:
    CMP navigate,3
    JNE NO9
    CALL thirdInputCommand
    
    NO9:
    CMP navigate,4
    JNE NO10
    CALL fourthInputCommand
   
    NO10:
    CMP navigate,5
    JNE NO11
    CALL fifthInputCommand
    
    NO11:
    ;check if enter is clicked to send the message
    CMP AH,1CH
    ;----------------------------------------
    ;TODO : WRITE THE CODE TO SEND A MESSAGE |
    ;----------------------------------------    
    SENDMESSAGE:    
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
;this a procedure is to read from the user
readNumFromUserIntoVar PROC
    
    ;SI will hold the address of the variable to store the enter variable in it
    ;AH will hold the number of the digits            
    MOV [SI],0H
    MOV CL,AH

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
    JNE ITSANAVIGATIONBUTTON
    
    ;display the entered character
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
    
    DEC CL
    ITSANAVIGATIONBUTTON:
    
    JNZ L1
 
    RET
    
readNumFromUserIntoVar ENDP
;================================================================================


;================================== PROCEDURE ===================================
pageZero PROC

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<FIRST INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
CALL firstInputCommand
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<FIRST INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 

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
    
   RET
pageOne ENDP
;================================================================================
    
   
;================================== PROCEDURE ===================================
pageTwo PROC

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<POWER UP INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
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
    
    PUSH SI
    MOV SI,OFFSET powerUpIndex
    MOV AH,1
    CALL readNumFromUserIntoVar 
    POP SI

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<POWER UP INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<page 1>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
CALL pageOne
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<page 1>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    RET                      
      
pageTwo ENDP
;================================================================================



;================================== PROCEDURE ===================================
firstInputCommand PROC

    MOV commandIndex,0H
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
    

    PUSH SI
    MOV SI,OFFSET commandIndex
    MOV AH,2
    CALL readNumFromUserIntoVar 
    POP SI
    
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<SECOND INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    CALL secondInputCommand
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<SECOND INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    RET
    
firstInputCommand ENDP 
;================================================================================

;================================== PROCEDURE ===================================
secondInputCommand PROC

    MOV isFirstOpBracket,0H
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
    
    PUSH SI
    MOV SI,OFFSET isFirstOpBracket
    MOV AH,1
    CALL readNumFromUserIntoVar 
    POP SI
    
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<THIRD INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    CALL thirdInputCommand
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<THIRD INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    RET 
     
secondInputCommand ENDP
;================================================================================

;================================== PROCEDURE ===================================
thirdInputCommand PROC

    MOV firstOperandIndex,0H
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
    
    
    PUSH SI
    MOV SI,OFFSET firstOperandIndex
    MOV AH,2
    CALL readNumFromUserIntoVar 
    POP SI
    
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<FOURTH INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    CALL fourthInputCommand
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<FOURTH INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    RET 
     
thirdInputCommand ENDP
;================================================================================

;================================== PROCEDURE ===================================
fourthInputCommand PROC

    MOV isSecondOpBracket,0H
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

      
    PUSH SI
    MOV SI,OFFSET isSecondOpBracket
    MOV AH,1
    CALL readNumFromUserIntoVar 
    POP SI
    
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<FIFTH INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
    CALL fifthInputCommand
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<FIFTH INPUT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    RET
    
fourthInputCommand ENDP
;================================================================================

;================================== PROCEDURE ===================================
fifthInputCommand PROC

    MOV secondOperandIndex,0H
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
    
    
    PUSH SI
    MOV SI,OFFSET secondOperandIndex
    MOV AH,2
    CALL readNumFromUserIntoVar 
    POP SI 
    
    CMP secondOperandIndex,17
    JNE PAGEONEFROMFIFTHINPUTCOMMAND
    PUSH SI
    MOV SI,OFFSET numberEntered
    MOV AH,3
    CALL readNumFromUserIntoVar 
    POP SI  
    
    PAGEONEFROMFIFTHINPUTCOMMAND:
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<PAGE 1>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
    CALL pageOne
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<PAGE 1>>>>>>>>>>>>>>>>>>>>>>>>>>>>>    
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
    
    CALL pageZero    
        
MAIN ENDP
END MAIN 