#include "types.h"

#include "stat.h"

#include "user.h"



int main(int argc, char **argv){
	if(fork()==0){
		printf(1,"C");
		if(fork()==0){
		printf(1,"G");
		}
		exit();
	}
	printf(1,"P");
	exit();
}
