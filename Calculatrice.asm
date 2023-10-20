				org $0
vector_000		dc.l $ffb500
vector_001 		dc.l Main
				org $500
Main 			lea		STREXAMPLE,a0
				move.b	#24,d1
				move.b	#20,d2
				jsr		Print
				illegal

; PrintChar d0.b d1.b d2.b -> void
; Print d0.b at X=d1.b and Y=d2.b 
PrintChar 		incbin "PrintChar.bin"

; StrLen a0 -> d0.l
StrLen			move.l a0,-(a7)
				clr.l	d0
\loop			tst.b	(a0)+
				beq		\exit
				addq.l	#1,d0
				jmp		\loop
\exit			move.l	(a7)+,a0
				rts

; Atoiui a0 -> d0.l
Atoui			movem.l	d1/a0,-(a7)
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

; Convert a0 -> d0.l			
Convert			jsr		RemoveSpace
				jsr		IsCharError
				beq		\err
				jsr		IsMaxError
				beq		\err
				jsr		Atoui
				ori.b	#%00000100,ccr
				rts
				
\err			andi.b	#%11111011,ccr

Print			movem.l	a0/d0/d1,-(a7)
\loop			move.b	(a0)+,d0
				beq		\exit
				jsr 	PrintChar
				addq.b	#1,d1
				jmp		\loop
\exit			movem.l	(a7)+,a0/d0/d1
				rts
				
;NextOp a0.l -> a0.l
NextOp			tst.b	(a0)
				beq		\exit
				cmpi.b	#'+',(a0)
				beq		\exit
				cmpi.b	#'-',(a0)
				beq		\exit
				cmpi.b	#'*',(a0)
				beq		\exit
				cmpi.b	#'/',(a0)
				beq		\exit
				addq.l	#1,a0
				jmp		NextOp
\exit			rts
				
				
STREXAMPLE		dc.b "LETZ PLAY SPAZE INVADERZ",0
