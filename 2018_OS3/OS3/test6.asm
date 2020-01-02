
_test6:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "syscall.h"
#include "traps.h"
#include "memlayout.h"
#define num 100 //1981까지 되고 1982부터는 Page Fault
int main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	81 ec a4 01 00 00    	sub    $0x1a4,%esp
	int stack[num];

	stack[-19000]=1;
  14:	c7 85 7c d5 fe ff 01 	movl   $0x1,-0x12a84(%ebp)
  1b:	00 00 00 
	int *heap, *heap2;
	heap = (int *)malloc(sizeof(int)*num);
  1e:	83 ec 0c             	sub    $0xc,%esp
  21:	68 90 01 00 00       	push   $0x190
  26:	e8 8a 07 00 00       	call   7b5 <malloc>
  2b:	83 c4 10             	add    $0x10,%esp
  2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	heap2 = (int *)malloc(sizeof(int)*num);
  31:	83 ec 0c             	sub    $0xc,%esp
  34:	68 90 01 00 00       	push   $0x190
  39:	e8 77 07 00 00       	call   7b5 <malloc>
  3e:	83 c4 10             	add    $0x10,%esp
  41:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int i=0;
  44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(i=0;i<num;i++) {
  4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  52:	eb 3c                	jmp    90 <main+0x90>
		heap[i] = i;
  54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  57:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  61:	01 c2                	add    %eax,%edx
  63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  66:	89 02                	mov    %eax,(%edx)
		heap2[i] = i;
  68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  6b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  75:	01 c2                	add    %eax,%edx
  77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  7a:	89 02                	mov    %eax,(%edx)
		stack[i] = 10+i;
  7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  7f:	8d 50 0a             	lea    0xa(%eax),%edx
  82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  85:	89 94 85 5c fe ff ff 	mov    %edx,-0x1a4(%ebp,%eax,4)
	stack[-19000]=1;
	int *heap, *heap2;
	heap = (int *)malloc(sizeof(int)*num);
	heap2 = (int *)malloc(sizeof(int)*num);
	int i=0;
	for(i=0;i<num;i++) {
  8c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  90:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  94:	7e be                	jle    54 <main+0x54>
		heap[i] = i;
		heap2[i] = i;
		stack[i] = 10+i;
	}
	//printf(1, "[%p %p %p]\n",main,stack,heap);
	for(i=0;i<num;i++){
  96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  9d:	eb 62                	jmp    101 <main+0x101>
		if(i == 0)
  9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a3:	75 29                	jne    ce <main+0xce>
			printf(1, "[1 : %d %p]\n", stack[i], &stack[i]);
  a5:	8d 85 5c fe ff ff    	lea    -0x1a4(%ebp),%eax
  ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ae:	c1 e2 02             	shl    $0x2,%edx
  b1:	01 c2                	add    %eax,%edx
  b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  b6:	8b 84 85 5c fe ff ff 	mov    -0x1a4(%ebp,%eax,4),%eax
  bd:	52                   	push   %edx
  be:	50                   	push   %eax
  bf:	68 98 08 00 00       	push   $0x898
  c4:	6a 01                	push   $0x1
  c6:	e8 17 04 00 00       	call   4e2 <printf>
  cb:	83 c4 10             	add    $0x10,%esp
		if(i==num-1)
  ce:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  d2:	75 29                	jne    fd <main+0xfd>
			printf(1, "[9 : %d %p]\n", stack[i], &stack[i]);
  d4:	8d 85 5c fe ff ff    	lea    -0x1a4(%ebp),%eax
  da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  dd:	c1 e2 02             	shl    $0x2,%edx
  e0:	01 c2                	add    %eax,%edx
  e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  e5:	8b 84 85 5c fe ff ff 	mov    -0x1a4(%ebp,%eax,4),%eax
  ec:	52                   	push   %edx
  ed:	50                   	push   %eax
  ee:	68 a5 08 00 00       	push   $0x8a5
  f3:	6a 01                	push   $0x1
  f5:	e8 e8 03 00 00       	call   4e2 <printf>
  fa:	83 c4 10             	add    $0x10,%esp
		heap[i] = i;
		heap2[i] = i;
		stack[i] = 10+i;
	}
	//printf(1, "[%p %p %p]\n",main,stack,heap);
	for(i=0;i<num;i++){
  fd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 101:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
 105:	7e 98                	jle    9f <main+0x9f>
	  if(i==num-1){
	  printf(1, "e[%d %p]\n", heap[i], &heap[i]);
	  printf(1, "e[%d %p]\n", heap2[i], &heap2[i]);
	  }
	  }*/
	exit();
 107:	e8 57 02 00 00       	call   363 <exit>

0000010c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 10c:	55                   	push   %ebp
 10d:	89 e5                	mov    %esp,%ebp
 10f:	57                   	push   %edi
 110:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 111:	8b 4d 08             	mov    0x8(%ebp),%ecx
 114:	8b 55 10             	mov    0x10(%ebp),%edx
 117:	8b 45 0c             	mov    0xc(%ebp),%eax
 11a:	89 cb                	mov    %ecx,%ebx
 11c:	89 df                	mov    %ebx,%edi
 11e:	89 d1                	mov    %edx,%ecx
 120:	fc                   	cld    
 121:	f3 aa                	rep stos %al,%es:(%edi)
 123:	89 ca                	mov    %ecx,%edx
 125:	89 fb                	mov    %edi,%ebx
 127:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 12d:	90                   	nop
 12e:	5b                   	pop    %ebx
 12f:	5f                   	pop    %edi
 130:	5d                   	pop    %ebp
 131:	c3                   	ret    

00000132 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 132:	55                   	push   %ebp
 133:	89 e5                	mov    %esp,%ebp
 135:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 138:	8b 45 08             	mov    0x8(%ebp),%eax
 13b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 13e:	90                   	nop
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
 142:	8d 50 01             	lea    0x1(%eax),%edx
 145:	89 55 08             	mov    %edx,0x8(%ebp)
 148:	8b 55 0c             	mov    0xc(%ebp),%edx
 14b:	8d 4a 01             	lea    0x1(%edx),%ecx
 14e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 151:	0f b6 12             	movzbl (%edx),%edx
 154:	88 10                	mov    %dl,(%eax)
 156:	0f b6 00             	movzbl (%eax),%eax
 159:	84 c0                	test   %al,%al
 15b:	75 e2                	jne    13f <strcpy+0xd>
    ;
  return os;
 15d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 160:	c9                   	leave  
 161:	c3                   	ret    

00000162 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 162:	55                   	push   %ebp
 163:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 165:	eb 08                	jmp    16f <strcmp+0xd>
    p++, q++;
 167:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 16f:	8b 45 08             	mov    0x8(%ebp),%eax
 172:	0f b6 00             	movzbl (%eax),%eax
 175:	84 c0                	test   %al,%al
 177:	74 10                	je     189 <strcmp+0x27>
 179:	8b 45 08             	mov    0x8(%ebp),%eax
 17c:	0f b6 10             	movzbl (%eax),%edx
 17f:	8b 45 0c             	mov    0xc(%ebp),%eax
 182:	0f b6 00             	movzbl (%eax),%eax
 185:	38 c2                	cmp    %al,%dl
 187:	74 de                	je     167 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 189:	8b 45 08             	mov    0x8(%ebp),%eax
 18c:	0f b6 00             	movzbl (%eax),%eax
 18f:	0f b6 d0             	movzbl %al,%edx
 192:	8b 45 0c             	mov    0xc(%ebp),%eax
 195:	0f b6 00             	movzbl (%eax),%eax
 198:	0f b6 c0             	movzbl %al,%eax
 19b:	29 c2                	sub    %eax,%edx
 19d:	89 d0                	mov    %edx,%eax
}
 19f:	5d                   	pop    %ebp
 1a0:	c3                   	ret    

