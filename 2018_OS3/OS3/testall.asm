
_testall:     file format elf32-i386


Disassembly of section .text:

00000000 <recursion>:
#include "types.h"
#include "stat.h"
#include "user.h"
#include "memlayout.h"

void recursion(int n){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 08             	sub    $0x8,%esp
	if(n>0)
   6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
   a:	7e 12                	jle    1e <recursion+0x1e>
		recursion(n-1);
   c:	8b 45 08             	mov    0x8(%ebp),%eax
   f:	83 e8 01             	sub    $0x1,%eax
  12:	83 ec 0c             	sub    $0xc,%esp
  15:	50                   	push   %eax
  16:	e8 e5 ff ff ff       	call   0 <recursion>
  1b:	83 c4 10             	add    $0x10,%esp
}
  1e:	90                   	nop
  1f:	c9                   	leave  
  20:	c3                   	ret    

00000021 <func>:
int func(int k){
  21:	55                   	push   %ebp
  22:	89 e5                	mov    %esp,%ebp
  24:	83 ec 08             	sub    $0x8,%esp
//	printf(1,"%x\n",&k);
	if(&k==(int*)(0x7FFFFFB0-0x20*(k-4))){
  27:	8b 45 08             	mov    0x8(%ebp),%eax
  2a:	83 e8 04             	sub    $0x4,%eax
  2d:	c1 e0 05             	shl    $0x5,%eax
  30:	ba b0 ff ff 7f       	mov    $0x7fffffb0,%edx
  35:	29 c2                	sub    %eax,%edx
  37:	89 d0                	mov    %edx,%eax
  39:	8d 4d 08             	lea    0x8(%ebp),%ecx
  3c:	39 c1                	cmp    %eax,%ecx
  3e:	75 1b                	jne    5b <func+0x3a>
		printf(1,"Test%d\n",k+4);
  40:	8b 45 08             	mov    0x8(%ebp),%eax
  43:	83 c0 04             	add    $0x4,%eax
  46:	83 ec 04             	sub    $0x4,%esp
  49:	50                   	push   %eax
  4a:	68 d4 0c 00 00       	push   $0xcd4
  4f:	6a 01                	push   $0x1
  51:	e8 c6 08 00 00       	call   91c <printf>
  56:	83 c4 10             	add    $0x10,%esp
  59:	eb 19                	jmp    74 <func+0x53>
	}else{
		printf(1,"Test%d Fail\n",k+4);
  5b:	8b 45 08             	mov    0x8(%ebp),%eax
  5e:	83 c0 04             	add    $0x4,%eax
  61:	83 ec 04             	sub    $0x4,%esp
  64:	50                   	push   %eax
  65:	68 dc 0c 00 00       	push   $0xcdc
  6a:	6a 01                	push   $0x1
  6c:	e8 ab 08 00 00       	call   91c <printf>
  71:	83 c4 10             	add    $0x10,%esp
	}
	if(k==4) func(5);
  74:	8b 45 08             	mov    0x8(%ebp),%eax
  77:	83 f8 04             	cmp    $0x4,%eax
  7a:	75 0d                	jne    89 <func+0x68>
  7c:	83 ec 0c             	sub    $0xc,%esp
  7f:	6a 05                	push   $0x5
  81:	e8 9b ff ff ff       	call   21 <func>
  86:	83 c4 10             	add    $0x10,%esp
	if(k==5) func(6);
  89:	8b 45 08             	mov    0x8(%ebp),%eax
  8c:	83 f8 05             	cmp    $0x5,%eax
  8f:	75 0d                	jne    9e <func+0x7d>
  91:	83 ec 0c             	sub    $0xc,%esp
  94:	6a 06                	push   $0x6
  96:	e8 86 ff ff ff       	call   21 <func>
  9b:	83 c4 10             	add    $0x10,%esp
	if(k>=6 && k<20) func(k+1);
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	83 f8 05             	cmp    $0x5,%eax
  a4:	7e 1a                	jle    c0 <func+0x9f>
  a6:	8b 45 08             	mov    0x8(%ebp),%eax
  a9:	83 f8 13             	cmp    $0x13,%eax
  ac:	7f 12                	jg     c0 <func+0x9f>
  ae:	8b 45 08             	mov    0x8(%ebp),%eax
  b1:	83 c0 01             	add    $0x1,%eax
  b4:	83 ec 0c             	sub    $0xc,%esp
  b7:	50                   	push   %eax
  b8:	e8 64 ff ff ff       	call   21 <func>
  bd:	83 c4 10             	add    $0x10,%esp
	if(k==4 && &k!=(int*)0x7FFFFFB0) printf(1,"Test25 Fail\n");
  c0:	8b 45 08             	mov    0x8(%ebp),%eax
  c3:	83 f8 04             	cmp    $0x4,%eax
  c6:	75 1c                	jne    e4 <func+0xc3>
  c8:	8d 45 08             	lea    0x8(%ebp),%eax
  cb:	3d b0 ff ff 7f       	cmp    $0x7fffffb0,%eax
  d0:	74 12                	je     e4 <func+0xc3>
  d2:	83 ec 08             	sub    $0x8,%esp
  d5:	68 e9 0c 00 00       	push   $0xce9
  da:	6a 01                	push   $0x1
  dc:	e8 3b 08 00 00       	call   91c <printf>
  e1:	83 c4 10             	add    $0x10,%esp
	printf(1,"Test25\n");
  e4:	83 ec 08             	sub    $0x8,%esp
  e7:	68 f6 0c 00 00       	push   $0xcf6
  ec:	6a 01                	push   $0x1
  ee:	e8 29 08 00 00       	call   91c <printf>
  f3:	83 c4 10             	add    $0x10,%esp
	return k-1;
  f6:	8b 45 08             	mov    0x8(%ebp),%eax
  f9:	83 e8 01             	sub    $0x1,%eax
}
  fc:	c9                   	leave  
  fd:	c3                   	ret    

000000fe <func2>:
int func2(){
  fe:	55                   	push   %ebp
  ff:	89 e5                	mov    %esp,%ebp
 101:	81 ec 38 5e 00 00    	sub    $0x5e38,%esp
	int arr[6025]={0};
 107:	8d 85 d4 a1 ff ff    	lea    -0x5e2c(%ebp),%eax
 10d:	ba 24 5e 00 00       	mov    $0x5e24,%edx
 112:	83 ec 04             	sub    $0x4,%esp
 115:	52                   	push   %edx
 116:	6a 00                	push   $0x0
 118:	50                   	push   %eax
 119:	e8 e4 04 00 00       	call   602 <memset>
 11e:	83 c4 10             	add    $0x10,%esp
	if(arr[0]==0) arr[0]=0;
 121:	8b 85 d4 a1 ff ff    	mov    -0x5e2c(%ebp),%eax
 127:	85 c0                	test   %eax,%eax
 129:	75 0a                	jne    135 <func2+0x37>
 12b:	c7 85 d4 a1 ff ff 00 	movl   $0x0,-0x5e2c(%ebp)
 132:	00 00 00 
	printf(1,"Test 28 Fail\n");
 135:	83 ec 08             	sub    $0x8,%esp
 138:	68 fe 0c 00 00       	push   $0xcfe
 13d:	6a 01                	push   $0x1
 13f:	e8 d8 07 00 00       	call   91c <printf>
 144:	83 c4 10             	add    $0x10,%esp
	return 1;	
 147:	b8 01 00 00 00       	mov    $0x1,%eax
}
 14c:	c9                   	leave  
 14d:	c3                   	ret    

