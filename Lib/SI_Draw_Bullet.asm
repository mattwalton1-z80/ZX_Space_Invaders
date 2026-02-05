draw_bullet:
    ld ix,bbulletposn       ; get current position of bullet
    ld a,(ix)         
    inc a                   ; is it 255 (default)?
    ret z                   ; if yes, then return as there is no bullet to draw
	
    ld d,(ix)               ; get screen position high byte
    ld e,(ix+1)             ; get screen position low byte
	
	; test whether new position is lower than $B020/$4020 (i.e. on the top row of the screen)
	xor a                   ; clear carry flag
	ld hl,$B020				; value to compare bullet position with
	;ld hl,$4020             ; value to compare bullet position with (test)
	sbc hl,de               ; subtract de from hl
	jr nc,preserve_posn		; if result is positive (i.e. no carry) then bullet must be on top row, so do not draw
	
    ld a,(bbulletoffset)    ; get base bullet offset to determine which bullet sprite to use
    cp 0
    jr z,draw_bbullet0
    cp 1
    jr z,draw_bbullet1
    cp 2
    jr z,draw_bbullet2
    cp 3
    jr z,draw_bbullet3
	
draw_bbullet0:
    ld hl,bullet_noshift
    call draw_1_char
    ret

draw_bbullet1:
    ld hl,bullet_shift2
    call draw_1_char
    ret

draw_bbullet2:
    ld hl,bullet_shift4
    call draw_1_char
    ret

draw_bbullet3:
    ld hl,bullet_shift6
    call draw_1_char
    ret

preserve_posn:
	call upde_row			; restore bullet row to last position in game screen, i.e., >= $B020 / $4020
    ld (ix),d               ; store updated screen position
    ld (ix+1),e
	ld a,1
	ld (bulletkill),a		; set bulletkill flag
	ret