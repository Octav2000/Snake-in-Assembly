.586
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc

includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
window_title DB "SNAKE",0
area_width EQU 800
area_height EQU 800
area dd 0
len dd 40		; lungimea unui patrat al sarpelui si al labirintului
verificare dd 0 ; pentru a verifica directiile (<200 sau > 600 etc)
a dd 0			
b dd 0	
counter dd 0	
scor dd 0
mancat_sarpe dd 0	;1 daca sarpele este mancat, 0 in caz contrar
mancarex dd 0	 					; coordonata pentru mancare buna
mancarey dd 0						; coordonata pentru mancare proasta
parcurgere_vector dd 0 				; ma ajuta pentru parcurgerea vectorului si pleaca intotdeauna de la 0
interval dd 0						; interval pentru generarea de coordonate
contor dd 0 						; ajuta la desenarea unui patrat
directie dd 1						; directia de deplasare a sarpelui -> 0 - sus, 1 - dreapta, 2 - jos, 3 - stanga
lungime_sarpe dd 20					; 3 patrate initialie => 6 coordonate x,y,x,y,x,y
lungime_sarpe_nou dd 20
lungime_sarpe2 dd 4					; pentru ca din 6 coordonate pe primele 2 nu le mut
lungime_sarpe2_nou dd 4
i dd 167                            ; contor memorarea pozitiei sarpelui in matrice (adica pe ce casuta se afla)
j dd 0 								; contor pentru cautarea coordonatei y
vector dd 26 dup(0)                 ; vectorul sarpelui
;0 - loc liber
;1 - labirint
;2 - sarpe
;3 - mancare buna
;4 - mancare proasta
matrice db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		db 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0
		db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0
		db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0
		db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
		db 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
		db 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
		db 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
		db 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
		db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
		db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0 
		db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0 
		db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0 
		db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
		db 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0 
		db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
		db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
x_matrice dd 0
y_matrice dd 0
x_pixel dd 0
y_pixel dd 0

arg1 EQU 8  ; simbolul de afisat (litera sau cifra)
arg2 EQU 12 ; pointer la vectorul de pixeli
arg3 EQU 16 ; pos_x
arg4 EQU 20 ; pos_y

symbol_width EQU 10
symbol_height EQU 20
include digits.inc
include letters.inc

.code
;colorare matrice
colorare_matrice macro
local parcurgere, comparare, verificare, actualizare, sfarsit, loc_liber, labirint, sarpe, mancare_buna, mancare_proasta
	pusha
	lea esi, matrice
	mov ecx, 400
	mov edx, mancarex
	mov byte ptr[esi+edx],3
	mov edx, mancarey
	mov byte ptr[esi+edx],4
parcurgere:
comparare:
	mov al, byte ptr[esi]
	cmp al, 0
	je loc_liber
	cmp al, 1
	je labirint
	cmp al, 2
	je sarpe
	cmp al, 3
	je mancare_buna
	cmp al, 4
	je mancare_proasta
	jmp sfarsit
loc_liber:
	colorare_patrat x_pixel,y_pixel,len,066ffffh,contor
	jmp verificare
labirint:
	colorare_patrat x_pixel,y_pixel,len,0h,contor
	jmp verificare
sarpe:
	; imi stric esi ul in initializarea sarpelui asa ca tin minte esi ul matricii in edx
	mov edx, esi
	initializare_vector_sarpe dword ptr[x_pixel], dword ptr[y_pixel]
	mov esi, edx
	mov bl, 0
	mov byte ptr[esi], bl
	jmp verificare
mancare_buna:
	colorare_patrat x_pixel,y_pixel,len,0ffff00h,contor
	jmp verificare
mancare_proasta:
	colorare_patrat x_pixel,y_pixel,len,0ff00ffh,contor
	jmp verificare
verificare:
	add x_matrice, 1
	dec ecx
	inc esi
	add x_pixel, 40
	cmp ecx, 0
	je sfarsit
	cmp x_matrice,20
	je actualizare
	jmp comparare 
actualizare:
	mov x_matrice, 0
	add y_matrice, 1
	add y_pixel, 40 
	mov x_pixel, 0
	jmp comparare
sfarsit:
	mov x_matrice, 0
	mov y_matrice, 0
	mov x_pixel, 0
	mov y_pixel, 0
	popa
endm

recolorare_matrice macro
local parcurgere, comparare, verificare, actualizare, sfarsit, loc_liber, labirint, mancare_buna,mancare_proasta
	pusha
	lea esi, matrice
	mov ecx, 400
