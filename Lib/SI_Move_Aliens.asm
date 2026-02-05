; *** Move Aliens ***
; routines to move aliens left or right

move_aliens:
    xor a						; clear any carry
	ld a,(aliendir)             ; first, figure out if we're going left or right
    rra                         ; rotate first bit into carry
    jr c,move_aliens_right      ; if =1 then we're moving right, otherwise we're moving left


; *** Move LEFT ***
move_aliens_left:
    xor a                       ; reset flags
    ld a,(alienoffset)          ; get alien offset
    cp 0                        ; check if it's already at min
    jr z,move_aliens_left0      ; if yes, then skip to decrement positions
    dec a                       ; otherwise, decrement the offset
    ld (alienoffset),a          ; and store it
    jp reset_movecounter        ; jump to end

move_aliens_left0:
    ld ix,a1_db                 ; get alien 1 database
    dec (ix+2)                  ; decrement low bit position by 1

    ; ld h,0
    ; ld a,(ix+2)
    ; and 31
    ; ld l,a
    ; ld (score),hl               ; show current x position in Score

    ld hl,a1_db                 ; use HL to move along bytes in the row
    jr alien_row_lhs_check

    ; Check we haven't hit the LHS of the screen...
    ; Start from LHS of row of aliens, working right
    ; If alien exists, check if position low bit + x coord == 1 (???)
    ; If the left-most alien has hit the LHS of the screen, drop the Row position by 2 pixels 
    ; and change direction so aliens are moving to the right

alien_row_lhs_check:
    ; start with first alien at byte 3
    ld bc,3
    add hl,bc

alien_row_lhs_check1:
    bit $00,(hl)                ; test if row exists
    jr z,alien_row_lhs_check2   ; if no alien, check next one in the row  
    ld a,(ix+2)                 ; otherwise, get position low bit
    inc hl                      ; get x coord of current alien in row (1 byte along from existence flag)
    add a,(hl)                  ; add x coord of current alien
    and 31                      ; mask to get column between 0-31
    cp 1                        ; compare against 1 (left-hand limit of alien)
    jr nz,reset_alienoffset_high; alien not at left-hand then we can stop checking and jump to resetting movecounter
    inc (ix+2)                  ; otherwise, first thing we need to do is stop moving things left so un-decrememnt position low bit
    ld d,(ix+1)                 ; load position high bit into D
    ld e,(ix+2)                 ; load position low bit into E
    call upde                   ; call upde twice to move position down 2 pixels
    call upde       
    ld (ix+1),d                 ; load updated D into position high bit
    ld (ix+2),e                 ; load updated E into position low bit
    ld a,1
    ld (aliendir),a             ; set aliens moving to the right (0=left/1=right)
    jr reset_movecounter        ; jump to end

alien_row_lhs_check2:
    ; move along row for next alien then check again
    inc hl                      ; increase HL to get to next alien existence flag
    inc hl
    jr alien_row_lhs_check1
; ****************


; *** Move RIGHT ***
move_aliens_right:
    xor a                       ; reset flags
    ld a,(alienoffset)          ; get alien offset - only update if at top row
    cp 3                        ; check if it's already at max
    jr z,move_aliens_right0     ; if yes, then skip to increment positions
    inc a                       ; otherwise, increment the offset
    ld (alienoffset),a          ; and store it
    jr reset_movecounter        ; jump to end 

move_aliens_right0:
    ld ix,a1_db                 ; get alien 1 database
    inc (ix+2)                  ; advance low bit position by 1
    
    ; ld a,(ix+2)
    ; and 31
    ; ld l,a
    ; ld (score),hl               ; show current x position in Score
    
    ld hl,a1_db                 ; use HL to move along bytes in the row
    jr alien_row_rhs_check

    ; Check we haven't hit the RHS of the screen...
    ; Start from RHS of row of aliens, working left
    ; If alien exists, check if position low bit + x coord == 29 (screen is 32 chars wide but we're working with 3-char sprites)
    ; If position = 29, drop the Row position by 2 pixels and change direction so aliens are moving to the left
    ; If position < 29 then entire row hasn't hit RHS so skip

alien_row_rhs_check:
    ; start with very last alien in the row
    ld bc,23                    ; add 23 to start of row
    add hl,bc
    
alien_row_rhs_check1:
    bit $00,(hl)                ; test if row exists
    jr z,alien_row_rhs_check2   ; if no alien, check next one in the row
    ld a,(ix+2)                 ; otherwise, get position low bit
    inc hl                      ; advance HL to get position of alien
    add a,(hl)                  ; add x coord of alien
    and 31                      ; mask to get column between 0-31
    cp 29                       ; compare against 29 (right-hand limit of alien)
    jr nz,reset_alienoffset_low ; alien not at right-hand then we can stop checking and jump to resetting alien offet & movecounter
    dec (ix+2)                  ; otherwise, first thing we need to do is stop moving things right so un-incrememnt position low bit
    ld d,(ix+1)                 ; load position high bit into D
    ld e,(ix+2)                 ; load position low bit into E
    call upde                   ; call upde twice to move position down 2 pixels
    call upde       
    ld (ix+1),d                 ; load updated D into position high bit
    ld (ix+2),e                 ; load updated E into position low bit
    xor a                       ; reset a
    ld (aliendir),a             ; set aliens moving to the left
    jr reset_movecounter        ; jump to end
    
alien_row_rhs_check2:
    ; move back along row for next alien then check again
    dec hl                      ; decrease HL by two bytes to get to next alien in row
    dec hl
    jr alien_row_rhs_check1     ; go back to check next alien
; ****************

reset_alienoffset_low:
    xor a                       ; reset a
    ld (alienoffset),a          ; reset alien offset to min (0)
    jr reset_movecounter        ; jump to end

reset_alienoffset_high:
    ld a,3                      ; reset alien offset to max (3)
    ld (alienoffset),a          ; 

reset_movecounter:
    ; Process counters at the end of the routine
    xor a                       ; reset move counter
    ld (movecount),a            ; store value back in variable

    ret
; ***************