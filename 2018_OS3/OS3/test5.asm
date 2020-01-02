
_test5:     file format elf32-i386


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

00000021 <main>:

	int
main(int argc, char **argv)
{
  21:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  25:	83 e4 f0             	and    $0xfffffff0,%esp
  28:	ff 71 fc             	pushl  -0x4(%ecx)
  2b:	55                   	push   %ebp
  2c:	89 e5                	mov    %esp,%ebp
  2e:	51                   	push   %ecx
  2f:	83 ec 14             	sub    $0x14,%esp
	int ppid, pid;

	// stack overflow test
	printf(1, "TEST4: ");
  32:	83 ec 08             	sub    $0x8,%esp
  35:	68 37 08 00 00       	push   $0x837
  3a:	6a 01                	push   $0x1
  3c:	e8 40 04 00 00       	call   481 <printf>
  41:	83 c4 10             	add    $0x10,%esp

	ppid = getpid();
  44:	e8 39 03 00 00       	call   382 <getpid>
  49:	89 45 f4             	mov    %eax,-0xc(%ebp)
	pid = fork();
  4c:	e8 a9 02 00 00       	call   2fa <fork>
  51:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if(pid==0){
  54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  58:	75 35                	jne    8f <main+0x6e>
		recursion(1000);
  5a:	83 ec 0c             	sub    $0xc,%esp
  5d:	68 e8 03 00 00       	push   $0x3e8
  62:	e8 99 ff ff ff       	call   0 <recursion>
  67:	83 c4 10             	add    $0x10,%esp
		printf(1, "FAIL\n");
  6a:	83 ec 08             	sub    $0x8,%esp
  6d:	68 3f 08 00 00       	push   $0x83f
  72:	6a 01                	push   $0x1
  74:	e8 08 04 00 00       	call   481 <printf>
  79:	83 c4 10             	add    $0x10,%esp
		kill(ppid);
  7c:	83 ec 0c             	sub    $0xc,%esp
  7f:	ff 75 f4             	pushl  -0xc(%ebp)
  82:	e8 ab 02 00 00       	call   332 <kill>
  87:	83 c4 10             	add    $0x10,%esp
		exit();
  8a:	e8 73 02 00 00       	call   302 <exit>
	}
	wait();
  8f:	e8 76 02 00 00       	call   30a <wait>
	printf(1, "OK\n");
  94:	83 ec 08             	sub    $0x8,%esp
  97:	68 45 08 00 00       	push   $0x845
  9c:	6a 01                	push   $0x1
  9e:	e8 de 03 00 00       	call   481 <printf>
  a3:	83 c4 10             	add    $0x10,%esp
	exit();
  a6:	e8 57 02 00 00       	call   302 <exit>

000000ab <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  ab:	55                   	push   %ebp
  ac:	89 e5                	mov    %esp,%ebp
  ae:	57                   	push   %edi
  af:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  b3:	8b 55 10             	mov    0x10(%ebp),%edx
  b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  b9:	89 cb                	mov    %ecx,%ebx
  bb:	89 df                	mov    %ebx,%edi
  bd:	89 d1                	mov    %edx,%ecx
  bf:	fc                   	cld    
  c0:	f3 aa                	rep stos %al,%es:(%edi)
  c2:	89 ca                	mov    %ecx,%edx
  c4:	89 fb                	mov    %edi,%ebx
  c6:	89 5d 08             	mov    %ebx,0x8(%ebp)
  c9:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  cc:	90                   	nop
  cd:	5b                   	pop    %ebx
  ce:	5f                   	pop    %edi
  cf:	5d                   	pop    %ebp
  d0:	c3                   	ret    

000000d1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  d1:	55                   	push   %ebp
  d2:	89 e5                	mov    %esp,%ebp
  d4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  dd:	90                   	nop
  de:	8b 45 08             	mov    0x8(%ebp),%eax
  e1:	8d 50 01             	lea    0x1(%eax),%edx
  e4:	89 55 08             	mov    %edx,0x8(%ebp)
  e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  ea:	8d 4a 01             	lea    0x1(%edx),%ecx
  ed:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  f0:	0f b6 12             	movzbl (%edx),%edx
  f3:	88 10                	mov    %dl,(%eax)
  f5:	0f b6 00             	movzbl (%eax),%eax
  f8:	84 c0                	test   %al,%al
  fa:	75 e2                	jne    de <strcpy+0xd>
    ;
  return os;
  fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ff:	c9                   	leave  
 100:	c3                   	ret    

00000101 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 104:	eb 08                	jmp    10e <strcmp+0xd>
    p++, q++;
 106:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 10a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 10e:	8b 45 08             	mov    0x8(%ebp),%eax
 111:	0f b6 00             	movzbl (%eax),%eax
 114:	84 c0                	test   %al,%al
 116:	74 10                	je     128 <strcmp+0x27>
 118:	8b 45 08             	mov    0x8(%ebp),%eax
 11b:	0f b6 10             	movzbl (%eax),%edx
 11e:	8b 45 0c             	mov    0xc(%ebp),%eax
 121:	0f b6 00             	movzbl (%eax),%eax
 124:	38 c2                	cmp    %al,%dl
 126:	74 de                	je     106 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 128:	8b 45 08             	mov    0x8(%ebp),%eax
 12b:	0f b6 00             	movzbl (%eax),%eax
 12e:	0f b6 d0             	movzbl %al,%edx
 131:	8b 45 0c             	mov    0xc(%ebp),%eax
 134:	0f b6 00             	movzbl (%eax),%eax
 137:	0f b6 c0             	movzbl %al,%eax
 13a:	29 c2                	sub    %eax,%edx
 13c:	89 d0                	mov    %edx,%eax
}
 13e:	5d                   	pop    %ebp
 13f:	c3                   	ret    

