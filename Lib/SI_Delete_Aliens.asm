; *** Delete Aliens ***
; routines to delete aliens in a row if they exist

; determine which row of aliens to delete
delete_aliens:
    jr delete_aliens_row1       ; delete row1 

; delete row 1 of aliens
delete_aliens_row1:
    ld ix,ar1_db                 ; get alien 1 database
    bit $00,(ix)                ; test if row exists
    ret z                       ; return immediately if row doesn't exist
    call delete_aliens_row      ; otherwise, delete current positions of aliens
    ret

; generic routine to delete a row of aliens
delete_aliens_row:
    ld d,(ix+1)         ; get y position - high bit
    ld e,(ix+2)         ; - low bit
    ld bc,3             ; set ix to start of individual aliens
    add ix,bc
    ld b,11             ; loop through 11 aliens per row
delete_aliens_loop:
    push de             ; store y position
    push bc             ; store count
    xor a                ; reset carry flag
    ld a,(ix)           ; test if alien exists
    rra                 ; rotate low bit into carry
    call c,delete_single_alien  ; if there's a carry then alien exists, so delete individual
    ld de,2             ; advance to next alien in row
    add ix,de
    pop bc              ; restore count
    pop de              ; restore y position
    djnz delete_aliens_loop
    ret

; generic routine to delete a single alien
delete_single_alien:
    ld a,(ix+1)         ; get x position
    add a,e             ; get location to draw - add x coord (a) to lower byte of y coord (de)
    ld e,a
    call draw_blank_3_char
    ret
; ***************