0000014e <func3sub>:
int func3sub(int test){
 14e:	55                   	push   %ebp
 14f:	89 e5                	mov    %esp,%ebp
 151:	83 ec 18             	sub    $0x18,%esp
	int k=0;
 154:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//printf(1,"test %d : %x\n",test,&k);
	if(&k==(int*)0x7FDDD15C){
 15b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 15e:	3d 5c d1 dd 7f       	cmp    $0x7fddd15c,%eax
 163:	75 17                	jne    17c <func3sub+0x2e>
		printf(1,"Test%d\n",test);
 165:	83 ec 04             	sub    $0x4,%esp
 168:	ff 75 08             	pushl  0x8(%ebp)
 16b:	68 d4 0c 00 00       	push   $0xcd4
 170:	6a 01                	push   $0x1
 172:	e8 a5 07 00 00       	call   91c <printf>
 177:	83 c4 10             	add    $0x10,%esp
 17a:	eb 15                	jmp    191 <func3sub+0x43>
	}else{
		printf(1,"Test%d Fail\n",test);
 17c:	83 ec 04             	sub    $0x4,%esp
 17f:	ff 75 08             	pushl  0x8(%ebp)
 182:	68 dc 0c 00 00       	push   $0xcdc
 187:	6a 01                	push   $0x1
 189:	e8 8e 07 00 00       	call   91c <printf>
 18e:	83 c4 10             	add    $0x10,%esp
	}
	return 0;
 191:	b8 00 00 00 00       	mov    $0x0,%eax
}
 196:	c9                   	leave  
 197:	c3                   	ret    

