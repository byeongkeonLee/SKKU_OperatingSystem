#include "types.h"
#include "stat.h"
#include "user.h"
int g;
int func();
int main(int argc, char **argv){
	int i[900]={0},j=0;
	int* a=(int*)malloc(sizeof(int)*10000);
	int* b=(int*)malloc(sizeof(int)*10000);
	j++;
	j++;
	j++;
	printf(1,"main:%p func:%p\n",main,func);
	printf(1,"data:%p\n",&g);
	printf(1,"a-heap:%p b-heap:%p\n",a,b);
	printf(1,"argc:%p // %p %p %p\n",&argc,&i[899],&i[0],&j);
	func();
	exit();
}
int func(){
	int k=0;
	int* c=(int*)malloc(sizeof(int)*10000);
	printf(1,"func:%p c-heap:%p\n",&k,c);
	return 0;
}
