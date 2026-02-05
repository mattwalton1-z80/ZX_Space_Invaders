; Handy defines
screen_width_pixels:    equ 256
screen_height_pixels:   equ 192
screen_width_chars:     equ 32
screen_height_chars:    equ 24

screen_start:           equ $4000
screen_size:            equ screen_width_chars * screen_height_pixels
attr_start:             equ $5800
attributes_length:      equ screen_width_chars * screen_height_chars
buffer_start            equ $B000
buffer_attr_start       equ $C800

screen_bottom_row       equ $50E0
screen_2nd_botton_row   equ $50C0

;SEG1 equ $4000
;SEG2 equ $4800
;SEG3 equ $5000
;bufferSEG1 equ $B000
;bufferSEG2 equ $B800
;bufferSEG3 equ $C000
bufferSEG1 equ $B00A
bufferSEG2 equ $B80A
bufferSEG3 equ $C00A
SEG1 equ $4018
SEG2 equ $4818
SEG3 equ $5018
attr_bufferSEG equ $C80A
attr_screenSEG equ $5818

P0 equ 0
P1 equ 256
P2 equ 512
P3 equ 768
P4 equ 1024
P5 equ 1280
P6 equ 1536
P7 equ 1792
C0 equ 0
C1 equ 32
C2 equ 64
C3 equ 96
C4 equ 128
C5 equ 160
C6 equ 192
C7 equ 224

black:                  equ %000000
blue:                   equ %000001
red:                    equ %000010
magenta:                equ %000011
green:                  equ %000100
cyan:                   equ %000101
yellow:                 equ %000110
white:                  equ %000111

pBlack:                 equ black << 3
pBlue:                  equ blue  << 3
pRed:                   equ red  << 3
pMagenta:               equ magenta  << 3
pGreen:                 equ green  << 3
pCyan:                  equ cyan  << 3
pYellow:                equ yellow  << 3
pWhite:                 equ white  << 3
            
bright:                 equ %1000000