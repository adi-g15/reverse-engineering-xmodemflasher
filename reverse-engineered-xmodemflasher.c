#include <stdint.h>
#include <string.h>
#include <fcntl.h>
#include <termios.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <sys/param.h> // for MIN

int crc16(uint8_t *buff, int size);

int xymodem_send(int fd, const char *sketch_bin, int arg3, int arg4) {
	struct stat *statbuf;
	int sketch_fd;
	int sketch_size;
	uint8_t *sketch_content;
	uint8_t buffer[3];
	char buffer_130[0x80 + 0x3 /*see comments above memcpy later*/];
	uint8_t val_12f;
	uint64_t block_size;
	uint32_t val_154;
	uint32_t val_158 = 0 /*is initialised after prologue*/;
	uint32_t val_15a = 4;

	sketch_fd = open(sketch_bin, O_RDONLY /*0*/);

	fstat(sketch_fd, statbuf);

	sketch_size = statbuf->st_size;

	sketch_content = mmap(NULL, sketch_size, PROT_READ /*1*/, MAP_PRIVATE /*2*/, sketch_fd, 0);

	if (arg4 == 0) {
		goto after_puts_1696;
	}

	do {
		read(fd, buffer, 1);
		read(fd, buffer+1, 1);
		read(fd, buffer+2, 1);
	} while (buffer[2] != 'C' || buffer[1] != 'C' || buffer[0] != 'C' /*0x43*/);

	/* x/3cb $rbp-0x15d
           0x7fffffffd673: 67 'C'  67 'C'  67 'C'
        */

	puts("done.");

after_puts_1696:
	printf("Uploading %s", sketch_bin);

	if (arg3 == 1) {
		strncpy(buffer_130, sketch_bin, sizeof(buffer_130) /*0x80*/);
		    /*16dc:	movb   $0x0,-0x12f(%rbp)*/
		val_12f = 0;
		/* Don't know and don't need to care for our case */
		    /*16e3:	movl   $0x1,-0x158(%rbp)*/
		val_158 = 1;
		goto label_16f6;
	} else {
		/*16ef:	movb   $0x1,-0x12f(%rbp)*/
		val_12f = 1;
	}

label_16f6:
	/*16f6:	movb   $0x1,-0x130(%rbp)*/
	buffer_130[0] = 1;

	goto label_1915;
label_1702:

	block_size = 0;
	val_154 = 0;
	if (val_158 != 0) {
		/*<xymodem_send+738>       movl   $0x0,-0x158(%rbp)*/
		val_158 = 0;
	} else {
		/* mostly it will just be 0x80 */
		block_size = MIN(0x80, statbuf->st_size);

    /*3r	d argument (size) passed to memcpy is 0x80, while buffer also is
     * s	hifted by 3, does it mean it's size should atleast be 131 ?*/
		memcpy(buffer_130 + 0x3, sketch_content, block_size);

		/*shouldn't affect anything actually, as 3rd arg is 0*/
		memset(buffer_130 + 0x3 + block_size, 0xff, 0x80 - block_size /* both are same, hence 3rd arg will become 0 */);
	}

	crc16(buffer_130 + 0x3, 0x80);

label_1915:
	if (statbuf->st_size != 0) {
		goto label_1702;
	}

label_1923:

	return sketch_fd;
}

int open_serial(const char *device, speed_t baud_rate) {
	struct termios details;

	int fd = open(device, O_RDWR);

	memset(&details, 0, sizeof(details));

	tcgetattr(fd, &details);

	/* set the output & input baud rate here, which is 0x1002 */
	cfsetospeed(&details, baud_rate);
	cfsetispeed(&details, baud_rate);

	/*
	 * At this point, content of 'details' struct is this:
       0x00000100      0x00000000      0x00001cb2      0x00008a21
       0x7f1c0300      0x020a0415      0x1a131100      0x170f1200
       0x00000016      0x00000000      0x00000000      0x00000000
       0x00000000      0x00001002      0x00001002
	*/

	/* assembly had many instructions modifying content of 'details', but
	 * nothing changed from the above mentioned content */

	tcsetattr(fd, 0, &details);

    return fd;
}

void dump_serial(int fd) {
	uint8_t val;
	int max_tries = 1000;

	read(fd, &val, 1);
	printf("Read %c (%d)\n", val, val);
	
	if (val == '<') {
		goto read_success;
	}

	fprintf(stderr, "Waiting for Reset...\n");

	while ((max_tries --> 0) && val != '<') {	/* 0x3c = 60 = '<'*/
		read(fd, &val, 1);
	}

read_success:
	printf("Writing\n");
	write(fd, ">" /*0x3e*/, 1);
	printf("Written\n");
}

int main(int argc, const char *argv[]) {
	if (argc < 2 || argc > 2) {
		printf("Usage: ./program-name /dev/ttyUSB0 /tmp/arduino/sketches/*/*.ino.bin");
		return -1;
	}

	const char *device = argv[1]; /* "/dev/ttyUSB0" */
	const char *sketch_bin = argv[2];

	/* B115200 = 0x1002, got from stackoverflow */
	int fd = open_serial("/dev/ttyUSB0", B115200);

	dump_serial(fd);

	xymodem_send(fd, sketch_bin, 0, 1);

	return 0;
}
