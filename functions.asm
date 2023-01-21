		PUBLIC DNUM
		PUBLIC PRINTINT
codes segment para 'yordam'
		ASSUME CS:codes
DNUM	PROC FAR
		
		push BP
		push CX
		push SI
		push BX
		push DI
		push DX
		
		XOR AX,AX ; D(0), D(1) ve D(2) degerlerinin stacke atilmasi
		push AX
		MOV AX,1
		push AX
		push AX
		
		MOV BP,SP
		CMP [BP + 22], WORD PTR 0 ;0,1 ve 2 degerlerinin sonuclar halihazirda bilindiginden giris bunlardan biriyse direkt degeri gonder
		JNE L1
		MOV AX, 0
		JMP SON
L1:		CMP [BP + 22], WORD PTR 1 
		JNE L2
		MOV AX, 1
		JMP SON
L2:		CMP [BP + 22], WORD PTR 2 
		JNE L3
		MOV AX, 1
		JMP SON
		
		
L3:		MOV CX, [BP + 22] ; CX degerine giris degeri stack'ten aktarildi
		MOV DX, CX ; stack'i bosaltirken tekrar giris degerine ihtiyac duyacagiz fakat CX loop sonunda sifirlanacagindan giris degerini bir de DX'de sakladim
		
		SUB CX, 2  ; Giris degerinin 2 eksigi kadar donecek. Ornegin girdi olarak 5 girildeyse once D(3) ve D(4)'u daha sonra D(5)'i bulması gerektiginden 3 kere donecek
		ADD BP, 4  ;BX'e D(0)'in stack adresini atadim. Boylece ornegin D(1)'i gostermek istedigimde [BX-2], D(13)'u gostermek istedigimde [BX-26] seklinde daha kolay gosterebilirim
		MOV SI, 6 ; hesaplamaya D(3)'ten baslayacagi ve stack word olarak tanimlandigindan 6 degeri verildi
		
L4:		SUB BP,SI ; D(n)'in secilmesi
		MOV DI, [BP+2] ; DI' ya bulunmasi gerekenden bir onceki degerin yani D(n-1)'in atanmasi
		ADD BP, SI  ; BP tekrardan D(0)'da
		SHL DI,1 ; word oldugundan 2 ile carpilmasi gerek
		SUB BP, DI ; BP D(D(n-1))'i gosteriyor
		MOV AX, [BP] ; D(D(n-1)) kisminin bulunup AX'e atanmasi
		ADD BP, DI ; BP tekrardan D(0)'da
		
		SUB BP,SI ; D(n)'in secilmesi
		MOV DI, [BP+4] ; D(n-2) degerinin DI'ya atanmasi
		ADD BP,SI ; BP tekrardan D(0)'da
		SHL DI,1  ; word oldugundan 2 ile carpilmasi gerek
		SUB BP,SI ; D(n)'in secilmesi
		ADD BP,DI ; BP'nin D(D(n-2))'yi gosterecek sekilde ayarlanmasi
		ADD AX, [BP+2] ; D(n-1-D(n-2)) degerinin bulunup AX'in icerisindeki D(D(n-1)) ile toplanması
		ADD BP,SI
		SUB BP,DI ; BP tekrardan D(0)'da
		PUSH AX ; bulunan degerin stacke aktarilmasi
		ADD SI,2 ; bir sonraki degere gecilmesi
		LOOP L4
		
SON:	MOV CX,DX ; stacki bosaltmak icin giris degerini CX'e atama
		INC CX ; D(0) degeri de olacagindan giris+1 kere bosaltilacak
L5:		POP BX
		LOOP L5
		
		POP DX
		POP DI
		POP BX
		POP SI
		POP CX
		POP BP
		
		RETF 2 ;giris degerini de temizlemek icin 2 yazildi
DNUM	ENDP

PRINTINT PROC FAR
		
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX
		
		MOV BP,SP
		MOV AX,[BP + 12] ; AX'e sonucu ata
		MOV BX,10  ; 10'a bolunecek
		XOR CX,CX  ; kac kere dondugu
		XOR DX,DX   ; sonuc olusacak
		
		CMP AX,0  ; 0 ise gereksiz yere POP yapacagindan direkt yazdir ve bitir
		JNE L7
		XOR DX,DX
		ADD DX, 48
		MOV AH,2
		INT 21H
		JMP atla
		
L7:		CMP AX,0 ; sonuc 0 degil ise 10'a bol, kalani stack'e at
		JE L6
		DIV BX
		PUSH DX
		XOR DX,DX
		INC CX
		JMP L7
		
		
L6:		POP DX  ; stackteki degerleri teker teker yazdir
		ADD DX, 48
		MOV AH,2
		INT 21H
		LOOP L6
		
		MOV DX, ' ' ; yazdirdiktan sonra bosluk biraksin	
		MOV AH,2
		INT 21H
		
		POP DX
		POP CX
		POP BX
		POP AX
		
atla:	RETF 2
PRINTINT ENDP
codes	 ENDS
		 END