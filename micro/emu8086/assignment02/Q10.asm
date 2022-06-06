.MODEL SMALL
.STACK 64
.DATA
Grades              DB      81,65,77,82,73,55,88,78,51,91,86,76
NumberOfGrades      DB      12     

.CODE                           
MAIN PROC FAR      

    
    MOV BX,@DATA
    MOV DS,BX   
    
    ;we will use Dl as Counter for num of grades   
    MOV DL,NumberOfGrades
    MOV CL,0
    
    MOV SI,OFFSET Grades 
    
GetMaxLoop:

      ;first we get the max Grade 
      ;store current value in DH
    
      MOV DH,[SI]           
      CMP DH,CL
      
      JG IsGreaterThan 
      JL ISSmaller
      
IsGreaterThan:
      ;store the max value in CL 
      MOV CL,DH
        
ISSmaller:
      ADD DH,32
      
      INC SI
      
      DEC DL
      jnz GetMaxLoop


;Calculate addition value offset
     MOV CH,99
     SUB CH,CL 
     
;initializing register again
     MOV DL,NumberOfGrades   
     MOV SI,OFFSET Grades
     
;adding offset value to each grade

CurvingGrades:
        
        MOV BL,[SI]
        ADD BL,CH
        MOV [SI],BL
        INC SI
                          
        
        DEC DL
        JNZ CurvingGrades
                  
      HLT
MAIN ENDP
END MAIN