
_halt:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(void){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
	return halt();
  11:	e8 f7 02 00 00       	call   30d <halt>

00000016 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  16:	55                   	push   %ebp
  17:	89 e5                	mov    %esp,%ebp
  19:	57                   	push   %edi
  1a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1e:	8b 55 10             	mov    0x10(%ebp),%edx
  21:	8b 45 0c             	mov    0xc(%ebp),%eax
  24:	89 cb                	mov    %ecx,%ebx
  26:	89 df                	mov    %ebx,%edi
  28:	89 d1                	mov    %edx,%ecx
  2a:	fc                   	cld    
  2b:	f3 aa                	rep stos %al,%es:(%edi)
  2d:	89 ca                	mov    %ecx,%edx
  2f:	89 fb                	mov    %edi,%ebx
  31:	89 5d 08             	mov    %ebx,0x8(%ebp)
  34:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  37:	90                   	nop
  38:	5b                   	pop    %ebx
  39:	5f                   	pop    %edi
  3a:	5d                   	pop    %ebp
  3b:	c3                   	ret    

0000003c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  3c:	55                   	push   %ebp
  3d:	89 e5                	mov    %esp,%ebp
  3f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  42:	8b 45 08             	mov    0x8(%ebp),%eax
  45:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  48:	90                   	nop
  49:	8b 45 08             	mov    0x8(%ebp),%eax
  4c:	8d 50 01             	lea    0x1(%eax),%edx
  4f:	89 55 08             	mov    %edx,0x8(%ebp)
  52:	8b 55 0c             	mov    0xc(%ebp),%edx
  55:	8d 4a 01             	lea    0x1(%edx),%ecx
  58:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  5b:	0f b6 12             	movzbl (%edx),%edx
  5e:	88 10                	mov    %dl,(%eax)
  60:	0f b6 00             	movzbl (%eax),%eax
  63:	84 c0                	test   %al,%al
  65:	75 e2                	jne    49 <strcpy+0xd>
    ;
  return os;
  67:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  6a:	c9                   	leave  
  6b:	c3                   	ret    

0000006c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  6f:	eb 08                	jmp    79 <strcmp+0xd>
    p++, q++;
  71:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  75:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  79:	8b 45 08             	mov    0x8(%ebp),%eax
  7c:	0f b6 00             	movzbl (%eax),%eax
  7f:	84 c0                	test   %al,%al
  81:	74 10                	je     93 <strcmp+0x27>
  83:	8b 45 08             	mov    0x8(%ebp),%eax
  86:	0f b6 10             	movzbl (%eax),%edx
  89:	8b 45 0c             	mov    0xc(%ebp),%eax
  8c:	0f b6 00             	movzbl (%eax),%eax
  8f:	38 c2                	cmp    %al,%dl
  91:	74 de                	je     71 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  93:	8b 45 08             	mov    0x8(%ebp),%eax
  96:	0f b6 00             	movzbl (%eax),%eax
  99:	0f b6 d0             	movzbl %al,%edx
  9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  9f:	0f b6 00             	movzbl (%eax),%eax
  a2:	0f b6 c0             	movzbl %al,%eax
  a5:	29 c2                	sub    %eax,%edx
  a7:	89 d0                	mov    %edx,%eax
}
  a9:	5d                   	pop    %ebp
  aa:	c3                   	ret    

000000ab <strlen>:

