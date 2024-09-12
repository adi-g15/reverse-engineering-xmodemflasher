/*Don't delete, this has some comments*/

/home/adityag/.arduino15/packages/vega/tools/vegaflasher/002/xmodemflasher:     file format elf64-x86-64

/*removed crc16, and swap16*/

00000000000014b4 <xymodem_send>:
    14b4:	endbr64
    14b8:	push   %rbp
    14b9:	mov    %rsp,%rbp
    14bc:	sub    $0x180,%rsp
    /*considering mov, will use higher bytes, let's say storing %edi at
     * -174, then it will write -174,-173,-172,-171 bytes */

    /* -0x164(rbp) = fd (don't know, but since used edi, maybe 4 bytes) */
    /* -0x170(rbp) = filename (maybe 8 bytes) */
    /* -0x168(rbp) = 3rd argument (maybe 4 bytes) */
    /* -0x174(rbp) = 4th argument (maybe 4 bytes) */
    /*above sizes also make sense according to which register was used in the mov*/

    /*Argument passing in x86_64:
     * 1. rdi
     * 2. rsi 
     * 3. rdx
     * 4. rcx
     * 5. r8d
     * 6. r9d
     *
     *Return value is stored in %eax
     */

    /*
     (gdb) info reg rdi rsi rdx rcx
      rdi            0x3                 3 (most probably fd)
      rsi            0x7fffffffddbc      140737488346556 ("/tmp/arduino/sketches/7BFB521CD2C948FD7BE4FC9C74B47FE0/FirstSketch.ino.bin")
      rdx            0x0                 0
      rcx            0x1                 1
     */
    14c3:	mov    %edi,-0x164(%rbp)
    14c9:	mov    %rsi,-0x170(%rbp)
    14d0:	mov    %edx,-0x168(%rbp)
    14d6:	mov    %ecx,-0x174(%rbp)
    14dc:	mov    %fs:0x28,%rax
    14e3:
    14e5:	mov    %rax,-0x8(%rbp)
    14e9:	xor    %eax,%eax
    14eb:	movb   $0x4,-0x15a(%rbp)
    14f2:	movl   $0x0,-0x158(%rbp)
    14f9:
    
    /* opening a filename, with mode=0 (ie. O_RDONLY)*/
    14fc:	mov    -0x170(%rbp),%rax
    1503:	mov    $0x0,%esi
    1508:	mov    %rax,%rdi
    150b:	mov    $0x0,%eax
    1510:	call   1280 <open@plt>


    /* error case: start */
    1515:	mov    %eax,-0x150(%rbp)
    151b:	cmpl   $0x0,-0x150(%rbp)
    1522:	jns    153e <xymodem_send+0x8a>
    1524:	lea    0xadd(%rip),%rdi        # 2008 <_IO_stdin_used+0x8>
    152b:	call   12a0 <perror@plt>
    1530:	call   1190 <__errno_location@plt>
    1535:	mov    (%rax),%eax
    1537:	neg    %eax
    1539:	jmp    19df <xymodem_send+0x52b>
    /* error case: end */

    /* -0x150(%rbp) = sketch_bin's/filename's fd */
    /* -0xa0(%rbp) = local variable (struct stat *statbuf), passed to fstat */
    153e:	lea    -0xa0(%rbp),%rdx
    1545:	mov    -0x150(%rbp),%eax
    154b:	mov    %rdx,%rsi
    154e:	mov    %eax,%edi
    1550:	call   1d00 <__fstat>

    /* -0x70(%rbp) = -0x148(%rbp) = 0xb60 = statbuf.st_size (1292 byte) */
    1555:	mov    -0x70(%rbp),%rax
    1559:	mov    %rax,-0x148(%rbp)
    1560:	mov    -0x150(%rbp),%edx
    1566:	mov    -0x148(%rbp),%rax
    156d:	mov    $0x0,%r9d
    1573:	mov    %edx,%r8d
    1576:	mov    $0x2,%ecx
    157b:	mov    $0x1,%edx
    1580:	mov    %rax,%rsi
    1583:	mov    $0x0,%edi
    1588:	call   11f0 <mmap@plt>

    /* -0x140(%rbp) = return address by mmap = sketch_content */
    158d:	mov    %rax,-0x140(%rbp)
    1594:	cmpq   $0x0,-0x140(%rbp)
    159b:
    159c:	jne    15b8 <xymodem_send+0x104>

    /* error case: start */
    159e:	lea    0xa68(%rip),%rdi        # 200d <_IO_stdin_used+0xd>
    15a5:	call   12a0 <perror@plt>
    15aa:	call   1190 <__errno_location@plt>
    15af:	mov    (%rax),%eax
    15b1:	neg    %eax
    15b3:	jmp    19df <xymodem_send+0x52b>
    /* error case: end */

    /* some jump based on arg4 */
    15b8:	cmpl   $0x0,-0x174(%rbp)
    15bf:	je     1696 <xymodem_send+0x1e2>

    /* some flush */
    15c5:	mov    0x2a44(%rip),%rax        # 4010 <stdout@GLIBC_2.2.5>
    15cc:	mov    %rax,%rdi
    15cf:	call   1240 <fflush@plt>

    /* -164(%rbp) = input fd (device fd) */
    /* -15d(%rbp) = buffer */
    /* edx = 1 = count */
    15d4:	lea    -0x15d(%rbp),%rcx
    15db:	mov    -0x164(%rbp),%eax
    15e1:	mov    $0x1,%edx
    15e6:	mov    %rcx,%rsi
    15e9:	mov    %eax,%edi
    15eb:	call   1220 <read@plt>

    15f0:	mov    %eax,-0x14c(%rbp)
    15f6:	lea    -0x15c(%rbp),%rcx
    15fd:	mov    -0x164(%rbp),%eax
    1603:	mov    $0x1,%edx
    1608:	mov    %rcx,%rsi
    160b:	mov    %eax,%edi
    160d:	call   1220 <read@plt>

    1612:	mov    %eax,-0x14c(%rbp)
    1618:	lea    -0x15b(%rbp),%rcx
    161f:	mov    -0x164(%rbp),%eax
    1625:	mov    $0x1,%edx
    162a:	mov    %rcx,%rsi
    162d:	mov    %eax,%edi
    162f:	call   1220 <read@plt>

    /* return value checking if read 1 byte or not */
    1634:	mov    %eax,-0x14c(%rbp)
    163a:	cmpl   $0x1,-0x14c(%rbp)
    1641:	je     165d <xymodem_send+0x1a9>

    /* error case: start */
    1643:	lea    0x9c8(%rip),%rdi        # 2012 <_IO_stdin_used+0x12>
    164a:	call   12a0 <perror@plt>
    164f:	call   1190 <__errno_location@plt>
    1654:	mov    (%rax),%eax
    1656:	neg    %eax
    1658:	jmp    19df <xymodem_send+0x52b>
    /* error case: end */

    /* load each of the 3 bytes in buffer, one by one */
    /* if any of the 3 bytes is not 'C', jump back to the loop to read all
     * 3 values*/
    165d:	movzbl -0x15d(%rbp),%eax
    1664:	cmp    $0x43,%al
    1666:	jne    15d4 <xymodem_send+0x120>
    166c:	movzbl -0x15c(%rbp),%eax
    1673:	cmp    $0x43,%al
    1675:	jne    15d4 <xymodem_send+0x120>
    167b:	movzbl -0x15b(%rbp),%eax
    1682:	cmp    $0x43,%al
    1684:	jne    15d4 <xymodem_send+0x120>

    /* now, first 3 values in buffer are 'C' */
    /* 0x986(%rip) is string "done." */
    168a:	lea    0x986(%rip),%rdi        # 2017 <_IO_stdin_used+0x17>
    1691:	call   11b0 <puts@plt>

    /*-0x170(%rbp) was the filename*/
    1696:	mov    -0x170(%rbp),%rax
    169d:	mov    %rax,%rsi
    /* 0x976(%rip) is "Uploading %s", so basically a format string for
     * printf, and argument will be the filename */
    16a0:	lea    0x976(%rip),%rdi        # 201d <_IO_stdin_used+0x1d>
    16a7:	mov    $0x0,%eax
    16ac:	call   1200 <printf@plt>

    /* jump somewhere if arg3 (-168(%rbp)) is NOT 0x1 */
    16b1:	cmpl   $0x1,-0x168(%rbp)
    16b8:	jne    16ef <xymodem_send+0x23b>

    /* -0x130(%rbp) seems to be a buffer of size 128 (0x80), as it
     * and size is passed to strncpy */
    16ba:	mov    -0x170(%rbp),%rax
    16c1:	lea    -0x130(%rbp),%rdx
    16c8:	lea    0x3(%rdx),%rcx
    16cc:	mov    $0x80,%edx
    16d1:	mov    %rax,%rsi
    16d4:	mov    %rcx,%rdi
    16d7:	call   11a0 <strncpy@plt>
    16dc:	movb   $0x0,-0x12f(%rbp)
    16e3:	movl   $0x1,-0x158(%rbp)
    16ea:
    16ed:	jmp    16f6 <xymodem_send+0x242>
    16ef:	movb   $0x1,-0x12f(%rbp)
    16f6:	movb   $0x1,-0x130(%rbp)
    16fd:	jmp    1915 <xymodem_send+0x461>

    1702:	movq   $0x0,-0x138(%rbp)
    1709:
    170d:	movl   $0x0,-0x154(%rbp)
    1714:
    1717:	cmpl   $0x0,-0x158(%rbp)
    171e:	jne    1796 <xymodem_send+0x2e2>

    /* this basically will chose 0x80 or -0x148(%rbp) into $rax, whichever
     * is lower */
    1720:	mov    $0x80,%eax
    1725:	cmpq   $0x80,-0x148(%rbp)    /*(-0x148(%rbp) compared with 0x80)*/
    172c:
    1730:	cmovbe -0x148(%rbp),%rax
    1737:
    1738:	mov    %rax,-0x138(%rbp)
    /* -0x138(%rbp), maybe 'block_size' ? minimum of filesize and 0x80 */
    173f:	mov    -0x138(%rbp),%rdx
    /* -0x140(%rbp) = sketch_content */
    1746:	mov    -0x140(%rbp),%rax
    /* -0x130(%rbp) = buffer[0x80] */
    174d:	lea    -0x130(%rbp),%rcx
    1754:	add    $0x3,%rcx
    1758:	mov    %rax,%rsi
    175b:	mov    %rcx,%rdi
    /*3rd argument (size) passed to memcpy is 128, while buffer also is
     * shifted by 3, does it mean it's size should atleast be 131 ?*/
    175e:	call   1230 <memcpy@plt>
    1763:	mov    $0x80,%eax
    1768:	sub    -0x138(%rbp),%rax
    176f:	lea    -0x130(%rbp),%rdx
    1776:	lea    0x3(%rdx),%rcx
    177a:	mov    -0x138(%rbp),%rdx
    1781:	add    %rdx,%rcx
    1784:	mov    %rax,%rdx
    1787:	mov    $0xff,%esi
    178c:	mov    %rcx,%rdi
    178f:	call   1210 <memset@plt>
    1794:	jmp    17a0 <xymodem_send+0x2ec>
    1796:	movl   $0x0,-0x158(%rbp)
    179d:
    /* pass buffer */
    17a0:	lea    -0x130(%rbp),%rax
    17a7:	add    $0x3,%rax
    17ab:	mov    $0x80,%esi
    17b0:	mov    %rax,%rdi
    17b3:	call   13f4 <crc16>
    17b8:	movzwl %ax,%eax
    17bb:	mov    %eax,%edi
    17bd:	call   1491 <swap16>
    17c2:	mov    %ax,-0xad(%rbp)
    17c9:	movzbl -0x12f(%rbp),%eax
    17d0:	not    %eax
    17d2:	mov    %al,-0x12e(%rbp)
    17d8:	lea    -0x130(%rbp),%rcx
    17df:	mov    -0x164(%rbp),%eax
    17e5:	mov    $0x85,%edx
    17ea:	mov    %rcx,%rsi
    17ed:	mov    %eax,%edi
    17ef:	call   11c0 <write@plt>
    17f4:	mov    %eax,-0x14c(%rbp)
    17fa:	cmpl   $0x85,-0x14c(%rbp)
    1801:
    1804:	je     1814 <xymodem_send+0x360>
    1806:	call   1190 <__errno_location@plt>
    180b:	mov    (%rax),%eax
    180d:	neg    %eax
    180f:	jmp    19df <xymodem_send+0x52b>
    1814:	lea    -0x15d(%rbp),%rcx
    181b:	mov    -0x164(%rbp),%eax
    1821:	mov    $0x1,%edx
    1826:	mov    %rcx,%rsi
    1829:	mov    %eax,%edi
    182b:	call   1220 <read@plt>
    1830:	mov    %eax,-0x14c(%rbp)
    1836:	cmpl   $0x1,-0x14c(%rbp)
    183d:	je     184d <xymodem_send+0x399>
    183f:	call   1190 <__errno_location@plt>
    1844:	mov    (%rax),%eax
    1846:	neg    %eax
    1848:	jmp    19df <xymodem_send+0x52b>
    184d:	movzbl -0x15d(%rbp),%eax
    1854:	movzbl %al,%eax
    1857:	cmp    $0x15,%eax
    185a:	je     186d <xymodem_send+0x3b9>
    185c:	cmp    $0x15,%eax
    185f:	jg     18a6 <xymodem_send+0x3f2>
    1861:	cmp    $0x6,%eax
    1864:	je     1876 <xymodem_send+0x3c2>
    1866:	cmp    $0xf,%eax
    1869:	je     1889 <xymodem_send+0x3d5>
    186b:	jmp    18a6 <xymodem_send+0x3f2>
    186d:	movb   $0x4e,-0x159(%rbp)
    1874:	jmp    18c3 <xymodem_send+0x40f>
    1876:	movb   $0x2e,-0x159(%rbp)
    187d:	movl   $0x1,-0x154(%rbp)
    1884:
    1887:	jmp    18c3 <xymodem_send+0x40f>
    1889:	movb   $0x3f,-0x159(%rbp)
    1890:	lea    0x799(%rip),%rdi        # 2030 <_IO_stdin_used+0x30>
    1897:	call   11b0 <puts@plt>
    189c:	mov    $0x0,%edi
    18a1:	call   12b0 <exit@plt>
    18a6:	movb   $0x3f,-0x159(%rbp)
    18ad:	lea    0x844(%rip),%rdi        # 20f8 <_IO_stdin_used+0xf8>
    18b4:	call   11b0 <puts@plt>
    18b9:	mov    $0x0,%edi
    18be:	call   12b0 <exit@plt>
    18c3:	movsbl -0x159(%rbp),%eax
    18ca:	mov    %eax,%edi
    18cc:	call   1180 <putchar@plt>
    18d1:	mov    0x2738(%rip),%rax        # 4010 <stdout@GLIBC_2.2.5>
    18d8:	mov    %rax,%rdi
    18db:	call   1240 <fflush@plt>
    18e0:	cmpl   $0x0,-0x154(%rbp)
    18e7:	je     1915 <xymodem_send+0x461>
    18e9:	movzbl -0x12f(%rbp),%eax
    18f0:	add    $0x1,%eax
    18f3:	mov    %al,-0x12f(%rbp)
    18f9:	mov    -0x138(%rbp),%rax
    1900:	sub    %rax,-0x148(%rbp)
    1907:	mov    -0x138(%rbp),%rax
    190e:	add    %rax,-0x140(%rbp)
    /* skipping part for now: end */

    1915:	cmpq   $0x0,-0x148(%rbp)
    191c:
    191d:	jne    1702 <xymodem_send+0x24e>

    /* skipping part for now: start */
    1923:	lea    -0x15a(%rbp),%rcx
    192a:	mov    -0x164(%rbp),%eax
    1930:	mov    $0x1,%edx
    1935:	mov    %rcx,%rsi
    1938:	mov    %eax,%edi
    193a:	call   11c0 <write@plt>
    193f:	mov    %eax,-0x14c(%rbp)
    1945:	cmpl   $0x1,-0x14c(%rbp)
    194c:	je     195c <xymodem_send+0x4a8>
    194e:	call   1190 <__errno_location@plt>
    1953:	mov    (%rax),%eax
    1955:	neg    %eax
    1957:	jmp    19df <xymodem_send+0x52b>
    195c:	cmpl   $0x1,-0x168(%rbp)
    1963:	jne    199b <xymodem_send+0x4e7>
    1965:	lea    -0x15a(%rbp),%rcx
    196c:	mov    -0x164(%rbp),%eax
    1972:	mov    $0x1,%edx
    1977:	mov    %rcx,%rsi
    197a:	mov    %eax,%edi
    197c:	call   11c0 <write@plt>
    1981:	mov    %eax,-0x14c(%rbp)
    1987:	cmpl   $0x1,-0x14c(%rbp)
    198e:	je     199b <xymodem_send+0x4e7>
    1990:	call   1190 <__errno_location@plt>
    1995:	mov    (%rax),%eax
    1997:	neg    %eax
    1999:	jmp    19df <xymodem_send+0x52b>
    199b:	lea    0x675(%rip),%rdi        # 2017 <_IO_stdin_used+0x17>
    19a2:	call   11b0 <puts@plt>
    19a7:	mov    -0x164(%rbp),%eax
    19ad:	mov    $0x1,%edx
    19b2:	lea    0x7d9(%rip),%rsi        # 2192 <_IO_stdin_used+0x192>
    19b9:	mov    %eax,%edi
    19bb:	call   11c0 <write@plt>
    19c0:	mov    %eax,-0x14c(%rbp)
    19c6:	cmpl   $0x1,-0x14c(%rbp)
    19cd:	je     19da <xymodem_send+0x526>
    19cf:	call   1190 <__errno_location@plt>
    19d4:	mov    (%rax),%eax
    19d6:	neg    %eax
    19d8:	jmp    19df <xymodem_send+0x52b>
    19da:	mov    $0x0,%eax
    19df:	mov    -0x8(%rbp),%rsi
    19e3:	xor    %fs:0x28,%rsi
    19ea:
    19ec:	je     19f3 <xymodem_send+0x53f>
    19ee:	call   11e0 <__stack_chk_fail@plt>
    19f3:	leave
    19f4:	ret

