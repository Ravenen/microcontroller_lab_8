.include "m2560def.inc"


;======== Macrodefinitions ===================================
.def	_temp1	= r16
.def	_temp2	= r17
.def	_temp3	= r18

.def	_btn1	= r19
.def	_btn2	= r20

.def	_algo_buff1	= r21
.def	_algo_buff2	= r22

;==========================================================
; F_CPU						= 16000000
; TIMER_CYCLE_IN_SECONDS	= 1.05
; PRESCALER_VALUE			= 1024
; COUNTER_VALUE				= (TIMER_CYCLE_IN_SECONDS * F_CPU / PRESCALER_VALUE) - 1
;
; COUNTER_VALUE				= 16405
;
;==========================================================
.equ	COUNTER_VALUE		= 16405


;======== SRAM ============================================
.DSEG


;======== FLASH ============================================
.CSEG
	.org	0x00
	jmp		reset
	.org	0x40
	jmp		TIMER3_COMPA
	.org	0x70 ; Last address	
	reti


TIMER3_COMPA:
	cli
	check_first_algo:
		sbrc	_btn1, 0
		rjmp	run_first_algo
	check_second_algo:
		sbrc	_btn2, 0
		rjmp	run_second_algo
	timer_end:
		sei
		reti


run_first_algo:
	out		PORTF, _algo_buff1
	cpi		_algo_buff1, 0b10000000
	breq	algo_1_step_2
	cpi		_algo_buff1, 0b00100000
	breq	algo_1_step_3
	cpi		_algo_buff1, 0b00001000
	breq	algo_1_step_4
	cpi		_algo_buff1, 0b00000010
	breq	algo_1_step_5
	cpi		_algo_buff1, 0b01000000
	breq	algo_1_step_6
	cpi		_algo_buff1, 0b00010000
	breq	algo_1_step_7
	cpi		_algo_buff1, 0b00000100
	breq	algo_1_step_8
	cpi		_algo_buff1, 0b00000001
	breq	algo_1_step_clear
	cpi		_algo_buff1, 0b00000000
	breq	algo_1_step_end


run_second_algo:
	sts		PORTK, _algo_buff2
	cpi		_algo_buff2, 0b00000001
	breq	algo_2_step_2
	cpi		_algo_buff2, 0b00000010
	breq	algo_2_step_3
	cpi		_algo_buff2, 0b00000100
	breq	algo_2_step_4
	cpi		_algo_buff2, 0b00001000
	breq	algo_2_step_5
	cpi		_algo_buff2, 0b00010000
	breq	algo_2_step_6
	cpi		_algo_buff2, 0b00100000
	breq	algo_2_step_7
	cpi		_algo_buff2, 0b01000000
	breq	algo_2_step_8
	cpi		_algo_buff2, 0b10000000
	breq	algo_2_step_clear
	cpi		_algo_buff2, 0b00000000
	breq	algo_2_step_end
	

algo_1_step_2:
	ldi		_algo_buff1, 0b00100000
	rjmp	check_second_algo
algo_1_step_3:
	ldi		_algo_buff1, 0b00001000
	rjmp	check_second_algo
algo_1_step_4:
	ldi		_algo_buff1, 0b00000010
	rjmp	check_second_algo
algo_1_step_5:
	ldi		_algo_buff1, 0b01000000
	rjmp	check_second_algo
algo_1_step_6:
	ldi		_algo_buff1, 0b00010000
	rjmp	check_second_algo
algo_1_step_7:
	ldi		_algo_buff1, 0b00000100
	rjmp	check_second_algo
algo_1_step_8:
	ldi		_algo_buff1, 0b00000001
	rjmp	check_second_algo
algo_1_step_clear:
	ldi		_algo_buff1, 0b00000000
	rjmp	check_second_algo
algo_1_step_end:
	ldi		_btn1, 0
	rjmp	check_second_algo


algo_2_step_2:
	ldi		_algo_buff2, 0b00000010
	rjmp	timer_end
algo_2_step_3:
	ldi		_algo_buff2, 0b00000100
	rjmp	timer_end
algo_2_step_4:
	ldi		_algo_buff2, 0b00001000
	rjmp	timer_end
algo_2_step_5:
	ldi		_algo_buff2, 0b00010000
	rjmp	timer_end
algo_2_step_6:
	ldi		_algo_buff2, 0b00100000
	rjmp	timer_end
algo_2_step_7:
	ldi		_algo_buff2, 0b01000000
	rjmp	timer_end
algo_2_step_8:
	ldi		_algo_buff2, 0b10000000
	rjmp	timer_end
algo_2_step_clear:
	ldi		_algo_buff2, 0b00000000
	rjmp	timer_end
algo_2_step_end:
	ldi		_btn2, 0
	rjmp	timer_end


reset: 
	cli

	ldi		_temp1, high(RAMEND)
	out		sph, _temp1
	ldi		_temp1, low(RAMEND)
	out		spl, _temp1

	; CTC mode, 1024 prescaler
	ldi		_temp1, (1 << WGM32) | (1 << CS30) | (1 << CS32) 
	ldi		_temp2, 0x00
	sts		TCCR3A, _temp2
	sts		TCCR3B, _temp1

	; TOP value of counter
	ldi		_temp1, Low(COUNTER_VALUE)
	ldi		_temp2, High(COUNTER_VALUE)
	sts		OCR3AH, _temp2
	sts		OCR3AL, _temp1
	
	
	; enable interrupt on compare A
	ldi		_temp1, 1 << OCIE3A
	sts		TIMSK3, _temp1

	ldi		_temp1, 0x00
	ldi		_temp2, 0xFF

	; PORTF on output - LEDs
	out		DDRF, _temp2
	out		PORTF, _temp1

	; PORTK on output - LEDs
	sts		DDRK, _temp2
	sts		PORTK, _temp1

	; PB0 on output - buzzer
	ldi		_temp1, 0x01
	ldi		_temp2, 0x00
	out		DDRB, _temp1
	out		PORTB, _temp2

	; PA0 and PA2 in input - buttons
	ldi		_temp1, 0x00
	ldi		_temp2, (1 << PA0) | (1 << PA2)
	out		DDRA, _temp1
	out		PORTA, _temp2

	ldi _temp1, 0
	sei
main:
	; if button PA0 is down
	sbis	PINA, 0
	rcall	first_btn

	; if button PA2 is down
	sbis	PINA, 2
	rcall	second_btn

	rjmp	main


first_btn:
	ldi		_btn1, 1
	ldi		_algo_buff1, 0b10000000

	rcall	sound_buzzer
	ret


second_btn:
	ldi		_btn2, 1
	ldi		_algo_buff2, 0b00000001

	rcall	sound_buzzer
	ret


sound_buzzer:
	sbi		PORTB, 0
	rcall	delay200ms	
	cbi		PORTB, 0
	ret


delay200ms:
	ldi		_temp1, 0x00
	ldi		_temp2, 0xC4
	ldi		_temp3, 0x09
delay:	
	subi	_temp1, 1
	sbci	_temp2, 0
	sbci	_temp3, 0
	brne	delay
	ret

;======== EEPROM ============================================
.ESEG