BWXP_EXPAddition::
    callba SRAMStatsRecordBWEXPGain
    
; copy back yield to multiplier fields
    ld a, [BWXP_SCRATCH5B_1 + 2]
    ld [hProduct + 3], a
    ld a, [BWXP_SCRATCH5B_1 + 1]
    ld [hProduct + 2], a
    ld a, [BWXP_SCRATCH5B_1]
    ld [hProduct + 1], a
    
; functions from original code, call them as is
    call AnimateExpBar
	
    push bc
    call LoadTileMapToTempTileMap
    pop bc
; set hl = 3rd byte of party mon exp value (+10 from current bc)
    ld hl, $a
    add hl, bc

    ld a, [wPermanentOptions2]
    and EXP_MASK
    cp EXP_NEG
    jp r, .subtract
; add new exp
    ld d, [hl]
    ld a, [hProduct + 3]
    add d
    ld [hld], a
    
    ld d, [hl]
    ld a, [hProduct + 2]
    adc d
    ld [hld], a
    
    ld d, [hl]
    ld a, [hProduct + 1]
    adc d
    ld [hl], a
    ret nc
; maxed exp, set it to FFFFFF
    ld a, $ff
    ld [hli], a
    ld [hli], a
    ld [hl], a
	ret

.subtract
    push de
    push bc
    ld d, h ;de = mon exp location
    ld e, l
    ld a, [de]
    ld hl [hProduct + 3]
    sub a, [hl]
    dec hl
    ld [de], a
    dec de

    ld a, [de]
    sub a, [hl]
    dec hl
    ld [de], a
    dec de

    ld a, [de]
    sub a, [hl]
    ld [de], a
    pop bc
    pop de
    ret nc
    ld a, 0
    ld [hli], a
    ld [hli], a
    ld [hl], a
	ret
