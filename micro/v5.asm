.MODEL SMALL 
.STACK 128
.DATA
;(IMUL IDIV SAR ROL ROR PUSH POP ADC SBB) to be removed 
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
instructionList     DB 'use left and right arrow to edit your command,use up and down arrows to scroll pages,use f2 to switch to chatting,use f3 to exit chatting,press enter to send the message$'
addressListHeaders  DB '  0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F$'
noticationsTitle    DB 'notifications ',1,'$'
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
enterRegisterVal    DB 'AX : ,BX : ,CX : ,DX : ,SI : ,DI : ,SP : ,BP : ,$'
extraPowerUp        DB '6) Change target Value$'

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
isANavigateButton   DB 0H
navigationIndex     DB 0H

dummyVariable       DB 0H

powerUpIndex        DB 0

messageToBeSend     DB 200 DUP('$')
messageRecieved     DB 200 DUP('$')

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
yourForbiddenChar       DB  1  DUP('$')  
yourAddressesList       DB  16 DUP(0)
yourFlags               DW  0
youchangedForbiddenKey  DB  0 ;IF 1 then you cannot change opponent key again
youMadeRegWithZero      DB  0 ;If 1 then you canot use this power up again 

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

;OPPONENT VARIABLES
opponentForbiddenChar       DB  1  DUP('$')
opponentAddressesList       DB  16 DUP(0)
opponentFlags                DW  0
opponentchangedForbiddenKey  DB  0 ;IF 1 then opponent cannot change opponent key again
opponentMadeRegWithZero      DB  0 ;If 1 then opponent canot use this power up again 

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
checkWhichPlaceToNavigateTo  MACRO
LOCAL ENDPAGE,NO12,NO1,ENDARROW,NO3,NO4,NO5,NO6,UNKNOWNNAVIGATOR

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
    JNE UNKNOWNNAVIGATOR
    JMP PAGETWO_MAIN
    
    
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
    
    displaySourceNumberByConvertingItToAscii numberEntered,0FH,3
    
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
    JNE NOTANAVIGATEBUTTON
    
    ;F2 was clicked
    ;CMP AH,3CH 
    ;JE F2ISPRESSEDFROMNAVIGATION
    ;JMP DONOTHING
    ;F2ISPRESSEDFROMNAVIGATION:
    ;MOV isANavigateButton,01H
    ;MOV cursorX,51   ;cursorX  
    ;MOV cursorY,33   ;cursorY
    ;CALL readAndSendMassages
    ;JMP DONOTHING     
    
    
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
    ;MOV isANavigateButton,01H
    MOV navigationIndex,7
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
;===============================================================================================

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
    ;this is ADD command (TO BE REMOVED)
    ADDCOMMAND:
    CMP commandIndex,1
    JE ADDCOMMAND1
    JMP ADCCOMMAND
    ADDCOMMAND1:
;------------------------------------------------------------------------------------------------  
    ;this is ADC command (TO BE REMOVED)
    ADCCOMMAND:
    CMP commandIndex,2
    JE ADCCOMMAND1
    JMP SUBCOMMAND
    ADCCOMMAND1:
;------------------------------------------------------------------------------------------------   
    ;this is SUB command (TO BE REMOVED)
    SUBCOMMAND:
    CMP commandIndex,3
    JE SUBCOMMAND1
    JMP SBBCOMMAND
    SUBCOMMAND1:
;------------------------------------------------------------------------------------------------   
    ;this is SBB command (TO BE REMOVED)
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
    ;this is MOV command (TO BE REMOVED)
    MOVCOMMAND:
    CMP commandIndex,7
    JE MOVCOMMAND1
    JMP XORCOMMAND
    MOVCOMMAND1:
