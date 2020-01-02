
_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"
int g;
int func();
int main(int argc, char **argv){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
	int* a=(int*)malloc(sizeof(int)*600);
  11:	83 ec 0c             	sub    $0xc,%esp
  14:	68 60 09 00 00       	push   $0x960
  19:	e8 42 07 00 00       	call   760 <malloc>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int* b=(int*)malloc(sizeof(int)*600);
  24:	83 ec 0c             	sub    $0xc,%esp
  27:	68 60 09 00 00       	push   $0x960
  2c:	e8 2f 07 00 00       	call   760 <malloc>
  31:	83 c4 10             	add    $0x10,%esp
  34:	89 45 f0             	mov    %eax,-0x10(%ebp)
	printf(1,"main : %x, data : %x   a-heap:%p b-heap:%p\n",main,&g,a,b);
  37:	83 ec 08             	sub    $0x8,%esp
  3a:	ff 75 f0             	pushl  -0x10(%ebp)
  3d:	ff 75 f4             	pushl  -0xc(%ebp)
  40:	68 20 0b 00 00       	push   $0xb20
  45:	68 00 00 00 00       	push   $0x0
  4a:	68 44 08 00 00       	push   $0x844
  4f:	6a 01                	push   $0x1
  51:	e8 37 04 00 00       	call   48d <printf>
  56:	83 c4 20             	add    $0x20,%esp
	printf(1,"printf: %x\n",printf);
  59:	83 ec 04             	sub    $0x4,%esp
  5c:	68 8d 04 00 00       	push   $0x48d
  61:	68 70 08 00 00       	push   $0x870
  66:	6a 01                	push   $0x1
  68:	e8 20 04 00 00       	call   48d <printf>
  6d:	83 c4 10             	add    $0x10,%esp
//	for(int i=0;i<20;i++){
//		printf(1,"%d heap : %x\n",i,(int*)malloc(sizeof(int)*900));
//	}
	func();
  70:	e8 05 00 00 00       	call   7a <func>
	exit();
  75:	e8 94 02 00 00       	call   30e <exit>

0000007a <func>:
}
int func(){
  7a:	55                   	push   %ebp
  7b:	89 e5                	mov    %esp,%ebp
  7d:	83 ec 18             	sub    $0x18,%esp
	int k=0;
  80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int* c=(int*)malloc(sizeof(int)*600);
  87:	83 ec 0c             	sub    $0xc,%esp
  8a:	68 60 09 00 00       	push   $0x960
  8f:	e8 cc 06 00 00       	call   760 <malloc>
  94:	83 c4 10             	add    $0x10,%esp
  97:	89 45 f4             	mov    %eax,-0xc(%ebp)
	printf(1,"func:%p c-heap:%p\n",&k,c);
  9a:	ff 75 f4             	pushl  -0xc(%ebp)
  9d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  a0:	50                   	push   %eax
  a1:	68 7c 08 00 00       	push   $0x87c
  a6:	6a 01                	push   $0x1
  a8:	e8 e0 03 00 00       	call   48d <printf>
  ad:	83 c4 10             	add    $0x10,%esp
	return 0;
  b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  b5:	c9                   	leave  
  b6:	c3                   	ret    

000000b7 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  b7:	55                   	push   %ebp
  b8:	89 e5                	mov    %esp,%ebp
  ba:	57                   	push   %edi
  bb:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  bf:	8b 55 10             	mov    0x10(%ebp),%edx
  c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  c5:	89 cb                	mov    %ecx,%ebx
  c7:	89 df                	mov    %ebx,%edi
  c9:	89 d1                	mov    %edx,%ecx
  cb:	fc                   	cld    
  cc:	f3 aa                	rep stos %al,%es:(%edi)
  ce:	89 ca                	mov    %ecx,%edx
  d0:	89 fb                	mov    %edi,%ebx
  d2:	89 5d 08             	mov    %ebx,0x8(%ebp)
  d5:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  d8:	90                   	nop
  d9:	5b                   	pop    %ebx
  da:	5f                   	pop    %edi
  db:	5d                   	pop    %ebp
  dc:	c3                   	ret    

000000dd <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  dd:	55                   	push   %ebp
  de:	89 e5                	mov    %esp,%ebp
  e0:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
  e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  e9:	90                   	nop
  ea:	8b 45 08             	mov    0x8(%ebp),%eax
  ed:	8d 50 01             	lea    0x1(%eax),%edx
  f0:	89 55 08             	mov    %edx,0x8(%ebp)
  f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  f6:	8d 4a 01             	lea    0x1(%edx),%ecx
  f9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  fc:	0f b6 12             	movzbl (%edx),%edx
  ff:	88 10                	mov    %dl,(%eax)
 101:	0f b6 00             	movzbl (%eax),%eax
 104:	84 c0                	test   %al,%al
 106:	75 e2                	jne    ea <strcpy+0xd>
    ;
  return os;
 108:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 10b:	c9                   	leave  
 10c:	c3                   	ret    

0000010d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 10d:	55                   	push   %ebp
 10e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 110:	eb 08                	jmp    11a <strcmp+0xd>
    p++, q++;
 112:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 116:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 11a:	8b 45 08             	mov    0x8(%ebp),%eax
 11d:	0f b6 00             	movzbl (%eax),%eax
 120:	84 c0                	test   %al,%al
 122:	74 10                	je     134 <strcmp+0x27>
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	0f b6 10             	movzbl (%eax),%edx
 12a:	8b 45 0c             	mov    0xc(%ebp),%eax
 12d:	0f b6 00             	movzbl (%eax),%eax
 130:	38 c2                	cmp    %al,%dl
 132:	74 de                	je     112 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	0f b6 00             	movzbl (%eax),%eax
 13a:	0f b6 d0             	movzbl %al,%edx
 13d:	8b 45 0c             	mov    0xc(%ebp),%eax
 140:	0f b6 00             	movzbl (%eax),%eax
 143:	0f b6 c0             	movzbl %al,%eax
 146:	29 c2                	sub    %eax,%edx
 148:	89 d0                	mov    %edx,%eax
}
 14a:	5d                   	pop    %ebp
 14b:	c3                   	ret    