000001a1 <strlen>:

uint
strlen(char *s)
{
 1a1:	55                   	push   %ebp
 1a2:	89 e5                	mov    %esp,%ebp
 1a4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1ae:	eb 04                	jmp    1b4 <strlen+0x13>
 1b0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1b7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ba:	01 d0                	add    %edx,%eax
 1bc:	0f b6 00             	movzbl (%eax),%eax
 1bf:	84 c0                	test   %al,%al
 1c1:	75 ed                	jne    1b0 <strlen+0xf>
    ;
  return n;
 1c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c6:	c9                   	leave  
 1c7:	c3                   	ret    

000001c8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c8:	55                   	push   %ebp
 1c9:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1cb:	8b 45 10             	mov    0x10(%ebp),%eax
 1ce:	50                   	push   %eax
 1cf:	ff 75 0c             	pushl  0xc(%ebp)
 1d2:	ff 75 08             	pushl  0x8(%ebp)
 1d5:	e8 32 ff ff ff       	call   10c <stosb>
 1da:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e0:	c9                   	leave  
 1e1:	c3                   	ret    

000001e2 <strchr>:

char*
strchr(const char *s, char c)
{
 1e2:	55                   	push   %ebp
 1e3:	89 e5                	mov    %esp,%ebp
 1e5:	83 ec 04             	sub    $0x4,%esp
 1e8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1eb:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1ee:	eb 14                	jmp    204 <strchr+0x22>
    if(*s == c)
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	0f b6 00             	movzbl (%eax),%eax
 1f6:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1f9:	75 05                	jne    200 <strchr+0x1e>
      return (char*)s;
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
 1fe:	eb 13                	jmp    213 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 200:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	0f b6 00             	movzbl (%eax),%eax
 20a:	84 c0                	test   %al,%al
 20c:	75 e2                	jne    1f0 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 20e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 213:	c9                   	leave  
 214:	c3                   	ret    

00000215 <gets>:

char*
gets(char *buf, int max)
{
 215:	55                   	push   %ebp
 216:	89 e5                	mov    %esp,%ebp
 218:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 222:	eb 42                	jmp    266 <gets+0x51>
    cc = read(0, &c, 1);
 224:	83 ec 04             	sub    $0x4,%esp
 227:	6a 01                	push   $0x1
 229:	8d 45 ef             	lea    -0x11(%ebp),%eax
 22c:	50                   	push   %eax
 22d:	6a 00                	push   $0x0
 22f:	e8 47 01 00 00       	call   37b <read>
 234:	83 c4 10             	add    $0x10,%esp
 237:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 23a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 23e:	7e 33                	jle    273 <gets+0x5e>
      break;
    buf[i++] = c;
 240:	8b 45 f4             	mov    -0xc(%ebp),%eax
 243:	8d 50 01             	lea    0x1(%eax),%edx
 246:	89 55 f4             	mov    %edx,-0xc(%ebp)
 249:	89 c2                	mov    %eax,%edx
 24b:	8b 45 08             	mov    0x8(%ebp),%eax
 24e:	01 c2                	add    %eax,%edx
 250:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 254:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 256:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 25a:	3c 0a                	cmp    $0xa,%al
 25c:	74 16                	je     274 <gets+0x5f>
 25e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 262:	3c 0d                	cmp    $0xd,%al
 264:	74 0e                	je     274 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 266:	8b 45 f4             	mov    -0xc(%ebp),%eax
 269:	83 c0 01             	add    $0x1,%eax
 26c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 26f:	7c b3                	jl     224 <gets+0xf>
 271:	eb 01                	jmp    274 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 273:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 274:	8b 55 f4             	mov    -0xc(%ebp),%edx
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	01 d0                	add    %edx,%eax
 27c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 282:	c9                   	leave  
 283:	c3                   	ret    

00000284 <stat>:

int
stat(char *n, struct stat *st)
{
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 28a:	83 ec 08             	sub    $0x8,%esp
 28d:	6a 00                	push   $0x0
 28f:	ff 75 08             	pushl  0x8(%ebp)
 292:	e8 0c 01 00 00       	call   3a3 <open>
 297:	83 c4 10             	add    $0x10,%esp
 29a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 29d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2a1:	79 07                	jns    2aa <stat+0x26>
    return -1;
 2a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2a8:	eb 25                	jmp    2cf <stat+0x4b>
  r = fstat(fd, st);
 2aa:	83 ec 08             	sub    $0x8,%esp
 2ad:	ff 75 0c             	pushl  0xc(%ebp)
 2b0:	ff 75 f4             	pushl  -0xc(%ebp)
 2b3:	e8 03 01 00 00       	call   3bb <fstat>
 2b8:	83 c4 10             	add    $0x10,%esp
 2bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2be:	83 ec 0c             	sub    $0xc,%esp
 2c1:	ff 75 f4             	pushl  -0xc(%ebp)
 2c4:	e8 c2 00 00 00       	call   38b <close>
 2c9:	83 c4 10             	add    $0x10,%esp
  return r;
 2cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2cf:	c9                   	leave  
 2d0:	c3                   	ret    

000002d1 <atoi>:

int
atoi(const char *s)
{
 2d1:	55                   	push   %ebp
 2d2:	89 e5                	mov    %esp,%ebp
 2d4:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2de:	eb 25                	jmp    305 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e3:	89 d0                	mov    %edx,%eax
 2e5:	c1 e0 02             	shl    $0x2,%eax
 2e8:	01 d0                	add    %edx,%eax
 2ea:	01 c0                	add    %eax,%eax
 2ec:	89 c1                	mov    %eax,%ecx
 2ee:	8b 45 08             	mov    0x8(%ebp),%eax
 2f1:	8d 50 01             	lea    0x1(%eax),%edx
 2f4:	89 55 08             	mov    %edx,0x8(%ebp)
 2f7:	0f b6 00             	movzbl (%eax),%eax
 2fa:	0f be c0             	movsbl %al,%eax
 2fd:	01 c8                	add    %ecx,%eax
 2ff:	83 e8 30             	sub    $0x30,%eax
 302:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 305:	8b 45 08             	mov    0x8(%ebp),%eax
 308:	0f b6 00             	movzbl (%eax),%eax
 30b:	3c 2f                	cmp    $0x2f,%al
 30d:	7e 0a                	jle    319 <atoi+0x48>
 30f:	8b 45 08             	mov    0x8(%ebp),%eax
 312:	0f b6 00             	movzbl (%eax),%eax
 315:	3c 39                	cmp    $0x39,%al
 317:	7e c7                	jle    2e0 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 319:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 31c:	c9                   	leave  
 31d:	c3                   	ret    

0000031e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 31e:	55                   	push   %ebp
 31f:	89 e5                	mov    %esp,%ebp
 321:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 32a:	8b 45 0c             	mov    0xc(%ebp),%eax
 32d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 330:	eb 17                	jmp    349 <memmove+0x2b>
    *dst++ = *src++;
 332:	8b 45 fc             	mov    -0x4(%ebp),%eax
 335:	8d 50 01             	lea    0x1(%eax),%edx
 338:	89 55 fc             	mov    %edx,-0x4(%ebp)
 33b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 33e:	8d 4a 01             	lea    0x1(%edx),%ecx
 341:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 344:	0f b6 12             	movzbl (%edx),%edx
 347:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 349:	8b 45 10             	mov    0x10(%ebp),%eax
 34c:	8d 50 ff             	lea    -0x1(%eax),%edx
 34f:	89 55 10             	mov    %edx,0x10(%ebp)
 352:	85 c0                	test   %eax,%eax
 354:	7f dc                	jg     332 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 356:	8b 45 08             	mov    0x8(%ebp),%eax
}
 359:	c9                   	leave  
 35a:	c3                   	ret    

0000035b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 35b:	b8 01 00 00 00       	mov    $0x1,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <exit>:
SYSCALL(exit)
 363:	b8 02 00 00 00       	mov    $0x2,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <wait>:
SYSCALL(wait)
 36b:	b8 03 00 00 00       	mov    $0x3,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <pipe>:
SYSCALL(pipe)
 373:	b8 04 00 00 00       	mov    $0x4,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <read>:
SYSCALL(read)
 37b:	b8 05 00 00 00       	mov    $0x5,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <write>:
SYSCALL(write)
 383:	b8 10 00 00 00       	mov    $0x10,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <close>:
SYSCALL(close)
 38b:	b8 15 00 00 00       	mov    $0x15,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <kill>:
SYSCALL(kill)
 393:	b8 06 00 00 00       	mov    $0x6,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <exec>:
SYSCALL(exec)
 39b:	b8 07 00 00 00       	mov    $0x7,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <open>:
SYSCALL(open)
 3a3:	b8 0f 00 00 00       	mov    $0xf,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <mknod>:
SYSCALL(mknod)
 3ab:	b8 11 00 00 00       	mov    $0x11,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <unlink>:
SYSCALL(unlink)
 3b3:	b8 12 00 00 00       	mov    $0x12,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <fstat>:
SYSCALL(fstat)
 3bb:	b8 08 00 00 00       	mov    $0x8,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <link>:
SYSCALL(link)
 3c3:	b8 13 00 00 00       	mov    $0x13,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <mkdir>:
SYSCALL(mkdir)
 3cb:	b8 14 00 00 00       	mov    $0x14,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <chdir>:
SYSCALL(chdir)
 3d3:	b8 09 00 00 00       	mov    $0x9,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <dup>:
SYSCALL(dup)
 3db:	b8 0a 00 00 00       	mov    $0xa,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <getpid>:
SYSCALL(getpid)
 3e3:	b8 0b 00 00 00       	mov    $0xb,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <sbrk>:
SYSCALL(sbrk)
 3eb:	b8 0c 00 00 00       	mov    $0xc,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <sleep>:
SYSCALL(sleep)
 3f3:	b8 0d 00 00 00       	mov    $0xd,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <uptime>:
SYSCALL(uptime)
 3fb:	b8 0e 00 00 00       	mov    $0xe,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <halt>:
SYSCALL(halt)
 403:	b8 16 00 00 00       	mov    $0x16,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 40b:	55                   	push   %ebp
 40c:	89 e5                	mov    %esp,%ebp
 40e:	83 ec 18             	sub    $0x18,%esp
 411:	8b 45 0c             	mov    0xc(%ebp),%eax
 414:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 417:	83 ec 04             	sub    $0x4,%esp
 41a:	6a 01                	push   $0x1
 41c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 41f:	50                   	push   %eax
 420:	ff 75 08             	pushl  0x8(%ebp)
 423:	e8 5b ff ff ff       	call   383 <write>
 428:	83 c4 10             	add    $0x10,%esp
}
 42b:	90                   	nop
 42c:	c9                   	leave  
 42d:	c3                   	ret    

0000042e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 42e:	55                   	push   %ebp
 42f:	89 e5                	mov    %esp,%ebp
 431:	53                   	push   %ebx
 432:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 435:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 43c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 440:	74 17                	je     459 <printint+0x2b>
 442:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 446:	79 11                	jns    459 <printint+0x2b>
    neg = 1;
 448:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 44f:	8b 45 0c             	mov    0xc(%ebp),%eax
 452:	f7 d8                	neg    %eax
 454:	89 45 ec             	mov    %eax,-0x14(%ebp)
 457:	eb 06                	jmp    45f <printint+0x31>
  } else {
    x = xx;
 459:	8b 45 0c             	mov    0xc(%ebp),%eax
 45c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 45f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 466:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 469:	8d 41 01             	lea    0x1(%ecx),%eax
 46c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 46f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 472:	8b 45 ec             	mov    -0x14(%ebp),%eax
 475:	ba 00 00 00 00       	mov    $0x0,%edx
 47a:	f7 f3                	div    %ebx
 47c:	89 d0                	mov    %edx,%eax
 47e:	0f b6 80 04 0b 00 00 	movzbl 0xb04(%eax),%eax
 485:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 489:	8b 5d 10             	mov    0x10(%ebp),%ebx
 48c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 48f:	ba 00 00 00 00       	mov    $0x0,%edx
 494:	f7 f3                	div    %ebx
 496:	89 45 ec             	mov    %eax,-0x14(%ebp)
 499:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 49d:	75 c7                	jne    466 <printint+0x38>
  if(neg)
 49f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4a3:	74 2d                	je     4d2 <printint+0xa4>
    buf[i++] = '-';
 4a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a8:	8d 50 01             	lea    0x1(%eax),%edx
 4ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4ae:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4b3:	eb 1d                	jmp    4d2 <printint+0xa4>
    putc(fd, buf[i]);
 4b5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4bb:	01 d0                	add    %edx,%eax
 4bd:	0f b6 00             	movzbl (%eax),%eax
 4c0:	0f be c0             	movsbl %al,%eax
 4c3:	83 ec 08             	sub    $0x8,%esp
 4c6:	50                   	push   %eax
 4c7:	ff 75 08             	pushl  0x8(%ebp)
 4ca:	e8 3c ff ff ff       	call   40b <putc>
 4cf:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4d2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4da:	79 d9                	jns    4b5 <printint+0x87>
    putc(fd, buf[i]);
}
 4dc:	90                   	nop
 4dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4e0:	c9                   	leave  
 4e1:	c3                   	ret    

000004e2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4e2:	55                   	push   %ebp
 4e3:	89 e5                	mov    %esp,%ebp
 4e5:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4e8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4ef:	8d 45 0c             	lea    0xc(%ebp),%eax
 4f2:	83 c0 04             	add    $0x4,%eax
 4f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4f8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4ff:	e9 59 01 00 00       	jmp    65d <printf+0x17b>
    c = fmt[i] & 0xff;
 504:	8b 55 0c             	mov    0xc(%ebp),%edx
 507:	8b 45 f0             	mov    -0x10(%ebp),%eax
 50a:	01 d0                	add    %edx,%eax
 50c:	0f b6 00             	movzbl (%eax),%eax
 50f:	0f be c0             	movsbl %al,%eax
 512:	25 ff 00 00 00       	and    $0xff,%eax
 517:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 51a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 51e:	75 2c                	jne    54c <printf+0x6a>
      if(c == '%'){
 520:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 524:	75 0c                	jne    532 <printf+0x50>
        state = '%';
 526:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 52d:	e9 27 01 00 00       	jmp    659 <printf+0x177>
      } else {
        putc(fd, c);
 532:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 535:	0f be c0             	movsbl %al,%eax
 538:	83 ec 08             	sub    $0x8,%esp
 53b:	50                   	push   %eax
 53c:	ff 75 08             	pushl  0x8(%ebp)
 53f:	e8 c7 fe ff ff       	call   40b <putc>
 544:	83 c4 10             	add    $0x10,%esp
 547:	e9 0d 01 00 00       	jmp    659 <printf+0x177>
      }
    } else if(state == '%'){
 54c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 550:	0f 85 03 01 00 00    	jne    659 <printf+0x177>
      if(c == 'd'){
 556:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 55a:	75 1e                	jne    57a <printf+0x98>
        printint(fd, *ap, 10, 1);
 55c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55f:	8b 00                	mov    (%eax),%eax
 561:	6a 01                	push   $0x1
 563:	6a 0a                	push   $0xa
 565:	50                   	push   %eax
 566:	ff 75 08             	pushl  0x8(%ebp)
 569:	e8 c0 fe ff ff       	call   42e <printint>
 56e:	83 c4 10             	add    $0x10,%esp
        ap++;
 571:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 575:	e9 d8 00 00 00       	jmp    652 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 57a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 57e:	74 06                	je     586 <printf+0xa4>
 580:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 584:	75 1e                	jne    5a4 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 586:	8b 45 e8             	mov    -0x18(%ebp),%eax
 589:	8b 00                	mov    (%eax),%eax
 58b:	6a 00                	push   $0x0
 58d:	6a 10                	push   $0x10
 58f:	50                   	push   %eax
 590:	ff 75 08             	pushl  0x8(%ebp)
 593:	e8 96 fe ff ff       	call   42e <printint>
 598:	83 c4 10             	add    $0x10,%esp
        ap++;
 59b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 59f:	e9 ae 00 00 00       	jmp    652 <printf+0x170>
      } else if(c == 's'){
 5a4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5a8:	75 43                	jne    5ed <printf+0x10b>
        s = (char*)*ap;
 5aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ad:	8b 00                	mov    (%eax),%eax
 5af:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5b2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ba:	75 25                	jne    5e1 <printf+0xff>
          s = "(null)";
 5bc:	c7 45 f4 b2 08 00 00 	movl   $0x8b2,-0xc(%ebp)
        while(*s != 0){
 5c3:	eb 1c                	jmp    5e1 <printf+0xff>
          putc(fd, *s);
 5c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c8:	0f b6 00             	movzbl (%eax),%eax
 5cb:	0f be c0             	movsbl %al,%eax
 5ce:	83 ec 08             	sub    $0x8,%esp
 5d1:	50                   	push   %eax
 5d2:	ff 75 08             	pushl  0x8(%ebp)
 5d5:	e8 31 fe ff ff       	call   40b <putc>
 5da:	83 c4 10             	add    $0x10,%esp
          s++;
 5dd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e4:	0f b6 00             	movzbl (%eax),%eax
 5e7:	84 c0                	test   %al,%al
 5e9:	75 da                	jne    5c5 <printf+0xe3>
 5eb:	eb 65                	jmp    652 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ed:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5f1:	75 1d                	jne    610 <printf+0x12e>
        putc(fd, *ap);
 5f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f6:	8b 00                	mov    (%eax),%eax
 5f8:	0f be c0             	movsbl %al,%eax
 5fb:	83 ec 08             	sub    $0x8,%esp
 5fe:	50                   	push   %eax
 5ff:	ff 75 08             	pushl  0x8(%ebp)
 602:	e8 04 fe ff ff       	call   40b <putc>
 607:	83 c4 10             	add    $0x10,%esp
        ap++;
 60a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 60e:	eb 42                	jmp    652 <printf+0x170>
      } else if(c == '%'){
 610:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 614:	75 17                	jne    62d <printf+0x14b>
        putc(fd, c);
 616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 619:	0f be c0             	movsbl %al,%eax
 61c:	83 ec 08             	sub    $0x8,%esp
 61f:	50                   	push   %eax
 620:	ff 75 08             	pushl  0x8(%ebp)
 623:	e8 e3 fd ff ff       	call   40b <putc>
 628:	83 c4 10             	add    $0x10,%esp
 62b:	eb 25                	jmp    652 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 62d:	83 ec 08             	sub    $0x8,%esp
 630:	6a 25                	push   $0x25
 632:	ff 75 08             	pushl  0x8(%ebp)
 635:	e8 d1 fd ff ff       	call   40b <putc>
 63a:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 63d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 640:	0f be c0             	movsbl %al,%eax
 643:	83 ec 08             	sub    $0x8,%esp
 646:	50                   	push   %eax
 647:	ff 75 08             	pushl  0x8(%ebp)
 64a:	e8 bc fd ff ff       	call   40b <putc>
 64f:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 652:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 659:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 65d:	8b 55 0c             	mov    0xc(%ebp),%edx
 660:	8b 45 f0             	mov    -0x10(%ebp),%eax
 663:	01 d0                	add    %edx,%eax
 665:	0f b6 00             	movzbl (%eax),%eax
 668:	84 c0                	test   %al,%al
 66a:	0f 85 94 fe ff ff    	jne    504 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 670:	90                   	nop
 671:	c9                   	leave  
 672:	c3                   	ret    

00000673 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 673:	55                   	push   %ebp
 674:	89 e5                	mov    %esp,%ebp
 676:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 679:	8b 45 08             	mov    0x8(%ebp),%eax
 67c:	83 e8 08             	sub    $0x8,%eax
 67f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 682:	a1 20 0b 00 00       	mov    0xb20,%eax
 687:	89 45 fc             	mov    %eax,-0x4(%ebp)
 68a:	eb 24                	jmp    6b0 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 68c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68f:	8b 00                	mov    (%eax),%eax
 691:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 694:	77 12                	ja     6a8 <free+0x35>
 696:	8b 45 f8             	mov    -0x8(%ebp),%eax
 699:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 69c:	77 24                	ja     6c2 <free+0x4f>
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	8b 00                	mov    (%eax),%eax
 6a3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a6:	77 1a                	ja     6c2 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ab:	8b 00                	mov    (%eax),%eax
 6ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b6:	76 d4                	jbe    68c <free+0x19>
 6b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bb:	8b 00                	mov    (%eax),%eax
 6bd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c0:	76 ca                	jbe    68c <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c5:	8b 40 04             	mov    0x4(%eax),%eax
 6c8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d2:	01 c2                	add    %eax,%edx
 6d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d7:	8b 00                	mov    (%eax),%eax
 6d9:	39 c2                	cmp    %eax,%edx
 6db:	75 24                	jne    701 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e0:	8b 50 04             	mov    0x4(%eax),%edx
 6e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e6:	8b 00                	mov    (%eax),%eax
 6e8:	8b 40 04             	mov    0x4(%eax),%eax
 6eb:	01 c2                	add    %eax,%edx
 6ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f0:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f6:	8b 00                	mov    (%eax),%eax
 6f8:	8b 10                	mov    (%eax),%edx
 6fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fd:	89 10                	mov    %edx,(%eax)
 6ff:	eb 0a                	jmp    70b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 701:	8b 45 fc             	mov    -0x4(%ebp),%eax
 704:	8b 10                	mov    (%eax),%edx
 706:	8b 45 f8             	mov    -0x8(%ebp),%eax
 709:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 70b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70e:	8b 40 04             	mov    0x4(%eax),%eax
 711:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 718:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71b:	01 d0                	add    %edx,%eax
 71d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 720:	75 20                	jne    742 <free+0xcf>
    p->s.size += bp->s.size;
 722:	8b 45 fc             	mov    -0x4(%ebp),%eax
 725:	8b 50 04             	mov    0x4(%eax),%edx
 728:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72b:	8b 40 04             	mov    0x4(%eax),%eax
 72e:	01 c2                	add    %eax,%edx
 730:	8b 45 fc             	mov    -0x4(%ebp),%eax
 733:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 736:	8b 45 f8             	mov    -0x8(%ebp),%eax
 739:	8b 10                	mov    (%eax),%edx
 73b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73e:	89 10                	mov    %edx,(%eax)
 740:	eb 08                	jmp    74a <free+0xd7>
  } else
    p->s.ptr = bp;
 742:	8b 45 fc             	mov    -0x4(%ebp),%eax
 745:	8b 55 f8             	mov    -0x8(%ebp),%edx
 748:	89 10                	mov    %edx,(%eax)
  freep = p;
 74a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74d:	a3 20 0b 00 00       	mov    %eax,0xb20
}
 752:	90                   	nop
 753:	c9                   	leave  
 754:	c3                   	ret    

00000755 <morecore>:

static Header*
morecore(uint nu)
{
 755:	55                   	push   %ebp
 756:	89 e5                	mov    %esp,%ebp
 758:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 75b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 762:	77 07                	ja     76b <morecore+0x16>
    nu = 4096;
 764:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 76b:	8b 45 08             	mov    0x8(%ebp),%eax
 76e:	c1 e0 03             	shl    $0x3,%eax
 771:	83 ec 0c             	sub    $0xc,%esp
 774:	50                   	push   %eax
 775:	e8 71 fc ff ff       	call   3eb <sbrk>
 77a:	83 c4 10             	add    $0x10,%esp
 77d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 780:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 784:	75 07                	jne    78d <morecore+0x38>
    return 0;
 786:	b8 00 00 00 00       	mov    $0x0,%eax
 78b:	eb 26                	jmp    7b3 <morecore+0x5e>
  hp = (Header*)p;
 78d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 790:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 793:	8b 45 f0             	mov    -0x10(%ebp),%eax
 796:	8b 55 08             	mov    0x8(%ebp),%edx
 799:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 79c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79f:	83 c0 08             	add    $0x8,%eax
 7a2:	83 ec 0c             	sub    $0xc,%esp
 7a5:	50                   	push   %eax
 7a6:	e8 c8 fe ff ff       	call   673 <free>
 7ab:	83 c4 10             	add    $0x10,%esp
  return freep;
 7ae:	a1 20 0b 00 00       	mov    0xb20,%eax
}
 7b3:	c9                   	leave  
 7b4:	c3                   	ret    

000007b5 <malloc>:

void*
malloc(uint nbytes)
{
 7b5:	55                   	push   %ebp
 7b6:	89 e5                	mov    %esp,%ebp
 7b8:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7bb:	8b 45 08             	mov    0x8(%ebp),%eax
 7be:	83 c0 07             	add    $0x7,%eax
 7c1:	c1 e8 03             	shr    $0x3,%eax
 7c4:	83 c0 01             	add    $0x1,%eax
 7c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7ca:	a1 20 0b 00 00       	mov    0xb20,%eax
 7cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7d6:	75 23                	jne    7fb <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7d8:	c7 45 f0 18 0b 00 00 	movl   $0xb18,-0x10(%ebp)
 7df:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e2:	a3 20 0b 00 00       	mov    %eax,0xb20
 7e7:	a1 20 0b 00 00       	mov    0xb20,%eax
 7ec:	a3 18 0b 00 00       	mov    %eax,0xb18
    base.s.size = 0;
 7f1:	c7 05 1c 0b 00 00 00 	movl   $0x0,0xb1c
 7f8:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fe:	8b 00                	mov    (%eax),%eax
 800:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 803:	8b 45 f4             	mov    -0xc(%ebp),%eax
 806:	8b 40 04             	mov    0x4(%eax),%eax
 809:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 80c:	72 4d                	jb     85b <malloc+0xa6>
      if(p->s.size == nunits)
 80e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 811:	8b 40 04             	mov    0x4(%eax),%eax
 814:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 817:	75 0c                	jne    825 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 819:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81c:	8b 10                	mov    (%eax),%edx
 81e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 821:	89 10                	mov    %edx,(%eax)
 823:	eb 26                	jmp    84b <malloc+0x96>
      else {
        p->s.size -= nunits;
 825:	8b 45 f4             	mov    -0xc(%ebp),%eax
 828:	8b 40 04             	mov    0x4(%eax),%eax
 82b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 82e:	89 c2                	mov    %eax,%edx
 830:	8b 45 f4             	mov    -0xc(%ebp),%eax
 833:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 836:	8b 45 f4             	mov    -0xc(%ebp),%eax
 839:	8b 40 04             	mov    0x4(%eax),%eax
 83c:	c1 e0 03             	shl    $0x3,%eax
 83f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 842:	8b 45 f4             	mov    -0xc(%ebp),%eax
 845:	8b 55 ec             	mov    -0x14(%ebp),%edx
 848:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 84b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84e:	a3 20 0b 00 00       	mov    %eax,0xb20
      return (void*)(p + 1);
 853:	8b 45 f4             	mov    -0xc(%ebp),%eax
 856:	83 c0 08             	add    $0x8,%eax
 859:	eb 3b                	jmp    896 <malloc+0xe1>
    }
    if(p == freep)
 85b:	a1 20 0b 00 00       	mov    0xb20,%eax
 860:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 863:	75 1e                	jne    883 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 865:	83 ec 0c             	sub    $0xc,%esp
 868:	ff 75 ec             	pushl  -0x14(%ebp)
 86b:	e8 e5 fe ff ff       	call   755 <morecore>
 870:	83 c4 10             	add    $0x10,%esp
 873:	89 45 f4             	mov    %eax,-0xc(%ebp)
 876:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 87a:	75 07                	jne    883 <malloc+0xce>
        return 0;
 87c:	b8 00 00 00 00       	mov    $0x0,%eax
 881:	eb 13                	jmp    896 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 883:	8b 45 f4             	mov    -0xc(%ebp),%eax
 886:	89 45 f0             	mov    %eax,-0x10(%ebp)
 889:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88c:	8b 00                	mov    (%eax),%eax
 88e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 891:	e9 6d ff ff ff       	jmp    803 <malloc+0x4e>
}
 896:	c9                   	leave  
 897:	c3                   	ret    
