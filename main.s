// Tarea 3, Lab Arqui 1B, Kristhoper Ucelo, 202502428

.global _start

.data 
.align 3                      // Alinea la memoria a bloques de 8 bytes

NumsTotal:   .quad 10
NumsB:       .quad 91, 12, 99, 45, 3, 36, 15, 70, 78, 2 //Números para Bubble Sort
NumsS:       .quad 50, 80, 45, 63, 30, 74, 23, 48, 67, 2  // Números para Selection Sort

msg_bubble:    .asciz "- - BUBBLE SORT - -\n"
msg_selection: .asciz "- - SELECTION SORT - -\n"

Espacio:     .asciz " "
Linea:       .asciz "\n"

.text 

_start:
    // --- BUBBLE SORT ---
    mov x0, #1                // Salida estándar stdout
    ldr x1, =msg_bubble       // Mensaje de cabecera
    mov x2, #20               // Longitud del mensaje
    mov x8, #64               // Syscall write
    svc #0                    

    // Imprimir desordenado
    ldr x0, =NumsB            // Pasa NumsB a x0
    ldr x1, =NumsTotal        // Pasa NumsTotal a x1
    ldr x1, [x1]              
    bl print_array            

    // Ordenar con Bubble Sort
    ldr x0, =NumsB            
    ldr x1, =NumsTotal        
    ldr x1, [x1]              
    bl bubble_sort            

    // Imprimir ordenado
    ldr x0, =NumsB            
    ldr x1, =NumsTotal        
    ldr x1, [x1]              
    bl print_array            

    // --- SELECTION SORT ---
    mov x0, #1                
    ldr x1, =msg_selection    
    mov x2, #23               // Longitud del mensaje
    mov x8, #64               
    svc #0                    

    // Imprimir desordenado
    ldr x0, =NumsS            // Pasa NumsS a x0
    ldr x1, =NumsTotal        
    ldr x1, [x1]              
    bl print_array            

    // Ordenar con Selection Sort
    ldr x0, =NumsS            
    ldr x1, =NumsTotal        
    ldr x1, [x1]              
    bl selection_sort         

    // Imprimir ordenado
    ldr x0, =NumsS            
    ldr x1, =NumsTotal        
    ldr x1, [x1]              
    bl print_array            

    // Salir del programa
    mov x0, #0                // Código de retorno 0
    mov x8, #93               // Syscall exit
    svc #0                    

// FUNCIONES AUXILIARES

// Imprime un número entero de 64 bits convertido a ASCII
print_num:
    stp x29, x30, [sp, #-64]!  // Guarda Frame Pointer y Link Register en Stack
    mov x29, sp               
    stp x19, x20, [sp, #16]   // Preserva x19 y x20

    mov x19, x0               // Número a imprimir
    add x20, x29, #63         // Buffer en stack
    mov w2, #10               // Base 10
    strb wzr, [x20]           // Fin de cadena '\0'

convert_loop:
    udiv x3, x19, x2          // x3 = x19 / 10
    msub x4, x3, x2, x19      // x4 = residuo
    add w4, w4, #'0'          // ASCII
    sub x20, x20, #1          
    strb w4, [x20]            
    mov x19, x3               
    cbnz x19, convert_loop    

    mov x0, #1                
    mov x1, x20               
    add x2, x29, #63          
    sub x2, x2, x20           
    mov x8, #64               // Syscall write
    svc #0                    

    ldp x19, x20, [sp, #16]   // Restaura x19 y x20
    ldp x29, x30, [sp], #64   // Libera Stack Frame
    ret                       

// Imprime todos los elementos del arreglo separados por espacio
print_array:
    stp x29, x30, [sp, #-32]!  
    mov x29, sp               
    stp x19, x20, [sp, #16]   

    mov x19, x0               // Dirección del arreglo
    mov x20, x1               // Total elementos

print_loop:
    cbz x20, print_done       
    ldr x0, [x19]             
    bl print_num              

    // Imprimir espacio
    mov x0, #1                
    ldr x1, =Espacio          
    mov x2, #1                
    mov x8, #64               
    svc #0                    

    add x19, x19, #8          // Siguiente elemento (8 bytes)
    sub x20, x20, #1          
    b print_loop              

print_done:
    // Imprimir salto de línea
    mov x0, #1                
    ldr x1, =Linea            
    mov x2, #1                
    mov x8, #64               
    svc #0                    

    ldp x19, x20, [sp, #16]   
    ldp x29, x30, [sp], #32   
    ret                       

// ALGORITMOS DE ORDENAMIENTO

// BUBBLE SORT
bubble_sort:
    stp x29, x30, [sp, #-48]!  
    mov x29, sp               
    stp x19, x20, [sp, #16]   
    stp x21, x22, [sp, #32]   

    mov x19, x0               // Dirección base
    mov x20, x1               // Tamaño N
    cmp x20, #1               
    ble bubble_done           

    sub x21, x20, #1          // i = N - 1

bubble_outer:
    mov x22, #0               // j = 0

bubble_inner:
    cmp x22, x21              
    b.ge bubble_next_outer    

    lsl x2, x22, #3           
    add x3, x19, x2           
    ldr x4, [x3]              // NumsB[j]
    ldr x5, [x3, #8]          // NumsB[j+1]

    cmp x4, x5                
    ble no_swap_bubble        

    // Swap (Intercambio)
    str x5, [x3]              
    str x4, [x3, #8]          

no_swap_bubble:
    add x22, x22, #1          // j++
    b bubble_inner            

bubble_next_outer:
    sub x21, x21, #1          // i--
    cbnz x21, bubble_outer    

bubble_done:
    ldp x21, x22, [sp, #32]   
    ldp x19, x20, [sp, #16]   
    ldp x29, x30, [sp], #48   
    ret                       

// SELECTION SORT
selection_sort:
    stp x29, x30, [sp, #-48]!  
    mov x29, sp               
    stp x19, x20, [sp, #16]   
    stp x21, x22, [sp, #32]   

    mov x19, x0               // Dirección base
    mov x20, x1               // Tamaño N
    cmp x20, #1               
    ble selection_done        

    mov x21, #0               // i = 0
    sub x22, x20, #1          // N - 1

sel_outer:
    cmp x21, x22              
    b.ge selection_done       

    mov x2, x21               
    add x3, x21, #1           // j = i + 1

sel_inner:
    cmp x3, x20               
    b.ge sel_swap             

    lsl x4, x3, #3            
    add x5, x19, x4           
    ldr x6, [x5]              // NumsS[j]

    lsl x7, x2, #3            // Offset min_idx
    add x8, x19, x7           
    ldr x9, [x8]              // NumsS[min_idx]

    cmp x6, x9                
    b.ge sel_next_inner       
    mov x2, x3                

sel_next_inner:
    add x3, x3, #1            // j++
    b sel_inner               

sel_swap:
    cmp x2, x21               
    beq sel_next_outer        

    // Swap
    lsl x4, x21, #3           
    add x5, x19, x4           
    ldr x6, [x5]              

    lsl x7, x2, #3            
    add x8, x19, x7           
    ldr x9, [x8]              

    str x9, [x5]              
    str x6, [x8]              

sel_next_outer:
    add x21, x21, #1          // i++
    b sel_outer               

selection_done:
    ldp x21, x22, [sp, #32]   
    ldp x19, x20, [sp, #16]   
    ldp x29, x30, [sp], #48   
    ret

