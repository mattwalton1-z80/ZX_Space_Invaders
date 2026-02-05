title_screen:
	; print title
	ld de,poorly_written
	ld bc,poorly_written_len
	call 8252
	ld de,title1    			; address of title
    ld bc,title1_string_len		; length of string to print        
    call 8252					; print our string 
    ld de,title2    			; address of title
    ld bc,title2_string_len		; length of string to print        
    call 8252					; print our string 
    ld de,alien_score_high
	ld bc,alien_score_high_len
	call 8252
    ld de,alien_score_med
	ld bc,alien_score_med_len
	call 8252
    ld de,alien_score_low
	ld bc,alien_score_low_len
	call 8252

alien_scroll_score_hi:
	ld hl,a1_noshift            ; use address of alien 1 graphic 
	ld de,$4860					; define starting address for alien on left
	
	xor a
	ld (alienoffset),a			; reset alien offset to 0
	
	; loop x times to move alien x places to right
	ld b,9
	
alien_scroll_score_hi_loop:
	; 0 offset
	push bc
	push hl
	push de
	call alien_scroll_draw
	pop de
	pop hl
	pop bc
	
	halt
	halt
	halt
	
	; delete from current position
	push bc
	push hl
	push de
	call draw_blank_3_char 
	pop de
	pop hl
	pop bc
	
	; advance offset
	ld a,(alienoffset)
	inc a
	ld (alienoffset),a
	
	; 1 offset
	push bc
	push hl
	push de
	call alien_scroll_draw
	pop de
	pop hl
	pop bc
	
	halt
	halt
	halt
	
	push bc
	push hl
	push de
	call draw_blank_3_char 
	pop de
	pop hl
	pop bc
	
	ld a,(alienoffset)
	inc a
	ld (alienoffset),a
	
	; 2 offset
	push bc
	push hl
	push de
	call alien_scroll_draw
	pop de
	pop hl
	pop bc
	
	halt
	halt
	halt
	
	push bc
	push hl
	push de
	call draw_blank_3_char 
	pop de
	pop hl
	pop bc
	
	ld a,(alienoffset)
	inc a
	ld (alienoffset),a
	
	; 3 offset
	push bc
	push hl
	push de
	call alien_scroll_draw
	pop de
	pop hl
	pop bc

	halt
	halt
	halt
	
	push bc
	push hl
	push de
	call draw_blank_3_char 
	pop de
	pop hl
	pop bc

	; reset alien offset
	xor a
	ld (alienoffset),a
	
	; incremement DE
	inc de
	
	djnz alien_scroll_score_hi_loop
	
	; one last draw in final position
	push hl
	push de
	call alien_scroll_draw
	pop de
	pop hl
	
alien_scroll_score_med:
	ld hl,a2_noshift            ; use address of alien 2 graphic
	ld de,$48A0					; define starting address for alien on left
	
	xor a
	ld (alienoffset),a			; reset alien offset to 0
	
	; loop x times to move alien x places to right
	ld b,9
	
alien_scroll_score_med_loop:
	; 0 offset
	push bc
	push hl
	push de
	call alien_scroll_draw
	pop de
	pop hl
	pop bc
	
	halt
	halt
	halt
	
	; delete from current position
	push bc
	push hl
	push de
	call draw_blank_3_char 
	pop de
	pop hl
	pop bc
	
	; advance offset
	ld a,(alienoffset)
	inc a
	ld (alienoffset),a
	
	; 1 offset
	push bc
	push hl
	push de
	call alien_scroll_draw
	pop de
	pop hl
	pop bc
	
	halt
	halt
	halt
	
	push bc
	push hl
	push de
	call draw_blank_3_char 
	pop de
	pop hl
	pop bc
	
	ld a,(alienoffset)
	inc a
	ld (alienoffset),a
	
	; 2 offset
	push bc
	push hl
	push de
	call alien_scroll_draw
	pop de
	pop hl
	pop bc
	
	halt
	halt
	halt
	
	push bc
	push hl
	push de
	call draw_blank_3_char 
	pop de
	pop hl
	pop bc
	
	ld a,(alienoffset)
	inc a
	ld (alienoffset),a
	
	; 3 offset
	push bc
	push hl
	push de
	call alien_scroll_draw
	pop de
	pop hl
	pop bc

	halt
	halt
	halt
	
	push bc
	push hl
	push de
	call draw_blank_3_char 
	pop de
	pop hl
	pop bc

	; reset alien offset
	xor a
	ld (alienoffset),a
	
	; incremement DE
	inc de
	
	djnz alien_scroll_score_med_loop
	
	; one last draw in final position
	push hl
	push de
	call alien_scroll_draw
	pop de
	pop hl

	
alien_scroll_score_lo:
	ld hl,a3_noshift            ; use address of alien 3 graphic
	ld de,$48E0					; define starting address for alien on left
	
	xor a
	ld (alienoffset),a			; reset alien offset to 0
	
	; loop x times to move alien x places to right
	ld b,9
	