00000000000019f5 <open_serial>:
    19f5:	endbr64
    19f9:	push   %rbp
    19fa:	mov    %rsp,%rbp
    19fd:	sub    $0x70,%rsp
	/* -0x68(%rbp) is 'const char* filename' */
	/* -0x6c(%rbp) is the second argument */
    1a01:	mov    %rdi,-0x68(%rbp)
    1a05:	mov    %esi,-0x6c(%rbp)
    1a08:	mov    %fs:0x28,%rax
    1a0f:	
    1a11:	mov    %rax,-0x8(%rbp)
    1a15:	xor    %eax,%eax
    1a17:	mov    -0x68(%rbp),%rax
    1a1b:	mov    $0x2,%esi
    1a20:	mov    %rax,%rdi
    1a23:	mov    $0x0,%eax
   /* %rdi has the file name (/dev/ttyUSB0), %rsi has open flags, which is
	* 0x2, means O_RDWR (from man 2 open, and usr/include/bits/fcntl-linux.h) */
    1a28:	call   1280 <open@plt>

	/*this is probably storing the returned value, which is the 'fd', and
	 * checking if it is NULL*/
    1a2d:	mov    %eax,-0x54(%rbp)	/*eax is 0x3 in my case, which is what open syscall also returns*/
    1a30:	cmpl   $0x0,-0x54(%rbp)

    1a34:	jns    1a50 <open_serial+0x5b>

	/*error case: start*/
    1a36:	lea    0x5cb(%rip),%rdi        # 2008 <_IO_stdin_used+0x8>
    1a3d:	call   12a0 <perror@plt>
    1a42:	call   1190 <__errno_location@plt>
    1a47:	mov    (%rax),%eax
    1a49:	neg    %eax
    1a4b:	jmp    1b4c <open_serial+0x157>	/*this jumps to end of function*/
	/*error case: end*/

	/* here, it's probably just zeroing a local variable 'struct termios' */
	/* based on seeing the addresses and values, and a wrong but helpful
	 * conversion from https://www.codeconvert.ai/assembly-to-c-converter */
	/* and also manpage for tcgetattr, where these are used later */
	/* sizeof(struct termio) = 0x3c */
    1a50:	lea    -0x50(%rbp),%rax
    1a54:	mov    $0x3c,%edx
    1a59:	mov    $0x0,%esi
    1a5e:	mov    %rax,%rdi
    1a61:	call   1210 <memset@plt>

	/* -0x54(%rbp) contains the file descriptor */
	/* -0x50(%rbp) contains the 'struct termios' local variable */
	/* so, basically calling tcgetattr(fd, *(struct termios)) */
    1a66:	lea    -0x50(%rbp),%rdx
    1a6a:	mov    -0x54(%rbp),%eax
    1a6d:	mov    %rdx,%rsi
    1a70:	mov    %eax,%edi
    1a72:	call   1260 <tcgetattr@plt>

    1a77:	test   %eax,%eax
    1a79:	je     1a95 <open_serial+0xa0>

	/* error case: start */
    1a7b:	lea    0x712(%rip),%rdi        # 2194 <_IO_stdin_used+0x194>
    1a82:	call   12a0 <perror@plt>
    1a87:	call   1190 <__errno_location@plt>
    1a8c:	mov    (%rax),%eax
    1a8e:	neg    %eax
    1a90:	jmp    1b4c <open_serial+0x157>
	/* error case: end */

	/* rdi = -0x50(%rbp) = fd */
	/* rsi = -0x6c(%rbp) = second argument ('speed' from manpage) */
	/* second argument is 0x1002 in my case (baudrate ?) */
	/* yes, it's a baudrate, and the value is a known constant (B115200),
	 * source: stackoverflow */
    1a95:	mov    -0x6c(%rbp),%edx
    1a98:	lea    -0x50(%rbp),%rax
    1a9c:	mov    %edx,%esi
    1a9e:	mov    %rax,%rdi
    1aa1:	call   11d0 <cfsetospeed@plt>

	/*same args as above*/
    1aa6:	mov    -0x6c(%rbp),%edx
    1aa9:	lea    -0x50(%rbp),%rax
    1aad:	mov    %edx,%esi
    1aaf:	mov    %rax,%rdi
    1ab2:	call   1290 <cfsetispeed@plt>

	/* -0x44(%rbp) is 0x8a21, but what is it ? */
	/* below instructions don't really change anything, because the ANDs
	 * will still keep it as 0x8a21 */
    1ab7:	mov    -0x44(%rbp),%eax
    1aba:	and    $0xfffffffd,%eax
    1abd:	mov    %eax,-0x44(%rbp)
    1ac0:	mov    -0x44(%rbp),%eax
    1ac3:	and    $0xffffffe7,%eax
    1ac6:	mov    %eax,-0x44(%rbp)
    1ac9:	movb   $0x2,-0x39(%rbp)
    1acd:	movb   $0xa,-0x3a(%rbp)

	/* -0x40(%rbp) is 0x1cb2, but what is it ? */
    1ad1:	mov    -0x48(%rbp),%eax
    1ad4:	or     $0x30,%eax
    1ad7:	mov    %eax,-0x48(%rbp)
    1ada:	mov    -0x50(%rbp),%eax
    1add:	and    $0xfffffffe,%eax
    1ae0:	mov    %eax,-0x50(%rbp)
    1ae3:	movl   $0x0,-0x4c(%rbp)
    1aea:	mov    -0x50(%rbp),%eax
    1aed:	and    $0xe3,%ah
    1af0:	mov    %eax,-0x50(%rbp)
    1af3:	mov    -0x48(%rbp),%eax
    1af6:	or     $0x880,%eax
    1afb:	mov    %eax,-0x48(%rbp)
    1afe:	mov    -0x48(%rbp),%eax
    1b01:	and    $0xfc,%ah
    1b04:	mov    %eax,-0x48(%rbp)
    1b07:	mov    -0x48(%rbp),%eax
    1b0a:	and    $0xffffffbf,%eax
    1b0d:	mov    %eax,-0x48(%rbp)
    1b10:	mov    -0x48(%rbp),%eax
    1b13:	and    $0x7fffffff,%eax
    1b18:	mov    %eax,-0x48(%rbp)
    1b1b:	lea    -0x50(%rbp),%rdx
    1b1f:	mov    -0x54(%rbp),%eax
    1b22:	mov    $0x0,%esi
    1b27:	mov    %eax,%edi

	/* takes 3 arguments: %rdi=fd, %rsi=0, %rdx=(struct termios*) */
    1b29:	call   1270 <tcsetattr@plt>
    1b2e:	test   %eax,%eax
    1b30:	je     1b49 <open_serial+0x154>
    1b32:	lea    0x665(%rip),%rdi        # 219e <_IO_stdin_used+0x19e>
    1b39:	call   12a0 <perror@plt>
    1b3e:	call   1190 <__errno_location@plt>
    1b43:	mov    (%rax),%eax
    1b45:	neg    %eax
    1b47:	jmp    1b4c <open_serial+0x157>
    1b49:	mov    -0x54(%rbp),%eax
    1b4c:	mov    -0x8(%rbp),%rcx
    1b50:	xor    %fs:0x28,%rcx
    1b57:	
    1b59:	je     1b60 <open_serial+0x16b>
    1b5b:	call   11e0 <__stack_chk_fail@plt>
    1b60:	leave
    1b61:	ret

