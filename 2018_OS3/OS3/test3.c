#include "types.h"
#include "stat.h"
#include "user.h"
#include "memlayout.h"

void recursion(int n){
	if(n>0){
		for(int i=8;i>=0;i--){
			printf(1,"i(%d) %p\n",i,*(&n-i));
		}
		recursion(n-1);
		printf(1,"\n");
	}
}

	int
main(int argc, char **argv)
{
	// stack growth test
	printf(1,"recursion : %p main : %p\n",recursion,main);
	recursion(3);
	exit();
}
