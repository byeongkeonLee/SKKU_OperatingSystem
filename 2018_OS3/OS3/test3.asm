
_test3:     file format elf32-i386


Disassembly of section .text:

00000000 <recursion>:
#include "types.h"
#include "stat.h"
#include "user.h"
#include "memlayout.h"

void recursion(int n){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
	if(n>0){
   6:	8b 45 08             	mov    0x8(%ebp),%eax
   9:	85 c0                	test   %eax,%eax
   b:	7e 59                	jle    66 <recursion+0x66>
		for(int i=8;i>=0;i--){
   d:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
  14:	eb 26                	jmp    3c <recursion+0x3c>
			printf(1,"i(%d) %p\n",i,*(&n-i));
  16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  19:	c1 e0 02             	shl    $0x2,%eax
  1c:	f7 d8                	neg    %eax
  1e:	8d 55 08             	lea    0x8(%ebp),%edx
  21:	01 d0                	add    %edx,%eax
  23:	8b 00                	mov    (%eax),%eax
  25:	50                   	push   %eax
  26:	ff 75 f4             	pushl  -0xc(%ebp)
  29:	68 31 08 00 00       	push   $0x831
  2e:	6a 01                	push   $0x1
  30:	e8 46 04 00 00       	call   47b <printf>
  35:	83 c4 10             	add    $0x10,%esp
#include "user.h"
#include "memlayout.h"

void recursion(int n){
	if(n>0){
		for(int i=8;i>=0;i--){
  38:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  40:	79 d4                	jns    16 <recursion+0x16>
			printf(1,"i(%d) %p\n",i,*(&n-i));
		}
		recursion(n-1);
  42:	8b 45 08             	mov    0x8(%ebp),%eax
  45:	83 e8 01             	sub    $0x1,%eax
  48:	83 ec 0c             	sub    $0xc,%esp
  4b:	50                   	push   %eax
  4c:	e8 af ff ff ff       	call   0 <recursion>
  51:	83 c4 10             	add    $0x10,%esp
		printf(1,"\n");
  54:	83 ec 08             	sub    $0x8,%esp
  57:	68 3b 08 00 00       	push   $0x83b
  5c:	6a 01                	push   $0x1
  5e:	e8 18 04 00 00       	call   47b <printf>
  63:	83 c4 10             	add    $0x10,%esp
	}
}
  66:	90                   	nop
  67:	c9                   	leave  
  68:	c3                   	ret    

00000069 <main>:

	int
main(int argc, char **argv)
{
  69:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  6d:	83 e4 f0             	and    $0xfffffff0,%esp
  70:	ff 71 fc             	pushl  -0x4(%ecx)
  73:	55                   	push   %ebp
  74:	89 e5                	mov    %esp,%ebp
  76:	51                   	push   %ecx
  77:	83 ec 04             	sub    $0x4,%esp
	// stack growth test
	printf(1,"recursion : %p main : %p\n",recursion,main);
  7a:	68 69 00 00 00       	push   $0x69
  7f:	68 00 00 00 00       	push   $0x0
  84:	68 3d 08 00 00       	push   $0x83d
  89:	6a 01                	push   $0x1
  8b:	e8 eb 03 00 00       	call   47b <printf>
  90:	83 c4 10             	add    $0x10,%esp
	recursion(3);
  93:	83 ec 0c             	sub    $0xc,%esp
  96:	6a 03                	push   $0x3
  98:	e8 63 ff ff ff       	call   0 <recursion>
  9d:	83 c4 10             	add    $0x10,%esp
	exit();
  a0:	e8 57 02 00 00       	call   2fc <exit>

000000a5 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  a5:	55                   	push   %ebp
  a6:	89 e5                	mov    %esp,%ebp
  a8:	57                   	push   %edi
  a9:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ad:	8b 55 10             	mov    0x10(%ebp),%edx
  b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  b3:	89 cb                	mov    %ecx,%ebx
  b5:	89 df                	mov    %ebx,%edi
  b7:	89 d1                	mov    %edx,%ecx
  b9:	fc                   	cld    
  ba:	f3 aa                	rep stos %al,%es:(%edi)
  bc:	89 ca                	mov    %ecx,%edx
  be:	89 fb                	mov    %edi,%ebx
  c0:	89 5d 08             	mov    %ebx,0x8(%ebp)
  c3:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  c6:	90                   	nop
  c7:	5b                   	pop    %ebx
  c8:	5f                   	pop    %edi
  c9:	5d                   	pop    %ebp
  ca:	c3                   	ret    

000000cb <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  cb:	55                   	push   %ebp
  cc:	89 e5                	mov    %esp,%ebp
  ce:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  d1:	8b 45 08             	mov    0x8(%ebp),%eax
  d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  d7:	90                   	nop
  d8:	8b 45 08             	mov    0x8(%ebp),%eax
  db:	8d 50 01             	lea    0x1(%eax),%edx
  de:	89 55 08             	mov    %edx,0x8(%ebp)
  e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  e4:	8d 4a 01             	lea    0x1(%edx),%ecx
  e7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  ea:	0f b6 12             	movzbl (%edx),%edx
  ed:	88 10                	mov    %dl,(%eax)
  ef:	0f b6 00             	movzbl (%eax),%eax
  f2:	84 c0                	test   %al,%al
  f4:	75 e2                	jne    d8 <strcpy+0xd>
    ;
  return os;
  f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  f9:	c9                   	leave  
  fa:	c3                   	ret    

000000fb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  fb:	55                   	push   %ebp
  fc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  fe:	eb 08                	jmp    108 <strcmp+0xd>
    p++, q++;
 100:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 104:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 108:	8b 45 08             	mov    0x8(%ebp),%eax
 10b:	0f b6 00             	movzbl (%eax),%eax
 10e:	84 c0                	test   %al,%al
 110:	74 10                	je     122 <strcmp+0x27>
 112:	8b 45 08             	mov    0x8(%ebp),%eax
 115:	0f b6 10             	movzbl (%eax),%edx
 118:	8b 45 0c             	mov    0xc(%ebp),%eax
 11b:	0f b6 00             	movzbl (%eax),%eax
 11e:	38 c2                	cmp    %al,%dl
 120:	74 de                	je     100 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 122:	8b 45 08             	mov    0x8(%ebp),%eax
 125:	0f b6 00             	movzbl (%eax),%eax
 128:	0f b6 d0             	movzbl %al,%edx
 12b:	8b 45 0c             	mov    0xc(%ebp),%eax
 12e:	0f b6 00             	movzbl (%eax),%eax
 131:	0f b6 c0             	movzbl %al,%eax
 134:	29 c2                	sub    %eax,%edx
 136:	89 d0                	mov    %edx,%eax
}
 138:	5d                   	pop    %ebp
 139:	c3                   	ret    

0000013a <strlen>:

uint
strlen(char *s)
{
 13a:	55                   	push   %ebp
 13b:	89 e5                	mov    %esp,%ebp
 13d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 140:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 147:	eb 04                	jmp    14d <strlen+0x13>
 149:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 14d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 150:	8b 45 08             	mov    0x8(%ebp),%eax
 153:	01 d0                	add    %edx,%eax
 155:	0f b6 00             	movzbl (%eax),%eax
 158:	84 c0                	test   %al,%al
 15a:	75 ed                	jne    149 <strlen+0xf>
    ;
  return n;
 15c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 15f:	c9                   	leave  
 160:	c3                   	ret    

00000161 <memset>:

void*
memset(void *dst, int c, uint n)
{
 161:	55                   	push   %ebp
 162:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 164:	8b 45 10             	mov    0x10(%ebp),%eax
 167:	50                   	push   %eax
 168:	ff 75 0c             	pushl  0xc(%ebp)
 16b:	ff 75 08             	pushl  0x8(%ebp)
 16e:	e8 32 ff ff ff       	call   a5 <stosb>
 173:	83 c4 0c             	add    $0xc,%esp
  return dst;
 176:	8b 45 08             	mov    0x8(%ebp),%eax
}
 179:	c9                   	leave  
 17a:	c3                   	ret    

0000017b <strchr>:

char*
strchr(const char *s, char c)
{
 17b:	55                   	push   %ebp
 17c:	89 e5                	mov    %esp,%ebp
 17e:	83 ec 04             	sub    $0x4,%esp
 181:	8b 45 0c             	mov    0xc(%ebp),%eax
 184:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 187:	eb 14                	jmp    19d <strchr+0x22>
    if(*s == c)
 189:	8b 45 08             	mov    0x8(%ebp),%eax
 18c:	0f b6 00             	movzbl (%eax),%eax
 18f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 192:	75 05                	jne    199 <strchr+0x1e>
      return (char*)s;
 194:	8b 45 08             	mov    0x8(%ebp),%eax
 197:	eb 13                	jmp    1ac <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 199:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 19d:	8b 45 08             	mov    0x8(%ebp),%eax
 1a0:	0f b6 00             	movzbl (%eax),%eax
 1a3:	84 c0                	test   %al,%al
 1a5:	75 e2                	jne    189 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1ac:	c9                   	leave  
 1ad:	c3                   	ret    

000001ae <gets>:

char*
gets(char *buf, int max)
{
 1ae:	55                   	push   %ebp
 1af:	89 e5                	mov    %esp,%ebp
 1b1:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1bb:	eb 42                	jmp    1ff <gets+0x51>
    cc = read(0, &c, 1);
 1bd:	83 ec 04             	sub    $0x4,%esp
 1c0:	6a 01                	push   $0x1
 1c2:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1c5:	50                   	push   %eax
 1c6:	6a 00                	push   $0x0
 1c8:	e8 47 01 00 00       	call   314 <read>
 1cd:	83 c4 10             	add    $0x10,%esp
 1d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1d7:	7e 33                	jle    20c <gets+0x5e>
      break;
    buf[i++] = c;
 1d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1dc:	8d 50 01             	lea    0x1(%eax),%edx
 1df:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1e2:	89 c2                	mov    %eax,%edx
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
 1e7:	01 c2                	add    %eax,%edx
 1e9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ed:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1ef:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f3:	3c 0a                	cmp    $0xa,%al
 1f5:	74 16                	je     20d <gets+0x5f>
 1f7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1fb:	3c 0d                	cmp    $0xd,%al
 1fd:	74 0e                	je     20d <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 202:	83 c0 01             	add    $0x1,%eax
 205:	3b 45 0c             	cmp    0xc(%ebp),%eax
 208:	7c b3                	jl     1bd <gets+0xf>
 20a:	eb 01                	jmp    20d <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 20c:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 20d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	01 d0                	add    %edx,%eax
 215:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 218:	8b 45 08             	mov    0x8(%ebp),%eax
}
 21b:	c9                   	leave  
 21c:	c3                   	ret    

0000021d <stat>:

int
stat(char *n, struct stat *st)
{
 21d:	55                   	push   %ebp
 21e:	89 e5                	mov    %esp,%ebp
 220:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 223:	83 ec 08             	sub    $0x8,%esp
 226:	6a 00                	push   $0x0
 228:	ff 75 08             	pushl  0x8(%ebp)
 22b:	e8 0c 01 00 00       	call   33c <open>
 230:	83 c4 10             	add    $0x10,%esp
 233:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 236:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 23a:	79 07                	jns    243 <stat+0x26>
    return -1;
 23c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 241:	eb 25                	jmp    268 <stat+0x4b>
  r = fstat(fd, st);
 243:	83 ec 08             	sub    $0x8,%esp
 246:	ff 75 0c             	pushl  0xc(%ebp)
 249:	ff 75 f4             	pushl  -0xc(%ebp)
 24c:	e8 03 01 00 00       	call   354 <fstat>
 251:	83 c4 10             	add    $0x10,%esp
 254:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 257:	83 ec 0c             	sub    $0xc,%esp
 25a:	ff 75 f4             	pushl  -0xc(%ebp)
 25d:	e8 c2 00 00 00       	call   324 <close>
 262:	83 c4 10             	add    $0x10,%esp
  return r;
 265:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 268:	c9                   	leave  
 269:	c3                   	ret    

0000026a <atoi>:

int
atoi(const char *s)
{
 26a:	55                   	push   %ebp
 26b:	89 e5                	mov    %esp,%ebp
 26d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 270:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 277:	eb 25                	jmp    29e <atoi+0x34>
    n = n*10 + *s++ - '0';
 279:	8b 55 fc             	mov    -0x4(%ebp),%edx
 27c:	89 d0                	mov    %edx,%eax
 27e:	c1 e0 02             	shl    $0x2,%eax
 281:	01 d0                	add    %edx,%eax
 283:	01 c0                	add    %eax,%eax
 285:	89 c1                	mov    %eax,%ecx
 287:	8b 45 08             	mov    0x8(%ebp),%eax
 28a:	8d 50 01             	lea    0x1(%eax),%edx
 28d:	89 55 08             	mov    %edx,0x8(%ebp)
 290:	0f b6 00             	movzbl (%eax),%eax
 293:	0f be c0             	movsbl %al,%eax
 296:	01 c8                	add    %ecx,%eax
 298:	83 e8 30             	sub    $0x30,%eax
 29b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 29e:	8b 45 08             	mov    0x8(%ebp),%eax
 2a1:	0f b6 00             	movzbl (%eax),%eax
 2a4:	3c 2f                	cmp    $0x2f,%al
 2a6:	7e 0a                	jle    2b2 <atoi+0x48>
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	0f b6 00             	movzbl (%eax),%eax
 2ae:	3c 39                	cmp    $0x39,%al
 2b0:	7e c7                	jle    279 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2b5:	c9                   	leave  
 2b6:	c3                   	ret    

000002b7 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2b7:	55                   	push   %ebp
 2b8:	89 e5                	mov    %esp,%ebp
 2ba:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
 2c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2c9:	eb 17                	jmp    2e2 <memmove+0x2b>
    *dst++ = *src++;
 2cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2ce:	8d 50 01             	lea    0x1(%eax),%edx
 2d1:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2d4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2d7:	8d 4a 01             	lea    0x1(%edx),%ecx
 2da:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2dd:	0f b6 12             	movzbl (%edx),%edx
 2e0:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2e2:	8b 45 10             	mov    0x10(%ebp),%eax
 2e5:	8d 50 ff             	lea    -0x1(%eax),%edx
 2e8:	89 55 10             	mov    %edx,0x10(%ebp)
 2eb:	85 c0                	test   %eax,%eax
 2ed:	7f dc                	jg     2cb <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2f2:	c9                   	leave  
 2f3:	c3                   	ret    

000002f4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2f4:	b8 01 00 00 00       	mov    $0x1,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <exit>:
SYSCALL(exit)
 2fc:	b8 02 00 00 00       	mov    $0x2,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <wait>:
SYSCALL(wait)
 304:	b8 03 00 00 00       	mov    $0x3,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <pipe>:
SYSCALL(pipe)
 30c:	b8 04 00 00 00       	mov    $0x4,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <read>:
SYSCALL(read)
 314:	b8 05 00 00 00       	mov    $0x5,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <write>:
SYSCALL(write)
 31c:	b8 10 00 00 00       	mov    $0x10,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <close>:
SYSCALL(close)
 324:	b8 15 00 00 00       	mov    $0x15,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <kill>:
SYSCALL(kill)
 32c:	b8 06 00 00 00       	mov    $0x6,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <exec>:
SYSCALL(exec)
 334:	b8 07 00 00 00       	mov    $0x7,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <open>:
SYSCALL(open)
 33c:	b8 0f 00 00 00       	mov    $0xf,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <mknod>:
SYSCALL(mknod)
 344:	b8 11 00 00 00       	mov    $0x11,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <unlink>:
SYSCALL(unlink)
 34c:	b8 12 00 00 00       	mov    $0x12,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <fstat>:
SYSCALL(fstat)
 354:	b8 08 00 00 00       	mov    $0x8,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <link>:
SYSCALL(link)
 35c:	b8 13 00 00 00       	mov    $0x13,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <mkdir>:
SYSCALL(mkdir)
 364:	b8 14 00 00 00       	mov    $0x14,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <chdir>:
SYSCALL(chdir)
 36c:	b8 09 00 00 00       	mov    $0x9,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <dup>:
SYSCALL(dup)
 374:	b8 0a 00 00 00       	mov    $0xa,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <getpid>:
SYSCALL(getpid)
 37c:	b8 0b 00 00 00       	mov    $0xb,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <sbrk>:
SYSCALL(sbrk)
 384:	b8 0c 00 00 00       	mov    $0xc,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <sleep>:
SYSCALL(sleep)
 38c:	b8 0d 00 00 00       	mov    $0xd,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <uptime>:
SYSCALL(uptime)
 394:	b8 0e 00 00 00       	mov    $0xe,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <halt>:
SYSCALL(halt)
 39c:	b8 16 00 00 00       	mov    $0x16,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3a4:	55                   	push   %ebp
 3a5:	89 e5                	mov    %esp,%ebp
 3a7:	83 ec 18             	sub    $0x18,%esp
 3aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ad:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3b0:	83 ec 04             	sub    $0x4,%esp
 3b3:	6a 01                	push   $0x1
 3b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3b8:	50                   	push   %eax
 3b9:	ff 75 08             	pushl  0x8(%ebp)
 3bc:	e8 5b ff ff ff       	call   31c <write>
 3c1:	83 c4 10             	add    $0x10,%esp
}
 3c4:	90                   	nop
 3c5:	c9                   	leave  
 3c6:	c3                   	ret    

000003c7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c7:	55                   	push   %ebp
 3c8:	89 e5                	mov    %esp,%ebp
 3ca:	53                   	push   %ebx
 3cb:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3d5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3d9:	74 17                	je     3f2 <printint+0x2b>
 3db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3df:	79 11                	jns    3f2 <printint+0x2b>
    neg = 1;
 3e1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3e8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3eb:	f7 d8                	neg    %eax
 3ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f0:	eb 06                	jmp    3f8 <printint+0x31>
  } else {
    x = xx;
 3f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3ff:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 402:	8d 41 01             	lea    0x1(%ecx),%eax
 405:	89 45 f4             	mov    %eax,-0xc(%ebp)
 408:	8b 5d 10             	mov    0x10(%ebp),%ebx
 40b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 40e:	ba 00 00 00 00       	mov    $0x0,%edx
 413:	f7 f3                	div    %ebx
 415:	89 d0                	mov    %edx,%eax
 417:	0f b6 80 c8 0a 00 00 	movzbl 0xac8(%eax),%eax
 41e:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 422:	8b 5d 10             	mov    0x10(%ebp),%ebx
 425:	8b 45 ec             	mov    -0x14(%ebp),%eax
 428:	ba 00 00 00 00       	mov    $0x0,%edx
 42d:	f7 f3                	div    %ebx
 42f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 432:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 436:	75 c7                	jne    3ff <printint+0x38>
  if(neg)
 438:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 43c:	74 2d                	je     46b <printint+0xa4>
    buf[i++] = '-';
 43e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 441:	8d 50 01             	lea    0x1(%eax),%edx
 444:	89 55 f4             	mov    %edx,-0xc(%ebp)
 447:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 44c:	eb 1d                	jmp    46b <printint+0xa4>
    putc(fd, buf[i]);
 44e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 451:	8b 45 f4             	mov    -0xc(%ebp),%eax
 454:	01 d0                	add    %edx,%eax
 456:	0f b6 00             	movzbl (%eax),%eax
 459:	0f be c0             	movsbl %al,%eax
 45c:	83 ec 08             	sub    $0x8,%esp
 45f:	50                   	push   %eax
 460:	ff 75 08             	pushl  0x8(%ebp)
 463:	e8 3c ff ff ff       	call   3a4 <putc>
 468:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 46b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 46f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 473:	79 d9                	jns    44e <printint+0x87>
    putc(fd, buf[i]);
}
 475:	90                   	nop
 476:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 479:	c9                   	leave  
 47a:	c3                   	ret    

0000047b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 47b:	55                   	push   %ebp
 47c:	89 e5                	mov    %esp,%ebp
 47e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 481:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 488:	8d 45 0c             	lea    0xc(%ebp),%eax
 48b:	83 c0 04             	add    $0x4,%eax
 48e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 491:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 498:	e9 59 01 00 00       	jmp    5f6 <printf+0x17b>
    c = fmt[i] & 0xff;
 49d:	8b 55 0c             	mov    0xc(%ebp),%edx
 4a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4a3:	01 d0                	add    %edx,%eax
 4a5:	0f b6 00             	movzbl (%eax),%eax
 4a8:	0f be c0             	movsbl %al,%eax
 4ab:	25 ff 00 00 00       	and    $0xff,%eax
 4b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b7:	75 2c                	jne    4e5 <printf+0x6a>
      if(c == '%'){
 4b9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4bd:	75 0c                	jne    4cb <printf+0x50>
        state = '%';
 4bf:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4c6:	e9 27 01 00 00       	jmp    5f2 <printf+0x177>
      } else {
        putc(fd, c);
 4cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4ce:	0f be c0             	movsbl %al,%eax
 4d1:	83 ec 08             	sub    $0x8,%esp
 4d4:	50                   	push   %eax
 4d5:	ff 75 08             	pushl  0x8(%ebp)
 4d8:	e8 c7 fe ff ff       	call   3a4 <putc>
 4dd:	83 c4 10             	add    $0x10,%esp
 4e0:	e9 0d 01 00 00       	jmp    5f2 <printf+0x177>
      }
    } else if(state == '%'){
 4e5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4e9:	0f 85 03 01 00 00    	jne    5f2 <printf+0x177>
      if(c == 'd'){
 4ef:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4f3:	75 1e                	jne    513 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f8:	8b 00                	mov    (%eax),%eax
 4fa:	6a 01                	push   $0x1
 4fc:	6a 0a                	push   $0xa
 4fe:	50                   	push   %eax
 4ff:	ff 75 08             	pushl  0x8(%ebp)
 502:	e8 c0 fe ff ff       	call   3c7 <printint>
 507:	83 c4 10             	add    $0x10,%esp
        ap++;
 50a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 50e:	e9 d8 00 00 00       	jmp    5eb <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 513:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 517:	74 06                	je     51f <printf+0xa4>
 519:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 51d:	75 1e                	jne    53d <printf+0xc2>
        printint(fd, *ap, 16, 0);
 51f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 522:	8b 00                	mov    (%eax),%eax
 524:	6a 00                	push   $0x0
 526:	6a 10                	push   $0x10
 528:	50                   	push   %eax
 529:	ff 75 08             	pushl  0x8(%ebp)
 52c:	e8 96 fe ff ff       	call   3c7 <printint>
 531:	83 c4 10             	add    $0x10,%esp
        ap++;
 534:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 538:	e9 ae 00 00 00       	jmp    5eb <printf+0x170>
      } else if(c == 's'){
 53d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 541:	75 43                	jne    586 <printf+0x10b>
        s = (char*)*ap;
 543:	8b 45 e8             	mov    -0x18(%ebp),%eax
 546:	8b 00                	mov    (%eax),%eax
 548:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 54b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 54f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 553:	75 25                	jne    57a <printf+0xff>
          s = "(null)";
 555:	c7 45 f4 57 08 00 00 	movl   $0x857,-0xc(%ebp)
        while(*s != 0){
 55c:	eb 1c                	jmp    57a <printf+0xff>
          putc(fd, *s);
 55e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 561:	0f b6 00             	movzbl (%eax),%eax
 564:	0f be c0             	movsbl %al,%eax
 567:	83 ec 08             	sub    $0x8,%esp
 56a:	50                   	push   %eax
 56b:	ff 75 08             	pushl  0x8(%ebp)
 56e:	e8 31 fe ff ff       	call   3a4 <putc>
 573:	83 c4 10             	add    $0x10,%esp
          s++;
 576:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 57a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57d:	0f b6 00             	movzbl (%eax),%eax
 580:	84 c0                	test   %al,%al
 582:	75 da                	jne    55e <printf+0xe3>
 584:	eb 65                	jmp    5eb <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 586:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 58a:	75 1d                	jne    5a9 <printf+0x12e>
        putc(fd, *ap);
 58c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58f:	8b 00                	mov    (%eax),%eax
 591:	0f be c0             	movsbl %al,%eax
 594:	83 ec 08             	sub    $0x8,%esp
 597:	50                   	push   %eax
 598:	ff 75 08             	pushl  0x8(%ebp)
 59b:	e8 04 fe ff ff       	call   3a4 <putc>
 5a0:	83 c4 10             	add    $0x10,%esp
        ap++;
 5a3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a7:	eb 42                	jmp    5eb <printf+0x170>
      } else if(c == '%'){
 5a9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ad:	75 17                	jne    5c6 <printf+0x14b>
        putc(fd, c);
 5af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b2:	0f be c0             	movsbl %al,%eax
 5b5:	83 ec 08             	sub    $0x8,%esp
 5b8:	50                   	push   %eax
 5b9:	ff 75 08             	pushl  0x8(%ebp)
 5bc:	e8 e3 fd ff ff       	call   3a4 <putc>
 5c1:	83 c4 10             	add    $0x10,%esp
 5c4:	eb 25                	jmp    5eb <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5c6:	83 ec 08             	sub    $0x8,%esp
 5c9:	6a 25                	push   $0x25
 5cb:	ff 75 08             	pushl  0x8(%ebp)
 5ce:	e8 d1 fd ff ff       	call   3a4 <putc>
 5d3:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d9:	0f be c0             	movsbl %al,%eax
 5dc:	83 ec 08             	sub    $0x8,%esp
 5df:	50                   	push   %eax
 5e0:	ff 75 08             	pushl  0x8(%ebp)
 5e3:	e8 bc fd ff ff       	call   3a4 <putc>
 5e8:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5eb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5f2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5f6:	8b 55 0c             	mov    0xc(%ebp),%edx
 5f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5fc:	01 d0                	add    %edx,%eax
 5fe:	0f b6 00             	movzbl (%eax),%eax
 601:	84 c0                	test   %al,%al
 603:	0f 85 94 fe ff ff    	jne    49d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 609:	90                   	nop
 60a:	c9                   	leave  
 60b:	c3                   	ret    

0000060c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 60c:	55                   	push   %ebp
 60d:	89 e5                	mov    %esp,%ebp
 60f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 612:	8b 45 08             	mov    0x8(%ebp),%eax
 615:	83 e8 08             	sub    $0x8,%eax
 618:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61b:	a1 e4 0a 00 00       	mov    0xae4,%eax
 620:	89 45 fc             	mov    %eax,-0x4(%ebp)
 623:	eb 24                	jmp    649 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 625:	8b 45 fc             	mov    -0x4(%ebp),%eax
 628:	8b 00                	mov    (%eax),%eax
 62a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62d:	77 12                	ja     641 <free+0x35>
 62f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 632:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 635:	77 24                	ja     65b <free+0x4f>
 637:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63a:	8b 00                	mov    (%eax),%eax
 63c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 63f:	77 1a                	ja     65b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 641:	8b 45 fc             	mov    -0x4(%ebp),%eax
 644:	8b 00                	mov    (%eax),%eax
 646:	89 45 fc             	mov    %eax,-0x4(%ebp)
 649:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64f:	76 d4                	jbe    625 <free+0x19>
 651:	8b 45 fc             	mov    -0x4(%ebp),%eax
 654:	8b 00                	mov    (%eax),%eax
 656:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 659:	76 ca                	jbe    625 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 65b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65e:	8b 40 04             	mov    0x4(%eax),%eax
 661:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 668:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66b:	01 c2                	add    %eax,%edx
 66d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 670:	8b 00                	mov    (%eax),%eax
 672:	39 c2                	cmp    %eax,%edx
 674:	75 24                	jne    69a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 676:	8b 45 f8             	mov    -0x8(%ebp),%eax
 679:	8b 50 04             	mov    0x4(%eax),%edx
 67c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67f:	8b 00                	mov    (%eax),%eax
 681:	8b 40 04             	mov    0x4(%eax),%eax
 684:	01 c2                	add    %eax,%edx
 686:	8b 45 f8             	mov    -0x8(%ebp),%eax
 689:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 68c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68f:	8b 00                	mov    (%eax),%eax
 691:	8b 10                	mov    (%eax),%edx
 693:	8b 45 f8             	mov    -0x8(%ebp),%eax
 696:	89 10                	mov    %edx,(%eax)
 698:	eb 0a                	jmp    6a4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69d:	8b 10                	mov    (%eax),%edx
 69f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a7:	8b 40 04             	mov    0x4(%eax),%eax
 6aa:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b4:	01 d0                	add    %edx,%eax
 6b6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b9:	75 20                	jne    6db <free+0xcf>
    p->s.size += bp->s.size;
 6bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6be:	8b 50 04             	mov    0x4(%eax),%edx
 6c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c4:	8b 40 04             	mov    0x4(%eax),%eax
 6c7:	01 c2                	add    %eax,%edx
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d2:	8b 10                	mov    (%eax),%edx
 6d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d7:	89 10                	mov    %edx,(%eax)
 6d9:	eb 08                	jmp    6e3 <free+0xd7>
  } else
    p->s.ptr = bp;
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6e1:	89 10                	mov    %edx,(%eax)
  freep = p;
 6e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e6:	a3 e4 0a 00 00       	mov    %eax,0xae4
}
 6eb:	90                   	nop
 6ec:	c9                   	leave  
 6ed:	c3                   	ret    

000006ee <morecore>:

static Header*
morecore(uint nu)
{
 6ee:	55                   	push   %ebp
 6ef:	89 e5                	mov    %esp,%ebp
 6f1:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6f4:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6fb:	77 07                	ja     704 <morecore+0x16>
    nu = 4096;
 6fd:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 704:	8b 45 08             	mov    0x8(%ebp),%eax
 707:	c1 e0 03             	shl    $0x3,%eax
 70a:	83 ec 0c             	sub    $0xc,%esp
 70d:	50                   	push   %eax
 70e:	e8 71 fc ff ff       	call   384 <sbrk>
 713:	83 c4 10             	add    $0x10,%esp
 716:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 719:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 71d:	75 07                	jne    726 <morecore+0x38>
    return 0;
 71f:	b8 00 00 00 00       	mov    $0x0,%eax
 724:	eb 26                	jmp    74c <morecore+0x5e>
  hp = (Header*)p;
 726:	8b 45 f4             	mov    -0xc(%ebp),%eax
 729:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 72c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72f:	8b 55 08             	mov    0x8(%ebp),%edx
 732:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 735:	8b 45 f0             	mov    -0x10(%ebp),%eax
 738:	83 c0 08             	add    $0x8,%eax
 73b:	83 ec 0c             	sub    $0xc,%esp
 73e:	50                   	push   %eax
 73f:	e8 c8 fe ff ff       	call   60c <free>
 744:	83 c4 10             	add    $0x10,%esp
  return freep;
 747:	a1 e4 0a 00 00       	mov    0xae4,%eax
}
 74c:	c9                   	leave  
 74d:	c3                   	ret    

0000074e <malloc>:

void*
malloc(uint nbytes)
{
 74e:	55                   	push   %ebp
 74f:	89 e5                	mov    %esp,%ebp
 751:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 754:	8b 45 08             	mov    0x8(%ebp),%eax
 757:	83 c0 07             	add    $0x7,%eax
 75a:	c1 e8 03             	shr    $0x3,%eax
 75d:	83 c0 01             	add    $0x1,%eax
 760:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 763:	a1 e4 0a 00 00       	mov    0xae4,%eax
 768:	89 45 f0             	mov    %eax,-0x10(%ebp)
 76b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 76f:	75 23                	jne    794 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 771:	c7 45 f0 dc 0a 00 00 	movl   $0xadc,-0x10(%ebp)
 778:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77b:	a3 e4 0a 00 00       	mov    %eax,0xae4
 780:	a1 e4 0a 00 00       	mov    0xae4,%eax
 785:	a3 dc 0a 00 00       	mov    %eax,0xadc
    base.s.size = 0;
 78a:	c7 05 e0 0a 00 00 00 	movl   $0x0,0xae0
 791:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 794:	8b 45 f0             	mov    -0x10(%ebp),%eax
 797:	8b 00                	mov    (%eax),%eax
 799:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 79c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79f:	8b 40 04             	mov    0x4(%eax),%eax
 7a2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7a5:	72 4d                	jb     7f4 <malloc+0xa6>
      if(p->s.size == nunits)
 7a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7aa:	8b 40 04             	mov    0x4(%eax),%eax
 7ad:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b0:	75 0c                	jne    7be <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b5:	8b 10                	mov    (%eax),%edx
 7b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ba:	89 10                	mov    %edx,(%eax)
 7bc:	eb 26                	jmp    7e4 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c1:	8b 40 04             	mov    0x4(%eax),%eax
 7c4:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7c7:	89 c2                	mov    %eax,%edx
 7c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cc:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d2:	8b 40 04             	mov    0x4(%eax),%eax
 7d5:	c1 e0 03             	shl    $0x3,%eax
 7d8:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7de:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7e1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e7:	a3 e4 0a 00 00       	mov    %eax,0xae4
      return (void*)(p + 1);
 7ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ef:	83 c0 08             	add    $0x8,%eax
 7f2:	eb 3b                	jmp    82f <malloc+0xe1>
    }
    if(p == freep)
 7f4:	a1 e4 0a 00 00       	mov    0xae4,%eax
 7f9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7fc:	75 1e                	jne    81c <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7fe:	83 ec 0c             	sub    $0xc,%esp
 801:	ff 75 ec             	pushl  -0x14(%ebp)
 804:	e8 e5 fe ff ff       	call   6ee <morecore>
 809:	83 c4 10             	add    $0x10,%esp
 80c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 80f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 813:	75 07                	jne    81c <malloc+0xce>
        return 0;
 815:	b8 00 00 00 00       	mov    $0x0,%eax
 81a:	eb 13                	jmp    82f <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 822:	8b 45 f4             	mov    -0xc(%ebp),%eax
 825:	8b 00                	mov    (%eax),%eax
 827:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 82a:	e9 6d ff ff ff       	jmp    79c <malloc+0x4e>
}
 82f:	c9                   	leave  
 830:	c3                   	ret    