parcurgere:
comparare:
	mov bl, byte ptr[esi]
	cmp bl, 0
	je loc_liber
	cmp bl, 1
	je labirint
	cmp bl, 3
	je mancare_buna
	cmp bl, 4
	je mancare_proasta
	jmp sfarsit
loc_liber:
	colorare_patrat x_pixel,y_pixel,len,066ffffh,contor
	jmp verificare
labirint:
	colorare_patrat x_pixel,y_pixel,len,0h,contor
	jmp verificare
mancare_buna:
	colorare_patrat x_pixel,y_pixel,len,0ffff00h,contor
	jmp verificare
mancare_proasta:
	colorare_patrat x_pixel,y_pixel,len,0ff00ffh,contor
	jmp verificare
verificare:
	add x_matrice, 1
	dec ecx
	inc esi
	add x_pixel, 40
	cmp ecx, 0
	je sfarsit
	cmp x_matrice,20
	je actualizare
	jmp comparare 
actualizare:
	mov x_matrice, 0
	add y_matrice, 1
	add y_pixel, 40 
	mov x_pixel, 0
	jmp comparare
sfarsit:
	mov x_matrice, 0
	mov y_matrice, 0
	mov x_pixel, 0
	mov y_pixel, 0
	popa
endm

;linii trasate
;linie verticala in jos
line_vertical_down macro x,y,len,color,contor
local bucla_coloana
	pushad
	mov eax, 0
	mov eax, y
	add eax, contor
	mov ebx, area_width
	mul ebx
	add eax, x
	add eax, contor
	shl eax, 2
	add eax, area
	mov ecx, len
	sub ecx, contor
bucla_coloana:
	mov dword ptr[eax], color
	mov ebx, area_width
	shl ebx, 2
	add eax, ebx
	loop bucla_coloana
	popad
endm

;linie orizontala in dreapta
line_horizontal_right macro x,y,len,color,contor
local bucla_linie
	pushad
	mov eax, y
	add eax, contor
	mov ebx, area_height
	mul ebx
	add eax, x
	add eax, contor
	shl eax, 2
	add eax, area
	mov ecx, len
	sub ecx, contor
bucla_linie:
	mov dword ptr[eax], color
	add eax, 4
	loop bucla_linie
	popad
endm

;colorarea unui patrat
colorare_patrat macro a,b,len,color,contor
local bucla_patrat
	pusha
bucla_patrat:
	line_horizontal_right a, b, len, color,contor
	line_vertical_down a, b, len, color,contor
	add contor, 1
	mov edx, len
	cmp contor, edx
	jne bucla_patrat
	mov contor, 0
	popa
endm

;generare random de coordonate x, y 
random_coordinate macro x
	pusha
	mov eax, 320
	mov edx, 0
	mov interval, eax
	rdtsc
	mov edx, 0
	div interval
	add edx, 80
	mov x, edx
	popa
endm

;directie/miscarea sarpelui
directie_sus macro
local sfarsit
	mov eax, 200
	mov verificare, eax
	mov eax, dword ptr[ebp+arg3]
	cmp eax, verificare
	ja sfarsit
		mov directie, 0
	sfarsit:
endm

miscare_sus macro directie, i
local sfarsit,resetare
	cmp directie, 0
	jne sfarsit
		lea esi, vector
		mov eax, dword ptr[esi+4]
		sub eax, len
		mov ebx, 0
		add ebx, len
		add ebx, len
		cmp eax, ebx
		jb resetare
			actualizare_sarpe dword ptr[esi], eax,lungime_sarpe2
			sub i, 20
			jmp sfarsit
		resetare: ; resetare adica cand trece de partea de sus sa inceapa sa mearga din partea de jos a ecranului
			mov eax, area_height
			sub eax, len
			add i, 320
			actualizare_sarpe dword ptr[esi], eax, lungime_sarpe2
	sfarsit:
endm

directie_jos macro
local sfarsit
	mov eax, area_height
	sub eax, 200
	mov verificare, eax
	mov eax, dword ptr[ebp+arg3]
	cmp eax, verificare
	jb sfarsit
		mov directie, 2
	sfarsit:
endm


miscare_jos macro directie , i
local sfarsit,resetare
	cmp directie, 2
	jne sfarsit
		lea esi, vector
		mov eax, dword ptr[esi+4]
		add eax, len
		mov ebx, area_height
		sub ebx, len
		cmp eax, ebx
		ja resetare
			actualizare_sarpe dword ptr[esi], eax,lungime_sarpe2
			add i, 20
			jmp sfarsit
		resetare:
			mov eax, 0
			add eax, len
			add eax, len
			sub i, 320
			actualizare_sarpe dword ptr[esi], eax,lungime_sarpe2
	sfarsit:
endm

directie_stanga macro
local sfarsit
	mov eax, 200
	mov verificare, eax
	mov eax, dword ptr[ebp+arg2]
	cmp eax, verificare
	ja sfarsit
	mov directie, 3
	sfarsit:
endm

miscare_stanga macro directie, i
local sfarsit
	cmp directie, 3
	jne sfarsit
		lea esi,vector
		mov eax, dword ptr[esi]
		cmp eax, 0
		je resetare
			sub eax, len
			actualizare_sarpe eax, dword ptr[esi+4],lungime_sarpe2
			sub i, 1
			jmp sfarsit
		resetare:
			mov eax, 800
			actualizare_sarpe eax, dword ptr[esi+4],lungime_sarpe2
			add i, 20
			jmp sfarsit
	sfarsit:
endm

directie_dreapta macro
local sfarsit
	mov eax, area_width
	sub eax, 200
	mov verificare, eax
	mov eax, dword ptr[ebp+arg2]
	cmp eax, verificare
	jb sfarsit
	mov directie, 1
	sfarsit:
endm

miscare_dreapta macro directie, i
local sfarsit,resetare
	cmp directie, 1
	jne sfarsit
		lea esi,vector
		mov eax, dword ptr[esi]
		cmp eax, 800
		je resetare
			add eax, len
			actualizare_sarpe eax, dword ptr[esi+4],lungime_sarpe2
			add i, 1
			jmp sfarsit
		resetare:
			mov eax, 0
			actualizare_sarpe eax, dword ptr[esi+4],lungime_sarpe2
			sub i,20
			jmp sfarsit
	sfarsit:
endm

;initializarea vectorului cu cele 2 coordonate pentru sarpe
initializare_vector_sarpe macro a,b
	lea esi, vector
	mov eax, a
	mov dword ptr[esi], eax
	mov ebx, b
	mov dword ptr[esi+4], ebx
	add eax, len
	mov dword ptr[esi+8], eax
	mov dword ptr[esi+12],ebx
	add eax, len
	mov dword ptr[esi+16], eax
	mov dword ptr[esi+20],ebx
endm

actualizare_sarpe macro a,b,lungime_sarpe2
local eticheta,sfarsit,colorare
	pushad
	lea esi, vector
	mov ebx, lungime_sarpe
	mov ecx, lungime_sarpe
	sub ecx, 4
	colorare_patrat dword ptr[esi+ecx], dword ptr[esi+ebx],len,066ffffh,contor
	mov edx, lungime_sarpe
eticheta:
		sub edx, 8
		mov ebx, dword ptr[esi+edx]
		mov dword ptr[esi+edx+8], ebx
		add edx, 4
		dec lungime_sarpe2
		cmp lungime_sarpe2, 0
		jne eticheta
	lea esi, vector
	mov edx, a
	mov dword ptr[esi], edx
	mov edx, b
	mov dword ptr[esi+4], edx
	mov edx, lungime_sarpe2_nou
	mov lungime_sarpe2,edx
	mov edx, lungime_sarpe
colorare:
	lea esi,vector
	mov ecx, parcurgere_vector
	mov ebx, parcurgere_vector
	add ebx, 4
	colorare_patrat dword ptr[esi+ecx], dword ptr[esi+ebx],len,0ff0000h,contor
	add ebx, 4
	mov parcurgere_vector, ebx
	cmp edx, ebx
	jb sfarsit
	jmp colorare
sfarsit:
	mov parcurgere_vector,0
	popad
endm

;la mancat trebuie verificat daca si ambele coordonate x,y sunt egale pentru ca toate coordonate x sunt egale cand sarpele e orizontal si toate coordonatele y sunt egale cand sarpele e vertical
mancat macro
local continua,sfarsit1,sfarsit2,coordx,actualizare
	lea esi, vector
	mov ecx, lungime_sarpe
	mov edx, dword ptr[esi+ecx] ;y
	sub ecx, 4
	mov eax, dword ptr[esi+ecx] ;x
	mov ebx, 0
continua:
	sub ecx, 4
	cmp edx, dword ptr[esi+ecx]
	je coordx
	cmp ecx, ebx
	je sfarsit2
	jmp actualizare
