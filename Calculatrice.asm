				org $4
Vector_001 		dc.l Main
				org $500
Main 			movea.l	#STREXAMPLE,a0
				jsr		StrLen
				illegal
				
; StrLen a0 -> d0
StrLen			move.l a0,-(a7)
				clr.l	d0
\loop			tst.b	(a0)+
				beq		\exit
				addq.l	#1,d0
				jmp		\loop
\exit			move.l	(a7)+,a0
				rts

; Atoiui a0 -> d0
Atoiui			movem.l	d1/a0,-(a7)
				clr.l	d0
				clr.l	d1
\loop			move.b	(a0)+,d1
				beq		\quit
				subi.b	#'0',d1
				mulu.w	#10,d0
				add.l	d1,d0
				bra		\loop
\quit			movem.l	(a7)+,d1/a0
				rts

RemoveSpace		movem.l d0/a0/a1,-(a7)
				movea.l a0,a1
\loop			move.b 	(a0)+,d0
				cmpi.b 	#' ',d0
				beq 	\loop
				move.b 	d0,(a1)+
				bne 	\loop
\quit 			movem.l (a7)+,d0/a0/a1
				rts

; IsCharError a0 -> Z=1 si erreur
IsCharError		movem.l d0/a0,-(a7)
\loop			move.b (a0)+,d0
				beq \false
				cmpi.b #'0',d0
				blo \true
				cmpi.b #'9',d0
				bls \loop
\true			ori.b #%00000100,ccr
				bra \quit
\false			andi.b #%11111011,ccr
\quit			movem.l (a7)+,d0/a0
				rts

; IsMaxError a0 -> Z=1 si erreur
IsMaxError		movem.l d0/a0,-(a7)
				jsr 	StrLen
				cmpi.l 	#5,d0
				bhi 	\true
				blo 	\false
				cmpi.b #'3',(a0)+
				bhi \true
				blo \false
				cmpi.b #'2',(a0)+
				bhi \true
				blo \false
				cmpi.b #'7',(a0)+
				bhi \true
				blo \false
				cmpi.b #'6',(a0)+
				bhi \true
				blo \false
				cmpi.b #'7',(a0)
				bhi \true
\false 			andi.b #%11111011,ccr
				bra \quit
\true 			ori.b #%00000100,ccr
\quit			movem.l (a7)+,d0/a0
				rts
				
Convert			jsr		RemoveSpace
				jsr		IsCharError
				beq		\err
				jsr		IsMaxError
				beq		\err
				jsr		Atoui
				
				
STREXAMPLE		dc.b "Hello World!",0
