#include "types.h"
#include "stat.h"
#include "user.h"
int main(){
	int a;
	a=fork();
	if(a==0){
		return 0;
	}else{
		sleep(200);
	}
	return 0;
	exit();
}

