; *** Draw Aliens ***
; Routines for drawing Aliens

; determine which row of aliens to draw
draw_aliens:
    jr draw_aliens_row1         ; draw first row of aliens

; draw row 1 of aliens
draw_aliens_row1:
    ld ix,ar1_db                 ; get alien 1 database
    bit $00,(ix)                ; test if row exists
    ret z                       ; return immediately if row doesn't exist (Z flag is set when bit tested is zero)
    ld hl,a1_noshift            ; use address of alien 1 graphic 
    call draw_aliens_row        ; top row
    ret

; generic routine to draw a row of aliense
draw_aliens_row:
    ld d,(ix+1)         ; get y position - high bit
    ld e,(ix+2)         ; - low bit
    ld bc,3             ; set ix to start of individual aliens
    add ix,bc
    ld b,11             ; loop through 11 aliens per row
draw_aliens_loop:
    push de             ; store y position
    push bc             ; store count
    push hl             ; store sprite address
    xor a               ; reset carry flag
    ld a,(ix)           ; test if alien exists
    rra                 ; rotate low bit into carry
    call c,draw_single_alien   ; if there's a carry then alien exists, so draw individual
    ld de,2             ; advance to next alien in row
    add ix,de
    pop hl              ; restore sprite address
    pop bc              ; restore count
    pop de              ; restore y position
    djnz draw_aliens_loop
    ret

; generic routine to draw a single alien, based on the provided offset
draw_single_alien:
	rra							; check alien exists flag to see if it has just been hit (i.e. flag was set to 00000011 = 3)
	jr nc,draw_single_alien0	; if there is no carry then alien has not been hit so carry on with regular alien image
	ld hl,abang_noshift			; replace hl with alien hit sprite (will be reset in above loop with pop hl)
	xor a						; set a to 0
	ld (ix),a					; set alien display flag to off
								; also need to kill bullet
	
draw_single_alien0:
    ld a,(ix+1)         ; get x position
    add a,e             ; get location to draw - add x coord (a) to lower byte of y coord (de)
    ld e,a
    ld a,(alienoffset)   ; retrieve alien offset
    cp 0
    jr z,draw_alien0
    cp 1
    jr z,draw_alien1
    cp 2
    jr z,draw_alien2
    cp 3
    jr z,draw_alien3

; draw alien with no offset/shift
draw_alien0:
    call draw_3_char
    ret

; draw alien with at first offset
draw_alien1:
    ld bc,24            ; advance hl to first shifted sprite
    add hl,bc
    call draw_3_char
    ret

; draw alien with at second offset
draw_alien2:
    ld bc,48            ; advance hl to second shifted sprite
    add hl,bc
    call draw_3_char
    ret

; draw alien with at third offset
draw_alien3:
    ld bc,72            ; advance hl to last shifted sprite
    add hl,bc
    call draw_3_char
    ret

; ***************