00000140 <strlen>:

uint
strlen(char *s)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 146:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 14d:	eb 04                	jmp    153 <strlen+0x13>
 14f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 153:	8b 55 fc             	mov    -0x4(%ebp),%edx
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	01 d0                	add    %edx,%eax
 15b:	0f b6 00             	movzbl (%eax),%eax
 15e:	84 c0                	test   %al,%al
 160:	75 ed                	jne    14f <strlen+0xf>
    ;
  return n;
 162:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 165:	c9                   	leave  
 166:	c3                   	ret    

00000167 <memset>:

void*
memset(void *dst, int c, uint n)
{
 167:	55                   	push   %ebp
 168:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 16a:	8b 45 10             	mov    0x10(%ebp),%eax
 16d:	50                   	push   %eax
 16e:	ff 75 0c             	pushl  0xc(%ebp)
 171:	ff 75 08             	pushl  0x8(%ebp)
 174:	e8 32 ff ff ff       	call   ab <stosb>
 179:	83 c4 0c             	add    $0xc,%esp
  return dst;
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 17f:	c9                   	leave  
 180:	c3                   	ret    

00000181 <strchr>:

char*
strchr(const char *s, char c)
{
 181:	55                   	push   %ebp
 182:	89 e5                	mov    %esp,%ebp
 184:	83 ec 04             	sub    $0x4,%esp
 187:	8b 45 0c             	mov    0xc(%ebp),%eax
 18a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 18d:	eb 14                	jmp    1a3 <strchr+0x22>
    if(*s == c)
 18f:	8b 45 08             	mov    0x8(%ebp),%eax
 192:	0f b6 00             	movzbl (%eax),%eax
 195:	3a 45 fc             	cmp    -0x4(%ebp),%al
 198:	75 05                	jne    19f <strchr+0x1e>
      return (char*)s;
 19a:	8b 45 08             	mov    0x8(%ebp),%eax
 19d:	eb 13                	jmp    1b2 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 19f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1a3:	8b 45 08             	mov    0x8(%ebp),%eax
 1a6:	0f b6 00             	movzbl (%eax),%eax
 1a9:	84 c0                	test   %al,%al
 1ab:	75 e2                	jne    18f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1b2:	c9                   	leave  
 1b3:	c3                   	ret    

000001b4 <gets>:

char*
gets(char *buf, int max)
{
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
 1b7:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1c1:	eb 42                	jmp    205 <gets+0x51>
    cc = read(0, &c, 1);
 1c3:	83 ec 04             	sub    $0x4,%esp
 1c6:	6a 01                	push   $0x1
 1c8:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1cb:	50                   	push   %eax
 1cc:	6a 00                	push   $0x0
 1ce:	e8 47 01 00 00       	call   31a <read>
 1d3:	83 c4 10             	add    $0x10,%esp
 1d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1dd:	7e 33                	jle    212 <gets+0x5e>
      break;
    buf[i++] = c;
 1df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e2:	8d 50 01             	lea    0x1(%eax),%edx
 1e5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1e8:	89 c2                	mov    %eax,%edx
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	01 c2                	add    %eax,%edx
 1ef:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f3:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1f5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f9:	3c 0a                	cmp    $0xa,%al
 1fb:	74 16                	je     213 <gets+0x5f>
 1fd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 201:	3c 0d                	cmp    $0xd,%al
 203:	74 0e                	je     213 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 205:	8b 45 f4             	mov    -0xc(%ebp),%eax
 208:	83 c0 01             	add    $0x1,%eax
 20b:	3b 45 0c             	cmp    0xc(%ebp),%eax
 20e:	7c b3                	jl     1c3 <gets+0xf>
 210:	eb 01                	jmp    213 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 212:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 213:	8b 55 f4             	mov    -0xc(%ebp),%edx
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	01 d0                	add    %edx,%eax
 21b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 21e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 221:	c9                   	leave  
 222:	c3                   	ret    

00000223 <stat>:

int
stat(char *n, struct stat *st)
{
 223:	55                   	push   %ebp
 224:	89 e5                	mov    %esp,%ebp
 226:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 229:	83 ec 08             	sub    $0x8,%esp
 22c:	6a 00                	push   $0x0
 22e:	ff 75 08             	pushl  0x8(%ebp)
 231:	e8 0c 01 00 00       	call   342 <open>
 236:	83 c4 10             	add    $0x10,%esp
 239:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 23c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 240:	79 07                	jns    249 <stat+0x26>
    return -1;
 242:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 247:	eb 25                	jmp    26e <stat+0x4b>
  r = fstat(fd, st);
 249:	83 ec 08             	sub    $0x8,%esp
 24c:	ff 75 0c             	pushl  0xc(%ebp)
 24f:	ff 75 f4             	pushl  -0xc(%ebp)
 252:	e8 03 01 00 00       	call   35a <fstat>
 257:	83 c4 10             	add    $0x10,%esp
 25a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 25d:	83 ec 0c             	sub    $0xc,%esp
 260:	ff 75 f4             	pushl  -0xc(%ebp)
 263:	e8 c2 00 00 00       	call   32a <close>
 268:	83 c4 10             	add    $0x10,%esp
  return r;
 26b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 26e:	c9                   	leave  
 26f:	c3                   	ret    

00000270 <atoi>:

int
atoi(const char *s)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 276:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 27d:	eb 25                	jmp    2a4 <atoi+0x34>
    n = n*10 + *s++ - '0';
 27f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 282:	89 d0                	mov    %edx,%eax
 284:	c1 e0 02             	shl    $0x2,%eax
 287:	01 d0                	add    %edx,%eax
 289:	01 c0                	add    %eax,%eax
 28b:	89 c1                	mov    %eax,%ecx
 28d:	8b 45 08             	mov    0x8(%ebp),%eax
 290:	8d 50 01             	lea    0x1(%eax),%edx
 293:	89 55 08             	mov    %edx,0x8(%ebp)
 296:	0f b6 00             	movzbl (%eax),%eax
 299:	0f be c0             	movsbl %al,%eax
 29c:	01 c8                	add    %ecx,%eax
 29e:	83 e8 30             	sub    $0x30,%eax
 2a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a4:	8b 45 08             	mov    0x8(%ebp),%eax
 2a7:	0f b6 00             	movzbl (%eax),%eax
 2aa:	3c 2f                	cmp    $0x2f,%al
 2ac:	7e 0a                	jle    2b8 <atoi+0x48>
 2ae:	8b 45 08             	mov    0x8(%ebp),%eax
 2b1:	0f b6 00             	movzbl (%eax),%eax
 2b4:	3c 39                	cmp    $0x39,%al
 2b6:	7e c7                	jle    27f <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2bb:	c9                   	leave  
 2bc:	c3                   	ret    

000002bd <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2bd:	55                   	push   %ebp
 2be:	89 e5                	mov    %esp,%ebp
 2c0:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2c3:	8b 45 08             	mov    0x8(%ebp),%eax
 2c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2cf:	eb 17                	jmp    2e8 <memmove+0x2b>
    *dst++ = *src++;
 2d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2d4:	8d 50 01             	lea    0x1(%eax),%edx
 2d7:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2da:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2dd:	8d 4a 01             	lea    0x1(%edx),%ecx
 2e0:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2e3:	0f b6 12             	movzbl (%edx),%edx
 2e6:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2e8:	8b 45 10             	mov    0x10(%ebp),%eax
 2eb:	8d 50 ff             	lea    -0x1(%eax),%edx
 2ee:	89 55 10             	mov    %edx,0x10(%ebp)
 2f1:	85 c0                	test   %eax,%eax
 2f3:	7f dc                	jg     2d1 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2f8:	c9                   	leave  
 2f9:	c3                   	ret    

000002fa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2fa:	b8 01 00 00 00       	mov    $0x1,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <exit>:
SYSCALL(exit)
 302:	b8 02 00 00 00       	mov    $0x2,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <wait>:
SYSCALL(wait)
 30a:	b8 03 00 00 00       	mov    $0x3,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <pipe>:
SYSCALL(pipe)
 312:	b8 04 00 00 00       	mov    $0x4,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <read>:
SYSCALL(read)
 31a:	b8 05 00 00 00       	mov    $0x5,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <write>:
SYSCALL(write)
 322:	b8 10 00 00 00       	mov    $0x10,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <close>:
SYSCALL(close)
 32a:	b8 15 00 00 00       	mov    $0x15,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <kill>:
SYSCALL(kill)
 332:	b8 06 00 00 00       	mov    $0x6,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <exec>:
SYSCALL(exec)
 33a:	b8 07 00 00 00       	mov    $0x7,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <open>:
SYSCALL(open)
 342:	b8 0f 00 00 00       	mov    $0xf,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <mknod>:
SYSCALL(mknod)
 34a:	b8 11 00 00 00       	mov    $0x11,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <unlink>:
SYSCALL(unlink)
 352:	b8 12 00 00 00       	mov    $0x12,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <fstat>:
SYSCALL(fstat)
 35a:	b8 08 00 00 00       	mov    $0x8,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <link>:
SYSCALL(link)
 362:	b8 13 00 00 00       	mov    $0x13,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <mkdir>:
SYSCALL(mkdir)
 36a:	b8 14 00 00 00       	mov    $0x14,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <chdir>:
SYSCALL(chdir)
 372:	b8 09 00 00 00       	mov    $0x9,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <dup>:
SYSCALL(dup)
 37a:	b8 0a 00 00 00       	mov    $0xa,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <getpid>:
SYSCALL(getpid)
 382:	b8 0b 00 00 00       	mov    $0xb,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <sbrk>:
SYSCALL(sbrk)
 38a:	b8 0c 00 00 00       	mov    $0xc,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <sleep>:
SYSCALL(sleep)
 392:	b8 0d 00 00 00       	mov    $0xd,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <uptime>:
SYSCALL(uptime)
 39a:	b8 0e 00 00 00       	mov    $0xe,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <halt>:
SYSCALL(halt)
 3a2:	b8 16 00 00 00       	mov    $0x16,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3aa:	55                   	push   %ebp
 3ab:	89 e5                	mov    %esp,%ebp
 3ad:	83 ec 18             	sub    $0x18,%esp
 3b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b3:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3b6:	83 ec 04             	sub    $0x4,%esp
 3b9:	6a 01                	push   $0x1
 3bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3be:	50                   	push   %eax
 3bf:	ff 75 08             	pushl  0x8(%ebp)
 3c2:	e8 5b ff ff ff       	call   322 <write>
 3c7:	83 c4 10             	add    $0x10,%esp
}
 3ca:	90                   	nop
 3cb:	c9                   	leave  
 3cc:	c3                   	ret    

000003cd <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3cd:	55                   	push   %ebp
 3ce:	89 e5                	mov    %esp,%ebp
 3d0:	53                   	push   %ebx
 3d1:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3db:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3df:	74 17                	je     3f8 <printint+0x2b>
 3e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3e5:	79 11                	jns    3f8 <printint+0x2b>
    neg = 1;
 3e7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f1:	f7 d8                	neg    %eax
 3f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f6:	eb 06                	jmp    3fe <printint+0x31>
  } else {
    x = xx;
 3f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 405:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 408:	8d 41 01             	lea    0x1(%ecx),%eax
 40b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 40e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 411:	8b 45 ec             	mov    -0x14(%ebp),%eax
 414:	ba 00 00 00 00       	mov    $0x0,%edx
 419:	f7 f3                	div    %ebx
 41b:	89 d0                	mov    %edx,%eax
 41d:	0f b6 80 b8 0a 00 00 	movzbl 0xab8(%eax),%eax
 424:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 428:	8b 5d 10             	mov    0x10(%ebp),%ebx
 42b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 42e:	ba 00 00 00 00       	mov    $0x0,%edx
 433:	f7 f3                	div    %ebx
 435:	89 45 ec             	mov    %eax,-0x14(%ebp)
 438:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 43c:	75 c7                	jne    405 <printint+0x38>
  if(neg)
 43e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 442:	74 2d                	je     471 <printint+0xa4>
    buf[i++] = '-';
 444:	8b 45 f4             	mov    -0xc(%ebp),%eax
 447:	8d 50 01             	lea    0x1(%eax),%edx
 44a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 44d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 452:	eb 1d                	jmp    471 <printint+0xa4>
    putc(fd, buf[i]);
 454:	8d 55 dc             	lea    -0x24(%ebp),%edx
 457:	8b 45 f4             	mov    -0xc(%ebp),%eax
 45a:	01 d0                	add    %edx,%eax
 45c:	0f b6 00             	movzbl (%eax),%eax
 45f:	0f be c0             	movsbl %al,%eax
 462:	83 ec 08             	sub    $0x8,%esp
 465:	50                   	push   %eax
 466:	ff 75 08             	pushl  0x8(%ebp)
 469:	e8 3c ff ff ff       	call   3aa <putc>
 46e:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 471:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 475:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 479:	79 d9                	jns    454 <printint+0x87>
    putc(fd, buf[i]);
}
 47b:	90                   	nop
 47c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 47f:	c9                   	leave  
 480:	c3                   	ret    

00000481 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 481:	55                   	push   %ebp
 482:	89 e5                	mov    %esp,%ebp
 484:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 487:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 48e:	8d 45 0c             	lea    0xc(%ebp),%eax
 491:	83 c0 04             	add    $0x4,%eax
 494:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 497:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 49e:	e9 59 01 00 00       	jmp    5fc <printf+0x17b>
    c = fmt[i] & 0xff;
 4a3:	8b 55 0c             	mov    0xc(%ebp),%edx
 4a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4a9:	01 d0                	add    %edx,%eax
 4ab:	0f b6 00             	movzbl (%eax),%eax
 4ae:	0f be c0             	movsbl %al,%eax
 4b1:	25 ff 00 00 00       	and    $0xff,%eax
 4b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4bd:	75 2c                	jne    4eb <printf+0x6a>
      if(c == '%'){
 4bf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4c3:	75 0c                	jne    4d1 <printf+0x50>
        state = '%';
 4c5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4cc:	e9 27 01 00 00       	jmp    5f8 <printf+0x177>
      } else {
        putc(fd, c);
 4d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4d4:	0f be c0             	movsbl %al,%eax
 4d7:	83 ec 08             	sub    $0x8,%esp
 4da:	50                   	push   %eax
 4db:	ff 75 08             	pushl  0x8(%ebp)
 4de:	e8 c7 fe ff ff       	call   3aa <putc>
 4e3:	83 c4 10             	add    $0x10,%esp
 4e6:	e9 0d 01 00 00       	jmp    5f8 <printf+0x177>
      }
    } else if(state == '%'){
 4eb:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4ef:	0f 85 03 01 00 00    	jne    5f8 <printf+0x177>
      if(c == 'd'){
 4f5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4f9:	75 1e                	jne    519 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4fe:	8b 00                	mov    (%eax),%eax
 500:	6a 01                	push   $0x1
 502:	6a 0a                	push   $0xa
 504:	50                   	push   %eax
 505:	ff 75 08             	pushl  0x8(%ebp)
 508:	e8 c0 fe ff ff       	call   3cd <printint>
 50d:	83 c4 10             	add    $0x10,%esp
        ap++;
 510:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 514:	e9 d8 00 00 00       	jmp    5f1 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 519:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 51d:	74 06                	je     525 <printf+0xa4>
 51f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 523:	75 1e                	jne    543 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 525:	8b 45 e8             	mov    -0x18(%ebp),%eax
 528:	8b 00                	mov    (%eax),%eax
 52a:	6a 00                	push   $0x0
 52c:	6a 10                	push   $0x10
 52e:	50                   	push   %eax
 52f:	ff 75 08             	pushl  0x8(%ebp)
 532:	e8 96 fe ff ff       	call   3cd <printint>
 537:	83 c4 10             	add    $0x10,%esp
        ap++;
 53a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 53e:	e9 ae 00 00 00       	jmp    5f1 <printf+0x170>
      } else if(c == 's'){
 543:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 547:	75 43                	jne    58c <printf+0x10b>
        s = (char*)*ap;
 549:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54c:	8b 00                	mov    (%eax),%eax
 54e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 551:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 555:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 559:	75 25                	jne    580 <printf+0xff>
          s = "(null)";
 55b:	c7 45 f4 49 08 00 00 	movl   $0x849,-0xc(%ebp)
        while(*s != 0){
 562:	eb 1c                	jmp    580 <printf+0xff>
          putc(fd, *s);
 564:	8b 45 f4             	mov    -0xc(%ebp),%eax
 567:	0f b6 00             	movzbl (%eax),%eax
 56a:	0f be c0             	movsbl %al,%eax
 56d:	83 ec 08             	sub    $0x8,%esp
 570:	50                   	push   %eax
 571:	ff 75 08             	pushl  0x8(%ebp)
 574:	e8 31 fe ff ff       	call   3aa <putc>
 579:	83 c4 10             	add    $0x10,%esp
          s++;
 57c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 580:	8b 45 f4             	mov    -0xc(%ebp),%eax
 583:	0f b6 00             	movzbl (%eax),%eax
 586:	84 c0                	test   %al,%al
 588:	75 da                	jne    564 <printf+0xe3>
 58a:	eb 65                	jmp    5f1 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 58c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 590:	75 1d                	jne    5af <printf+0x12e>
        putc(fd, *ap);
 592:	8b 45 e8             	mov    -0x18(%ebp),%eax
 595:	8b 00                	mov    (%eax),%eax
 597:	0f be c0             	movsbl %al,%eax
 59a:	83 ec 08             	sub    $0x8,%esp
 59d:	50                   	push   %eax
 59e:	ff 75 08             	pushl  0x8(%ebp)
 5a1:	e8 04 fe ff ff       	call   3aa <putc>
 5a6:	83 c4 10             	add    $0x10,%esp
        ap++;
 5a9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ad:	eb 42                	jmp    5f1 <printf+0x170>
      } else if(c == '%'){
 5af:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5b3:	75 17                	jne    5cc <printf+0x14b>
        putc(fd, c);
 5b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b8:	0f be c0             	movsbl %al,%eax
 5bb:	83 ec 08             	sub    $0x8,%esp
 5be:	50                   	push   %eax
 5bf:	ff 75 08             	pushl  0x8(%ebp)
 5c2:	e8 e3 fd ff ff       	call   3aa <putc>
 5c7:	83 c4 10             	add    $0x10,%esp
 5ca:	eb 25                	jmp    5f1 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5cc:	83 ec 08             	sub    $0x8,%esp
 5cf:	6a 25                	push   $0x25
 5d1:	ff 75 08             	pushl  0x8(%ebp)
 5d4:	e8 d1 fd ff ff       	call   3aa <putc>
 5d9:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5df:	0f be c0             	movsbl %al,%eax
 5e2:	83 ec 08             	sub    $0x8,%esp
 5e5:	50                   	push   %eax
 5e6:	ff 75 08             	pushl  0x8(%ebp)
 5e9:	e8 bc fd ff ff       	call   3aa <putc>
 5ee:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5f8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5fc:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 602:	01 d0                	add    %edx,%eax
 604:	0f b6 00             	movzbl (%eax),%eax
 607:	84 c0                	test   %al,%al
 609:	0f 85 94 fe ff ff    	jne    4a3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 60f:	90                   	nop
 610:	c9                   	leave  
 611:	c3                   	ret    

00000612 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 612:	55                   	push   %ebp
 613:	89 e5                	mov    %esp,%ebp
 615:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 618:	8b 45 08             	mov    0x8(%ebp),%eax
 61b:	83 e8 08             	sub    $0x8,%eax
 61e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 621:	a1 d4 0a 00 00       	mov    0xad4,%eax
 626:	89 45 fc             	mov    %eax,-0x4(%ebp)
 629:	eb 24                	jmp    64f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 62b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62e:	8b 00                	mov    (%eax),%eax
 630:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 633:	77 12                	ja     647 <free+0x35>
 635:	8b 45 f8             	mov    -0x8(%ebp),%eax
 638:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63b:	77 24                	ja     661 <free+0x4f>
 63d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 640:	8b 00                	mov    (%eax),%eax
 642:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 645:	77 1a                	ja     661 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 647:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64a:	8b 00                	mov    (%eax),%eax
 64c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 64f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 652:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 655:	76 d4                	jbe    62b <free+0x19>
 657:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65a:	8b 00                	mov    (%eax),%eax
 65c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 65f:	76 ca                	jbe    62b <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 661:	8b 45 f8             	mov    -0x8(%ebp),%eax
 664:	8b 40 04             	mov    0x4(%eax),%eax
 667:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 66e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 671:	01 c2                	add    %eax,%edx
 673:	8b 45 fc             	mov    -0x4(%ebp),%eax
 676:	8b 00                	mov    (%eax),%eax
 678:	39 c2                	cmp    %eax,%edx
 67a:	75 24                	jne    6a0 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 67c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67f:	8b 50 04             	mov    0x4(%eax),%edx
 682:	8b 45 fc             	mov    -0x4(%ebp),%eax
 685:	8b 00                	mov    (%eax),%eax
 687:	8b 40 04             	mov    0x4(%eax),%eax
 68a:	01 c2                	add    %eax,%edx
 68c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 692:	8b 45 fc             	mov    -0x4(%ebp),%eax
 695:	8b 00                	mov    (%eax),%eax
 697:	8b 10                	mov    (%eax),%edx
 699:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69c:	89 10                	mov    %edx,(%eax)
 69e:	eb 0a                	jmp    6aa <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a3:	8b 10                	mov    (%eax),%edx
 6a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a8:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ad:	8b 40 04             	mov    0x4(%eax),%eax
 6b0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ba:	01 d0                	add    %edx,%eax
 6bc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6bf:	75 20                	jne    6e1 <free+0xcf>
    p->s.size += bp->s.size;
 6c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c4:	8b 50 04             	mov    0x4(%eax),%edx
 6c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ca:	8b 40 04             	mov    0x4(%eax),%eax
 6cd:	01 c2                	add    %eax,%edx
 6cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d8:	8b 10                	mov    (%eax),%edx
 6da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dd:	89 10                	mov    %edx,(%eax)
 6df:	eb 08                	jmp    6e9 <free+0xd7>
  } else
    p->s.ptr = bp;
 6e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6e7:	89 10                	mov    %edx,(%eax)
  freep = p;
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	a3 d4 0a 00 00       	mov    %eax,0xad4
}
 6f1:	90                   	nop
 6f2:	c9                   	leave  
 6f3:	c3                   	ret    

000006f4 <morecore>:

static Header*
morecore(uint nu)
{
 6f4:	55                   	push   %ebp
 6f5:	89 e5                	mov    %esp,%ebp
 6f7:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6fa:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 701:	77 07                	ja     70a <morecore+0x16>
    nu = 4096;
 703:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 70a:	8b 45 08             	mov    0x8(%ebp),%eax
 70d:	c1 e0 03             	shl    $0x3,%eax
 710:	83 ec 0c             	sub    $0xc,%esp
 713:	50                   	push   %eax
 714:	e8 71 fc ff ff       	call   38a <sbrk>
 719:	83 c4 10             	add    $0x10,%esp
 71c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 71f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 723:	75 07                	jne    72c <morecore+0x38>
    return 0;
 725:	b8 00 00 00 00       	mov    $0x0,%eax
 72a:	eb 26                	jmp    752 <morecore+0x5e>
  hp = (Header*)p;
 72c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 732:	8b 45 f0             	mov    -0x10(%ebp),%eax
 735:	8b 55 08             	mov    0x8(%ebp),%edx
 738:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 73b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73e:	83 c0 08             	add    $0x8,%eax
 741:	83 ec 0c             	sub    $0xc,%esp
 744:	50                   	push   %eax
 745:	e8 c8 fe ff ff       	call   612 <free>
 74a:	83 c4 10             	add    $0x10,%esp
  return freep;
 74d:	a1 d4 0a 00 00       	mov    0xad4,%eax
}
 752:	c9                   	leave  
 753:	c3                   	ret    

00000754 <malloc>:

void*
malloc(uint nbytes)
{
 754:	55                   	push   %ebp
 755:	89 e5                	mov    %esp,%ebp
 757:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 75a:	8b 45 08             	mov    0x8(%ebp),%eax
 75d:	83 c0 07             	add    $0x7,%eax
 760:	c1 e8 03             	shr    $0x3,%eax
 763:	83 c0 01             	add    $0x1,%eax
 766:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 769:	a1 d4 0a 00 00       	mov    0xad4,%eax
 76e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 771:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 775:	75 23                	jne    79a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 777:	c7 45 f0 cc 0a 00 00 	movl   $0xacc,-0x10(%ebp)
 77e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 781:	a3 d4 0a 00 00       	mov    %eax,0xad4
 786:	a1 d4 0a 00 00       	mov    0xad4,%eax
 78b:	a3 cc 0a 00 00       	mov    %eax,0xacc
    base.s.size = 0;
 790:	c7 05 d0 0a 00 00 00 	movl   $0x0,0xad0
 797:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79d:	8b 00                	mov    (%eax),%eax
 79f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a5:	8b 40 04             	mov    0x4(%eax),%eax
 7a8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ab:	72 4d                	jb     7fa <malloc+0xa6>
      if(p->s.size == nunits)
 7ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b0:	8b 40 04             	mov    0x4(%eax),%eax
 7b3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b6:	75 0c                	jne    7c4 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bb:	8b 10                	mov    (%eax),%edx
 7bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c0:	89 10                	mov    %edx,(%eax)
 7c2:	eb 26                	jmp    7ea <malloc+0x96>
      else {
        p->s.size -= nunits;
 7c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c7:	8b 40 04             	mov    0x4(%eax),%eax
 7ca:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7cd:	89 c2                	mov    %eax,%edx
 7cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d8:	8b 40 04             	mov    0x4(%eax),%eax
 7db:	c1 e0 03             	shl    $0x3,%eax
 7de:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7e7:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ed:	a3 d4 0a 00 00       	mov    %eax,0xad4
      return (void*)(p + 1);
 7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f5:	83 c0 08             	add    $0x8,%eax
 7f8:	eb 3b                	jmp    835 <malloc+0xe1>
    }
    if(p == freep)
 7fa:	a1 d4 0a 00 00       	mov    0xad4,%eax
 7ff:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 802:	75 1e                	jne    822 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 804:	83 ec 0c             	sub    $0xc,%esp
 807:	ff 75 ec             	pushl  -0x14(%ebp)
 80a:	e8 e5 fe ff ff       	call   6f4 <morecore>
 80f:	83 c4 10             	add    $0x10,%esp
 812:	89 45 f4             	mov    %eax,-0xc(%ebp)
 815:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 819:	75 07                	jne    822 <malloc+0xce>
        return 0;
 81b:	b8 00 00 00 00       	mov    $0x0,%eax
 820:	eb 13                	jmp    835 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 822:	8b 45 f4             	mov    -0xc(%ebp),%eax
 825:	89 45 f0             	mov    %eax,-0x10(%ebp)
 828:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82b:	8b 00                	mov    (%eax),%eax
 82d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 830:	e9 6d ff ff ff       	jmp    7a2 <malloc+0x4e>
}
 835:	c9                   	leave  
 836:	c3                   	ret    
