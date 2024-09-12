    global crc16
    global swap16

crc_update:
    endbr64
    push   %rbp
    mov    %rsp,%rbp
    mov    %edi,%eax
    mov    %esi,-0x18(%rbp)
    mov    %ax,-0x14(%rbp)
    movzwl -0x14(%rbp),%eax
    shr    $0xf,%ax
    mov    %ax,-0x2(%rbp)
    movzwl -0x14(%rbp),%eax
    add    %eax,%eax
    mov    %ax,-0x4(%rbp)
    cmpl   $0x0,-0x18(%rbp)
    je     _13e1
    movzwl -0x4(%rbp),%eax
    add    $0x1,%eax
    mov    %ax,-0x4(%rbp)
_13e1:
    cmpw   $0x0,-0x2(%rbp)
    je     _13ee
    xorw   $0x1021,-0x4(%rbp)
_13ee:
    movzwl -0x4(%rbp),%eax
    pop    %rbp
    ret

crc16:
    endbr64
    push   %rbp
    mov    %rsp,%rbp
    sub    $0x20,%rsp
    mov    %rdi,-0x18(%rbp)
    mov    %esi,%eax
    mov    %ax,-0x1c(%rbp)
    movw   $0x0,-0x4(%rbp)
    jmp    _1456 <crc16+0x62>
_1412:
    movw   $0x80,-0x2(%rbp)
    jmp    _143f <crc16+0x4b>
_141a:
    mov    -0x18(%rbp),%rax
    movzbl (%rax),%eax
    movzbl %al,%edx
    movzwl -0x2(%rbp),%eax
    and    %eax,%edx
    movzwl -0x4(%rbp),%eax
    mov    %edx,%esi
    mov    %eax,%edi
    call   crc_update
    mov    %ax,-0x4(%rbp)
    shrw   $1,-0x2(%rbp)
_143f:
    cmpw   $0x0,-0x2(%rbp)
    jne    _141a
    movzwl -0x1c(%rbp),%eax
    sub    $0x1,%eax
    mov    %ax,-0x1c(%rbp)
    addq   $0x1,-0x18(%rbp)
_1456:
    cmpw   $0x0,-0x1c(%rbp)
    jne    _1412
    movw   $0x0,-0x2(%rbp)
    jmp    _1484
_1465:
    movzwl -0x4(%rbp),%eax
    mov    $0x0,%esi
    mov    %eax,%edi
    call   crc_update
    mov    %ax,-0x4(%rbp)
    movzwl -0x2(%rbp),%eax
    add    $0x1,%eax
    mov    %ax,-0x2(%rbp)
_1484:
    cmpw   $0xf,-0x2(%rbp)
    jbe    _1465
    movzwl -0x4(%rbp),%eax
    leave
    ret

swap16:
    endbr64
    push   %rbp
    mov    %rsp,%rbp
    mov    %edi,%eax
    mov    %ax,-0x4(%rbp)
    movzwl -0x4(%rbp),%eax
    shr    $0x8,%ax
    mov    %eax,%edx
    movzwl -0x4(%rbp),%eax
    shl    $0x8,%eax
    or     %edx,%eax
    pop    %rbp
    ret

