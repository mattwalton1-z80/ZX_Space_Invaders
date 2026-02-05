; draw base
draw_base:
;    ld d,$50           ; test
    ld d,$C0            ; base is always on bottom row (high byte) of screen buffer
    ld a,(basex)        
    ld e,a              ; x position is low byte
    ld a,(baseoffset)   ; retrieve base offset
    cp 0
    jr z,draw_base0     ; if no offset, draw non-shifted base
    cp 1
    jr z,draw_base1     ; draw first shifted sprite
    cp 2
    jr z,draw_base2     ; draw second shifted sprite
    cp 3
    jr z,draw_base3     ; draw third shifted sprite

draw_base0:
    ld hl,base_noshift
    call draw_2_char
    ret

draw_base1:
    ld hl,base_shift2
    call draw_3_char
    ret

draw_base2:
    ld hl,base_shift4
    call draw_3_char
    ret

draw_base3:
    ld hl,base_shift6
    call draw_3_char
    ret