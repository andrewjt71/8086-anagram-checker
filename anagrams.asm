org 100h

include 'emu8086.inc'

        
    ;ask for input and store as array (inputstring1)
    print "enter string: "                  ;ask user for string
    LEA DI, inputstring1                    ;load address of destination array into DI          
    MOV DX, inputstring1size                ;move size of destination array into DX             
    CALL get_string                         ;save user input into destination array indexed by DI    
                                            
    PRINT 13
    PRINT 10
    
    ;read inputstring1 and print
    PRINT "just read string: "              ;notify user that string has been read   
    LEA SI, inputstring1                    ;load address of source array into SI          
    CALL print_string                       ;print source array indexed by SI
     
    PRINT 13
    PRINT 10   
      
    ;ask for input and store as array (inputstring2)
    PRINT "enter string: "                  ;ask user for string
    LEA DI, inputstring2                    ;load address of destination array into DI            
    MOV DX, inputstring2size                ;move size of destination array into DX                 
    CALL get_string                         ;save user input into destination array indexed by DI     
    
    PRINT 13
    PRINT 10
    
    ;read inputstring2 and print
    PRINT "just read string: "              ;notify user that string has been read   
    LEA SI, inputstring2                    ;load address of source array into SI             
    CALL print_string                       ;print source array indexed by SI
     
    PRINT 13
    PRINT 10  
         
    ;convert inputstring1 to lowercase
    ;save to inputstring1                    
    LEA SI, inputstring1                    ;load address of source array into SI 
    CALL LOWERCASE_SUB                      ;convert source array to lowercase                              
    LEA SI, inputstring1                    ;load address of source array into SI           
    CALL print_string                       ;print source array indexed by SI
     
    PRINT 13
    PRINT 10   
        
    ;convert inputstring1 to lowercase
    ;save to inputstring1                   
    LEA SI, inputstring2                    ;load address of source array into SI
    CALL LOWERCASE_SUB                      ;convert source array to lowercase                       
    LEA SI, inputstring2                    ;load address of source array into SI 
    CALL print_string                       ;print source array indexed by SI
     
    PRINT 13
    PRINT 10 
    
    ;save alphabetic chars from inputstring1 to alpha1
    LEA SI, inputstring1                    ;load address of source array into SI 
    LEA DI, alpha1                          ;load address of destination array into DI 
    CALL REMOVE_SYMBOLS_SUB                 ;copies alphabetic chars from source array to destination array
    LEA SI, alpha1                          ;load address of source array into SI 
    CALL print_string                       ;print source array indexed by at SI

    PRINT 13
    PRINT 10
    
    ;save alphabetic chars from inputstring2 to alpha2
    LEA SI,inputstring2                    ;load address of source array into SI  
    LEA DI,alpha2                          ;load address of destination array into DI 
    CALL REMOVE_SYMBOLS_SUB                ;copies alphabetic chars from source array to destination array
    LEA SI, alpha2                         ;load address of source array into SI 
    CALL print_string                      ;print source array indexed by at SI

    PRINT 13
    PRINT 10
    
    ;calculate letter frequencies in alpha1
    ;save to array alphacountarray1
    ;print alphacountarray1
    LEA SI, alpha1                         ;load address of source array into SI 
    LEA DI, alphacountarray1               ;load address of destination array into DI 
    CALL COUNT_ALPHA_OCCURRENCES_SUB       ;count letter occurrences in source array, save in destination array
    LEA SI, alphacountarray1               ;load address of source array into SI 
    CALL PRINT_ALPHA_OCCURRENCES_SUB       ;print source array indexed by at SI
    
    PRINT 13
    PRINT 10
    
    ;calculate letter frequencies in alpha2
    ;save to array alphacountarray2
    ;print alphacountarray2
    LEA SI, alpha2                         ;load address of source array into SI 
    LEA DI, alphacountarray2               ;load address of destination array into DI 
    CALL COUNT_ALPHA_OCCURRENCES_SUB       ;count letter occurrences in source array, save in destination array 
    LEA SI, alphacountarray2               ;load address of source array into SI
    CALL PRINT_ALPHA_OCCURRENCES_SUB       ;print source array indexed by at SI
    
    PRINT 13
    PRINT 10
       
    ;compare each digit of character counts
    ;calculate and display whether anagrams    
    MOV SI,0                               ;clear SI
anagramtest:
    MOV AX,0                               ;clear AX
    CMP SI,26                              ;check not end of array
    JE anagrams                            ;of end of array and no differences, inputs are anagrams
    MOV Al, alphacountarray1[SI]           ;move digit at current index in 1st array to AL
    CMP Al, alphacountarray2[SI]           ;compare digit in AL to digit at current index in 2nd array
    JNE notanagrams                        ;if difference found at any index inputs are not anagrams
    INC SI                                 ;next character
    JMP anagramtest                        ;run again for next character
anagrams:
    PRINT "strings ARE anagrams"           ;notify user words are anagrams
    JMP endofprogram
