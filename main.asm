		EXTRN DNUM:FAR
		EXTRN PRINTINT:FAR
stacksg segment para stack 'yigin'
		DW 525 DUP (?)
stacksg ENDS

datasg segment para 'veri'
giris1 dw 10	; stack'e atilacagindan word tanimli
giris2 dw 500
sonuc1 dw 0  ; AX'e aktarilacagindan word tanimli
sonuc2 dw 0;
datasg ENDS

codesg segment para 'kod'
		ASSUME CS:codesg, DS:datasg, SS:stacksg
ANA		PROC FAR
		PUSH DS
		XOR AX, AX
		PUSH AX
		MOV AX, datasg
		MOV DS, AX
		
		
		PUSH giris1
		CALL DNUM
		MOV sonuc1, AX	
		
		PUSH giris2
		CALL DNUM
		MOV sonuc2, AX
		
		PUSH sonuc1
		CALL PRINTINT
		
		PUSH sonuc2
		CALL PRINTINT
		RETF
ANA		ENDP
codesg	ENDS
		END ANA
		