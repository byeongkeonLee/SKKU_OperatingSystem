#include "types.h"
#include "stat.h"
#include "user.h"
int g;
int func();
int main(int argc, char **argv){
	int* a=(int*)malloc(sizeof(int)*600);
	int* b=(int*)malloc(sizeof(int)*600);
	printf(1,"main : %x, data : %x   a-heap:%p b-heap:%p\n",main,&g,a,b);
	printf(1,"printf: %x\n",printf);
//	for(int i=0;i<20;i++){
//		printf(1,"%d heap : %x\n",i,(int*)malloc(sizeof(int)*900));
//	}
	func();
	exit();
}
int func(){
	int k=0;
	int* c=(int*)malloc(sizeof(int)*600);
	printf(1,"func:%p c-heap:%p\n",&k,c);
	return 0;
}
