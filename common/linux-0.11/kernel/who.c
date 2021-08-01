#include<errno.h>
#include<asm/segment.h>

extern int errno;
char __whoname[24];

int sys_iam(const char * p){
	char buffer[24];
	int i;
	for(i = 0; i < 24; i++){
		buffer[i] = get_fs_byte(p + i);
		if(buffer[i] == '\0') break;
	}
	if(i == 24){
		errno = EINVAL;
		return -1;
	}else{
		for(i = 0; buffer[i] != '\0'; i++) __whoname[i] = buffer[i];
		__whoname[i] = '\0';
		return i + 1;
	}
}

int sys_whoami(char *p, unsigned int size){
	int len;
	len = 0;
	while(__whoname[len] != '\0') len++;
	if(size > len){
		int i;
		for(i = 0; i <= len; i++)
			put_fs_byte(__whoname[i], p + i);
		return len;
	}else{
		errno = EINVAL;
		return -1;
	}
}

	
