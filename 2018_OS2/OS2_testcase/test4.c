#include "types.h"

#include "stat.h"

#include "user.h"



int main(int argc, char **argv){
	int parent = getpid();
	parent=fork();
	setnice(getpid(),7);
	if(parent==0){
		printf(1,"1234");
	}else{
		printf(1,"ABCD");
		wait();
	}
	printf(1,"3");
	exit();
}
