
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  11:	83 ec 08             	sub    $0x8,%esp
  14:	6a 02                	push   $0x2
  16:	68 65 08 00 00       	push   $0x865
  1b:	e8 4d 03 00 00       	call   36d <open>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	79 26                	jns    4d <main+0x4d>
    mknod("console", 1, 1);
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	6a 01                	push   $0x1
  2c:	6a 01                	push   $0x1
  2e:	68 65 08 00 00       	push   $0x865
  33:	e8 3d 03 00 00       	call   375 <mknod>
  38:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	6a 02                	push   $0x2
  40:	68 65 08 00 00       	push   $0x865
  45:	e8 23 03 00 00       	call   36d <open>
  4a:	83 c4 10             	add    $0x10,%esp
  }
  dup(0);  // stdout
  4d:	83 ec 0c             	sub    $0xc,%esp
  50:	6a 00                	push   $0x0
  52:	e8 4e 03 00 00       	call   3a5 <dup>
  57:	83 c4 10             	add    $0x10,%esp
  dup(0);  // stderr
  5a:	83 ec 0c             	sub    $0xc,%esp
  5d:	6a 00                	push   $0x0
  5f:	e8 41 03 00 00       	call   3a5 <dup>
  64:	83 c4 10             	add    $0x10,%esp


  for(;;){
    pid = fork();
  67:	e8 b9 02 00 00       	call   325 <fork>
  6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
  6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  73:	79 17                	jns    8c <main+0x8c>
      printf(1, "init: fork failed\n");
  75:	83 ec 08             	sub    $0x8,%esp
  78:	68 6d 08 00 00       	push   $0x86d
  7d:	6a 01                	push   $0x1
  7f:	e8 28 04 00 00       	call   4ac <printf>
  84:	83 c4 10             	add    $0x10,%esp
      exit();
  87:	e8 a1 02 00 00       	call   32d <exit>
    }
    if(pid == 0){
  8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  90:	75 2c                	jne    be <main+0xbe>
      exec("sh", argv);
  92:	83 ec 08             	sub    $0x8,%esp
  95:	68 e8 0a 00 00       	push   $0xae8
  9a:	68 62 08 00 00       	push   $0x862
  9f:	e8 c1 02 00 00       	call   365 <exec>
  a4:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
  a7:	83 ec 08             	sub    $0x8,%esp
  aa:	68 80 08 00 00       	push   $0x880
  af:	6a 01                	push   $0x1
  b1:	e8 f6 03 00 00       	call   4ac <printf>
  b6:	83 c4 10             	add    $0x10,%esp
      exit();
  b9:	e8 6f 02 00 00       	call   32d <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid);
  be:	e8 72 02 00 00       	call   335 <wait>
  c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  ca:	78 9b                	js     67 <main+0x67>
  cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  d2:	75 ea                	jne    be <main+0xbe>
  }
  d4:	eb 91                	jmp    67 <main+0x67>

000000d6 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  d6:	55                   	push   %ebp
  d7:	89 e5                	mov    %esp,%ebp
  d9:	57                   	push   %edi
  da:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  de:	8b 55 10             	mov    0x10(%ebp),%edx
  e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  e4:	89 cb                	mov    %ecx,%ebx
  e6:	89 df                	mov    %ebx,%edi
  e8:	89 d1                	mov    %edx,%ecx
  ea:	fc                   	cld    
  eb:	f3 aa                	rep stos %al,%es:(%edi)
  ed:	89 ca                	mov    %ecx,%edx
  ef:	89 fb                	mov    %edi,%ebx
  f1:	89 5d 08             	mov    %ebx,0x8(%ebp)
  f4:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  f7:	90                   	nop
  f8:	5b                   	pop    %ebx
  f9:	5f                   	pop    %edi
  fa:	5d                   	pop    %ebp
  fb:	c3                   	ret    

000000fc <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  ff:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 102:	8b 45 08             	mov    0x8(%ebp),%eax
 105:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 108:	90                   	nop
 109:	8b 45 08             	mov    0x8(%ebp),%eax
 10c:	8d 50 01             	lea    0x1(%eax),%edx
 10f:	89 55 08             	mov    %edx,0x8(%ebp)
 112:	8b 55 0c             	mov    0xc(%ebp),%edx
 115:	8d 4a 01             	lea    0x1(%edx),%ecx
 118:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 11b:	0f b6 12             	movzbl (%edx),%edx
 11e:	88 10                	mov    %dl,(%eax)
 120:	0f b6 00             	movzbl (%eax),%eax
 123:	84 c0                	test   %al,%al
 125:	75 e2                	jne    109 <strcpy+0xd>
    ;
  return os;
 127:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12a:	c9                   	leave  
 12b:	c3                   	ret    

