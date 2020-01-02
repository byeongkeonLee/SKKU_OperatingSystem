
_t1:     file format elf32-i386


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
	int pid;

	// fork process with deallocated stacks
	printf(1, "TEST1: ");
  11:	83 ec 08             	sub    $0x8,%esp
  14:	68 fb 07 00 00       	push   $0x7fb
  19:	6a 01                	push   $0x1
  1b:	e8 25 04 00 00       	call   445 <printf>
  20:	83 c4 10             	add    $0x10,%esp

	pid = fork();
  23:	e8 96 02 00 00       	call   2be <fork>
  28:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(pid<0){
  2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  2f:	79 17                	jns    48 <main+0x48>
		printf(1, "FAIL\n");
  31:	83 ec 08             	sub    $0x8,%esp
  34:	68 03 08 00 00       	push   $0x803
  39:	6a 01                	push   $0x1
  3b:	e8 05 04 00 00       	call   445 <printf>
  40:	83 c4 10             	add    $0x10,%esp
		exit();
  43:	e8 7e 02 00 00       	call   2c6 <exit>
	}

	if(pid==0)
  48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  4c:	75 05                	jne    53 <main+0x53>
		exit();
  4e:	e8 73 02 00 00       	call   2c6 <exit>
	else
		wait();
  53:	e8 76 02 00 00       	call   2ce <wait>

	printf(1, "OK\n");
  58:	83 ec 08             	sub    $0x8,%esp
  5b:	68 09 08 00 00       	push   $0x809
  60:	6a 01                	push   $0x1
  62:	e8 de 03 00 00       	call   445 <printf>
  67:	83 c4 10             	add    $0x10,%esp
	exit();
  6a:	e8 57 02 00 00       	call   2c6 <exit>

0000006f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  6f:	55                   	push   %ebp
  70:	89 e5                	mov    %esp,%ebp
  72:	57                   	push   %edi
  73:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  77:	8b 55 10             	mov    0x10(%ebp),%edx
  7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  7d:	89 cb                	mov    %ecx,%ebx
  7f:	89 df                	mov    %ebx,%edi
  81:	89 d1                	mov    %edx,%ecx
  83:	fc                   	cld    
  84:	f3 aa                	rep stos %al,%es:(%edi)
  86:	89 ca                	mov    %ecx,%edx
  88:	89 fb                	mov    %edi,%ebx
  8a:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  90:	90                   	nop
  91:	5b                   	pop    %ebx
  92:	5f                   	pop    %edi
  93:	5d                   	pop    %ebp
  94:	c3                   	ret    

00000095 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  95:	55                   	push   %ebp
  96:	89 e5                	mov    %esp,%ebp
  98:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  9b:	8b 45 08             	mov    0x8(%ebp),%eax
  9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a1:	90                   	nop
  a2:	8b 45 08             	mov    0x8(%ebp),%eax
  a5:	8d 50 01             	lea    0x1(%eax),%edx
  a8:	89 55 08             	mov    %edx,0x8(%ebp)
  ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  ae:	8d 4a 01             	lea    0x1(%edx),%ecx
  b1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b4:	0f b6 12             	movzbl (%edx),%edx
  b7:	88 10                	mov    %dl,(%eax)
  b9:	0f b6 00             	movzbl (%eax),%eax
  bc:	84 c0                	test   %al,%al
  be:	75 e2                	jne    a2 <strcpy+0xd>
    ;
  return os;
  c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c3:	c9                   	leave  
  c4:	c3                   	ret    

000000c5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c5:	55                   	push   %ebp
  c6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c8:	eb 08                	jmp    d2 <strcmp+0xd>
    p++, q++;
  ca:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ce:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	0f b6 00             	movzbl (%eax),%eax
  d8:	84 c0                	test   %al,%al
  da:	74 10                	je     ec <strcmp+0x27>
  dc:	8b 45 08             	mov    0x8(%ebp),%eax
  df:	0f b6 10             	movzbl (%eax),%edx
  e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  e5:	0f b6 00             	movzbl (%eax),%eax
  e8:	38 c2                	cmp    %al,%dl
  ea:	74 de                	je     ca <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  ec:	8b 45 08             	mov    0x8(%ebp),%eax
  ef:	0f b6 00             	movzbl (%eax),%eax
  f2:	0f b6 d0             	movzbl %al,%edx
  f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  f8:	0f b6 00             	movzbl (%eax),%eax
  fb:	0f b6 c0             	movzbl %al,%eax
  fe:	29 c2                	sub    %eax,%edx
 100:	89 d0                	mov    %edx,%eax
}
 102:	5d                   	pop    %ebp
 103:	c3                   	ret    

