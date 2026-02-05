buf2screen:
    di              ; disable interrupts

;alien_copy:
    ; check for existence of each row before copying
    ld ix,a1_db               ; get alien 1 (only row) database
    or a                        ; reset carry flag
    ld a,(ix)                   ; test if row exists
    rra                         ; rotate low bit into carry
;    jr nc,alien_copy2           ; if row doesn't exist, skip to next row
    jp nc,copy_done             ; if row doesn't exist, skip to end of routine
    ; row exists
    ld d,(ix+1)                 ; get y coords for row (high byte)
    ld a,(ix+2)                 ; (low byte)
    and $E0                     ; mask to get in range 32-256, i.e. make first 5 bits 0
    add a,$02                   ; add 2 to get to lh margin of playable screen
    ld e,a
    call downde                 ; call downde twice to move DE two pixel rows above
    call downde
    ld (buffer_posn),de         ; define base location as starting position for buffer copy
    ld a,d                      ; get high byte of y buffer address
    sub $70                     ; subtract $70 (112) to get corresponding screen position
    ld d,a                      ; put result back into high byte of hl
    ld a,e
    add a,$0E
    ld e,a                      ; add 14 to a to get to mid-position of screen (ie 16 chars in)
    ld (screen_posn),de
    call copy_loop_aliens

; alien_copy2:
;     ; check for existence of each row before copying
;     ld ix,a2_1_db               ; get alien 2 (first row) database
;     or a                        ; reset carry flag
;     ld a,(ix)                   ; test if row exists
;     rra                         ; rotate low bit into carry
;     jr nc,alien_copy3           ; if row doesn't exist, skip to next row
;     ; row exists
;     ld h,(ix+1)                 ; get y coords for row (high byte)
;     ld a,(ix+2)                 ; (low byte)
;     add a,$2                    ; add 2 to get to lh margin of playable screen
;     ld l,a
;     ld (buffer_posn),hl         ; define base location as starting position for buffer copy
;     ld a,h                      ; get high byte of y buffer address
;     sub $70                     ; subtract $70 (112) to get corresponding screen position
;     ld h,a                      ; put result back into high byte of hl
;     ld a,l
;     add a,$E
;     ld l,a                      ; add 14 to a to get to mid-position of screen (ie 16 chars in)
;     ld (screen_posn),hl
;     call copy_loop

; alien_copy3:
;     ; check for existence of each row before copying
;     ld ix,a2_2_db               ; get alien 2 (second row) database
;     or a                        ; reset carry flag
;     ld a,(ix)                   ; test if row exists
;     rra                         ; rotate low bit into carry
;     jr nc,alien_copy4           ; if row doesn't exist, skip to next row
;     ; row exists
;     ld h,(ix+1)                 ; get y coords for row (high byte)
;     ld a,(ix+2)                 ; (low byte)
;     add a,$2                    ; add 2 to get to lh margin of playable screen
;     ld l,a
;     ld (buffer_posn),hl         ; define base location as starting position for buffer copy
;     ld a,h                      ; get high byte of y buffer address
;     sub $70                     ; subtract $70 (112) to get corresponding screen position
;     ld h,a                      ; put result back into high byte of hl
;     ld a,l
;     add a,$E
;     ld l,a                      ; add 14 to a to get to mid-position of screen (ie 16 chars in)
;     ld (screen_posn),hl
;     call copy_loop

; alien_copy4:
;     ; check for existence of each row before copying
;     ld ix,a3_1_db               ; get alien 3 (first row) database
;     or a                        ; reset carry flag
;     ld a,(ix)                   ; test if row exists
;     rra                         ; rotate low bit into carry
;     jr nc,alien_copy5           ; if row doesn't exist, skip to next row
;     ; row exists
;     ld h,(ix+1)                 ; get y coords for row (high byte)
;     ld a,(ix+2)                 ; (low byte)
;     add a,$2                    ; add 2 to get to lh margin of playable screen
;     ld l,a
;     ld (buffer_posn),hl         ; define base location as starting position for buffer copy
;     ld a,h                      ; get high byte of y buffer address
;     sub $70                     ; subtract $70 (112) to get corresponding screen position
;     ld h,a                      ; put result back into high byte of hl
;     ld a,l
;     add a,$E
;     ld l,a                      ; add 14 to a to get to mid-position of screen (ie 16 chars in)
;     ld (screen_posn),hl
;     call copy_loop

; alien_copy5:
;     ; check for existence of each row before copying
;     ld ix,a3_2_db               ; get alien 3 (second row) database
;     or a                        ; reset carry flag
;     ld a,(ix)                   ; test if row exists
;     rra                         ; rotate low bit into carry
;     jr nc,base_copy             ; if row doesn't exist, skip to base
;     ; row exists
;     ld h,(ix+1)                 ; get y coords for row (high byte)
;     ld a,(ix+2)                 ; (low byte)
;     add a,$2                    ; add 2 to get to lh margin of playable screen
;     ld l,a
;     ld (buffer_posn),hl         ; define base location as starting position for buffer copy
;     ld a,h                      ; get high byte of y buffer address
;     sub $70                     ; subtract $70 (112) to get corresponding screen position
;     ld h,a                      ; put result back into high byte of hl
;     ld a,l
;     add a,$E
;     ld l,a                      ; add 14 to a to get to mid-position of screen (ie 16 chars in)
;     ld (screen_posn),hl
;     call copy_loop

