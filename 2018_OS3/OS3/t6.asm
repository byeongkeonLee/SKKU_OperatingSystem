
_t6:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "memlayout.h"

	int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
	char *a;
	int ppid, pid;

	// invalid access over kernel space
	printf(1, "TEST6: ");
  11:	83 ec 08             	sub    $0x8,%esp
  14:	68 29 08 00 00       	push   $0x829
  19:	6a 01                	push   $0x1
  1b:	e8 53 04 00 00       	call   473 <printf>
  20:	83 c4 10             	add    $0x10,%esp

	for(a = (char *)(KERNBASE); a < (char *)(KERNBASE+2000000); a += 50000){
  23:	c7 45 f4 00 00 00 80 	movl   $0x80000000,-0xc(%ebp)
  2a:	eb 51                	jmp    7d <main+0x7d>
		ppid = getpid();
  2c:	e8 43 03 00 00       	call   374 <getpid>
  31:	89 45 f0             	mov    %eax,-0x10(%ebp)
		pid = fork();
  34:	e8 b3 02 00 00       	call   2ec <fork>
  39:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(pid == 0){
  3c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  40:	75 2f                	jne    71 <main+0x71>
			printf(1, "invalid access %x = %x\n", a, *a);
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	0f b6 00             	movzbl (%eax),%eax
  48:	0f be c0             	movsbl %al,%eax
  4b:	50                   	push   %eax
  4c:	ff 75 f4             	pushl  -0xc(%ebp)
  4f:	68 31 08 00 00       	push   $0x831
  54:	6a 01                	push   $0x1
  56:	e8 18 04 00 00       	call   473 <printf>
  5b:	83 c4 10             	add    $0x10,%esp
			kill(ppid);
  5e:	83 ec 0c             	sub    $0xc,%esp
  61:	ff 75 f0             	pushl  -0x10(%ebp)
  64:	e8 bb 02 00 00       	call   324 <kill>
  69:	83 c4 10             	add    $0x10,%esp
			exit();
  6c:	e8 83 02 00 00       	call   2f4 <exit>
		}
		wait();
  71:	e8 86 02 00 00       	call   2fc <wait>
	int ppid, pid;

	// invalid access over kernel space
	printf(1, "TEST6: ");

	for(a = (char *)(KERNBASE); a < (char *)(KERNBASE+2000000); a += 50000){
  76:	81 45 f4 50 c3 00 00 	addl   $0xc350,-0xc(%ebp)
  7d:	81 7d f4 7f 84 1e 80 	cmpl   $0x801e847f,-0xc(%ebp)
  84:	76 a6                	jbe    2c <main+0x2c>
			exit();
		}
		wait();
	}

	printf(1, "OK\n");
  86:	83 ec 08             	sub    $0x8,%esp
  89:	68 49 08 00 00       	push   $0x849
  8e:	6a 01                	push   $0x1
  90:	e8 de 03 00 00       	call   473 <printf>
  95:	83 c4 10             	add    $0x10,%esp
	exit();
  98:	e8 57 02 00 00       	call   2f4 <exit>

0000009d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  9d:	55                   	push   %ebp
  9e:	89 e5                	mov    %esp,%ebp
  a0:	57                   	push   %edi
  a1:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  a5:	8b 55 10             	mov    0x10(%ebp),%edx
  a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  ab:	89 cb                	mov    %ecx,%ebx
  ad:	89 df                	mov    %ebx,%edi
  af:	89 d1                	mov    %edx,%ecx
  b1:	fc                   	cld    
  b2:	f3 aa                	rep stos %al,%es:(%edi)
  b4:	89 ca                	mov    %ecx,%edx
  b6:	89 fb                	mov    %edi,%ebx
  b8:	89 5d 08             	mov    %ebx,0x8(%ebp)
  bb:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  be:	90                   	nop
  bf:	5b                   	pop    %ebx
  c0:	5f                   	pop    %edi
  c1:	5d                   	pop    %ebp
  c2:	c3                   	ret    