coordx:
	sub ecx, 4
	cmp eax, dword ptr[esi+ecx]
	je sfarsit1
	cmp ecx, ebx
	je sfarsit2
	jmp continua
actualizare:
	sub ecx, 4
	cmp ecx, ebx
	je sfarsit2
	jmp continua
sfarsit1:
	mov eax, 1
	mov mancat_sarpe, eax
sfarsit2:
endm

crestere_sarpe macro 
	mov ebx, lungime_sarpe
	add ebx, 8
	mov lungime_sarpe, ebx
	mov lungime_sarpe_nou, ebx
	mov ebx, lungime_sarpe2
	add ebx, 2
	mov lungime_sarpe2, ebx
	mov lungime_sarpe2_nou, ebx
endm

scad_sarpe macro 
	mov ebx, lungime_sarpe_nou
	sub ebx, 8
	mov lungime_sarpe, ebx
	mov lungime_sarpe_nou, ebx
	mov ebx, lungime_sarpe2_nou
	sub ebx, 2
	mov lungime_sarpe2, ebx
	mov lungime_sarpe2_nou, ebx
endm

generare_mancare macro mancarex, i
	pusha
	lea esi,matrice
	mov edx, i
	mov byte ptr[esi+edx], 0
	mov edx, mancarex
	mov al, byte ptr[esi+edx]
	cmp al, 1
	je iar
iar:
	random_coordinate mancarex
	mov edx, mancarex
	mov byte ptr[esi+edx],3
	popa
endm

generare_mancare_proasta macro mancarey, i
	pusha
	lea esi,matrice
	mov edx, i
	mov byte ptr[esi+edx], 0
	mov edx, mancarey
	mov byte ptr[esi+edx],4
	popa
endm

fereastra macro
	pusha
	mov eax, 800
	mov ebx, 800
	mul ebx
	shl eax, 2
	push eax
	push 255
	push area
	call memset
	add esp, 12
	popa
	mov eax, 0
	mov ebx, 0
endm

make_text proc
	push ebp
	mov ebp, esp
	pusha
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 0FFFFFFh
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp
; un macro ca sa apelam mai usor desenarea simbolului
make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm
; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click)
; arg2 - x
; arg3 - y
draw proc
	push ebp
	mov ebp, esp
	pusha
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz evt_timer ; nu s-a efectuat click pe nimic
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 255
	push area
	call memset
	add esp, 16
	;colorarea matricei
	random_coordinate mancarex
	random_coordinate mancarey
	colorare_matrice
	jmp afisare_litere
	
evt_click:	
	;aceste 4 functii dau variabilei directie valorile 0/1/2/3
	directie_stanga
	directie_dreapta
	directie_sus
	directie_jos
	jmp afisare_litere
scorplus:
	inc scor
	random_coordinate mancarex   ; linia 233
	generare_mancare mancarex, i ; linina 443
	crestere_sarpe 
	fereastra
	recolorare_matrice
	jmp afisare_litere
scorminus:
	dec scor
	random_coordinate mancarey
	generare_mancare_proasta mancarey, i
	scad_sarpe
	fereastra
	recolorare_matrice
	jmp afisare_litere
evt_timer:
	;miscarea liniilor in functie de directie
	inc counter
	miscare_stanga directie, i
	miscare_dreapta directie, i
	miscare_sus directie, i
	miscare_jos directie, i
	cmp scor,10
	je final
	cmp scor, 10 ; asta cand scorul este 0 si mananci o bucata de mancare proasta
	ja final
	lea esi, matrice
	mov edx, i
	mov al, byte ptr[esi+edx]
	cmp al, 1
	je final
	cmp al, 3
	je scorplus
	cmp al, 4 
	je scorminus
	cmp counter, 1
	ja serpic
	jmp afisare_litere
serpic:
	mancat
	cmp mancat_sarpe, 1
	je final
afisare_litere:
	make_text_macro 'S', area, 355, 30
	make_text_macro 'C', area, 365, 30
	make_text_macro 'O', area, 375, 30
	make_text_macro 'R', area, 385, 30
	make_text_macro 'E', area, 395, 30
	
	mov ebx, 10
	mov eax, scor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 425, 30
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 415, 30

	make_text_macro 'S', area, 380, 0
	make_text_macro 'N', area, 390, 0
	make_text_macro 'A', area, 400, 0
	make_text_macro 'K', area, 410, 0
	make_text_macro 'E', area, 420, 0
	
final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
final:
	push 0
	call exit
draw endp
start:
	;alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	;terminarea programului
	push 0
	call exit
end start
