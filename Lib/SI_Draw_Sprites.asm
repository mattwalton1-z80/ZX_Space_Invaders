; *** Draw Sprites ***
; Routines for drawing sprites

; routine for drawing single character wide sprites (hl points to sprite address)
draw_1_char:
    ld b,8              ; repeat for 8 lines
draw_1_char0:
    push de             ; store coord location
    ld a,(hl)           ; first character width - get new byte to display
    ex de,hl            ; temp swap of de,hl values
    ld c,(hl)           ; load current byte in display
    or c                ; combine new byte with current byte
    ex de,hl            ; swap de,hl values back
    ld (de),a           ; load combined bytes into display
    pop de
    push hl
    call upde
    pop hl
    inc hl
    djnz draw_1_char0
    ret

; routine for drawing 2-char wide sprites (hl points to sprite address)
draw_2_char:
    ld b,8              ; repeat for 8 lines
draw_2_char0:
    push de
    ld a,(hl)
    ld (de),a
    inc hl
    inc de
    ld a,(hl)
    ld (de),a
    pop de
    push hl
    call upde
    pop hl
    inc hl
    djnz draw_2_char0
    ret

; routine for drawing 3-char wide sprites (hl points to sprite address)
draw_3_char:
    ld b,8              ; repeat for 8 lines
draw_3_char0:
    push de             ; store coord location
    ld a,(hl)           ; first character width - get new byte to display
    ex de,hl            ; temp swap of de,hl values
    ld c,(hl)           ; load current byte in display
    or c                ; combine new byte with current byte
    ex de,hl            ; swap de,hl values back
    ld (de),a           ; load combined bytes into display           
    inc hl
    inc de
    ld a,(hl)           ; second character width
    ld (de),a
    inc hl
    inc de
    ld a,(hl)           ; third character width
    ld (de),a
    pop de
    push hl
    call upde
    pop hl
    inc hl
    djnz draw_3_char0
    ret

draw_blank_bullet_1_char:
    ld b,8              				; repeat 8 pixel lines
    ld a,(bbulletoffset)				; get bullet offset
    cp 0
    jr z,draw_blank_bullet_1_char0
    cp 1
    jr z,draw_blank_bullet_1_char1
    cp 2
    jr z,draw_blank_bullet_1_char2
    cp 3
    jr z,draw_blank_bullet_1_char3

draw_blank_bullet_1_char0:
    push de             ; store coord location
    ld a,(de)           ; load byte of existing display at de
    res 0,a             ; set lowest bit to 0 (this should erase the bullet in this offset)
    ld (de),a           ; load byte into display     
    pop de
    call upde
    djnz draw_blank_bullet_1_char0
    ret

draw_blank_bullet_1_char1:
    push de             ; store coord location
    ld a,(de)           ; load byte of existing display at de
    res 6,a             ; set lowest bit to 0 (this should erase the bullet in this offset)
    ld (de),a           ; load byte into display     
    pop de
    call upde
    djnz draw_blank_bullet_1_char1
    ret

draw_blank_bullet_1_char2:
    push de             ; store coord location
    ld a,(de)           ; load byte of existing display at de
    res 4,a             ; set lowest bit to 0 (this should erase the bullet in this offset)
    ld (de),a           ; load byte into display     
    pop de
    call upde
    djnz draw_blank_bullet_1_char2
    ret

draw_blank_bullet_1_char3:
    push de             ; store coord location
    ld a,(de)           ; load byte of existing display at de
    res 2,a             ; set lowest bit to 0 (this should erase the bullet in this offset)
    ld (de),a           ; load byte into display     
    pop de
    call upde
    djnz draw_blank_bullet_1_char3
    ret

; delete 1 char-wide space
draw_blank_1_char:
    ld b,8              ; repeat for 8 lines
draw_blank_1_char0:
    ld a,0
    ld (de),a
    call upde    
    djnz draw_blank_1_char0
    ret

; delete 2 char-wide space
draw_blank_2_char:
    ld b,8              ; repeat for 8 lines
draw_blank_2_char0:
    push de
    ld a,0
    ld (de),a
    inc de
    ld a,0
    ld (de),a
    pop de
    call upde
    djnz draw_blank_2_char0
    ret

; delete 3 char-wide space
draw_blank_3_char:
    ld b,8              ; repeat for 8 lines
draw_blank_3_char0:
    push de             ; store coord location
    ld a,0              ; first character width - get new byte to display
    ld (de),a           ; load byte into display           
    inc de
    ld a,0              ; second character width
    ld (de),a
    inc de
    ld a,0              ; third character width
    ld (de),a
    pop de
    call upde
    djnz draw_blank_3_char0
    ret


; Given an address in screen memory in DE, return the address of the next pixel line down the screen
upde:
    inc d       ; increment higher order byte
    ld a,d      ; test to see if we're at the 8th byte row in the character
    and 7       ; mask everything but first 3 bits, leaves the *last* 3 bytes of the y coord yte row)
    ret nz      ; if result is zero then we have passed the bottom of the char
                ; now test to see if we're at the 8th byte row at the bottom of the 8 row group
    ld a,e      ; isolate lower order byte
    add a,$20    ; if last 3 bits of e are 111 then adding 32 will cause a carry
    ld e,a      ; ld result back into e
    ret c       ; if there was a carry then de has been set to top of next group of 8 rows
                ; if no carry then we're still in the same group of 8 rows
    ld a,d      ; get higher order byte
    sub 8       ; subtract 8 to roll back any carry over
    ld d,a
    ret

; Given an address in screen memory in DE, return the address of the next pixel line up the screen
downde:
    ld   a, d                  ; Load the value in A
    dec  d                     ; Decrements H to decrement the scanline
    and  $07                   ; Keeps the bits of the original scanline
    ret  nz                    ; If not at 0, end of routine

    ; Calculate the previous line
    ld   a, e                  ; Load the value of L into A
    sub  $20                   ; Subtract one line
    ld   e, a                  ; Load the value in L
    ret  c                     ; If there is carry-over, end of routine

    ; If you arrive here, you have moved to scanline 7 of the previous line
    ; and subtracted a third, which we add up again
    ld   a, d                  ; Load the value of H into A
    add  a, $08                ; Returns the third to the way it was
    ld   d, a                  ; Load the value in h
    ret

; Given an address in DE, return the address of the next screen row directly below it on the screen
upde_row:
	xor a			; reset flags
	ld a,e			; get low byte
	add a,$20			; add 32 (length of one row)
	ld e,a			; load back into de
	ret nc			; if there is no carry, we're done
	ld a,d			; otherwise, get high byte as we've gone into next block of rows
	add a,$08		; add 8 (difference between blocks of rows, e.g. $40,$48,$50)
	ld d,e			; load back into de
	ret

; Given an address in DE, return the address of the next screen row directly above it on the screen
downde_row:
    xor a           ; reset flags
    ld a,e          ; test low byte
    sub $20         ; subtract 32 (length of one row)
    ld e,a          ; load back into de
    ret nc          ; if still positive, we're done
    ld a,d          ; test high byte
    sub $08         ; subtract 8 (difference between blocks of rows)
    ld d,a          ; load back into de
    ret
; ***************