0000000000001b62 <dump_serial>:
    1b62:	endbr64
    1b66:	push   %rbp
    1b67:	mov    %rsp,%rbp
    1b6a:	sub    $0x20,%rsp
	/* -0x14(%rbp) = %edi = file descriptor (probably 8 bytes) */
    1b6e:	mov    %edi,-0x14(%rbp)
    1b71:	mov    %fs:0x28,%rax
    1b78:
	/* -0x8(%rbp) = %rax = some thread specific memory (since using %fs) */
    1b7a:	mov    %rax,-0x8(%rbp)
    1b7e:	xor    %eax,%eax
   1b80:	lea    -0x9(%rbp),%rcx
    1b84:	mov    -0x14(%rbp),%eax
    1b87:	mov    $0x1,%edx
    1b8c:	mov    %rcx,%rsi
    1b8f:	mov    %eax,%edi
	/* so %rdi = -0x14(%rbp) = file descriptor (first arg to 'read') */
	/* so %rsi = -0x9(%rbp) = buffer address (should be 0x14-0x9 = 11 bytes?)*/
	/* so %rdx = 0x1 = count to read */
    1b91:	call   1220 <read@plt>
    1b96:	movzbl -0x9(%rbp),%eax
	/* with above, $eax should basically contain 1 byte of buffer's content */
    1b9a:	cmp    $0x3c,%al
	/* jump to end, if read did not give '<' */
    1b9c:	jne    1bc7 <dump_serial+0x65>
    1b9e:	mov    -0x14(%rbp),%eax
    1ba1:	mov    $0x1,%edx
    1ba6:	lea    0x5fb(%rip),%rsi        # 21a8 <_IO_stdin_used+0x1a8>
    1bad:	mov    %eax,%edi
    1baf:	call   11c0 <write@plt>
    1bb4:	nop
    1bb5:	nop
    1bb6:	mov    -0x8(%rbp),%rax
    1bba:	xor    %fs:0x28,%rax
    1bc1:
    1bc3:	je     1bdd <dump_serial+0x7b>
    1bc5:	jmp    1bd8 <dump_serial+0x76>
    1bc7:	mov    0x2442(%rip),%rax        # 4010 <stdout@GLIBC_2.2.5>
    1bce:	mov    %rax,%rdi
    1bd1:	call   1240 <fflush@plt>
    1bd6:	jmp    1b80 <dump_serial+0x1e>
    1bd8:	call   11e0 <__stack_chk_fail@plt>
    1bdd:	leave
    1bde:	ret