uint
strlen(char *s)
{
  ab:	55                   	push   %ebp
  ac:	89 e5                	mov    %esp,%ebp
  ae:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  b8:	eb 04                	jmp    be <strlen+0x13>
  ba:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  c1:	8b 45 08             	mov    0x8(%ebp),%eax
  c4:	01 d0                	add    %edx,%eax
  c6:	0f b6 00             	movzbl (%eax),%eax
  c9:	84 c0                	test   %al,%al
  cb:	75 ed                	jne    ba <strlen+0xf>
    ;
  return n;
  cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d0:	c9                   	leave  
  d1:	c3                   	ret    

000000d2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d2:	55                   	push   %ebp
  d3:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  d5:	8b 45 10             	mov    0x10(%ebp),%eax
  d8:	50                   	push   %eax
  d9:	ff 75 0c             	pushl  0xc(%ebp)
  dc:	ff 75 08             	pushl  0x8(%ebp)
  df:	e8 32 ff ff ff       	call   16 <stosb>
  e4:	83 c4 0c             	add    $0xc,%esp
  return dst;
  e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  ea:	c9                   	leave  
  eb:	c3                   	ret    

000000ec <strchr>:

char*
strchr(const char *s, char c)
{
  ec:	55                   	push   %ebp
  ed:	89 e5                	mov    %esp,%ebp
  ef:	83 ec 04             	sub    $0x4,%esp
  f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  f5:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
  f8:	eb 14                	jmp    10e <strchr+0x22>
    if(*s == c)
  fa:	8b 45 08             	mov    0x8(%ebp),%eax
  fd:	0f b6 00             	movzbl (%eax),%eax
 100:	3a 45 fc             	cmp    -0x4(%ebp),%al
 103:	75 05                	jne    10a <strchr+0x1e>
      return (char*)s;
 105:	8b 45 08             	mov    0x8(%ebp),%eax
 108:	eb 13                	jmp    11d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 10a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 10e:	8b 45 08             	mov    0x8(%ebp),%eax
 111:	0f b6 00             	movzbl (%eax),%eax
 114:	84 c0                	test   %al,%al
 116:	75 e2                	jne    fa <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 118:	b8 00 00 00 00       	mov    $0x0,%eax
}
 11d:	c9                   	leave  
 11e:	c3                   	ret    

0000011f <gets>:

char*
gets(char *buf, int max)
{
 11f:	55                   	push   %ebp
 120:	89 e5                	mov    %esp,%ebp
 122:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 125:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 12c:	eb 42                	jmp    170 <gets+0x51>
    cc = read(0, &c, 1);
 12e:	83 ec 04             	sub    $0x4,%esp
 131:	6a 01                	push   $0x1
 133:	8d 45 ef             	lea    -0x11(%ebp),%eax
 136:	50                   	push   %eax
 137:	6a 00                	push   $0x0
 139:	e8 47 01 00 00       	call   285 <read>
 13e:	83 c4 10             	add    $0x10,%esp
 141:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 144:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 148:	7e 33                	jle    17d <gets+0x5e>
      break;
    buf[i++] = c;
 14a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 14d:	8d 50 01             	lea    0x1(%eax),%edx
 150:	89 55 f4             	mov    %edx,-0xc(%ebp)
 153:	89 c2                	mov    %eax,%edx
 155:	8b 45 08             	mov    0x8(%ebp),%eax
 158:	01 c2                	add    %eax,%edx
 15a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 15e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 160:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 164:	3c 0a                	cmp    $0xa,%al
 166:	74 16                	je     17e <gets+0x5f>
 168:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 16c:	3c 0d                	cmp    $0xd,%al
 16e:	74 0e                	je     17e <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 170:	8b 45 f4             	mov    -0xc(%ebp),%eax
 173:	83 c0 01             	add    $0x1,%eax
 176:	3b 45 0c             	cmp    0xc(%ebp),%eax
 179:	7c b3                	jl     12e <gets+0xf>
 17b:	eb 01                	jmp    17e <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 17d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 17e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 181:	8b 45 08             	mov    0x8(%ebp),%eax
 184:	01 d0                	add    %edx,%eax
 186:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 189:	8b 45 08             	mov    0x8(%ebp),%eax
}
 18c:	c9                   	leave  
 18d:	c3                   	ret    

0000018e <stat>:

int
stat(char *n, struct stat *st)
{
 18e:	55                   	push   %ebp
 18f:	89 e5                	mov    %esp,%ebp
 191:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 194:	83 ec 08             	sub    $0x8,%esp
 197:	6a 00                	push   $0x0
 199:	ff 75 08             	pushl  0x8(%ebp)
 19c:	e8 0c 01 00 00       	call   2ad <open>
 1a1:	83 c4 10             	add    $0x10,%esp
 1a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1ab:	79 07                	jns    1b4 <stat+0x26>
    return -1;
 1ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1b2:	eb 25                	jmp    1d9 <stat+0x4b>
  r = fstat(fd, st);
 1b4:	83 ec 08             	sub    $0x8,%esp
 1b7:	ff 75 0c             	pushl  0xc(%ebp)
 1ba:	ff 75 f4             	pushl  -0xc(%ebp)
 1bd:	e8 03 01 00 00       	call   2c5 <fstat>
 1c2:	83 c4 10             	add    $0x10,%esp
 1c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1c8:	83 ec 0c             	sub    $0xc,%esp
 1cb:	ff 75 f4             	pushl  -0xc(%ebp)
 1ce:	e8 c2 00 00 00       	call   295 <close>
 1d3:	83 c4 10             	add    $0x10,%esp
  return r;
 1d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1d9:	c9                   	leave  
 1da:	c3                   	ret    

000001db <atoi>:

int
atoi(const char *s)
{
 1db:	55                   	push   %ebp
 1dc:	89 e5                	mov    %esp,%ebp
 1de:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1e8:	eb 25                	jmp    20f <atoi+0x34>
    n = n*10 + *s++ - '0';
 1ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ed:	89 d0                	mov    %edx,%eax
 1ef:	c1 e0 02             	shl    $0x2,%eax
 1f2:	01 d0                	add    %edx,%eax
 1f4:	01 c0                	add    %eax,%eax
 1f6:	89 c1                	mov    %eax,%ecx
 1f8:	8b 45 08             	mov    0x8(%ebp),%eax
 1fb:	8d 50 01             	lea    0x1(%eax),%edx
 1fe:	89 55 08             	mov    %edx,0x8(%ebp)
 201:	0f b6 00             	movzbl (%eax),%eax
 204:	0f be c0             	movsbl %al,%eax
 207:	01 c8                	add    %ecx,%eax
 209:	83 e8 30             	sub    $0x30,%eax
 20c:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	0f b6 00             	movzbl (%eax),%eax
 215:	3c 2f                	cmp    $0x2f,%al
 217:	7e 0a                	jle    223 <atoi+0x48>
 219:	8b 45 08             	mov    0x8(%ebp),%eax
 21c:	0f b6 00             	movzbl (%eax),%eax
 21f:	3c 39                	cmp    $0x39,%al
 221:	7e c7                	jle    1ea <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 223:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 226:	c9                   	leave  
 227:	c3                   	ret    

00000228 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 228:	55                   	push   %ebp
 229:	89 e5                	mov    %esp,%ebp
 22b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 22e:	8b 45 08             	mov    0x8(%ebp),%eax
 231:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 234:	8b 45 0c             	mov    0xc(%ebp),%eax
 237:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 23a:	eb 17                	jmp    253 <memmove+0x2b>
    *dst++ = *src++;
 23c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 23f:	8d 50 01             	lea    0x1(%eax),%edx
 242:	89 55 fc             	mov    %edx,-0x4(%ebp)
 245:	8b 55 f8             	mov    -0x8(%ebp),%edx
 248:	8d 4a 01             	lea    0x1(%edx),%ecx
 24b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 24e:	0f b6 12             	movzbl (%edx),%edx
 251:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 253:	8b 45 10             	mov    0x10(%ebp),%eax
 256:	8d 50 ff             	lea    -0x1(%eax),%edx
 259:	89 55 10             	mov    %edx,0x10(%ebp)
 25c:	85 c0                	test   %eax,%eax
 25e:	7f dc                	jg     23c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 260:	8b 45 08             	mov    0x8(%ebp),%eax
}
 263:	c9                   	leave  
 264:	c3                   	ret    

00000265 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 265:	b8 01 00 00 00       	mov    $0x1,%eax
 26a:	cd 40                	int    $0x40
 26c:	c3                   	ret    

0000026d <exit>:
SYSCALL(exit)
 26d:	b8 02 00 00 00       	mov    $0x2,%eax
 272:	cd 40                	int    $0x40
 274:	c3                   	ret    

00000275 <wait>:
SYSCALL(wait)
 275:	b8 03 00 00 00       	mov    $0x3,%eax
 27a:	cd 40                	int    $0x40
 27c:	c3                   	ret    

0000027d <pipe>:
SYSCALL(pipe)
 27d:	b8 04 00 00 00       	mov    $0x4,%eax
 282:	cd 40                	int    $0x40
 284:	c3                   	ret    

00000285 <read>:
SYSCALL(read)
 285:	b8 05 00 00 00       	mov    $0x5,%eax
 28a:	cd 40                	int    $0x40
 28c:	c3                   	ret    

0000028d <write>:
SYSCALL(write)
 28d:	b8 10 00 00 00       	mov    $0x10,%eax
 292:	cd 40                	int    $0x40
 294:	c3                   	ret    

00000295 <close>:
SYSCALL(close)
 295:	b8 15 00 00 00       	mov    $0x15,%eax
 29a:	cd 40                	int    $0x40
 29c:	c3                   	ret    

0000029d <kill>:
SYSCALL(kill)
 29d:	b8 06 00 00 00       	mov    $0x6,%eax
 2a2:	cd 40                	int    $0x40
 2a4:	c3                   	ret    

000002a5 <exec>:
SYSCALL(exec)
 2a5:	b8 07 00 00 00       	mov    $0x7,%eax
 2aa:	cd 40                	int    $0x40
 2ac:	c3                   	ret    

000002ad <open>:
SYSCALL(open)
 2ad:	b8 0f 00 00 00       	mov    $0xf,%eax
 2b2:	cd 40                	int    $0x40
 2b4:	c3                   	ret    

000002b5 <mknod>:
SYSCALL(mknod)
 2b5:	b8 11 00 00 00       	mov    $0x11,%eax
 2ba:	cd 40                	int    $0x40
 2bc:	c3                   	ret    

000002bd <unlink>:
SYSCALL(unlink)
 2bd:	b8 12 00 00 00       	mov    $0x12,%eax
 2c2:	cd 40                	int    $0x40
 2c4:	c3                   	ret    

000002c5 <fstat>:
SYSCALL(fstat)
 2c5:	b8 08 00 00 00       	mov    $0x8,%eax
 2ca:	cd 40                	int    $0x40
 2cc:	c3                   	ret    

000002cd <link>:
SYSCALL(link)
 2cd:	b8 13 00 00 00       	mov    $0x13,%eax
 2d2:	cd 40                	int    $0x40
 2d4:	c3                   	ret    

000002d5 <mkdir>:
SYSCALL(mkdir)
 2d5:	b8 14 00 00 00       	mov    $0x14,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <chdir>:
SYSCALL(chdir)
 2dd:	b8 09 00 00 00       	mov    $0x9,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <dup>:
SYSCALL(dup)
 2e5:	b8 0a 00 00 00       	mov    $0xa,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <getpid>:
SYSCALL(getpid)
 2ed:	b8 0b 00 00 00       	mov    $0xb,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <sbrk>:
SYSCALL(sbrk)
 2f5:	b8 0c 00 00 00       	mov    $0xc,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <sleep>:
SYSCALL(sleep)
 2fd:	b8 0d 00 00 00       	mov    $0xd,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <uptime>:
SYSCALL(uptime)
 305:	b8 0e 00 00 00       	mov    $0xe,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <halt>:
SYSCALL(halt)
 30d:	b8 16 00 00 00       	mov    $0x16,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 315:	55                   	push   %ebp
 316:	89 e5                	mov    %esp,%ebp
 318:	83 ec 18             	sub    $0x18,%esp
 31b:	8b 45 0c             	mov    0xc(%ebp),%eax
 31e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 321:	83 ec 04             	sub    $0x4,%esp
 324:	6a 01                	push   $0x1
 326:	8d 45 f4             	lea    -0xc(%ebp),%eax
 329:	50                   	push   %eax
 32a:	ff 75 08             	pushl  0x8(%ebp)
 32d:	e8 5b ff ff ff       	call   28d <write>
 332:	83 c4 10             	add    $0x10,%esp
}
 335:	90                   	nop
 336:	c9                   	leave  
 337:	c3                   	ret    

00000338 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 338:	55                   	push   %ebp
 339:	89 e5                	mov    %esp,%ebp
 33b:	53                   	push   %ebx
 33c:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 33f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 346:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 34a:	74 17                	je     363 <printint+0x2b>
 34c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 350:	79 11                	jns    363 <printint+0x2b>
    neg = 1;
 352:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 359:	8b 45 0c             	mov    0xc(%ebp),%eax
 35c:	f7 d8                	neg    %eax
 35e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 361:	eb 06                	jmp    369 <printint+0x31>
  } else {
    x = xx;
 363:	8b 45 0c             	mov    0xc(%ebp),%eax
 366:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 369:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 370:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 373:	8d 41 01             	lea    0x1(%ecx),%eax
 376:	89 45 f4             	mov    %eax,-0xc(%ebp)
 379:	8b 5d 10             	mov    0x10(%ebp),%ebx
 37c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 37f:	ba 00 00 00 00       	mov    $0x0,%edx
 384:	f7 f3                	div    %ebx
 386:	89 d0                	mov    %edx,%eax
 388:	0f b6 80 f4 09 00 00 	movzbl 0x9f4(%eax),%eax
 38f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 393:	8b 5d 10             	mov    0x10(%ebp),%ebx
 396:	8b 45 ec             	mov    -0x14(%ebp),%eax
 399:	ba 00 00 00 00       	mov    $0x0,%edx
 39e:	f7 f3                	div    %ebx
 3a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3a7:	75 c7                	jne    370 <printint+0x38>
  if(neg)
 3a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3ad:	74 2d                	je     3dc <printint+0xa4>
    buf[i++] = '-';
 3af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3b2:	8d 50 01             	lea    0x1(%eax),%edx
 3b5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3b8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3bd:	eb 1d                	jmp    3dc <printint+0xa4>
    putc(fd, buf[i]);
 3bf:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3c5:	01 d0                	add    %edx,%eax
 3c7:	0f b6 00             	movzbl (%eax),%eax
 3ca:	0f be c0             	movsbl %al,%eax
 3cd:	83 ec 08             	sub    $0x8,%esp
 3d0:	50                   	push   %eax
 3d1:	ff 75 08             	pushl  0x8(%ebp)
 3d4:	e8 3c ff ff ff       	call   315 <putc>
 3d9:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3dc:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 3e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3e4:	79 d9                	jns    3bf <printint+0x87>
    putc(fd, buf[i]);
}
 3e6:	90                   	nop
 3e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3ea:	c9                   	leave  
 3eb:	c3                   	ret    

