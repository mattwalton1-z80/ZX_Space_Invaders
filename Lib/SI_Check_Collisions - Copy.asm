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
	; IX contains address of alien row
	ld ix,ar1_db                 ; get alien 1 database
	ld a,(ix+2)				; get low byte of starting alien row position
	and 31					; AND with 31 to get x position (0-32) only
	sla a					; multiply by 8 to get total number of pixels, i.e. shift bits left 3 times
	sla a
	sla a
	ld b,a					; store gross alien starting position

	; add pixels according to alien offset (for Alien 1 type)
	ld a,(alienoffset)
 	cp 0 
	jr z,alien1_offset_0
	cp 1 
	jr z,alien1_offset_1
	cp 2 
	jr z,alien1_offset_2
	cp 3 
	jr z,alien1_offset_3

alien1_offset_0:
	ld a,3
	jr alien1_posn_calc
alien1_offset_1:
	ld a,5
	jr alien1_posn_calc
alien1_offset_2:
	ld a,7
	jr alien1_posn_calc
alien1_offset_3:
	ld a,9

alien1_posn_calc:
	add a,b					; add gross and fine x positions
	ld d,a					; store actual alien starting position in D

	; get bullet x position: bbulletposn
	; get bullet offset: bbulletoffset
	; calculate actual lateral position
	ld ix,bbulletposn
	ld a,(ix+1)				; get low byte for bullet position
	and 31					; AND with 31 to get x position (0-32) only
	sla a					; multiply by 8 to get total number of pixels, i.e. shift bits left 3 times
	sla a
	sla a
	ld b,a					; store gross bullet x position in B

	; add pixels according to bullet offset
	ld a,(bbulletoffset)
	cp 0
	jr z,bullet_offset_0
	cp 1
	jr z,bullet_offset_1
	cp 2
	jr z,bullet_offset_2
	cp 3
	jr z,bullet_offset_3

bullet_offset_0:
	ld a,8					; add 8 pixels
	jr bullet_posn_calc
bullet_offset_1:
	ld a,10					; add 8 pixels
	jr bullet_posn_calc
bullet_offset_2:
	ld a,12					; add 8 pixels
	jr bullet_posn_calc
bullet_offset_3:
	ld a,14					; add 8 pixels
	
bullet_posn_calc:
	add a,b					; add gross and fine x positions
	ld e,a					; store actual bullet position in E 


	; Advance IX to first alien spot
	ld ix,ar1_db                 ; get alien 1 database
	ld 	bc,3
	add ix,bc

	; loop to check each alien in the row
	ld b,11

check_row_collision_loop:
	; check if alien exists
	; if not, skip to next
	; if yes, the check X coord against X position of bullet
	; if close (how to check?) then set special flag to show that alien has been hit and leave routine
	bit $00,(ix)						; test first bit of exists flag
 	jr z,check_row_collision_loop_next	; if alien doesn't exist, skip to next one
	ld a,e								; retrieve bullet position from E
	sub d								; subtract position of alien from position of bullet
	ret m								; if negative, return from check_row_collision_alien_1 as bullet is to left of alien
	jr z,alien1_hit						; if zero, alien has been hit
	sub 8								; if positive, subtract pixel width of alien to see if bullet was on target
	jp m,alien1_hit						; if result is negative, alien has been hit
										; otherwise, loop to check next alien in the row

check_row_collision_loop_next:
	inc ix								; advance IX to next alien in row
	inc ix								
 	ld a,d								; add 16 (2 chars * 8 pixels) to alien position in D to test next						
	add a,16
	ld d,a
	djnz check_row_collision_loop

	ret

alien1_hit:
	ld hl,(score)						; increase score by 10
	ld bc,10
	add hl,bc
	ld (score),hl

	ld a,(aliencount)					; decrement alien count
	dec a
	ld (aliencount),a
	
	ld a,3								; set flag on hit alien to 3 (so it explodes)				
	ld (ix),a
	
	ret