00000198 <func3>:
int func3(){
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	83 ec 18             	sub    $0x18,%esp
	int i=0,pid;
 19e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(i=0;i<20;i++){
 1a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1ac:	eb 29                	jmp    1d7 <func3+0x3f>
		pid=fork();
 1ae:	e8 e2 05 00 00       	call   795 <fork>
 1b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(pid==0){
 1b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1ba:	75 17                	jne    1d3 <func3+0x3b>
			func3sub(i+29);	
 1bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1bf:	83 c0 1d             	add    $0x1d,%eax
 1c2:	83 ec 0c             	sub    $0xc,%esp
 1c5:	50                   	push   %eax
 1c6:	e8 83 ff ff ff       	call   14e <func3sub>
 1cb:	83 c4 10             	add    $0x10,%esp
			exit();
 1ce:	e8 ca 05 00 00       	call   79d <exit>
	}
	return 0;
}
int func3(){
	int i=0,pid;
	for(i=0;i<20;i++){
 1d3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1d7:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 1db:	7e d1                	jle    1ae <func3+0x16>
		if(pid==0){
			func3sub(i+29);	
			exit();
		}
	}
	wait();
 1dd:	e8 c3 05 00 00       	call   7a5 <wait>
	return 0;
 1e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1e7:	c9                   	leave  
 1e8:	c3                   	ret    

000001e9 <func4>:
int* func4(){
 1e9:	55                   	push   %ebp
 1ea:	89 e5                	mov    %esp,%ebp
 1ec:	83 ec 18             	sub    $0x18,%esp
	int *a =(int*)malloc(sizeof(int)*40);
 1ef:	83 ec 0c             	sub    $0xc,%esp
 1f2:	68 a0 00 00 00       	push   $0xa0
 1f7:	e8 f3 09 00 00       	call   bef <malloc>
 1fc:	83 c4 10             	add    $0x10,%esp
 1ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*a=2014312692;
 202:	8b 45 f4             	mov    -0xc(%ebp),%eax
 205:	c7 00 f4 f8 0f 78    	movl   $0x780ff8f4,(%eax)
	printf(1,"a : %x, I set the answer 0x9F60\n",a);
 20b:	83 ec 04             	sub    $0x4,%esp
 20e:	ff 75 f4             	pushl  -0xc(%ebp)
 211:	68 0c 0d 00 00       	push   $0xd0c
 216:	6a 01                	push   $0x1
 218:	e8 ff 06 00 00       	call   91c <printf>
 21d:	83 c4 10             	add    $0x10,%esp
	if(a==(int*)0x9F60){
 220:	81 7d f4 60 9f 00 00 	cmpl   $0x9f60,-0xc(%ebp)
 227:	75 14                	jne    23d <func4+0x54>
		printf(1,"Test 49 (it can be different)\n");
 229:	83 ec 08             	sub    $0x8,%esp
 22c:	68 30 0d 00 00       	push   $0xd30
 231:	6a 01                	push   $0x1
 233:	e8 e4 06 00 00       	call   91c <printf>
 238:	83 c4 10             	add    $0x10,%esp
 23b:	eb 12                	jmp    24f <func4+0x66>
	}else{
		printf(1,"Test 49 Fail (it can be different)\n");
 23d:	83 ec 08             	sub    $0x8,%esp
 240:	68 50 0d 00 00       	push   $0xd50
 245:	6a 01                	push   $0x1
 247:	e8 d0 06 00 00       	call   91c <printf>
 24c:	83 c4 10             	add    $0x10,%esp
	}
	return a;
 24f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 252:	c9                   	leave  
 253:	c3                   	ret    

00000254 <growstack_by_recursion>:
void growstack_by_recursion(int k){
 254:	55                   	push   %ebp
 255:	89 e5                	mov    %esp,%ebp
 257:	83 ec 08             	sub    $0x8,%esp
	if(k>0) growstack_by_recursion(k-1);
 25a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 25e:	7e 14                	jle    274 <growstack_by_recursion+0x20>
 260:	8b 45 08             	mov    0x8(%ebp),%eax
 263:	83 e8 01             	sub    $0x1,%eax
 266:	83 ec 0c             	sub    $0xc,%esp
 269:	50                   	push   %eax
 26a:	e8 e5 ff ff ff       	call   254 <growstack_by_recursion>
 26f:	83 c4 10             	add    $0x10,%esp
	else func3();
}
 272:	eb 05                	jmp    279 <growstack_by_recursion+0x25>
	}
	return a;
}
void growstack_by_recursion(int k){
	if(k>0) growstack_by_recursion(k-1);
	else func3();
 274:	e8 1f ff ff ff       	call   198 <func3>
}
 279:	90                   	nop
 27a:	c9                   	leave  
 27b:	c3                   	ret    

0000027c <main>:
int
main(int argc, char **argv)
{
 27c:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 280:	83 e4 f0             	and    $0xfffffff0,%esp
 283:	ff 71 fc             	pushl  -0x4(%ecx)
 286:	55                   	push   %ebp
 287:	89 e5                	mov    %esp,%ebp
 289:	51                   	push   %ecx
 28a:	83 ec 14             	sub    $0x14,%esp
	int pid;
	int* p;
	int a=0;
 28d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	p=&pid;
 294:	8d 45 ec             	lea    -0x14(%ebp),%eax
 297:	89 45 f4             	mov    %eax,-0xc(%ebp)
	printf(1,"%x\n",p);
 29a:	83 ec 04             	sub    $0x4,%esp
 29d:	ff 75 f4             	pushl  -0xc(%ebp)
 2a0:	68 74 0d 00 00       	push   $0xd74
 2a5:	6a 01                	push   $0x1
 2a7:	e8 70 06 00 00       	call   91c <printf>
 2ac:	83 c4 10             	add    $0x10,%esp
	if(p==(int*)0x7FFFFFC4){
 2af:	81 7d f4 c4 ff ff 7f 	cmpl   $0x7fffffc4,-0xc(%ebp)
 2b6:	75 14                	jne    2cc <main+0x50>
		printf(1,"Test1\n");
 2b8:	83 ec 08             	sub    $0x8,%esp
 2bb:	68 78 0d 00 00       	push   $0xd78
 2c0:	6a 01                	push   $0x1
 2c2:	e8 55 06 00 00       	call   91c <printf>
 2c7:	83 c4 10             	add    $0x10,%esp
 2ca:	eb 15                	jmp    2e1 <main+0x65>
	}else{
		printf(1,"Test1 Fail, %x\n",p);
 2cc:	83 ec 04             	sub    $0x4,%esp
 2cf:	ff 75 f4             	pushl  -0xc(%ebp)
 2d2:	68 7f 0d 00 00       	push   $0xd7f
 2d7:	6a 01                	push   $0x1
 2d9:	e8 3e 06 00 00       	call   91c <printf>
 2de:	83 c4 10             	add    $0x10,%esp
	}
	pid=fork();
 2e1:	e8 af 04 00 00       	call   795 <fork>
 2e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(pid==0){
 2e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 2ec:	85 c0                	test   %eax,%eax
 2ee:	0f 85 af 00 00 00    	jne    3a3 <main+0x127>
		if(p==&pid){
 2f4:	8d 45 ec             	lea    -0x14(%ebp),%eax
 2f7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 2fa:	75 14                	jne    310 <main+0x94>
			printf(1,"Test2\n");
 2fc:	83 ec 08             	sub    $0x8,%esp
 2ff:	68 8f 0d 00 00       	push   $0xd8f
 304:	6a 01                	push   $0x1
 306:	e8 11 06 00 00       	call   91c <printf>
 30b:	83 c4 10             	add    $0x10,%esp
 30e:	eb 12                	jmp    322 <main+0xa6>
		}else{
			printf(1,"Test2 Fail\n");
 310:	83 ec 08             	sub    $0x8,%esp
 313:	68 96 0d 00 00       	push   $0xd96
 318:	6a 01                	push   $0x1
 31a:	e8 fd 05 00 00       	call   91c <printf>
 31f:	83 c4 10             	add    $0x10,%esp
		}
		if(p==(int*)0x7FFFFFC4){
 322:	81 7d f4 c4 ff ff 7f 	cmpl   $0x7fffffc4,-0xc(%ebp)
 329:	75 14                	jne    33f <main+0xc3>
			printf(1,"Test3\n");
 32b:	83 ec 08             	sub    $0x8,%esp
 32e:	68 a2 0d 00 00       	push   $0xda2
 333:	6a 01                	push   $0x1
 335:	e8 e2 05 00 00       	call   91c <printf>
 33a:	83 c4 10             	add    $0x10,%esp
 33d:	eb 12                	jmp    351 <main+0xd5>
		}else{
			printf(1,"Test3 Fail\n");
 33f:	83 ec 08             	sub    $0x8,%esp
 342:	68 a9 0d 00 00       	push   $0xda9
 347:	6a 01                	push   $0x1
 349:	e8 ce 05 00 00       	call   91c <printf>
 34e:	83 c4 10             	add    $0x10,%esp
		}
		if(&a==(int*)0x7FFFFFC0){
 351:	8d 45 e8             	lea    -0x18(%ebp),%eax
 354:	3d c0 ff ff 7f       	cmp    $0x7fffffc0,%eax
 359:	75 14                	jne    36f <main+0xf3>
			printf(1,"Test4\n");
 35b:	83 ec 08             	sub    $0x8,%esp
 35e:	68 b5 0d 00 00       	push   $0xdb5
 363:	6a 01                	push   $0x1
 365:	e8 b2 05 00 00       	call   91c <printf>
 36a:	83 c4 10             	add    $0x10,%esp
 36d:	eb 12                	jmp    381 <main+0x105>
		}else{
			printf(1,"Test4 Fail\n");
 36f:	83 ec 08             	sub    $0x8,%esp
 372:	68 bc 0d 00 00       	push   $0xdbc
 377:	6a 01                	push   $0x1
 379:	e8 9e 05 00 00       	call   91c <printf>
 37e:	83 c4 10             	add    $0x10,%esp
		}
		int *b=(int*)0x80000000;
 381:	c7 45 f0 00 00 00 80 	movl   $0x80000000,-0x10(%ebp)
		*b=2;
 388:	8b 45 f0             	mov    -0x10(%ebp),%eax
 38b:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
		printf(1,"Test5 Fail\n");
 391:	83 ec 08             	sub    $0x8,%esp
 394:	68 c8 0d 00 00       	push   $0xdc8
 399:	6a 01                	push   $0x1
 39b:	e8 7c 05 00 00       	call   91c <printf>
 3a0:	83 c4 10             	add    $0x10,%esp
	}
	wait();
 3a3:	e8 fd 03 00 00       	call   7a5 <wait>
	printf(1,"Test5\n");
 3a8:	83 ec 08             	sub    $0x8,%esp
 3ab:	68 d4 0d 00 00       	push   $0xdd4
 3b0:	6a 01                	push   $0x1
 3b2:	e8 65 05 00 00       	call   91c <printf>
 3b7:	83 c4 10             	add    $0x10,%esp
	recursion(400);
 3ba:	83 ec 0c             	sub    $0xc,%esp
 3bd:	68 90 01 00 00       	push   $0x190
 3c2:	e8 39 fc ff ff       	call   0 <recursion>
 3c7:	83 c4 10             	add    $0x10,%esp
	printf(1,"Test6\n");
 3ca:	83 ec 08             	sub    $0x8,%esp
 3cd:	68 db 0d 00 00       	push   $0xddb
 3d2:	6a 01                	push   $0x1
 3d4:	e8 43 05 00 00       	call   91c <printf>
 3d9:	83 c4 10             	add    $0x10,%esp
	recursion(300);
 3dc:	83 ec 0c             	sub    $0xc,%esp
 3df:	68 2c 01 00 00       	push   $0x12c
 3e4:	e8 17 fc ff ff       	call   0 <recursion>
 3e9:	83 c4 10             	add    $0x10,%esp
	printf(1,"Test7\n");
 3ec:	83 ec 08             	sub    $0x8,%esp
 3ef:	68 e2 0d 00 00       	push   $0xde2
 3f4:	6a 01                	push   $0x1
 3f6:	e8 21 05 00 00       	call   91c <printf>
 3fb:	83 c4 10             	add    $0x10,%esp
	a=func(4);
 3fe:	83 ec 0c             	sub    $0xc,%esp
 401:	6a 04                	push   $0x4
 403:	e8 19 fc ff ff       	call   21 <func>
 408:	83 c4 10             	add    $0x10,%esp
 40b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(a==3)printf(1,"Test26\n");
 40e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 411:	83 f8 03             	cmp    $0x3,%eax
 414:	75 14                	jne    42a <main+0x1ae>
 416:	83 ec 08             	sub    $0x8,%esp
 419:	68 e9 0d 00 00       	push   $0xde9
 41e:	6a 01                	push   $0x1
 420:	e8 f7 04 00 00       	call   91c <printf>
 425:	83 c4 10             	add    $0x10,%esp
 428:	eb 12                	jmp    43c <main+0x1c0>
	else printf(1,"Test26 Fail\n");
 42a:	83 ec 08             	sub    $0x8,%esp
 42d:	68 f1 0d 00 00       	push   $0xdf1
 432:	6a 01                	push   $0x1
 434:	e8 e3 04 00 00       	call   91c <printf>
 439:	83 c4 10             	add    $0x10,%esp
	printf(1,"%x == 0 ? is correct : is fail\n ",recursion);
 43c:	83 ec 04             	sub    $0x4,%esp
 43f:	68 00 00 00 00       	push   $0x0
 444:	68 00 0e 00 00       	push   $0xe00
 449:	6a 01                	push   $0x1
 44b:	e8 cc 04 00 00       	call   91c <printf>
 450:	83 c4 10             	add    $0x10,%esp
	if(func==(void*)0x21) printf(1,"Test27\n");
 453:	b8 21 00 00 00       	mov    $0x21,%eax
 458:	83 f8 21             	cmp    $0x21,%eax
 45b:	75 14                	jne    471 <main+0x1f5>
 45d:	83 ec 08             	sub    $0x8,%esp
 460:	68 21 0e 00 00       	push   $0xe21
 465:	6a 01                	push   $0x1
 467:	e8 b0 04 00 00       	call   91c <printf>
 46c:	83 c4 10             	add    $0x10,%esp
 46f:	eb 12                	jmp    483 <main+0x207>
	else printf(1,"Test27 Fail\n");
 471:	83 ec 08             	sub    $0x8,%esp
 474:	68 29 0e 00 00       	push   $0xe29
 479:	6a 01                	push   $0x1
 47b:	e8 9c 04 00 00       	call   91c <printf>
 480:	83 c4 10             	add    $0x10,%esp
	pid=fork();
 483:	e8 0d 03 00 00       	call   795 <fork>
 488:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(pid==0){
 48b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 48e:	85 c0                	test   %eax,%eax
 490:	75 0a                	jne    49c <main+0x220>
		func2();
 492:	e8 67 fc ff ff       	call   fe <func2>
		exit();
 497:	e8 01 03 00 00       	call   79d <exit>
	}
	wait();
 49c:	e8 04 03 00 00       	call   7a5 <wait>
	printf(1,"Test28\n");
 4a1:	83 ec 08             	sub    $0x8,%esp
 4a4:	68 36 0e 00 00       	push   $0xe36
 4a9:	6a 01                	push   $0x1
 4ab:	e8 6c 04 00 00       	call   91c <printf>
 4b0:	83 c4 10             	add    $0x10,%esp
	pid=fork();
 4b3:	e8 dd 02 00 00       	call   795 <fork>
 4b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(pid==0){
 4bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4be:	85 c0                	test   %eax,%eax
 4c0:	75 15                	jne    4d7 <main+0x25b>
		growstack_by_recursion(70000);
 4c2:	83 ec 0c             	sub    $0xc,%esp
 4c5:	68 70 11 01 00       	push   $0x11170
 4ca:	e8 85 fd ff ff       	call   254 <growstack_by_recursion>
 4cf:	83 c4 10             	add    $0x10,%esp
		exit();
 4d2:	e8 c6 02 00 00       	call   79d <exit>
	}
	wait();
 4d7:	e8 c9 02 00 00       	call   7a5 <wait>
	pid=fork();
 4dc:	e8 b4 02 00 00       	call   795 <fork>
 4e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(pid==0){
 4e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4e7:	85 c0                	test   %eax,%eax
 4e9:	75 3f                	jne    52a <main+0x2ae>
		p=func4();
 4eb:	e8 f9 fc ff ff       	call   1e9 <func4>
 4f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(*p==2014312692){
 4f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f6:	8b 00                	mov    (%eax),%eax
 4f8:	3d f4 f8 0f 78       	cmp    $0x780ff8f4,%eax
 4fd:	75 14                	jne    513 <main+0x297>
			printf(1,"Test50\n");
 4ff:	83 ec 08             	sub    $0x8,%esp
 502:	68 3e 0e 00 00       	push   $0xe3e
 507:	6a 01                	push   $0x1
 509:	e8 0e 04 00 00       	call   91c <printf>
 50e:	83 c4 10             	add    $0x10,%esp
 511:	eb 12                	jmp    525 <main+0x2a9>
		}else{
			printf(1,"Test50 Fail\n");
 513:	83 ec 08             	sub    $0x8,%esp
 516:	68 46 0e 00 00       	push   $0xe46
 51b:	6a 01                	push   $0x1
 51d:	e8 fa 03 00 00       	call   91c <printf>
 522:	83 c4 10             	add    $0x10,%esp
		}
		exit();
 525:	e8 73 02 00 00       	call   79d <exit>
	}
	wait();
 52a:	e8 76 02 00 00       	call   7a5 <wait>
			printf(1,"Finished all test. If there are some fail case, please let me know\n");
 52f:	83 ec 08             	sub    $0x8,%esp
 532:	68 54 0e 00 00       	push   $0xe54
 537:	6a 01                	push   $0x1
 539:	e8 de 03 00 00       	call   91c <printf>
 53e:	83 c4 10             	add    $0x10,%esp
	exit();
 541:	e8 57 02 00 00       	call   79d <exit>

00000546 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 546:	55                   	push   %ebp
 547:	89 e5                	mov    %esp,%ebp
 549:	57                   	push   %edi
 54a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 54b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 54e:	8b 55 10             	mov    0x10(%ebp),%edx
 551:	8b 45 0c             	mov    0xc(%ebp),%eax
 554:	89 cb                	mov    %ecx,%ebx
 556:	89 df                	mov    %ebx,%edi
 558:	89 d1                	mov    %edx,%ecx
 55a:	fc                   	cld    
 55b:	f3 aa                	rep stos %al,%es:(%edi)
 55d:	89 ca                	mov    %ecx,%edx
 55f:	89 fb                	mov    %edi,%ebx
 561:	89 5d 08             	mov    %ebx,0x8(%ebp)
 564:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 567:	90                   	nop
 568:	5b                   	pop    %ebx
 569:	5f                   	pop    %edi
 56a:	5d                   	pop    %ebp
 56b:	c3                   	ret    

0000056c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 56c:	55                   	push   %ebp
 56d:	89 e5                	mov    %esp,%ebp
 56f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 572:	8b 45 08             	mov    0x8(%ebp),%eax
 575:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 578:	90                   	nop
 579:	8b 45 08             	mov    0x8(%ebp),%eax
 57c:	8d 50 01             	lea    0x1(%eax),%edx
 57f:	89 55 08             	mov    %edx,0x8(%ebp)
 582:	8b 55 0c             	mov    0xc(%ebp),%edx
 585:	8d 4a 01             	lea    0x1(%edx),%ecx
 588:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 58b:	0f b6 12             	movzbl (%edx),%edx
 58e:	88 10                	mov    %dl,(%eax)
 590:	0f b6 00             	movzbl (%eax),%eax
 593:	84 c0                	test   %al,%al
 595:	75 e2                	jne    579 <strcpy+0xd>
    ;
  return os;
 597:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 59a:	c9                   	leave  
 59b:	c3                   	ret    

0000059c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 59c:	55                   	push   %ebp
 59d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 59f:	eb 08                	jmp    5a9 <strcmp+0xd>
    p++, q++;
 5a1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 5a5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 5a9:	8b 45 08             	mov    0x8(%ebp),%eax
 5ac:	0f b6 00             	movzbl (%eax),%eax
 5af:	84 c0                	test   %al,%al
 5b1:	74 10                	je     5c3 <strcmp+0x27>
 5b3:	8b 45 08             	mov    0x8(%ebp),%eax
 5b6:	0f b6 10             	movzbl (%eax),%edx
 5b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 5bc:	0f b6 00             	movzbl (%eax),%eax
 5bf:	38 c2                	cmp    %al,%dl
 5c1:	74 de                	je     5a1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 5c3:	8b 45 08             	mov    0x8(%ebp),%eax
 5c6:	0f b6 00             	movzbl (%eax),%eax
 5c9:	0f b6 d0             	movzbl %al,%edx
 5cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 5cf:	0f b6 00             	movzbl (%eax),%eax
 5d2:	0f b6 c0             	movzbl %al,%eax
 5d5:	29 c2                	sub    %eax,%edx
 5d7:	89 d0                	mov    %edx,%eax
}
 5d9:	5d                   	pop    %ebp
 5da:	c3                   	ret    

000005db <strlen>:

uint
strlen(char *s)
{
 5db:	55                   	push   %ebp
 5dc:	89 e5                	mov    %esp,%ebp
 5de:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 5e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 5e8:	eb 04                	jmp    5ee <strlen+0x13>
 5ea:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 5ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
 5f1:	8b 45 08             	mov    0x8(%ebp),%eax
 5f4:	01 d0                	add    %edx,%eax
 5f6:	0f b6 00             	movzbl (%eax),%eax
 5f9:	84 c0                	test   %al,%al
 5fb:	75 ed                	jne    5ea <strlen+0xf>
    ;
  return n;
 5fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 600:	c9                   	leave  
 601:	c3                   	ret    

00000602 <memset>:

void*
memset(void *dst, int c, uint n)
{
 602:	55                   	push   %ebp
 603:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 605:	8b 45 10             	mov    0x10(%ebp),%eax
 608:	50                   	push   %eax
 609:	ff 75 0c             	pushl  0xc(%ebp)
 60c:	ff 75 08             	pushl  0x8(%ebp)
 60f:	e8 32 ff ff ff       	call   546 <stosb>
 614:	83 c4 0c             	add    $0xc,%esp
  return dst;
 617:	8b 45 08             	mov    0x8(%ebp),%eax
}
 61a:	c9                   	leave  
 61b:	c3                   	ret    

0000061c <strchr>:

char*
strchr(const char *s, char c)
{
 61c:	55                   	push   %ebp
 61d:	89 e5                	mov    %esp,%ebp
 61f:	83 ec 04             	sub    $0x4,%esp
 622:	8b 45 0c             	mov    0xc(%ebp),%eax
 625:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 628:	eb 14                	jmp    63e <strchr+0x22>
    if(*s == c)
 62a:	8b 45 08             	mov    0x8(%ebp),%eax
 62d:	0f b6 00             	movzbl (%eax),%eax
 630:	3a 45 fc             	cmp    -0x4(%ebp),%al
 633:	75 05                	jne    63a <strchr+0x1e>
      return (char*)s;
 635:	8b 45 08             	mov    0x8(%ebp),%eax
 638:	eb 13                	jmp    64d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 63a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 63e:	8b 45 08             	mov    0x8(%ebp),%eax
 641:	0f b6 00             	movzbl (%eax),%eax
 644:	84 c0                	test   %al,%al
 646:	75 e2                	jne    62a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 648:	b8 00 00 00 00       	mov    $0x0,%eax
}
 64d:	c9                   	leave  
 64e:	c3                   	ret    

0000064f <gets>:

char*
gets(char *buf, int max)
{
 64f:	55                   	push   %ebp
 650:	89 e5                	mov    %esp,%ebp
 652:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 655:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 65c:	eb 42                	jmp    6a0 <gets+0x51>
    cc = read(0, &c, 1);
 65e:	83 ec 04             	sub    $0x4,%esp
 661:	6a 01                	push   $0x1
 663:	8d 45 ef             	lea    -0x11(%ebp),%eax
 666:	50                   	push   %eax
 667:	6a 00                	push   $0x0
 669:	e8 47 01 00 00       	call   7b5 <read>
 66e:	83 c4 10             	add    $0x10,%esp
 671:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 674:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 678:	7e 33                	jle    6ad <gets+0x5e>
      break;
    buf[i++] = c;
 67a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 67d:	8d 50 01             	lea    0x1(%eax),%edx
 680:	89 55 f4             	mov    %edx,-0xc(%ebp)
 683:	89 c2                	mov    %eax,%edx
 685:	8b 45 08             	mov    0x8(%ebp),%eax
 688:	01 c2                	add    %eax,%edx
 68a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 68e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 690:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 694:	3c 0a                	cmp    $0xa,%al
 696:	74 16                	je     6ae <gets+0x5f>
 698:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 69c:	3c 0d                	cmp    $0xd,%al
 69e:	74 0e                	je     6ae <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a3:	83 c0 01             	add    $0x1,%eax
 6a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
 6a9:	7c b3                	jl     65e <gets+0xf>
 6ab:	eb 01                	jmp    6ae <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 6ad:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 6ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
 6b1:	8b 45 08             	mov    0x8(%ebp),%eax
 6b4:	01 d0                	add    %edx,%eax
 6b6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 6b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 6bc:	c9                   	leave  
 6bd:	c3                   	ret    

000006be <stat>:

int
stat(char *n, struct stat *st)
{
 6be:	55                   	push   %ebp
 6bf:	89 e5                	mov    %esp,%ebp
 6c1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 6c4:	83 ec 08             	sub    $0x8,%esp
 6c7:	6a 00                	push   $0x0
 6c9:	ff 75 08             	pushl  0x8(%ebp)
 6cc:	e8 0c 01 00 00       	call   7dd <open>
 6d1:	83 c4 10             	add    $0x10,%esp
 6d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 6d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6db:	79 07                	jns    6e4 <stat+0x26>
    return -1;
 6dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 6e2:	eb 25                	jmp    709 <stat+0x4b>
  r = fstat(fd, st);
 6e4:	83 ec 08             	sub    $0x8,%esp
 6e7:	ff 75 0c             	pushl  0xc(%ebp)
 6ea:	ff 75 f4             	pushl  -0xc(%ebp)
 6ed:	e8 03 01 00 00       	call   7f5 <fstat>
 6f2:	83 c4 10             	add    $0x10,%esp
 6f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 6f8:	83 ec 0c             	sub    $0xc,%esp
 6fb:	ff 75 f4             	pushl  -0xc(%ebp)
 6fe:	e8 c2 00 00 00       	call   7c5 <close>
 703:	83 c4 10             	add    $0x10,%esp
  return r;
 706:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 709:	c9                   	leave  
 70a:	c3                   	ret    

0000070b <atoi>:

int
atoi(const char *s)
{
 70b:	55                   	push   %ebp
 70c:	89 e5                	mov    %esp,%ebp
 70e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 711:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 718:	eb 25                	jmp    73f <atoi+0x34>
    n = n*10 + *s++ - '0';
 71a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 71d:	89 d0                	mov    %edx,%eax
 71f:	c1 e0 02             	shl    $0x2,%eax
 722:	01 d0                	add    %edx,%eax
 724:	01 c0                	add    %eax,%eax
 726:	89 c1                	mov    %eax,%ecx
 728:	8b 45 08             	mov    0x8(%ebp),%eax
 72b:	8d 50 01             	lea    0x1(%eax),%edx
 72e:	89 55 08             	mov    %edx,0x8(%ebp)
 731:	0f b6 00             	movzbl (%eax),%eax
 734:	0f be c0             	movsbl %al,%eax
 737:	01 c8                	add    %ecx,%eax
 739:	83 e8 30             	sub    $0x30,%eax
 73c:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 73f:	8b 45 08             	mov    0x8(%ebp),%eax
 742:	0f b6 00             	movzbl (%eax),%eax
 745:	3c 2f                	cmp    $0x2f,%al
 747:	7e 0a                	jle    753 <atoi+0x48>
 749:	8b 45 08             	mov    0x8(%ebp),%eax
 74c:	0f b6 00             	movzbl (%eax),%eax
 74f:	3c 39                	cmp    $0x39,%al
 751:	7e c7                	jle    71a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 753:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 756:	c9                   	leave  
 757:	c3                   	ret    

00000758 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 758:	55                   	push   %ebp
 759:	89 e5                	mov    %esp,%ebp
 75b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 75e:	8b 45 08             	mov    0x8(%ebp),%eax
 761:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 764:	8b 45 0c             	mov    0xc(%ebp),%eax
 767:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 76a:	eb 17                	jmp    783 <memmove+0x2b>
    *dst++ = *src++;
 76c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76f:	8d 50 01             	lea    0x1(%eax),%edx
 772:	89 55 fc             	mov    %edx,-0x4(%ebp)
 775:	8b 55 f8             	mov    -0x8(%ebp),%edx
 778:	8d 4a 01             	lea    0x1(%edx),%ecx
 77b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 77e:	0f b6 12             	movzbl (%edx),%edx
 781:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 783:	8b 45 10             	mov    0x10(%ebp),%eax
 786:	8d 50 ff             	lea    -0x1(%eax),%edx
 789:	89 55 10             	mov    %edx,0x10(%ebp)
 78c:	85 c0                	test   %eax,%eax
 78e:	7f dc                	jg     76c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 790:	8b 45 08             	mov    0x8(%ebp),%eax
}
 793:	c9                   	leave  
 794:	c3                   	ret    

00000795 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 795:	b8 01 00 00 00       	mov    $0x1,%eax
 79a:	cd 40                	int    $0x40
 79c:	c3                   	ret    

0000079d <exit>:
SYSCALL(exit)
 79d:	b8 02 00 00 00       	mov    $0x2,%eax
 7a2:	cd 40                	int    $0x40
 7a4:	c3                   	ret    

000007a5 <wait>:
SYSCALL(wait)
 7a5:	b8 03 00 00 00       	mov    $0x3,%eax
 7aa:	cd 40                	int    $0x40
 7ac:	c3                   	ret    

000007ad <pipe>:
SYSCALL(pipe)
 7ad:	b8 04 00 00 00       	mov    $0x4,%eax
 7b2:	cd 40                	int    $0x40
 7b4:	c3                   	ret    

000007b5 <read>:
SYSCALL(read)
 7b5:	b8 05 00 00 00       	mov    $0x5,%eax
 7ba:	cd 40                	int    $0x40
 7bc:	c3                   	ret    

000007bd <write>:
SYSCALL(write)
 7bd:	b8 10 00 00 00       	mov    $0x10,%eax
 7c2:	cd 40                	int    $0x40
 7c4:	c3                   	ret    

000007c5 <close>:
SYSCALL(close)
 7c5:	b8 15 00 00 00       	mov    $0x15,%eax
 7ca:	cd 40                	int    $0x40
 7cc:	c3                   	ret    

000007cd <kill>:
SYSCALL(kill)
 7cd:	b8 06 00 00 00       	mov    $0x6,%eax
 7d2:	cd 40                	int    $0x40
 7d4:	c3                   	ret    

000007d5 <exec>:
SYSCALL(exec)
 7d5:	b8 07 00 00 00       	mov    $0x7,%eax
 7da:	cd 40                	int    $0x40
 7dc:	c3                   	ret    

000007dd <open>:
SYSCALL(open)
 7dd:	b8 0f 00 00 00       	mov    $0xf,%eax
 7e2:	cd 40                	int    $0x40
 7e4:	c3                   	ret    

000007e5 <mknod>:
SYSCALL(mknod)
 7e5:	b8 11 00 00 00       	mov    $0x11,%eax
 7ea:	cd 40                	int    $0x40
 7ec:	c3                   	ret    

000007ed <unlink>:
SYSCALL(unlink)
 7ed:	b8 12 00 00 00       	mov    $0x12,%eax
 7f2:	cd 40                	int    $0x40
 7f4:	c3                   	ret    

000007f5 <fstat>:
SYSCALL(fstat)
 7f5:	b8 08 00 00 00       	mov    $0x8,%eax
 7fa:	cd 40                	int    $0x40
 7fc:	c3                   	ret    

000007fd <link>:
SYSCALL(link)
 7fd:	b8 13 00 00 00       	mov    $0x13,%eax
 802:	cd 40                	int    $0x40
 804:	c3                   	ret    

00000805 <mkdir>:
SYSCALL(mkdir)
 805:	b8 14 00 00 00       	mov    $0x14,%eax
 80a:	cd 40                	int    $0x40
 80c:	c3                   	ret    

0000080d <chdir>:
SYSCALL(chdir)
 80d:	b8 09 00 00 00       	mov    $0x9,%eax
 812:	cd 40                	int    $0x40
 814:	c3                   	ret    

00000815 <dup>:
SYSCALL(dup)
 815:	b8 0a 00 00 00       	mov    $0xa,%eax
 81a:	cd 40                	int    $0x40
 81c:	c3                   	ret    

0000081d <getpid>:
SYSCALL(getpid)
 81d:	b8 0b 00 00 00       	mov    $0xb,%eax
 822:	cd 40                	int    $0x40
 824:	c3                   	ret    

00000825 <sbrk>:
SYSCALL(sbrk)
 825:	b8 0c 00 00 00       	mov    $0xc,%eax
 82a:	cd 40                	int    $0x40
 82c:	c3                   	ret    

0000082d <sleep>:
SYSCALL(sleep)
 82d:	b8 0d 00 00 00       	mov    $0xd,%eax
 832:	cd 40                	int    $0x40
 834:	c3                   	ret    

00000835 <uptime>:
SYSCALL(uptime)
 835:	b8 0e 00 00 00       	mov    $0xe,%eax
 83a:	cd 40                	int    $0x40
 83c:	c3                   	ret    

0000083d <halt>:
SYSCALL(halt)
 83d:	b8 16 00 00 00       	mov    $0x16,%eax
 842:	cd 40                	int    $0x40
 844:	c3                   	ret    

00000845 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 845:	55                   	push   %ebp
 846:	89 e5                	mov    %esp,%ebp
 848:	83 ec 18             	sub    $0x18,%esp
 84b:	8b 45 0c             	mov    0xc(%ebp),%eax
 84e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 851:	83 ec 04             	sub    $0x4,%esp
 854:	6a 01                	push   $0x1
 856:	8d 45 f4             	lea    -0xc(%ebp),%eax
 859:	50                   	push   %eax
 85a:	ff 75 08             	pushl  0x8(%ebp)
 85d:	e8 5b ff ff ff       	call   7bd <write>
 862:	83 c4 10             	add    $0x10,%esp
}
 865:	90                   	nop
 866:	c9                   	leave  
 867:	c3                   	ret    

00000868 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 868:	55                   	push   %ebp
 869:	89 e5                	mov    %esp,%ebp
 86b:	53                   	push   %ebx
 86c:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 86f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 876:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 87a:	74 17                	je     893 <printint+0x2b>
 87c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 880:	79 11                	jns    893 <printint+0x2b>
    neg = 1;
 882:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 889:	8b 45 0c             	mov    0xc(%ebp),%eax
 88c:	f7 d8                	neg    %eax
 88e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 891:	eb 06                	jmp    899 <printint+0x31>
  } else {
    x = xx;
 893:	8b 45 0c             	mov    0xc(%ebp),%eax
 896:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 899:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 8a0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 8a3:	8d 41 01             	lea    0x1(%ecx),%eax
 8a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
 8ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8af:	ba 00 00 00 00       	mov    $0x0,%edx
 8b4:	f7 f3                	div    %ebx
 8b6:	89 d0                	mov    %edx,%eax
 8b8:	0f b6 80 c8 11 00 00 	movzbl 0x11c8(%eax),%eax
 8bf:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 8c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
 8c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8c9:	ba 00 00 00 00       	mov    $0x0,%edx
 8ce:	f7 f3                	div    %ebx
 8d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8d7:	75 c7                	jne    8a0 <printint+0x38>
  if(neg)
 8d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8dd:	74 2d                	je     90c <printint+0xa4>
    buf[i++] = '-';
 8df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e2:	8d 50 01             	lea    0x1(%eax),%edx
 8e5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 8e8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 8ed:	eb 1d                	jmp    90c <printint+0xa4>
    putc(fd, buf[i]);
 8ef:	8d 55 dc             	lea    -0x24(%ebp),%edx
 8f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f5:	01 d0                	add    %edx,%eax
 8f7:	0f b6 00             	movzbl (%eax),%eax
 8fa:	0f be c0             	movsbl %al,%eax
 8fd:	83 ec 08             	sub    $0x8,%esp
 900:	50                   	push   %eax
 901:	ff 75 08             	pushl  0x8(%ebp)
 904:	e8 3c ff ff ff       	call   845 <putc>
 909:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 90c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 910:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 914:	79 d9                	jns    8ef <printint+0x87>
    putc(fd, buf[i]);
}
 916:	90                   	nop
 917:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 91a:	c9                   	leave  
 91b:	c3                   	ret    

0000091c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 91c:	55                   	push   %ebp
 91d:	89 e5                	mov    %esp,%ebp
 91f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 922:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 929:	8d 45 0c             	lea    0xc(%ebp),%eax
 92c:	83 c0 04             	add    $0x4,%eax
 92f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 932:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 939:	e9 59 01 00 00       	jmp    a97 <printf+0x17b>
    c = fmt[i] & 0xff;
 93e:	8b 55 0c             	mov    0xc(%ebp),%edx
 941:	8b 45 f0             	mov    -0x10(%ebp),%eax
 944:	01 d0                	add    %edx,%eax
 946:	0f b6 00             	movzbl (%eax),%eax
 949:	0f be c0             	movsbl %al,%eax
 94c:	25 ff 00 00 00       	and    $0xff,%eax
 951:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 954:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 958:	75 2c                	jne    986 <printf+0x6a>
      if(c == '%'){
 95a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 95e:	75 0c                	jne    96c <printf+0x50>
        state = '%';
 960:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 967:	e9 27 01 00 00       	jmp    a93 <printf+0x177>
      } else {
        putc(fd, c);
 96c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 96f:	0f be c0             	movsbl %al,%eax
 972:	83 ec 08             	sub    $0x8,%esp
 975:	50                   	push   %eax
 976:	ff 75 08             	pushl  0x8(%ebp)
 979:	e8 c7 fe ff ff       	call   845 <putc>
 97e:	83 c4 10             	add    $0x10,%esp
 981:	e9 0d 01 00 00       	jmp    a93 <printf+0x177>
      }
    } else if(state == '%'){
 986:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 98a:	0f 85 03 01 00 00    	jne    a93 <printf+0x177>
      if(c == 'd'){
 990:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 994:	75 1e                	jne    9b4 <printf+0x98>
        printint(fd, *ap, 10, 1);
 996:	8b 45 e8             	mov    -0x18(%ebp),%eax
 999:	8b 00                	mov    (%eax),%eax
 99b:	6a 01                	push   $0x1
 99d:	6a 0a                	push   $0xa
 99f:	50                   	push   %eax
 9a0:	ff 75 08             	pushl  0x8(%ebp)
 9a3:	e8 c0 fe ff ff       	call   868 <printint>
 9a8:	83 c4 10             	add    $0x10,%esp
        ap++;
 9ab:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9af:	e9 d8 00 00 00       	jmp    a8c <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 9b4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 9b8:	74 06                	je     9c0 <printf+0xa4>
 9ba:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 9be:	75 1e                	jne    9de <printf+0xc2>
        printint(fd, *ap, 16, 0);
 9c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9c3:	8b 00                	mov    (%eax),%eax
 9c5:	6a 00                	push   $0x0
 9c7:	6a 10                	push   $0x10
 9c9:	50                   	push   %eax
 9ca:	ff 75 08             	pushl  0x8(%ebp)
 9cd:	e8 96 fe ff ff       	call   868 <printint>
 9d2:	83 c4 10             	add    $0x10,%esp
        ap++;
 9d5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9d9:	e9 ae 00 00 00       	jmp    a8c <printf+0x170>
      } else if(c == 's'){
 9de:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 9e2:	75 43                	jne    a27 <printf+0x10b>
        s = (char*)*ap;
 9e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9e7:	8b 00                	mov    (%eax),%eax
 9e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 9ec:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 9f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9f4:	75 25                	jne    a1b <printf+0xff>
          s = "(null)";
 9f6:	c7 45 f4 98 0e 00 00 	movl   $0xe98,-0xc(%ebp)
        while(*s != 0){
 9fd:	eb 1c                	jmp    a1b <printf+0xff>
          putc(fd, *s);
 9ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a02:	0f b6 00             	movzbl (%eax),%eax
 a05:	0f be c0             	movsbl %al,%eax
 a08:	83 ec 08             	sub    $0x8,%esp
 a0b:	50                   	push   %eax
 a0c:	ff 75 08             	pushl  0x8(%ebp)
 a0f:	e8 31 fe ff ff       	call   845 <putc>
 a14:	83 c4 10             	add    $0x10,%esp
          s++;
 a17:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1e:	0f b6 00             	movzbl (%eax),%eax
 a21:	84 c0                	test   %al,%al
 a23:	75 da                	jne    9ff <printf+0xe3>
 a25:	eb 65                	jmp    a8c <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 a27:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 a2b:	75 1d                	jne    a4a <printf+0x12e>
        putc(fd, *ap);
 a2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a30:	8b 00                	mov    (%eax),%eax
 a32:	0f be c0             	movsbl %al,%eax
 a35:	83 ec 08             	sub    $0x8,%esp
 a38:	50                   	push   %eax
 a39:	ff 75 08             	pushl  0x8(%ebp)
 a3c:	e8 04 fe ff ff       	call   845 <putc>
 a41:	83 c4 10             	add    $0x10,%esp
        ap++;
 a44:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a48:	eb 42                	jmp    a8c <printf+0x170>
      } else if(c == '%'){
 a4a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a4e:	75 17                	jne    a67 <printf+0x14b>
        putc(fd, c);
 a50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a53:	0f be c0             	movsbl %al,%eax
 a56:	83 ec 08             	sub    $0x8,%esp
 a59:	50                   	push   %eax
 a5a:	ff 75 08             	pushl  0x8(%ebp)
 a5d:	e8 e3 fd ff ff       	call   845 <putc>
 a62:	83 c4 10             	add    $0x10,%esp
 a65:	eb 25                	jmp    a8c <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 a67:	83 ec 08             	sub    $0x8,%esp
 a6a:	6a 25                	push   $0x25
 a6c:	ff 75 08             	pushl  0x8(%ebp)
 a6f:	e8 d1 fd ff ff       	call   845 <putc>
 a74:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 a77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a7a:	0f be c0             	movsbl %al,%eax
 a7d:	83 ec 08             	sub    $0x8,%esp
 a80:	50                   	push   %eax
 a81:	ff 75 08             	pushl  0x8(%ebp)
 a84:	e8 bc fd ff ff       	call   845 <putc>
 a89:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 a8c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a93:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 a97:	8b 55 0c             	mov    0xc(%ebp),%edx
 a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a9d:	01 d0                	add    %edx,%eax
 a9f:	0f b6 00             	movzbl (%eax),%eax
 aa2:	84 c0                	test   %al,%al
 aa4:	0f 85 94 fe ff ff    	jne    93e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 aaa:	90                   	nop
 aab:	c9                   	leave  
 aac:	c3                   	ret    

00000aad <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 aad:	55                   	push   %ebp
 aae:	89 e5                	mov    %esp,%ebp
 ab0:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 ab3:	8b 45 08             	mov    0x8(%ebp),%eax
 ab6:	83 e8 08             	sub    $0x8,%eax
 ab9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 abc:	a1 e4 11 00 00       	mov    0x11e4,%eax
 ac1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 ac4:	eb 24                	jmp    aea <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ac6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ac9:	8b 00                	mov    (%eax),%eax
 acb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 ace:	77 12                	ja     ae2 <free+0x35>
 ad0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ad3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 ad6:	77 24                	ja     afc <free+0x4f>
 ad8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 adb:	8b 00                	mov    (%eax),%eax
 add:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 ae0:	77 1a                	ja     afc <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ae2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ae5:	8b 00                	mov    (%eax),%eax
 ae7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 aea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aed:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 af0:	76 d4                	jbe    ac6 <free+0x19>
 af2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 af5:	8b 00                	mov    (%eax),%eax
 af7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 afa:	76 ca                	jbe    ac6 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 afc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aff:	8b 40 04             	mov    0x4(%eax),%eax
 b02:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b09:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b0c:	01 c2                	add    %eax,%edx
 b0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b11:	8b 00                	mov    (%eax),%eax
 b13:	39 c2                	cmp    %eax,%edx
 b15:	75 24                	jne    b3b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 b17:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b1a:	8b 50 04             	mov    0x4(%eax),%edx
 b1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b20:	8b 00                	mov    (%eax),%eax
 b22:	8b 40 04             	mov    0x4(%eax),%eax
 b25:	01 c2                	add    %eax,%edx
 b27:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b2a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 b2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b30:	8b 00                	mov    (%eax),%eax
 b32:	8b 10                	mov    (%eax),%edx
 b34:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b37:	89 10                	mov    %edx,(%eax)
 b39:	eb 0a                	jmp    b45 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 b3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b3e:	8b 10                	mov    (%eax),%edx
 b40:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b43:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 b45:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b48:	8b 40 04             	mov    0x4(%eax),%eax
 b4b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b52:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b55:	01 d0                	add    %edx,%eax
 b57:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b5a:	75 20                	jne    b7c <free+0xcf>
    p->s.size += bp->s.size;
 b5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b5f:	8b 50 04             	mov    0x4(%eax),%edx
 b62:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b65:	8b 40 04             	mov    0x4(%eax),%eax
 b68:	01 c2                	add    %eax,%edx
 b6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b6d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b70:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b73:	8b 10                	mov    (%eax),%edx
 b75:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b78:	89 10                	mov    %edx,(%eax)
 b7a:	eb 08                	jmp    b84 <free+0xd7>
  } else
    p->s.ptr = bp;
 b7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b7f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 b82:	89 10                	mov    %edx,(%eax)
  freep = p;
 b84:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b87:	a3 e4 11 00 00       	mov    %eax,0x11e4
}
 b8c:	90                   	nop
 b8d:	c9                   	leave  
 b8e:	c3                   	ret    

00000b8f <morecore>:

static Header*
morecore(uint nu)
{
 b8f:	55                   	push   %ebp
 b90:	89 e5                	mov    %esp,%ebp
 b92:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 b95:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 b9c:	77 07                	ja     ba5 <morecore+0x16>
    nu = 4096;
 b9e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 ba5:	8b 45 08             	mov    0x8(%ebp),%eax
 ba8:	c1 e0 03             	shl    $0x3,%eax
 bab:	83 ec 0c             	sub    $0xc,%esp
 bae:	50                   	push   %eax
 baf:	e8 71 fc ff ff       	call   825 <sbrk>
 bb4:	83 c4 10             	add    $0x10,%esp
 bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 bba:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 bbe:	75 07                	jne    bc7 <morecore+0x38>
    return 0;
 bc0:	b8 00 00 00 00       	mov    $0x0,%eax
 bc5:	eb 26                	jmp    bed <morecore+0x5e>
  hp = (Header*)p;
 bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 bcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bd0:	8b 55 08             	mov    0x8(%ebp),%edx
 bd3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bd9:	83 c0 08             	add    $0x8,%eax
 bdc:	83 ec 0c             	sub    $0xc,%esp
 bdf:	50                   	push   %eax
 be0:	e8 c8 fe ff ff       	call   aad <free>
 be5:	83 c4 10             	add    $0x10,%esp
  return freep;
 be8:	a1 e4 11 00 00       	mov    0x11e4,%eax
}
 bed:	c9                   	leave  
 bee:	c3                   	ret    

00000bef <malloc>:

void*
malloc(uint nbytes)
{
 bef:	55                   	push   %ebp
 bf0:	89 e5                	mov    %esp,%ebp
 bf2:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bf5:	8b 45 08             	mov    0x8(%ebp),%eax
 bf8:	83 c0 07             	add    $0x7,%eax
 bfb:	c1 e8 03             	shr    $0x3,%eax
 bfe:	83 c0 01             	add    $0x1,%eax
 c01:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 c04:	a1 e4 11 00 00       	mov    0x11e4,%eax
 c09:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 c10:	75 23                	jne    c35 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 c12:	c7 45 f0 dc 11 00 00 	movl   $0x11dc,-0x10(%ebp)
 c19:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c1c:	a3 e4 11 00 00       	mov    %eax,0x11e4
 c21:	a1 e4 11 00 00       	mov    0x11e4,%eax
 c26:	a3 dc 11 00 00       	mov    %eax,0x11dc
    base.s.size = 0;
 c2b:	c7 05 e0 11 00 00 00 	movl   $0x0,0x11e0
 c32:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c35:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c38:	8b 00                	mov    (%eax),%eax
 c3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c40:	8b 40 04             	mov    0x4(%eax),%eax
 c43:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 c46:	72 4d                	jb     c95 <malloc+0xa6>
      if(p->s.size == nunits)
 c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c4b:	8b 40 04             	mov    0x4(%eax),%eax
 c4e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 c51:	75 0c                	jne    c5f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c56:	8b 10                	mov    (%eax),%edx
 c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c5b:	89 10                	mov    %edx,(%eax)
 c5d:	eb 26                	jmp    c85 <malloc+0x96>
      else {
        p->s.size -= nunits;
 c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c62:	8b 40 04             	mov    0x4(%eax),%eax
 c65:	2b 45 ec             	sub    -0x14(%ebp),%eax
 c68:	89 c2                	mov    %eax,%edx
 c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c6d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c73:	8b 40 04             	mov    0x4(%eax),%eax
 c76:	c1 e0 03             	shl    $0x3,%eax
 c79:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c7f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 c82:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c88:	a3 e4 11 00 00       	mov    %eax,0x11e4
      return (void*)(p + 1);
 c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c90:	83 c0 08             	add    $0x8,%eax
 c93:	eb 3b                	jmp    cd0 <malloc+0xe1>
    }
    if(p == freep)
 c95:	a1 e4 11 00 00       	mov    0x11e4,%eax
 c9a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 c9d:	75 1e                	jne    cbd <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 c9f:	83 ec 0c             	sub    $0xc,%esp
 ca2:	ff 75 ec             	pushl  -0x14(%ebp)
 ca5:	e8 e5 fe ff ff       	call   b8f <morecore>
 caa:	83 c4 10             	add    $0x10,%esp
 cad:	89 45 f4             	mov    %eax,-0xc(%ebp)
 cb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 cb4:	75 07                	jne    cbd <malloc+0xce>
        return 0;
 cb6:	b8 00 00 00 00       	mov    $0x0,%eax
 cbb:	eb 13                	jmp    cd0 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cc6:	8b 00                	mov    (%eax),%eax
 cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 ccb:	e9 6d ff ff ff       	jmp    c3d <malloc+0x4e>
}
 cd0:	c9                   	leave  
 cd1:	c3                   	ret    