notanagrams:
    PRINT "strings are NOT anagrams"       ;notify user words are anagrams
endofprogram:

RET                   
                                                         
                                                         
;Define strings & arrays                                                         
inputstring1 DB inputstring1size DUP (0)   ;save 1st input here
inputstring1size = 100                     ;max size of input 1
alpha1 DB alpha1size DUP (0)               ;save alphabetic version of 1st input here
alpha1size = 100                           ;max size of alpha1
alphacountarray1 DB 26 DUP (0)             ;represent letter frequency (1) (No.A's:1st item, No.b's:2nd item etc)
inputstring2 DB inputstring2size DUP (0)   ;save 2nd input here
inputstring2size = 100                     ;max size of input 2
alpha2 DB alpha2size DUP (0)               ;save alphabetic version of 2nd input here
alpha2size = 100                           ;max size of alpha2
alphacountarray2 DB 26 DUP (0)             ;represent letter frequency (2) (No.A's:1st item, No.b's:2nd item etc)


;load in-built macros
DEFINE_GET_STRING       ;Saves string input by user into destination array indexed by DI, size is in DX
DEFINE_PRINT_STRING     ;Prints string indexed by SI
DEFINE_PRINT_NUM_UNS    ;prints digit stored in AL
  
                      
;procedure to convert string to lowercase
;address of source array must first be loaded into SI
PROC LOWERCASE_SUB
PRINT "converted to lower case: "        
looplower:                
    MOV AL, [SI]                           ;move character in array indexed by SI to AL    
    CMP AL, 0                              ;check whether we have reached end of array
    JE donelower                           ;if end of array jump to end
    CMP AL, 41h                            ;check whether character is uppercase 
    JL nxtlower                            ;if not alphabetic, next character
    CMP AL, 5Ah                            ;check whether character is uppercase
    JG nxtlower                            ;if not alphabetic of lowercase, next character
    ADD AL, 20h                            ;if uppercase and alphabetic, add 20h making it lowercase
nxtlower:        
    MOV [SI], AL                           ;store character in source array
    INC SI                                 ;change SI to next character in source array
    JMP looplower                
donelower:
RET
ENDP LOWERCASE_SUB  


;procedure to remove symbols from string
;address of source & destination arrays must first be loaded into SI & DI respectively 
PROC REMOVE_SYMBOLS_SUB    
PRINT "removed non-alphabetic characters: "        
loopsym:  
    MOV AL, [SI]                           ;move character in array indexed by SI to AL                
    CMP AL, 0                              ;check whether we have reached end of array
    JE donesym                             ;if end of array jump to end
    CMP AL, 61h                            ;check whether character is symbol
    JL nxtsym                              ;if character is symbol ignore
    CMP AL, 7Ah                            ;check whether character is symbol
    JG nxtsym                              ;if character is symbol ignore
    MOV [DI], AL                           ;if character isn't symbol, save to destination array
    INC DI                                 ;update index of destination of array for next character
nxtsym:        
    INC SI                                 ;update index of source array for next character
    JMP loopsym                            ;restart loop for next character
donesym:        
RET
ENDP REMOVE_SYMBOLS_SUB
 

;procedure to calculate the character counts
;address of source & destination arrays must first be loaded into SI & DI respectively
PROC COUNT_ALPHA_OCCURRENCES_SUB
PRINT "character counts: " 
MOV CX, 0                                  ;clear CX   
alphaconv1:      
    MOV AX, 0                              ;clear AX
    MOV AX, [SI]                           ;move number in source array indexed by SI to AX
    ADD AL, -61h                           ;subtract 61h from number to calculate index of destination array
    MOV AH, 0                              ;clear AH
    ADD DI, AX                             ;DI = destination array address + index of destination number (1:26)
    INC [DI]                               ;increase destination number by 1
    SUB DI, AX                             ;DI = destination array address ready for next number
    INC SI                                 ;update index of source array for next number
    INC CX                                 ;increase count
    CMP [SI],0                             ;check whether end of string has been reached
    JE Donealphaconv1                      ;if end of string, jump to end
    JMP alphaconv1                         ;if not end of string, run again for next number
Donealphaconv1:          
ret  
ENDP COUNT_ALPHA_OCCURRENCES_SUB  


;procedure to print out the character counts
;address of source array must first be loaded into SI
PROC PRINT_ALPHA_OCCURRENCES_SUB
     
     MOV CX, 0                             ;clear CX
     MOV AX, 0                             ;clear AX
printalphacount1:               
     MOV Al, [SI]                          ;move number in source array indexed by SI into AL
     CALL print_num_uns                    ;print number stored in AL
     INC SI                                ;update index of source array for next number
     INC CX                                ;increase count
     CMP CX, 26                            ;check if end of array reached
     JE printalphacomplete1                ;if end of array reached jump to end
     JMP printalphacount1                  ;if end of array not reached repeat for next number
printalphacomplete1:
RET
ENDP PRINT_ALPHA_OCCURRENCES_SUB

END