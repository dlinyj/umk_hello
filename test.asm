array_h		equ 0x09 ;откуда берём код
array_l		equ 0x00 ;0900
position_a	equ 0x0920
len			equ 0x0C
counter_sh	equ 0x2492; 0x618 если буду делать 1 раз 6
	ORG 0800h
start:
	lxi h, counter_sh
m1:
	mvi b, 0x01
	mvi c, 00 ; i
	mvi d, array_h 
	mvi e, array_l 
m2:
	lda position_a
	add c; i+position
	cpi len ;вычитаем длинну из а
	jp else ; если меньше, переходим
	;Если больше нуля putchar(array[i + position]);
	mov e, a; array_l
	jmp putchar
else:
	;если меньше нуля putchar(array[len - (i + position)]); 
	lda position_a
	mov e, a
	mvi a, len
	sub c ;len - i
	sub e ; (len - i) - position
	mov e, a; array_l
putchar:
	call out_p
	;проверка количества циклов выполнения
	dcx h
	mov a, h
	ora l
	jz increment_pos; типа всё, цикл закончен!
	;проверка сдвига по выводу на экран
	mov a, b
	sbi 0x20
	jz m1; если 20, то перейти  на m1
	mov a, b
	rlc ; сдвинуть влево
	mov b, a
	inr c; i++
	inx d
	jmp m2
increment_pos:
	lda position_a
	inr a; 
	cpi len; достигли ли мы конца?
	jnz load_pos;ещё пока не достигли дна
	sub a ;дно пробито, очищаем позицию на нуль
load_pos:
	sta position_a; загружаем её
	jmp start; топаем на старт
	ORG 0860h
out_p:
	;F8 - рег сегментных
	;F9 - настр
	mov a, b
	out 0xF8
	ldax d ;загружаем в А содержимое по адресу ячейки D+E
	out 0xF9
	ret
	
	ORG 0900h
	DB	76h, 79h, 38h, 38h, 3Fh, 00, 74h, 0dch, 7Ch, 50h, 00h, 00h
	ORG position_a
	DB	00; position

