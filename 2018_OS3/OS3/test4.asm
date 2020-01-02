
_test4:     file format elf32-i386


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
   e:	81 ec 44 9c 00 00    	sub    $0x9c44,%esp
	printf(1,"Test4\n");
  14:	83 ec 08             	sub    $0x8,%esp
  17:	68 d1 07 00 00       	push   $0x7d1
  1c:	6a 01                	push   $0x1
  1e:	e8 f8 03 00 00       	call   41b <printf>
  23:	83 c4 10             	add    $0x10,%esp
	int arr[10000]={0};
  26:	8d 85 b8 63 ff ff    	lea    -0x9c48(%ebp),%eax
  2c:	ba 40 9c 00 00       	mov    $0x9c40,%edx
  31:	83 ec 04             	sub    $0x4,%esp
  34:	52                   	push   %edx
  35:	6a 00                	push   $0x0
  37:	50                   	push   %eax
  38:	e8 c4 00 00 00       	call   101 <memset>
  3d:	83 c4 10             	add    $0x10,%esp
	if(0)printf(1,"%d",arr[0]);
	exit();
  40:	e8 57 02 00 00       	call   29c <exit>

00000045 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  45:	55                   	push   %ebp
  46:	89 e5                	mov    %esp,%ebp
  48:	57                   	push   %edi
  49:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  4d:	8b 55 10             	mov    0x10(%ebp),%edx
  50:	8b 45 0c             	mov    0xc(%ebp),%eax
  53:	89 cb                	mov    %ecx,%ebx
  55:	89 df                	mov    %ebx,%edi
  57:	89 d1                	mov    %edx,%ecx
  59:	fc                   	cld    
  5a:	f3 aa                	rep stos %al,%es:(%edi)
  5c:	89 ca                	mov    %ecx,%edx
  5e:	89 fb                	mov    %edi,%ebx
  60:	89 5d 08             	mov    %ebx,0x8(%ebp)
  63:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  66:	90                   	nop
  67:	5b                   	pop    %ebx
  68:	5f                   	pop    %edi
  69:	5d                   	pop    %ebp
  6a:	c3                   	ret    

0000006b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  6b:	55                   	push   %ebp
  6c:	89 e5                	mov    %esp,%ebp
  6e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  71:	8b 45 08             	mov    0x8(%ebp),%eax
  74:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  77:	90                   	nop
  78:	8b 45 08             	mov    0x8(%ebp),%eax
  7b:	8d 50 01             	lea    0x1(%eax),%edx
  7e:	89 55 08             	mov    %edx,0x8(%ebp)
  81:	8b 55 0c             	mov    0xc(%ebp),%edx
  84:	8d 4a 01             	lea    0x1(%edx),%ecx
  87:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8a:	0f b6 12             	movzbl (%edx),%edx
  8d:	88 10                	mov    %dl,(%eax)
  8f:	0f b6 00             	movzbl (%eax),%eax
  92:	84 c0                	test   %al,%al
  94:	75 e2                	jne    78 <strcpy+0xd>
    ;
  return os;
  96:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  99:	c9                   	leave  
  9a:	c3                   	ret    

0000009b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9b:	55                   	push   %ebp
  9c:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  9e:	eb 08                	jmp    a8 <strcmp+0xd>
    p++, q++;
  a0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  a4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  a8:	8b 45 08             	mov    0x8(%ebp),%eax
  ab:	0f b6 00             	movzbl (%eax),%eax
  ae:	84 c0                	test   %al,%al
  b0:	74 10                	je     c2 <strcmp+0x27>
  b2:	8b 45 08             	mov    0x8(%ebp),%eax
  b5:	0f b6 10             	movzbl (%eax),%edx
  b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  bb:	0f b6 00             	movzbl (%eax),%eax
  be:	38 c2                	cmp    %al,%dl
  c0:	74 de                	je     a0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  c2:	8b 45 08             	mov    0x8(%ebp),%eax
  c5:	0f b6 00             	movzbl (%eax),%eax
  c8:	0f b6 d0             	movzbl %al,%edx
  cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ce:	0f b6 00             	movzbl (%eax),%eax
  d1:	0f b6 c0             	movzbl %al,%eax
  d4:	29 c2                	sub    %eax,%edx
  d6:	89 d0                	mov    %edx,%eax
}
  d8:	5d                   	pop    %ebp
  d9:	c3                   	ret    