0000014c <strlen>:

uint
strlen(char *s)
{
 14c:	55                   	push   %ebp
 14d:	89 e5                	mov    %esp,%ebp
 14f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 152:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 159:	eb 04                	jmp    15f <strlen+0x13>
 15b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 15f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 162:	8b 45 08             	mov    0x8(%ebp),%eax
 165:	01 d0                	add    %edx,%eax
 167:	0f b6 00             	movzbl (%eax),%eax
 16a:	84 c0                	test   %al,%al
 16c:	75 ed                	jne    15b <strlen+0xf>
    ;
  return n;
 16e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 171:	c9                   	leave  
 172:	c3                   	ret    

00000173 <memset>:

void*
memset(void *dst, int c, uint n)
{
 173:	55                   	push   %ebp
 174:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 176:	8b 45 10             	mov    0x10(%ebp),%eax
 179:	50                   	push   %eax
 17a:	ff 75 0c             	pushl  0xc(%ebp)
 17d:	ff 75 08             	pushl  0x8(%ebp)
 180:	e8 32 ff ff ff       	call   b7 <stosb>
 185:	83 c4 0c             	add    $0xc,%esp
  return dst;
 188:	8b 45 08             	mov    0x8(%ebp),%eax
}
 18b:	c9                   	leave  
 18c:	c3                   	ret    

0000018d <strchr>:

char*
strchr(const char *s, char c)
{
 18d:	55                   	push   %ebp
 18e:	89 e5                	mov    %esp,%ebp
 190:	83 ec 04             	sub    $0x4,%esp
 193:	8b 45 0c             	mov    0xc(%ebp),%eax
 196:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 199:	eb 14                	jmp    1af <strchr+0x22>
    if(*s == c)
 19b:	8b 45 08             	mov    0x8(%ebp),%eax
 19e:	0f b6 00             	movzbl (%eax),%eax
 1a1:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1a4:	75 05                	jne    1ab <strchr+0x1e>
      return (char*)s;
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
 1a9:	eb 13                	jmp    1be <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1ab:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1af:	8b 45 08             	mov    0x8(%ebp),%eax
 1b2:	0f b6 00             	movzbl (%eax),%eax
 1b5:	84 c0                	test   %al,%al
 1b7:	75 e2                	jne    19b <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1be:	c9                   	leave  
 1bf:	c3                   	ret    

000001c0 <gets>:

char*
gets(char *buf, int max)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1cd:	eb 42                	jmp    211 <gets+0x51>
    cc = read(0, &c, 1);
 1cf:	83 ec 04             	sub    $0x4,%esp
 1d2:	6a 01                	push   $0x1
 1d4:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1d7:	50                   	push   %eax
 1d8:	6a 00                	push   $0x0
 1da:	e8 47 01 00 00       	call   326 <read>
 1df:	83 c4 10             	add    $0x10,%esp
 1e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1e9:	7e 33                	jle    21e <gets+0x5e>
      break;
    buf[i++] = c;
 1eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ee:	8d 50 01             	lea    0x1(%eax),%edx
 1f1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1f4:	89 c2                	mov    %eax,%edx
 1f6:	8b 45 08             	mov    0x8(%ebp),%eax
 1f9:	01 c2                	add    %eax,%edx
 1fb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ff:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 201:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 205:	3c 0a                	cmp    $0xa,%al
 207:	74 16                	je     21f <gets+0x5f>
 209:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 20d:	3c 0d                	cmp    $0xd,%al
 20f:	74 0e                	je     21f <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 211:	8b 45 f4             	mov    -0xc(%ebp),%eax
 214:	83 c0 01             	add    $0x1,%eax
 217:	3b 45 0c             	cmp    0xc(%ebp),%eax
 21a:	7c b3                	jl     1cf <gets+0xf>
 21c:	eb 01                	jmp    21f <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 21e:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 21f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 222:	8b 45 08             	mov    0x8(%ebp),%eax
 225:	01 d0                	add    %edx,%eax
 227:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 22a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 22d:	c9                   	leave  
 22e:	c3                   	ret    

0000022f <stat>:

int
stat(char *n, struct stat *st)
{
 22f:	55                   	push   %ebp
 230:	89 e5                	mov    %esp,%ebp
 232:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 235:	83 ec 08             	sub    $0x8,%esp
 238:	6a 00                	push   $0x0
 23a:	ff 75 08             	pushl  0x8(%ebp)
 23d:	e8 0c 01 00 00       	call   34e <open>
 242:	83 c4 10             	add    $0x10,%esp
 245:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 248:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 24c:	79 07                	jns    255 <stat+0x26>
    return -1;
 24e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 253:	eb 25                	jmp    27a <stat+0x4b>
  r = fstat(fd, st);
 255:	83 ec 08             	sub    $0x8,%esp
 258:	ff 75 0c             	pushl  0xc(%ebp)
 25b:	ff 75 f4             	pushl  -0xc(%ebp)
 25e:	e8 03 01 00 00       	call   366 <fstat>
 263:	83 c4 10             	add    $0x10,%esp
 266:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 269:	83 ec 0c             	sub    $0xc,%esp
 26c:	ff 75 f4             	pushl  -0xc(%ebp)
 26f:	e8 c2 00 00 00       	call   336 <close>
 274:	83 c4 10             	add    $0x10,%esp
  return r;
 277:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 27a:	c9                   	leave  
 27b:	c3                   	ret    

0000027c <atoi>:

int
atoi(const char *s)
{
 27c:	55                   	push   %ebp
 27d:	89 e5                	mov    %esp,%ebp
 27f:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 282:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 289:	eb 25                	jmp    2b0 <atoi+0x34>
    n = n*10 + *s++ - '0';
 28b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 28e:	89 d0                	mov    %edx,%eax
 290:	c1 e0 02             	shl    $0x2,%eax
 293:	01 d0                	add    %edx,%eax
 295:	01 c0                	add    %eax,%eax
 297:	89 c1                	mov    %eax,%ecx
 299:	8b 45 08             	mov    0x8(%ebp),%eax
 29c:	8d 50 01             	lea    0x1(%eax),%edx
 29f:	89 55 08             	mov    %edx,0x8(%ebp)
 2a2:	0f b6 00             	movzbl (%eax),%eax
 2a5:	0f be c0             	movsbl %al,%eax
 2a8:	01 c8                	add    %ecx,%eax
 2aa:	83 e8 30             	sub    $0x30,%eax
 2ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b0:	8b 45 08             	mov    0x8(%ebp),%eax
 2b3:	0f b6 00             	movzbl (%eax),%eax
 2b6:	3c 2f                	cmp    $0x2f,%al
 2b8:	7e 0a                	jle    2c4 <atoi+0x48>
 2ba:	8b 45 08             	mov    0x8(%ebp),%eax
 2bd:	0f b6 00             	movzbl (%eax),%eax
 2c0:	3c 39                	cmp    $0x39,%al
 2c2:	7e c7                	jle    28b <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2c7:	c9                   	leave  
 2c8:	c3                   	ret    

000002c9 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2c9:	55                   	push   %ebp
 2ca:	89 e5                	mov    %esp,%ebp
 2cc:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
 2d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2db:	eb 17                	jmp    2f4 <memmove+0x2b>
    *dst++ = *src++;
 2dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2e0:	8d 50 01             	lea    0x1(%eax),%edx
 2e3:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2e6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2e9:	8d 4a 01             	lea    0x1(%edx),%ecx
 2ec:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2ef:	0f b6 12             	movzbl (%edx),%edx
 2f2:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2f4:	8b 45 10             	mov    0x10(%ebp),%eax
 2f7:	8d 50 ff             	lea    -0x1(%eax),%edx
 2fa:	89 55 10             	mov    %edx,0x10(%ebp)
 2fd:	85 c0                	test   %eax,%eax
 2ff:	7f dc                	jg     2dd <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 301:	8b 45 08             	mov    0x8(%ebp),%eax
}
 304:	c9                   	leave  
 305:	c3                   	ret    

00000306 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 306:	b8 01 00 00 00       	mov    $0x1,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret    

0000030e <exit>:
SYSCALL(exit)
 30e:	b8 02 00 00 00       	mov    $0x2,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    

00000316 <wait>:
SYSCALL(wait)
 316:	b8 03 00 00 00       	mov    $0x3,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <pipe>:
SYSCALL(pipe)
 31e:	b8 04 00 00 00       	mov    $0x4,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <read>:
SYSCALL(read)
 326:	b8 05 00 00 00       	mov    $0x5,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <write>:
SYSCALL(write)
 32e:	b8 10 00 00 00       	mov    $0x10,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <close>:
SYSCALL(close)
 336:	b8 15 00 00 00       	mov    $0x15,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <kill>:
SYSCALL(kill)
 33e:	b8 06 00 00 00       	mov    $0x6,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <exec>:
SYSCALL(exec)
 346:	b8 07 00 00 00       	mov    $0x7,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <open>:
SYSCALL(open)
 34e:	b8 0f 00 00 00       	mov    $0xf,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <mknod>:
SYSCALL(mknod)
 356:	b8 11 00 00 00       	mov    $0x11,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <unlink>:
SYSCALL(unlink)
 35e:	b8 12 00 00 00       	mov    $0x12,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <fstat>:
SYSCALL(fstat)
 366:	b8 08 00 00 00       	mov    $0x8,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <link>:
SYSCALL(link)
 36e:	b8 13 00 00 00       	mov    $0x13,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <mkdir>:
SYSCALL(mkdir)
 376:	b8 14 00 00 00       	mov    $0x14,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <chdir>:
SYSCALL(chdir)
 37e:	b8 09 00 00 00       	mov    $0x9,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <dup>:
SYSCALL(dup)
 386:	b8 0a 00 00 00       	mov    $0xa,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <getpid>:
SYSCALL(getpid)
 38e:	b8 0b 00 00 00       	mov    $0xb,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <sbrk>:
SYSCALL(sbrk)
 396:	b8 0c 00 00 00       	mov    $0xc,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <sleep>:
SYSCALL(sleep)
 39e:	b8 0d 00 00 00       	mov    $0xd,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <uptime>:
SYSCALL(uptime)
 3a6:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <halt>:
SYSCALL(halt)
 3ae:	b8 16 00 00 00       	mov    $0x16,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3b6:	55                   	push   %ebp
 3b7:	89 e5                	mov    %esp,%ebp
 3b9:	83 ec 18             	sub    $0x18,%esp
 3bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bf:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3c2:	83 ec 04             	sub    $0x4,%esp
 3c5:	6a 01                	push   $0x1
 3c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3ca:	50                   	push   %eax
 3cb:	ff 75 08             	pushl  0x8(%ebp)
 3ce:	e8 5b ff ff ff       	call   32e <write>
 3d3:	83 c4 10             	add    $0x10,%esp
}
 3d6:	90                   	nop
 3d7:	c9                   	leave  
 3d8:	c3                   	ret    

000003d9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d9:	55                   	push   %ebp
 3da:	89 e5                	mov    %esp,%ebp
 3dc:	53                   	push   %ebx
 3dd:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3e7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3eb:	74 17                	je     404 <printint+0x2b>
 3ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3f1:	79 11                	jns    404 <printint+0x2b>
    neg = 1;
 3f3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fd:	f7 d8                	neg    %eax
 3ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
 402:	eb 06                	jmp    40a <printint+0x31>
  } else {
    x = xx;
 404:	8b 45 0c             	mov    0xc(%ebp),%eax
 407:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 40a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 411:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 414:	8d 41 01             	lea    0x1(%ecx),%eax
 417:	89 45 f4             	mov    %eax,-0xc(%ebp)
 41a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 41d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 420:	ba 00 00 00 00       	mov    $0x0,%edx
 425:	f7 f3                	div    %ebx
 427:	89 d0                	mov    %edx,%eax
 429:	0f b6 80 00 0b 00 00 	movzbl 0xb00(%eax),%eax
 430:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 434:	8b 5d 10             	mov    0x10(%ebp),%ebx
 437:	8b 45 ec             	mov    -0x14(%ebp),%eax
 43a:	ba 00 00 00 00       	mov    $0x0,%edx
 43f:	f7 f3                	div    %ebx
 441:	89 45 ec             	mov    %eax,-0x14(%ebp)
 444:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 448:	75 c7                	jne    411 <printint+0x38>
  if(neg)
 44a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 44e:	74 2d                	je     47d <printint+0xa4>
    buf[i++] = '-';
 450:	8b 45 f4             	mov    -0xc(%ebp),%eax
 453:	8d 50 01             	lea    0x1(%eax),%edx
 456:	89 55 f4             	mov    %edx,-0xc(%ebp)
 459:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 45e:	eb 1d                	jmp    47d <printint+0xa4>
    putc(fd, buf[i]);
 460:	8d 55 dc             	lea    -0x24(%ebp),%edx
 463:	8b 45 f4             	mov    -0xc(%ebp),%eax
 466:	01 d0                	add    %edx,%eax
 468:	0f b6 00             	movzbl (%eax),%eax
 46b:	0f be c0             	movsbl %al,%eax
 46e:	83 ec 08             	sub    $0x8,%esp
 471:	50                   	push   %eax
 472:	ff 75 08             	pushl  0x8(%ebp)
 475:	e8 3c ff ff ff       	call   3b6 <putc>
 47a:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 47d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 481:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 485:	79 d9                	jns    460 <printint+0x87>
    putc(fd, buf[i]);
}
 487:	90                   	nop
 488:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 48b:	c9                   	leave  
 48c:	c3                   	ret    

0000048d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 48d:	55                   	push   %ebp
 48e:	89 e5                	mov    %esp,%ebp
 490:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 493:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 49a:	8d 45 0c             	lea    0xc(%ebp),%eax
 49d:	83 c0 04             	add    $0x4,%eax
 4a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4aa:	e9 59 01 00 00       	jmp    608 <printf+0x17b>
    c = fmt[i] & 0xff;
 4af:	8b 55 0c             	mov    0xc(%ebp),%edx
 4b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4b5:	01 d0                	add    %edx,%eax
 4b7:	0f b6 00             	movzbl (%eax),%eax
 4ba:	0f be c0             	movsbl %al,%eax
 4bd:	25 ff 00 00 00       	and    $0xff,%eax
 4c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c9:	75 2c                	jne    4f7 <printf+0x6a>
      if(c == '%'){
 4cb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4cf:	75 0c                	jne    4dd <printf+0x50>
        state = '%';
 4d1:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4d8:	e9 27 01 00 00       	jmp    604 <printf+0x177>
      } else {
        putc(fd, c);
 4dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4e0:	0f be c0             	movsbl %al,%eax
 4e3:	83 ec 08             	sub    $0x8,%esp
 4e6:	50                   	push   %eax
 4e7:	ff 75 08             	pushl  0x8(%ebp)
 4ea:	e8 c7 fe ff ff       	call   3b6 <putc>
 4ef:	83 c4 10             	add    $0x10,%esp
 4f2:	e9 0d 01 00 00       	jmp    604 <printf+0x177>
      }
    } else if(state == '%'){
 4f7:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4fb:	0f 85 03 01 00 00    	jne    604 <printf+0x177>
      if(c == 'd'){
 501:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 505:	75 1e                	jne    525 <printf+0x98>
        printint(fd, *ap, 10, 1);
 507:	8b 45 e8             	mov    -0x18(%ebp),%eax
 50a:	8b 00                	mov    (%eax),%eax
 50c:	6a 01                	push   $0x1
 50e:	6a 0a                	push   $0xa
 510:	50                   	push   %eax
 511:	ff 75 08             	pushl  0x8(%ebp)
 514:	e8 c0 fe ff ff       	call   3d9 <printint>
 519:	83 c4 10             	add    $0x10,%esp
        ap++;
 51c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 520:	e9 d8 00 00 00       	jmp    5fd <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 525:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 529:	74 06                	je     531 <printf+0xa4>
 52b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 52f:	75 1e                	jne    54f <printf+0xc2>
        printint(fd, *ap, 16, 0);
 531:	8b 45 e8             	mov    -0x18(%ebp),%eax
 534:	8b 00                	mov    (%eax),%eax
 536:	6a 00                	push   $0x0
 538:	6a 10                	push   $0x10
 53a:	50                   	push   %eax
 53b:	ff 75 08             	pushl  0x8(%ebp)
 53e:	e8 96 fe ff ff       	call   3d9 <printint>
 543:	83 c4 10             	add    $0x10,%esp
        ap++;
 546:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 54a:	e9 ae 00 00 00       	jmp    5fd <printf+0x170>
      } else if(c == 's'){
 54f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 553:	75 43                	jne    598 <printf+0x10b>
        s = (char*)*ap;
 555:	8b 45 e8             	mov    -0x18(%ebp),%eax
 558:	8b 00                	mov    (%eax),%eax
 55a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 55d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 561:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 565:	75 25                	jne    58c <printf+0xff>
          s = "(null)";
 567:	c7 45 f4 8f 08 00 00 	movl   $0x88f,-0xc(%ebp)
        while(*s != 0){
 56e:	eb 1c                	jmp    58c <printf+0xff>
          putc(fd, *s);
 570:	8b 45 f4             	mov    -0xc(%ebp),%eax
 573:	0f b6 00             	movzbl (%eax),%eax
 576:	0f be c0             	movsbl %al,%eax
 579:	83 ec 08             	sub    $0x8,%esp
 57c:	50                   	push   %eax
 57d:	ff 75 08             	pushl  0x8(%ebp)
 580:	e8 31 fe ff ff       	call   3b6 <putc>
 585:	83 c4 10             	add    $0x10,%esp
          s++;
 588:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 58c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58f:	0f b6 00             	movzbl (%eax),%eax
 592:	84 c0                	test   %al,%al
 594:	75 da                	jne    570 <printf+0xe3>
 596:	eb 65                	jmp    5fd <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 598:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 59c:	75 1d                	jne    5bb <printf+0x12e>
        putc(fd, *ap);
 59e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a1:	8b 00                	mov    (%eax),%eax
 5a3:	0f be c0             	movsbl %al,%eax
 5a6:	83 ec 08             	sub    $0x8,%esp
 5a9:	50                   	push   %eax
 5aa:	ff 75 08             	pushl  0x8(%ebp)
 5ad:	e8 04 fe ff ff       	call   3b6 <putc>
 5b2:	83 c4 10             	add    $0x10,%esp
        ap++;
 5b5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b9:	eb 42                	jmp    5fd <printf+0x170>
      } else if(c == '%'){
 5bb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5bf:	75 17                	jne    5d8 <printf+0x14b>
        putc(fd, c);
 5c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c4:	0f be c0             	movsbl %al,%eax
 5c7:	83 ec 08             	sub    $0x8,%esp
 5ca:	50                   	push   %eax
 5cb:	ff 75 08             	pushl  0x8(%ebp)
 5ce:	e8 e3 fd ff ff       	call   3b6 <putc>
 5d3:	83 c4 10             	add    $0x10,%esp
 5d6:	eb 25                	jmp    5fd <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5d8:	83 ec 08             	sub    $0x8,%esp
 5db:	6a 25                	push   $0x25
 5dd:	ff 75 08             	pushl  0x8(%ebp)
 5e0:	e8 d1 fd ff ff       	call   3b6 <putc>
 5e5:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5eb:	0f be c0             	movsbl %al,%eax
 5ee:	83 ec 08             	sub    $0x8,%esp
 5f1:	50                   	push   %eax
 5f2:	ff 75 08             	pushl  0x8(%ebp)
 5f5:	e8 bc fd ff ff       	call   3b6 <putc>
 5fa:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5fd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 604:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 608:	8b 55 0c             	mov    0xc(%ebp),%edx
 60b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 60e:	01 d0                	add    %edx,%eax
 610:	0f b6 00             	movzbl (%eax),%eax
 613:	84 c0                	test   %al,%al
 615:	0f 85 94 fe ff ff    	jne    4af <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 61b:	90                   	nop
 61c:	c9                   	leave  
 61d:	c3                   	ret    

0000061e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 61e:	55                   	push   %ebp
 61f:	89 e5                	mov    %esp,%ebp
 621:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 624:	8b 45 08             	mov    0x8(%ebp),%eax
 627:	83 e8 08             	sub    $0x8,%eax
 62a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62d:	a1 1c 0b 00 00       	mov    0xb1c,%eax
 632:	89 45 fc             	mov    %eax,-0x4(%ebp)
 635:	eb 24                	jmp    65b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 637:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63a:	8b 00                	mov    (%eax),%eax
 63c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63f:	77 12                	ja     653 <free+0x35>
 641:	8b 45 f8             	mov    -0x8(%ebp),%eax
 644:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 647:	77 24                	ja     66d <free+0x4f>
 649:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64c:	8b 00                	mov    (%eax),%eax
 64e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 651:	77 1a                	ja     66d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 653:	8b 45 fc             	mov    -0x4(%ebp),%eax
 656:	8b 00                	mov    (%eax),%eax
 658:	89 45 fc             	mov    %eax,-0x4(%ebp)
 65b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 661:	76 d4                	jbe    637 <free+0x19>
 663:	8b 45 fc             	mov    -0x4(%ebp),%eax
 666:	8b 00                	mov    (%eax),%eax
 668:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66b:	76 ca                	jbe    637 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 66d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 670:	8b 40 04             	mov    0x4(%eax),%eax
 673:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 67a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67d:	01 c2                	add    %eax,%edx
 67f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 682:	8b 00                	mov    (%eax),%eax
 684:	39 c2                	cmp    %eax,%edx
 686:	75 24                	jne    6ac <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 688:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68b:	8b 50 04             	mov    0x4(%eax),%edx
 68e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 691:	8b 00                	mov    (%eax),%eax
 693:	8b 40 04             	mov    0x4(%eax),%eax
 696:	01 c2                	add    %eax,%edx
 698:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	8b 00                	mov    (%eax),%eax
 6a3:	8b 10                	mov    (%eax),%edx
 6a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a8:	89 10                	mov    %edx,(%eax)
 6aa:	eb 0a                	jmp    6b6 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6af:	8b 10                	mov    (%eax),%edx
 6b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b4:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b9:	8b 40 04             	mov    0x4(%eax),%eax
 6bc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c6:	01 d0                	add    %edx,%eax
 6c8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6cb:	75 20                	jne    6ed <free+0xcf>
    p->s.size += bp->s.size;
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	8b 50 04             	mov    0x4(%eax),%edx
 6d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d6:	8b 40 04             	mov    0x4(%eax),%eax
 6d9:	01 c2                	add    %eax,%edx
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e4:	8b 10                	mov    (%eax),%edx
 6e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e9:	89 10                	mov    %edx,(%eax)
 6eb:	eb 08                	jmp    6f5 <free+0xd7>
  } else
    p->s.ptr = bp;
 6ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6f3:	89 10                	mov    %edx,(%eax)
  freep = p;
 6f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f8:	a3 1c 0b 00 00       	mov    %eax,0xb1c
}
 6fd:	90                   	nop
 6fe:	c9                   	leave  
 6ff:	c3                   	ret    

00000700 <morecore>:

static Header*
morecore(uint nu)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 706:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 70d:	77 07                	ja     716 <morecore+0x16>
    nu = 4096;
 70f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 716:	8b 45 08             	mov    0x8(%ebp),%eax
 719:	c1 e0 03             	shl    $0x3,%eax
 71c:	83 ec 0c             	sub    $0xc,%esp
 71f:	50                   	push   %eax
 720:	e8 71 fc ff ff       	call   396 <sbrk>
 725:	83 c4 10             	add    $0x10,%esp
 728:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 72b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 72f:	75 07                	jne    738 <morecore+0x38>
    return 0;
 731:	b8 00 00 00 00       	mov    $0x0,%eax
 736:	eb 26                	jmp    75e <morecore+0x5e>
  hp = (Header*)p;
 738:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 73e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 741:	8b 55 08             	mov    0x8(%ebp),%edx
 744:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 747:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74a:	83 c0 08             	add    $0x8,%eax
 74d:	83 ec 0c             	sub    $0xc,%esp
 750:	50                   	push   %eax
 751:	e8 c8 fe ff ff       	call   61e <free>
 756:	83 c4 10             	add    $0x10,%esp
  return freep;
 759:	a1 1c 0b 00 00       	mov    0xb1c,%eax
}
 75e:	c9                   	leave  
 75f:	c3                   	ret    

