#include "types.h"

#include "stat.h"

#include "user.h"



int main(int argc, char **argv){

	int child, parent = getpid();
	//start
	printf(1, "Start \n");
	if((child = fork()) == 0) { /* child executes later because new process is added to the end of the queue. */
		printf(1, "2");
		setnice(getpid(), 7);  // child's current nice value is set to 2, and this system call calls sched().
		if(fork() == 0) { // creates grand child process
			printf(1, "3");  // the grand child process's priority is the highest, i.e., 0
			yield();
		} else { // child's priority 2 is higher than the parent's 3.
			printf(1, "4");
			wait();
		}
	}
	else {  /* parent executes first. */
		printf(1, "1");
		setnice(parent, 9);  // parent process' nice level should be 3.
		wait();
		printf(1, "5");
	}
	//end
	exit();
}
