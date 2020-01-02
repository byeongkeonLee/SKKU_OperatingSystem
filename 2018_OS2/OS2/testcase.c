#include "types.h"
#include "stat.h"
#include "user.h"

void printinfo(struct pstat);
int main(){
	struct pstat a;
	int parent,print=0;
	setnice(getpid(),0);
	for(int i=0;i<10;i++){
		if((parent=fork())==0){
			setnice(i+4,i);
			break;
		}else{
			setnice(getpid(),0);
		}
	}
	if(parent==0){
		while(1){}
	}else{
		sleep(50);
		while(1){
			getpinfo(&a);
			printf(1,"printout:%d\n",++print);
			printinfo(a);
			printf(1,"\n");
			sleep(50);
		}
	}
	exit();
}
void printinfo(struct pstat a){
	int cnt[11]={0};
	int pid[11][64]={0};
	int inuse[11][64]={0};
	int tick[11][64]={0};
	int n;
	for(int i=0;i<64;i++){
		if(a.pid[i]){
			printf(1,"pid : %d, nice : %d, inuse : %d, tick: %d\n",a.pid[i],a.nice[i],a.inuse[i],a.ticks[i]);
			n=a.nice[i];
			pid[n][cnt[n]]=a.pid[i];
			inuse[n][cnt[n]]=a.inuse[i];
			tick[n][cnt[n]]=a.ticks[i];
			cnt[n]++;
		}
	}
	for(int i=0;i<11;i++){
//		printf(1,"cnt: %d\n",cnt[i]);
		for(int j=0;j<cnt[i];j++){
if(0)			printf(1,"nice : %d, pid : %d, inuse : %d, tick : %d\n",i,pid[i][j],inuse[i][j],tick[i][j]);
		}
	}
	printf(1,"\n"); 
}
