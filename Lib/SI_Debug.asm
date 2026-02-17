debug:
; ; set the border to blackest of nights
; 	ld a,pBlack
; 	call 8859
; 	call 3503 ; ROM routine - clears screen, opens channel 2.

; ; set global attributes (black screen, white text)
;     ld hl,attr_start
;     push hl
;     pop de
;     inc de
;     ld bc,attributes_length
;     ld (hl),pBlack | white
;     ldir

; ***** Alien row 1 position ****
; display text
    ld de,a1_row_posn    			; address of title
    ld bc,a1_row_posn_len		    ; length of string to print        
    call 8252					; ROM routine to print string

; get alien row 1 data
    ld ix,ar1_db

; get row position (first byte)
    ld a,(ix+1)

; convert to hex
    call NumToHex   ; hex of value in A is now in BC

; display hex
    ld d,10          ; row
    ld e,10         ; column
    call display_hex

    ld d,10          ; row
    ld e,11         ; column
    ld b,c          ; value to display in B
    call display_hex

; get column position (second byte)
    ld a,(ix+2)

; convert to hex
    call NumToHex   ; hex of value in A is now in BC

; display hex
    ld d,10          ; row
    ld e,12         ; column
    call display_hex

    ld d,10          ; row
    ld e,13         ; column
    ld b,c          ; value to display in B
    call display_hex

; get alien offset
    ld a,(alienoffset)

; convert to hex
    call NumToHex   ; hex of value in A is now in BC

; display hex
    ld d,10          ; row
    ld e,15         ; column
    ld b,c          ; value to display in B
    call display_hex
; **************************


; ***** Bullet position ****
; display text
    ld de,bullet_posn    			; address of title
    ld bc,bullet_posn_len		    ; length of string to print        
    call 8252					; ROM routine to print string

; get bullet position (2 bytes)
    ld de,(bbulletposn)

; convert to hex
    ld a,e
    push de
    call NumToHex   ; hex of value in A is now in BC

; display hex
    ld d,11          ; row
    ld e,10         ; column
    call display_hex

    ld d,11          ; row
    ld e,11         ; column
    ld b,c          ; value to display in B
    call display_hex

; convert to hex
    pop de
    ld a,d
    call NumToHex   ; hex of value in A is now in BC

; display hex
    ld d,11          ; row
    ld e,12         ; column
    call display_hex

    ld d,11          ; row
    ld e,13         ; column
    ld b,c          ; value to display in B
    call display_hex

; get bullet offset
    ld a,(bbulletoffset)

; convert to hex
    call NumToHex   ; hex of value in A is now in BC

; display hex
    ld d,11          ; row
    ld e,15         ; column
    ld b,c          ; value to display in B
    call display_hex
; ************************

; ***** Base position ****
; display text
    ld de,base_posn    			; address of title
    ld bc,base_posn_len		    ; length of string to print        
    call 8252					; ROM routine to print string

; get base position
    ld a,(basex)

; convert to hex
    call NumToHex   ; hex of value in A is now in BC

; display hex
    ld d,12          ; row
    ld e,10         ; column
    call display_hex

    ld d,12          ; row
    ld e,11         ; column
    ld b,c          ; value to display in B
    call display_hex

; get base offset
    ld a,(baseoffset)

; convert to hex
    call NumToHex   ; hex of value in A is now in BC

; display hex
    ld d,12          ; row
    ld e,13         ; column
    ld b,c          ; value to display in B
    call display_hex
; ************************

; wait for key press to return
	ld hl,23560 ; LAST K system variable.
	ld (hl),0 ; put null value there.
key_wait_loop:
	ld a,(hl) ; new value of LAST K.
	cp 0 ; is it still zero?s
	jr z,key_wait_loop ; yes, so no key pressed.

; set the border to blackest of nights
	ld a,pBlack
	call 8859
	call 3503 ; ROM routine - clears screen, opens channel 2.

; set global attributes (black screen, white text)
    ld hl,attr_start
    push hl
    pop de
    inc de
    ld bc,attributes_length
    ld (hl),pBlack | white
    ldir

; restore score string
    ld de,score_string			; address of Score string        
    ld bc,score_string_len		; length of string to print        
    call 8252					; print our string 

; return to game play
    ret
;****** END debug *****************

; routine from internet to convert an 8-bit number into its corresponding ZX Spectrum ASCII code for displaying on the screen
NumToHex:
    ld d, a   ; a = number to convert
    call Num1
    ld b, a
    ld a, d
    call Num2
    ld c, a
    ret  ; return with hex number in BC
            
Num1:
    rra
    rra
    rra
    rra
Num2:        
    or $F0
    daa
    add a, $A0
    adc a, $40 ; Ascii hex at this point (0 to F)   
    ret

; print value in B at position DE (D=row,E=column)
display_hex:
    ld a,22 ; AT code.
	rst 16
	ld a,d ; vertical coord.
	rst 16 ; 
	ld a,e ; horizontal position.
	rst 16 ; 
    ld a,b ; code for printing
    rst 16
    ret




a1_row_posn
    db 22,10,0,17,0,16,7,19,0
        defm "Row 1: "
	a1_row_posn_len	equ $ - a1_row_posn

bullet_posn
    db 22,11,0,17,0,16,7,19,0
        defm "Bullet: "
	bullet_posn_len	equ $ - bullet_posn

base_posn
        db 22,12,0,17,0,16,7,19,0
        defm "Base: "
	base_posn_len	equ $ - base_posn


a2_1_row_posn
    db 22,11,0,17,0,16,7,19,0
        defm "Row 2: "
	a2_1_row_posn_len	equ $ - a2_1_row_posn

a2_2_row_posn
    db 22,12,0,17,0,16,7,19,0
        defm "Row 3: "
	a2_2_row_posn_len	equ $ - a2_2_row_posn

a3_1_row_posn
    db 22,13,0,17,0,16,7,19,0
        defm "Row 4: "
	a3_1_row_posn_len	equ $ - a3_1_row_posn

a3_2_row_posn
    db 22,14,0,17,0,16,7,19,0
        defm "Row 5: "
	a3_2_row_posn_len	equ $ - a3_2_row_posn