00000104 <strlen>:

uint
strlen(char *s)
{
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 111:	eb 04                	jmp    117 <strlen+0x13>
 113:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 117:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11a:	8b 45 08             	mov    0x8(%ebp),%eax
 11d:	01 d0                	add    %edx,%eax
 11f:	0f b6 00             	movzbl (%eax),%eax
 122:	84 c0                	test   %al,%al
 124:	75 ed                	jne    113 <strlen+0xf>
    ;
  return n;
 126:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 129:	c9                   	leave  
 12a:	c3                   	ret    

0000012b <memset>:

void*
memset(void *dst, int c, uint n)
{
 12b:	55                   	push   %ebp
 12c:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 12e:	8b 45 10             	mov    0x10(%ebp),%eax
 131:	50                   	push   %eax
 132:	ff 75 0c             	pushl  0xc(%ebp)
 135:	ff 75 08             	pushl  0x8(%ebp)
 138:	e8 32 ff ff ff       	call   6f <stosb>
 13d:	83 c4 0c             	add    $0xc,%esp
  return dst;
 140:	8b 45 08             	mov    0x8(%ebp),%eax
}
 143:	c9                   	leave  
 144:	c3                   	ret    

00000145 <strchr>:

char*
strchr(const char *s, char c)
{
 145:	55                   	push   %ebp
 146:	89 e5                	mov    %esp,%ebp
 148:	83 ec 04             	sub    $0x4,%esp
 14b:	8b 45 0c             	mov    0xc(%ebp),%eax
 14e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 151:	eb 14                	jmp    167 <strchr+0x22>
    if(*s == c)
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	0f b6 00             	movzbl (%eax),%eax
 159:	3a 45 fc             	cmp    -0x4(%ebp),%al
 15c:	75 05                	jne    163 <strchr+0x1e>
      return (char*)s;
 15e:	8b 45 08             	mov    0x8(%ebp),%eax
 161:	eb 13                	jmp    176 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 163:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 167:	8b 45 08             	mov    0x8(%ebp),%eax
 16a:	0f b6 00             	movzbl (%eax),%eax
 16d:	84 c0                	test   %al,%al
 16f:	75 e2                	jne    153 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 171:	b8 00 00 00 00       	mov    $0x0,%eax
}
 176:	c9                   	leave  
 177:	c3                   	ret    

00000178 <gets>:

char*
gets(char *buf, int max)
{
 178:	55                   	push   %ebp
 179:	89 e5                	mov    %esp,%ebp
 17b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 185:	eb 42                	jmp    1c9 <gets+0x51>
    cc = read(0, &c, 1);
 187:	83 ec 04             	sub    $0x4,%esp
 18a:	6a 01                	push   $0x1
 18c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 18f:	50                   	push   %eax
 190:	6a 00                	push   $0x0
 192:	e8 47 01 00 00       	call   2de <read>
 197:	83 c4 10             	add    $0x10,%esp
 19a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 19d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a1:	7e 33                	jle    1d6 <gets+0x5e>
      break;
    buf[i++] = c;
 1a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a6:	8d 50 01             	lea    0x1(%eax),%edx
 1a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1ac:	89 c2                	mov    %eax,%edx
 1ae:	8b 45 08             	mov    0x8(%ebp),%eax
 1b1:	01 c2                	add    %eax,%edx
 1b3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b7:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1b9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bd:	3c 0a                	cmp    $0xa,%al
 1bf:	74 16                	je     1d7 <gets+0x5f>
 1c1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c5:	3c 0d                	cmp    $0xd,%al
 1c7:	74 0e                	je     1d7 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1cc:	83 c0 01             	add    $0x1,%eax
 1cf:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d2:	7c b3                	jl     187 <gets+0xf>
 1d4:	eb 01                	jmp    1d7 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1d6:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1da:	8b 45 08             	mov    0x8(%ebp),%eax
 1dd:	01 d0                	add    %edx,%eax
 1df:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e5:	c9                   	leave  
 1e6:	c3                   	ret    

000001e7 <stat>:

int
stat(char *n, struct stat *st)
{
 1e7:	55                   	push   %ebp
 1e8:	89 e5                	mov    %esp,%ebp
 1ea:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ed:	83 ec 08             	sub    $0x8,%esp
 1f0:	6a 00                	push   $0x0
 1f2:	ff 75 08             	pushl  0x8(%ebp)
 1f5:	e8 0c 01 00 00       	call   306 <open>
 1fa:	83 c4 10             	add    $0x10,%esp
 1fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 200:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 204:	79 07                	jns    20d <stat+0x26>
    return -1;
 206:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 20b:	eb 25                	jmp    232 <stat+0x4b>
  r = fstat(fd, st);
 20d:	83 ec 08             	sub    $0x8,%esp
 210:	ff 75 0c             	pushl  0xc(%ebp)
 213:	ff 75 f4             	pushl  -0xc(%ebp)
 216:	e8 03 01 00 00       	call   31e <fstat>
 21b:	83 c4 10             	add    $0x10,%esp
 21e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 221:	83 ec 0c             	sub    $0xc,%esp
 224:	ff 75 f4             	pushl  -0xc(%ebp)
 227:	e8 c2 00 00 00       	call   2ee <close>
 22c:	83 c4 10             	add    $0x10,%esp
  return r;
 22f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 232:	c9                   	leave  
 233:	c3                   	ret    

00000234 <atoi>:

int
atoi(const char *s)
{
 234:	55                   	push   %ebp
 235:	89 e5                	mov    %esp,%ebp
 237:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 241:	eb 25                	jmp    268 <atoi+0x34>
    n = n*10 + *s++ - '0';
 243:	8b 55 fc             	mov    -0x4(%ebp),%edx
 246:	89 d0                	mov    %edx,%eax
 248:	c1 e0 02             	shl    $0x2,%eax
 24b:	01 d0                	add    %edx,%eax
 24d:	01 c0                	add    %eax,%eax
 24f:	89 c1                	mov    %eax,%ecx
 251:	8b 45 08             	mov    0x8(%ebp),%eax
 254:	8d 50 01             	lea    0x1(%eax),%edx
 257:	89 55 08             	mov    %edx,0x8(%ebp)
 25a:	0f b6 00             	movzbl (%eax),%eax
 25d:	0f be c0             	movsbl %al,%eax
 260:	01 c8                	add    %ecx,%eax
 262:	83 e8 30             	sub    $0x30,%eax
 265:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	0f b6 00             	movzbl (%eax),%eax
 26e:	3c 2f                	cmp    $0x2f,%al
 270:	7e 0a                	jle    27c <atoi+0x48>
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	0f b6 00             	movzbl (%eax),%eax
 278:	3c 39                	cmp    $0x39,%al
 27a:	7e c7                	jle    243 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 27c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 27f:	c9                   	leave  
 280:	c3                   	ret    

00000281 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 281:	55                   	push   %ebp
 282:	89 e5                	mov    %esp,%ebp
 284:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 287:	8b 45 08             	mov    0x8(%ebp),%eax
 28a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 28d:	8b 45 0c             	mov    0xc(%ebp),%eax
 290:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 293:	eb 17                	jmp    2ac <memmove+0x2b>
    *dst++ = *src++;
 295:	8b 45 fc             	mov    -0x4(%ebp),%eax
 298:	8d 50 01             	lea    0x1(%eax),%edx
 29b:	89 55 fc             	mov    %edx,-0x4(%ebp)
 29e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2a1:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a4:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2a7:	0f b6 12             	movzbl (%edx),%edx
 2aa:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ac:	8b 45 10             	mov    0x10(%ebp),%eax
 2af:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b2:	89 55 10             	mov    %edx,0x10(%ebp)
 2b5:	85 c0                	test   %eax,%eax
 2b7:	7f dc                	jg     295 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bc:	c9                   	leave  
 2bd:	c3                   	ret    

000002be <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2be:	b8 01 00 00 00       	mov    $0x1,%eax
 2c3:	cd 40                	int    $0x40
 2c5:	c3                   	ret    

000002c6 <exit>:
SYSCALL(exit)
 2c6:	b8 02 00 00 00       	mov    $0x2,%eax
 2cb:	cd 40                	int    $0x40
 2cd:	c3                   	ret    

000002ce <wait>:
SYSCALL(wait)
 2ce:	b8 03 00 00 00       	mov    $0x3,%eax
 2d3:	cd 40                	int    $0x40
 2d5:	c3                   	ret    

000002d6 <pipe>:
SYSCALL(pipe)
 2d6:	b8 04 00 00 00       	mov    $0x4,%eax
 2db:	cd 40                	int    $0x40
 2dd:	c3                   	ret    

000002de <read>:
SYSCALL(read)
 2de:	b8 05 00 00 00       	mov    $0x5,%eax
 2e3:	cd 40                	int    $0x40
 2e5:	c3                   	ret    

000002e6 <write>:
SYSCALL(write)
 2e6:	b8 10 00 00 00       	mov    $0x10,%eax
 2eb:	cd 40                	int    $0x40
 2ed:	c3                   	ret    

000002ee <close>:
SYSCALL(close)
 2ee:	b8 15 00 00 00       	mov    $0x15,%eax
 2f3:	cd 40                	int    $0x40
 2f5:	c3                   	ret    

000002f6 <kill>:
SYSCALL(kill)
 2f6:	b8 06 00 00 00       	mov    $0x6,%eax
 2fb:	cd 40                	int    $0x40
 2fd:	c3                   	ret    

000002fe <exec>:
SYSCALL(exec)
 2fe:	b8 07 00 00 00       	mov    $0x7,%eax
 303:	cd 40                	int    $0x40
 305:	c3                   	ret    

00000306 <open>:
SYSCALL(open)
 306:	b8 0f 00 00 00       	mov    $0xf,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret    

0000030e <mknod>:
SYSCALL(mknod)
 30e:	b8 11 00 00 00       	mov    $0x11,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    

00000316 <unlink>:
SYSCALL(unlink)
 316:	b8 12 00 00 00       	mov    $0x12,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <fstat>:
SYSCALL(fstat)
 31e:	b8 08 00 00 00       	mov    $0x8,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <link>:
SYSCALL(link)
 326:	b8 13 00 00 00       	mov    $0x13,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <mkdir>:
SYSCALL(mkdir)
 32e:	b8 14 00 00 00       	mov    $0x14,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <chdir>:
SYSCALL(chdir)
 336:	b8 09 00 00 00       	mov    $0x9,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <dup>:
SYSCALL(dup)
 33e:	b8 0a 00 00 00       	mov    $0xa,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <getpid>:
SYSCALL(getpid)
 346:	b8 0b 00 00 00       	mov    $0xb,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <sbrk>:
SYSCALL(sbrk)
 34e:	b8 0c 00 00 00       	mov    $0xc,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <sleep>:
SYSCALL(sleep)
 356:	b8 0d 00 00 00       	mov    $0xd,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <uptime>:
SYSCALL(uptime)
 35e:	b8 0e 00 00 00       	mov    $0xe,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <halt>:
SYSCALL(halt)
 366:	b8 16 00 00 00       	mov    $0x16,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 36e:	55                   	push   %ebp
 36f:	89 e5                	mov    %esp,%ebp
 371:	83 ec 18             	sub    $0x18,%esp
 374:	8b 45 0c             	mov    0xc(%ebp),%eax
 377:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 37a:	83 ec 04             	sub    $0x4,%esp
 37d:	6a 01                	push   $0x1
 37f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 382:	50                   	push   %eax
 383:	ff 75 08             	pushl  0x8(%ebp)
 386:	e8 5b ff ff ff       	call   2e6 <write>
 38b:	83 c4 10             	add    $0x10,%esp
}
 38e:	90                   	nop
 38f:	c9                   	leave  
 390:	c3                   	ret    

00000391 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 391:	55                   	push   %ebp
 392:	89 e5                	mov    %esp,%ebp
 394:	53                   	push   %ebx
 395:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 398:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 39f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3a3:	74 17                	je     3bc <printint+0x2b>
 3a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3a9:	79 11                	jns    3bc <printint+0x2b>
    neg = 1;
 3ab:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b5:	f7 d8                	neg    %eax
 3b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ba:	eb 06                	jmp    3c2 <printint+0x31>
  } else {
    x = xx;
 3bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3c9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3cc:	8d 41 01             	lea    0x1(%ecx),%eax
 3cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d8:	ba 00 00 00 00       	mov    $0x0,%edx
 3dd:	f7 f3                	div    %ebx
 3df:	89 d0                	mov    %edx,%eax
 3e1:	0f b6 80 5c 0a 00 00 	movzbl 0xa5c(%eax),%eax
 3e8:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3f2:	ba 00 00 00 00       	mov    $0x0,%edx
 3f7:	f7 f3                	div    %ebx
 3f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 400:	75 c7                	jne    3c9 <printint+0x38>
  if(neg)
 402:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 406:	74 2d                	je     435 <printint+0xa4>
    buf[i++] = '-';
 408:	8b 45 f4             	mov    -0xc(%ebp),%eax
 40b:	8d 50 01             	lea    0x1(%eax),%edx
 40e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 411:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 416:	eb 1d                	jmp    435 <printint+0xa4>
    putc(fd, buf[i]);
 418:	8d 55 dc             	lea    -0x24(%ebp),%edx
 41b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41e:	01 d0                	add    %edx,%eax
 420:	0f b6 00             	movzbl (%eax),%eax
 423:	0f be c0             	movsbl %al,%eax
 426:	83 ec 08             	sub    $0x8,%esp
 429:	50                   	push   %eax
 42a:	ff 75 08             	pushl  0x8(%ebp)
 42d:	e8 3c ff ff ff       	call   36e <putc>
 432:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 435:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 439:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 43d:	79 d9                	jns    418 <printint+0x87>
    putc(fd, buf[i]);
}
 43f:	90                   	nop
 440:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 443:	c9                   	leave  
 444:	c3                   	ret    

00000445 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 445:	55                   	push   %ebp
 446:	89 e5                	mov    %esp,%ebp
 448:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 44b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 452:	8d 45 0c             	lea    0xc(%ebp),%eax
 455:	83 c0 04             	add    $0x4,%eax
 458:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 45b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 462:	e9 59 01 00 00       	jmp    5c0 <printf+0x17b>
    c = fmt[i] & 0xff;
 467:	8b 55 0c             	mov    0xc(%ebp),%edx
 46a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 46d:	01 d0                	add    %edx,%eax
 46f:	0f b6 00             	movzbl (%eax),%eax
 472:	0f be c0             	movsbl %al,%eax
 475:	25 ff 00 00 00       	and    $0xff,%eax
 47a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 47d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 481:	75 2c                	jne    4af <printf+0x6a>
      if(c == '%'){
 483:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 487:	75 0c                	jne    495 <printf+0x50>
        state = '%';
 489:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 490:	e9 27 01 00 00       	jmp    5bc <printf+0x177>
      } else {
        putc(fd, c);
 495:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 498:	0f be c0             	movsbl %al,%eax
 49b:	83 ec 08             	sub    $0x8,%esp
 49e:	50                   	push   %eax
 49f:	ff 75 08             	pushl  0x8(%ebp)
 4a2:	e8 c7 fe ff ff       	call   36e <putc>
 4a7:	83 c4 10             	add    $0x10,%esp
 4aa:	e9 0d 01 00 00       	jmp    5bc <printf+0x177>
      }
    } else if(state == '%'){
 4af:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4b3:	0f 85 03 01 00 00    	jne    5bc <printf+0x177>
      if(c == 'd'){
 4b9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4bd:	75 1e                	jne    4dd <printf+0x98>
        printint(fd, *ap, 10, 1);
 4bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4c2:	8b 00                	mov    (%eax),%eax
 4c4:	6a 01                	push   $0x1
 4c6:	6a 0a                	push   $0xa
 4c8:	50                   	push   %eax
 4c9:	ff 75 08             	pushl  0x8(%ebp)
 4cc:	e8 c0 fe ff ff       	call   391 <printint>
 4d1:	83 c4 10             	add    $0x10,%esp
        ap++;
 4d4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4d8:	e9 d8 00 00 00       	jmp    5b5 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4dd:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4e1:	74 06                	je     4e9 <printf+0xa4>
 4e3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4e7:	75 1e                	jne    507 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ec:	8b 00                	mov    (%eax),%eax
 4ee:	6a 00                	push   $0x0
 4f0:	6a 10                	push   $0x10
 4f2:	50                   	push   %eax
 4f3:	ff 75 08             	pushl  0x8(%ebp)
 4f6:	e8 96 fe ff ff       	call   391 <printint>
 4fb:	83 c4 10             	add    $0x10,%esp
        ap++;
 4fe:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 502:	e9 ae 00 00 00       	jmp    5b5 <printf+0x170>
      } else if(c == 's'){
 507:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 50b:	75 43                	jne    550 <printf+0x10b>
        s = (char*)*ap;
 50d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 510:	8b 00                	mov    (%eax),%eax
 512:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 515:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 519:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 51d:	75 25                	jne    544 <printf+0xff>
          s = "(null)";
 51f:	c7 45 f4 0d 08 00 00 	movl   $0x80d,-0xc(%ebp)
        while(*s != 0){
 526:	eb 1c                	jmp    544 <printf+0xff>
          putc(fd, *s);
 528:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52b:	0f b6 00             	movzbl (%eax),%eax
 52e:	0f be c0             	movsbl %al,%eax
 531:	83 ec 08             	sub    $0x8,%esp
 534:	50                   	push   %eax
 535:	ff 75 08             	pushl  0x8(%ebp)
 538:	e8 31 fe ff ff       	call   36e <putc>
 53d:	83 c4 10             	add    $0x10,%esp
          s++;
 540:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 544:	8b 45 f4             	mov    -0xc(%ebp),%eax
 547:	0f b6 00             	movzbl (%eax),%eax
 54a:	84 c0                	test   %al,%al
 54c:	75 da                	jne    528 <printf+0xe3>
 54e:	eb 65                	jmp    5b5 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 550:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 554:	75 1d                	jne    573 <printf+0x12e>
        putc(fd, *ap);
 556:	8b 45 e8             	mov    -0x18(%ebp),%eax
 559:	8b 00                	mov    (%eax),%eax
 55b:	0f be c0             	movsbl %al,%eax
 55e:	83 ec 08             	sub    $0x8,%esp
 561:	50                   	push   %eax
 562:	ff 75 08             	pushl  0x8(%ebp)
 565:	e8 04 fe ff ff       	call   36e <putc>
 56a:	83 c4 10             	add    $0x10,%esp
        ap++;
 56d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 571:	eb 42                	jmp    5b5 <printf+0x170>
      } else if(c == '%'){
 573:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 577:	75 17                	jne    590 <printf+0x14b>
        putc(fd, c);
 579:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 57c:	0f be c0             	movsbl %al,%eax
 57f:	83 ec 08             	sub    $0x8,%esp
 582:	50                   	push   %eax
 583:	ff 75 08             	pushl  0x8(%ebp)
 586:	e8 e3 fd ff ff       	call   36e <putc>
 58b:	83 c4 10             	add    $0x10,%esp
 58e:	eb 25                	jmp    5b5 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 590:	83 ec 08             	sub    $0x8,%esp
 593:	6a 25                	push   $0x25
 595:	ff 75 08             	pushl  0x8(%ebp)
 598:	e8 d1 fd ff ff       	call   36e <putc>
 59d:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a3:	0f be c0             	movsbl %al,%eax
 5a6:	83 ec 08             	sub    $0x8,%esp
 5a9:	50                   	push   %eax
 5aa:	ff 75 08             	pushl  0x8(%ebp)
 5ad:	e8 bc fd ff ff       	call   36e <putc>
 5b2:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5b5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5bc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5c0:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5c6:	01 d0                	add    %edx,%eax
 5c8:	0f b6 00             	movzbl (%eax),%eax
 5cb:	84 c0                	test   %al,%al
 5cd:	0f 85 94 fe ff ff    	jne    467 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5d3:	90                   	nop
 5d4:	c9                   	leave  
 5d5:	c3                   	ret    

000005d6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5d6:	55                   	push   %ebp
 5d7:	89 e5                	mov    %esp,%ebp
 5d9:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5dc:	8b 45 08             	mov    0x8(%ebp),%eax
 5df:	83 e8 08             	sub    $0x8,%eax
 5e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e5:	a1 78 0a 00 00       	mov    0xa78,%eax
 5ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5ed:	eb 24                	jmp    613 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f2:	8b 00                	mov    (%eax),%eax
 5f4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f7:	77 12                	ja     60b <free+0x35>
 5f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5fc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5ff:	77 24                	ja     625 <free+0x4f>
 601:	8b 45 fc             	mov    -0x4(%ebp),%eax
 604:	8b 00                	mov    (%eax),%eax
 606:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 609:	77 1a                	ja     625 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 60b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60e:	8b 00                	mov    (%eax),%eax
 610:	89 45 fc             	mov    %eax,-0x4(%ebp)
 613:	8b 45 f8             	mov    -0x8(%ebp),%eax
 616:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 619:	76 d4                	jbe    5ef <free+0x19>
 61b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61e:	8b 00                	mov    (%eax),%eax
 620:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 623:	76 ca                	jbe    5ef <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 625:	8b 45 f8             	mov    -0x8(%ebp),%eax
 628:	8b 40 04             	mov    0x4(%eax),%eax
 62b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 632:	8b 45 f8             	mov    -0x8(%ebp),%eax
 635:	01 c2                	add    %eax,%edx
 637:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63a:	8b 00                	mov    (%eax),%eax
 63c:	39 c2                	cmp    %eax,%edx
 63e:	75 24                	jne    664 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 640:	8b 45 f8             	mov    -0x8(%ebp),%eax
 643:	8b 50 04             	mov    0x4(%eax),%edx
 646:	8b 45 fc             	mov    -0x4(%ebp),%eax
 649:	8b 00                	mov    (%eax),%eax
 64b:	8b 40 04             	mov    0x4(%eax),%eax
 64e:	01 c2                	add    %eax,%edx
 650:	8b 45 f8             	mov    -0x8(%ebp),%eax
 653:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 656:	8b 45 fc             	mov    -0x4(%ebp),%eax
 659:	8b 00                	mov    (%eax),%eax
 65b:	8b 10                	mov    (%eax),%edx
 65d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 660:	89 10                	mov    %edx,(%eax)
 662:	eb 0a                	jmp    66e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 664:	8b 45 fc             	mov    -0x4(%ebp),%eax
 667:	8b 10                	mov    (%eax),%edx
 669:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 66e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 671:	8b 40 04             	mov    0x4(%eax),%eax
 674:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 67b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67e:	01 d0                	add    %edx,%eax
 680:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 683:	75 20                	jne    6a5 <free+0xcf>
    p->s.size += bp->s.size;
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
 688:	8b 50 04             	mov    0x4(%eax),%edx
 68b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68e:	8b 40 04             	mov    0x4(%eax),%eax
 691:	01 c2                	add    %eax,%edx
 693:	8b 45 fc             	mov    -0x4(%ebp),%eax
 696:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 699:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69c:	8b 10                	mov    (%eax),%edx
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	89 10                	mov    %edx,(%eax)
 6a3:	eb 08                	jmp    6ad <free+0xd7>
  } else
    p->s.ptr = bp;
 6a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6ab:	89 10                	mov    %edx,(%eax)
  freep = p;
 6ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b0:	a3 78 0a 00 00       	mov    %eax,0xa78
}
 6b5:	90                   	nop
 6b6:	c9                   	leave  
 6b7:	c3                   	ret    

000006b8 <morecore>:

static Header*
morecore(uint nu)
{
 6b8:	55                   	push   %ebp
 6b9:	89 e5                	mov    %esp,%ebp
 6bb:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6be:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6c5:	77 07                	ja     6ce <morecore+0x16>
    nu = 4096;
 6c7:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6ce:	8b 45 08             	mov    0x8(%ebp),%eax
 6d1:	c1 e0 03             	shl    $0x3,%eax
 6d4:	83 ec 0c             	sub    $0xc,%esp
 6d7:	50                   	push   %eax
 6d8:	e8 71 fc ff ff       	call   34e <sbrk>
 6dd:	83 c4 10             	add    $0x10,%esp
 6e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6e3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6e7:	75 07                	jne    6f0 <morecore+0x38>
    return 0;
 6e9:	b8 00 00 00 00       	mov    $0x0,%eax
 6ee:	eb 26                	jmp    716 <morecore+0x5e>
  hp = (Header*)p;
 6f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f9:	8b 55 08             	mov    0x8(%ebp),%edx
 6fc:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 702:	83 c0 08             	add    $0x8,%eax
 705:	83 ec 0c             	sub    $0xc,%esp
 708:	50                   	push   %eax
 709:	e8 c8 fe ff ff       	call   5d6 <free>
 70e:	83 c4 10             	add    $0x10,%esp
  return freep;
 711:	a1 78 0a 00 00       	mov    0xa78,%eax
}
 716:	c9                   	leave  
 717:	c3                   	ret    

00000718 <malloc>:

void*
malloc(uint nbytes)
{
 718:	55                   	push   %ebp
 719:	89 e5                	mov    %esp,%ebp
 71b:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 71e:	8b 45 08             	mov    0x8(%ebp),%eax
 721:	83 c0 07             	add    $0x7,%eax
 724:	c1 e8 03             	shr    $0x3,%eax
 727:	83 c0 01             	add    $0x1,%eax
 72a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 72d:	a1 78 0a 00 00       	mov    0xa78,%eax
 732:	89 45 f0             	mov    %eax,-0x10(%ebp)
 735:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 739:	75 23                	jne    75e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 73b:	c7 45 f0 70 0a 00 00 	movl   $0xa70,-0x10(%ebp)
 742:	8b 45 f0             	mov    -0x10(%ebp),%eax
 745:	a3 78 0a 00 00       	mov    %eax,0xa78
 74a:	a1 78 0a 00 00       	mov    0xa78,%eax
 74f:	a3 70 0a 00 00       	mov    %eax,0xa70
    base.s.size = 0;
 754:	c7 05 74 0a 00 00 00 	movl   $0x0,0xa74
 75b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 75e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 761:	8b 00                	mov    (%eax),%eax
 763:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 766:	8b 45 f4             	mov    -0xc(%ebp),%eax
 769:	8b 40 04             	mov    0x4(%eax),%eax
 76c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 76f:	72 4d                	jb     7be <malloc+0xa6>
      if(p->s.size == nunits)
 771:	8b 45 f4             	mov    -0xc(%ebp),%eax
 774:	8b 40 04             	mov    0x4(%eax),%eax
 777:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 77a:	75 0c                	jne    788 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 77c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77f:	8b 10                	mov    (%eax),%edx
 781:	8b 45 f0             	mov    -0x10(%ebp),%eax
 784:	89 10                	mov    %edx,(%eax)
 786:	eb 26                	jmp    7ae <malloc+0x96>
      else {
        p->s.size -= nunits;
 788:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78b:	8b 40 04             	mov    0x4(%eax),%eax
 78e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 791:	89 c2                	mov    %eax,%edx
 793:	8b 45 f4             	mov    -0xc(%ebp),%eax
 796:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 799:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79c:	8b 40 04             	mov    0x4(%eax),%eax
 79f:	c1 e0 03             	shl    $0x3,%eax
 7a2:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7ab:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b1:	a3 78 0a 00 00       	mov    %eax,0xa78
      return (void*)(p + 1);
 7b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b9:	83 c0 08             	add    $0x8,%eax
 7bc:	eb 3b                	jmp    7f9 <malloc+0xe1>
    }
    if(p == freep)
 7be:	a1 78 0a 00 00       	mov    0xa78,%eax
 7c3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7c6:	75 1e                	jne    7e6 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7c8:	83 ec 0c             	sub    $0xc,%esp
 7cb:	ff 75 ec             	pushl  -0x14(%ebp)
 7ce:	e8 e5 fe ff ff       	call   6b8 <morecore>
 7d3:	83 c4 10             	add    $0x10,%esp
 7d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7dd:	75 07                	jne    7e6 <malloc+0xce>
        return 0;
 7df:	b8 00 00 00 00       	mov    $0x0,%eax
 7e4:	eb 13                	jmp    7f9 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ef:	8b 00                	mov    (%eax),%eax
 7f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7f4:	e9 6d ff ff ff       	jmp    766 <malloc+0x4e>
}
 7f9:	c9                   	leave  
 7fa:	c3                   	ret    