000000c3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  c3:	55                   	push   %ebp
  c4:	89 e5                	mov    %esp,%ebp
  c6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  c9:	8b 45 08             	mov    0x8(%ebp),%eax
  cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  cf:	90                   	nop
  d0:	8b 45 08             	mov    0x8(%ebp),%eax
  d3:	8d 50 01             	lea    0x1(%eax),%edx
  d6:	89 55 08             	mov    %edx,0x8(%ebp)
  d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  dc:	8d 4a 01             	lea    0x1(%edx),%ecx
  df:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  e2:	0f b6 12             	movzbl (%edx),%edx
  e5:	88 10                	mov    %dl,(%eax)
  e7:	0f b6 00             	movzbl (%eax),%eax
  ea:	84 c0                	test   %al,%al
  ec:	75 e2                	jne    d0 <strcpy+0xd>
    ;
  return os;
  ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  f1:	c9                   	leave  
  f2:	c3                   	ret    

000000f3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f3:	55                   	push   %ebp
  f4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  f6:	eb 08                	jmp    100 <strcmp+0xd>
    p++, q++;
  f8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  fc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 100:	8b 45 08             	mov    0x8(%ebp),%eax
 103:	0f b6 00             	movzbl (%eax),%eax
 106:	84 c0                	test   %al,%al
 108:	74 10                	je     11a <strcmp+0x27>
 10a:	8b 45 08             	mov    0x8(%ebp),%eax
 10d:	0f b6 10             	movzbl (%eax),%edx
 110:	8b 45 0c             	mov    0xc(%ebp),%eax
 113:	0f b6 00             	movzbl (%eax),%eax
 116:	38 c2                	cmp    %al,%dl
 118:	74 de                	je     f8 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 11a:	8b 45 08             	mov    0x8(%ebp),%eax
 11d:	0f b6 00             	movzbl (%eax),%eax
 120:	0f b6 d0             	movzbl %al,%edx
 123:	8b 45 0c             	mov    0xc(%ebp),%eax
 126:	0f b6 00             	movzbl (%eax),%eax
 129:	0f b6 c0             	movzbl %al,%eax
 12c:	29 c2                	sub    %eax,%edx
 12e:	89 d0                	mov    %edx,%eax
}
 130:	5d                   	pop    %ebp
 131:	c3                   	ret    

00000132 <strlen>:

uint
strlen(char *s)
{
 132:	55                   	push   %ebp
 133:	89 e5                	mov    %esp,%ebp
 135:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 138:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 13f:	eb 04                	jmp    145 <strlen+0x13>
 141:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 145:	8b 55 fc             	mov    -0x4(%ebp),%edx
 148:	8b 45 08             	mov    0x8(%ebp),%eax
 14b:	01 d0                	add    %edx,%eax
 14d:	0f b6 00             	movzbl (%eax),%eax
 150:	84 c0                	test   %al,%al
 152:	75 ed                	jne    141 <strlen+0xf>
    ;
  return n;
 154:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 157:	c9                   	leave  
 158:	c3                   	ret    

00000159 <memset>:

void*
memset(void *dst, int c, uint n)
{
 159:	55                   	push   %ebp
 15a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 15c:	8b 45 10             	mov    0x10(%ebp),%eax
 15f:	50                   	push   %eax
 160:	ff 75 0c             	pushl  0xc(%ebp)
 163:	ff 75 08             	pushl  0x8(%ebp)
 166:	e8 32 ff ff ff       	call   9d <stosb>
 16b:	83 c4 0c             	add    $0xc,%esp
  return dst;
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 171:	c9                   	leave  
 172:	c3                   	ret    

00000173 <strchr>:

char*
strchr(const char *s, char c)
{
 173:	55                   	push   %ebp
 174:	89 e5                	mov    %esp,%ebp
 176:	83 ec 04             	sub    $0x4,%esp
 179:	8b 45 0c             	mov    0xc(%ebp),%eax
 17c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 17f:	eb 14                	jmp    195 <strchr+0x22>
    if(*s == c)
 181:	8b 45 08             	mov    0x8(%ebp),%eax
 184:	0f b6 00             	movzbl (%eax),%eax
 187:	3a 45 fc             	cmp    -0x4(%ebp),%al
 18a:	75 05                	jne    191 <strchr+0x1e>
      return (char*)s;
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	eb 13                	jmp    1a4 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 191:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 195:	8b 45 08             	mov    0x8(%ebp),%eax
 198:	0f b6 00             	movzbl (%eax),%eax
 19b:	84 c0                	test   %al,%al
 19d:	75 e2                	jne    181 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 19f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1a4:	c9                   	leave  
 1a5:	c3                   	ret    

000001a6 <gets>:

char*
gets(char *buf, int max)
{
 1a6:	55                   	push   %ebp
 1a7:	89 e5                	mov    %esp,%ebp
 1a9:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1b3:	eb 42                	jmp    1f7 <gets+0x51>
    cc = read(0, &c, 1);
 1b5:	83 ec 04             	sub    $0x4,%esp
 1b8:	6a 01                	push   $0x1
 1ba:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1bd:	50                   	push   %eax
 1be:	6a 00                	push   $0x0
 1c0:	e8 47 01 00 00       	call   30c <read>
 1c5:	83 c4 10             	add    $0x10,%esp
 1c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1cf:	7e 33                	jle    204 <gets+0x5e>
      break;
    buf[i++] = c;
 1d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d4:	8d 50 01             	lea    0x1(%eax),%edx
 1d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1da:	89 c2                	mov    %eax,%edx
 1dc:	8b 45 08             	mov    0x8(%ebp),%eax
 1df:	01 c2                	add    %eax,%edx
 1e1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e5:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1e7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1eb:	3c 0a                	cmp    $0xa,%al
 1ed:	74 16                	je     205 <gets+0x5f>
 1ef:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f3:	3c 0d                	cmp    $0xd,%al
 1f5:	74 0e                	je     205 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1fa:	83 c0 01             	add    $0x1,%eax
 1fd:	3b 45 0c             	cmp    0xc(%ebp),%eax
 200:	7c b3                	jl     1b5 <gets+0xf>
 202:	eb 01                	jmp    205 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 204:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 205:	8b 55 f4             	mov    -0xc(%ebp),%edx
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	01 d0                	add    %edx,%eax
 20d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 210:	8b 45 08             	mov    0x8(%ebp),%eax
}
 213:	c9                   	leave  
 214:	c3                   	ret    

00000215 <stat>:

int
stat(char *n, struct stat *st)
{
 215:	55                   	push   %ebp
 216:	89 e5                	mov    %esp,%ebp
 218:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 21b:	83 ec 08             	sub    $0x8,%esp
 21e:	6a 00                	push   $0x0
 220:	ff 75 08             	pushl  0x8(%ebp)
 223:	e8 0c 01 00 00       	call   334 <open>
 228:	83 c4 10             	add    $0x10,%esp
 22b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 22e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 232:	79 07                	jns    23b <stat+0x26>
    return -1;
 234:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 239:	eb 25                	jmp    260 <stat+0x4b>
  r = fstat(fd, st);
 23b:	83 ec 08             	sub    $0x8,%esp
 23e:	ff 75 0c             	pushl  0xc(%ebp)
 241:	ff 75 f4             	pushl  -0xc(%ebp)
 244:	e8 03 01 00 00       	call   34c <fstat>
 249:	83 c4 10             	add    $0x10,%esp
 24c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 24f:	83 ec 0c             	sub    $0xc,%esp
 252:	ff 75 f4             	pushl  -0xc(%ebp)
 255:	e8 c2 00 00 00       	call   31c <close>
 25a:	83 c4 10             	add    $0x10,%esp
  return r;
 25d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 260:	c9                   	leave  
 261:	c3                   	ret    

00000262 <atoi>:

int
atoi(const char *s)
{
 262:	55                   	push   %ebp
 263:	89 e5                	mov    %esp,%ebp
 265:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 268:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 26f:	eb 25                	jmp    296 <atoi+0x34>
    n = n*10 + *s++ - '0';
 271:	8b 55 fc             	mov    -0x4(%ebp),%edx
 274:	89 d0                	mov    %edx,%eax
 276:	c1 e0 02             	shl    $0x2,%eax
 279:	01 d0                	add    %edx,%eax
 27b:	01 c0                	add    %eax,%eax
 27d:	89 c1                	mov    %eax,%ecx
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
 282:	8d 50 01             	lea    0x1(%eax),%edx
 285:	89 55 08             	mov    %edx,0x8(%ebp)
 288:	0f b6 00             	movzbl (%eax),%eax
 28b:	0f be c0             	movsbl %al,%eax
 28e:	01 c8                	add    %ecx,%eax
 290:	83 e8 30             	sub    $0x30,%eax
 293:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 296:	8b 45 08             	mov    0x8(%ebp),%eax
 299:	0f b6 00             	movzbl (%eax),%eax
 29c:	3c 2f                	cmp    $0x2f,%al
 29e:	7e 0a                	jle    2aa <atoi+0x48>
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
 2a3:	0f b6 00             	movzbl (%eax),%eax
 2a6:	3c 39                	cmp    $0x39,%al
 2a8:	7e c7                	jle    271 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2ad:	c9                   	leave  
 2ae:	c3                   	ret    

000002af <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2af:	55                   	push   %ebp
 2b0:	89 e5                	mov    %esp,%ebp
 2b2:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 2be:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2c1:	eb 17                	jmp    2da <memmove+0x2b>
    *dst++ = *src++;
 2c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2c6:	8d 50 01             	lea    0x1(%eax),%edx
 2c9:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2cc:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2cf:	8d 4a 01             	lea    0x1(%edx),%ecx
 2d2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2d5:	0f b6 12             	movzbl (%edx),%edx
 2d8:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2da:	8b 45 10             	mov    0x10(%ebp),%eax
 2dd:	8d 50 ff             	lea    -0x1(%eax),%edx
 2e0:	89 55 10             	mov    %edx,0x10(%ebp)
 2e3:	85 c0                	test   %eax,%eax
 2e5:	7f dc                	jg     2c3 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ea:	c9                   	leave  
 2eb:	c3                   	ret    

000002ec <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ec:	b8 01 00 00 00       	mov    $0x1,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <exit>:
SYSCALL(exit)
 2f4:	b8 02 00 00 00       	mov    $0x2,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <wait>:
SYSCALL(wait)
 2fc:	b8 03 00 00 00       	mov    $0x3,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <pipe>:
SYSCALL(pipe)
 304:	b8 04 00 00 00       	mov    $0x4,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <read>:
SYSCALL(read)
 30c:	b8 05 00 00 00       	mov    $0x5,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <write>:
SYSCALL(write)
 314:	b8 10 00 00 00       	mov    $0x10,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <close>:
SYSCALL(close)
 31c:	b8 15 00 00 00       	mov    $0x15,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <kill>:
SYSCALL(kill)
 324:	b8 06 00 00 00       	mov    $0x6,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <exec>:
SYSCALL(exec)
 32c:	b8 07 00 00 00       	mov    $0x7,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <open>:
SYSCALL(open)
 334:	b8 0f 00 00 00       	mov    $0xf,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <mknod>:
SYSCALL(mknod)
 33c:	b8 11 00 00 00       	mov    $0x11,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <unlink>:
SYSCALL(unlink)
 344:	b8 12 00 00 00       	mov    $0x12,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <fstat>:
SYSCALL(fstat)
 34c:	b8 08 00 00 00       	mov    $0x8,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <link>:
SYSCALL(link)
 354:	b8 13 00 00 00       	mov    $0x13,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <mkdir>:
SYSCALL(mkdir)
 35c:	b8 14 00 00 00       	mov    $0x14,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <chdir>:
SYSCALL(chdir)
 364:	b8 09 00 00 00       	mov    $0x9,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <dup>:
SYSCALL(dup)
 36c:	b8 0a 00 00 00       	mov    $0xa,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <getpid>:
SYSCALL(getpid)
 374:	b8 0b 00 00 00       	mov    $0xb,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <sbrk>:
SYSCALL(sbrk)
 37c:	b8 0c 00 00 00       	mov    $0xc,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <sleep>:
SYSCALL(sleep)
 384:	b8 0d 00 00 00       	mov    $0xd,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <uptime>:
SYSCALL(uptime)
 38c:	b8 0e 00 00 00       	mov    $0xe,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <halt>:
SYSCALL(halt)
 394:	b8 16 00 00 00       	mov    $0x16,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 39c:	55                   	push   %ebp
 39d:	89 e5                	mov    %esp,%ebp
 39f:	83 ec 18             	sub    $0x18,%esp
 3a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3a8:	83 ec 04             	sub    $0x4,%esp
 3ab:	6a 01                	push   $0x1
 3ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3b0:	50                   	push   %eax
 3b1:	ff 75 08             	pushl  0x8(%ebp)
 3b4:	e8 5b ff ff ff       	call   314 <write>
 3b9:	83 c4 10             	add    $0x10,%esp
}
 3bc:	90                   	nop
 3bd:	c9                   	leave  
 3be:	c3                   	ret    

000003bf <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3bf:	55                   	push   %ebp
 3c0:	89 e5                	mov    %esp,%ebp
 3c2:	53                   	push   %ebx
 3c3:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3c6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3cd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3d1:	74 17                	je     3ea <printint+0x2b>
 3d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3d7:	79 11                	jns    3ea <printint+0x2b>
    neg = 1;
 3d9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3e0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e3:	f7 d8                	neg    %eax
 3e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e8:	eb 06                	jmp    3f0 <printint+0x31>
  } else {
    x = xx;
 3ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3f7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3fa:	8d 41 01             	lea    0x1(%ecx),%eax
 3fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 400:	8b 5d 10             	mov    0x10(%ebp),%ebx
 403:	8b 45 ec             	mov    -0x14(%ebp),%eax
 406:	ba 00 00 00 00       	mov    $0x0,%edx
 40b:	f7 f3                	div    %ebx
 40d:	89 d0                	mov    %edx,%eax
 40f:	0f b6 80 9c 0a 00 00 	movzbl 0xa9c(%eax),%eax
 416:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 41a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 41d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 420:	ba 00 00 00 00       	mov    $0x0,%edx
 425:	f7 f3                	div    %ebx
 427:	89 45 ec             	mov    %eax,-0x14(%ebp)
 42a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 42e:	75 c7                	jne    3f7 <printint+0x38>
  if(neg)
 430:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 434:	74 2d                	je     463 <printint+0xa4>
    buf[i++] = '-';
 436:	8b 45 f4             	mov    -0xc(%ebp),%eax
 439:	8d 50 01             	lea    0x1(%eax),%edx
 43c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 43f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 444:	eb 1d                	jmp    463 <printint+0xa4>
    putc(fd, buf[i]);
 446:	8d 55 dc             	lea    -0x24(%ebp),%edx
 449:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44c:	01 d0                	add    %edx,%eax
 44e:	0f b6 00             	movzbl (%eax),%eax
 451:	0f be c0             	movsbl %al,%eax
 454:	83 ec 08             	sub    $0x8,%esp
 457:	50                   	push   %eax
 458:	ff 75 08             	pushl  0x8(%ebp)
 45b:	e8 3c ff ff ff       	call   39c <putc>
 460:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 463:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 467:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 46b:	79 d9                	jns    446 <printint+0x87>
    putc(fd, buf[i]);
}
 46d:	90                   	nop
 46e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 471:	c9                   	leave  
 472:	c3                   	ret    

00000473 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 473:	55                   	push   %ebp
 474:	89 e5                	mov    %esp,%ebp
 476:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 479:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 480:	8d 45 0c             	lea    0xc(%ebp),%eax
 483:	83 c0 04             	add    $0x4,%eax
 486:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 489:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 490:	e9 59 01 00 00       	jmp    5ee <printf+0x17b>
    c = fmt[i] & 0xff;
 495:	8b 55 0c             	mov    0xc(%ebp),%edx
 498:	8b 45 f0             	mov    -0x10(%ebp),%eax
 49b:	01 d0                	add    %edx,%eax
 49d:	0f b6 00             	movzbl (%eax),%eax
 4a0:	0f be c0             	movsbl %al,%eax
 4a3:	25 ff 00 00 00       	and    $0xff,%eax
 4a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4af:	75 2c                	jne    4dd <printf+0x6a>
      if(c == '%'){
 4b1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4b5:	75 0c                	jne    4c3 <printf+0x50>
        state = '%';
 4b7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4be:	e9 27 01 00 00       	jmp    5ea <printf+0x177>
      } else {
        putc(fd, c);
 4c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4c6:	0f be c0             	movsbl %al,%eax
 4c9:	83 ec 08             	sub    $0x8,%esp
 4cc:	50                   	push   %eax
 4cd:	ff 75 08             	pushl  0x8(%ebp)
 4d0:	e8 c7 fe ff ff       	call   39c <putc>
 4d5:	83 c4 10             	add    $0x10,%esp
 4d8:	e9 0d 01 00 00       	jmp    5ea <printf+0x177>
      }
    } else if(state == '%'){
 4dd:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4e1:	0f 85 03 01 00 00    	jne    5ea <printf+0x177>
      if(c == 'd'){
 4e7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4eb:	75 1e                	jne    50b <printf+0x98>
        printint(fd, *ap, 10, 1);
 4ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f0:	8b 00                	mov    (%eax),%eax
 4f2:	6a 01                	push   $0x1
 4f4:	6a 0a                	push   $0xa
 4f6:	50                   	push   %eax
 4f7:	ff 75 08             	pushl  0x8(%ebp)
 4fa:	e8 c0 fe ff ff       	call   3bf <printint>
 4ff:	83 c4 10             	add    $0x10,%esp
        ap++;
 502:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 506:	e9 d8 00 00 00       	jmp    5e3 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 50b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 50f:	74 06                	je     517 <printf+0xa4>
 511:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 515:	75 1e                	jne    535 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 517:	8b 45 e8             	mov    -0x18(%ebp),%eax
 51a:	8b 00                	mov    (%eax),%eax
 51c:	6a 00                	push   $0x0
 51e:	6a 10                	push   $0x10
 520:	50                   	push   %eax
 521:	ff 75 08             	pushl  0x8(%ebp)
 524:	e8 96 fe ff ff       	call   3bf <printint>
 529:	83 c4 10             	add    $0x10,%esp
        ap++;
 52c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 530:	e9 ae 00 00 00       	jmp    5e3 <printf+0x170>
      } else if(c == 's'){
 535:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 539:	75 43                	jne    57e <printf+0x10b>
        s = (char*)*ap;
 53b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53e:	8b 00                	mov    (%eax),%eax
 540:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 543:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 547:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 54b:	75 25                	jne    572 <printf+0xff>
          s = "(null)";
 54d:	c7 45 f4 4d 08 00 00 	movl   $0x84d,-0xc(%ebp)
        while(*s != 0){
 554:	eb 1c                	jmp    572 <printf+0xff>
          putc(fd, *s);
 556:	8b 45 f4             	mov    -0xc(%ebp),%eax
 559:	0f b6 00             	movzbl (%eax),%eax
 55c:	0f be c0             	movsbl %al,%eax
 55f:	83 ec 08             	sub    $0x8,%esp
 562:	50                   	push   %eax
 563:	ff 75 08             	pushl  0x8(%ebp)
 566:	e8 31 fe ff ff       	call   39c <putc>
 56b:	83 c4 10             	add    $0x10,%esp
          s++;
 56e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 572:	8b 45 f4             	mov    -0xc(%ebp),%eax
 575:	0f b6 00             	movzbl (%eax),%eax
 578:	84 c0                	test   %al,%al
 57a:	75 da                	jne    556 <printf+0xe3>
 57c:	eb 65                	jmp    5e3 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 57e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 582:	75 1d                	jne    5a1 <printf+0x12e>
        putc(fd, *ap);
 584:	8b 45 e8             	mov    -0x18(%ebp),%eax
 587:	8b 00                	mov    (%eax),%eax
 589:	0f be c0             	movsbl %al,%eax
 58c:	83 ec 08             	sub    $0x8,%esp
 58f:	50                   	push   %eax
 590:	ff 75 08             	pushl  0x8(%ebp)
 593:	e8 04 fe ff ff       	call   39c <putc>
 598:	83 c4 10             	add    $0x10,%esp
        ap++;
 59b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 59f:	eb 42                	jmp    5e3 <printf+0x170>
      } else if(c == '%'){
 5a1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5a5:	75 17                	jne    5be <printf+0x14b>
        putc(fd, c);
 5a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5aa:	0f be c0             	movsbl %al,%eax
 5ad:	83 ec 08             	sub    $0x8,%esp
 5b0:	50                   	push   %eax
 5b1:	ff 75 08             	pushl  0x8(%ebp)
 5b4:	e8 e3 fd ff ff       	call   39c <putc>
 5b9:	83 c4 10             	add    $0x10,%esp
 5bc:	eb 25                	jmp    5e3 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5be:	83 ec 08             	sub    $0x8,%esp
 5c1:	6a 25                	push   $0x25
 5c3:	ff 75 08             	pushl  0x8(%ebp)
 5c6:	e8 d1 fd ff ff       	call   39c <putc>
 5cb:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d1:	0f be c0             	movsbl %al,%eax
 5d4:	83 ec 08             	sub    $0x8,%esp
 5d7:	50                   	push   %eax
 5d8:	ff 75 08             	pushl  0x8(%ebp)
 5db:	e8 bc fd ff ff       	call   39c <putc>
 5e0:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5e3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5ea:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5ee:	8b 55 0c             	mov    0xc(%ebp),%edx
 5f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5f4:	01 d0                	add    %edx,%eax
 5f6:	0f b6 00             	movzbl (%eax),%eax
 5f9:	84 c0                	test   %al,%al
 5fb:	0f 85 94 fe ff ff    	jne    495 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 601:	90                   	nop
 602:	c9                   	leave  
 603:	c3                   	ret    

00000604 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 604:	55                   	push   %ebp
 605:	89 e5                	mov    %esp,%ebp
 607:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 60a:	8b 45 08             	mov    0x8(%ebp),%eax
 60d:	83 e8 08             	sub    $0x8,%eax
 610:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 613:	a1 b8 0a 00 00       	mov    0xab8,%eax
 618:	89 45 fc             	mov    %eax,-0x4(%ebp)
 61b:	eb 24                	jmp    641 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 61d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 620:	8b 00                	mov    (%eax),%eax
 622:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 625:	77 12                	ja     639 <free+0x35>
 627:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62d:	77 24                	ja     653 <free+0x4f>
 62f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 632:	8b 00                	mov    (%eax),%eax
 634:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 637:	77 1a                	ja     653 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 639:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63c:	8b 00                	mov    (%eax),%eax
 63e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 641:	8b 45 f8             	mov    -0x8(%ebp),%eax
 644:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 647:	76 d4                	jbe    61d <free+0x19>
 649:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64c:	8b 00                	mov    (%eax),%eax
 64e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 651:	76 ca                	jbe    61d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 653:	8b 45 f8             	mov    -0x8(%ebp),%eax
 656:	8b 40 04             	mov    0x4(%eax),%eax
 659:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 660:	8b 45 f8             	mov    -0x8(%ebp),%eax
 663:	01 c2                	add    %eax,%edx
 665:	8b 45 fc             	mov    -0x4(%ebp),%eax
 668:	8b 00                	mov    (%eax),%eax
 66a:	39 c2                	cmp    %eax,%edx
 66c:	75 24                	jne    692 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 66e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 671:	8b 50 04             	mov    0x4(%eax),%edx
 674:	8b 45 fc             	mov    -0x4(%ebp),%eax
 677:	8b 00                	mov    (%eax),%eax
 679:	8b 40 04             	mov    0x4(%eax),%eax
 67c:	01 c2                	add    %eax,%edx
 67e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 681:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 684:	8b 45 fc             	mov    -0x4(%ebp),%eax
 687:	8b 00                	mov    (%eax),%eax
 689:	8b 10                	mov    (%eax),%edx
 68b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68e:	89 10                	mov    %edx,(%eax)
 690:	eb 0a                	jmp    69c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 692:	8b 45 fc             	mov    -0x4(%ebp),%eax
 695:	8b 10                	mov    (%eax),%edx
 697:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 69c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69f:	8b 40 04             	mov    0x4(%eax),%eax
 6a2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ac:	01 d0                	add    %edx,%eax
 6ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b1:	75 20                	jne    6d3 <free+0xcf>
    p->s.size += bp->s.size;
 6b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b6:	8b 50 04             	mov    0x4(%eax),%edx
 6b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bc:	8b 40 04             	mov    0x4(%eax),%eax
 6bf:	01 c2                	add    %eax,%edx
 6c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ca:	8b 10                	mov    (%eax),%edx
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cf:	89 10                	mov    %edx,(%eax)
 6d1:	eb 08                	jmp    6db <free+0xd7>
  } else
    p->s.ptr = bp;
 6d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6d9:	89 10                	mov    %edx,(%eax)
  freep = p;
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	a3 b8 0a 00 00       	mov    %eax,0xab8
}
 6e3:	90                   	nop
 6e4:	c9                   	leave  
 6e5:	c3                   	ret    

000006e6 <morecore>:

static Header*
morecore(uint nu)
{
 6e6:	55                   	push   %ebp
 6e7:	89 e5                	mov    %esp,%ebp
 6e9:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6ec:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6f3:	77 07                	ja     6fc <morecore+0x16>
    nu = 4096;
 6f5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6fc:	8b 45 08             	mov    0x8(%ebp),%eax
 6ff:	c1 e0 03             	shl    $0x3,%eax
 702:	83 ec 0c             	sub    $0xc,%esp
 705:	50                   	push   %eax
 706:	e8 71 fc ff ff       	call   37c <sbrk>
 70b:	83 c4 10             	add    $0x10,%esp
 70e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 711:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 715:	75 07                	jne    71e <morecore+0x38>
    return 0;
 717:	b8 00 00 00 00       	mov    $0x0,%eax
 71c:	eb 26                	jmp    744 <morecore+0x5e>
  hp = (Header*)p;
 71e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 721:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 724:	8b 45 f0             	mov    -0x10(%ebp),%eax
 727:	8b 55 08             	mov    0x8(%ebp),%edx
 72a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 72d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 730:	83 c0 08             	add    $0x8,%eax
 733:	83 ec 0c             	sub    $0xc,%esp
 736:	50                   	push   %eax
 737:	e8 c8 fe ff ff       	call   604 <free>
 73c:	83 c4 10             	add    $0x10,%esp
  return freep;
 73f:	a1 b8 0a 00 00       	mov    0xab8,%eax
}
 744:	c9                   	leave  
 745:	c3                   	ret    

00000746 <malloc>:

void*
malloc(uint nbytes)
{
 746:	55                   	push   %ebp
 747:	89 e5                	mov    %esp,%ebp
 749:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 74c:	8b 45 08             	mov    0x8(%ebp),%eax
 74f:	83 c0 07             	add    $0x7,%eax
 752:	c1 e8 03             	shr    $0x3,%eax
 755:	83 c0 01             	add    $0x1,%eax
 758:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 75b:	a1 b8 0a 00 00       	mov    0xab8,%eax
 760:	89 45 f0             	mov    %eax,-0x10(%ebp)
 763:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 767:	75 23                	jne    78c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 769:	c7 45 f0 b0 0a 00 00 	movl   $0xab0,-0x10(%ebp)
 770:	8b 45 f0             	mov    -0x10(%ebp),%eax
 773:	a3 b8 0a 00 00       	mov    %eax,0xab8
 778:	a1 b8 0a 00 00       	mov    0xab8,%eax
 77d:	a3 b0 0a 00 00       	mov    %eax,0xab0
    base.s.size = 0;
 782:	c7 05 b4 0a 00 00 00 	movl   $0x0,0xab4
 789:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78f:	8b 00                	mov    (%eax),%eax
 791:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 794:	8b 45 f4             	mov    -0xc(%ebp),%eax
 797:	8b 40 04             	mov    0x4(%eax),%eax
 79a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 79d:	72 4d                	jb     7ec <malloc+0xa6>
      if(p->s.size == nunits)
 79f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a2:	8b 40 04             	mov    0x4(%eax),%eax
 7a5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7a8:	75 0c                	jne    7b6 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ad:	8b 10                	mov    (%eax),%edx
 7af:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b2:	89 10                	mov    %edx,(%eax)
 7b4:	eb 26                	jmp    7dc <malloc+0x96>
      else {
        p->s.size -= nunits;
 7b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b9:	8b 40 04             	mov    0x4(%eax),%eax
 7bc:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7bf:	89 c2                	mov    %eax,%edx
 7c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ca:	8b 40 04             	mov    0x4(%eax),%eax
 7cd:	c1 e0 03             	shl    $0x3,%eax
 7d0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7d9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7df:	a3 b8 0a 00 00       	mov    %eax,0xab8
      return (void*)(p + 1);
 7e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e7:	83 c0 08             	add    $0x8,%eax
 7ea:	eb 3b                	jmp    827 <malloc+0xe1>
    }
    if(p == freep)
 7ec:	a1 b8 0a 00 00       	mov    0xab8,%eax
 7f1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7f4:	75 1e                	jne    814 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7f6:	83 ec 0c             	sub    $0xc,%esp
 7f9:	ff 75 ec             	pushl  -0x14(%ebp)
 7fc:	e8 e5 fe ff ff       	call   6e6 <morecore>
 801:	83 c4 10             	add    $0x10,%esp
 804:	89 45 f4             	mov    %eax,-0xc(%ebp)
 807:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 80b:	75 07                	jne    814 <malloc+0xce>
        return 0;
 80d:	b8 00 00 00 00       	mov    $0x0,%eax
 812:	eb 13                	jmp    827 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 814:	8b 45 f4             	mov    -0xc(%ebp),%eax
 817:	89 45 f0             	mov    %eax,-0x10(%ebp)
 81a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81d:	8b 00                	mov    (%eax),%eax
 81f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 822:	e9 6d ff ff ff       	jmp    794 <malloc+0x4e>
}
 827:	c9                   	leave  
 828:	c3                   	ret    
