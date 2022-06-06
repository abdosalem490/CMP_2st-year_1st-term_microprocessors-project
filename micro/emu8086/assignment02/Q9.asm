.MODEL SMALL
.STACK 64
.DATA
InputString     DB      'THis iS A TEsT MESsaGE'
ResultString    DB      22 DUP(?)
StringSize      DB      22     

.CODE                           
MAIN PROC FAR      
    
    MOV BX,@DATA
    MOV DS,BX   
    MOV DL,StringSize
    
    MOV SI,OFFSET InputString 
    MOV BX,OFFSET ResultString
    
MainLoop:

      MOV DH,[SI]
           
      CMP DH,65
      JGE IsGreaterThan 
      JL IsSmall
      
IsGreaterThan:
      CMP DH,90
      JLE IsCaptial 
      JG IsSmall
        
IsCaptial:
      ADD DH,32

IsSmall:
      MOV [BX],DH
      INC SI
      INC BX
      DEC DL
      jnz MainLoop
                  
                  
      HLT
MAIN ENDP
END MAIN