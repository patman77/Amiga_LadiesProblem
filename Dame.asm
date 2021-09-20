; Dame.asm
; von Patrick Klie

		include	"lvo/exec.i"
		include	"lvo/dos.i"
		lea	DOSName(PC),a1
		moveq	#0,d0
		movea.l	4.w,a6
		jsr	_LVOOpenLibrary(a6)
		tst.l	d0
		beq	nolibrary
		move.l	d0,a6
		jsr	_LVOOutput(a6)
		lea	out(PC),a0
		move.l	d0,(a0)
		move.l	d0,d1
		lea	CLSText(PC),a0
		move.l	a0,d2
		moveq	#1,d3
		jsr	_LVOWrite(a6)
		lea	x(PC),a2
		lea	xxor(PC),a3
		lea	xdiagpl(PC),a4
		lea	xdiagmi(PC),a5
		move.w	#128,(a2)
gogo:
		move.w	(a2),(a3)
		move.w	#2,d7
		move.w	(a2),d0
		add.w	d0,d0
		move.w	d0,(a4)
		lsr.w	#2,d0
		move.w	d0,(a5)
whap:
		move.w	#128,(a2,d7.w)
rhap:
		move.w	-2(a3,d7.w),d0
		and.w	(a2,d7.w),d0
		bne.w	neuespalte
		move.w	-2(a4,d7.w),d0
                or.w	-2(a5,d7.w),d0
		and.w	(a2,d7.w),d0
		beq.s	neuereihe
neuespalte:
		lsr	(a2,d7.w)
		bcc.s	rhap
sk:
		subq	#2,d7
		bne.s	weiter
		lsr	(a2)
		bcc.s	gogo
		bcs.s	aus
weiter:
		lsr	(a2,d7.w)
		bcc.s	rhap
		bcs.s	sk
neuereihe:
		cmpi	#14,d7
		beq.s	treffer
		move.w	-2(a3,d7.w),d0
		or.w	(a2,d7.w),d0
		move.w	d0,(a3,d7.w)
		move.w	-2(a4,d7.w),d0
		or.w	(a2,d7.w),d0
		lsl.w	#1,d0
		move.w	d0,(a4,d7.w)
		move.w	-2(a5,d7.w),d0
		or.w	(a2,d7.w),d0
		lsr.w	#1,d0
		move.w	d0,(a5,d7.w)
		addq	#2,d7
		bra.s	whap
treffer:
		addq	#1,d5
		bsr	darstellung
		bra.s	sk
aus:
		move.l	a6,a1
		move.l	4,a6
		jsr	_LVOCloseLibrary(a6)
nolibrary:
		moveq	#0,d0
		rts
darstellung:
		movem.l	a5,-(SP)
		move.l	#7,d4
		movea.l	a2,a5
runde:
		lea	Zeile(PC),a0
		move.l	a0,d2
		move.w	(a5)+,d0
		move.l	#7,d6
nocheine:
		lsl.b	#1,d0
		bcs	zeichnen
		move.b	#"0",(a0)+
		bra	ki
zeichnen:
		move.b	#"x",(a0)+
ki:
		dbra	d6,nocheine
		lea	out(PC),a0
		move.l	(a0),d1
		move.l	#9,d3
		jsr	_LVOWrite(a6)
		dbra	d4,runde
		lea	out(PC),a0
		move.l	(a0),d1
		move.l	#16,d3
		lea	Anzahl(PC),a0
		add.b	#1,2(a0)
		cmp.b	#58,2(a0)
		bne	schreiben
		move.b	#"0",2(a0)
		add.b	#1,1(a0)
		cmp.b	#58,1(a0)
		bne	schreiben
		move.b	#"0",1(a0)
		add.b	#1,(a0)
schreiben:
		move.l	a0,d2
		jsr	_LVOWrite(a6)
		movem.l	(SP)+,a5
		rts
		even
out:		dc.l	0
DOSName:	dc.b	"dos.library",0
		even
xdiagpl:	ds.w	8
xdiagmi:	ds.w	8
xxor:		ds.w	8
x:		ds.w	8
Zeile:		ds.b	8
		dc.b	10
CLSText:	dc.b	12
Anzahl:		dc.b	"000.te Stellung",10
		END
