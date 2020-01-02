#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

typedef struct lock_t{
	uint lock;
}lock_t;

void lock_acquire(volatile lock_t *lock){
	while(xchg(&(lock->lock),1)==1);
}
void lock_release(volatile lock_t *lock){
	lock->lock=0;
}
int thread_create(void *(*function)(void *), int priority, void *arg, void *stack){
	int tid;
//	cprintf("clone start\n");
	lock_t lock;
	lock_acquire(&lock);
	tid=clone(function,priority,arg,(void*)stack);
//	cprintf("tid : %d is cloned\n",tid);
	lock_release(&lock);
	return tid;
}

void thread_exit(void *retval){
	//cprintf("tid = %d  is exit %x is retval",proc->tid,(int*)retval);
	lock_t lock;
	lock_acquire(&lock);
	thread_finish(retval);
	lock_release(&lock);
}

int thread_join(int tid, void **retval){
	int val;
	lock_t lock;
	lock_acquire(&lock);
	val= thread_join_function(tid,retval);
	//cprintf("(tid:%d is called thread join, and retval : %d\n)",tid,val);
	lock_release(&lock);
	return val;
}

int gettid(void){
	return proc->tid;
}
