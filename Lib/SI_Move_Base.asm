; read keyboard, update base horizontal position if moved
move_base:
    ld bc,$FEFE             ; port for keyboard row (LHS, bottom).
    in a,(c)                ; read keyboard.
    ld d,a                  ; store result in d register.
    ld bc,$7FFE             ; port for keyboard row (RHS, bottom).
    in a,(c)                ; read keyboard.
    ld e,a                  ; store result in e register.
    rr d                    ; discard first bit (caps lock)
    rr d                    ; check second key ("Z")
    call nc,base_move_left  ; player left.
    rr d                    ; check next key ("X")
    call nc,base_move_right ; player right.
    rr e                    ; check next key ("Space")
    call nc,base_fire       ; bullet fired
    ret

base_move_left:
    ld a,(baseoffset)       ; get offset
    cp 0
    jr nz,base_move_left0   ; if offset is non-zero, decrement the offset
    ld a,(basex)            ; offset is zero, check if x position is already 2
    cp $E2
    ret z                   ; return, don't update position because can't go any further left
    dec a                   ; position is non zero so decrement
    ld (basex),a            ; store new position
    ld a,3                  ; reset offset to max
    ld (baseoffset),a       ; store new offset
    ret
base_move_left0:
    dec a                   ; decrement offset only
    ld (baseoffset),a       ; store new offset
    ret
    
base_move_right:
    ld a,(baseoffset)       ; get offset
    cp 3
    jr nz,base_move_right0  ; if offset is not 3 (the max), increment the offset
    ld a,(basex)            ; check if x position is already at the max right (27th column)
    cp $FB
    ret z                   ; return, don't update position because you can't go any further right
    inc a                   ; position isn't max so increment
    ld (basex),a            ; store new position
    xor a                   ; zeroize a
    ld (baseoffset),a       ; reset offset to zero
    ret 
base_move_right0:
    inc a                   ; increment offset only
    ld (baseoffset),a       ; store new offset
    ret

base_fire:
    ld ix,bbulletposn       ; get pointer to base bullet position
    ld a,(ix)               ; test first byte. Is it 255 (default)?
    inc a
    ret nz                  ; if no then bullet is already on screen so cannot fire again
;    ld a,$50               ; test
    ld a,$C0                ; starting point is bottom section of buffer
    ld (ix),a
    ld a,(basex)            ; get and store current basex position to use for bullet low byte
    ld (ix+1),a
    
    ld de,$400
Laserloop:
	add hl,de
	dec de
	ld a,h
    and 248
	out (#fe),a
	ld a,e
	or d
	jr nz,Laserloop
    
    ld a,(baseoffset)       ; get and store base offset at time of firing
    ld (bbulletoffset),a
    cp 0                    ; if the offset is non-zero then add 1 to x coord
    ret z
    inc (ix+1)              
    ret