0000012c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12c:	55                   	push   %ebp
 12d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 12f:	eb 08                	jmp    139 <strcmp+0xd>
    p++, q++;
 131:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 135:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 139:	8b 45 08             	mov    0x8(%ebp),%eax
 13c:	0f b6 00             	movzbl (%eax),%eax
 13f:	84 c0                	test   %al,%al
 141:	74 10                	je     153 <strcmp+0x27>
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	0f b6 10             	movzbl (%eax),%edx
 149:	8b 45 0c             	mov    0xc(%ebp),%eax
 14c:	0f b6 00             	movzbl (%eax),%eax
 14f:	38 c2                	cmp    %al,%dl
 151:	74 de                	je     131 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	0f b6 00             	movzbl (%eax),%eax
 159:	0f b6 d0             	movzbl %al,%edx
 15c:	8b 45 0c             	mov    0xc(%ebp),%eax
 15f:	0f b6 00             	movzbl (%eax),%eax
 162:	0f b6 c0             	movzbl %al,%eax
 165:	29 c2                	sub    %eax,%edx
 167:	89 d0                	mov    %edx,%eax
}
 169:	5d                   	pop    %ebp
 16a:	c3                   	ret    

0000016b <strlen>:

uint
strlen(char *s)
{
 16b:	55                   	push   %ebp
 16c:	89 e5                	mov    %esp,%ebp
 16e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 171:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 178:	eb 04                	jmp    17e <strlen+0x13>
 17a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 17e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 181:	8b 45 08             	mov    0x8(%ebp),%eax
 184:	01 d0                	add    %edx,%eax
 186:	0f b6 00             	movzbl (%eax),%eax
 189:	84 c0                	test   %al,%al
 18b:	75 ed                	jne    17a <strlen+0xf>
    ;
  return n;
 18d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 190:	c9                   	leave  
 191:	c3                   	ret    

00000192 <memset>:

void*
memset(void *dst, int c, uint n)
{
 192:	55                   	push   %ebp
 193:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 195:	8b 45 10             	mov    0x10(%ebp),%eax
 198:	50                   	push   %eax
 199:	ff 75 0c             	pushl  0xc(%ebp)
 19c:	ff 75 08             	pushl  0x8(%ebp)
 19f:	e8 32 ff ff ff       	call   d6 <stosb>
 1a4:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1aa:	c9                   	leave  
 1ab:	c3                   	ret    

000001ac <strchr>:

char*
strchr(const char *s, char c)
{
 1ac:	55                   	push   %ebp
 1ad:	89 e5                	mov    %esp,%ebp
 1af:	83 ec 04             	sub    $0x4,%esp
 1b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b5:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1b8:	eb 14                	jmp    1ce <strchr+0x22>
    if(*s == c)
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	0f b6 00             	movzbl (%eax),%eax
 1c0:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1c3:	75 05                	jne    1ca <strchr+0x1e>
      return (char*)s;
 1c5:	8b 45 08             	mov    0x8(%ebp),%eax
 1c8:	eb 13                	jmp    1dd <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1ca:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1ce:	8b 45 08             	mov    0x8(%ebp),%eax
 1d1:	0f b6 00             	movzbl (%eax),%eax
 1d4:	84 c0                	test   %al,%al
 1d6:	75 e2                	jne    1ba <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1dd:	c9                   	leave  
 1de:	c3                   	ret    

000001df <gets>:

char*
gets(char *buf, int max)
{
 1df:	55                   	push   %ebp
 1e0:	89 e5                	mov    %esp,%ebp
 1e2:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1ec:	eb 42                	jmp    230 <gets+0x51>
    cc = read(0, &c, 1);
 1ee:	83 ec 04             	sub    $0x4,%esp
 1f1:	6a 01                	push   $0x1
 1f3:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1f6:	50                   	push   %eax
 1f7:	6a 00                	push   $0x0
 1f9:	e8 47 01 00 00       	call   345 <read>
 1fe:	83 c4 10             	add    $0x10,%esp
 201:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 204:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 208:	7e 33                	jle    23d <gets+0x5e>
      break;
    buf[i++] = c;
 20a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 20d:	8d 50 01             	lea    0x1(%eax),%edx
 210:	89 55 f4             	mov    %edx,-0xc(%ebp)
 213:	89 c2                	mov    %eax,%edx
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	01 c2                	add    %eax,%edx
 21a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 21e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 220:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 224:	3c 0a                	cmp    $0xa,%al
 226:	74 16                	je     23e <gets+0x5f>
 228:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 22c:	3c 0d                	cmp    $0xd,%al
 22e:	74 0e                	je     23e <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 230:	8b 45 f4             	mov    -0xc(%ebp),%eax
 233:	83 c0 01             	add    $0x1,%eax
 236:	3b 45 0c             	cmp    0xc(%ebp),%eax
 239:	7c b3                	jl     1ee <gets+0xf>
 23b:	eb 01                	jmp    23e <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 23d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 23e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	01 d0                	add    %edx,%eax
 246:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 249:	8b 45 08             	mov    0x8(%ebp),%eax
}
 24c:	c9                   	leave  
 24d:	c3                   	ret    

0000024e <stat>:

int
stat(char *n, struct stat *st)
{
 24e:	55                   	push   %ebp
 24f:	89 e5                	mov    %esp,%ebp
 251:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 254:	83 ec 08             	sub    $0x8,%esp
 257:	6a 00                	push   $0x0
 259:	ff 75 08             	pushl  0x8(%ebp)
 25c:	e8 0c 01 00 00       	call   36d <open>
 261:	83 c4 10             	add    $0x10,%esp
 264:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 267:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 26b:	79 07                	jns    274 <stat+0x26>
    return -1;
 26d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 272:	eb 25                	jmp    299 <stat+0x4b>
  r = fstat(fd, st);
 274:	83 ec 08             	sub    $0x8,%esp
 277:	ff 75 0c             	pushl  0xc(%ebp)
 27a:	ff 75 f4             	pushl  -0xc(%ebp)
 27d:	e8 03 01 00 00       	call   385 <fstat>
 282:	83 c4 10             	add    $0x10,%esp
 285:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 288:	83 ec 0c             	sub    $0xc,%esp
 28b:	ff 75 f4             	pushl  -0xc(%ebp)
 28e:	e8 c2 00 00 00       	call   355 <close>
 293:	83 c4 10             	add    $0x10,%esp
  return r;
 296:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 299:	c9                   	leave  
 29a:	c3                   	ret    

0000029b <atoi>:

int
atoi(const char *s)
{
 29b:	55                   	push   %ebp
 29c:	89 e5                	mov    %esp,%ebp
 29e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2a8:	eb 25                	jmp    2cf <atoi+0x34>
    n = n*10 + *s++ - '0';
 2aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2ad:	89 d0                	mov    %edx,%eax
 2af:	c1 e0 02             	shl    $0x2,%eax
 2b2:	01 d0                	add    %edx,%eax
 2b4:	01 c0                	add    %eax,%eax
 2b6:	89 c1                	mov    %eax,%ecx
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	8d 50 01             	lea    0x1(%eax),%edx
 2be:	89 55 08             	mov    %edx,0x8(%ebp)
 2c1:	0f b6 00             	movzbl (%eax),%eax
 2c4:	0f be c0             	movsbl %al,%eax
 2c7:	01 c8                	add    %ecx,%eax
 2c9:	83 e8 30             	sub    $0x30,%eax
 2cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
 2d2:	0f b6 00             	movzbl (%eax),%eax
 2d5:	3c 2f                	cmp    $0x2f,%al
 2d7:	7e 0a                	jle    2e3 <atoi+0x48>
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	0f b6 00             	movzbl (%eax),%eax
 2df:	3c 39                	cmp    $0x39,%al
 2e1:	7e c7                	jle    2aa <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2e6:	c9                   	leave  
 2e7:	c3                   	ret    

000002e8 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2e8:	55                   	push   %ebp
 2e9:	89 e5                	mov    %esp,%ebp
 2eb:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2ee:	8b 45 08             	mov    0x8(%ebp),%eax
 2f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2fa:	eb 17                	jmp    313 <memmove+0x2b>
    *dst++ = *src++;
 2fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2ff:	8d 50 01             	lea    0x1(%eax),%edx
 302:	89 55 fc             	mov    %edx,-0x4(%ebp)
 305:	8b 55 f8             	mov    -0x8(%ebp),%edx
 308:	8d 4a 01             	lea    0x1(%edx),%ecx
 30b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 30e:	0f b6 12             	movzbl (%edx),%edx
 311:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 313:	8b 45 10             	mov    0x10(%ebp),%eax
 316:	8d 50 ff             	lea    -0x1(%eax),%edx
 319:	89 55 10             	mov    %edx,0x10(%ebp)
 31c:	85 c0                	test   %eax,%eax
 31e:	7f dc                	jg     2fc <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 320:	8b 45 08             	mov    0x8(%ebp),%eax
}
 323:	c9                   	leave  
 324:	c3                   	ret    

00000325 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 325:	b8 01 00 00 00       	mov    $0x1,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <exit>:
SYSCALL(exit)
 32d:	b8 02 00 00 00       	mov    $0x2,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <wait>:
SYSCALL(wait)
 335:	b8 03 00 00 00       	mov    $0x3,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <pipe>:
SYSCALL(pipe)
 33d:	b8 04 00 00 00       	mov    $0x4,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <read>:
SYSCALL(read)
 345:	b8 05 00 00 00       	mov    $0x5,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <write>:
SYSCALL(write)
 34d:	b8 10 00 00 00       	mov    $0x10,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <close>:
SYSCALL(close)
 355:	b8 15 00 00 00       	mov    $0x15,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <kill>:
SYSCALL(kill)
 35d:	b8 06 00 00 00       	mov    $0x6,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <exec>:
SYSCALL(exec)
 365:	b8 07 00 00 00       	mov    $0x7,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <open>:
SYSCALL(open)
 36d:	b8 0f 00 00 00       	mov    $0xf,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <mknod>:
SYSCALL(mknod)
 375:	b8 11 00 00 00       	mov    $0x11,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <unlink>:
SYSCALL(unlink)
 37d:	b8 12 00 00 00       	mov    $0x12,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <fstat>:
SYSCALL(fstat)
 385:	b8 08 00 00 00       	mov    $0x8,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <link>:
SYSCALL(link)
 38d:	b8 13 00 00 00       	mov    $0x13,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <mkdir>:
SYSCALL(mkdir)
 395:	b8 14 00 00 00       	mov    $0x14,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <chdir>:
SYSCALL(chdir)
 39d:	b8 09 00 00 00       	mov    $0x9,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <dup>:
SYSCALL(dup)
 3a5:	b8 0a 00 00 00       	mov    $0xa,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <getpid>:
SYSCALL(getpid)
 3ad:	b8 0b 00 00 00       	mov    $0xb,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <sbrk>:
SYSCALL(sbrk)
 3b5:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <sleep>:
SYSCALL(sleep)
 3bd:	b8 0d 00 00 00       	mov    $0xd,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <uptime>:
SYSCALL(uptime)
 3c5:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <halt>:
SYSCALL(halt)
 3cd:	b8 16 00 00 00       	mov    $0x16,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3d5:	55                   	push   %ebp
 3d6:	89 e5                	mov    %esp,%ebp
 3d8:	83 ec 18             	sub    $0x18,%esp
 3db:	8b 45 0c             	mov    0xc(%ebp),%eax
 3de:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3e1:	83 ec 04             	sub    $0x4,%esp
 3e4:	6a 01                	push   $0x1
 3e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3e9:	50                   	push   %eax
 3ea:	ff 75 08             	pushl  0x8(%ebp)
 3ed:	e8 5b ff ff ff       	call   34d <write>
 3f2:	83 c4 10             	add    $0x10,%esp
}
 3f5:	90                   	nop
 3f6:	c9                   	leave  
 3f7:	c3                   	ret    

000003f8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f8:	55                   	push   %ebp
 3f9:	89 e5                	mov    %esp,%ebp
 3fb:	53                   	push   %ebx
 3fc:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 406:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 40a:	74 17                	je     423 <printint+0x2b>
 40c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 410:	79 11                	jns    423 <printint+0x2b>
    neg = 1;
 412:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 419:	8b 45 0c             	mov    0xc(%ebp),%eax
 41c:	f7 d8                	neg    %eax
 41e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 421:	eb 06                	jmp    429 <printint+0x31>
  } else {
    x = xx;
 423:	8b 45 0c             	mov    0xc(%ebp),%eax
 426:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 429:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 430:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 433:	8d 41 01             	lea    0x1(%ecx),%eax
 436:	89 45 f4             	mov    %eax,-0xc(%ebp)
 439:	8b 5d 10             	mov    0x10(%ebp),%ebx
 43c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 43f:	ba 00 00 00 00       	mov    $0x0,%edx
 444:	f7 f3                	div    %ebx
 446:	89 d0                	mov    %edx,%eax
 448:	0f b6 80 f0 0a 00 00 	movzbl 0xaf0(%eax),%eax
 44f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 453:	8b 5d 10             	mov    0x10(%ebp),%ebx
 456:	8b 45 ec             	mov    -0x14(%ebp),%eax
 459:	ba 00 00 00 00       	mov    $0x0,%edx
 45e:	f7 f3                	div    %ebx
 460:	89 45 ec             	mov    %eax,-0x14(%ebp)
 463:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 467:	75 c7                	jne    430 <printint+0x38>
  if(neg)
 469:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 46d:	74 2d                	je     49c <printint+0xa4>
    buf[i++] = '-';
 46f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 472:	8d 50 01             	lea    0x1(%eax),%edx
 475:	89 55 f4             	mov    %edx,-0xc(%ebp)
 478:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 47d:	eb 1d                	jmp    49c <printint+0xa4>
    putc(fd, buf[i]);
 47f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 482:	8b 45 f4             	mov    -0xc(%ebp),%eax
 485:	01 d0                	add    %edx,%eax
 487:	0f b6 00             	movzbl (%eax),%eax
 48a:	0f be c0             	movsbl %al,%eax
 48d:	83 ec 08             	sub    $0x8,%esp
 490:	50                   	push   %eax
 491:	ff 75 08             	pushl  0x8(%ebp)
 494:	e8 3c ff ff ff       	call   3d5 <putc>
 499:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 49c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4a4:	79 d9                	jns    47f <printint+0x87>
    putc(fd, buf[i]);
}
 4a6:	90                   	nop
 4a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4aa:	c9                   	leave  
 4ab:	c3                   	ret    

000004ac <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4ac:	55                   	push   %ebp
 4ad:	89 e5                	mov    %esp,%ebp
 4af:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4b2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4b9:	8d 45 0c             	lea    0xc(%ebp),%eax
 4bc:	83 c0 04             	add    $0x4,%eax
 4bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4c9:	e9 59 01 00 00       	jmp    627 <printf+0x17b>
    c = fmt[i] & 0xff;
 4ce:	8b 55 0c             	mov    0xc(%ebp),%edx
 4d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4d4:	01 d0                	add    %edx,%eax
 4d6:	0f b6 00             	movzbl (%eax),%eax
 4d9:	0f be c0             	movsbl %al,%eax
 4dc:	25 ff 00 00 00       	and    $0xff,%eax
 4e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e8:	75 2c                	jne    516 <printf+0x6a>
      if(c == '%'){
 4ea:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4ee:	75 0c                	jne    4fc <printf+0x50>
        state = '%';
 4f0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4f7:	e9 27 01 00 00       	jmp    623 <printf+0x177>
      } else {
        putc(fd, c);
 4fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4ff:	0f be c0             	movsbl %al,%eax
 502:	83 ec 08             	sub    $0x8,%esp
 505:	50                   	push   %eax
 506:	ff 75 08             	pushl  0x8(%ebp)
 509:	e8 c7 fe ff ff       	call   3d5 <putc>
 50e:	83 c4 10             	add    $0x10,%esp
 511:	e9 0d 01 00 00       	jmp    623 <printf+0x177>
      }
    } else if(state == '%'){
 516:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 51a:	0f 85 03 01 00 00    	jne    623 <printf+0x177>
      if(c == 'd'){
 520:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 524:	75 1e                	jne    544 <printf+0x98>
        printint(fd, *ap, 10, 1);
 526:	8b 45 e8             	mov    -0x18(%ebp),%eax
 529:	8b 00                	mov    (%eax),%eax
 52b:	6a 01                	push   $0x1
 52d:	6a 0a                	push   $0xa
 52f:	50                   	push   %eax
 530:	ff 75 08             	pushl  0x8(%ebp)
 533:	e8 c0 fe ff ff       	call   3f8 <printint>
 538:	83 c4 10             	add    $0x10,%esp
        ap++;
 53b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 53f:	e9 d8 00 00 00       	jmp    61c <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 544:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 548:	74 06                	je     550 <printf+0xa4>
 54a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 54e:	75 1e                	jne    56e <printf+0xc2>
        printint(fd, *ap, 16, 0);
 550:	8b 45 e8             	mov    -0x18(%ebp),%eax
 553:	8b 00                	mov    (%eax),%eax
 555:	6a 00                	push   $0x0
 557:	6a 10                	push   $0x10
 559:	50                   	push   %eax
 55a:	ff 75 08             	pushl  0x8(%ebp)
 55d:	e8 96 fe ff ff       	call   3f8 <printint>
 562:	83 c4 10             	add    $0x10,%esp
        ap++;
 565:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 569:	e9 ae 00 00 00       	jmp    61c <printf+0x170>
      } else if(c == 's'){
 56e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 572:	75 43                	jne    5b7 <printf+0x10b>
        s = (char*)*ap;
 574:	8b 45 e8             	mov    -0x18(%ebp),%eax
 577:	8b 00                	mov    (%eax),%eax
 579:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 57c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 580:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 584:	75 25                	jne    5ab <printf+0xff>
          s = "(null)";
 586:	c7 45 f4 96 08 00 00 	movl   $0x896,-0xc(%ebp)
        while(*s != 0){
 58d:	eb 1c                	jmp    5ab <printf+0xff>
          putc(fd, *s);
 58f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 592:	0f b6 00             	movzbl (%eax),%eax
 595:	0f be c0             	movsbl %al,%eax
 598:	83 ec 08             	sub    $0x8,%esp
 59b:	50                   	push   %eax
 59c:	ff 75 08             	pushl  0x8(%ebp)
 59f:	e8 31 fe ff ff       	call   3d5 <putc>
 5a4:	83 c4 10             	add    $0x10,%esp
          s++;
 5a7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ae:	0f b6 00             	movzbl (%eax),%eax
 5b1:	84 c0                	test   %al,%al
 5b3:	75 da                	jne    58f <printf+0xe3>
 5b5:	eb 65                	jmp    61c <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5b7:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5bb:	75 1d                	jne    5da <printf+0x12e>
        putc(fd, *ap);
 5bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c0:	8b 00                	mov    (%eax),%eax
 5c2:	0f be c0             	movsbl %al,%eax
 5c5:	83 ec 08             	sub    $0x8,%esp
 5c8:	50                   	push   %eax
 5c9:	ff 75 08             	pushl  0x8(%ebp)
 5cc:	e8 04 fe ff ff       	call   3d5 <putc>
 5d1:	83 c4 10             	add    $0x10,%esp
        ap++;
 5d4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d8:	eb 42                	jmp    61c <printf+0x170>
      } else if(c == '%'){
 5da:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5de:	75 17                	jne    5f7 <printf+0x14b>
        putc(fd, c);
 5e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e3:	0f be c0             	movsbl %al,%eax
 5e6:	83 ec 08             	sub    $0x8,%esp
 5e9:	50                   	push   %eax
 5ea:	ff 75 08             	pushl  0x8(%ebp)
 5ed:	e8 e3 fd ff ff       	call   3d5 <putc>
 5f2:	83 c4 10             	add    $0x10,%esp
 5f5:	eb 25                	jmp    61c <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5f7:	83 ec 08             	sub    $0x8,%esp
 5fa:	6a 25                	push   $0x25
 5fc:	ff 75 08             	pushl  0x8(%ebp)
 5ff:	e8 d1 fd ff ff       	call   3d5 <putc>
 604:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 60a:	0f be c0             	movsbl %al,%eax
 60d:	83 ec 08             	sub    $0x8,%esp
 610:	50                   	push   %eax
 611:	ff 75 08             	pushl  0x8(%ebp)
 614:	e8 bc fd ff ff       	call   3d5 <putc>
 619:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 61c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 623:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 627:	8b 55 0c             	mov    0xc(%ebp),%edx
 62a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 62d:	01 d0                	add    %edx,%eax
 62f:	0f b6 00             	movzbl (%eax),%eax
 632:	84 c0                	test   %al,%al
 634:	0f 85 94 fe ff ff    	jne    4ce <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 63a:	90                   	nop
 63b:	c9                   	leave  
 63c:	c3                   	ret    

0000063d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 63d:	55                   	push   %ebp
 63e:	89 e5                	mov    %esp,%ebp
 640:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 643:	8b 45 08             	mov    0x8(%ebp),%eax
 646:	83 e8 08             	sub    $0x8,%eax
 649:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64c:	a1 0c 0b 00 00       	mov    0xb0c,%eax
 651:	89 45 fc             	mov    %eax,-0x4(%ebp)
 654:	eb 24                	jmp    67a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 656:	8b 45 fc             	mov    -0x4(%ebp),%eax
 659:	8b 00                	mov    (%eax),%eax
 65b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65e:	77 12                	ja     672 <free+0x35>
 660:	8b 45 f8             	mov    -0x8(%ebp),%eax
 663:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 666:	77 24                	ja     68c <free+0x4f>
 668:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66b:	8b 00                	mov    (%eax),%eax
 66d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 670:	77 1a                	ja     68c <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 672:	8b 45 fc             	mov    -0x4(%ebp),%eax
 675:	8b 00                	mov    (%eax),%eax
 677:	89 45 fc             	mov    %eax,-0x4(%ebp)
 67a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 680:	76 d4                	jbe    656 <free+0x19>
 682:	8b 45 fc             	mov    -0x4(%ebp),%eax
 685:	8b 00                	mov    (%eax),%eax
 687:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 68a:	76 ca                	jbe    656 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 68c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68f:	8b 40 04             	mov    0x4(%eax),%eax
 692:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 699:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69c:	01 c2                	add    %eax,%edx
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	8b 00                	mov    (%eax),%eax
 6a3:	39 c2                	cmp    %eax,%edx
 6a5:	75 24                	jne    6cb <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6aa:	8b 50 04             	mov    0x4(%eax),%edx
 6ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b0:	8b 00                	mov    (%eax),%eax
 6b2:	8b 40 04             	mov    0x4(%eax),%eax
 6b5:	01 c2                	add    %eax,%edx
 6b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ba:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	8b 00                	mov    (%eax),%eax
 6c2:	8b 10                	mov    (%eax),%edx
 6c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c7:	89 10                	mov    %edx,(%eax)
 6c9:	eb 0a                	jmp    6d5 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ce:	8b 10                	mov    (%eax),%edx
 6d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	8b 40 04             	mov    0x4(%eax),%eax
 6db:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e5:	01 d0                	add    %edx,%eax
 6e7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ea:	75 20                	jne    70c <free+0xcf>
    p->s.size += bp->s.size;
 6ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ef:	8b 50 04             	mov    0x4(%eax),%edx
 6f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f5:	8b 40 04             	mov    0x4(%eax),%eax
 6f8:	01 c2                	add    %eax,%edx
 6fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fd:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 700:	8b 45 f8             	mov    -0x8(%ebp),%eax
 703:	8b 10                	mov    (%eax),%edx
 705:	8b 45 fc             	mov    -0x4(%ebp),%eax
 708:	89 10                	mov    %edx,(%eax)
 70a:	eb 08                	jmp    714 <free+0xd7>
  } else
    p->s.ptr = bp;
 70c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 712:	89 10                	mov    %edx,(%eax)
  freep = p;
 714:	8b 45 fc             	mov    -0x4(%ebp),%eax
 717:	a3 0c 0b 00 00       	mov    %eax,0xb0c
}
 71c:	90                   	nop
 71d:	c9                   	leave  
 71e:	c3                   	ret    

0000071f <morecore>:

static Header*
morecore(uint nu)
{
 71f:	55                   	push   %ebp
 720:	89 e5                	mov    %esp,%ebp
 722:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 725:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 72c:	77 07                	ja     735 <morecore+0x16>
    nu = 4096;
 72e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 735:	8b 45 08             	mov    0x8(%ebp),%eax
 738:	c1 e0 03             	shl    $0x3,%eax
 73b:	83 ec 0c             	sub    $0xc,%esp
 73e:	50                   	push   %eax
 73f:	e8 71 fc ff ff       	call   3b5 <sbrk>
 744:	83 c4 10             	add    $0x10,%esp
 747:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 74a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 74e:	75 07                	jne    757 <morecore+0x38>
    return 0;
 750:	b8 00 00 00 00       	mov    $0x0,%eax
 755:	eb 26                	jmp    77d <morecore+0x5e>
  hp = (Header*)p;
 757:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 75d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 760:	8b 55 08             	mov    0x8(%ebp),%edx
 763:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 766:	8b 45 f0             	mov    -0x10(%ebp),%eax
 769:	83 c0 08             	add    $0x8,%eax
 76c:	83 ec 0c             	sub    $0xc,%esp
 76f:	50                   	push   %eax
 770:	e8 c8 fe ff ff       	call   63d <free>
 775:	83 c4 10             	add    $0x10,%esp
  return freep;
 778:	a1 0c 0b 00 00       	mov    0xb0c,%eax
}
 77d:	c9                   	leave  
 77e:	c3                   	ret    

0000077f <malloc>:

void*
malloc(uint nbytes)
{
 77f:	55                   	push   %ebp
 780:	89 e5                	mov    %esp,%ebp
 782:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 785:	8b 45 08             	mov    0x8(%ebp),%eax
 788:	83 c0 07             	add    $0x7,%eax
 78b:	c1 e8 03             	shr    $0x3,%eax
 78e:	83 c0 01             	add    $0x1,%eax
 791:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 794:	a1 0c 0b 00 00       	mov    0xb0c,%eax
 799:	89 45 f0             	mov    %eax,-0x10(%ebp)
 79c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7a0:	75 23                	jne    7c5 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7a2:	c7 45 f0 04 0b 00 00 	movl   $0xb04,-0x10(%ebp)
 7a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ac:	a3 0c 0b 00 00       	mov    %eax,0xb0c
 7b1:	a1 0c 0b 00 00       	mov    0xb0c,%eax
 7b6:	a3 04 0b 00 00       	mov    %eax,0xb04
    base.s.size = 0;
 7bb:	c7 05 08 0b 00 00 00 	movl   $0x0,0xb08
 7c2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c8:	8b 00                	mov    (%eax),%eax
 7ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d0:	8b 40 04             	mov    0x4(%eax),%eax
 7d3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7d6:	72 4d                	jb     825 <malloc+0xa6>
      if(p->s.size == nunits)
 7d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7db:	8b 40 04             	mov    0x4(%eax),%eax
 7de:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7e1:	75 0c                	jne    7ef <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e6:	8b 10                	mov    (%eax),%edx
 7e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7eb:	89 10                	mov    %edx,(%eax)
 7ed:	eb 26                	jmp    815 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f2:	8b 40 04             	mov    0x4(%eax),%eax
 7f5:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7f8:	89 c2                	mov    %eax,%edx
 7fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fd:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 800:	8b 45 f4             	mov    -0xc(%ebp),%eax
 803:	8b 40 04             	mov    0x4(%eax),%eax
 806:	c1 e0 03             	shl    $0x3,%eax
 809:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 80c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 812:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 815:	8b 45 f0             	mov    -0x10(%ebp),%eax
 818:	a3 0c 0b 00 00       	mov    %eax,0xb0c
      return (void*)(p + 1);
 81d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 820:	83 c0 08             	add    $0x8,%eax
 823:	eb 3b                	jmp    860 <malloc+0xe1>
    }
    if(p == freep)
 825:	a1 0c 0b 00 00       	mov    0xb0c,%eax
 82a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 82d:	75 1e                	jne    84d <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 82f:	83 ec 0c             	sub    $0xc,%esp
 832:	ff 75 ec             	pushl  -0x14(%ebp)
 835:	e8 e5 fe ff ff       	call   71f <morecore>
 83a:	83 c4 10             	add    $0x10,%esp
 83d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 840:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 844:	75 07                	jne    84d <malloc+0xce>
        return 0;
 846:	b8 00 00 00 00       	mov    $0x0,%eax
 84b:	eb 13                	jmp    860 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 850:	89 45 f0             	mov    %eax,-0x10(%ebp)
 853:	8b 45 f4             	mov    -0xc(%ebp),%eax
 856:	8b 00                	mov    (%eax),%eax
 858:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 85b:	e9 6d ff ff ff       	jmp    7cd <malloc+0x4e>
}
 860:	c9                   	leave  
 861:	c3                   	ret    
