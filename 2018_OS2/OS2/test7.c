#include "types.h"
#include "stat.h"
#include "user.h"
int main(int argc, char **argv){
	struct pstat p;
	int child;//, parent = getpid();
	printf(1, "Start\n");
	setnice(getpid(),5);
	if((child = fork()) == 0) { /* child executes later because new process is added to the end of the queue. */
		printf(1, "1"); // child's current nice value is 0, while parent's is 1, 2, or 3.
		setnice(getpid(),3);
		if(fork() == 0) { // creates grand child process
			printf(1, "2");
			yield();
			setnice(getpid(),3);
			printf(1,"4");
		} else {
			printf(1, "3");
			if(fork() == 0){
				printf(1,"5");
				setnice(getpid(),9);
				printf(1, "9");
				exit();
			} else{
				printf(1, "6");
				wait();
			}
			wait();
		}
	}
	else {  /* parent executes first. */
		printf(1, "7");
		setnice(getpid(),8);
		printf(1,"8");
	    getpinfo(&p);
		wait();
		printf(1, "0");
		printf(1,"\n");
		for(int i=0;i<64;i++){
			if(p.pid[i]){
				printf(1,"pid %d, nice %d, inuse %d, acctic %d\n",p.pid[i],p.nice[i],p.inuse[i],p.ticks[i]);
			}
		}
	}
	//end
	exit();
}
