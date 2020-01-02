#include "types.h"
#include "stat.h"
#include "user.h"
#include "pstat.h"
int main(){
	for(int i=0;i<40;i++){
		if(fork()!=0){
		}else{
			setnice(getpid(),10);
			exit();
		}
	}
	for(int i=0;i<40;i++)
	wait();
	for(int i=0;i<50;i++){
		if(fork()!=0){
		}else{
			setnice(getpid(),10);
			exit();
		}
	}

	exit();
}

