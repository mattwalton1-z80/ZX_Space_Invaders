delete_bullet:
    ld ix,bbulletposn       		; get current position of bullet
    ld a,(ix)         
    inc a                   		; is it 255 (default)?
    ret z                   		; if yes, then return as there is no bullet to draw
	
	xor a							; reset flags
	ld a,(bulletkill)				; get bullet kill flag
	rra
	jr c,cancel_bullet
	
    ld d,(ix)               		; get screen position high byte
    ld e,(ix+1)             		; get screen position low byte					
	call draw_blank_bullet_1_char
	ret
	
cancel_bullet:
	ld a,255				; reset position high byte to 255
	ld (ix),a
	xor a					
	ld (ix+1),a				; reset position low byte to 0
	ld (bulletkill),a		; reset bullet kill flag to 0
	ret

	