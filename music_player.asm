; Music_Player (c) Jan Klingel 2020
; Version 31.08.2020;07:45
; Written for MOS 6510 Commodore 64
; using Turbo Macro Pro v1.2

         *= $1000

; Play some notes ("music"). The notes
; are expected in label "music" in the
; format freq low byte, high byte,
; hold time. The last byte must be the
; null byte.

sid      = $d400    ; SID-II voice 1
holdt    = $02a7    ; Hold timer

;---------------------------------------
main
         jsr init_sid
         jsr play_music
         rts
;---------------------------------------
play_music
         .block
         lda #15    ; max volume
         sta sid+24 ; volume
         lda #4*16+4
         sta sid+5  ; attack+decay
         lda #8*16+6
         sta sid+6  ; sustain+release
         ldy #0
loop
         lda music,y
         cmp #0
         beq end
         cmp #255
         beq pause
         sta sid    ; freq low byte
         iny
         lda music,y
         sta sid+1  ; freq high byte
         lda #33    ; square wave on
         sta sid+4  ; noise gen on
pause
         iny
         lda music,y
         sta holdt
         iny
         jsr hold
         lda #34    ; square wave off
         sta sid+4  ; noise gen off
         jmp loop
end
         rts
         .bend
;---------------------------------------
init_sid
         ; Reset all registers of SID
         .block
         lda #0
         ldx #$00
loop
         sta sid,x
         inx
         cpx #29
         bne loop
         rts
         .bend
;---------------------------------------
hold
         ; Implement a hold func by
         ; counting VIC-II frames. 50
         ; PAL frames equal to 1s.

         ; 1/8 note: hold 10 frames
         ; 1/4 note: hold 20 frames
         ; 1/2 note: hold 40 frames
         ; 1/1 note: hold 60 frames
         .block

         ldx holdt ; Get hold timer
wait_1
         ; Copy bit 7 of $d011 into
         ; negative flag. Loop back
         ; if negative flag is cleared
         ; (0). Bit 7 is bit 8 of
         ; $d012 raster counter.
         bit $d011
         bpl wait_1
wait_2
         ; Copy bit 7 of $d011 into
         ; negative flag. Loop back
         ; if negative flag is set.
         bit $d011
         bmi wait_2
         dex
         bne wait_1
         rts
         .bend
;---------------------------------------
         ; Include the music file here

         .include "alle_meine.dat"

         .end