0000000000001bdf <main>:
    1bdf:	f3 0f 1e fa          	endbr64
    1be3:	55                   	push   %rbp
    1be4:	48 89 e5             	mov    %rsp,%rbp
    1be7:	48 83 ec 20          	sub    $0x20,%rsp
    1beb:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1bee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1bf2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1bf6:	48 83 c0 08          	add    $0x8,%rax
    1bfa:	48 8b 00             	mov    (%rax),%rax
    1bfd:	be 02 10 00 00       	mov    $0x1002,%esi
    1c02:	48 89 c7             	mov    %rax,%rdi
    1c05:	e8 eb fd ff ff       	call   19f5 <open_serial>
    1c0a:	89 45 f8             	mov    %eax,-0x8(%rbp)
    1c0d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1c11:	79 17                	jns    1c2a <main+0x4b>
    1c13:	48 8d 3d 96 05 00 00 	lea    0x596(%rip),%rdi        # 21b0 <_IO_stdin_used+0x1b0>
    1c1a:	e8 91 f5 ff ff       	call   11b0 <puts@plt>
    1c1f:	e8 6c f5 ff ff       	call   1190 <__errno_location@plt>
    1c24:	8b 00                	mov    (%rax),%eax
    1c26:	f7 d8                	neg    %eax
    1c28:	eb 4d                	jmp    1c77 <main+0x98>
    1c2a:	48 8d 3d 18 06 00 00 	lea    0x618(%rip),%rdi        # 2249 <_IO_stdin_used+0x249>
    1c31:	b8 00 00 00 00       	mov    $0x0,%eax
    1c36:	e8 c5 f5 ff ff       	call   1200 <printf@plt>
    1c3b:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1c3e:	89 c7                	mov    %eax,%edi
    1c40:	e8 1d ff ff ff       	call   1b62 <dump_serial>
    1c45:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1c49:	48 83 c0 10          	add    $0x10,%rax
    1c4d:	48 8b 30             	mov    (%rax),%rsi
    1c50:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1c53:	b9 01 00 00 00       	mov    $0x1,%ecx
    1c58:	ba 00 00 00 00       	mov    $0x0,%edx
    1c5d:	89 c7                	mov    %eax,%edi
    1c5f:	e8 50 f8 ff ff       	call   14b4 <xymodem_send>
    1c64:	89 45 fc             	mov    %eax,-0x4(%rbp)
    1c67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1c6b:	79 05                	jns    1c72 <main+0x93>
    1c6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1c70:	eb 05                	jmp    1c77 <main+0x98>
    1c72:	b8 00 00 00 00       	mov    $0x0,%eax
    1c77:	c9                   	leave
    1c78:	c3                   	ret
    1c79:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000001c80 <__libc_csu_init>:
    1c80:	f3 0f 1e fa          	endbr64
    1c84:	41 57                	push   %r15
    1c86:	4c 8d 3d 93 20 00 00 	lea    0x2093(%rip),%r15        # 3d20 <__frame_dummy_init_array_entry>
    1c8d:	41 56                	push   %r14
    1c8f:	49 89 d6             	mov    %rdx,%r14
    1c92:	41 55                	push   %r13
    1c94:	49 89 f5             	mov    %rsi,%r13
    1c97:	41 54                	push   %r12
    1c99:	41 89 fc             	mov    %edi,%r12d
    1c9c:	55                   	push   %rbp
    1c9d:	48 8d 2d 84 20 00 00 	lea    0x2084(%rip),%rbp        # 3d28 <__do_global_dtors_aux_fini_array_entry>
    1ca4:	53                   	push   %rbx
    1ca5:	4c 29 fd             	sub    %r15,%rbp
    1ca8:	48 83 ec 08          	sub    $0x8,%rsp
    1cac:	e8 4f f3 ff ff       	call   1000 <_init>
    1cb1:	48 c1 fd 03          	sar    $0x3,%rbp
    1cb5:	74 1f                	je     1cd6 <__libc_csu_init+0x56>
    1cb7:	31 db                	xor    %ebx,%ebx
    1cb9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    1cc0:	4c 89 f2             	mov    %r14,%rdx
    1cc3:	4c 89 ee             	mov    %r13,%rsi
    1cc6:	44 89 e7             	mov    %r12d,%edi
    1cc9:	41 ff 14 df          	call   *(%r15,%rbx,8)
    1ccd:	48 83 c3 01          	add    $0x1,%rbx
    1cd1:	48 39 dd             	cmp    %rbx,%rbp
    1cd4:	75 ea                	jne    1cc0 <__libc_csu_init+0x40>
    1cd6:	48 83 c4 08          	add    $0x8,%rsp
    1cda:	5b                   	pop    %rbx
    1cdb:	5d                   	pop    %rbp
    1cdc:	41 5c                	pop    %r12
    1cde:	41 5d                	pop    %r13
    1ce0:	41 5e                	pop    %r14
    1ce2:	41 5f                	pop    %r15
    1ce4:	c3                   	ret
    1ce5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    1cec:	00 00 00 00 

0000000000001cf0 <__libc_csu_fini>:
    1cf0:	f3 0f 1e fa          	endbr64
    1cf4:	c3                   	ret
    1cf5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    1cfc:	00 00 00 
    1cff:	90                   	nop

0000000000001d00 <__fstat>:
    1d00:	f3 0f 1e fa          	endbr64
    1d04:	48 89 f2             	mov    %rsi,%rdx
    1d07:	89 fe                	mov    %edi,%esi
    1d09:	bf 01 00 00 00       	mov    $0x1,%edi
    1d0e:	e9 3d f5 ff ff       	jmp    1250 <__fxstat@plt>

Disassembly of section .fini:

0000000000001d14 <_fini>:
    1d14:	f3 0f 1e fa          	endbr64
    1d18:	48 83 ec 08          	sub    $0x8,%rsp
    1d1c:	48 83 c4 08          	add    $0x8,%rsp
    1d20:	c3                   	ret