000003ec <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3ec:	55                   	push   %ebp
 3ed:	89 e5                	mov    %esp,%ebp
 3ef:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 3f2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 3f9:	8d 45 0c             	lea    0xc(%ebp),%eax
 3fc:	83 c0 04             	add    $0x4,%eax
 3ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 402:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 409:	e9 59 01 00 00       	jmp    567 <printf+0x17b>
    c = fmt[i] & 0xff;
 40e:	8b 55 0c             	mov    0xc(%ebp),%edx
 411:	8b 45 f0             	mov    -0x10(%ebp),%eax
 414:	01 d0                	add    %edx,%eax
 416:	0f b6 00             	movzbl (%eax),%eax
 419:	0f be c0             	movsbl %al,%eax
 41c:	25 ff 00 00 00       	and    $0xff,%eax
 421:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 424:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 428:	75 2c                	jne    456 <printf+0x6a>
      if(c == '%'){
 42a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 42e:	75 0c                	jne    43c <printf+0x50>
        state = '%';
 430:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 437:	e9 27 01 00 00       	jmp    563 <printf+0x177>
      } else {
        putc(fd, c);
 43c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 43f:	0f be c0             	movsbl %al,%eax
 442:	83 ec 08             	sub    $0x8,%esp
 445:	50                   	push   %eax
 446:	ff 75 08             	pushl  0x8(%ebp)
 449:	e8 c7 fe ff ff       	call   315 <putc>
 44e:	83 c4 10             	add    $0x10,%esp
 451:	e9 0d 01 00 00       	jmp    563 <printf+0x177>
      }
    } else if(state == '%'){
 456:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 45a:	0f 85 03 01 00 00    	jne    563 <printf+0x177>
      if(c == 'd'){
 460:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 464:	75 1e                	jne    484 <printf+0x98>
        printint(fd, *ap, 10, 1);
 466:	8b 45 e8             	mov    -0x18(%ebp),%eax
 469:	8b 00                	mov    (%eax),%eax
 46b:	6a 01                	push   $0x1
 46d:	6a 0a                	push   $0xa
 46f:	50                   	push   %eax
 470:	ff 75 08             	pushl  0x8(%ebp)
 473:	e8 c0 fe ff ff       	call   338 <printint>
 478:	83 c4 10             	add    $0x10,%esp
        ap++;
 47b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 47f:	e9 d8 00 00 00       	jmp    55c <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 484:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 488:	74 06                	je     490 <printf+0xa4>
 48a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 48e:	75 1e                	jne    4ae <printf+0xc2>
        printint(fd, *ap, 16, 0);
 490:	8b 45 e8             	mov    -0x18(%ebp),%eax
 493:	8b 00                	mov    (%eax),%eax
 495:	6a 00                	push   $0x0
 497:	6a 10                	push   $0x10
 499:	50                   	push   %eax
 49a:	ff 75 08             	pushl  0x8(%ebp)
 49d:	e8 96 fe ff ff       	call   338 <printint>
 4a2:	83 c4 10             	add    $0x10,%esp
        ap++;
 4a5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4a9:	e9 ae 00 00 00       	jmp    55c <printf+0x170>
      } else if(c == 's'){
 4ae:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4b2:	75 43                	jne    4f7 <printf+0x10b>
        s = (char*)*ap;
 4b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b7:	8b 00                	mov    (%eax),%eax
 4b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4bc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4c4:	75 25                	jne    4eb <printf+0xff>
          s = "(null)";
 4c6:	c7 45 f4 a2 07 00 00 	movl   $0x7a2,-0xc(%ebp)
        while(*s != 0){
 4cd:	eb 1c                	jmp    4eb <printf+0xff>
          putc(fd, *s);
 4cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d2:	0f b6 00             	movzbl (%eax),%eax
 4d5:	0f be c0             	movsbl %al,%eax
 4d8:	83 ec 08             	sub    $0x8,%esp
 4db:	50                   	push   %eax
 4dc:	ff 75 08             	pushl  0x8(%ebp)
 4df:	e8 31 fe ff ff       	call   315 <putc>
 4e4:	83 c4 10             	add    $0x10,%esp
          s++;
 4e7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ee:	0f b6 00             	movzbl (%eax),%eax
 4f1:	84 c0                	test   %al,%al
 4f3:	75 da                	jne    4cf <printf+0xe3>
 4f5:	eb 65                	jmp    55c <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4f7:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 4fb:	75 1d                	jne    51a <printf+0x12e>
        putc(fd, *ap);
 4fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 500:	8b 00                	mov    (%eax),%eax
 502:	0f be c0             	movsbl %al,%eax
 505:	83 ec 08             	sub    $0x8,%esp
 508:	50                   	push   %eax
 509:	ff 75 08             	pushl  0x8(%ebp)
 50c:	e8 04 fe ff ff       	call   315 <putc>
 511:	83 c4 10             	add    $0x10,%esp
        ap++;
 514:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 518:	eb 42                	jmp    55c <printf+0x170>
      } else if(c == '%'){
 51a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 51e:	75 17                	jne    537 <printf+0x14b>
        putc(fd, c);
 520:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 523:	0f be c0             	movsbl %al,%eax
 526:	83 ec 08             	sub    $0x8,%esp
 529:	50                   	push   %eax
 52a:	ff 75 08             	pushl  0x8(%ebp)
 52d:	e8 e3 fd ff ff       	call   315 <putc>
 532:	83 c4 10             	add    $0x10,%esp
 535:	eb 25                	jmp    55c <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 537:	83 ec 08             	sub    $0x8,%esp
 53a:	6a 25                	push   $0x25
 53c:	ff 75 08             	pushl  0x8(%ebp)
 53f:	e8 d1 fd ff ff       	call   315 <putc>
 544:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 547:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 54a:	0f be c0             	movsbl %al,%eax
 54d:	83 ec 08             	sub    $0x8,%esp
 550:	50                   	push   %eax
 551:	ff 75 08             	pushl  0x8(%ebp)
 554:	e8 bc fd ff ff       	call   315 <putc>
 559:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 55c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 563:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 567:	8b 55 0c             	mov    0xc(%ebp),%edx
 56a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 56d:	01 d0                	add    %edx,%eax
 56f:	0f b6 00             	movzbl (%eax),%eax
 572:	84 c0                	test   %al,%al
 574:	0f 85 94 fe ff ff    	jne    40e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 57a:	90                   	nop
 57b:	c9                   	leave  
 57c:	c3                   	ret    

0000057d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 57d:	55                   	push   %ebp
 57e:	89 e5                	mov    %esp,%ebp
 580:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 583:	8b 45 08             	mov    0x8(%ebp),%eax
 586:	83 e8 08             	sub    $0x8,%eax
 589:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 58c:	a1 10 0a 00 00       	mov    0xa10,%eax
 591:	89 45 fc             	mov    %eax,-0x4(%ebp)
 594:	eb 24                	jmp    5ba <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 596:	8b 45 fc             	mov    -0x4(%ebp),%eax
 599:	8b 00                	mov    (%eax),%eax
 59b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 59e:	77 12                	ja     5b2 <free+0x35>
 5a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5a3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5a6:	77 24                	ja     5cc <free+0x4f>
 5a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ab:	8b 00                	mov    (%eax),%eax
 5ad:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5b0:	77 1a                	ja     5cc <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5b5:	8b 00                	mov    (%eax),%eax
 5b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5bd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5c0:	76 d4                	jbe    596 <free+0x19>
 5c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5c5:	8b 00                	mov    (%eax),%eax
 5c7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5ca:	76 ca                	jbe    596 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5cf:	8b 40 04             	mov    0x4(%eax),%eax
 5d2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 5d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5dc:	01 c2                	add    %eax,%edx
 5de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e1:	8b 00                	mov    (%eax),%eax
 5e3:	39 c2                	cmp    %eax,%edx
 5e5:	75 24                	jne    60b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 5e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5ea:	8b 50 04             	mov    0x4(%eax),%edx
 5ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f0:	8b 00                	mov    (%eax),%eax
 5f2:	8b 40 04             	mov    0x4(%eax),%eax
 5f5:	01 c2                	add    %eax,%edx
 5f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5fa:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 5fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 600:	8b 00                	mov    (%eax),%eax
 602:	8b 10                	mov    (%eax),%edx
 604:	8b 45 f8             	mov    -0x8(%ebp),%eax
 607:	89 10                	mov    %edx,(%eax)
 609:	eb 0a                	jmp    615 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 60b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60e:	8b 10                	mov    (%eax),%edx
 610:	8b 45 f8             	mov    -0x8(%ebp),%eax
 613:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 615:	8b 45 fc             	mov    -0x4(%ebp),%eax
 618:	8b 40 04             	mov    0x4(%eax),%eax
 61b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 622:	8b 45 fc             	mov    -0x4(%ebp),%eax
 625:	01 d0                	add    %edx,%eax
 627:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 62a:	75 20                	jne    64c <free+0xcf>
    p->s.size += bp->s.size;
 62c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62f:	8b 50 04             	mov    0x4(%eax),%edx
 632:	8b 45 f8             	mov    -0x8(%ebp),%eax
 635:	8b 40 04             	mov    0x4(%eax),%eax
 638:	01 c2                	add    %eax,%edx
 63a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 640:	8b 45 f8             	mov    -0x8(%ebp),%eax
 643:	8b 10                	mov    (%eax),%edx
 645:	8b 45 fc             	mov    -0x4(%ebp),%eax
 648:	89 10                	mov    %edx,(%eax)
 64a:	eb 08                	jmp    654 <free+0xd7>
  } else
    p->s.ptr = bp;
 64c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 652:	89 10                	mov    %edx,(%eax)
  freep = p;
 654:	8b 45 fc             	mov    -0x4(%ebp),%eax
 657:	a3 10 0a 00 00       	mov    %eax,0xa10
}
 65c:	90                   	nop
 65d:	c9                   	leave  
 65e:	c3                   	ret    

0000065f <morecore>:

static Header*
morecore(uint nu)
{
 65f:	55                   	push   %ebp
 660:	89 e5                	mov    %esp,%ebp
 662:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 665:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 66c:	77 07                	ja     675 <morecore+0x16>
    nu = 4096;
 66e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 675:	8b 45 08             	mov    0x8(%ebp),%eax
 678:	c1 e0 03             	shl    $0x3,%eax
 67b:	83 ec 0c             	sub    $0xc,%esp
 67e:	50                   	push   %eax
 67f:	e8 71 fc ff ff       	call   2f5 <sbrk>
 684:	83 c4 10             	add    $0x10,%esp
 687:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 68a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 68e:	75 07                	jne    697 <morecore+0x38>
    return 0;
 690:	b8 00 00 00 00       	mov    $0x0,%eax
 695:	eb 26                	jmp    6bd <morecore+0x5e>
  hp = (Header*)p;
 697:	8b 45 f4             	mov    -0xc(%ebp),%eax
 69a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 69d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6a0:	8b 55 08             	mov    0x8(%ebp),%edx
 6a3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6a9:	83 c0 08             	add    $0x8,%eax
 6ac:	83 ec 0c             	sub    $0xc,%esp
 6af:	50                   	push   %eax
 6b0:	e8 c8 fe ff ff       	call   57d <free>
 6b5:	83 c4 10             	add    $0x10,%esp
  return freep;
 6b8:	a1 10 0a 00 00       	mov    0xa10,%eax
}
 6bd:	c9                   	leave  
 6be:	c3                   	ret    

000006bf <malloc>:

void*
malloc(uint nbytes)
{
 6bf:	55                   	push   %ebp
 6c0:	89 e5                	mov    %esp,%ebp
 6c2:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6c5:	8b 45 08             	mov    0x8(%ebp),%eax
 6c8:	83 c0 07             	add    $0x7,%eax
 6cb:	c1 e8 03             	shr    $0x3,%eax
 6ce:	83 c0 01             	add    $0x1,%eax
 6d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6d4:	a1 10 0a 00 00       	mov    0xa10,%eax
 6d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 6dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6e0:	75 23                	jne    705 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 6e2:	c7 45 f0 08 0a 00 00 	movl   $0xa08,-0x10(%ebp)
 6e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ec:	a3 10 0a 00 00       	mov    %eax,0xa10
 6f1:	a1 10 0a 00 00       	mov    0xa10,%eax
 6f6:	a3 08 0a 00 00       	mov    %eax,0xa08
    base.s.size = 0;
 6fb:	c7 05 0c 0a 00 00 00 	movl   $0x0,0xa0c
 702:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 705:	8b 45 f0             	mov    -0x10(%ebp),%eax
 708:	8b 00                	mov    (%eax),%eax
 70a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 70d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 710:	8b 40 04             	mov    0x4(%eax),%eax
 713:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 716:	72 4d                	jb     765 <malloc+0xa6>
      if(p->s.size == nunits)
 718:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71b:	8b 40 04             	mov    0x4(%eax),%eax
 71e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 721:	75 0c                	jne    72f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 723:	8b 45 f4             	mov    -0xc(%ebp),%eax
 726:	8b 10                	mov    (%eax),%edx
 728:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72b:	89 10                	mov    %edx,(%eax)
 72d:	eb 26                	jmp    755 <malloc+0x96>
      else {
        p->s.size -= nunits;
 72f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 732:	8b 40 04             	mov    0x4(%eax),%eax
 735:	2b 45 ec             	sub    -0x14(%ebp),%eax
 738:	89 c2                	mov    %eax,%edx
 73a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 740:	8b 45 f4             	mov    -0xc(%ebp),%eax
 743:	8b 40 04             	mov    0x4(%eax),%eax
 746:	c1 e0 03             	shl    $0x3,%eax
 749:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 74c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 752:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 755:	8b 45 f0             	mov    -0x10(%ebp),%eax
 758:	a3 10 0a 00 00       	mov    %eax,0xa10
      return (void*)(p + 1);
 75d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 760:	83 c0 08             	add    $0x8,%eax
 763:	eb 3b                	jmp    7a0 <malloc+0xe1>
    }
    if(p == freep)
 765:	a1 10 0a 00 00       	mov    0xa10,%eax
 76a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 76d:	75 1e                	jne    78d <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 76f:	83 ec 0c             	sub    $0xc,%esp
 772:	ff 75 ec             	pushl  -0x14(%ebp)
 775:	e8 e5 fe ff ff       	call   65f <morecore>
 77a:	83 c4 10             	add    $0x10,%esp
 77d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 780:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 784:	75 07                	jne    78d <malloc+0xce>
        return 0;
 786:	b8 00 00 00 00       	mov    $0x0,%eax
 78b:	eb 13                	jmp    7a0 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 790:	89 45 f0             	mov    %eax,-0x10(%ebp)
 793:	8b 45 f4             	mov    -0xc(%ebp),%eax
 796:	8b 00                	mov    (%eax),%eax
 798:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 79b:	e9 6d ff ff ff       	jmp    70d <malloc+0x4e>
}
 7a0:	c9                   	leave  
 7a1:	c3                   	ret    
