#include "types.h"

#include "stat.h"

#include "user.h"



int main(int argc, char **argv){
	setnice(getpid(),7);
	if(fork()==0){
		if(fork()==0){
			setnice(getpid(),7);
			printf(1,"C");
			exit();
		}else{
		setnice(getpid(),7);
		printf(1,"B");
		printf(1,"E");
		exit();
		}
	}else{
	printf(1,"A");
	yield();
	printf(1,"D");
	wait();
	exit();
	}
}