00000760 <malloc>:

void*
malloc(uint nbytes)
{
 760:	55                   	push   %ebp
 761:	89 e5                	mov    %esp,%ebp
 763:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 766:	8b 45 08             	mov    0x8(%ebp),%eax
 769:	83 c0 07             	add    $0x7,%eax
 76c:	c1 e8 03             	shr    $0x3,%eax
 76f:	83 c0 01             	add    $0x1,%eax
 772:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 775:	a1 1c 0b 00 00       	mov    0xb1c,%eax
 77a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 77d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 781:	75 23                	jne    7a6 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 783:	c7 45 f0 14 0b 00 00 	movl   $0xb14,-0x10(%ebp)
 78a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78d:	a3 1c 0b 00 00       	mov    %eax,0xb1c
 792:	a1 1c 0b 00 00       	mov    0xb1c,%eax
 797:	a3 14 0b 00 00       	mov    %eax,0xb14
    base.s.size = 0;
 79c:	c7 05 18 0b 00 00 00 	movl   $0x0,0xb18
 7a3:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a9:	8b 00                	mov    (%eax),%eax
 7ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b1:	8b 40 04             	mov    0x4(%eax),%eax
 7b4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b7:	72 4d                	jb     806 <malloc+0xa6>
      if(p->s.size == nunits)
 7b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bc:	8b 40 04             	mov    0x4(%eax),%eax
 7bf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c2:	75 0c                	jne    7d0 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c7:	8b 10                	mov    (%eax),%edx
 7c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cc:	89 10                	mov    %edx,(%eax)
 7ce:	eb 26                	jmp    7f6 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d3:	8b 40 04             	mov    0x4(%eax),%eax
 7d6:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7d9:	89 c2                	mov    %eax,%edx
 7db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7de:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e4:	8b 40 04             	mov    0x4(%eax),%eax
 7e7:	c1 e0 03             	shl    $0x3,%eax
 7ea:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7f3:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f9:	a3 1c 0b 00 00       	mov    %eax,0xb1c
      return (void*)(p + 1);
 7fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 801:	83 c0 08             	add    $0x8,%eax
 804:	eb 3b                	jmp    841 <malloc+0xe1>
    }
    if(p == freep)
 806:	a1 1c 0b 00 00       	mov    0xb1c,%eax
 80b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 80e:	75 1e                	jne    82e <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 810:	83 ec 0c             	sub    $0xc,%esp
 813:	ff 75 ec             	pushl  -0x14(%ebp)
 816:	e8 e5 fe ff ff       	call   700 <morecore>
 81b:	83 c4 10             	add    $0x10,%esp
 81e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 821:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 825:	75 07                	jne    82e <malloc+0xce>
        return 0;
 827:	b8 00 00 00 00       	mov    $0x0,%eax
 82c:	eb 13                	jmp    841 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 831:	89 45 f0             	mov    %eax,-0x10(%ebp)
 834:	8b 45 f4             	mov    -0xc(%ebp),%eax
 837:	8b 00                	mov    (%eax),%eax
 839:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 83c:	e9 6d ff ff ff       	jmp    7ae <malloc+0x4e>
}
 841:	c9                   	leave  
 842:	c3                   	ret    
