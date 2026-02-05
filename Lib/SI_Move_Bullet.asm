move_bullet:
    ld ix,bbulletposn       ; get current position of bullet
    ld a,(ix)         
    inc a                   ; is it 255 (default)?
    ret z                   ; if yes, then return as there is no bullet to move
	
    ld d,(ix)               ; get screen position high byte
    ld e,(ix+1)             ; get screen position low byte
	call downde_row         ; get screen position of row immediately above current
    ld (ix),d               ; otherwise, store updated screen position
    ld (ix+1),e
	
	ret
	
