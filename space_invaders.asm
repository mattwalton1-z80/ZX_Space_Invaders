org $8000

screen_setup:
; set the border to blackest of nights
	ld a,pBlack
	call 8859
	call 3503 ; ROM routine - clears screen, opens channel 2.

; set global attributes (black screen, white text)
    ld hl,attr_start
    push hl
    pop de
    inc de
    ld bc,attributes_length
    ld (hl),pBlack | white
    ldir

; reset variables
    ld a,55                 ; starting alien count
    ld (aliencount),a
    ld a,5                  ; starting number of rows of aliens
    ld (alrowcount),a
    ld a,1                  ; aliens start off moving to right (0=left, 1=right)
    ld (aliendir),a
    ld a,255
    ld ix,bbulletposn       ; store 255 as default for first byte of base bullet position
    ld (ix),a
    xor a
    ld (ix+1),a				; set 2nd byte of base bullet position to 0
    ld (movecount),a        ; reset movecount
	ld (bbulletoffset),a    ; set default offset of base bullet to 0
    ld (alienmoveflag),a    ; reset alien move flag to 0
    ld (alienoffset),a      ; starting offset for base is 0, i.e. start with non-shifted sprite
    ld (baseoffset),a       ; starting offset for base is 0, i.e. start with non-shifted sprite
	ld (bulletkill),a      ; set default bullet kill flag to 0
    ld a,$EF                ; starting horizontal position of base (middle of screen)
    ld (basex),a
    ld b,0
    ld c,0
    ld (score),bc           ; reset score

; prepare alien row 1
    ld hl,a1_db         ; populate alien 1 database
    ld (hl),1           ; row exists
    inc hl
    ld (hl),$B0         ; default y position for row (high byte first) - Double Buffer display
    ; ld (hl),$40         ; default y position for row (high byte first) - Single Buffer display
    inc hl
    ld (hl),$84         ; default y & x position for row (low byte last)
    inc hl
    ld b,11             ; populate 11 aliens in row
    ld a,0              ; starting x position
a1_prep_loop:
    ld (hl),1           ; alien exists
    inc hl
    ld (hl),a           ; x position
    inc hl
    add a,2             ; advance x position by 2
    djnz a1_prep_loop

; print title screen
    call title_screen

    ei                          ; enable interrupts

; *** MAIN LOOP ***
main_loop: 
    ld a,22 ; AT code.
	rst 16
	ld a,0 ; vertical coord.
	rst 16 ; 
	ld a,7 ; horizontal position.
	rst 16 ; 
    ld bc,(score)
    call 11563 ; stack number in bc.
    call 11747 ; display top of calc. stack.

    call delete_base            ; delete base from current position
    call delete_aliens          ; delete aliens from current position
	call delete_bullet			; delete base bullet from current position
	
    call check_bullet_collision

    call move_base              ; read keyboard
	
    ; test whether to move aliens each loop
    ld a,(movecount)            ; get move counter
    cp 20                       ; compare against some value
    call z,move_aliens          ; if match, time to move the aliens

	call move_bullet			; move bullet if present and check for collisions

    call draw_base              ; repaint base in new position
    call draw_aliens            ; draw row of aliens in current position
	call draw_bullet			; draw bullet in new location if present

    ; Process counters at the end of the loop
    ld a,(movecount)            ; get move counter
    inc a                       ; increment move counter
    ld (movecount),a            ; store value

    ; Copy double buffer to screen buffer
    call buf2screen

    jp main_loop 
; ****************


; Definitions
	include "./lib/constants.asm"
	include "./lib/Colors.asm"
    include "./lib/sound.asm"
    include "./lib/SI_Delete_Aliens.asm"
    include "./lib/SI_Delete_Base.asm"
	include "./lib/SI_Delete_Bullet.asm"
    include "./lib/SI_Draw_Base.asm"
    include "./lib/SI_Draw_Aliens.asm"
	include "./lib/SI_Draw_Bullet.asm"
    include "./lib/SI_Move_Base.asm"
    include "./lib/SI_Move_Aliens.asm"
	include "./lib/SI_Move_Bullet.asm"
	include "./lib/SI_Check_Collisions.asm"
    include "./lib/SI_Draw_Sprites.asm"
    include "./lib/SI_Buffer_Copy.asm"
	include "./lib/SI_Intro_Screen.asm"


