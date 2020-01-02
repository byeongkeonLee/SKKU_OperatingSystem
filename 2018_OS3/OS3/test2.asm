
_test2:     file format elf32-i386


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
   d:	57                   	push   %edi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	81 ec 2c 0e 00 00    	sub    $0xe2c,%esp
  16:	89 cb                	mov    %ecx,%ebx
	int i[900]={0},j=0;
  18:	8d 95 d0 f1 ff ff    	lea    -0xe30(%ebp),%edx
  1e:	b8 00 00 00 00       	mov    $0x0,%eax
  23:	b9 84 03 00 00       	mov    $0x384,%ecx
  28:	89 d7                	mov    %edx,%edi
  2a:	f3 ab                	rep stos %eax,%es:(%edi)
  2c:	c7 85 cc f1 ff ff 00 	movl   $0x0,-0xe34(%ebp)
  33:	00 00 00 
	int* a=(int*)malloc(sizeof(int)*10000);
  36:	83 ec 0c             	sub    $0xc,%esp
  39:	68 40 9c 00 00       	push   $0x9c40
  3e:	e8 aa 07 00 00       	call   7ed <malloc>
  43:	83 c4 10             	add    $0x10,%esp
  46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int* b=(int*)malloc(sizeof(int)*10000);
  49:	83 ec 0c             	sub    $0xc,%esp
  4c:	68 40 9c 00 00       	push   $0x9c40
  51:	e8 97 07 00 00       	call   7ed <malloc>
  56:	83 c4 10             	add    $0x10,%esp
  59:	89 45 e0             	mov    %eax,-0x20(%ebp)
	j++;
  5c:	8b 85 cc f1 ff ff    	mov    -0xe34(%ebp),%eax
  62:	83 c0 01             	add    $0x1,%eax
  65:	89 85 cc f1 ff ff    	mov    %eax,-0xe34(%ebp)
	j++;
  6b:	8b 85 cc f1 ff ff    	mov    -0xe34(%ebp),%eax
  71:	83 c0 01             	add    $0x1,%eax
  74:	89 85 cc f1 ff ff    	mov    %eax,-0xe34(%ebp)
	j++;
  7a:	8b 85 cc f1 ff ff    	mov    -0xe34(%ebp),%eax
  80:	83 c0 01             	add    $0x1,%eax
  83:	89 85 cc f1 ff ff    	mov    %eax,-0xe34(%ebp)
	printf(1,"main:%p func:%p\n",main,func);
  89:	68 07 01 00 00       	push   $0x107
  8e:	68 00 00 00 00       	push   $0x0
  93:	68 d0 08 00 00       	push   $0x8d0
  98:	6a 01                	push   $0x1
  9a:	e8 7b 04 00 00       	call   51a <printf>
  9f:	83 c4 10             	add    $0x10,%esp
	printf(1,"data:%p\n",&g);
  a2:	83 ec 04             	sub    $0x4,%esp
  a5:	68 c0 0b 00 00       	push   $0xbc0
  aa:	68 e1 08 00 00       	push   $0x8e1
  af:	6a 01                	push   $0x1
  b1:	e8 64 04 00 00       	call   51a <printf>
  b6:	83 c4 10             	add    $0x10,%esp
	printf(1,"a-heap:%p b-heap:%p\n",a,b);
  b9:	ff 75 e0             	pushl  -0x20(%ebp)
  bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  bf:	68 ea 08 00 00       	push   $0x8ea
  c4:	6a 01                	push   $0x1
  c6:	e8 4f 04 00 00       	call   51a <printf>
  cb:	83 c4 10             	add    $0x10,%esp
	printf(1,"argc:%p // %p %p %p\n",&argc,&i[899],&i[0],&j);
  ce:	83 ec 08             	sub    $0x8,%esp
  d1:	8d 85 cc f1 ff ff    	lea    -0xe34(%ebp),%eax
  d7:	50                   	push   %eax
  d8:	8d 85 d0 f1 ff ff    	lea    -0xe30(%ebp),%eax
  de:	50                   	push   %eax
  df:	8d 85 d0 f1 ff ff    	lea    -0xe30(%ebp),%eax
  e5:	05 0c 0e 00 00       	add    $0xe0c,%eax
  ea:	50                   	push   %eax
  eb:	89 d8                	mov    %ebx,%eax
  ed:	50                   	push   %eax
  ee:	68 ff 08 00 00       	push   $0x8ff
  f3:	6a 01                	push   $0x1
  f5:	e8 20 04 00 00       	call   51a <printf>
  fa:	83 c4 20             	add    $0x20,%esp
	func();
  fd:	e8 05 00 00 00       	call   107 <func>
	exit();
 102:	e8 94 02 00 00       	call   39b <exit>

