
_test7:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

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
	printf(1,"Test7\n");
  11:	83 ec 08             	sub    $0x8,%esp
  14:	68 c5 07 00 00       	push   $0x7c5
  19:	6a 01                	push   $0x1
  1b:	e8 ef 03 00 00       	call   40f <printf>
  20:	83 c4 10             	add    $0x10,%esp
	int arr[1]={0};
  23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if(0)printf(1,"%d",arr[0]);
	arr[-10001]=0;
  2a:	c7 85 b0 63 ff ff 00 	movl   $0x0,-0x9c50(%ebp)
  31:	00 00 00 
	exit();
  34:	e8 57 02 00 00       	call   290 <exit>

00000039 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  39:	55                   	push   %ebp
  3a:	89 e5                	mov    %esp,%ebp
  3c:	57                   	push   %edi
  3d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  41:	8b 55 10             	mov    0x10(%ebp),%edx
  44:	8b 45 0c             	mov    0xc(%ebp),%eax
  47:	89 cb                	mov    %ecx,%ebx
  49:	89 df                	mov    %ebx,%edi
  4b:	89 d1                	mov    %edx,%ecx
  4d:	fc                   	cld    
  4e:	f3 aa                	rep stos %al,%es:(%edi)
  50:	89 ca                	mov    %ecx,%edx
  52:	89 fb                	mov    %edi,%ebx
  54:	89 5d 08             	mov    %ebx,0x8(%ebp)
  57:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  5a:	90                   	nop
  5b:	5b                   	pop    %ebx
  5c:	5f                   	pop    %edi
  5d:	5d                   	pop    %ebp
  5e:	c3                   	ret    

0000005f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  5f:	55                   	push   %ebp
  60:	89 e5                	mov    %esp,%ebp
  62:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  65:	8b 45 08             	mov    0x8(%ebp),%eax
  68:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  6b:	90                   	nop
  6c:	8b 45 08             	mov    0x8(%ebp),%eax
  6f:	8d 50 01             	lea    0x1(%eax),%edx
  72:	89 55 08             	mov    %edx,0x8(%ebp)
  75:	8b 55 0c             	mov    0xc(%ebp),%edx
  78:	8d 4a 01             	lea    0x1(%edx),%ecx
  7b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  7e:	0f b6 12             	movzbl (%edx),%edx
  81:	88 10                	mov    %dl,(%eax)
  83:	0f b6 00             	movzbl (%eax),%eax
  86:	84 c0                	test   %al,%al
  88:	75 e2                	jne    6c <strcpy+0xd>
    ;
  return os;
  8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8d:	c9                   	leave  
  8e:	c3                   	ret    

0000008f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8f:	55                   	push   %ebp
  90:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  92:	eb 08                	jmp    9c <strcmp+0xd>
    p++, q++;
  94:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  98:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  9c:	8b 45 08             	mov    0x8(%ebp),%eax
  9f:	0f b6 00             	movzbl (%eax),%eax
  a2:	84 c0                	test   %al,%al
  a4:	74 10                	je     b6 <strcmp+0x27>
  a6:	8b 45 08             	mov    0x8(%ebp),%eax
  a9:	0f b6 10             	movzbl (%eax),%edx
  ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  af:	0f b6 00             	movzbl (%eax),%eax
  b2:	38 c2                	cmp    %al,%dl
  b4:	74 de                	je     94 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  b6:	8b 45 08             	mov    0x8(%ebp),%eax
  b9:	0f b6 00             	movzbl (%eax),%eax
  bc:	0f b6 d0             	movzbl %al,%edx
  bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  c2:	0f b6 00             	movzbl (%eax),%eax
  c5:	0f b6 c0             	movzbl %al,%eax
  c8:	29 c2                	sub    %eax,%edx
  ca:	89 d0                	mov    %edx,%eax
}
  cc:	5d                   	pop    %ebp
  cd:	c3                   	ret    

000000ce <strlen>:

uint
strlen(char *s)
{
  ce:	55                   	push   %ebp
  cf:	89 e5                	mov    %esp,%ebp
  d1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  db:	eb 04                	jmp    e1 <strlen+0x13>
  dd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  e4:	8b 45 08             	mov    0x8(%ebp),%eax
  e7:	01 d0                	add    %edx,%eax
  e9:	0f b6 00             	movzbl (%eax),%eax
  ec:	84 c0                	test   %al,%al
  ee:	75 ed                	jne    dd <strlen+0xf>
    ;
  return n;
  f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  f3:	c9                   	leave  
  f4:	c3                   	ret    

000000f5 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f5:	55                   	push   %ebp
  f6:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  f8:	8b 45 10             	mov    0x10(%ebp),%eax
  fb:	50                   	push   %eax
  fc:	ff 75 0c             	pushl  0xc(%ebp)
  ff:	ff 75 08             	pushl  0x8(%ebp)
 102:	e8 32 ff ff ff       	call   39 <stosb>
 107:	83 c4 0c             	add    $0xc,%esp
  return dst;
 10a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 10d:	c9                   	leave  
 10e:	c3                   	ret    

0000010f <strchr>:

char*
strchr(const char *s, char c)
{
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	83 ec 04             	sub    $0x4,%esp
 115:	8b 45 0c             	mov    0xc(%ebp),%eax
 118:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 11b:	eb 14                	jmp    131 <strchr+0x22>
    if(*s == c)
 11d:	8b 45 08             	mov    0x8(%ebp),%eax
 120:	0f b6 00             	movzbl (%eax),%eax
 123:	3a 45 fc             	cmp    -0x4(%ebp),%al
 126:	75 05                	jne    12d <strchr+0x1e>
      return (char*)s;
 128:	8b 45 08             	mov    0x8(%ebp),%eax
 12b:	eb 13                	jmp    140 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 12d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 131:	8b 45 08             	mov    0x8(%ebp),%eax
 134:	0f b6 00             	movzbl (%eax),%eax
 137:	84 c0                	test   %al,%al
 139:	75 e2                	jne    11d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 13b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 140:	c9                   	leave  
 141:	c3                   	ret    

00000142 <gets>:

char*
gets(char *buf, int max)
{
 142:	55                   	push   %ebp
 143:	89 e5                	mov    %esp,%ebp
 145:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 148:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 14f:	eb 42                	jmp    193 <gets+0x51>
    cc = read(0, &c, 1);
 151:	83 ec 04             	sub    $0x4,%esp
 154:	6a 01                	push   $0x1
 156:	8d 45 ef             	lea    -0x11(%ebp),%eax
 159:	50                   	push   %eax
 15a:	6a 00                	push   $0x0
 15c:	e8 47 01 00 00       	call   2a8 <read>
 161:	83 c4 10             	add    $0x10,%esp
 164:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 167:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 16b:	7e 33                	jle    1a0 <gets+0x5e>
      break;
    buf[i++] = c;
 16d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 170:	8d 50 01             	lea    0x1(%eax),%edx
 173:	89 55 f4             	mov    %edx,-0xc(%ebp)
 176:	89 c2                	mov    %eax,%edx
 178:	8b 45 08             	mov    0x8(%ebp),%eax
 17b:	01 c2                	add    %eax,%edx
 17d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 181:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 183:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 187:	3c 0a                	cmp    $0xa,%al
 189:	74 16                	je     1a1 <gets+0x5f>
 18b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 18f:	3c 0d                	cmp    $0xd,%al
 191:	74 0e                	je     1a1 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 193:	8b 45 f4             	mov    -0xc(%ebp),%eax
 196:	83 c0 01             	add    $0x1,%eax
 199:	3b 45 0c             	cmp    0xc(%ebp),%eax
 19c:	7c b3                	jl     151 <gets+0xf>
 19e:	eb 01                	jmp    1a1 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1a0:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	01 d0                	add    %edx,%eax
 1a9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1af:	c9                   	leave  
 1b0:	c3                   	ret    

000001b1 <stat>:

int
stat(char *n, struct stat *st)
{
 1b1:	55                   	push   %ebp
 1b2:	89 e5                	mov    %esp,%ebp
 1b4:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b7:	83 ec 08             	sub    $0x8,%esp
 1ba:	6a 00                	push   $0x0
 1bc:	ff 75 08             	pushl  0x8(%ebp)
 1bf:	e8 0c 01 00 00       	call   2d0 <open>
 1c4:	83 c4 10             	add    $0x10,%esp
 1c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1ce:	79 07                	jns    1d7 <stat+0x26>
    return -1;
 1d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1d5:	eb 25                	jmp    1fc <stat+0x4b>
  r = fstat(fd, st);
 1d7:	83 ec 08             	sub    $0x8,%esp
 1da:	ff 75 0c             	pushl  0xc(%ebp)
 1dd:	ff 75 f4             	pushl  -0xc(%ebp)
 1e0:	e8 03 01 00 00       	call   2e8 <fstat>
 1e5:	83 c4 10             	add    $0x10,%esp
 1e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1eb:	83 ec 0c             	sub    $0xc,%esp
 1ee:	ff 75 f4             	pushl  -0xc(%ebp)
 1f1:	e8 c2 00 00 00       	call   2b8 <close>
 1f6:	83 c4 10             	add    $0x10,%esp
  return r;
 1f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1fc:	c9                   	leave  
 1fd:	c3                   	ret    

000001fe <atoi>:

int
atoi(const char *s)
{
 1fe:	55                   	push   %ebp
 1ff:	89 e5                	mov    %esp,%ebp
 201:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 204:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 20b:	eb 25                	jmp    232 <atoi+0x34>
    n = n*10 + *s++ - '0';
 20d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 210:	89 d0                	mov    %edx,%eax
 212:	c1 e0 02             	shl    $0x2,%eax
 215:	01 d0                	add    %edx,%eax
 217:	01 c0                	add    %eax,%eax
 219:	89 c1                	mov    %eax,%ecx
 21b:	8b 45 08             	mov    0x8(%ebp),%eax
 21e:	8d 50 01             	lea    0x1(%eax),%edx
 221:	89 55 08             	mov    %edx,0x8(%ebp)
 224:	0f b6 00             	movzbl (%eax),%eax
 227:	0f be c0             	movsbl %al,%eax
 22a:	01 c8                	add    %ecx,%eax
 22c:	83 e8 30             	sub    $0x30,%eax
 22f:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 232:	8b 45 08             	mov    0x8(%ebp),%eax
 235:	0f b6 00             	movzbl (%eax),%eax
 238:	3c 2f                	cmp    $0x2f,%al
 23a:	7e 0a                	jle    246 <atoi+0x48>
 23c:	8b 45 08             	mov    0x8(%ebp),%eax
 23f:	0f b6 00             	movzbl (%eax),%eax
 242:	3c 39                	cmp    $0x39,%al
 244:	7e c7                	jle    20d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 246:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 249:	c9                   	leave  
 24a:	c3                   	ret    

0000024b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 24b:	55                   	push   %ebp
 24c:	89 e5                	mov    %esp,%ebp
 24e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 251:	8b 45 08             	mov    0x8(%ebp),%eax
 254:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 257:	8b 45 0c             	mov    0xc(%ebp),%eax
 25a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 25d:	eb 17                	jmp    276 <memmove+0x2b>
    *dst++ = *src++;
 25f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 262:	8d 50 01             	lea    0x1(%eax),%edx
 265:	89 55 fc             	mov    %edx,-0x4(%ebp)
 268:	8b 55 f8             	mov    -0x8(%ebp),%edx
 26b:	8d 4a 01             	lea    0x1(%edx),%ecx
 26e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 271:	0f b6 12             	movzbl (%edx),%edx
 274:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 276:	8b 45 10             	mov    0x10(%ebp),%eax
 279:	8d 50 ff             	lea    -0x1(%eax),%edx
 27c:	89 55 10             	mov    %edx,0x10(%ebp)
 27f:	85 c0                	test   %eax,%eax
 281:	7f dc                	jg     25f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 283:	8b 45 08             	mov    0x8(%ebp),%eax
}
 286:	c9                   	leave  
 287:	c3                   	ret    

00000288 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 288:	b8 01 00 00 00       	mov    $0x1,%eax
 28d:	cd 40                	int    $0x40
 28f:	c3                   	ret    

00000290 <exit>:
SYSCALL(exit)
 290:	b8 02 00 00 00       	mov    $0x2,%eax
 295:	cd 40                	int    $0x40
 297:	c3                   	ret    

00000298 <wait>:
SYSCALL(wait)
 298:	b8 03 00 00 00       	mov    $0x3,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <pipe>:
SYSCALL(pipe)
 2a0:	b8 04 00 00 00       	mov    $0x4,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <read>:
SYSCALL(read)
 2a8:	b8 05 00 00 00       	mov    $0x5,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <write>:
SYSCALL(write)
 2b0:	b8 10 00 00 00       	mov    $0x10,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <close>:
SYSCALL(close)
 2b8:	b8 15 00 00 00       	mov    $0x15,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <kill>:
SYSCALL(kill)
 2c0:	b8 06 00 00 00       	mov    $0x6,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <exec>:
SYSCALL(exec)
 2c8:	b8 07 00 00 00       	mov    $0x7,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <open>:
SYSCALL(open)
 2d0:	b8 0f 00 00 00       	mov    $0xf,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <mknod>:
SYSCALL(mknod)
 2d8:	b8 11 00 00 00       	mov    $0x11,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <unlink>:
SYSCALL(unlink)
 2e0:	b8 12 00 00 00       	mov    $0x12,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <fstat>:
SYSCALL(fstat)
 2e8:	b8 08 00 00 00       	mov    $0x8,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <link>:
SYSCALL(link)
 2f0:	b8 13 00 00 00       	mov    $0x13,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <mkdir>:
SYSCALL(mkdir)
 2f8:	b8 14 00 00 00       	mov    $0x14,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <chdir>:
SYSCALL(chdir)
 300:	b8 09 00 00 00       	mov    $0x9,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <dup>:
SYSCALL(dup)
 308:	b8 0a 00 00 00       	mov    $0xa,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <getpid>:
SYSCALL(getpid)
 310:	b8 0b 00 00 00       	mov    $0xb,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <sbrk>:
SYSCALL(sbrk)
 318:	b8 0c 00 00 00       	mov    $0xc,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <sleep>:
SYSCALL(sleep)
 320:	b8 0d 00 00 00       	mov    $0xd,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <uptime>:
SYSCALL(uptime)
 328:	b8 0e 00 00 00       	mov    $0xe,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <halt>:
SYSCALL(halt)
 330:	b8 16 00 00 00       	mov    $0x16,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 338:	55                   	push   %ebp
 339:	89 e5                	mov    %esp,%ebp
 33b:	83 ec 18             	sub    $0x18,%esp
 33e:	8b 45 0c             	mov    0xc(%ebp),%eax
 341:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 344:	83 ec 04             	sub    $0x4,%esp
 347:	6a 01                	push   $0x1
 349:	8d 45 f4             	lea    -0xc(%ebp),%eax
 34c:	50                   	push   %eax
 34d:	ff 75 08             	pushl  0x8(%ebp)
 350:	e8 5b ff ff ff       	call   2b0 <write>
 355:	83 c4 10             	add    $0x10,%esp
}
 358:	90                   	nop
 359:	c9                   	leave  
 35a:	c3                   	ret    

0000035b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 35b:	55                   	push   %ebp
 35c:	89 e5                	mov    %esp,%ebp
 35e:	53                   	push   %ebx
 35f:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 362:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 369:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 36d:	74 17                	je     386 <printint+0x2b>
 36f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 373:	79 11                	jns    386 <printint+0x2b>
    neg = 1;
 375:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 37c:	8b 45 0c             	mov    0xc(%ebp),%eax
 37f:	f7 d8                	neg    %eax
 381:	89 45 ec             	mov    %eax,-0x14(%ebp)
 384:	eb 06                	jmp    38c <printint+0x31>
  } else {
    x = xx;
 386:	8b 45 0c             	mov    0xc(%ebp),%eax
 389:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 38c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 393:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 396:	8d 41 01             	lea    0x1(%ecx),%eax
 399:	89 45 f4             	mov    %eax,-0xc(%ebp)
 39c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 39f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3a2:	ba 00 00 00 00       	mov    $0x0,%edx
 3a7:	f7 f3                	div    %ebx
 3a9:	89 d0                	mov    %edx,%eax
 3ab:	0f b6 80 1c 0a 00 00 	movzbl 0xa1c(%eax),%eax
 3b2:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3bc:	ba 00 00 00 00       	mov    $0x0,%edx
 3c1:	f7 f3                	div    %ebx
 3c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3ca:	75 c7                	jne    393 <printint+0x38>
  if(neg)
 3cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3d0:	74 2d                	je     3ff <printint+0xa4>
    buf[i++] = '-';
 3d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d5:	8d 50 01             	lea    0x1(%eax),%edx
 3d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3db:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3e0:	eb 1d                	jmp    3ff <printint+0xa4>
    putc(fd, buf[i]);
 3e2:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3e8:	01 d0                	add    %edx,%eax
 3ea:	0f b6 00             	movzbl (%eax),%eax
 3ed:	0f be c0             	movsbl %al,%eax
 3f0:	83 ec 08             	sub    $0x8,%esp
 3f3:	50                   	push   %eax
 3f4:	ff 75 08             	pushl  0x8(%ebp)
 3f7:	e8 3c ff ff ff       	call   338 <putc>
 3fc:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3ff:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 403:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 407:	79 d9                	jns    3e2 <printint+0x87>
    putc(fd, buf[i]);
}
 409:	90                   	nop
 40a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 40d:	c9                   	leave  
 40e:	c3                   	ret    

0000040f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 40f:	55                   	push   %ebp
 410:	89 e5                	mov    %esp,%ebp
 412:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 415:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 41c:	8d 45 0c             	lea    0xc(%ebp),%eax
 41f:	83 c0 04             	add    $0x4,%eax
 422:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 425:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 42c:	e9 59 01 00 00       	jmp    58a <printf+0x17b>
    c = fmt[i] & 0xff;
 431:	8b 55 0c             	mov    0xc(%ebp),%edx
 434:	8b 45 f0             	mov    -0x10(%ebp),%eax
 437:	01 d0                	add    %edx,%eax
 439:	0f b6 00             	movzbl (%eax),%eax
 43c:	0f be c0             	movsbl %al,%eax
 43f:	25 ff 00 00 00       	and    $0xff,%eax
 444:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 447:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 44b:	75 2c                	jne    479 <printf+0x6a>
      if(c == '%'){
 44d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 451:	75 0c                	jne    45f <printf+0x50>
        state = '%';
 453:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 45a:	e9 27 01 00 00       	jmp    586 <printf+0x177>
      } else {
        putc(fd, c);
 45f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 462:	0f be c0             	movsbl %al,%eax
 465:	83 ec 08             	sub    $0x8,%esp
 468:	50                   	push   %eax
 469:	ff 75 08             	pushl  0x8(%ebp)
 46c:	e8 c7 fe ff ff       	call   338 <putc>
 471:	83 c4 10             	add    $0x10,%esp
 474:	e9 0d 01 00 00       	jmp    586 <printf+0x177>
      }
    } else if(state == '%'){
 479:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 47d:	0f 85 03 01 00 00    	jne    586 <printf+0x177>
      if(c == 'd'){
 483:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 487:	75 1e                	jne    4a7 <printf+0x98>
        printint(fd, *ap, 10, 1);
 489:	8b 45 e8             	mov    -0x18(%ebp),%eax
 48c:	8b 00                	mov    (%eax),%eax
 48e:	6a 01                	push   $0x1
 490:	6a 0a                	push   $0xa
 492:	50                   	push   %eax
 493:	ff 75 08             	pushl  0x8(%ebp)
 496:	e8 c0 fe ff ff       	call   35b <printint>
 49b:	83 c4 10             	add    $0x10,%esp
        ap++;
 49e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4a2:	e9 d8 00 00 00       	jmp    57f <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4a7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4ab:	74 06                	je     4b3 <printf+0xa4>
 4ad:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4b1:	75 1e                	jne    4d1 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b6:	8b 00                	mov    (%eax),%eax
 4b8:	6a 00                	push   $0x0
 4ba:	6a 10                	push   $0x10
 4bc:	50                   	push   %eax
 4bd:	ff 75 08             	pushl  0x8(%ebp)
 4c0:	e8 96 fe ff ff       	call   35b <printint>
 4c5:	83 c4 10             	add    $0x10,%esp
        ap++;
 4c8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4cc:	e9 ae 00 00 00       	jmp    57f <printf+0x170>
      } else if(c == 's'){
 4d1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4d5:	75 43                	jne    51a <printf+0x10b>
        s = (char*)*ap;
 4d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4da:	8b 00                	mov    (%eax),%eax
 4dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4df:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4e7:	75 25                	jne    50e <printf+0xff>
          s = "(null)";
 4e9:	c7 45 f4 cc 07 00 00 	movl   $0x7cc,-0xc(%ebp)
        while(*s != 0){
 4f0:	eb 1c                	jmp    50e <printf+0xff>
          putc(fd, *s);
 4f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f5:	0f b6 00             	movzbl (%eax),%eax
 4f8:	0f be c0             	movsbl %al,%eax
 4fb:	83 ec 08             	sub    $0x8,%esp
 4fe:	50                   	push   %eax
 4ff:	ff 75 08             	pushl  0x8(%ebp)
 502:	e8 31 fe ff ff       	call   338 <putc>
 507:	83 c4 10             	add    $0x10,%esp
          s++;
 50a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 50e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 511:	0f b6 00             	movzbl (%eax),%eax
 514:	84 c0                	test   %al,%al
 516:	75 da                	jne    4f2 <printf+0xe3>
 518:	eb 65                	jmp    57f <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 51a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 51e:	75 1d                	jne    53d <printf+0x12e>
        putc(fd, *ap);
 520:	8b 45 e8             	mov    -0x18(%ebp),%eax
 523:	8b 00                	mov    (%eax),%eax
 525:	0f be c0             	movsbl %al,%eax
 528:	83 ec 08             	sub    $0x8,%esp
 52b:	50                   	push   %eax
 52c:	ff 75 08             	pushl  0x8(%ebp)
 52f:	e8 04 fe ff ff       	call   338 <putc>
 534:	83 c4 10             	add    $0x10,%esp
        ap++;
 537:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 53b:	eb 42                	jmp    57f <printf+0x170>
      } else if(c == '%'){
 53d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 541:	75 17                	jne    55a <printf+0x14b>
        putc(fd, c);
 543:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 546:	0f be c0             	movsbl %al,%eax
 549:	83 ec 08             	sub    $0x8,%esp
 54c:	50                   	push   %eax
 54d:	ff 75 08             	pushl  0x8(%ebp)
 550:	e8 e3 fd ff ff       	call   338 <putc>
 555:	83 c4 10             	add    $0x10,%esp
 558:	eb 25                	jmp    57f <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 55a:	83 ec 08             	sub    $0x8,%esp
 55d:	6a 25                	push   $0x25
 55f:	ff 75 08             	pushl  0x8(%ebp)
 562:	e8 d1 fd ff ff       	call   338 <putc>
 567:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 56a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 56d:	0f be c0             	movsbl %al,%eax
 570:	83 ec 08             	sub    $0x8,%esp
 573:	50                   	push   %eax
 574:	ff 75 08             	pushl  0x8(%ebp)
 577:	e8 bc fd ff ff       	call   338 <putc>
 57c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 57f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 586:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 58a:	8b 55 0c             	mov    0xc(%ebp),%edx
 58d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 590:	01 d0                	add    %edx,%eax
 592:	0f b6 00             	movzbl (%eax),%eax
 595:	84 c0                	test   %al,%al
 597:	0f 85 94 fe ff ff    	jne    431 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 59d:	90                   	nop
 59e:	c9                   	leave  
 59f:	c3                   	ret    

000005a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5a0:	55                   	push   %ebp
 5a1:	89 e5                	mov    %esp,%ebp
 5a3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5a6:	8b 45 08             	mov    0x8(%ebp),%eax
 5a9:	83 e8 08             	sub    $0x8,%eax
 5ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5af:	a1 38 0a 00 00       	mov    0xa38,%eax
 5b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5b7:	eb 24                	jmp    5dd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5bc:	8b 00                	mov    (%eax),%eax
 5be:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5c1:	77 12                	ja     5d5 <free+0x35>
 5c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5c6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5c9:	77 24                	ja     5ef <free+0x4f>
 5cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ce:	8b 00                	mov    (%eax),%eax
 5d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5d3:	77 1a                	ja     5ef <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d8:	8b 00                	mov    (%eax),%eax
 5da:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e3:	76 d4                	jbe    5b9 <free+0x19>
 5e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e8:	8b 00                	mov    (%eax),%eax
 5ea:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5ed:	76 ca                	jbe    5b9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f2:	8b 40 04             	mov    0x4(%eax),%eax
 5f5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 5fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5ff:	01 c2                	add    %eax,%edx
 601:	8b 45 fc             	mov    -0x4(%ebp),%eax
 604:	8b 00                	mov    (%eax),%eax
 606:	39 c2                	cmp    %eax,%edx
 608:	75 24                	jne    62e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 60a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60d:	8b 50 04             	mov    0x4(%eax),%edx
 610:	8b 45 fc             	mov    -0x4(%ebp),%eax
 613:	8b 00                	mov    (%eax),%eax
 615:	8b 40 04             	mov    0x4(%eax),%eax
 618:	01 c2                	add    %eax,%edx
 61a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 620:	8b 45 fc             	mov    -0x4(%ebp),%eax
 623:	8b 00                	mov    (%eax),%eax
 625:	8b 10                	mov    (%eax),%edx
 627:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62a:	89 10                	mov    %edx,(%eax)
 62c:	eb 0a                	jmp    638 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 62e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 631:	8b 10                	mov    (%eax),%edx
 633:	8b 45 f8             	mov    -0x8(%ebp),%eax
 636:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 638:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63b:	8b 40 04             	mov    0x4(%eax),%eax
 63e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 645:	8b 45 fc             	mov    -0x4(%ebp),%eax
 648:	01 d0                	add    %edx,%eax
 64a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 64d:	75 20                	jne    66f <free+0xcf>
    p->s.size += bp->s.size;
 64f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 652:	8b 50 04             	mov    0x4(%eax),%edx
 655:	8b 45 f8             	mov    -0x8(%ebp),%eax
 658:	8b 40 04             	mov    0x4(%eax),%eax
 65b:	01 c2                	add    %eax,%edx
 65d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 660:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 663:	8b 45 f8             	mov    -0x8(%ebp),%eax
 666:	8b 10                	mov    (%eax),%edx
 668:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66b:	89 10                	mov    %edx,(%eax)
 66d:	eb 08                	jmp    677 <free+0xd7>
  } else
    p->s.ptr = bp;
 66f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 672:	8b 55 f8             	mov    -0x8(%ebp),%edx
 675:	89 10                	mov    %edx,(%eax)
  freep = p;
 677:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67a:	a3 38 0a 00 00       	mov    %eax,0xa38
}
 67f:	90                   	nop
 680:	c9                   	leave  
 681:	c3                   	ret    

00000682 <morecore>:

static Header*
morecore(uint nu)
{
 682:	55                   	push   %ebp
 683:	89 e5                	mov    %esp,%ebp
 685:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 688:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 68f:	77 07                	ja     698 <morecore+0x16>
    nu = 4096;
 691:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 698:	8b 45 08             	mov    0x8(%ebp),%eax
 69b:	c1 e0 03             	shl    $0x3,%eax
 69e:	83 ec 0c             	sub    $0xc,%esp
 6a1:	50                   	push   %eax
 6a2:	e8 71 fc ff ff       	call   318 <sbrk>
 6a7:	83 c4 10             	add    $0x10,%esp
 6aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6ad:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6b1:	75 07                	jne    6ba <morecore+0x38>
    return 0;
 6b3:	b8 00 00 00 00       	mov    $0x0,%eax
 6b8:	eb 26                	jmp    6e0 <morecore+0x5e>
  hp = (Header*)p;
 6ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c3:	8b 55 08             	mov    0x8(%ebp),%edx
 6c6:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6cc:	83 c0 08             	add    $0x8,%eax
 6cf:	83 ec 0c             	sub    $0xc,%esp
 6d2:	50                   	push   %eax
 6d3:	e8 c8 fe ff ff       	call   5a0 <free>
 6d8:	83 c4 10             	add    $0x10,%esp
  return freep;
 6db:	a1 38 0a 00 00       	mov    0xa38,%eax
}
 6e0:	c9                   	leave  
 6e1:	c3                   	ret    

000006e2 <malloc>:

void*
malloc(uint nbytes)
{
 6e2:	55                   	push   %ebp
 6e3:	89 e5                	mov    %esp,%ebp
 6e5:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e8:	8b 45 08             	mov    0x8(%ebp),%eax
 6eb:	83 c0 07             	add    $0x7,%eax
 6ee:	c1 e8 03             	shr    $0x3,%eax
 6f1:	83 c0 01             	add    $0x1,%eax
 6f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6f7:	a1 38 0a 00 00       	mov    0xa38,%eax
 6fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 6ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 703:	75 23                	jne    728 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 705:	c7 45 f0 30 0a 00 00 	movl   $0xa30,-0x10(%ebp)
 70c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70f:	a3 38 0a 00 00       	mov    %eax,0xa38
 714:	a1 38 0a 00 00       	mov    0xa38,%eax
 719:	a3 30 0a 00 00       	mov    %eax,0xa30
    base.s.size = 0;
 71e:	c7 05 34 0a 00 00 00 	movl   $0x0,0xa34
 725:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 728:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72b:	8b 00                	mov    (%eax),%eax
 72d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 730:	8b 45 f4             	mov    -0xc(%ebp),%eax
 733:	8b 40 04             	mov    0x4(%eax),%eax
 736:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 739:	72 4d                	jb     788 <malloc+0xa6>
      if(p->s.size == nunits)
 73b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73e:	8b 40 04             	mov    0x4(%eax),%eax
 741:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 744:	75 0c                	jne    752 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 746:	8b 45 f4             	mov    -0xc(%ebp),%eax
 749:	8b 10                	mov    (%eax),%edx
 74b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74e:	89 10                	mov    %edx,(%eax)
 750:	eb 26                	jmp    778 <malloc+0x96>
      else {
        p->s.size -= nunits;
 752:	8b 45 f4             	mov    -0xc(%ebp),%eax
 755:	8b 40 04             	mov    0x4(%eax),%eax
 758:	2b 45 ec             	sub    -0x14(%ebp),%eax
 75b:	89 c2                	mov    %eax,%edx
 75d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 760:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 763:	8b 45 f4             	mov    -0xc(%ebp),%eax
 766:	8b 40 04             	mov    0x4(%eax),%eax
 769:	c1 e0 03             	shl    $0x3,%eax
 76c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 76f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 772:	8b 55 ec             	mov    -0x14(%ebp),%edx
 775:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 778:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77b:	a3 38 0a 00 00       	mov    %eax,0xa38
      return (void*)(p + 1);
 780:	8b 45 f4             	mov    -0xc(%ebp),%eax
 783:	83 c0 08             	add    $0x8,%eax
 786:	eb 3b                	jmp    7c3 <malloc+0xe1>
    }
    if(p == freep)
 788:	a1 38 0a 00 00       	mov    0xa38,%eax
 78d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 790:	75 1e                	jne    7b0 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 792:	83 ec 0c             	sub    $0xc,%esp
 795:	ff 75 ec             	pushl  -0x14(%ebp)
 798:	e8 e5 fe ff ff       	call   682 <morecore>
 79d:	83 c4 10             	add    $0x10,%esp
 7a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7a7:	75 07                	jne    7b0 <malloc+0xce>
        return 0;
 7a9:	b8 00 00 00 00       	mov    $0x0,%eax
 7ae:	eb 13                	jmp    7c3 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b9:	8b 00                	mov    (%eax),%eax
 7bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7be:	e9 6d ff ff ff       	jmp    730 <malloc+0x4e>
}
 7c3:	c9                   	leave  
 7c4:	c3                   	ret    