; variable definitions
    score			defw 0        ; define bytes to store score
    aliencount      defb 0        ; number of remaining aliens
    aliendir        defb 0        ; direction of aliens (0=left, 1=right)
    movecount       defb 0        ; move count (time between moving aliens)
    alienmoveflag   defb 0        ; flag set if it's time to move aliens
    alrowcount      defb 0        ; move alien rows one at a time (vals 1,2,3,4,5)
    alienoffset     defb 0        ; which pre-shifted alien sprite to use (vals 0,1,2,3)
    stptr           defb 0,0      ; define bytes to hold a pointer to stack
    rowloopctr      defb 0        ; used to track bytes to be copied from buffer to screen
    buffer_posn     defb 0,0      ; use for buffer copy
    screen_posn     defb 0,0      ; use for buffer copy
    basex           defb 0        ; x position of base
    baseoffset      defb 0        ; which pre-shifted base sprite to use (vals 0,1,2,3)
    bbulletposn     defb 0,0      ; store base bullet position as full address
    bbulletoffset   defb 0        ; store base offset at time of firing bullet (vals 0,1,2,3)
	bulletkill     defb 0     	  ; flag when bullet goes above screen and needs to be reset after buffer copy

    a1_db           defb 0          ; whole line exists (11x alien 1, top row) (0=no)
                    defb 0,0        ; y position of line (row)
                    defb 0,0        ; per alien pair: alien exists (0=no), x position of alien
                    defb 0,0
                    defb 0,0
                    defb 0,0
                    defb 0,0
                    defb 0,0
                    defb 0,0
                    defb 0,0
                    defb 0,0
                    defb 0,0
                    defb 0,0
    a1_noshift	    defb 6,0,0       ; shifted alien 1 sprites
                    defb 15,0,0
                    defb 31,128,0
                    defb 54,192,0
                    defb 63,192,0
                    defb 22,128,0
                    defb 32,64,0
                    defb 16,128,0
    a1_shift2	    defb 1,128,0
                    defb 3,192,0
                    defb 7,224,0
                    defb 13,176,0
                    defb 15,240,0
                    defb 2,64,0
                    defb 5,160,0
                    defb 10,80,0
    a1_shift4	    defb 0,96,0
                    defb 0,240,0
                    defb 1,248,0
                    defb 3,108,0
                    defb 3,252,0
                    defb 1,104,0
                    defb 2,4,0
                    defb 1,8,0
    a1_shift6	    defb 0,24,0
                    defb 0,60,0
                    defb 0,126,0
                    defb 0,219,0
                    defb 0,255,0
                    defb 0,36,0
                    defb 0,90,0
                    defb 0,165,0
    a2_noshift	    defb 32,128,0     ; shifted alien 2 sprites
                    defb 145,32,0
                    defb 191,160,0
                    defb 238,224,0
                    defb 255,224,0
                    defb 127,192,0
                    defb 32,128,0
                    defb 64,64,0
    a2_shift2	    defb 8,32,0
                    defb 4,64,0
                    defb 15,224,0
                    defb 27,176,0
                    defb 63,248,0
                    defb 47,232,0
                    defb 40,40,0
                    defb 6,192,0
    a2_shift4	    defb 2,8,0
                    defb 9,18,0
                    defb 11,250,0
                    defb 14,238,0
                    defb 15,254,0
                    defb 7,252,0
                    defb 2,8,0
                    defb 4,4,0
    a2_shift6	    defb 0,130,0
                    defb 0,68,0
                    defb 0,254,0
                    defb 1,187,0
                    defb 3,255,128
                    defb 2,254,128
                    defb 2,130,128
                    defb 0,108,0
    a3_noshift	    defb 15,0,0          ; shifted alien 3 sprites
                    defb 127,224,0
                    defb 255,240,0
                    defb 230,112,0
                    defb 255,240,0
                    defb 25,128,0
                    defb 54,192,0
                    defb 192,48,0
	a3_shift2	    defb 3,192,0
                    defb 31,248,0
                    defb 63,252,0
                    defb 57,156,0
                    defb 63,252,0
                    defb 14,112,0
                    defb 25,152,0
                    defb 12,48,0
	a3_shift4	    defb 0,240,0
                    defb 7,254,0
                    defb 15,255,0
                    defb 14,103,0
                    defb 15,255,0
                    defb 1,152,0
                    defb 3,108,0
                    defb 12,3,0
	a3_shift6	    defb 0,60,0
                    defb 1,255,128
                    defb 3,255,192
                    defb 3,153,192
                    defb 3,255,192
                    defb 0,231,0
                    defb 1,153,128
                    defb 0,195,0
    abang_noshift	defb 4,0,0
                    defb 36,128,0
                    defb 17,0,0
                    defb 0,0,0
                    defb 96,192,0
                    defb 0,0,0
                    defb 17,0,0
                    defb 36,128,0
    abang_shift2	defb 4,0,0
                    defb 36,128,0
                    defb 17,0,0
                    defb 0,0,0
                    defb 96,192,0
                    defb 0,0,0
                    defb 17,0,0
                    defb 36,128,0
    abang_shift4	defb 0,64,0
                    defb 2,72,0
                    defb 1,16,0
                    defb 0,0,0
                    defb 6,12,0
                    defb 0,0,0
                    defb 1,16,0
                    defb 2,72,0
    abang_shift6	defb 0,16,0
                    defb 0,146,0
                    defb 0,68,0
                    defb 0,0,0
                    defb 1,131,0
                    defb 0,0,0
                    defb 0,68,0
                    defb 0,146,0
	bullet_noshift	defb 0
                    defb 1
                    defb 1
                    defb 1
                    defb 1
                    defb 1
                    defb 1
                    defb 0
    bullet_shift2	defb 0
                    defb 64
                    defb 64
                    defb 64
                    defb 64
                    defb 64
                    defb 64
                    defb 0
    bullet_shift4	defb 0
                    defb 16
                    defb 16
                    defb 16
                    defb 16
                    defb 16
                    defb 16
                    defb 0
    bullet_shift6	defb 0
                    defb 4
                    defb 4
                    defb 4
                    defb 4
                    defb 4
                    defb 4
                    defb 0
    blank_1_char    defb 0          ; blank chars to erase sprites - why?!?
                    defb 0
                    defb 0
                    defb 0
                    defb 0
                    defb 0
                    defb 0
                    defb 0
    blank_2_char    defb 0,0        
                    defb 0,0
                    defb 0,0
                    defb 0,0
                    defb 0,0
                    defb 0,0
                    defb 0,0
                    defb 0,0
    blank_3_char    defb 0,0,0
                    defb 0,0,0
                    defb 0,0,0
                    defb 0,0,0
                    defb 0,0,0
                    defb 0,0,0
                    defb 0,0,0
                    defb 0,0,0
    base_noshift	defb 0,0      ; shifted base sprites
                    defb 1,0
                    defb 3,128
                    defb 31,240
                    defb 63,248
                    defb 127,252
                    defb 127,252
                    defb 127,252
    base_shift2	    defb 0,0,0
                    defb 0,64,0
                    defb 0,224,0
                    defb 7,252,0
                    defb 15,254,0
                    defb 31,255,0
                    defb 31,255,0
                    defb 31,255,0
    base_shift4	    defb 0,0,0
                    defb 0,16,0
                    defb 0,56,0
                    defb 1,255,0
                    defb 3,255,128
                    defb 7,255,192
                    defb 7,255,192
                    defb 7,255,192
    base_shift6	    defb 0,0,0
                    defb 0,4,0
                    defb 0,14,0
                    defb 0,127,192
                    defb 0,255,224
                    defb 1,255,240
                    defb 1,255,240
                    defb 1,255,240

    score_string		
        db 22,0,0,17,0,16,7,19,0
        defm "SCORE: "
	score_string_len	equ $ - score_string
    title1
        db 22,5,14,17,0,16,3,19,0
        defm "PLAY"
    title1_string_len   equ $ - title1
    title2
        db 22,7,9,17,0,16,2,19,1
        defm "SPACE INVADERS"
    title2_string_len   equ $ - title2
    alien_score_high
		db 22,11,12,17,0,16,7,19,0
        defm "= 30 POINTS"
	alien_score_high_len	equ $ - alien_score_high
    alien_score_med
		db 22,13,12,17,0,16,7,19,0
        defm "= 20 POINTS"
	alien_score_med_len		equ $ - alien_score_med
    alien_score_low
		db 22,15,12,17,0,16,7,19,0
        defm "= 10 POINTS"
	alien_score_low_len		equ $ - alien_score_low
	start_string		
		db 22,21,7,17,0,16,4,19,0
        defm "PRESS 'S' TO START"
    start_string_len	equ $ - start_string
    poorly_written:
        db 22,18,6,17,0,16,7,19,0
        defm "Poorly coded by Matt."
    poorly_written_len  equ $ - poorly_written
ret