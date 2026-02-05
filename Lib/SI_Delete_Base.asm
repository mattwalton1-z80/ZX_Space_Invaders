; delete base
delete_base:
;    ld d,$50           ; test
    ld d,$C0            ; base is always on bottom row (high byte) of screen buffer
    ld a,(basex)
    ld e,a              ; x position is low byte
    ld a,(baseoffset)   ; retrieve base offset
    cp 0
    jr z,delete_base0   ; if no offset, delete non-shifted base
    call draw_blank_3_char  ; otherwise, delete shifted base (3 chars wide)
    ret
delete_base0:
    call draw_blank_2_char  ; delete non-shifted base (2 chars wide)
    ret