check_bullet_collision:
	ld ix,bbulletposn       ; get current position of bullet
	ld a,(ix)         
    inc a                   ; is it 255 (default)?
    ret z                   ; if yes, then return as there is no bullet to move
	ld h,(ix)               ; otherwise, get screen position high byte
    ld l,(ix+1)             ; get screen position low byte
	
	; get bottom row of aliens
	; check if row exists
check_alien_row_bottom:
    ld ix,ar1_db                 ; get alien 1 database
    bit $00,(ix)				; test first bit of exists flag
	jr z,check_alien_row_second_from_bottom	; if row doesn't exist (Z flag is set when bit tested is zero), skip to next row
	
	; if it does, get alien position
	ld 	a,(ix+1)				; get high byte of alien position
	and $F8						; mask first 3 bits of high byte so position resets to top pixel line in the row
	ld 	d,a
	ld 	a,(ix+2)				; get low byte of alien position
	and $E0						; make first 5 bits of low byte so position resets to beginning of row
	ld 	e,a
	call upde_row				; return the address in DE of the next screen row directly below
					
	; prep bullet position
	ld 	a,l						; make first 5 bits 0 so bullet position resets to beginning of row
	and $E0
	ld 	l,a
	
	; now compare - if HL & DE are equal then we're on the same row so can check individual aliens
	xor a								; reset carry flag (don't want it for SBC calc)
	sbc	hl,de							; subtract DE from HL
	jr z,check_row_collision_alien_1	; if they're the same value then jump to checking individual aliens
										; otherwise, check next alien row
	
	
check_alien_row_second_from_bottom:
	; get second from bottom row of aliens
	; check if row exists
	; if so, check if alien Y position is close to that of bullet Y position
	; set IX to alien row, jump to individual check
	
	; get middle row of aliens
	; check if row exists
	; if so, check if alien Y position is close to that of bullet Y position
	; set IX to alien row, jump to individual check
	
	; get second from top row of aliens
	; check if row exists
	; if so, check if alien Y position is close to that of bullet Y position
	; set IX to alien row, jump to individual check
	
	; get top row of aliens
	; check if row exists
	; if so, check if alien Y position is close to that of bullet Y position
	; set IX to alien row, jump to individual check
	
	ret
	
check_row_collision_alien_1:


	ret

alien1_hit:
	ld hl,(score)						; increase score by 30 points
	ld bc,30
	add hl,bc
	ld (score),hl

	ld a,(aliencount)					; decrement alien count
	dec a
	ld (aliencount),a
	
	ld a,3								; set flag on hit alien to 3 (so it explodes)				
	ld (ix),a
	
	ret