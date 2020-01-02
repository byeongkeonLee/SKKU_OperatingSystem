#include "types.h"
#include "stat.h"
#include "user.h"

int main(){
    int pid=getpid(),cpid;
    int retval;
    printf(1,"%d(20)\n",getnice(pid));
    retval= setnice(pid,8);
    printf(1,"%d(8),%d(0)\n",getnice(pid),retval);
    retval= setnice(pid,-1);
    printf(1,"%d(8),%d(-1)\n",getnice(pid),retval);
    retval= setnice(pid,41);
    printf(1,"%d(8),%d(-1)\n",getnice(pid),retval);
    retval= setnice(124,7);
    printf(1,"%d(8),%d(-1)\n",getnice(pid),retval);
    ps(pid);
    printf(1,"notthing:");ps(12444);
    printf(1,"\n");
    printf(1,"%d(-1)\n",getnice(117));
    cpid=fork();
    if(cpid==0){
        printf(1,"%d(20)\n",getnice(getpid()));
        retval=setnice(getpid(),2);
		printf(1,"%d(2),%d(0)",getnice(getpid()),retval);
		while(1);
		return 0;
    }else{
	sleep(10);
	printf(1,"%d(2),%d(8)",getnice(cpid),getnice(pid));
	ps(cpid);
	kill(cpid);
	ps(0);
    }
    int arr[5];
    for(int i=0;i<5;i++){
	int child=fork();
	if(child==0){
	   while(1);
	   return 0;
	}else{
	   arr[i]=child;
	}
    }
    for(int i=0;i<5;i++){
	retval=setnice(arr[i],i*12);
    }
    for(int i=0;i<5;i++){
	printf(1,"%d(%d)",getnice(arr[i]),i*12>40?20:i*12);
	printf(1,"%d(-1)\n",retval);
	kill(arr[i]);
    }
    sleep(20);
    ps(0);
    exit();
}