00000107 <func>:
}
int func(){
 107:	55                   	push   %ebp
 108:	89 e5                	mov    %esp,%ebp
 10a:	83 ec 18             	sub    $0x18,%esp
	int k=0;
 10d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int* c=(int*)malloc(sizeof(int)*10000);
 114:	83 ec 0c             	sub    $0xc,%esp
 117:	68 40 9c 00 00       	push   $0x9c40
 11c:	e8 cc 06 00 00       	call   7ed <malloc>
 121:	83 c4 10             	add    $0x10,%esp
 124:	89 45 f4             	mov    %eax,-0xc(%ebp)
	printf(1,"func:%p c-heap:%p\n",&k,c);
 127:	ff 75 f4             	pushl  -0xc(%ebp)
 12a:	8d 45 f0             	lea    -0x10(%ebp),%eax
 12d:	50                   	push   %eax
 12e:	68 14 09 00 00       	push   $0x914
 133:	6a 01                	push   $0x1
 135:	e8 e0 03 00 00       	call   51a <printf>
 13a:	83 c4 10             	add    $0x10,%esp
	return 0;
 13d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 142:	c9                   	leave  
 143:	c3                   	ret    

00000144 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 144:	55                   	push   %ebp
 145:	89 e5                	mov    %esp,%ebp
 147:	57                   	push   %edi
 148:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 149:	8b 4d 08             	mov    0x8(%ebp),%ecx
 14c:	8b 55 10             	mov    0x10(%ebp),%edx
 14f:	8b 45 0c             	mov    0xc(%ebp),%eax
 152:	89 cb                	mov    %ecx,%ebx
 154:	89 df                	mov    %ebx,%edi
 156:	89 d1                	mov    %edx,%ecx
 158:	fc                   	cld    
 159:	f3 aa                	rep stos %al,%es:(%edi)
 15b:	89 ca                	mov    %ecx,%edx
 15d:	89 fb                	mov    %edi,%ebx
 15f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 162:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 165:	90                   	nop
 166:	5b                   	pop    %ebx
 167:	5f                   	pop    %edi
 168:	5d                   	pop    %ebp
 169:	c3                   	ret    

0000016a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 16a:	55                   	push   %ebp
 16b:	89 e5                	mov    %esp,%ebp
 16d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 170:	8b 45 08             	mov    0x8(%ebp),%eax
 173:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 176:	90                   	nop
 177:	8b 45 08             	mov    0x8(%ebp),%eax
 17a:	8d 50 01             	lea    0x1(%eax),%edx
 17d:	89 55 08             	mov    %edx,0x8(%ebp)
 180:	8b 55 0c             	mov    0xc(%ebp),%edx
 183:	8d 4a 01             	lea    0x1(%edx),%ecx
 186:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 189:	0f b6 12             	movzbl (%edx),%edx
 18c:	88 10                	mov    %dl,(%eax)
 18e:	0f b6 00             	movzbl (%eax),%eax
 191:	84 c0                	test   %al,%al
 193:	75 e2                	jne    177 <strcpy+0xd>
    ;
  return os;
 195:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 198:	c9                   	leave  
 199:	c3                   	ret    

0000019a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 19a:	55                   	push   %ebp
 19b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 19d:	eb 08                	jmp    1a7 <strcmp+0xd>
    p++, q++;
 19f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1a3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
 1aa:	0f b6 00             	movzbl (%eax),%eax
 1ad:	84 c0                	test   %al,%al
 1af:	74 10                	je     1c1 <strcmp+0x27>
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	0f b6 10             	movzbl (%eax),%edx
 1b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ba:	0f b6 00             	movzbl (%eax),%eax
 1bd:	38 c2                	cmp    %al,%dl
 1bf:	74 de                	je     19f <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1c1:	8b 45 08             	mov    0x8(%ebp),%eax
 1c4:	0f b6 00             	movzbl (%eax),%eax
 1c7:	0f b6 d0             	movzbl %al,%edx
 1ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cd:	0f b6 00             	movzbl (%eax),%eax
 1d0:	0f b6 c0             	movzbl %al,%eax
 1d3:	29 c2                	sub    %eax,%edx
 1d5:	89 d0                	mov    %edx,%eax
}
 1d7:	5d                   	pop    %ebp
 1d8:	c3                   	ret    

000001d9 <strlen>:

uint
strlen(char *s)
{
 1d9:	55                   	push   %ebp
 1da:	89 e5                	mov    %esp,%ebp
 1dc:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1e6:	eb 04                	jmp    1ec <strlen+0x13>
 1e8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
 1f2:	01 d0                	add    %edx,%eax
 1f4:	0f b6 00             	movzbl (%eax),%eax
 1f7:	84 c0                	test   %al,%al
 1f9:	75 ed                	jne    1e8 <strlen+0xf>
    ;
  return n;
 1fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1fe:	c9                   	leave  
 1ff:	c3                   	ret    

00000200 <memset>:

void*
memset(void *dst, int c, uint n)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 203:	8b 45 10             	mov    0x10(%ebp),%eax
 206:	50                   	push   %eax
 207:	ff 75 0c             	pushl  0xc(%ebp)
 20a:	ff 75 08             	pushl  0x8(%ebp)
 20d:	e8 32 ff ff ff       	call   144 <stosb>
 212:	83 c4 0c             	add    $0xc,%esp
  return dst;
 215:	8b 45 08             	mov    0x8(%ebp),%eax
}
 218:	c9                   	leave  
 219:	c3                   	ret    

0000021a <strchr>:

char*
strchr(const char *s, char c)
{
 21a:	55                   	push   %ebp
 21b:	89 e5                	mov    %esp,%ebp
 21d:	83 ec 04             	sub    $0x4,%esp
 220:	8b 45 0c             	mov    0xc(%ebp),%eax
 223:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 226:	eb 14                	jmp    23c <strchr+0x22>
    if(*s == c)
 228:	8b 45 08             	mov    0x8(%ebp),%eax
 22b:	0f b6 00             	movzbl (%eax),%eax
 22e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 231:	75 05                	jne    238 <strchr+0x1e>
      return (char*)s;
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	eb 13                	jmp    24b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 238:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 23c:	8b 45 08             	mov    0x8(%ebp),%eax
 23f:	0f b6 00             	movzbl (%eax),%eax
 242:	84 c0                	test   %al,%al
 244:	75 e2                	jne    228 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 246:	b8 00 00 00 00       	mov    $0x0,%eax
}
 24b:	c9                   	leave  
 24c:	c3                   	ret    

0000024d <gets>:

char*
gets(char *buf, int max)
{
 24d:	55                   	push   %ebp
 24e:	89 e5                	mov    %esp,%ebp
 250:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 253:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 25a:	eb 42                	jmp    29e <gets+0x51>
    cc = read(0, &c, 1);
 25c:	83 ec 04             	sub    $0x4,%esp
 25f:	6a 01                	push   $0x1
 261:	8d 45 ef             	lea    -0x11(%ebp),%eax
 264:	50                   	push   %eax
 265:	6a 00                	push   $0x0
 267:	e8 47 01 00 00       	call   3b3 <read>
 26c:	83 c4 10             	add    $0x10,%esp
 26f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 272:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 276:	7e 33                	jle    2ab <gets+0x5e>
      break;
    buf[i++] = c;
 278:	8b 45 f4             	mov    -0xc(%ebp),%eax
 27b:	8d 50 01             	lea    0x1(%eax),%edx
 27e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 281:	89 c2                	mov    %eax,%edx
 283:	8b 45 08             	mov    0x8(%ebp),%eax
 286:	01 c2                	add    %eax,%edx
 288:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 28c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 28e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 292:	3c 0a                	cmp    $0xa,%al
 294:	74 16                	je     2ac <gets+0x5f>
 296:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 29a:	3c 0d                	cmp    $0xd,%al
 29c:	74 0e                	je     2ac <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 29e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a1:	83 c0 01             	add    $0x1,%eax
 2a4:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2a7:	7c b3                	jl     25c <gets+0xf>
 2a9:	eb 01                	jmp    2ac <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2ab:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2af:	8b 45 08             	mov    0x8(%ebp),%eax
 2b2:	01 d0                	add    %edx,%eax
 2b4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ba:	c9                   	leave  
 2bb:	c3                   	ret    

000002bc <stat>:

int
stat(char *n, struct stat *st)
{
 2bc:	55                   	push   %ebp
 2bd:	89 e5                	mov    %esp,%ebp
 2bf:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c2:	83 ec 08             	sub    $0x8,%esp
 2c5:	6a 00                	push   $0x0
 2c7:	ff 75 08             	pushl  0x8(%ebp)
 2ca:	e8 0c 01 00 00       	call   3db <open>
 2cf:	83 c4 10             	add    $0x10,%esp
 2d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2d9:	79 07                	jns    2e2 <stat+0x26>
    return -1;
 2db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2e0:	eb 25                	jmp    307 <stat+0x4b>
  r = fstat(fd, st);
 2e2:	83 ec 08             	sub    $0x8,%esp
 2e5:	ff 75 0c             	pushl  0xc(%ebp)
 2e8:	ff 75 f4             	pushl  -0xc(%ebp)
 2eb:	e8 03 01 00 00       	call   3f3 <fstat>
 2f0:	83 c4 10             	add    $0x10,%esp
 2f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2f6:	83 ec 0c             	sub    $0xc,%esp
 2f9:	ff 75 f4             	pushl  -0xc(%ebp)
 2fc:	e8 c2 00 00 00       	call   3c3 <close>
 301:	83 c4 10             	add    $0x10,%esp
  return r;
 304:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 307:	c9                   	leave  
 308:	c3                   	ret    

00000309 <atoi>:

int
atoi(const char *s)
{
 309:	55                   	push   %ebp
 30a:	89 e5                	mov    %esp,%ebp
 30c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 30f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 316:	eb 25                	jmp    33d <atoi+0x34>
    n = n*10 + *s++ - '0';
 318:	8b 55 fc             	mov    -0x4(%ebp),%edx
 31b:	89 d0                	mov    %edx,%eax
 31d:	c1 e0 02             	shl    $0x2,%eax
 320:	01 d0                	add    %edx,%eax
 322:	01 c0                	add    %eax,%eax
 324:	89 c1                	mov    %eax,%ecx
 326:	8b 45 08             	mov    0x8(%ebp),%eax
 329:	8d 50 01             	lea    0x1(%eax),%edx
 32c:	89 55 08             	mov    %edx,0x8(%ebp)
 32f:	0f b6 00             	movzbl (%eax),%eax
 332:	0f be c0             	movsbl %al,%eax
 335:	01 c8                	add    %ecx,%eax
 337:	83 e8 30             	sub    $0x30,%eax
 33a:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 33d:	8b 45 08             	mov    0x8(%ebp),%eax
 340:	0f b6 00             	movzbl (%eax),%eax
 343:	3c 2f                	cmp    $0x2f,%al
 345:	7e 0a                	jle    351 <atoi+0x48>
 347:	8b 45 08             	mov    0x8(%ebp),%eax
 34a:	0f b6 00             	movzbl (%eax),%eax
 34d:	3c 39                	cmp    $0x39,%al
 34f:	7e c7                	jle    318 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 351:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 354:	c9                   	leave  
 355:	c3                   	ret    

00000356 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 356:	55                   	push   %ebp
 357:	89 e5                	mov    %esp,%ebp
 359:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 35c:	8b 45 08             	mov    0x8(%ebp),%eax
 35f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 362:	8b 45 0c             	mov    0xc(%ebp),%eax
 365:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 368:	eb 17                	jmp    381 <memmove+0x2b>
    *dst++ = *src++;
 36a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 36d:	8d 50 01             	lea    0x1(%eax),%edx
 370:	89 55 fc             	mov    %edx,-0x4(%ebp)
 373:	8b 55 f8             	mov    -0x8(%ebp),%edx
 376:	8d 4a 01             	lea    0x1(%edx),%ecx
 379:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 37c:	0f b6 12             	movzbl (%edx),%edx
 37f:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 381:	8b 45 10             	mov    0x10(%ebp),%eax
 384:	8d 50 ff             	lea    -0x1(%eax),%edx
 387:	89 55 10             	mov    %edx,0x10(%ebp)
 38a:	85 c0                	test   %eax,%eax
 38c:	7f dc                	jg     36a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 38e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 391:	c9                   	leave  
 392:	c3                   	ret    

00000393 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 393:	b8 01 00 00 00       	mov    $0x1,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <exit>:
SYSCALL(exit)
 39b:	b8 02 00 00 00       	mov    $0x2,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <wait>:
SYSCALL(wait)
 3a3:	b8 03 00 00 00       	mov    $0x3,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <pipe>:
SYSCALL(pipe)
 3ab:	b8 04 00 00 00       	mov    $0x4,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <read>:
SYSCALL(read)
 3b3:	b8 05 00 00 00       	mov    $0x5,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <write>:
SYSCALL(write)
 3bb:	b8 10 00 00 00       	mov    $0x10,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <close>:
SYSCALL(close)
 3c3:	b8 15 00 00 00       	mov    $0x15,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <kill>:
SYSCALL(kill)
 3cb:	b8 06 00 00 00       	mov    $0x6,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <exec>:
SYSCALL(exec)
 3d3:	b8 07 00 00 00       	mov    $0x7,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <open>:
SYSCALL(open)
 3db:	b8 0f 00 00 00       	mov    $0xf,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <mknod>:
SYSCALL(mknod)
 3e3:	b8 11 00 00 00       	mov    $0x11,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <unlink>:
SYSCALL(unlink)
 3eb:	b8 12 00 00 00       	mov    $0x12,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <fstat>:
SYSCALL(fstat)
 3f3:	b8 08 00 00 00       	mov    $0x8,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <link>:
SYSCALL(link)
 3fb:	b8 13 00 00 00       	mov    $0x13,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <mkdir>:
SYSCALL(mkdir)
 403:	b8 14 00 00 00       	mov    $0x14,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <chdir>:
SYSCALL(chdir)
 40b:	b8 09 00 00 00       	mov    $0x9,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <dup>:
SYSCALL(dup)
 413:	b8 0a 00 00 00       	mov    $0xa,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <getpid>:
SYSCALL(getpid)
 41b:	b8 0b 00 00 00       	mov    $0xb,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <sbrk>:
SYSCALL(sbrk)
 423:	b8 0c 00 00 00       	mov    $0xc,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <sleep>:
SYSCALL(sleep)
 42b:	b8 0d 00 00 00       	mov    $0xd,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <uptime>:
SYSCALL(uptime)
 433:	b8 0e 00 00 00       	mov    $0xe,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <halt>:
SYSCALL(halt)
 43b:	b8 16 00 00 00       	mov    $0x16,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 443:	55                   	push   %ebp
 444:	89 e5                	mov    %esp,%ebp
 446:	83 ec 18             	sub    $0x18,%esp
 449:	8b 45 0c             	mov    0xc(%ebp),%eax
 44c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 44f:	83 ec 04             	sub    $0x4,%esp
 452:	6a 01                	push   $0x1
 454:	8d 45 f4             	lea    -0xc(%ebp),%eax
 457:	50                   	push   %eax
 458:	ff 75 08             	pushl  0x8(%ebp)
 45b:	e8 5b ff ff ff       	call   3bb <write>
 460:	83 c4 10             	add    $0x10,%esp
}
 463:	90                   	nop
 464:	c9                   	leave  
 465:	c3                   	ret    

00000466 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 466:	55                   	push   %ebp
 467:	89 e5                	mov    %esp,%ebp
 469:	53                   	push   %ebx
 46a:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 46d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 474:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 478:	74 17                	je     491 <printint+0x2b>
 47a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 47e:	79 11                	jns    491 <printint+0x2b>
    neg = 1;
 480:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 487:	8b 45 0c             	mov    0xc(%ebp),%eax
 48a:	f7 d8                	neg    %eax
 48c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 48f:	eb 06                	jmp    497 <printint+0x31>
  } else {
    x = xx;
 491:	8b 45 0c             	mov    0xc(%ebp),%eax
 494:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 497:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 49e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4a1:	8d 41 01             	lea    0x1(%ecx),%eax
 4a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ad:	ba 00 00 00 00       	mov    $0x0,%edx
 4b2:	f7 f3                	div    %ebx
 4b4:	89 d0                	mov    %edx,%eax
 4b6:	0f b6 80 a0 0b 00 00 	movzbl 0xba0(%eax),%eax
 4bd:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c7:	ba 00 00 00 00       	mov    $0x0,%edx
 4cc:	f7 f3                	div    %ebx
 4ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4d5:	75 c7                	jne    49e <printint+0x38>
  if(neg)
 4d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4db:	74 2d                	je     50a <printint+0xa4>
    buf[i++] = '-';
 4dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e0:	8d 50 01             	lea    0x1(%eax),%edx
 4e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4e6:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4eb:	eb 1d                	jmp    50a <printint+0xa4>
    putc(fd, buf[i]);
 4ed:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f3:	01 d0                	add    %edx,%eax
 4f5:	0f b6 00             	movzbl (%eax),%eax
 4f8:	0f be c0             	movsbl %al,%eax
 4fb:	83 ec 08             	sub    $0x8,%esp
 4fe:	50                   	push   %eax
 4ff:	ff 75 08             	pushl  0x8(%ebp)
 502:	e8 3c ff ff ff       	call   443 <putc>
 507:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 50a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 50e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 512:	79 d9                	jns    4ed <printint+0x87>
    putc(fd, buf[i]);
}
 514:	90                   	nop
 515:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 518:	c9                   	leave  
 519:	c3                   	ret    

0000051a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 51a:	55                   	push   %ebp
 51b:	89 e5                	mov    %esp,%ebp
 51d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 520:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 527:	8d 45 0c             	lea    0xc(%ebp),%eax
 52a:	83 c0 04             	add    $0x4,%eax
 52d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 530:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 537:	e9 59 01 00 00       	jmp    695 <printf+0x17b>
    c = fmt[i] & 0xff;
 53c:	8b 55 0c             	mov    0xc(%ebp),%edx
 53f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 542:	01 d0                	add    %edx,%eax
 544:	0f b6 00             	movzbl (%eax),%eax
 547:	0f be c0             	movsbl %al,%eax
 54a:	25 ff 00 00 00       	and    $0xff,%eax
 54f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 552:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 556:	75 2c                	jne    584 <printf+0x6a>
      if(c == '%'){
 558:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 55c:	75 0c                	jne    56a <printf+0x50>
        state = '%';
 55e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 565:	e9 27 01 00 00       	jmp    691 <printf+0x177>
      } else {
        putc(fd, c);
 56a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 56d:	0f be c0             	movsbl %al,%eax
 570:	83 ec 08             	sub    $0x8,%esp
 573:	50                   	push   %eax
 574:	ff 75 08             	pushl  0x8(%ebp)
 577:	e8 c7 fe ff ff       	call   443 <putc>
 57c:	83 c4 10             	add    $0x10,%esp
 57f:	e9 0d 01 00 00       	jmp    691 <printf+0x177>
      }
    } else if(state == '%'){
 584:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 588:	0f 85 03 01 00 00    	jne    691 <printf+0x177>
      if(c == 'd'){
 58e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 592:	75 1e                	jne    5b2 <printf+0x98>
        printint(fd, *ap, 10, 1);
 594:	8b 45 e8             	mov    -0x18(%ebp),%eax
 597:	8b 00                	mov    (%eax),%eax
 599:	6a 01                	push   $0x1
 59b:	6a 0a                	push   $0xa
 59d:	50                   	push   %eax
 59e:	ff 75 08             	pushl  0x8(%ebp)
 5a1:	e8 c0 fe ff ff       	call   466 <printint>
 5a6:	83 c4 10             	add    $0x10,%esp
        ap++;
 5a9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ad:	e9 d8 00 00 00       	jmp    68a <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5b2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5b6:	74 06                	je     5be <printf+0xa4>
 5b8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5bc:	75 1e                	jne    5dc <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5be:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c1:	8b 00                	mov    (%eax),%eax
 5c3:	6a 00                	push   $0x0
 5c5:	6a 10                	push   $0x10
 5c7:	50                   	push   %eax
 5c8:	ff 75 08             	pushl  0x8(%ebp)
 5cb:	e8 96 fe ff ff       	call   466 <printint>
 5d0:	83 c4 10             	add    $0x10,%esp
        ap++;
 5d3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d7:	e9 ae 00 00 00       	jmp    68a <printf+0x170>
      } else if(c == 's'){
 5dc:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5e0:	75 43                	jne    625 <printf+0x10b>
        s = (char*)*ap;
 5e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e5:	8b 00                	mov    (%eax),%eax
 5e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5ea:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5f2:	75 25                	jne    619 <printf+0xff>
          s = "(null)";
 5f4:	c7 45 f4 27 09 00 00 	movl   $0x927,-0xc(%ebp)
        while(*s != 0){
 5fb:	eb 1c                	jmp    619 <printf+0xff>
          putc(fd, *s);
 5fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 600:	0f b6 00             	movzbl (%eax),%eax
 603:	0f be c0             	movsbl %al,%eax
 606:	83 ec 08             	sub    $0x8,%esp
 609:	50                   	push   %eax
 60a:	ff 75 08             	pushl  0x8(%ebp)
 60d:	e8 31 fe ff ff       	call   443 <putc>
 612:	83 c4 10             	add    $0x10,%esp
          s++;
 615:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 619:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61c:	0f b6 00             	movzbl (%eax),%eax
 61f:	84 c0                	test   %al,%al
 621:	75 da                	jne    5fd <printf+0xe3>
 623:	eb 65                	jmp    68a <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 625:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 629:	75 1d                	jne    648 <printf+0x12e>
        putc(fd, *ap);
 62b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 62e:	8b 00                	mov    (%eax),%eax
 630:	0f be c0             	movsbl %al,%eax
 633:	83 ec 08             	sub    $0x8,%esp
 636:	50                   	push   %eax
 637:	ff 75 08             	pushl  0x8(%ebp)
 63a:	e8 04 fe ff ff       	call   443 <putc>
 63f:	83 c4 10             	add    $0x10,%esp
        ap++;
 642:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 646:	eb 42                	jmp    68a <printf+0x170>
      } else if(c == '%'){
 648:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 64c:	75 17                	jne    665 <printf+0x14b>
        putc(fd, c);
 64e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 651:	0f be c0             	movsbl %al,%eax
 654:	83 ec 08             	sub    $0x8,%esp
 657:	50                   	push   %eax
 658:	ff 75 08             	pushl  0x8(%ebp)
 65b:	e8 e3 fd ff ff       	call   443 <putc>
 660:	83 c4 10             	add    $0x10,%esp
 663:	eb 25                	jmp    68a <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 665:	83 ec 08             	sub    $0x8,%esp
 668:	6a 25                	push   $0x25
 66a:	ff 75 08             	pushl  0x8(%ebp)
 66d:	e8 d1 fd ff ff       	call   443 <putc>
 672:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 675:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 678:	0f be c0             	movsbl %al,%eax
 67b:	83 ec 08             	sub    $0x8,%esp
 67e:	50                   	push   %eax
 67f:	ff 75 08             	pushl  0x8(%ebp)
 682:	e8 bc fd ff ff       	call   443 <putc>
 687:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 68a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 691:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 695:	8b 55 0c             	mov    0xc(%ebp),%edx
 698:	8b 45 f0             	mov    -0x10(%ebp),%eax
 69b:	01 d0                	add    %edx,%eax
 69d:	0f b6 00             	movzbl (%eax),%eax
 6a0:	84 c0                	test   %al,%al
 6a2:	0f 85 94 fe ff ff    	jne    53c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6a8:	90                   	nop
 6a9:	c9                   	leave  
 6aa:	c3                   	ret    

000006ab <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ab:	55                   	push   %ebp
 6ac:	89 e5                	mov    %esp,%ebp
 6ae:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6b1:	8b 45 08             	mov    0x8(%ebp),%eax
 6b4:	83 e8 08             	sub    $0x8,%eax
 6b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ba:	a1 bc 0b 00 00       	mov    0xbbc,%eax
 6bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c2:	eb 24                	jmp    6e8 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c7:	8b 00                	mov    (%eax),%eax
 6c9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6cc:	77 12                	ja     6e0 <free+0x35>
 6ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d4:	77 24                	ja     6fa <free+0x4f>
 6d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d9:	8b 00                	mov    (%eax),%eax
 6db:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6de:	77 1a                	ja     6fa <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e3:	8b 00                	mov    (%eax),%eax
 6e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6eb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ee:	76 d4                	jbe    6c4 <free+0x19>
 6f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f3:	8b 00                	mov    (%eax),%eax
 6f5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f8:	76 ca                	jbe    6c4 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fd:	8b 40 04             	mov    0x4(%eax),%eax
 700:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 707:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70a:	01 c2                	add    %eax,%edx
 70c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70f:	8b 00                	mov    (%eax),%eax
 711:	39 c2                	cmp    %eax,%edx
 713:	75 24                	jne    739 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 715:	8b 45 f8             	mov    -0x8(%ebp),%eax
 718:	8b 50 04             	mov    0x4(%eax),%edx
 71b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71e:	8b 00                	mov    (%eax),%eax
 720:	8b 40 04             	mov    0x4(%eax),%eax
 723:	01 c2                	add    %eax,%edx
 725:	8b 45 f8             	mov    -0x8(%ebp),%eax
 728:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 72b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72e:	8b 00                	mov    (%eax),%eax
 730:	8b 10                	mov    (%eax),%edx
 732:	8b 45 f8             	mov    -0x8(%ebp),%eax
 735:	89 10                	mov    %edx,(%eax)
 737:	eb 0a                	jmp    743 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 739:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73c:	8b 10                	mov    (%eax),%edx
 73e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 741:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 743:	8b 45 fc             	mov    -0x4(%ebp),%eax
 746:	8b 40 04             	mov    0x4(%eax),%eax
 749:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 750:	8b 45 fc             	mov    -0x4(%ebp),%eax
 753:	01 d0                	add    %edx,%eax
 755:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 758:	75 20                	jne    77a <free+0xcf>
    p->s.size += bp->s.size;
 75a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75d:	8b 50 04             	mov    0x4(%eax),%edx
 760:	8b 45 f8             	mov    -0x8(%ebp),%eax
 763:	8b 40 04             	mov    0x4(%eax),%eax
 766:	01 c2                	add    %eax,%edx
 768:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 76e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 771:	8b 10                	mov    (%eax),%edx
 773:	8b 45 fc             	mov    -0x4(%ebp),%eax
 776:	89 10                	mov    %edx,(%eax)
 778:	eb 08                	jmp    782 <free+0xd7>
  } else
    p->s.ptr = bp;
 77a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 780:	89 10                	mov    %edx,(%eax)
  freep = p;
 782:	8b 45 fc             	mov    -0x4(%ebp),%eax
 785:	a3 bc 0b 00 00       	mov    %eax,0xbbc
}
 78a:	90                   	nop
 78b:	c9                   	leave  
 78c:	c3                   	ret    

0000078d <morecore>:

static Header*
morecore(uint nu)
{
 78d:	55                   	push   %ebp
 78e:	89 e5                	mov    %esp,%ebp
 790:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 793:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 79a:	77 07                	ja     7a3 <morecore+0x16>
    nu = 4096;
 79c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7a3:	8b 45 08             	mov    0x8(%ebp),%eax
 7a6:	c1 e0 03             	shl    $0x3,%eax
 7a9:	83 ec 0c             	sub    $0xc,%esp
 7ac:	50                   	push   %eax
 7ad:	e8 71 fc ff ff       	call   423 <sbrk>
 7b2:	83 c4 10             	add    $0x10,%esp
 7b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7b8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7bc:	75 07                	jne    7c5 <morecore+0x38>
    return 0;
 7be:	b8 00 00 00 00       	mov    $0x0,%eax
 7c3:	eb 26                	jmp    7eb <morecore+0x5e>
  hp = (Header*)p;
 7c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ce:	8b 55 08             	mov    0x8(%ebp),%edx
 7d1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d7:	83 c0 08             	add    $0x8,%eax
 7da:	83 ec 0c             	sub    $0xc,%esp
 7dd:	50                   	push   %eax
 7de:	e8 c8 fe ff ff       	call   6ab <free>
 7e3:	83 c4 10             	add    $0x10,%esp
  return freep;
 7e6:	a1 bc 0b 00 00       	mov    0xbbc,%eax
}
 7eb:	c9                   	leave  
 7ec:	c3                   	ret    

000007ed <malloc>:

void*
malloc(uint nbytes)
{
 7ed:	55                   	push   %ebp
 7ee:	89 e5                	mov    %esp,%ebp
 7f0:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f3:	8b 45 08             	mov    0x8(%ebp),%eax
 7f6:	83 c0 07             	add    $0x7,%eax
 7f9:	c1 e8 03             	shr    $0x3,%eax
 7fc:	83 c0 01             	add    $0x1,%eax
 7ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 802:	a1 bc 0b 00 00       	mov    0xbbc,%eax
 807:	89 45 f0             	mov    %eax,-0x10(%ebp)
 80a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 80e:	75 23                	jne    833 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 810:	c7 45 f0 b4 0b 00 00 	movl   $0xbb4,-0x10(%ebp)
 817:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81a:	a3 bc 0b 00 00       	mov    %eax,0xbbc
 81f:	a1 bc 0b 00 00       	mov    0xbbc,%eax
 824:	a3 b4 0b 00 00       	mov    %eax,0xbb4
    base.s.size = 0;
 829:	c7 05 b8 0b 00 00 00 	movl   $0x0,0xbb8
 830:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 833:	8b 45 f0             	mov    -0x10(%ebp),%eax
 836:	8b 00                	mov    (%eax),%eax
 838:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 83b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83e:	8b 40 04             	mov    0x4(%eax),%eax
 841:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 844:	72 4d                	jb     893 <malloc+0xa6>
      if(p->s.size == nunits)
 846:	8b 45 f4             	mov    -0xc(%ebp),%eax
 849:	8b 40 04             	mov    0x4(%eax),%eax
 84c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 84f:	75 0c                	jne    85d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 851:	8b 45 f4             	mov    -0xc(%ebp),%eax
 854:	8b 10                	mov    (%eax),%edx
 856:	8b 45 f0             	mov    -0x10(%ebp),%eax
 859:	89 10                	mov    %edx,(%eax)
 85b:	eb 26                	jmp    883 <malloc+0x96>
      else {
        p->s.size -= nunits;
 85d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 860:	8b 40 04             	mov    0x4(%eax),%eax
 863:	2b 45 ec             	sub    -0x14(%ebp),%eax
 866:	89 c2                	mov    %eax,%edx
 868:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 86e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 871:	8b 40 04             	mov    0x4(%eax),%eax
 874:	c1 e0 03             	shl    $0x3,%eax
 877:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 87a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 880:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 883:	8b 45 f0             	mov    -0x10(%ebp),%eax
 886:	a3 bc 0b 00 00       	mov    %eax,0xbbc
      return (void*)(p + 1);
 88b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88e:	83 c0 08             	add    $0x8,%eax
 891:	eb 3b                	jmp    8ce <malloc+0xe1>
    }
    if(p == freep)
 893:	a1 bc 0b 00 00       	mov    0xbbc,%eax
 898:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 89b:	75 1e                	jne    8bb <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 89d:	83 ec 0c             	sub    $0xc,%esp
 8a0:	ff 75 ec             	pushl  -0x14(%ebp)
 8a3:	e8 e5 fe ff ff       	call   78d <morecore>
 8a8:	83 c4 10             	add    $0x10,%esp
 8ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8b2:	75 07                	jne    8bb <malloc+0xce>
        return 0;
 8b4:	b8 00 00 00 00       	mov    $0x0,%eax
 8b9:	eb 13                	jmp    8ce <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8be:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c4:	8b 00                	mov    (%eax),%eax
 8c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8c9:	e9 6d ff ff ff       	jmp    83b <malloc+0x4e>
}
 8ce:	c9                   	leave  
 8cf:	c3                   	ret    