000000da <strlen>:

uint
strlen(char *s)
{
  da:	55                   	push   %ebp
  db:	89 e5                	mov    %esp,%ebp
  dd:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  e7:	eb 04                	jmp    ed <strlen+0x13>
  e9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  f0:	8b 45 08             	mov    0x8(%ebp),%eax
  f3:	01 d0                	add    %edx,%eax
  f5:	0f b6 00             	movzbl (%eax),%eax
  f8:	84 c0                	test   %al,%al
  fa:	75 ed                	jne    e9 <strlen+0xf>
    ;
  return n;
  fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ff:	c9                   	leave  
 100:	c3                   	ret    

00000101 <memset>:

void*
memset(void *dst, int c, uint n)
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 104:	8b 45 10             	mov    0x10(%ebp),%eax
 107:	50                   	push   %eax
 108:	ff 75 0c             	pushl  0xc(%ebp)
 10b:	ff 75 08             	pushl  0x8(%ebp)
 10e:	e8 32 ff ff ff       	call   45 <stosb>
 113:	83 c4 0c             	add    $0xc,%esp
  return dst;
 116:	8b 45 08             	mov    0x8(%ebp),%eax
}
 119:	c9                   	leave  
 11a:	c3                   	ret    

0000011b <strchr>:

char*
strchr(const char *s, char c)
{
 11b:	55                   	push   %ebp
 11c:	89 e5                	mov    %esp,%ebp
 11e:	83 ec 04             	sub    $0x4,%esp
 121:	8b 45 0c             	mov    0xc(%ebp),%eax
 124:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 127:	eb 14                	jmp    13d <strchr+0x22>
    if(*s == c)
 129:	8b 45 08             	mov    0x8(%ebp),%eax
 12c:	0f b6 00             	movzbl (%eax),%eax
 12f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 132:	75 05                	jne    139 <strchr+0x1e>
      return (char*)s;
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	eb 13                	jmp    14c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 139:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 13d:	8b 45 08             	mov    0x8(%ebp),%eax
 140:	0f b6 00             	movzbl (%eax),%eax
 143:	84 c0                	test   %al,%al
 145:	75 e2                	jne    129 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 147:	b8 00 00 00 00       	mov    $0x0,%eax
}
 14c:	c9                   	leave  
 14d:	c3                   	ret    

0000014e <gets>:

char*
gets(char *buf, int max)
{
 14e:	55                   	push   %ebp
 14f:	89 e5                	mov    %esp,%ebp
 151:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 154:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 15b:	eb 42                	jmp    19f <gets+0x51>
    cc = read(0, &c, 1);
 15d:	83 ec 04             	sub    $0x4,%esp
 160:	6a 01                	push   $0x1
 162:	8d 45 ef             	lea    -0x11(%ebp),%eax
 165:	50                   	push   %eax
 166:	6a 00                	push   $0x0
 168:	e8 47 01 00 00       	call   2b4 <read>
 16d:	83 c4 10             	add    $0x10,%esp
 170:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 173:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 177:	7e 33                	jle    1ac <gets+0x5e>
      break;
    buf[i++] = c;
 179:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17c:	8d 50 01             	lea    0x1(%eax),%edx
 17f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 182:	89 c2                	mov    %eax,%edx
 184:	8b 45 08             	mov    0x8(%ebp),%eax
 187:	01 c2                	add    %eax,%edx
 189:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 18d:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 18f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 193:	3c 0a                	cmp    $0xa,%al
 195:	74 16                	je     1ad <gets+0x5f>
 197:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 19b:	3c 0d                	cmp    $0xd,%al
 19d:	74 0e                	je     1ad <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a2:	83 c0 01             	add    $0x1,%eax
 1a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1a8:	7c b3                	jl     15d <gets+0xf>
 1aa:	eb 01                	jmp    1ad <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1ac:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1b0:	8b 45 08             	mov    0x8(%ebp),%eax
 1b3:	01 d0                	add    %edx,%eax
 1b5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1bb:	c9                   	leave  
 1bc:	c3                   	ret    

000001bd <stat>:

int
stat(char *n, struct stat *st)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
 1c0:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c3:	83 ec 08             	sub    $0x8,%esp
 1c6:	6a 00                	push   $0x0
 1c8:	ff 75 08             	pushl  0x8(%ebp)
 1cb:	e8 0c 01 00 00       	call   2dc <open>
 1d0:	83 c4 10             	add    $0x10,%esp
 1d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1da:	79 07                	jns    1e3 <stat+0x26>
    return -1;
 1dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1e1:	eb 25                	jmp    208 <stat+0x4b>
  r = fstat(fd, st);
 1e3:	83 ec 08             	sub    $0x8,%esp
 1e6:	ff 75 0c             	pushl  0xc(%ebp)
 1e9:	ff 75 f4             	pushl  -0xc(%ebp)
 1ec:	e8 03 01 00 00       	call   2f4 <fstat>
 1f1:	83 c4 10             	add    $0x10,%esp
 1f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1f7:	83 ec 0c             	sub    $0xc,%esp
 1fa:	ff 75 f4             	pushl  -0xc(%ebp)
 1fd:	e8 c2 00 00 00       	call   2c4 <close>
 202:	83 c4 10             	add    $0x10,%esp
  return r;
 205:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 208:	c9                   	leave  
 209:	c3                   	ret    

0000020a <atoi>:

int
atoi(const char *s)
{
 20a:	55                   	push   %ebp
 20b:	89 e5                	mov    %esp,%ebp
 20d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 210:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 217:	eb 25                	jmp    23e <atoi+0x34>
    n = n*10 + *s++ - '0';
 219:	8b 55 fc             	mov    -0x4(%ebp),%edx
 21c:	89 d0                	mov    %edx,%eax
 21e:	c1 e0 02             	shl    $0x2,%eax
 221:	01 d0                	add    %edx,%eax
 223:	01 c0                	add    %eax,%eax
 225:	89 c1                	mov    %eax,%ecx
 227:	8b 45 08             	mov    0x8(%ebp),%eax
 22a:	8d 50 01             	lea    0x1(%eax),%edx
 22d:	89 55 08             	mov    %edx,0x8(%ebp)
 230:	0f b6 00             	movzbl (%eax),%eax
 233:	0f be c0             	movsbl %al,%eax
 236:	01 c8                	add    %ecx,%eax
 238:	83 e8 30             	sub    $0x30,%eax
 23b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 23e:	8b 45 08             	mov    0x8(%ebp),%eax
 241:	0f b6 00             	movzbl (%eax),%eax
 244:	3c 2f                	cmp    $0x2f,%al
 246:	7e 0a                	jle    252 <atoi+0x48>
 248:	8b 45 08             	mov    0x8(%ebp),%eax
 24b:	0f b6 00             	movzbl (%eax),%eax
 24e:	3c 39                	cmp    $0x39,%al
 250:	7e c7                	jle    219 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 252:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 255:	c9                   	leave  
 256:	c3                   	ret    

00000257 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 257:	55                   	push   %ebp
 258:	89 e5                	mov    %esp,%ebp
 25a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 25d:	8b 45 08             	mov    0x8(%ebp),%eax
 260:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 263:	8b 45 0c             	mov    0xc(%ebp),%eax
 266:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 269:	eb 17                	jmp    282 <memmove+0x2b>
    *dst++ = *src++;
 26b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 26e:	8d 50 01             	lea    0x1(%eax),%edx
 271:	89 55 fc             	mov    %edx,-0x4(%ebp)
 274:	8b 55 f8             	mov    -0x8(%ebp),%edx
 277:	8d 4a 01             	lea    0x1(%edx),%ecx
 27a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 27d:	0f b6 12             	movzbl (%edx),%edx
 280:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 282:	8b 45 10             	mov    0x10(%ebp),%eax
 285:	8d 50 ff             	lea    -0x1(%eax),%edx
 288:	89 55 10             	mov    %edx,0x10(%ebp)
 28b:	85 c0                	test   %eax,%eax
 28d:	7f dc                	jg     26b <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 28f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 292:	c9                   	leave  
 293:	c3                   	ret    

00000294 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 294:	b8 01 00 00 00       	mov    $0x1,%eax
 299:	cd 40                	int    $0x40
 29b:	c3                   	ret    

0000029c <exit>:
SYSCALL(exit)
 29c:	b8 02 00 00 00       	mov    $0x2,%eax
 2a1:	cd 40                	int    $0x40
 2a3:	c3                   	ret    

000002a4 <wait>:
SYSCALL(wait)
 2a4:	b8 03 00 00 00       	mov    $0x3,%eax
 2a9:	cd 40                	int    $0x40
 2ab:	c3                   	ret    

000002ac <pipe>:
SYSCALL(pipe)
 2ac:	b8 04 00 00 00       	mov    $0x4,%eax
 2b1:	cd 40                	int    $0x40
 2b3:	c3                   	ret    

000002b4 <read>:
SYSCALL(read)
 2b4:	b8 05 00 00 00       	mov    $0x5,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <write>:
SYSCALL(write)
 2bc:	b8 10 00 00 00       	mov    $0x10,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <close>:
SYSCALL(close)
 2c4:	b8 15 00 00 00       	mov    $0x15,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <kill>:
SYSCALL(kill)
 2cc:	b8 06 00 00 00       	mov    $0x6,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <exec>:
SYSCALL(exec)
 2d4:	b8 07 00 00 00       	mov    $0x7,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <open>:
SYSCALL(open)
 2dc:	b8 0f 00 00 00       	mov    $0xf,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <mknod>:
SYSCALL(mknod)
 2e4:	b8 11 00 00 00       	mov    $0x11,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <unlink>:
SYSCALL(unlink)
 2ec:	b8 12 00 00 00       	mov    $0x12,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <fstat>:
SYSCALL(fstat)
 2f4:	b8 08 00 00 00       	mov    $0x8,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <link>:
SYSCALL(link)
 2fc:	b8 13 00 00 00       	mov    $0x13,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <mkdir>:
SYSCALL(mkdir)
 304:	b8 14 00 00 00       	mov    $0x14,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <chdir>:
SYSCALL(chdir)
 30c:	b8 09 00 00 00       	mov    $0x9,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <dup>:
SYSCALL(dup)
 314:	b8 0a 00 00 00       	mov    $0xa,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <getpid>:
SYSCALL(getpid)
 31c:	b8 0b 00 00 00       	mov    $0xb,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <sbrk>:
SYSCALL(sbrk)
 324:	b8 0c 00 00 00       	mov    $0xc,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <sleep>:
SYSCALL(sleep)
 32c:	b8 0d 00 00 00       	mov    $0xd,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <uptime>:
SYSCALL(uptime)
 334:	b8 0e 00 00 00       	mov    $0xe,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <halt>:
SYSCALL(halt)
 33c:	b8 16 00 00 00       	mov    $0x16,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 344:	55                   	push   %ebp
 345:	89 e5                	mov    %esp,%ebp
 347:	83 ec 18             	sub    $0x18,%esp
 34a:	8b 45 0c             	mov    0xc(%ebp),%eax
 34d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 350:	83 ec 04             	sub    $0x4,%esp
 353:	6a 01                	push   $0x1
 355:	8d 45 f4             	lea    -0xc(%ebp),%eax
 358:	50                   	push   %eax
 359:	ff 75 08             	pushl  0x8(%ebp)
 35c:	e8 5b ff ff ff       	call   2bc <write>
 361:	83 c4 10             	add    $0x10,%esp
}
 364:	90                   	nop
 365:	c9                   	leave  
 366:	c3                   	ret    

00000367 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 367:	55                   	push   %ebp
 368:	89 e5                	mov    %esp,%ebp
 36a:	53                   	push   %ebx
 36b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 36e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 375:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 379:	74 17                	je     392 <printint+0x2b>
 37b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 37f:	79 11                	jns    392 <printint+0x2b>
    neg = 1;
 381:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 388:	8b 45 0c             	mov    0xc(%ebp),%eax
 38b:	f7 d8                	neg    %eax
 38d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 390:	eb 06                	jmp    398 <printint+0x31>
  } else {
    x = xx;
 392:	8b 45 0c             	mov    0xc(%ebp),%eax
 395:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 398:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 39f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3a2:	8d 41 01             	lea    0x1(%ecx),%eax
 3a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ae:	ba 00 00 00 00       	mov    $0x0,%edx
 3b3:	f7 f3                	div    %ebx
 3b5:	89 d0                	mov    %edx,%eax
 3b7:	0f b6 80 28 0a 00 00 	movzbl 0xa28(%eax),%eax
 3be:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3c8:	ba 00 00 00 00       	mov    $0x0,%edx
 3cd:	f7 f3                	div    %ebx
 3cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3d6:	75 c7                	jne    39f <printint+0x38>
  if(neg)
 3d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3dc:	74 2d                	je     40b <printint+0xa4>
    buf[i++] = '-';
 3de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3e1:	8d 50 01             	lea    0x1(%eax),%edx
 3e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3e7:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3ec:	eb 1d                	jmp    40b <printint+0xa4>
    putc(fd, buf[i]);
 3ee:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f4:	01 d0                	add    %edx,%eax
 3f6:	0f b6 00             	movzbl (%eax),%eax
 3f9:	0f be c0             	movsbl %al,%eax
 3fc:	83 ec 08             	sub    $0x8,%esp
 3ff:	50                   	push   %eax
 400:	ff 75 08             	pushl  0x8(%ebp)
 403:	e8 3c ff ff ff       	call   344 <putc>
 408:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 40b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 40f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 413:	79 d9                	jns    3ee <printint+0x87>
    putc(fd, buf[i]);
}
 415:	90                   	nop
 416:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 419:	c9                   	leave  
 41a:	c3                   	ret    