base_copy:
    ld de,$C0E2                 ; base is always on bottom row (high byte) of screen buffer
    ld (buffer_posn),de         ; define base location as starting position for buffer copy
    ld de,$50F0                 ; base is always on bottom row (high byte) of screen buffer
    ld (screen_posn),de
    call copy_loop

bbullet_copy:
     xor a               		; reset a
     ld ix,bbulletposn   		; get current base bullet position in buffer
     ld a,(ix)
     inc a               		; is it 255 (default)?
     jp z,copy_done      		; if no bullet to copy then skip to end
     ld d,(ix)           		; load high byte of buffer address
     ld e,(ix+1)         		; load low byte of buffer address
	 ; call downde_row			; get starting position one row above current (to delete what was already copied to screen buffer)		
     ld (buffer_posn),de 		; store buffer address
     ld a,d                     ; get high byte of y buffer address
     sub $70                    ; subtract $70 (112) to get corresponding screen position
     ld d,a                     ; put result back into high byte of hl
     ld (screen_posn),de
bbullet_copy_loop:
     ld a,16                      ; 2 x 8 rows of bytes to be copied (current row and one beneath it, to make sure you copy over the deleted previous position)
     ld (rowloopctr),a
bbullet_copy_loop0:
     ld a,(rowloopctr)
     dec a
     ld (rowloopctr),a
     ld de,(buffer_posn)         ; get byte at buffer position
     ld a,(de)
     push af                     ; store byte
     call upde                   ; advance buffer position to next byte row down
     ld (buffer_posn),de
     pop af                      ; recover byte
     ld de,(screen_posn)         ; insert byte at screen position
     ld (de),a
     call upde                   ; advance buffer position to next byte row down
     ld (screen_posn),de
     ld a,(rowloopctr)
     cp 0
     jp nz,bbullet_copy_loop0
	 
copy_done:
    ; done, return
    ei                          ; reenable interrupts
    ret


copy_loop_aliens:
    ld (stptr),sp               ; store stack pointer
    ld a,10                     ; 8+2 rows of bytes to be copied (for aliens with 2 pixels above)
    ld (rowloopctr),a
    jr copy_loop0

copy_loop:
    ld (stptr),sp               ; store stack pointer
    ld a,8                      ; 8 rows of bytes to be copied
    ld (rowloopctr),a
    jr copy_loop0

copy_loop0:
    ld a,(rowloopctr)
    dec a
    ld (rowloopctr),a

    ld sp,(buffer_posn) ; read 14 bytes from the double buffer going backwards into 3 register pairs
    pop af
    pop bc
    pop de
    pop hl
    exx
    pop bc
    pop de
    pop hl
    ld sp,(screen_posn) ; read same 14 bytes back into the screen buffer
    push hl
    push de
    push bc
    exx
    push hl
    push de
    push bc
    push af

    ld bc,$0E            ; advance buffer pointer along by 14 chars to the end of the usable row
    ld hl,(buffer_posn)
    add hl,bc
    ld (buffer_posn),hl
    ld hl,(screen_posn)
    add hl,bc
    ld (screen_posn),hl

    ld sp,(buffer_posn) ; read 14 bytes from the double buffer going backwards into 3 register pairs
    pop af
    pop bc
    pop de
    pop hl
    exx
    pop bc
    pop de
    pop hl
    ld sp,(screen_posn) ; read same 14 bytes back into the screen buffer
    push hl
    push de
    push bc
    exx
    push hl
    push de
    push bc
    push af

    ld a,(rowloopctr)
    cp 0
    jr z,copy_loop_end      ; if loop counter is zero then end

    ; move buffer and screen positions down to the next pixel row and reset for next loop
    ld sp,(stptr)           ; restore stack pointer.
    ld de,(buffer_posn)     ; get buffer position in DE
    call upde               ; get next pixel row 
    ex de,hl                ; swap DE & HL (can't do 16-bit subtraction in DE)
    ld bc,$0E               ; set BC to 14
    xor a                   ; reset Carry flag (otherwise carry bit will be subtracted from next operation)
    sbc hl,bc               ; subtract 14 from buffer position to take it back to start of row
    ld (buffer_posn),hl     ; store buffer position

    ld de,(screen_posn)     ; get screen position in DE
    call upde               ; get next pixel row
    ex de,hl                ; swap DE & HL (can't do 16-bit subtraction in DE)
    ld bc,$0E               ; set BC to 14
    xor a                   ; reset Carry flag (otherwise carry bit will be subtracted from next operation)
    sbc hl,bc               ; subtract 14 from screen position to take it back to middle of row
    ld (screen_posn),hl     ; store screen position
    
    jr copy_loop0

copy_loop_end:
    ld sp,(stptr)   ; restore stack pointer.
    ret