;------------------------------------------------------------------------------------------------   
    ;this is XOR command (TO BE REMOVED)
    XORCOMMAND:
    CMP commandIndex,8
    JE XORCOMMAND1
    JMP ANDCOMMAND
    XORCOMMAND1:
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
    
    ANDCOMMAND14:
    ;1nd operand has bracket 
    CMP isFirstOpBracket,1
    JE ANDCOMMAND15
    JMP ANDCOMMAND16
    ANDCOMMAND15:
    
    
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
    
    ;========================
    ;AND AL,Source with no bracket
    AND_AL1:
    CMP firstOperandIndex,10
    JE AND_AL2
    JMP AND_BH1
    AND_AL2:
    
    ;========================
    ;AND BH,Source with no bracket
    AND_BH1:
    CMP firstOperandIndex,11
    JE AND_BH2
    JMP AND_BL1
    AND_BH2:
    
    ;========================
    ;AND BL,Source with no bracket
    AND_BL1:
    CMP firstOperandIndex,12
    JE AND_BL2
    JMP AND_CH1
    AND_BL2:
    
    ;========================
    ;AND CH,Source with no bracket
    AND_CH1:
    CMP firstOperandIndex,13
    JE AND_CH2
    JMP AND_CL1
    AND_CH2:
    
    ;========================
    ;AND CL,Source with no bracket
    AND_CL1:
    CMP firstOperandIndex,14
    JE AND_CL2
    JMP AND_DH1
    AND_CL2:
    
    ;========================
    ;AND DH,Source with no bracket
    AND_DH1:
    CMP firstOperandIndex,15
    JE AND_DH2
    JMP AND_DL1
    AND_DH2:
    
    ;========================
    ;AND DL,Source with no bracket
    AND_DL1:
    CMP firstOperandIndex,15
    JE AND_DL2
    JMP NOTAVAILIDCOMMAND
    AND_DL2:
    
    
    
;------------------------------------------------------------------------------------------------  
    ;this is OR command (TO BE REMOVED)
    ORCOMMAND:
    CMP commandIndex,10
    JE ORCOMMAND1
    JMP SHRCOMMAND
    ORCOMMAND1:
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
    JNE EndExecutePowerUps
    
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
    ;<<<<<<<<<page zero>>>>>>>>>
    ;for yourself
    changeForBackColor 0FH,0H
    MOV SI,OFFSET yourForbiddenChar
    PUSH SI
    MOV SI,OFFSET yourPoints
    PUSH SI
    MOV SI,OFFSET yourName
    PUSH SI
    CALL pageZero
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
    
    
    MOV DI,OFFSET yourRegistersValues
    MOV regisetAdd,DI
    ;this is for game level 2
    CMP gameLevel,1
    JE DonotEnterInitialValues1
    CALL enterInitialValuesLv2
    DonotEnterInitialValues1:
    
    MOV DI,OFFSET opponentRegistersValues 
    MOV regisetAdd,DI
    ;this is for game level 2
    CMP gameLevel,1
    JE DonotEnterInitialValues2
    CALL enterInitialValuesLv2
    DonotEnterInitialValues2:
    
    ;temp to be removed later
    ;PUSH SI
    ;PUSH AX
    ;MOV SI,OFFSET opponentRegistersValues 
    ;MOV AX,253
    ;MOV [SI],AX
    
    ;ADD SI,2
    ;MOV AX,0FFFFH
    ;MOV [SI],AX
    
    ;ADD SI,2
    ;MOV AX,10
    ;MOV [SI],AX
    
    ;ADD SI,2
    ;MOV AX,50
    ;MOV [SI],AX
    ;POP SI
    ;POP AX
    
    ;the main will be the manager to decide what window to navigate to 
    INFINITYLOOP1:
   
    ;first check if there is a winner from last round
    CALL checkForWinnerOrLoser
    CMP isGameEnded,0
    JE ContinueTheGame
    JMP EndTheGame
    ContinueTheGame:
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
    JNE SECONDCOMMAND
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
    JNE THIRDCOMMAND
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
    JNE FOURTHCOMMAND
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
    JNE FIFTHCOMMAND
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
    JNE CHECKOFTHESOURCEISNUMBER
    ;clear the variable to be used again
    MOV isANavigateButton,0H  
    
    ;macro for navigation purposes
    checkWhichPlaceToNavigateTo  
    
    CHECKOFTHESOURCEISNUMBER:
    CMP secondOperandIndex,17
    JNE THESOURCEISNOTANUMBER
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
    MOV navigate,1
    MOV PageNumber,1
    ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<PAGE 1>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
    ;display the screen of main game
    CALL pageOne
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
    JNE NotOptionCInPowerUps
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
    
    
    SENDCOMMAND:
    
    ;check if there is a power up (default value 0 : no power up) 
    CMP powerUpIndex,0
    JE ThereIsNoPowerUp
    CALL executeAPowerUp
    JMP INFINITYLOOP1
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
    JMP INFINITYLOOP1
    
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
    JMP INFINITYLOOP1
    
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
    JMP INFINITYLOOP1
    
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
    JMP INFINITYLOOP1
    
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
    
    JMP INFINITYLOOP1
    
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
    
    JMP INFINITYLOOP1
    
    
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
    
MAIN ENDP
END MAIN 