alien_scroll_score_lo_loop:
	; 0 offset
	push bc
	push hl
	push de
	call alien_scroll_draw
	pop de
	pop hl
	pop bc
	
	halt
	halt
	halt
	
	; delete from current position
	push bc
	push hl
	push de
	call draw_blank_3_char 
	pop de
	pop hl
	pop bc
	
	; advance offset
	ld a,(alienoffset)
	inc a
	ld (alienoffset),a
	
	; 1 offset
	push bc
	push hl
	push de
	call alien_scroll_draw
	pop de
	pop hl
	pop bc
	
	halt
	halt
	halt
	
	push bc
	push hl
	push de
	call draw_blank_3_char 
	pop de
	pop hl
	pop bc
	
	ld a,(alienoffset)
	inc a
	ld (alienoffset),a
	
	; 2 offset
	push bc
	push hl
	push de
	call alien_scroll_draw
	pop de
	pop hl
	pop bc
	
	halt
	halt
	halt
	
	push bc
	push hl
	push de
	call draw_blank_3_char 
	pop de
	pop hl
	pop bc
	
	ld a,(alienoffset)
	inc a
	ld (alienoffset),a
	
	; 3 offset
	push bc
	push hl
	push de
	call alien_scroll_draw
	pop de
	pop hl
	pop bc

	halt
	halt
	halt
	
	push bc
	push hl
	push de
	call draw_blank_3_char 
	pop de
	pop hl
	pop bc

	; reset alien offset
	xor a
	ld (alienoffset),a
	
	; incremement DE
	inc de
	
	djnz alien_scroll_score_lo_loop
	
	; one last draw in final position
	push hl
	push de
	call alien_scroll_draw
	pop de
	pop hl

	; reset alien offset
	xor a
	ld (alienoffset),a 

	; start string
	ld de,start_string    		; address of title
    ld bc,start_string_len		; length of string to print        
    call 8252					; print our string 


; ***** start scrolling ****
scroll:
	halt				; slow the scroll a bit
    ld b,8              ; pixel line counter
    ld hl,$505F         ; set HL initially as last character on row

row_loop:
	dec b               ; decrement pixel line counter
    push bc             ; and store it

	ld bc,$FDFE 		; port for keyboard row (LHS, second from bottom).
    in a,(c) 			; read keyboard.
    ld d,a 				; store result in d register.
	rr d 				; right rotate the bits in d twice
	rr d 				
	jr nc,exit_intro_screen ; if Carry flag not set then S is being pressed so exit

scroll_loop:
    ld b,31             ; set counter to 31
    sla (hl)            ; shift bits left starting from right-most character
scroll_line:
    dec hl              ; decrement HL, i.e. move to next left character
    jr nc,no_carry      ; if previous bit shift did not set the Carry flag, jump
    sla (hl)            ; shift bits left in current character
    set 0,(hl)          ; since Carry flag was set from previous bit rotation, set the first bit in current char
    jr end_scroll_line
no_carry:
    sla (hl)            ; shift bits left in current character, no carry from previous bit rotation
end_scroll_line:
    djnz scroll_line

    jr nc,no_scroll_carry ; once we have got to the first character, we need to check if the rotated bit needs to go back round             
    ld de,$1F
    add hl,de
    set 0,(hl)
    jr next_line

no_scroll_carry:
    ld de,$1F
    add hl,de

next_line:
    pop bc              ; get pixel line counter
    ld a,b
    cp 0                ; if 0 then start all over again
    jr z,scroll

    call uphl           ; get next pixel line down
    jr row_loop
; *********************

exit_intro_screen:
	pop	bc				; restore BC before leaving

; clear screen
;    ld a,pBlack
;    call 8859
;	call 3503 ; ROM routine - clears screen, opens chan 2.

	call page_fade

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

	ret
	
alien_scroll_draw:
    ld a,(alienoffset)   ; retrieve alien offset
    cp 0
    jr z,intro_alien0
    cp 1
    jr z,intro_alien1
    cp 2
    jr z,intro_alien2
    cp 3
    jr z,intro_alien3

intro_alien0:
	call draw_3_char
	ret
	
intro_alien1:
    ld bc,24            ; advance hl to first shifted sprite
    add hl,bc
    call draw_3_char
	ret
	
intro_alien2:
    ld bc,48            ; advance hl to second shifted sprite
    add hl,bc
    call draw_3_char
	ret
	
intro_alien3:
    ld bc,72            ; advance hl to last shifted sprite
    add hl,bc
    call draw_3_char
	ret

uphl:
    inc h       ; increment higher order byte
    ld a,h      ; test to see if we're at the 8th byte row in the character
    and 7       ; mask everything but first 3 bits, leaves the *last* 3 bytes of the y coord yte row)
    ret nz      ; if result is zero then we have passed the bottom of the char
                ; now test to see if we're at the 8th byte row at the bottom of the 8 row group
    ld a,l      ; isolate lower order byte
    add a,$20    ; if last 3 bits of e are 111 then adding 32 will cause a carry
    ld l,a      ; ld result back into e
    ret c       ; if there was a carry then de has been set to top of next group of 8 rows
                ; if no carry then we're still in the same group of 8 rows
    ld a,h      ; get higher order byte
    sub 8       ; subtract 8 to roll back any carry over
    ld h,a
    ret

wait_for_key_press:
	ld hl,23560 ; LAST K system variable.
	ld (hl),0 ; put null value there.
loop:
	ld a,(hl) ; new value of LAST K.
	cp 0 ; is it still zero?s
	jr z,loop ; yes, so no key pressed.
	ret
	
page_fade:
ld hl,$4000

page_loop:
	ld b,3

page_loop0:
	push hl
	push bc

section_loop:
	ld b,8                                                                                                                                                                                                                     

section_loop0:
	push hl
	push bc

	char_row_loop:
		ld b,8
		
	char_row_loop0:
		push hl
		push bc
		bit $00,b
		jr z,pixel_row_loop
		halt
		
		pixel_row_loop:
			ld b,$20

		pixel_row_loop0:
			ld (hl),$00
			inc hl
			djnz pixel_row_loop0

		pop bc
		pop hl
		inc h
		djnz char_row_loop0

	pop bc
	pop hl
	ld a,l
	add a,$20
	ld l,a
	djnz section_loop0
	                                                                                       
	pop bc
	pop hl
	ld a,h
	add a,$08
	ld h,a
	djnz page_loop0
	ret