.intel_syntax noprefix
.globl _start

.section .text


_start:
    # fd = socket(AF_INET, SOCK_STREAM, 0)
    mov rax, 41          # syscall number for socket
    mov rdi, 2           # AF_INET
    mov rsi, 1           # SOCK_STREAM
    mov rdx, 0           # protocol (0 means default)
    syscall

    # Save the file descriptor returned by socket
    mov rbx, rax

    # bind(fd, &ipv4_sockaddr, 16)
    mov rax, 49          # syscall number for bind
    mov rdi, rbx         # file descriptor returned by socket
    mov rsi, OFFSET Path  # pointer to the sockaddr_in structure
    mov rdx, 16          # size of the sockaddr_in structure
    syscall

    #listen(fd, backlog)
    mov rax,50
    mov rdi , rbx
    mov rsi , 0
    syscall

    #client_fd = accept(fd,sockaddr,addrlen)
    mov rax,43
    mov rdi,rbx
    mov rsi,0
    mov rdx,0
    syscall
    

    mov rsp, rax


    #client : Gimme_<file>_client_<version>\n

    #read(client_fd,read_request,read_request_count)
    mov rax,0
    mov rdi,rsp #client_fd
    mov rsi,OFFSET BUFF_TO_DO 
    mov rdx,256
    syscall

    #server : Herw_you_go\n<content>

    #wirte(client_fd,"SERVER: Hey see MF we are connected\n",36)

    mov rax,1
    mov rdi,rsp
    mov rsi,OFFSET server_response
    mov rdx, 19
    syscall


    #close(client_fd)
    mov rax,3
    mov rdi , rsp
    syscall

    # Exit the program
    mov rdi, 0
    mov rax, 60          # SYS_exit
    syscall


.section .data

Path:
    .short 2             # sin_family (AF_INET)
    .short 0x5000        # sin_port (port number in network byte order, e.g., 80)
    .int 0               # sin_addr (IP address in network byte order, e.g., 0.0.0.0)

server_response:
        .ascii "HTTP/1.0 200 OK\r\n\r\n"
BUFF_TO_DO:
        .space 256, 0x00