0000041b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 41b:	55                   	push   %ebp
 41c:	89 e5                	mov    %esp,%ebp
 41e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 421:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 428:	8d 45 0c             	lea    0xc(%ebp),%eax
 42b:	83 c0 04             	add    $0x4,%eax
 42e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 431:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 438:	e9 59 01 00 00       	jmp    596 <printf+0x17b>
    c = fmt[i] & 0xff;
 43d:	8b 55 0c             	mov    0xc(%ebp),%edx
 440:	8b 45 f0             	mov    -0x10(%ebp),%eax
 443:	01 d0                	add    %edx,%eax
 445:	0f b6 00             	movzbl (%eax),%eax
 448:	0f be c0             	movsbl %al,%eax
 44b:	25 ff 00 00 00       	and    $0xff,%eax
 450:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 453:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 457:	75 2c                	jne    485 <printf+0x6a>
      if(c == '%'){
 459:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 45d:	75 0c                	jne    46b <printf+0x50>
        state = '%';
 45f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 466:	e9 27 01 00 00       	jmp    592 <printf+0x177>
      } else {
        putc(fd, c);
 46b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 46e:	0f be c0             	movsbl %al,%eax
 471:	83 ec 08             	sub    $0x8,%esp
 474:	50                   	push   %eax
 475:	ff 75 08             	pushl  0x8(%ebp)
 478:	e8 c7 fe ff ff       	call   344 <putc>
 47d:	83 c4 10             	add    $0x10,%esp
 480:	e9 0d 01 00 00       	jmp    592 <printf+0x177>
      }
    } else if(state == '%'){
 485:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 489:	0f 85 03 01 00 00    	jne    592 <printf+0x177>
      if(c == 'd'){
 48f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 493:	75 1e                	jne    4b3 <printf+0x98>
        printint(fd, *ap, 10, 1);
 495:	8b 45 e8             	mov    -0x18(%ebp),%eax
 498:	8b 00                	mov    (%eax),%eax
 49a:	6a 01                	push   $0x1
 49c:	6a 0a                	push   $0xa
 49e:	50                   	push   %eax
 49f:	ff 75 08             	pushl  0x8(%ebp)
 4a2:	e8 c0 fe ff ff       	call   367 <printint>
 4a7:	83 c4 10             	add    $0x10,%esp
        ap++;
 4aa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ae:	e9 d8 00 00 00       	jmp    58b <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4b3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4b7:	74 06                	je     4bf <printf+0xa4>
 4b9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4bd:	75 1e                	jne    4dd <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4c2:	8b 00                	mov    (%eax),%eax
 4c4:	6a 00                	push   $0x0
 4c6:	6a 10                	push   $0x10
 4c8:	50                   	push   %eax
 4c9:	ff 75 08             	pushl  0x8(%ebp)
 4cc:	e8 96 fe ff ff       	call   367 <printint>
 4d1:	83 c4 10             	add    $0x10,%esp
        ap++;
 4d4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4d8:	e9 ae 00 00 00       	jmp    58b <printf+0x170>
      } else if(c == 's'){
 4dd:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4e1:	75 43                	jne    526 <printf+0x10b>
        s = (char*)*ap;
 4e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e6:	8b 00                	mov    (%eax),%eax
 4e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4eb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f3:	75 25                	jne    51a <printf+0xff>
          s = "(null)";
 4f5:	c7 45 f4 d8 07 00 00 	movl   $0x7d8,-0xc(%ebp)
        while(*s != 0){
 4fc:	eb 1c                	jmp    51a <printf+0xff>
          putc(fd, *s);
 4fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 501:	0f b6 00             	movzbl (%eax),%eax
 504:	0f be c0             	movsbl %al,%eax
 507:	83 ec 08             	sub    $0x8,%esp
 50a:	50                   	push   %eax
 50b:	ff 75 08             	pushl  0x8(%ebp)
 50e:	e8 31 fe ff ff       	call   344 <putc>
 513:	83 c4 10             	add    $0x10,%esp
          s++;
 516:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 51a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51d:	0f b6 00             	movzbl (%eax),%eax
 520:	84 c0                	test   %al,%al
 522:	75 da                	jne    4fe <printf+0xe3>
 524:	eb 65                	jmp    58b <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 526:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 52a:	75 1d                	jne    549 <printf+0x12e>
        putc(fd, *ap);
 52c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 52f:	8b 00                	mov    (%eax),%eax
 531:	0f be c0             	movsbl %al,%eax
 534:	83 ec 08             	sub    $0x8,%esp
 537:	50                   	push   %eax
 538:	ff 75 08             	pushl  0x8(%ebp)
 53b:	e8 04 fe ff ff       	call   344 <putc>
 540:	83 c4 10             	add    $0x10,%esp
        ap++;
 543:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 547:	eb 42                	jmp    58b <printf+0x170>
      } else if(c == '%'){
 549:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 54d:	75 17                	jne    566 <printf+0x14b>
        putc(fd, c);
 54f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 552:	0f be c0             	movsbl %al,%eax
 555:	83 ec 08             	sub    $0x8,%esp
 558:	50                   	push   %eax
 559:	ff 75 08             	pushl  0x8(%ebp)
 55c:	e8 e3 fd ff ff       	call   344 <putc>
 561:	83 c4 10             	add    $0x10,%esp
 564:	eb 25                	jmp    58b <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 566:	83 ec 08             	sub    $0x8,%esp
 569:	6a 25                	push   $0x25
 56b:	ff 75 08             	pushl  0x8(%ebp)
 56e:	e8 d1 fd ff ff       	call   344 <putc>
 573:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 576:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 579:	0f be c0             	movsbl %al,%eax
 57c:	83 ec 08             	sub    $0x8,%esp
 57f:	50                   	push   %eax
 580:	ff 75 08             	pushl  0x8(%ebp)
 583:	e8 bc fd ff ff       	call   344 <putc>
 588:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 58b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 592:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 596:	8b 55 0c             	mov    0xc(%ebp),%edx
 599:	8b 45 f0             	mov    -0x10(%ebp),%eax
 59c:	01 d0                	add    %edx,%eax
 59e:	0f b6 00             	movzbl (%eax),%eax
 5a1:	84 c0                	test   %al,%al
 5a3:	0f 85 94 fe ff ff    	jne    43d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5a9:	90                   	nop
 5aa:	c9                   	leave  
 5ab:	c3                   	ret    

000005ac <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5ac:	55                   	push   %ebp
 5ad:	89 e5                	mov    %esp,%ebp
 5af:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5b2:	8b 45 08             	mov    0x8(%ebp),%eax
 5b5:	83 e8 08             	sub    $0x8,%eax
 5b8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5bb:	a1 44 0a 00 00       	mov    0xa44,%eax
 5c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5c3:	eb 24                	jmp    5e9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5c8:	8b 00                	mov    (%eax),%eax
 5ca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5cd:	77 12                	ja     5e1 <free+0x35>
 5cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5d5:	77 24                	ja     5fb <free+0x4f>
 5d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5da:	8b 00                	mov    (%eax),%eax
 5dc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5df:	77 1a                	ja     5fb <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e4:	8b 00                	mov    (%eax),%eax
 5e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5ec:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5ef:	76 d4                	jbe    5c5 <free+0x19>
 5f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f4:	8b 00                	mov    (%eax),%eax
 5f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5f9:	76 ca                	jbe    5c5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5fe:	8b 40 04             	mov    0x4(%eax),%eax
 601:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 608:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60b:	01 c2                	add    %eax,%edx
 60d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 610:	8b 00                	mov    (%eax),%eax
 612:	39 c2                	cmp    %eax,%edx
 614:	75 24                	jne    63a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 616:	8b 45 f8             	mov    -0x8(%ebp),%eax
 619:	8b 50 04             	mov    0x4(%eax),%edx
 61c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61f:	8b 00                	mov    (%eax),%eax
 621:	8b 40 04             	mov    0x4(%eax),%eax
 624:	01 c2                	add    %eax,%edx
 626:	8b 45 f8             	mov    -0x8(%ebp),%eax
 629:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 62c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62f:	8b 00                	mov    (%eax),%eax
 631:	8b 10                	mov    (%eax),%edx
 633:	8b 45 f8             	mov    -0x8(%ebp),%eax
 636:	89 10                	mov    %edx,(%eax)
 638:	eb 0a                	jmp    644 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 63a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63d:	8b 10                	mov    (%eax),%edx
 63f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 642:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 644:	8b 45 fc             	mov    -0x4(%ebp),%eax
 647:	8b 40 04             	mov    0x4(%eax),%eax
 64a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 651:	8b 45 fc             	mov    -0x4(%ebp),%eax
 654:	01 d0                	add    %edx,%eax
 656:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 659:	75 20                	jne    67b <free+0xcf>
    p->s.size += bp->s.size;
 65b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65e:	8b 50 04             	mov    0x4(%eax),%edx
 661:	8b 45 f8             	mov    -0x8(%ebp),%eax
 664:	8b 40 04             	mov    0x4(%eax),%eax
 667:	01 c2                	add    %eax,%edx
 669:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 66f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 672:	8b 10                	mov    (%eax),%edx
 674:	8b 45 fc             	mov    -0x4(%ebp),%eax
 677:	89 10                	mov    %edx,(%eax)
 679:	eb 08                	jmp    683 <free+0xd7>
  } else
    p->s.ptr = bp;
 67b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 681:	89 10                	mov    %edx,(%eax)
  freep = p;
 683:	8b 45 fc             	mov    -0x4(%ebp),%eax
 686:	a3 44 0a 00 00       	mov    %eax,0xa44
}
 68b:	90                   	nop
 68c:	c9                   	leave  
 68d:	c3                   	ret    

0000068e <morecore>:

static Header*
morecore(uint nu)
{
 68e:	55                   	push   %ebp
 68f:	89 e5                	mov    %esp,%ebp
 691:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 694:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 69b:	77 07                	ja     6a4 <morecore+0x16>
    nu = 4096;
 69d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6a4:	8b 45 08             	mov    0x8(%ebp),%eax
 6a7:	c1 e0 03             	shl    $0x3,%eax
 6aa:	83 ec 0c             	sub    $0xc,%esp
 6ad:	50                   	push   %eax
 6ae:	e8 71 fc ff ff       	call   324 <sbrk>
 6b3:	83 c4 10             	add    $0x10,%esp
 6b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6b9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6bd:	75 07                	jne    6c6 <morecore+0x38>
    return 0;
 6bf:	b8 00 00 00 00       	mov    $0x0,%eax
 6c4:	eb 26                	jmp    6ec <morecore+0x5e>
  hp = (Header*)p;
 6c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6cf:	8b 55 08             	mov    0x8(%ebp),%edx
 6d2:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d8:	83 c0 08             	add    $0x8,%eax
 6db:	83 ec 0c             	sub    $0xc,%esp
 6de:	50                   	push   %eax
 6df:	e8 c8 fe ff ff       	call   5ac <free>
 6e4:	83 c4 10             	add    $0x10,%esp
  return freep;
 6e7:	a1 44 0a 00 00       	mov    0xa44,%eax
}
 6ec:	c9                   	leave  
 6ed:	c3                   	ret    

000006ee <malloc>:

void*
malloc(uint nbytes)
{
 6ee:	55                   	push   %ebp
 6ef:	89 e5                	mov    %esp,%ebp
 6f1:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f4:	8b 45 08             	mov    0x8(%ebp),%eax
 6f7:	83 c0 07             	add    $0x7,%eax
 6fa:	c1 e8 03             	shr    $0x3,%eax
 6fd:	83 c0 01             	add    $0x1,%eax
 700:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 703:	a1 44 0a 00 00       	mov    0xa44,%eax
 708:	89 45 f0             	mov    %eax,-0x10(%ebp)
 70b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 70f:	75 23                	jne    734 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 711:	c7 45 f0 3c 0a 00 00 	movl   $0xa3c,-0x10(%ebp)
 718:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71b:	a3 44 0a 00 00       	mov    %eax,0xa44
 720:	a1 44 0a 00 00       	mov    0xa44,%eax
 725:	a3 3c 0a 00 00       	mov    %eax,0xa3c
    base.s.size = 0;
 72a:	c7 05 40 0a 00 00 00 	movl   $0x0,0xa40
 731:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 734:	8b 45 f0             	mov    -0x10(%ebp),%eax
 737:	8b 00                	mov    (%eax),%eax
 739:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 73c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73f:	8b 40 04             	mov    0x4(%eax),%eax
 742:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 745:	72 4d                	jb     794 <malloc+0xa6>
      if(p->s.size == nunits)
 747:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74a:	8b 40 04             	mov    0x4(%eax),%eax
 74d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 750:	75 0c                	jne    75e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 752:	8b 45 f4             	mov    -0xc(%ebp),%eax
 755:	8b 10                	mov    (%eax),%edx
 757:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75a:	89 10                	mov    %edx,(%eax)
 75c:	eb 26                	jmp    784 <malloc+0x96>
      else {
        p->s.size -= nunits;
 75e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 761:	8b 40 04             	mov    0x4(%eax),%eax
 764:	2b 45 ec             	sub    -0x14(%ebp),%eax
 767:	89 c2                	mov    %eax,%edx
 769:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 76f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 772:	8b 40 04             	mov    0x4(%eax),%eax
 775:	c1 e0 03             	shl    $0x3,%eax
 778:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 77b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 781:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 784:	8b 45 f0             	mov    -0x10(%ebp),%eax
 787:	a3 44 0a 00 00       	mov    %eax,0xa44
      return (void*)(p + 1);
 78c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78f:	83 c0 08             	add    $0x8,%eax
 792:	eb 3b                	jmp    7cf <malloc+0xe1>
    }
    if(p == freep)
 794:	a1 44 0a 00 00       	mov    0xa44,%eax
 799:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 79c:	75 1e                	jne    7bc <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 79e:	83 ec 0c             	sub    $0xc,%esp
 7a1:	ff 75 ec             	pushl  -0x14(%ebp)
 7a4:	e8 e5 fe ff ff       	call   68e <morecore>
 7a9:	83 c4 10             	add    $0x10,%esp
 7ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7b3:	75 07                	jne    7bc <malloc+0xce>
        return 0;
 7b5:	b8 00 00 00 00       	mov    $0x0,%eax
 7ba:	eb 13                	jmp    7cf <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c5:	8b 00                	mov    (%eax),%eax
 7c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7ca:	e9 6d ff ff ff       	jmp    73c <malloc+0x4e>
}
 7cf:	c9                   	leave  
 7d0:	c3                   	ret    
