#include "types.h"
#include "stat.h"
#include "user.h"
int main(){
	int a;
	if((a=fork())==0){
		exit();
	}else{
		wait();
		exit();
		return 0;
	}
}

