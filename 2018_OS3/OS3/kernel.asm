
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 c6 10 80       	mov    $0x8010c650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 51 38 10 80       	mov    $0x80103851,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 0c 86 10 80       	push   $0x8010860c
80100042:	68 60 c6 10 80       	push   $0x8010c660
80100047:	e8 28 4f 00 00       	call   80104f74 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 70 05 11 80 64 	movl   $0x80110564,0x80110570
80100056:	05 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 74 05 11 80 64 	movl   $0x80110564,0x80110574
80100060:	05 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 94 c6 10 80 	movl   $0x8010c694,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 74 05 11 80    	mov    0x80110574,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 64 05 11 80 	movl   $0x80110564,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 74 05 11 80       	mov    0x80110574,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 74 05 11 80       	mov    %eax,0x80110574

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 64 05 11 80       	mov    $0x80110564,%eax
801000ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ae:	72 bc                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000b0:	90                   	nop
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    

801000b3 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b3:	55                   	push   %ebp
801000b4:	89 e5                	mov    %esp,%ebp
801000b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b9:	83 ec 0c             	sub    $0xc,%esp
801000bc:	68 60 c6 10 80       	push   $0x8010c660
801000c1:	e8 d0 4e 00 00       	call   80104f96 <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 74 05 11 80       	mov    0x80110574,%eax
801000ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d1:	eb 67                	jmp    8010013a <bget+0x87>
    if(b->dev == dev && b->blockno == blockno){
801000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d6:	8b 40 04             	mov    0x4(%eax),%eax
801000d9:	3b 45 08             	cmp    0x8(%ebp),%eax
801000dc:	75 53                	jne    80100131 <bget+0x7e>
801000de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e1:	8b 40 08             	mov    0x8(%eax),%eax
801000e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e7:	75 48                	jne    80100131 <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ec:	8b 00                	mov    (%eax),%eax
801000ee:	83 e0 01             	and    $0x1,%eax
801000f1:	85 c0                	test   %eax,%eax
801000f3:	75 27                	jne    8010011c <bget+0x69>
        b->flags |= B_BUSY;
801000f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f8:	8b 00                	mov    (%eax),%eax
801000fa:	83 c8 01             	or     $0x1,%eax
801000fd:	89 c2                	mov    %eax,%edx
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100104:	83 ec 0c             	sub    $0xc,%esp
80100107:	68 60 c6 10 80       	push   $0x8010c660
8010010c:	e8 ec 4e 00 00       	call   80104ffd <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 60 c6 10 80       	push   $0x8010c660
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 71 4b 00 00       	call   80104c9d <sleep>
8010012c:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012f:	eb 98                	jmp    801000c9 <bget+0x16>

  acquire(&bcache.lock);

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100134:	8b 40 10             	mov    0x10(%eax),%eax
80100137:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010013a:	81 7d f4 64 05 11 80 	cmpl   $0x80110564,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 70 05 11 80       	mov    0x80110570,%eax
80100148:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014b:	eb 51                	jmp    8010019e <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100150:	8b 00                	mov    (%eax),%eax
80100152:	83 e0 01             	and    $0x1,%eax
80100155:	85 c0                	test   %eax,%eax
80100157:	75 3c                	jne    80100195 <bget+0xe2>
80100159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015c:	8b 00                	mov    (%eax),%eax
8010015e:	83 e0 04             	and    $0x4,%eax
80100161:	85 c0                	test   %eax,%eax
80100163:	75 30                	jne    80100195 <bget+0xe2>
      b->dev = dev;
80100165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100168:	8b 55 08             	mov    0x8(%ebp),%edx
8010016b:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100171:	8b 55 0c             	mov    0xc(%ebp),%edx
80100174:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100180:	83 ec 0c             	sub    $0xc,%esp
80100183:	68 60 c6 10 80       	push   $0x8010c660
80100188:	e8 70 4e 00 00       	call   80104ffd <release>
8010018d:	83 c4 10             	add    $0x10,%esp
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1f                	jmp    801001b4 <bget+0x101>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 0c             	mov    0xc(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 64 05 11 80 	cmpl   $0x80110564,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 13 86 10 80       	push   $0x80108613
801001af:	e8 b2 03 00 00       	call   80100566 <panic>
}
801001b4:	c9                   	leave  
801001b5:	c3                   	ret    

801001b6 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b6:	55                   	push   %ebp
801001b7:	89 e5                	mov    %esp,%ebp
801001b9:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bc:	83 ec 08             	sub    $0x8,%esp
801001bf:	ff 75 0c             	pushl  0xc(%ebp)
801001c2:	ff 75 08             	pushl  0x8(%ebp)
801001c5:	e8 e9 fe ff ff       	call   801000b3 <bget>
801001ca:	83 c4 10             	add    $0x10,%esp
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0e                	jne    801001ea <bread+0x34>
    iderw(b);
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	ff 75 f4             	pushl  -0xc(%ebp)
801001e2:	e8 e8 26 00 00       	call   801028cf <iderw>
801001e7:	83 c4 10             	add    $0x10,%esp
  }
  return b;
801001ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ed:	c9                   	leave  
801001ee:	c3                   	ret    

801001ef <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ef:	55                   	push   %ebp
801001f0:	89 e5                	mov    %esp,%ebp
801001f2:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f5:	8b 45 08             	mov    0x8(%ebp),%eax
801001f8:	8b 00                	mov    (%eax),%eax
801001fa:	83 e0 01             	and    $0x1,%eax
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 0d                	jne    8010020e <bwrite+0x1f>
    panic("bwrite");
80100201:	83 ec 0c             	sub    $0xc,%esp
80100204:	68 24 86 10 80       	push   $0x80108624
80100209:	e8 58 03 00 00       	call   80100566 <panic>
  b->flags |= B_DIRTY;
8010020e:	8b 45 08             	mov    0x8(%ebp),%eax
80100211:	8b 00                	mov    (%eax),%eax
80100213:	83 c8 04             	or     $0x4,%eax
80100216:	89 c2                	mov    %eax,%edx
80100218:	8b 45 08             	mov    0x8(%ebp),%eax
8010021b:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021d:	83 ec 0c             	sub    $0xc,%esp
80100220:	ff 75 08             	pushl  0x8(%ebp)
80100223:	e8 a7 26 00 00       	call   801028cf <iderw>
80100228:	83 c4 10             	add    $0x10,%esp
}
8010022b:	90                   	nop
8010022c:	c9                   	leave  
8010022d:	c3                   	ret    

8010022e <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022e:	55                   	push   %ebp
8010022f:	89 e5                	mov    %esp,%ebp
80100231:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100234:	8b 45 08             	mov    0x8(%ebp),%eax
80100237:	8b 00                	mov    (%eax),%eax
80100239:	83 e0 01             	and    $0x1,%eax
8010023c:	85 c0                	test   %eax,%eax
8010023e:	75 0d                	jne    8010024d <brelse+0x1f>
    panic("brelse");
80100240:	83 ec 0c             	sub    $0xc,%esp
80100243:	68 2b 86 10 80       	push   $0x8010862b
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 60 c6 10 80       	push   $0x8010c660
80100255:	e8 3c 4d 00 00       	call   80104f96 <acquire>
8010025a:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025d:	8b 45 08             	mov    0x8(%ebp),%eax
80100260:	8b 40 10             	mov    0x10(%eax),%eax
80100263:	8b 55 08             	mov    0x8(%ebp),%edx
80100266:	8b 52 0c             	mov    0xc(%edx),%edx
80100269:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
8010026c:	8b 45 08             	mov    0x8(%ebp),%eax
8010026f:	8b 40 0c             	mov    0xc(%eax),%eax
80100272:	8b 55 08             	mov    0x8(%ebp),%edx
80100275:	8b 52 10             	mov    0x10(%edx),%edx
80100278:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010027b:	8b 15 74 05 11 80    	mov    0x80110574,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c 64 05 11 80 	movl   $0x80110564,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 74 05 11 80       	mov    0x80110574,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 74 05 11 80       	mov    %eax,0x80110574

  b->flags &= ~B_BUSY;
801002a4:	8b 45 08             	mov    0x8(%ebp),%eax
801002a7:	8b 00                	mov    (%eax),%eax
801002a9:	83 e0 fe             	and    $0xfffffffe,%eax
801002ac:	89 c2                	mov    %eax,%edx
801002ae:	8b 45 08             	mov    0x8(%ebp),%eax
801002b1:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b3:	83 ec 0c             	sub    $0xc,%esp
801002b6:	ff 75 08             	pushl  0x8(%ebp)
801002b9:	e8 ca 4a 00 00       	call   80104d88 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 60 c6 10 80       	push   $0x8010c660
801002c9:	e8 2f 4d 00 00       	call   80104ffd <release>
801002ce:	83 c4 10             	add    $0x10,%esp
}
801002d1:	90                   	nop
801002d2:	c9                   	leave  
801002d3:	c3                   	ret    

801002d4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d4:	55                   	push   %ebp
801002d5:	89 e5                	mov    %esp,%ebp
801002d7:	83 ec 14             	sub    $0x14,%esp
801002da:	8b 45 08             	mov    0x8(%ebp),%eax
801002dd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e5:	89 c2                	mov    %eax,%edx
801002e7:	ec                   	in     (%dx),%al
801002e8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002eb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002ef:	c9                   	leave  
801002f0:	c3                   	ret    

801002f1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	83 ec 08             	sub    $0x8,%esp
801002f7:	8b 55 08             	mov    0x8(%ebp),%edx
801002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801002fd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100301:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100304:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100308:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010030c:	ee                   	out    %al,(%dx)
}
8010030d:	90                   	nop
8010030e:	c9                   	leave  
8010030f:	c3                   	ret    

80100310 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100310:	55                   	push   %ebp
80100311:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100313:	fa                   	cli    
}
80100314:	90                   	nop
80100315:	5d                   	pop    %ebp
80100316:	c3                   	ret    

80100317 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100317:	55                   	push   %ebp
80100318:	89 e5                	mov    %esp,%ebp
8010031a:	53                   	push   %ebx
8010031b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010031e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100322:	74 1c                	je     80100340 <printint+0x29>
80100324:	8b 45 08             	mov    0x8(%ebp),%eax
80100327:	c1 e8 1f             	shr    $0x1f,%eax
8010032a:	0f b6 c0             	movzbl %al,%eax
8010032d:	89 45 10             	mov    %eax,0x10(%ebp)
80100330:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100334:	74 0a                	je     80100340 <printint+0x29>
    x = -xx;
80100336:	8b 45 08             	mov    0x8(%ebp),%eax
80100339:	f7 d8                	neg    %eax
8010033b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010033e:	eb 06                	jmp    80100346 <printint+0x2f>
  else
    x = xx;
80100340:	8b 45 08             	mov    0x8(%ebp),%eax
80100343:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010034d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100350:	8d 41 01             	lea    0x1(%ecx),%eax
80100353:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100356:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100359:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035c:	ba 00 00 00 00       	mov    $0x0,%edx
80100361:	f7 f3                	div    %ebx
80100363:	89 d0                	mov    %edx,%eax
80100365:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
8010036c:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
80100370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100376:	ba 00 00 00 00       	mov    $0x0,%edx
8010037b:	f7 f3                	div    %ebx
8010037d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100380:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100384:	75 c7                	jne    8010034d <printint+0x36>

  if(sign)
80100386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038a:	74 2a                	je     801003b6 <printint+0x9f>
    buf[i++] = '-';
8010038c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038f:	8d 50 01             	lea    0x1(%eax),%edx
80100392:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100395:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039a:	eb 1a                	jmp    801003b6 <printint+0x9f>
    consputc(buf[i]);
8010039c:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010039f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a2:	01 d0                	add    %edx,%eax
801003a4:	0f b6 00             	movzbl (%eax),%eax
801003a7:	0f be c0             	movsbl %al,%eax
801003aa:	83 ec 0c             	sub    $0xc,%esp
801003ad:	50                   	push   %eax
801003ae:	e8 df 03 00 00       	call   80100792 <consputc>
801003b3:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003be:	79 dc                	jns    8010039c <printint+0x85>
    consputc(buf[i]);
}
801003c0:	90                   	nop
801003c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003c4:	c9                   	leave  
801003c5:	c3                   	ret    

801003c6 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c6:	55                   	push   %ebp
801003c7:	89 e5                	mov    %esp,%ebp
801003c9:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003cc:	a1 f4 b5 10 80       	mov    0x8010b5f4,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 c0 b5 10 80       	push   $0x8010b5c0
801003e2:	e8 af 4b 00 00       	call   80104f96 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 32 86 10 80       	push   $0x80108632
801003f9:	e8 68 01 00 00       	call   80100566 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fe:	8d 45 0c             	lea    0xc(%ebp),%eax
80100401:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010040b:	e9 1a 01 00 00       	jmp    8010052a <cprintf+0x164>
    if(c != '%'){
80100410:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100414:	74 13                	je     80100429 <cprintf+0x63>
      consputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	ff 75 e4             	pushl  -0x1c(%ebp)
8010041c:	e8 71 03 00 00       	call   80100792 <consputc>
80100421:	83 c4 10             	add    $0x10,%esp
      continue;
80100424:	e9 fd 00 00 00       	jmp    80100526 <cprintf+0x160>
    }
    c = fmt[++i] & 0xff;
80100429:	8b 55 08             	mov    0x8(%ebp),%edx
8010042c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100433:	01 d0                	add    %edx,%eax
80100435:	0f b6 00             	movzbl (%eax),%eax
80100438:	0f be c0             	movsbl %al,%eax
8010043b:	25 ff 00 00 00       	and    $0xff,%eax
80100440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100443:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100447:	0f 84 ff 00 00 00    	je     8010054c <cprintf+0x186>
      break;
    switch(c){
8010044d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100450:	83 f8 70             	cmp    $0x70,%eax
80100453:	74 47                	je     8010049c <cprintf+0xd6>
80100455:	83 f8 70             	cmp    $0x70,%eax
80100458:	7f 13                	jg     8010046d <cprintf+0xa7>
8010045a:	83 f8 25             	cmp    $0x25,%eax
8010045d:	0f 84 98 00 00 00    	je     801004fb <cprintf+0x135>
80100463:	83 f8 64             	cmp    $0x64,%eax
80100466:	74 14                	je     8010047c <cprintf+0xb6>
80100468:	e9 9d 00 00 00       	jmp    8010050a <cprintf+0x144>
8010046d:	83 f8 73             	cmp    $0x73,%eax
80100470:	74 47                	je     801004b9 <cprintf+0xf3>
80100472:	83 f8 78             	cmp    $0x78,%eax
80100475:	74 25                	je     8010049c <cprintf+0xd6>
80100477:	e9 8e 00 00 00       	jmp    8010050a <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
8010047c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047f:	8d 50 04             	lea    0x4(%eax),%edx
80100482:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100485:	8b 00                	mov    (%eax),%eax
80100487:	83 ec 04             	sub    $0x4,%esp
8010048a:	6a 01                	push   $0x1
8010048c:	6a 0a                	push   $0xa
8010048e:	50                   	push   %eax
8010048f:	e8 83 fe ff ff       	call   80100317 <printint>
80100494:	83 c4 10             	add    $0x10,%esp
      break;
80100497:	e9 8a 00 00 00       	jmp    80100526 <cprintf+0x160>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	83 ec 04             	sub    $0x4,%esp
801004aa:	6a 00                	push   $0x0
801004ac:	6a 10                	push   $0x10
801004ae:	50                   	push   %eax
801004af:	e8 63 fe ff ff       	call   80100317 <printint>
801004b4:	83 c4 10             	add    $0x10,%esp
      break;
801004b7:	eb 6d                	jmp    80100526 <cprintf+0x160>
    case 's':
      if((s = (char*)*argp++) == 0)
801004b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004bc:	8d 50 04             	lea    0x4(%eax),%edx
801004bf:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c2:	8b 00                	mov    (%eax),%eax
801004c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004cb:	75 22                	jne    801004ef <cprintf+0x129>
        s = "(null)";
801004cd:	c7 45 ec 3b 86 10 80 	movl   $0x8010863b,-0x14(%ebp)
      for(; *s; s++)
801004d4:	eb 19                	jmp    801004ef <cprintf+0x129>
        consputc(*s);
801004d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d9:	0f b6 00             	movzbl (%eax),%eax
801004dc:	0f be c0             	movsbl %al,%eax
801004df:	83 ec 0c             	sub    $0xc,%esp
801004e2:	50                   	push   %eax
801004e3:	e8 aa 02 00 00       	call   80100792 <consputc>
801004e8:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004eb:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004f2:	0f b6 00             	movzbl (%eax),%eax
801004f5:	84 c0                	test   %al,%al
801004f7:	75 dd                	jne    801004d6 <cprintf+0x110>
        consputc(*s);
      break;
801004f9:	eb 2b                	jmp    80100526 <cprintf+0x160>
    case '%':
      consputc('%');
801004fb:	83 ec 0c             	sub    $0xc,%esp
801004fe:	6a 25                	push   $0x25
80100500:	e8 8d 02 00 00       	call   80100792 <consputc>
80100505:	83 c4 10             	add    $0x10,%esp
      break;
80100508:	eb 1c                	jmp    80100526 <cprintf+0x160>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010050a:	83 ec 0c             	sub    $0xc,%esp
8010050d:	6a 25                	push   $0x25
8010050f:	e8 7e 02 00 00       	call   80100792 <consputc>
80100514:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100517:	83 ec 0c             	sub    $0xc,%esp
8010051a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010051d:	e8 70 02 00 00       	call   80100792 <consputc>
80100522:	83 c4 10             	add    $0x10,%esp
      break;
80100525:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100526:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010052a:	8b 55 08             	mov    0x8(%ebp),%edx
8010052d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100530:	01 d0                	add    %edx,%eax
80100532:	0f b6 00             	movzbl (%eax),%eax
80100535:	0f be c0             	movsbl %al,%eax
80100538:	25 ff 00 00 00       	and    $0xff,%eax
8010053d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100540:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100544:	0f 85 c6 fe ff ff    	jne    80100410 <cprintf+0x4a>
8010054a:	eb 01                	jmp    8010054d <cprintf+0x187>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
8010054c:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
8010054d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100551:	74 10                	je     80100563 <cprintf+0x19d>
    release(&cons.lock);
80100553:	83 ec 0c             	sub    $0xc,%esp
80100556:	68 c0 b5 10 80       	push   $0x8010b5c0
8010055b:	e8 9d 4a 00 00       	call   80104ffd <release>
80100560:	83 c4 10             	add    $0x10,%esp
}
80100563:	90                   	nop
80100564:	c9                   	leave  
80100565:	c3                   	ret    

80100566 <panic>:

void
panic(char *s)
{
80100566:	55                   	push   %ebp
80100567:	89 e5                	mov    %esp,%ebp
80100569:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
8010056c:	e8 9f fd ff ff       	call   80100310 <cli>
  cons.locking = 0;
80100571:	c7 05 f4 b5 10 80 00 	movl   $0x0,0x8010b5f4
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 42 86 10 80       	push   $0x80108642
80100590:	e8 31 fe ff ff       	call   801003c6 <cprintf>
80100595:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100598:	8b 45 08             	mov    0x8(%ebp),%eax
8010059b:	83 ec 0c             	sub    $0xc,%esp
8010059e:	50                   	push   %eax
8010059f:	e8 22 fe ff ff       	call   801003c6 <cprintf>
801005a4:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005a7:	83 ec 0c             	sub    $0xc,%esp
801005aa:	68 51 86 10 80       	push   $0x80108651
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 88 4a 00 00       	call   8010504f <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 53 86 10 80       	push   $0x80108653
801005e3:	e8 de fd ff ff       	call   801003c6 <cprintf>
801005e8:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005ef:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005f3:	7e de                	jle    801005d3 <panic+0x6d>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005f5:	c7 05 a0 b5 10 80 01 	movl   $0x1,0x8010b5a0
801005fc:	00 00 00 
  for(;;)
    ;
801005ff:	eb fe                	jmp    801005ff <panic+0x99>

80100601 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100601:	55                   	push   %ebp
80100602:	89 e5                	mov    %esp,%ebp
80100604:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100607:	6a 0e                	push   $0xe
80100609:	68 d4 03 00 00       	push   $0x3d4
8010060e:	e8 de fc ff ff       	call   801002f1 <outb>
80100613:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100616:	68 d5 03 00 00       	push   $0x3d5
8010061b:	e8 b4 fc ff ff       	call   801002d4 <inb>
80100620:	83 c4 04             	add    $0x4,%esp
80100623:	0f b6 c0             	movzbl %al,%eax
80100626:	c1 e0 08             	shl    $0x8,%eax
80100629:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010062c:	6a 0f                	push   $0xf
8010062e:	68 d4 03 00 00       	push   $0x3d4
80100633:	e8 b9 fc ff ff       	call   801002f1 <outb>
80100638:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
8010063b:	68 d5 03 00 00       	push   $0x3d5
80100640:	e8 8f fc ff ff       	call   801002d4 <inb>
80100645:	83 c4 04             	add    $0x4,%esp
80100648:	0f b6 c0             	movzbl %al,%eax
8010064b:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010064e:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100652:	75 30                	jne    80100684 <cgaputc+0x83>
    pos += 80 - pos%80;
80100654:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100657:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010065c:	89 c8                	mov    %ecx,%eax
8010065e:	f7 ea                	imul   %edx
80100660:	c1 fa 05             	sar    $0x5,%edx
80100663:	89 c8                	mov    %ecx,%eax
80100665:	c1 f8 1f             	sar    $0x1f,%eax
80100668:	29 c2                	sub    %eax,%edx
8010066a:	89 d0                	mov    %edx,%eax
8010066c:	c1 e0 02             	shl    $0x2,%eax
8010066f:	01 d0                	add    %edx,%eax
80100671:	c1 e0 04             	shl    $0x4,%eax
80100674:	29 c1                	sub    %eax,%ecx
80100676:	89 ca                	mov    %ecx,%edx
80100678:	b8 50 00 00 00       	mov    $0x50,%eax
8010067d:	29 d0                	sub    %edx,%eax
8010067f:	01 45 f4             	add    %eax,-0xc(%ebp)
80100682:	eb 34                	jmp    801006b8 <cgaputc+0xb7>
  else if(c == BACKSPACE){
80100684:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010068b:	75 0c                	jne    80100699 <cgaputc+0x98>
    if(pos > 0) --pos;
8010068d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100691:	7e 25                	jle    801006b8 <cgaputc+0xb7>
80100693:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100697:	eb 1f                	jmp    801006b8 <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100699:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
8010069f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006a2:	8d 50 01             	lea    0x1(%eax),%edx
801006a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006a8:	01 c0                	add    %eax,%eax
801006aa:	01 c8                	add    %ecx,%eax
801006ac:	8b 55 08             	mov    0x8(%ebp),%edx
801006af:	0f b6 d2             	movzbl %dl,%edx
801006b2:	80 ce 07             	or     $0x7,%dh
801006b5:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
801006b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006bc:	78 09                	js     801006c7 <cgaputc+0xc6>
801006be:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006c5:	7e 0d                	jle    801006d4 <cgaputc+0xd3>
    panic("pos under/overflow");
801006c7:	83 ec 0c             	sub    $0xc,%esp
801006ca:	68 57 86 10 80       	push   $0x80108657
801006cf:	e8 92 fe ff ff       	call   80100566 <panic>
  
  if((pos/80) >= 24){  // Scroll up.
801006d4:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006db:	7e 4c                	jle    80100729 <cgaputc+0x128>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006dd:	a1 00 90 10 80       	mov    0x80109000,%eax
801006e2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006e8:	a1 00 90 10 80       	mov    0x80109000,%eax
801006ed:	83 ec 04             	sub    $0x4,%esp
801006f0:	68 60 0e 00 00       	push   $0xe60
801006f5:	52                   	push   %edx
801006f6:	50                   	push   %eax
801006f7:	e8 bc 4b 00 00       	call   801052b8 <memmove>
801006fc:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006ff:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100703:	b8 80 07 00 00       	mov    $0x780,%eax
80100708:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010070b:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010070e:	a1 00 90 10 80       	mov    0x80109000,%eax
80100713:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100716:	01 c9                	add    %ecx,%ecx
80100718:	01 c8                	add    %ecx,%eax
8010071a:	83 ec 04             	sub    $0x4,%esp
8010071d:	52                   	push   %edx
8010071e:	6a 00                	push   $0x0
80100720:	50                   	push   %eax
80100721:	e8 d3 4a 00 00       	call   801051f9 <memset>
80100726:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
80100729:	83 ec 08             	sub    $0x8,%esp
8010072c:	6a 0e                	push   $0xe
8010072e:	68 d4 03 00 00       	push   $0x3d4
80100733:	e8 b9 fb ff ff       	call   801002f1 <outb>
80100738:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
8010073b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010073e:	c1 f8 08             	sar    $0x8,%eax
80100741:	0f b6 c0             	movzbl %al,%eax
80100744:	83 ec 08             	sub    $0x8,%esp
80100747:	50                   	push   %eax
80100748:	68 d5 03 00 00       	push   $0x3d5
8010074d:	e8 9f fb ff ff       	call   801002f1 <outb>
80100752:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100755:	83 ec 08             	sub    $0x8,%esp
80100758:	6a 0f                	push   $0xf
8010075a:	68 d4 03 00 00       	push   $0x3d4
8010075f:	e8 8d fb ff ff       	call   801002f1 <outb>
80100764:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
80100767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010076a:	0f b6 c0             	movzbl %al,%eax
8010076d:	83 ec 08             	sub    $0x8,%esp
80100770:	50                   	push   %eax
80100771:	68 d5 03 00 00       	push   $0x3d5
80100776:	e8 76 fb ff ff       	call   801002f1 <outb>
8010077b:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
8010077e:	a1 00 90 10 80       	mov    0x80109000,%eax
80100783:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100786:	01 d2                	add    %edx,%edx
80100788:	01 d0                	add    %edx,%eax
8010078a:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010078f:	90                   	nop
80100790:	c9                   	leave  
80100791:	c3                   	ret    

80100792 <consputc>:

void
consputc(int c)
{
80100792:	55                   	push   %ebp
80100793:	89 e5                	mov    %esp,%ebp
80100795:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100798:	a1 a0 b5 10 80       	mov    0x8010b5a0,%eax
8010079d:	85 c0                	test   %eax,%eax
8010079f:	74 07                	je     801007a8 <consputc+0x16>
    cli();
801007a1:	e8 6a fb ff ff       	call   80100310 <cli>
    for(;;)
      ;
801007a6:	eb fe                	jmp    801007a6 <consputc+0x14>
  }

  if(c == BACKSPACE){
801007a8:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007af:	75 29                	jne    801007da <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007b1:	83 ec 0c             	sub    $0xc,%esp
801007b4:	6a 08                	push   $0x8
801007b6:	e8 ea 63 00 00       	call   80106ba5 <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 dd 63 00 00       	call   80106ba5 <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 d0 63 00 00       	call   80106ba5 <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 c0 63 00 00       	call   80106ba5 <uartputc>
801007e5:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	ff 75 08             	pushl  0x8(%ebp)
801007ee:	e8 0e fe ff ff       	call   80100601 <cgaputc>
801007f3:	83 c4 10             	add    $0x10,%esp
}
801007f6:	90                   	nop
801007f7:	c9                   	leave  
801007f8:	c3                   	ret    

801007f9 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f9:	55                   	push   %ebp
801007fa:	89 e5                	mov    %esp,%ebp
801007fc:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
801007ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
80100806:	83 ec 0c             	sub    $0xc,%esp
80100809:	68 c0 b5 10 80       	push   $0x8010b5c0
8010080e:	e8 83 47 00 00       	call   80104f96 <acquire>
80100813:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100816:	e9 44 01 00 00       	jmp    8010095f <consoleintr+0x166>
    switch(c){
8010081b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010081e:	83 f8 10             	cmp    $0x10,%eax
80100821:	74 1e                	je     80100841 <consoleintr+0x48>
80100823:	83 f8 10             	cmp    $0x10,%eax
80100826:	7f 0a                	jg     80100832 <consoleintr+0x39>
80100828:	83 f8 08             	cmp    $0x8,%eax
8010082b:	74 6b                	je     80100898 <consoleintr+0x9f>
8010082d:	e9 9b 00 00 00       	jmp    801008cd <consoleintr+0xd4>
80100832:	83 f8 15             	cmp    $0x15,%eax
80100835:	74 33                	je     8010086a <consoleintr+0x71>
80100837:	83 f8 7f             	cmp    $0x7f,%eax
8010083a:	74 5c                	je     80100898 <consoleintr+0x9f>
8010083c:	e9 8c 00 00 00       	jmp    801008cd <consoleintr+0xd4>
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
80100841:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100848:	e9 12 01 00 00       	jmp    8010095f <consoleintr+0x166>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
8010084d:	a1 08 08 11 80       	mov    0x80110808,%eax
80100852:	83 e8 01             	sub    $0x1,%eax
80100855:	a3 08 08 11 80       	mov    %eax,0x80110808
        consputc(BACKSPACE);
8010085a:	83 ec 0c             	sub    $0xc,%esp
8010085d:	68 00 01 00 00       	push   $0x100
80100862:	e8 2b ff ff ff       	call   80100792 <consputc>
80100867:	83 c4 10             	add    $0x10,%esp
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010086a:	8b 15 08 08 11 80    	mov    0x80110808,%edx
80100870:	a1 04 08 11 80       	mov    0x80110804,%eax
80100875:	39 c2                	cmp    %eax,%edx
80100877:	0f 84 e2 00 00 00    	je     8010095f <consoleintr+0x166>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010087d:	a1 08 08 11 80       	mov    0x80110808,%eax
80100882:	83 e8 01             	sub    $0x1,%eax
80100885:	83 e0 7f             	and    $0x7f,%eax
80100888:	0f b6 80 80 07 11 80 	movzbl -0x7feef880(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010088f:	3c 0a                	cmp    $0xa,%al
80100891:	75 ba                	jne    8010084d <consoleintr+0x54>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100893:	e9 c7 00 00 00       	jmp    8010095f <consoleintr+0x166>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100898:	8b 15 08 08 11 80    	mov    0x80110808,%edx
8010089e:	a1 04 08 11 80       	mov    0x80110804,%eax
801008a3:	39 c2                	cmp    %eax,%edx
801008a5:	0f 84 b4 00 00 00    	je     8010095f <consoleintr+0x166>
        input.e--;
801008ab:	a1 08 08 11 80       	mov    0x80110808,%eax
801008b0:	83 e8 01             	sub    $0x1,%eax
801008b3:	a3 08 08 11 80       	mov    %eax,0x80110808
        consputc(BACKSPACE);
801008b8:	83 ec 0c             	sub    $0xc,%esp
801008bb:	68 00 01 00 00       	push   $0x100
801008c0:	e8 cd fe ff ff       	call   80100792 <consputc>
801008c5:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008c8:	e9 92 00 00 00       	jmp    8010095f <consoleintr+0x166>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801008d1:	0f 84 87 00 00 00    	je     8010095e <consoleintr+0x165>
801008d7:	8b 15 08 08 11 80    	mov    0x80110808,%edx
801008dd:	a1 00 08 11 80       	mov    0x80110800,%eax
801008e2:	29 c2                	sub    %eax,%edx
801008e4:	89 d0                	mov    %edx,%eax
801008e6:	83 f8 7f             	cmp    $0x7f,%eax
801008e9:	77 73                	ja     8010095e <consoleintr+0x165>
        c = (c == '\r') ? '\n' : c;
801008eb:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801008ef:	74 05                	je     801008f6 <consoleintr+0xfd>
801008f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008f4:	eb 05                	jmp    801008fb <consoleintr+0x102>
801008f6:	b8 0a 00 00 00       	mov    $0xa,%eax
801008fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008fe:	a1 08 08 11 80       	mov    0x80110808,%eax
80100903:	8d 50 01             	lea    0x1(%eax),%edx
80100906:	89 15 08 08 11 80    	mov    %edx,0x80110808
8010090c:	83 e0 7f             	and    $0x7f,%eax
8010090f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100912:	88 90 80 07 11 80    	mov    %dl,-0x7feef880(%eax)
        consputc(c);
80100918:	83 ec 0c             	sub    $0xc,%esp
8010091b:	ff 75 f0             	pushl  -0x10(%ebp)
8010091e:	e8 6f fe ff ff       	call   80100792 <consputc>
80100923:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100926:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
8010092a:	74 18                	je     80100944 <consoleintr+0x14b>
8010092c:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100930:	74 12                	je     80100944 <consoleintr+0x14b>
80100932:	a1 08 08 11 80       	mov    0x80110808,%eax
80100937:	8b 15 00 08 11 80    	mov    0x80110800,%edx
8010093d:	83 ea 80             	sub    $0xffffff80,%edx
80100940:	39 d0                	cmp    %edx,%eax
80100942:	75 1a                	jne    8010095e <consoleintr+0x165>
          input.w = input.e;
80100944:	a1 08 08 11 80       	mov    0x80110808,%eax
80100949:	a3 04 08 11 80       	mov    %eax,0x80110804
          wakeup(&input.r);
8010094e:	83 ec 0c             	sub    $0xc,%esp
80100951:	68 00 08 11 80       	push   $0x80110800
80100956:	e8 2d 44 00 00       	call   80104d88 <wakeup>
8010095b:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
8010095e:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
8010095f:	8b 45 08             	mov    0x8(%ebp),%eax
80100962:	ff d0                	call   *%eax
80100964:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100967:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010096b:	0f 89 aa fe ff ff    	jns    8010081b <consoleintr+0x22>
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100971:	83 ec 0c             	sub    $0xc,%esp
80100974:	68 c0 b5 10 80       	push   $0x8010b5c0
80100979:	e8 7f 46 00 00       	call   80104ffd <release>
8010097e:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
80100981:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100985:	74 05                	je     8010098c <consoleintr+0x193>
    procdump();  // now call procdump() wo. cons.lock held
80100987:	e8 b7 44 00 00       	call   80104e43 <procdump>
  }
}
8010098c:	90                   	nop
8010098d:	c9                   	leave  
8010098e:	c3                   	ret    

8010098f <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010098f:	55                   	push   %ebp
80100990:	89 e5                	mov    %esp,%ebp
80100992:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100995:	83 ec 0c             	sub    $0xc,%esp
80100998:	ff 75 08             	pushl  0x8(%ebp)
8010099b:	e8 ea 10 00 00       	call   80101a8a <iunlock>
801009a0:	83 c4 10             	add    $0x10,%esp
  target = n;
801009a3:	8b 45 10             	mov    0x10(%ebp),%eax
801009a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
801009a9:	83 ec 0c             	sub    $0xc,%esp
801009ac:	68 c0 b5 10 80       	push   $0x8010b5c0
801009b1:	e8 e0 45 00 00       	call   80104f96 <acquire>
801009b6:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009b9:	e9 ac 00 00 00       	jmp    80100a6a <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
801009be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801009c4:	8b 40 28             	mov    0x28(%eax),%eax
801009c7:	85 c0                	test   %eax,%eax
801009c9:	74 28                	je     801009f3 <consoleread+0x64>
        release(&cons.lock);
801009cb:	83 ec 0c             	sub    $0xc,%esp
801009ce:	68 c0 b5 10 80       	push   $0x8010b5c0
801009d3:	e8 25 46 00 00       	call   80104ffd <release>
801009d8:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
801009db:	83 ec 0c             	sub    $0xc,%esp
801009de:	ff 75 08             	pushl  0x8(%ebp)
801009e1:	e8 46 0f 00 00       	call   8010192c <ilock>
801009e6:	83 c4 10             	add    $0x10,%esp
        return -1;
801009e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009ee:	e9 ab 00 00 00       	jmp    80100a9e <consoleread+0x10f>
      }
      sleep(&input.r, &cons.lock);
801009f3:	83 ec 08             	sub    $0x8,%esp
801009f6:	68 c0 b5 10 80       	push   $0x8010b5c0
801009fb:	68 00 08 11 80       	push   $0x80110800
80100a00:	e8 98 42 00 00       	call   80104c9d <sleep>
80100a05:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100a08:	8b 15 00 08 11 80    	mov    0x80110800,%edx
80100a0e:	a1 04 08 11 80       	mov    0x80110804,%eax
80100a13:	39 c2                	cmp    %eax,%edx
80100a15:	74 a7                	je     801009be <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a17:	a1 00 08 11 80       	mov    0x80110800,%eax
80100a1c:	8d 50 01             	lea    0x1(%eax),%edx
80100a1f:	89 15 00 08 11 80    	mov    %edx,0x80110800
80100a25:	83 e0 7f             	and    $0x7f,%eax
80100a28:	0f b6 80 80 07 11 80 	movzbl -0x7feef880(%eax),%eax
80100a2f:	0f be c0             	movsbl %al,%eax
80100a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a35:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a39:	75 17                	jne    80100a52 <consoleread+0xc3>
      if(n < target){
80100a3b:	8b 45 10             	mov    0x10(%ebp),%eax
80100a3e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a41:	73 2f                	jae    80100a72 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a43:	a1 00 08 11 80       	mov    0x80110800,%eax
80100a48:	83 e8 01             	sub    $0x1,%eax
80100a4b:	a3 00 08 11 80       	mov    %eax,0x80110800
      }
      break;
80100a50:	eb 20                	jmp    80100a72 <consoleread+0xe3>
    }
    *dst++ = c;
80100a52:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a55:	8d 50 01             	lea    0x1(%eax),%edx
80100a58:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a5e:	88 10                	mov    %dl,(%eax)
    --n;
80100a60:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a64:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a68:	74 0b                	je     80100a75 <consoleread+0xe6>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100a6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a6e:	7f 98                	jg     80100a08 <consoleread+0x79>
80100a70:	eb 04                	jmp    80100a76 <consoleread+0xe7>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100a72:	90                   	nop
80100a73:	eb 01                	jmp    80100a76 <consoleread+0xe7>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100a75:	90                   	nop
  }
  release(&cons.lock);
80100a76:	83 ec 0c             	sub    $0xc,%esp
80100a79:	68 c0 b5 10 80       	push   $0x8010b5c0
80100a7e:	e8 7a 45 00 00       	call   80104ffd <release>
80100a83:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100a86:	83 ec 0c             	sub    $0xc,%esp
80100a89:	ff 75 08             	pushl  0x8(%ebp)
80100a8c:	e8 9b 0e 00 00       	call   8010192c <ilock>
80100a91:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100a94:	8b 45 10             	mov    0x10(%ebp),%eax
80100a97:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a9a:	29 c2                	sub    %eax,%edx
80100a9c:	89 d0                	mov    %edx,%eax
}
80100a9e:	c9                   	leave  
80100a9f:	c3                   	ret    

80100aa0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100aa0:	55                   	push   %ebp
80100aa1:	89 e5                	mov    %esp,%ebp
80100aa3:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100aa6:	83 ec 0c             	sub    $0xc,%esp
80100aa9:	ff 75 08             	pushl  0x8(%ebp)
80100aac:	e8 d9 0f 00 00       	call   80101a8a <iunlock>
80100ab1:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100ab4:	83 ec 0c             	sub    $0xc,%esp
80100ab7:	68 c0 b5 10 80       	push   $0x8010b5c0
80100abc:	e8 d5 44 00 00       	call   80104f96 <acquire>
80100ac1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100ac4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100acb:	eb 21                	jmp    80100aee <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100acd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ad3:	01 d0                	add    %edx,%eax
80100ad5:	0f b6 00             	movzbl (%eax),%eax
80100ad8:	0f be c0             	movsbl %al,%eax
80100adb:	0f b6 c0             	movzbl %al,%eax
80100ade:	83 ec 0c             	sub    $0xc,%esp
80100ae1:	50                   	push   %eax
80100ae2:	e8 ab fc ff ff       	call   80100792 <consputc>
80100ae7:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100aea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100af1:	3b 45 10             	cmp    0x10(%ebp),%eax
80100af4:	7c d7                	jl     80100acd <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100af6:	83 ec 0c             	sub    $0xc,%esp
80100af9:	68 c0 b5 10 80       	push   $0x8010b5c0
80100afe:	e8 fa 44 00 00       	call   80104ffd <release>
80100b03:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	ff 75 08             	pushl  0x8(%ebp)
80100b0c:	e8 1b 0e 00 00       	call   8010192c <ilock>
80100b11:	83 c4 10             	add    $0x10,%esp

  return n;
80100b14:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b17:	c9                   	leave  
80100b18:	c3                   	ret    

80100b19 <consoleinit>:

void
consoleinit(void)
{
80100b19:	55                   	push   %ebp
80100b1a:	89 e5                	mov    %esp,%ebp
80100b1c:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100b1f:	83 ec 08             	sub    $0x8,%esp
80100b22:	68 6a 86 10 80       	push   $0x8010866a
80100b27:	68 c0 b5 10 80       	push   $0x8010b5c0
80100b2c:	e8 43 44 00 00       	call   80104f74 <initlock>
80100b31:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b34:	c7 05 cc 11 11 80 a0 	movl   $0x80100aa0,0x801111cc
80100b3b:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b3e:	c7 05 c8 11 11 80 8f 	movl   $0x8010098f,0x801111c8
80100b45:	09 10 80 
  cons.locking = 1;
80100b48:	c7 05 f4 b5 10 80 01 	movl   $0x1,0x8010b5f4
80100b4f:	00 00 00 

  picenable(IRQ_KBD);
80100b52:	83 ec 0c             	sub    $0xc,%esp
80100b55:	6a 01                	push   $0x1
80100b57:	e8 57 33 00 00       	call   80103eb3 <picenable>
80100b5c:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b5f:	83 ec 08             	sub    $0x8,%esp
80100b62:	6a 00                	push   $0x0
80100b64:	6a 01                	push   $0x1
80100b66:	e8 31 1f 00 00       	call   80102a9c <ioapicenable>
80100b6b:	83 c4 10             	add    $0x10,%esp
}
80100b6e:	90                   	nop
80100b6f:	c9                   	leave  
80100b70:	c3                   	ret    

80100b71 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b71:	55                   	push   %ebp
80100b72:	89 e5                	mov    %esp,%ebp
80100b74:	81 ec 28 01 00 00    	sub    $0x128,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100b7a:	e8 90 29 00 00       	call   8010350f <begin_op>
  if((ip = namei(path)) == 0){
80100b7f:	83 ec 0c             	sub    $0xc,%esp
80100b82:	ff 75 08             	pushl  0x8(%ebp)
80100b85:	e8 60 19 00 00       	call   801024ea <namei>
80100b8a:	83 c4 10             	add    $0x10,%esp
80100b8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b90:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b94:	75 0f                	jne    80100ba5 <exec+0x34>
    end_op();
80100b96:	e8 00 2a 00 00       	call   8010359b <end_op>
    return -1;
80100b9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba0:	e9 da 03 00 00       	jmp    80100f7f <exec+0x40e>
  }
  ilock(ip);
80100ba5:	83 ec 0c             	sub    $0xc,%esp
80100ba8:	ff 75 d8             	pushl  -0x28(%ebp)
80100bab:	e8 7c 0d 00 00       	call   8010192c <ilock>
80100bb0:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100bb3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100bba:	6a 34                	push   $0x34
80100bbc:	6a 00                	push   $0x0
80100bbe:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bc4:	50                   	push   %eax
80100bc5:	ff 75 d8             	pushl  -0x28(%ebp)
80100bc8:	e8 cd 12 00 00       	call   80101e9a <readi>
80100bcd:	83 c4 10             	add    $0x10,%esp
80100bd0:	83 f8 33             	cmp    $0x33,%eax
80100bd3:	0f 86 55 03 00 00    	jbe    80100f2e <exec+0x3bd>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100bd9:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
80100bdf:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100be4:	0f 85 47 03 00 00    	jne    80100f31 <exec+0x3c0>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100bea:	e8 0b 71 00 00       	call   80107cfa <setupkvm>
80100bef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100bf2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100bf6:	0f 84 38 03 00 00    	je     80100f34 <exec+0x3c3>
    goto bad;

  // Load program into memory.
  sz = 0;
80100bfc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c03:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c0a:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
80100c10:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c13:	e9 ab 00 00 00       	jmp    80100cc3 <exec+0x152>
  //cprintf("[%x %x]\n",ph.vaddr,ph.memsz);
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c18:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c1b:	6a 20                	push   $0x20
80100c1d:	50                   	push   %eax
80100c1e:	8d 85 e4 fe ff ff    	lea    -0x11c(%ebp),%eax
80100c24:	50                   	push   %eax
80100c25:	ff 75 d8             	pushl  -0x28(%ebp)
80100c28:	e8 6d 12 00 00       	call   80101e9a <readi>
80100c2d:	83 c4 10             	add    $0x10,%esp
80100c30:	83 f8 20             	cmp    $0x20,%eax
80100c33:	0f 85 fe 02 00 00    	jne    80100f37 <exec+0x3c6>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c39:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
80100c3f:	83 f8 01             	cmp    $0x1,%eax
80100c42:	75 71                	jne    80100cb5 <exec+0x144>
      continue;
    if(ph.memsz < ph.filesz)
80100c44:	8b 95 f8 fe ff ff    	mov    -0x108(%ebp),%edx
80100c4a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c50:	39 c2                	cmp    %eax,%edx
80100c52:	0f 82 e2 02 00 00    	jb     80100f3a <exec+0x3c9>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c58:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100c5e:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100c64:	01 d0                	add    %edx,%eax
80100c66:	83 ec 04             	sub    $0x4,%esp
80100c69:	50                   	push   %eax
80100c6a:	ff 75 e0             	pushl  -0x20(%ebp)
80100c6d:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c70:	e8 2c 74 00 00       	call   801080a1 <allocuvm>
80100c75:	83 c4 10             	add    $0x10,%esp
80100c78:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c7b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c7f:	0f 84 b8 02 00 00    	je     80100f3d <exec+0x3cc>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c85:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c8b:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100c91:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
80100c97:	83 ec 0c             	sub    $0xc,%esp
80100c9a:	52                   	push   %edx
80100c9b:	50                   	push   %eax
80100c9c:	ff 75 d8             	pushl  -0x28(%ebp)
80100c9f:	51                   	push   %ecx
80100ca0:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ca3:	e8 22 73 00 00       	call   80107fca <loaduvm>
80100ca8:	83 c4 20             	add    $0x20,%esp
80100cab:	85 c0                	test   %eax,%eax
80100cad:	0f 88 8d 02 00 00    	js     80100f40 <exec+0x3cf>
80100cb3:	eb 01                	jmp    80100cb6 <exec+0x145>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  //cprintf("[%x %x]\n",ph.vaddr,ph.memsz);
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100cb5:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cb6:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100cba:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cbd:	83 c0 20             	add    $0x20,%eax
80100cc0:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cc3:	0f b7 85 30 ff ff ff 	movzwl -0xd0(%ebp),%eax
80100cca:	0f b7 c0             	movzwl %ax,%eax
80100ccd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100cd0:	0f 8f 42 ff ff ff    	jg     80100c18 <exec+0xa7>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100cd6:	83 ec 0c             	sub    $0xc,%esp
80100cd9:	ff 75 d8             	pushl  -0x28(%ebp)
80100cdc:	e8 0b 0f 00 00       	call   80101bec <iunlockput>
80100ce1:	83 c4 10             	add    $0x10,%esp
  end_op();
80100ce4:	e8 b2 28 00 00       	call   8010359b <end_op>
  ip = 0;
80100ce9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100cf0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cf3:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cf8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100cfd:	89 45 e0             	mov    %eax,-0x20(%ebp)

  //st = PGROUNDDOWN(KERNBASE-1);
  st=KERNBASE;
80100d00:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
  sb=st-1;
80100d07:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100d0a:	83 e8 01             	sub    $0x1,%eax
80100d0d:	89 45 cc             	mov    %eax,-0x34(%ebp)
  //cprintf("%d %s first : sb = %x\n",proc->pid,proc->name,sb);
  if((sb = allocuvm(pgdir, sb-PGSIZE, sb)) == 0)
80100d10:	8b 45 cc             	mov    -0x34(%ebp),%eax
80100d13:	2d 00 10 00 00       	sub    $0x1000,%eax
80100d18:	83 ec 04             	sub    $0x4,%esp
80100d1b:	ff 75 cc             	pushl  -0x34(%ebp)
80100d1e:	50                   	push   %eax
80100d1f:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d22:	e8 7a 73 00 00       	call   801080a1 <allocuvm>
80100d27:	83 c4 10             	add    $0x10,%esp
80100d2a:	89 45 cc             	mov    %eax,-0x34(%ebp)
80100d2d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
80100d31:	0f 84 0c 02 00 00    	je     80100f43 <exec+0x3d2>
    goto bad;
  sb= PGROUNDDOWN(sb);
80100d37:	81 65 cc 00 f0 ff ff 	andl   $0xfffff000,-0x34(%ebp)
  //clearpteu(pgdir, (char*)(sb));
  sp=st;
80100d3e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100d41:	89 45 dc             	mov    %eax,-0x24(%ebp)
  //cprintf("sb = %x sp = %x st = %x\n",sb,sp,st);

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d44:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d4b:	e9 96 00 00 00       	jmp    80100de6 <exec+0x275>
    if(argc >= MAXARG)
80100d50:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d54:	0f 87 ec 01 00 00    	ja     80100f46 <exec+0x3d5>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d5d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d64:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d67:	01 d0                	add    %edx,%eax
80100d69:	8b 00                	mov    (%eax),%eax
80100d6b:	83 ec 0c             	sub    $0xc,%esp
80100d6e:	50                   	push   %eax
80100d6f:	e8 d2 46 00 00       	call   80105446 <strlen>
80100d74:	83 c4 10             	add    $0x10,%esp
80100d77:	89 c2                	mov    %eax,%edx
80100d79:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d7c:	29 d0                	sub    %edx,%eax
80100d7e:	83 e8 01             	sub    $0x1,%eax
80100d81:	83 e0 fc             	and    $0xfffffffc,%eax
80100d84:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0){
80100d87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d8a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d91:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d94:	01 d0                	add    %edx,%eax
80100d96:	8b 00                	mov    (%eax),%eax
80100d98:	83 ec 0c             	sub    $0xc,%esp
80100d9b:	50                   	push   %eax
80100d9c:	e8 a5 46 00 00       	call   80105446 <strlen>
80100da1:	83 c4 10             	add    $0x10,%esp
80100da4:	83 c0 01             	add    $0x1,%eax
80100da7:	89 c1                	mov    %eax,%ecx
80100da9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100db3:	8b 45 0c             	mov    0xc(%ebp),%eax
80100db6:	01 d0                	add    %edx,%eax
80100db8:	8b 00                	mov    (%eax),%eax
80100dba:	51                   	push   %ecx
80100dbb:	50                   	push   %eax
80100dbc:	ff 75 dc             	pushl  -0x24(%ebp)
80100dbf:	ff 75 d4             	pushl  -0x2c(%ebp)
80100dc2:	e8 a5 77 00 00       	call   8010856c <copyout>
80100dc7:	83 c4 10             	add    $0x10,%esp
80100dca:	85 c0                	test   %eax,%eax
80100dcc:	0f 88 77 01 00 00    	js     80100f49 <exec+0x3d8>
      goto bad;
	}
    ustack[3+argc] = sp;
80100dd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd5:	8d 50 03             	lea    0x3(%eax),%edx
80100dd8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ddb:	89 84 95 38 ff ff ff 	mov    %eax,-0xc8(%ebp,%edx,4)
  //clearpteu(pgdir, (char*)(sb));
  sp=st;
  //cprintf("sb = %x sp = %x st = %x\n",sb,sp,st);

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100de2:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100de6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100de9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100df0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100df3:	01 d0                	add    %edx,%eax
80100df5:	8b 00                	mov    (%eax),%eax
80100df7:	85 c0                	test   %eax,%eax
80100df9:	0f 85 51 ff ff ff    	jne    80100d50 <exec+0x1df>
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0){
      goto bad;
	}
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100dff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e02:	83 c0 03             	add    $0x3,%eax
80100e05:	c7 84 85 38 ff ff ff 	movl   $0x0,-0xc8(%ebp,%eax,4)
80100e0c:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100e10:	c7 85 38 ff ff ff ff 	movl   $0xffffffff,-0xc8(%ebp)
80100e17:	ff ff ff 
  ustack[1] = argc;
80100e1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e1d:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e26:	83 c0 01             	add    $0x1,%eax
80100e29:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e30:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e33:	29 d0                	sub    %edx,%eax
80100e35:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  
  sp -= (3+argc+1) * 4;
80100e3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e3e:	83 c0 04             	add    $0x4,%eax
80100e41:	c1 e0 02             	shl    $0x2,%eax
80100e44:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e4a:	83 c0 04             	add    $0x4,%eax
80100e4d:	c1 e0 02             	shl    $0x2,%eax
80100e50:	50                   	push   %eax
80100e51:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
80100e57:	50                   	push   %eax
80100e58:	ff 75 dc             	pushl  -0x24(%ebp)
80100e5b:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e5e:	e8 09 77 00 00       	call   8010856c <copyout>
80100e63:	83 c4 10             	add    $0x10,%esp
80100e66:	85 c0                	test   %eax,%eax
80100e68:	0f 88 de 00 00 00    	js     80100f4c <exec+0x3db>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e6e:	8b 45 08             	mov    0x8(%ebp),%eax
80100e71:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e77:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e7a:	eb 17                	jmp    80100e93 <exec+0x322>
    if(*s == '/')
80100e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e7f:	0f b6 00             	movzbl (%eax),%eax
80100e82:	3c 2f                	cmp    $0x2f,%al
80100e84:	75 09                	jne    80100e8f <exec+0x31e>
      last = s+1;
80100e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e89:	83 c0 01             	add    $0x1,%eax
80100e8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e8f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e96:	0f b6 00             	movzbl (%eax),%eax
80100e99:	84 c0                	test   %al,%al
80100e9b:	75 df                	jne    80100e7c <exec+0x30b>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e9d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea3:	83 c0 70             	add    $0x70,%eax
80100ea6:	83 ec 04             	sub    $0x4,%esp
80100ea9:	6a 10                	push   $0x10
80100eab:	ff 75 f0             	pushl  -0x10(%ebp)
80100eae:	50                   	push   %eax
80100eaf:	e8 48 45 00 00       	call   801053fc <safestrcpy>
80100eb4:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100eb7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ebd:	8b 40 08             	mov    0x8(%eax),%eax
80100ec0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  proc->pgdir = pgdir;
80100ec3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100ecc:	89 50 08             	mov    %edx,0x8(%eax)
  proc->sz = sz;
80100ecf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed5:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ed8:	89 10                	mov    %edx,(%eax)
  proc->sb = sb;
80100eda:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ee0:	8b 55 cc             	mov    -0x34(%ebp),%edx
80100ee3:	89 50 04             	mov    %edx,0x4(%eax)
  proc->tf->eip = elf.entry;  // main
80100ee6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eec:	8b 40 1c             	mov    0x1c(%eax),%eax
80100eef:	8b 95 1c ff ff ff    	mov    -0xe4(%ebp),%edx
80100ef5:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100ef8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100efe:	8b 40 1c             	mov    0x1c(%eax),%eax
80100f01:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f04:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100f07:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f0d:	83 ec 0c             	sub    $0xc,%esp
80100f10:	50                   	push   %eax
80100f11:	e8 cb 6e 00 00       	call   80107de1 <switchuvm>
80100f16:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f19:	83 ec 0c             	sub    $0xc,%esp
80100f1c:	ff 75 c8             	pushl  -0x38(%ebp)
80100f1f:	e8 03 73 00 00       	call   80108227 <freevm>
80100f24:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f27:	b8 00 00 00 00       	mov    $0x0,%eax
80100f2c:	eb 51                	jmp    80100f7f <exec+0x40e>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100f2e:	90                   	nop
80100f2f:	eb 1c                	jmp    80100f4d <exec+0x3dc>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100f31:	90                   	nop
80100f32:	eb 19                	jmp    80100f4d <exec+0x3dc>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100f34:	90                   	nop
80100f35:	eb 16                	jmp    80100f4d <exec+0x3dc>
  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  //cprintf("[%x %x]\n",ph.vaddr,ph.memsz);
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100f37:	90                   	nop
80100f38:	eb 13                	jmp    80100f4d <exec+0x3dc>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100f3a:	90                   	nop
80100f3b:	eb 10                	jmp    80100f4d <exec+0x3dc>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100f3d:	90                   	nop
80100f3e:	eb 0d                	jmp    80100f4d <exec+0x3dc>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100f40:	90                   	nop
80100f41:	eb 0a                	jmp    80100f4d <exec+0x3dc>
  //st = PGROUNDDOWN(KERNBASE-1);
  st=KERNBASE;
  sb=st-1;
  //cprintf("%d %s first : sb = %x\n",proc->pid,proc->name,sb);
  if((sb = allocuvm(pgdir, sb-PGSIZE, sb)) == 0)
    goto bad;
80100f43:	90                   	nop
80100f44:	eb 07                	jmp    80100f4d <exec+0x3dc>
  //cprintf("sb = %x sp = %x st = %x\n",sb,sp,st);

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100f46:	90                   	nop
80100f47:	eb 04                	jmp    80100f4d <exec+0x3dc>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0){
      goto bad;
80100f49:	90                   	nop
80100f4a:	eb 01                	jmp    80100f4d <exec+0x3dc>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
  
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100f4c:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100f4d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f51:	74 0e                	je     80100f61 <exec+0x3f0>
    freevm(pgdir);
80100f53:	83 ec 0c             	sub    $0xc,%esp
80100f56:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f59:	e8 c9 72 00 00       	call   80108227 <freevm>
80100f5e:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100f61:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f65:	74 13                	je     80100f7a <exec+0x409>
    iunlockput(ip);
80100f67:	83 ec 0c             	sub    $0xc,%esp
80100f6a:	ff 75 d8             	pushl  -0x28(%ebp)
80100f6d:	e8 7a 0c 00 00       	call   80101bec <iunlockput>
80100f72:	83 c4 10             	add    $0x10,%esp
    end_op();
80100f75:	e8 21 26 00 00       	call   8010359b <end_op>
  }
  return -1;
80100f7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f7f:	c9                   	leave  
80100f80:	c3                   	ret    

80100f81 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f81:	55                   	push   %ebp
80100f82:	89 e5                	mov    %esp,%ebp
80100f84:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100f87:	83 ec 08             	sub    $0x8,%esp
80100f8a:	68 72 86 10 80       	push   $0x80108672
80100f8f:	68 20 08 11 80       	push   $0x80110820
80100f94:	e8 db 3f 00 00       	call   80104f74 <initlock>
80100f99:	83 c4 10             	add    $0x10,%esp
}
80100f9c:	90                   	nop
80100f9d:	c9                   	leave  
80100f9e:	c3                   	ret    

80100f9f <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f9f:	55                   	push   %ebp
80100fa0:	89 e5                	mov    %esp,%ebp
80100fa2:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100fa5:	83 ec 0c             	sub    $0xc,%esp
80100fa8:	68 20 08 11 80       	push   $0x80110820
80100fad:	e8 e4 3f 00 00       	call   80104f96 <acquire>
80100fb2:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fb5:	c7 45 f4 54 08 11 80 	movl   $0x80110854,-0xc(%ebp)
80100fbc:	eb 2d                	jmp    80100feb <filealloc+0x4c>
    if(f->ref == 0){
80100fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fc1:	8b 40 04             	mov    0x4(%eax),%eax
80100fc4:	85 c0                	test   %eax,%eax
80100fc6:	75 1f                	jne    80100fe7 <filealloc+0x48>
      f->ref = 1;
80100fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fcb:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100fd2:	83 ec 0c             	sub    $0xc,%esp
80100fd5:	68 20 08 11 80       	push   $0x80110820
80100fda:	e8 1e 40 00 00       	call   80104ffd <release>
80100fdf:	83 c4 10             	add    $0x10,%esp
      return f;
80100fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fe5:	eb 23                	jmp    8010100a <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fe7:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100feb:	b8 b4 11 11 80       	mov    $0x801111b4,%eax
80100ff0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100ff3:	72 c9                	jb     80100fbe <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100ff5:	83 ec 0c             	sub    $0xc,%esp
80100ff8:	68 20 08 11 80       	push   $0x80110820
80100ffd:	e8 fb 3f 00 00       	call   80104ffd <release>
80101002:	83 c4 10             	add    $0x10,%esp
  return 0;
80101005:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010100a:	c9                   	leave  
8010100b:	c3                   	ret    

8010100c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
8010100c:	55                   	push   %ebp
8010100d:	89 e5                	mov    %esp,%ebp
8010100f:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101012:	83 ec 0c             	sub    $0xc,%esp
80101015:	68 20 08 11 80       	push   $0x80110820
8010101a:	e8 77 3f 00 00       	call   80104f96 <acquire>
8010101f:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101022:	8b 45 08             	mov    0x8(%ebp),%eax
80101025:	8b 40 04             	mov    0x4(%eax),%eax
80101028:	85 c0                	test   %eax,%eax
8010102a:	7f 0d                	jg     80101039 <filedup+0x2d>
    panic("filedup");
8010102c:	83 ec 0c             	sub    $0xc,%esp
8010102f:	68 79 86 10 80       	push   $0x80108679
80101034:	e8 2d f5 ff ff       	call   80100566 <panic>
  f->ref++;
80101039:	8b 45 08             	mov    0x8(%ebp),%eax
8010103c:	8b 40 04             	mov    0x4(%eax),%eax
8010103f:	8d 50 01             	lea    0x1(%eax),%edx
80101042:	8b 45 08             	mov    0x8(%ebp),%eax
80101045:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101048:	83 ec 0c             	sub    $0xc,%esp
8010104b:	68 20 08 11 80       	push   $0x80110820
80101050:	e8 a8 3f 00 00       	call   80104ffd <release>
80101055:	83 c4 10             	add    $0x10,%esp
  return f;
80101058:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010105b:	c9                   	leave  
8010105c:	c3                   	ret    

8010105d <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
8010105d:	55                   	push   %ebp
8010105e:	89 e5                	mov    %esp,%ebp
80101060:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
80101063:	83 ec 0c             	sub    $0xc,%esp
80101066:	68 20 08 11 80       	push   $0x80110820
8010106b:	e8 26 3f 00 00       	call   80104f96 <acquire>
80101070:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101073:	8b 45 08             	mov    0x8(%ebp),%eax
80101076:	8b 40 04             	mov    0x4(%eax),%eax
80101079:	85 c0                	test   %eax,%eax
8010107b:	7f 0d                	jg     8010108a <fileclose+0x2d>
    panic("fileclose");
8010107d:	83 ec 0c             	sub    $0xc,%esp
80101080:	68 81 86 10 80       	push   $0x80108681
80101085:	e8 dc f4 ff ff       	call   80100566 <panic>
  if(--f->ref > 0){
8010108a:	8b 45 08             	mov    0x8(%ebp),%eax
8010108d:	8b 40 04             	mov    0x4(%eax),%eax
80101090:	8d 50 ff             	lea    -0x1(%eax),%edx
80101093:	8b 45 08             	mov    0x8(%ebp),%eax
80101096:	89 50 04             	mov    %edx,0x4(%eax)
80101099:	8b 45 08             	mov    0x8(%ebp),%eax
8010109c:	8b 40 04             	mov    0x4(%eax),%eax
8010109f:	85 c0                	test   %eax,%eax
801010a1:	7e 15                	jle    801010b8 <fileclose+0x5b>
    release(&ftable.lock);
801010a3:	83 ec 0c             	sub    $0xc,%esp
801010a6:	68 20 08 11 80       	push   $0x80110820
801010ab:	e8 4d 3f 00 00       	call   80104ffd <release>
801010b0:	83 c4 10             	add    $0x10,%esp
801010b3:	e9 8b 00 00 00       	jmp    80101143 <fileclose+0xe6>
    return;
  }
  ff = *f;
801010b8:	8b 45 08             	mov    0x8(%ebp),%eax
801010bb:	8b 10                	mov    (%eax),%edx
801010bd:	89 55 e0             	mov    %edx,-0x20(%ebp)
801010c0:	8b 50 04             	mov    0x4(%eax),%edx
801010c3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801010c6:	8b 50 08             	mov    0x8(%eax),%edx
801010c9:	89 55 e8             	mov    %edx,-0x18(%ebp)
801010cc:	8b 50 0c             	mov    0xc(%eax),%edx
801010cf:	89 55 ec             	mov    %edx,-0x14(%ebp)
801010d2:	8b 50 10             	mov    0x10(%eax),%edx
801010d5:	89 55 f0             	mov    %edx,-0x10(%ebp)
801010d8:	8b 40 14             	mov    0x14(%eax),%eax
801010db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
801010de:	8b 45 08             	mov    0x8(%ebp),%eax
801010e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
801010e8:	8b 45 08             	mov    0x8(%ebp),%eax
801010eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801010f1:	83 ec 0c             	sub    $0xc,%esp
801010f4:	68 20 08 11 80       	push   $0x80110820
801010f9:	e8 ff 3e 00 00       	call   80104ffd <release>
801010fe:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
80101101:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101104:	83 f8 01             	cmp    $0x1,%eax
80101107:	75 19                	jne    80101122 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
80101109:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
8010110d:	0f be d0             	movsbl %al,%edx
80101110:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101113:	83 ec 08             	sub    $0x8,%esp
80101116:	52                   	push   %edx
80101117:	50                   	push   %eax
80101118:	e8 ff 2f 00 00       	call   8010411c <pipeclose>
8010111d:	83 c4 10             	add    $0x10,%esp
80101120:	eb 21                	jmp    80101143 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
80101122:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101125:	83 f8 02             	cmp    $0x2,%eax
80101128:	75 19                	jne    80101143 <fileclose+0xe6>
    begin_op();
8010112a:	e8 e0 23 00 00       	call   8010350f <begin_op>
    iput(ff.ip);
8010112f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101132:	83 ec 0c             	sub    $0xc,%esp
80101135:	50                   	push   %eax
80101136:	e8 c1 09 00 00       	call   80101afc <iput>
8010113b:	83 c4 10             	add    $0x10,%esp
    end_op();
8010113e:	e8 58 24 00 00       	call   8010359b <end_op>
  }
}
80101143:	c9                   	leave  
80101144:	c3                   	ret    

80101145 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101145:	55                   	push   %ebp
80101146:	89 e5                	mov    %esp,%ebp
80101148:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
8010114b:	8b 45 08             	mov    0x8(%ebp),%eax
8010114e:	8b 00                	mov    (%eax),%eax
80101150:	83 f8 02             	cmp    $0x2,%eax
80101153:	75 40                	jne    80101195 <filestat+0x50>
    ilock(f->ip);
80101155:	8b 45 08             	mov    0x8(%ebp),%eax
80101158:	8b 40 10             	mov    0x10(%eax),%eax
8010115b:	83 ec 0c             	sub    $0xc,%esp
8010115e:	50                   	push   %eax
8010115f:	e8 c8 07 00 00       	call   8010192c <ilock>
80101164:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
80101167:	8b 45 08             	mov    0x8(%ebp),%eax
8010116a:	8b 40 10             	mov    0x10(%eax),%eax
8010116d:	83 ec 08             	sub    $0x8,%esp
80101170:	ff 75 0c             	pushl  0xc(%ebp)
80101173:	50                   	push   %eax
80101174:	e8 db 0c 00 00       	call   80101e54 <stati>
80101179:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
8010117c:	8b 45 08             	mov    0x8(%ebp),%eax
8010117f:	8b 40 10             	mov    0x10(%eax),%eax
80101182:	83 ec 0c             	sub    $0xc,%esp
80101185:	50                   	push   %eax
80101186:	e8 ff 08 00 00       	call   80101a8a <iunlock>
8010118b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010118e:	b8 00 00 00 00       	mov    $0x0,%eax
80101193:	eb 05                	jmp    8010119a <filestat+0x55>
  }
  return -1;
80101195:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010119a:	c9                   	leave  
8010119b:	c3                   	ret    

8010119c <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
8010119c:	55                   	push   %ebp
8010119d:	89 e5                	mov    %esp,%ebp
8010119f:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
801011a2:	8b 45 08             	mov    0x8(%ebp),%eax
801011a5:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801011a9:	84 c0                	test   %al,%al
801011ab:	75 0a                	jne    801011b7 <fileread+0x1b>
    return -1;
801011ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011b2:	e9 9b 00 00 00       	jmp    80101252 <fileread+0xb6>
  if(f->type == FD_PIPE)
801011b7:	8b 45 08             	mov    0x8(%ebp),%eax
801011ba:	8b 00                	mov    (%eax),%eax
801011bc:	83 f8 01             	cmp    $0x1,%eax
801011bf:	75 1a                	jne    801011db <fileread+0x3f>
    return piperead(f->pipe, addr, n);
801011c1:	8b 45 08             	mov    0x8(%ebp),%eax
801011c4:	8b 40 0c             	mov    0xc(%eax),%eax
801011c7:	83 ec 04             	sub    $0x4,%esp
801011ca:	ff 75 10             	pushl  0x10(%ebp)
801011cd:	ff 75 0c             	pushl  0xc(%ebp)
801011d0:	50                   	push   %eax
801011d1:	e8 ee 30 00 00       	call   801042c4 <piperead>
801011d6:	83 c4 10             	add    $0x10,%esp
801011d9:	eb 77                	jmp    80101252 <fileread+0xb6>
  if(f->type == FD_INODE){
801011db:	8b 45 08             	mov    0x8(%ebp),%eax
801011de:	8b 00                	mov    (%eax),%eax
801011e0:	83 f8 02             	cmp    $0x2,%eax
801011e3:	75 60                	jne    80101245 <fileread+0xa9>
    ilock(f->ip);
801011e5:	8b 45 08             	mov    0x8(%ebp),%eax
801011e8:	8b 40 10             	mov    0x10(%eax),%eax
801011eb:	83 ec 0c             	sub    $0xc,%esp
801011ee:	50                   	push   %eax
801011ef:	e8 38 07 00 00       	call   8010192c <ilock>
801011f4:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801011fa:	8b 45 08             	mov    0x8(%ebp),%eax
801011fd:	8b 50 14             	mov    0x14(%eax),%edx
80101200:	8b 45 08             	mov    0x8(%ebp),%eax
80101203:	8b 40 10             	mov    0x10(%eax),%eax
80101206:	51                   	push   %ecx
80101207:	52                   	push   %edx
80101208:	ff 75 0c             	pushl  0xc(%ebp)
8010120b:	50                   	push   %eax
8010120c:	e8 89 0c 00 00       	call   80101e9a <readi>
80101211:	83 c4 10             	add    $0x10,%esp
80101214:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101217:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010121b:	7e 11                	jle    8010122e <fileread+0x92>
      f->off += r;
8010121d:	8b 45 08             	mov    0x8(%ebp),%eax
80101220:	8b 50 14             	mov    0x14(%eax),%edx
80101223:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101226:	01 c2                	add    %eax,%edx
80101228:	8b 45 08             	mov    0x8(%ebp),%eax
8010122b:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
8010122e:	8b 45 08             	mov    0x8(%ebp),%eax
80101231:	8b 40 10             	mov    0x10(%eax),%eax
80101234:	83 ec 0c             	sub    $0xc,%esp
80101237:	50                   	push   %eax
80101238:	e8 4d 08 00 00       	call   80101a8a <iunlock>
8010123d:	83 c4 10             	add    $0x10,%esp
    return r;
80101240:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101243:	eb 0d                	jmp    80101252 <fileread+0xb6>
  }
  panic("fileread");
80101245:	83 ec 0c             	sub    $0xc,%esp
80101248:	68 8b 86 10 80       	push   $0x8010868b
8010124d:	e8 14 f3 ff ff       	call   80100566 <panic>
}
80101252:	c9                   	leave  
80101253:	c3                   	ret    

80101254 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101254:	55                   	push   %ebp
80101255:	89 e5                	mov    %esp,%ebp
80101257:	53                   	push   %ebx
80101258:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
8010125b:	8b 45 08             	mov    0x8(%ebp),%eax
8010125e:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80101262:	84 c0                	test   %al,%al
80101264:	75 0a                	jne    80101270 <filewrite+0x1c>
    return -1;
80101266:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010126b:	e9 1b 01 00 00       	jmp    8010138b <filewrite+0x137>
  if(f->type == FD_PIPE)
80101270:	8b 45 08             	mov    0x8(%ebp),%eax
80101273:	8b 00                	mov    (%eax),%eax
80101275:	83 f8 01             	cmp    $0x1,%eax
80101278:	75 1d                	jne    80101297 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
8010127a:	8b 45 08             	mov    0x8(%ebp),%eax
8010127d:	8b 40 0c             	mov    0xc(%eax),%eax
80101280:	83 ec 04             	sub    $0x4,%esp
80101283:	ff 75 10             	pushl  0x10(%ebp)
80101286:	ff 75 0c             	pushl  0xc(%ebp)
80101289:	50                   	push   %eax
8010128a:	e8 37 2f 00 00       	call   801041c6 <pipewrite>
8010128f:	83 c4 10             	add    $0x10,%esp
80101292:	e9 f4 00 00 00       	jmp    8010138b <filewrite+0x137>
  if(f->type == FD_INODE){
80101297:	8b 45 08             	mov    0x8(%ebp),%eax
8010129a:	8b 00                	mov    (%eax),%eax
8010129c:	83 f8 02             	cmp    $0x2,%eax
8010129f:	0f 85 d9 00 00 00    	jne    8010137e <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801012a5:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
801012ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801012b3:	e9 a3 00 00 00       	jmp    8010135b <filewrite+0x107>
      int n1 = n - i;
801012b8:	8b 45 10             	mov    0x10(%ebp),%eax
801012bb:	2b 45 f4             	sub    -0xc(%ebp),%eax
801012be:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
801012c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012c4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801012c7:	7e 06                	jle    801012cf <filewrite+0x7b>
        n1 = max;
801012c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801012cc:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
801012cf:	e8 3b 22 00 00       	call   8010350f <begin_op>
      ilock(f->ip);
801012d4:	8b 45 08             	mov    0x8(%ebp),%eax
801012d7:	8b 40 10             	mov    0x10(%eax),%eax
801012da:	83 ec 0c             	sub    $0xc,%esp
801012dd:	50                   	push   %eax
801012de:	e8 49 06 00 00       	call   8010192c <ilock>
801012e3:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801012e6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801012e9:	8b 45 08             	mov    0x8(%ebp),%eax
801012ec:	8b 50 14             	mov    0x14(%eax),%edx
801012ef:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801012f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801012f5:	01 c3                	add    %eax,%ebx
801012f7:	8b 45 08             	mov    0x8(%ebp),%eax
801012fa:	8b 40 10             	mov    0x10(%eax),%eax
801012fd:	51                   	push   %ecx
801012fe:	52                   	push   %edx
801012ff:	53                   	push   %ebx
80101300:	50                   	push   %eax
80101301:	e8 eb 0c 00 00       	call   80101ff1 <writei>
80101306:	83 c4 10             	add    $0x10,%esp
80101309:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010130c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101310:	7e 11                	jle    80101323 <filewrite+0xcf>
        f->off += r;
80101312:	8b 45 08             	mov    0x8(%ebp),%eax
80101315:	8b 50 14             	mov    0x14(%eax),%edx
80101318:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010131b:	01 c2                	add    %eax,%edx
8010131d:	8b 45 08             	mov    0x8(%ebp),%eax
80101320:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101323:	8b 45 08             	mov    0x8(%ebp),%eax
80101326:	8b 40 10             	mov    0x10(%eax),%eax
80101329:	83 ec 0c             	sub    $0xc,%esp
8010132c:	50                   	push   %eax
8010132d:	e8 58 07 00 00       	call   80101a8a <iunlock>
80101332:	83 c4 10             	add    $0x10,%esp
      end_op();
80101335:	e8 61 22 00 00       	call   8010359b <end_op>

      if(r < 0)
8010133a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010133e:	78 29                	js     80101369 <filewrite+0x115>
        break;
      if(r != n1)
80101340:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101343:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80101346:	74 0d                	je     80101355 <filewrite+0x101>
        panic("short filewrite");
80101348:	83 ec 0c             	sub    $0xc,%esp
8010134b:	68 94 86 10 80       	push   $0x80108694
80101350:	e8 11 f2 ff ff       	call   80100566 <panic>
      i += r;
80101355:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101358:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010135b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010135e:	3b 45 10             	cmp    0x10(%ebp),%eax
80101361:	0f 8c 51 ff ff ff    	jl     801012b8 <filewrite+0x64>
80101367:	eb 01                	jmp    8010136a <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
80101369:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010136a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010136d:	3b 45 10             	cmp    0x10(%ebp),%eax
80101370:	75 05                	jne    80101377 <filewrite+0x123>
80101372:	8b 45 10             	mov    0x10(%ebp),%eax
80101375:	eb 14                	jmp    8010138b <filewrite+0x137>
80101377:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010137c:	eb 0d                	jmp    8010138b <filewrite+0x137>
  }
  panic("filewrite");
8010137e:	83 ec 0c             	sub    $0xc,%esp
80101381:	68 a4 86 10 80       	push   $0x801086a4
80101386:	e8 db f1 ff ff       	call   80100566 <panic>
}
8010138b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010138e:	c9                   	leave  
8010138f:	c3                   	ret    

80101390 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101396:	8b 45 08             	mov    0x8(%ebp),%eax
80101399:	83 ec 08             	sub    $0x8,%esp
8010139c:	6a 01                	push   $0x1
8010139e:	50                   	push   %eax
8010139f:	e8 12 ee ff ff       	call   801001b6 <bread>
801013a4:	83 c4 10             	add    $0x10,%esp
801013a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801013aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013ad:	83 c0 18             	add    $0x18,%eax
801013b0:	83 ec 04             	sub    $0x4,%esp
801013b3:	6a 1c                	push   $0x1c
801013b5:	50                   	push   %eax
801013b6:	ff 75 0c             	pushl  0xc(%ebp)
801013b9:	e8 fa 3e 00 00       	call   801052b8 <memmove>
801013be:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801013c1:	83 ec 0c             	sub    $0xc,%esp
801013c4:	ff 75 f4             	pushl  -0xc(%ebp)
801013c7:	e8 62 ee ff ff       	call   8010022e <brelse>
801013cc:	83 c4 10             	add    $0x10,%esp
}
801013cf:	90                   	nop
801013d0:	c9                   	leave  
801013d1:	c3                   	ret    

801013d2 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
801013d2:	55                   	push   %ebp
801013d3:	89 e5                	mov    %esp,%ebp
801013d5:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
801013d8:	8b 55 0c             	mov    0xc(%ebp),%edx
801013db:	8b 45 08             	mov    0x8(%ebp),%eax
801013de:	83 ec 08             	sub    $0x8,%esp
801013e1:	52                   	push   %edx
801013e2:	50                   	push   %eax
801013e3:	e8 ce ed ff ff       	call   801001b6 <bread>
801013e8:	83 c4 10             	add    $0x10,%esp
801013eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801013ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013f1:	83 c0 18             	add    $0x18,%eax
801013f4:	83 ec 04             	sub    $0x4,%esp
801013f7:	68 00 02 00 00       	push   $0x200
801013fc:	6a 00                	push   $0x0
801013fe:	50                   	push   %eax
801013ff:	e8 f5 3d 00 00       	call   801051f9 <memset>
80101404:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101407:	83 ec 0c             	sub    $0xc,%esp
8010140a:	ff 75 f4             	pushl  -0xc(%ebp)
8010140d:	e8 35 23 00 00       	call   80103747 <log_write>
80101412:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101415:	83 ec 0c             	sub    $0xc,%esp
80101418:	ff 75 f4             	pushl  -0xc(%ebp)
8010141b:	e8 0e ee ff ff       	call   8010022e <brelse>
80101420:	83 c4 10             	add    $0x10,%esp
}
80101423:	90                   	nop
80101424:	c9                   	leave  
80101425:	c3                   	ret    

80101426 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101426:	55                   	push   %ebp
80101427:	89 e5                	mov    %esp,%ebp
80101429:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
8010142c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101433:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010143a:	e9 13 01 00 00       	jmp    80101552 <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
8010143f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101442:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101448:	85 c0                	test   %eax,%eax
8010144a:	0f 48 c2             	cmovs  %edx,%eax
8010144d:	c1 f8 0c             	sar    $0xc,%eax
80101450:	89 c2                	mov    %eax,%edx
80101452:	a1 38 12 11 80       	mov    0x80111238,%eax
80101457:	01 d0                	add    %edx,%eax
80101459:	83 ec 08             	sub    $0x8,%esp
8010145c:	50                   	push   %eax
8010145d:	ff 75 08             	pushl  0x8(%ebp)
80101460:	e8 51 ed ff ff       	call   801001b6 <bread>
80101465:	83 c4 10             	add    $0x10,%esp
80101468:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010146b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101472:	e9 a6 00 00 00       	jmp    8010151d <balloc+0xf7>
      m = 1 << (bi % 8);
80101477:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010147a:	99                   	cltd   
8010147b:	c1 ea 1d             	shr    $0x1d,%edx
8010147e:	01 d0                	add    %edx,%eax
80101480:	83 e0 07             	and    $0x7,%eax
80101483:	29 d0                	sub    %edx,%eax
80101485:	ba 01 00 00 00       	mov    $0x1,%edx
8010148a:	89 c1                	mov    %eax,%ecx
8010148c:	d3 e2                	shl    %cl,%edx
8010148e:	89 d0                	mov    %edx,%eax
80101490:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101493:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101496:	8d 50 07             	lea    0x7(%eax),%edx
80101499:	85 c0                	test   %eax,%eax
8010149b:	0f 48 c2             	cmovs  %edx,%eax
8010149e:	c1 f8 03             	sar    $0x3,%eax
801014a1:	89 c2                	mov    %eax,%edx
801014a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014a6:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801014ab:	0f b6 c0             	movzbl %al,%eax
801014ae:	23 45 e8             	and    -0x18(%ebp),%eax
801014b1:	85 c0                	test   %eax,%eax
801014b3:	75 64                	jne    80101519 <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
801014b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014b8:	8d 50 07             	lea    0x7(%eax),%edx
801014bb:	85 c0                	test   %eax,%eax
801014bd:	0f 48 c2             	cmovs  %edx,%eax
801014c0:	c1 f8 03             	sar    $0x3,%eax
801014c3:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014c6:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801014cb:	89 d1                	mov    %edx,%ecx
801014cd:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014d0:	09 ca                	or     %ecx,%edx
801014d2:	89 d1                	mov    %edx,%ecx
801014d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014d7:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
801014db:	83 ec 0c             	sub    $0xc,%esp
801014de:	ff 75 ec             	pushl  -0x14(%ebp)
801014e1:	e8 61 22 00 00       	call   80103747 <log_write>
801014e6:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
801014e9:	83 ec 0c             	sub    $0xc,%esp
801014ec:	ff 75 ec             	pushl  -0x14(%ebp)
801014ef:	e8 3a ed ff ff       	call   8010022e <brelse>
801014f4:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
801014f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014fd:	01 c2                	add    %eax,%edx
801014ff:	8b 45 08             	mov    0x8(%ebp),%eax
80101502:	83 ec 08             	sub    $0x8,%esp
80101505:	52                   	push   %edx
80101506:	50                   	push   %eax
80101507:	e8 c6 fe ff ff       	call   801013d2 <bzero>
8010150c:	83 c4 10             	add    $0x10,%esp
        return b + bi;
8010150f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101512:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101515:	01 d0                	add    %edx,%eax
80101517:	eb 57                	jmp    80101570 <balloc+0x14a>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101519:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010151d:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101524:	7f 17                	jg     8010153d <balloc+0x117>
80101526:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101529:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010152c:	01 d0                	add    %edx,%eax
8010152e:	89 c2                	mov    %eax,%edx
80101530:	a1 20 12 11 80       	mov    0x80111220,%eax
80101535:	39 c2                	cmp    %eax,%edx
80101537:	0f 82 3a ff ff ff    	jb     80101477 <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010153d:	83 ec 0c             	sub    $0xc,%esp
80101540:	ff 75 ec             	pushl  -0x14(%ebp)
80101543:	e8 e6 ec ff ff       	call   8010022e <brelse>
80101548:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010154b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101552:	8b 15 20 12 11 80    	mov    0x80111220,%edx
80101558:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010155b:	39 c2                	cmp    %eax,%edx
8010155d:	0f 87 dc fe ff ff    	ja     8010143f <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101563:	83 ec 0c             	sub    $0xc,%esp
80101566:	68 ae 86 10 80       	push   $0x801086ae
8010156b:	e8 f6 ef ff ff       	call   80100566 <panic>
}
80101570:	c9                   	leave  
80101571:	c3                   	ret    

80101572 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101572:	55                   	push   %ebp
80101573:	89 e5                	mov    %esp,%ebp
80101575:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101578:	83 ec 08             	sub    $0x8,%esp
8010157b:	68 20 12 11 80       	push   $0x80111220
80101580:	ff 75 08             	pushl  0x8(%ebp)
80101583:	e8 08 fe ff ff       	call   80101390 <readsb>
80101588:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
8010158b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010158e:	c1 e8 0c             	shr    $0xc,%eax
80101591:	89 c2                	mov    %eax,%edx
80101593:	a1 38 12 11 80       	mov    0x80111238,%eax
80101598:	01 c2                	add    %eax,%edx
8010159a:	8b 45 08             	mov    0x8(%ebp),%eax
8010159d:	83 ec 08             	sub    $0x8,%esp
801015a0:	52                   	push   %edx
801015a1:	50                   	push   %eax
801015a2:	e8 0f ec ff ff       	call   801001b6 <bread>
801015a7:	83 c4 10             	add    $0x10,%esp
801015aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801015ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801015b0:	25 ff 0f 00 00       	and    $0xfff,%eax
801015b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801015b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015bb:	99                   	cltd   
801015bc:	c1 ea 1d             	shr    $0x1d,%edx
801015bf:	01 d0                	add    %edx,%eax
801015c1:	83 e0 07             	and    $0x7,%eax
801015c4:	29 d0                	sub    %edx,%eax
801015c6:	ba 01 00 00 00       	mov    $0x1,%edx
801015cb:	89 c1                	mov    %eax,%ecx
801015cd:	d3 e2                	shl    %cl,%edx
801015cf:	89 d0                	mov    %edx,%eax
801015d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
801015d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015d7:	8d 50 07             	lea    0x7(%eax),%edx
801015da:	85 c0                	test   %eax,%eax
801015dc:	0f 48 c2             	cmovs  %edx,%eax
801015df:	c1 f8 03             	sar    $0x3,%eax
801015e2:	89 c2                	mov    %eax,%edx
801015e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015e7:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801015ec:	0f b6 c0             	movzbl %al,%eax
801015ef:	23 45 ec             	and    -0x14(%ebp),%eax
801015f2:	85 c0                	test   %eax,%eax
801015f4:	75 0d                	jne    80101603 <bfree+0x91>
    panic("freeing free block");
801015f6:	83 ec 0c             	sub    $0xc,%esp
801015f9:	68 c4 86 10 80       	push   $0x801086c4
801015fe:	e8 63 ef ff ff       	call   80100566 <panic>
  bp->data[bi/8] &= ~m;
80101603:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101606:	8d 50 07             	lea    0x7(%eax),%edx
80101609:	85 c0                	test   %eax,%eax
8010160b:	0f 48 c2             	cmovs  %edx,%eax
8010160e:	c1 f8 03             	sar    $0x3,%eax
80101611:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101614:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101619:	89 d1                	mov    %edx,%ecx
8010161b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010161e:	f7 d2                	not    %edx
80101620:	21 ca                	and    %ecx,%edx
80101622:	89 d1                	mov    %edx,%ecx
80101624:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101627:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
8010162b:	83 ec 0c             	sub    $0xc,%esp
8010162e:	ff 75 f4             	pushl  -0xc(%ebp)
80101631:	e8 11 21 00 00       	call   80103747 <log_write>
80101636:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101639:	83 ec 0c             	sub    $0xc,%esp
8010163c:	ff 75 f4             	pushl  -0xc(%ebp)
8010163f:	e8 ea eb ff ff       	call   8010022e <brelse>
80101644:	83 c4 10             	add    $0x10,%esp
}
80101647:	90                   	nop
80101648:	c9                   	leave  
80101649:	c3                   	ret    

8010164a <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
8010164a:	55                   	push   %ebp
8010164b:	89 e5                	mov    %esp,%ebp
8010164d:	83 ec 08             	sub    $0x8,%esp
  initlock(&icache.lock, "icache");
80101650:	83 ec 08             	sub    $0x8,%esp
80101653:	68 d7 86 10 80       	push   $0x801086d7
80101658:	68 40 12 11 80       	push   $0x80111240
8010165d:	e8 12 39 00 00       	call   80104f74 <initlock>
80101662:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80101665:	83 ec 08             	sub    $0x8,%esp
80101668:	68 20 12 11 80       	push   $0x80111220
8010166d:	ff 75 08             	pushl  0x8(%ebp)
80101670:	e8 1b fd ff ff       	call   80101390 <readsb>
80101675:	83 c4 10             	add    $0x10,%esp
}
80101678:	90                   	nop
80101679:	c9                   	leave  
8010167a:	c3                   	ret    

8010167b <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
8010167b:	55                   	push   %ebp
8010167c:	89 e5                	mov    %esp,%ebp
8010167e:	83 ec 28             	sub    $0x28,%esp
80101681:	8b 45 0c             	mov    0xc(%ebp),%eax
80101684:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101688:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010168f:	e9 9e 00 00 00       	jmp    80101732 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
80101694:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101697:	c1 e8 03             	shr    $0x3,%eax
8010169a:	89 c2                	mov    %eax,%edx
8010169c:	a1 34 12 11 80       	mov    0x80111234,%eax
801016a1:	01 d0                	add    %edx,%eax
801016a3:	83 ec 08             	sub    $0x8,%esp
801016a6:	50                   	push   %eax
801016a7:	ff 75 08             	pushl  0x8(%ebp)
801016aa:	e8 07 eb ff ff       	call   801001b6 <bread>
801016af:	83 c4 10             	add    $0x10,%esp
801016b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801016b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016b8:	8d 50 18             	lea    0x18(%eax),%edx
801016bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016be:	83 e0 07             	and    $0x7,%eax
801016c1:	c1 e0 06             	shl    $0x6,%eax
801016c4:	01 d0                	add    %edx,%eax
801016c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801016c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016cc:	0f b7 00             	movzwl (%eax),%eax
801016cf:	66 85 c0             	test   %ax,%ax
801016d2:	75 4c                	jne    80101720 <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
801016d4:	83 ec 04             	sub    $0x4,%esp
801016d7:	6a 40                	push   $0x40
801016d9:	6a 00                	push   $0x0
801016db:	ff 75 ec             	pushl  -0x14(%ebp)
801016de:	e8 16 3b 00 00       	call   801051f9 <memset>
801016e3:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801016e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016e9:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801016ed:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801016f0:	83 ec 0c             	sub    $0xc,%esp
801016f3:	ff 75 f0             	pushl  -0x10(%ebp)
801016f6:	e8 4c 20 00 00       	call   80103747 <log_write>
801016fb:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801016fe:	83 ec 0c             	sub    $0xc,%esp
80101701:	ff 75 f0             	pushl  -0x10(%ebp)
80101704:	e8 25 eb ff ff       	call   8010022e <brelse>
80101709:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
8010170c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010170f:	83 ec 08             	sub    $0x8,%esp
80101712:	50                   	push   %eax
80101713:	ff 75 08             	pushl  0x8(%ebp)
80101716:	e8 f8 00 00 00       	call   80101813 <iget>
8010171b:	83 c4 10             	add    $0x10,%esp
8010171e:	eb 30                	jmp    80101750 <ialloc+0xd5>
    }
    brelse(bp);
80101720:	83 ec 0c             	sub    $0xc,%esp
80101723:	ff 75 f0             	pushl  -0x10(%ebp)
80101726:	e8 03 eb ff ff       	call   8010022e <brelse>
8010172b:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010172e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101732:	8b 15 28 12 11 80    	mov    0x80111228,%edx
80101738:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010173b:	39 c2                	cmp    %eax,%edx
8010173d:	0f 87 51 ff ff ff    	ja     80101694 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101743:	83 ec 0c             	sub    $0xc,%esp
80101746:	68 de 86 10 80       	push   $0x801086de
8010174b:	e8 16 ee ff ff       	call   80100566 <panic>
}
80101750:	c9                   	leave  
80101751:	c3                   	ret    

80101752 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101752:	55                   	push   %ebp
80101753:	89 e5                	mov    %esp,%ebp
80101755:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101758:	8b 45 08             	mov    0x8(%ebp),%eax
8010175b:	8b 40 04             	mov    0x4(%eax),%eax
8010175e:	c1 e8 03             	shr    $0x3,%eax
80101761:	89 c2                	mov    %eax,%edx
80101763:	a1 34 12 11 80       	mov    0x80111234,%eax
80101768:	01 c2                	add    %eax,%edx
8010176a:	8b 45 08             	mov    0x8(%ebp),%eax
8010176d:	8b 00                	mov    (%eax),%eax
8010176f:	83 ec 08             	sub    $0x8,%esp
80101772:	52                   	push   %edx
80101773:	50                   	push   %eax
80101774:	e8 3d ea ff ff       	call   801001b6 <bread>
80101779:	83 c4 10             	add    $0x10,%esp
8010177c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010177f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101782:	8d 50 18             	lea    0x18(%eax),%edx
80101785:	8b 45 08             	mov    0x8(%ebp),%eax
80101788:	8b 40 04             	mov    0x4(%eax),%eax
8010178b:	83 e0 07             	and    $0x7,%eax
8010178e:	c1 e0 06             	shl    $0x6,%eax
80101791:	01 d0                	add    %edx,%eax
80101793:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101796:	8b 45 08             	mov    0x8(%ebp),%eax
80101799:	0f b7 50 10          	movzwl 0x10(%eax),%edx
8010179d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017a0:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801017a3:	8b 45 08             	mov    0x8(%ebp),%eax
801017a6:	0f b7 50 12          	movzwl 0x12(%eax),%edx
801017aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017ad:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801017b1:	8b 45 08             	mov    0x8(%ebp),%eax
801017b4:	0f b7 50 14          	movzwl 0x14(%eax),%edx
801017b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017bb:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801017bf:	8b 45 08             	mov    0x8(%ebp),%eax
801017c2:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801017c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017c9:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801017cd:	8b 45 08             	mov    0x8(%ebp),%eax
801017d0:	8b 50 18             	mov    0x18(%eax),%edx
801017d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017d6:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017d9:	8b 45 08             	mov    0x8(%ebp),%eax
801017dc:	8d 50 1c             	lea    0x1c(%eax),%edx
801017df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017e2:	83 c0 0c             	add    $0xc,%eax
801017e5:	83 ec 04             	sub    $0x4,%esp
801017e8:	6a 34                	push   $0x34
801017ea:	52                   	push   %edx
801017eb:	50                   	push   %eax
801017ec:	e8 c7 3a 00 00       	call   801052b8 <memmove>
801017f1:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801017f4:	83 ec 0c             	sub    $0xc,%esp
801017f7:	ff 75 f4             	pushl  -0xc(%ebp)
801017fa:	e8 48 1f 00 00       	call   80103747 <log_write>
801017ff:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101802:	83 ec 0c             	sub    $0xc,%esp
80101805:	ff 75 f4             	pushl  -0xc(%ebp)
80101808:	e8 21 ea ff ff       	call   8010022e <brelse>
8010180d:	83 c4 10             	add    $0x10,%esp
}
80101810:	90                   	nop
80101811:	c9                   	leave  
80101812:	c3                   	ret    

80101813 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101813:	55                   	push   %ebp
80101814:	89 e5                	mov    %esp,%ebp
80101816:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101819:	83 ec 0c             	sub    $0xc,%esp
8010181c:	68 40 12 11 80       	push   $0x80111240
80101821:	e8 70 37 00 00       	call   80104f96 <acquire>
80101826:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101829:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101830:	c7 45 f4 74 12 11 80 	movl   $0x80111274,-0xc(%ebp)
80101837:	eb 5d                	jmp    80101896 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101839:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010183c:	8b 40 08             	mov    0x8(%eax),%eax
8010183f:	85 c0                	test   %eax,%eax
80101841:	7e 39                	jle    8010187c <iget+0x69>
80101843:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101846:	8b 00                	mov    (%eax),%eax
80101848:	3b 45 08             	cmp    0x8(%ebp),%eax
8010184b:	75 2f                	jne    8010187c <iget+0x69>
8010184d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101850:	8b 40 04             	mov    0x4(%eax),%eax
80101853:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101856:	75 24                	jne    8010187c <iget+0x69>
      ip->ref++;
80101858:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010185b:	8b 40 08             	mov    0x8(%eax),%eax
8010185e:	8d 50 01             	lea    0x1(%eax),%edx
80101861:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101864:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101867:	83 ec 0c             	sub    $0xc,%esp
8010186a:	68 40 12 11 80       	push   $0x80111240
8010186f:	e8 89 37 00 00       	call   80104ffd <release>
80101874:	83 c4 10             	add    $0x10,%esp
      return ip;
80101877:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010187a:	eb 74                	jmp    801018f0 <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010187c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101880:	75 10                	jne    80101892 <iget+0x7f>
80101882:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101885:	8b 40 08             	mov    0x8(%eax),%eax
80101888:	85 c0                	test   %eax,%eax
8010188a:	75 06                	jne    80101892 <iget+0x7f>
      empty = ip;
8010188c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010188f:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101892:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101896:	81 7d f4 14 22 11 80 	cmpl   $0x80112214,-0xc(%ebp)
8010189d:	72 9a                	jb     80101839 <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
8010189f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801018a3:	75 0d                	jne    801018b2 <iget+0x9f>
    panic("iget: no inodes");
801018a5:	83 ec 0c             	sub    $0xc,%esp
801018a8:	68 f0 86 10 80       	push   $0x801086f0
801018ad:	e8 b4 ec ff ff       	call   80100566 <panic>

  ip = empty;
801018b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801018b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018bb:	8b 55 08             	mov    0x8(%ebp),%edx
801018be:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801018c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018c3:	8b 55 0c             	mov    0xc(%ebp),%edx
801018c6:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801018c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018cc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
801018d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018d6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
801018dd:	83 ec 0c             	sub    $0xc,%esp
801018e0:	68 40 12 11 80       	push   $0x80111240
801018e5:	e8 13 37 00 00       	call   80104ffd <release>
801018ea:	83 c4 10             	add    $0x10,%esp

  return ip;
801018ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801018f0:	c9                   	leave  
801018f1:	c3                   	ret    

801018f2 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801018f2:	55                   	push   %ebp
801018f3:	89 e5                	mov    %esp,%ebp
801018f5:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801018f8:	83 ec 0c             	sub    $0xc,%esp
801018fb:	68 40 12 11 80       	push   $0x80111240
80101900:	e8 91 36 00 00       	call   80104f96 <acquire>
80101905:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101908:	8b 45 08             	mov    0x8(%ebp),%eax
8010190b:	8b 40 08             	mov    0x8(%eax),%eax
8010190e:	8d 50 01             	lea    0x1(%eax),%edx
80101911:	8b 45 08             	mov    0x8(%ebp),%eax
80101914:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101917:	83 ec 0c             	sub    $0xc,%esp
8010191a:	68 40 12 11 80       	push   $0x80111240
8010191f:	e8 d9 36 00 00       	call   80104ffd <release>
80101924:	83 c4 10             	add    $0x10,%esp
  return ip;
80101927:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010192a:	c9                   	leave  
8010192b:	c3                   	ret    

8010192c <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
8010192c:	55                   	push   %ebp
8010192d:	89 e5                	mov    %esp,%ebp
8010192f:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101932:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101936:	74 0a                	je     80101942 <ilock+0x16>
80101938:	8b 45 08             	mov    0x8(%ebp),%eax
8010193b:	8b 40 08             	mov    0x8(%eax),%eax
8010193e:	85 c0                	test   %eax,%eax
80101940:	7f 0d                	jg     8010194f <ilock+0x23>
    panic("ilock");
80101942:	83 ec 0c             	sub    $0xc,%esp
80101945:	68 00 87 10 80       	push   $0x80108700
8010194a:	e8 17 ec ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
8010194f:	83 ec 0c             	sub    $0xc,%esp
80101952:	68 40 12 11 80       	push   $0x80111240
80101957:	e8 3a 36 00 00       	call   80104f96 <acquire>
8010195c:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
8010195f:	eb 13                	jmp    80101974 <ilock+0x48>
    sleep(ip, &icache.lock);
80101961:	83 ec 08             	sub    $0x8,%esp
80101964:	68 40 12 11 80       	push   $0x80111240
80101969:	ff 75 08             	pushl  0x8(%ebp)
8010196c:	e8 2c 33 00 00       	call   80104c9d <sleep>
80101971:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101974:	8b 45 08             	mov    0x8(%ebp),%eax
80101977:	8b 40 0c             	mov    0xc(%eax),%eax
8010197a:	83 e0 01             	and    $0x1,%eax
8010197d:	85 c0                	test   %eax,%eax
8010197f:	75 e0                	jne    80101961 <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101981:	8b 45 08             	mov    0x8(%ebp),%eax
80101984:	8b 40 0c             	mov    0xc(%eax),%eax
80101987:	83 c8 01             	or     $0x1,%eax
8010198a:	89 c2                	mov    %eax,%edx
8010198c:	8b 45 08             	mov    0x8(%ebp),%eax
8010198f:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101992:	83 ec 0c             	sub    $0xc,%esp
80101995:	68 40 12 11 80       	push   $0x80111240
8010199a:	e8 5e 36 00 00       	call   80104ffd <release>
8010199f:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
801019a2:	8b 45 08             	mov    0x8(%ebp),%eax
801019a5:	8b 40 0c             	mov    0xc(%eax),%eax
801019a8:	83 e0 02             	and    $0x2,%eax
801019ab:	85 c0                	test   %eax,%eax
801019ad:	0f 85 d4 00 00 00    	jne    80101a87 <ilock+0x15b>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019b3:	8b 45 08             	mov    0x8(%ebp),%eax
801019b6:	8b 40 04             	mov    0x4(%eax),%eax
801019b9:	c1 e8 03             	shr    $0x3,%eax
801019bc:	89 c2                	mov    %eax,%edx
801019be:	a1 34 12 11 80       	mov    0x80111234,%eax
801019c3:	01 c2                	add    %eax,%edx
801019c5:	8b 45 08             	mov    0x8(%ebp),%eax
801019c8:	8b 00                	mov    (%eax),%eax
801019ca:	83 ec 08             	sub    $0x8,%esp
801019cd:	52                   	push   %edx
801019ce:	50                   	push   %eax
801019cf:	e8 e2 e7 ff ff       	call   801001b6 <bread>
801019d4:	83 c4 10             	add    $0x10,%esp
801019d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801019da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019dd:	8d 50 18             	lea    0x18(%eax),%edx
801019e0:	8b 45 08             	mov    0x8(%ebp),%eax
801019e3:	8b 40 04             	mov    0x4(%eax),%eax
801019e6:	83 e0 07             	and    $0x7,%eax
801019e9:	c1 e0 06             	shl    $0x6,%eax
801019ec:	01 d0                	add    %edx,%eax
801019ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
801019f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019f4:	0f b7 10             	movzwl (%eax),%edx
801019f7:	8b 45 08             	mov    0x8(%ebp),%eax
801019fa:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
801019fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a01:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101a05:	8b 45 08             	mov    0x8(%ebp),%eax
80101a08:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101a0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a0f:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101a13:	8b 45 08             	mov    0x8(%ebp),%eax
80101a16:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a1d:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101a21:	8b 45 08             	mov    0x8(%ebp),%eax
80101a24:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a2b:	8b 50 08             	mov    0x8(%eax),%edx
80101a2e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a31:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a37:	8d 50 0c             	lea    0xc(%eax),%edx
80101a3a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3d:	83 c0 1c             	add    $0x1c,%eax
80101a40:	83 ec 04             	sub    $0x4,%esp
80101a43:	6a 34                	push   $0x34
80101a45:	52                   	push   %edx
80101a46:	50                   	push   %eax
80101a47:	e8 6c 38 00 00       	call   801052b8 <memmove>
80101a4c:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101a4f:	83 ec 0c             	sub    $0xc,%esp
80101a52:	ff 75 f4             	pushl  -0xc(%ebp)
80101a55:	e8 d4 e7 ff ff       	call   8010022e <brelse>
80101a5a:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101a5d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a60:	8b 40 0c             	mov    0xc(%eax),%eax
80101a63:	83 c8 02             	or     $0x2,%eax
80101a66:	89 c2                	mov    %eax,%edx
80101a68:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6b:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101a6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a71:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101a75:	66 85 c0             	test   %ax,%ax
80101a78:	75 0d                	jne    80101a87 <ilock+0x15b>
      panic("ilock: no type");
80101a7a:	83 ec 0c             	sub    $0xc,%esp
80101a7d:	68 06 87 10 80       	push   $0x80108706
80101a82:	e8 df ea ff ff       	call   80100566 <panic>
  }
}
80101a87:	90                   	nop
80101a88:	c9                   	leave  
80101a89:	c3                   	ret    

80101a8a <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a8a:	55                   	push   %ebp
80101a8b:	89 e5                	mov    %esp,%ebp
80101a8d:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101a90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a94:	74 17                	je     80101aad <iunlock+0x23>
80101a96:	8b 45 08             	mov    0x8(%ebp),%eax
80101a99:	8b 40 0c             	mov    0xc(%eax),%eax
80101a9c:	83 e0 01             	and    $0x1,%eax
80101a9f:	85 c0                	test   %eax,%eax
80101aa1:	74 0a                	je     80101aad <iunlock+0x23>
80101aa3:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa6:	8b 40 08             	mov    0x8(%eax),%eax
80101aa9:	85 c0                	test   %eax,%eax
80101aab:	7f 0d                	jg     80101aba <iunlock+0x30>
    panic("iunlock");
80101aad:	83 ec 0c             	sub    $0xc,%esp
80101ab0:	68 15 87 10 80       	push   $0x80108715
80101ab5:	e8 ac ea ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101aba:	83 ec 0c             	sub    $0xc,%esp
80101abd:	68 40 12 11 80       	push   $0x80111240
80101ac2:	e8 cf 34 00 00       	call   80104f96 <acquire>
80101ac7:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101aca:	8b 45 08             	mov    0x8(%ebp),%eax
80101acd:	8b 40 0c             	mov    0xc(%eax),%eax
80101ad0:	83 e0 fe             	and    $0xfffffffe,%eax
80101ad3:	89 c2                	mov    %eax,%edx
80101ad5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad8:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101adb:	83 ec 0c             	sub    $0xc,%esp
80101ade:	ff 75 08             	pushl  0x8(%ebp)
80101ae1:	e8 a2 32 00 00       	call   80104d88 <wakeup>
80101ae6:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101ae9:	83 ec 0c             	sub    $0xc,%esp
80101aec:	68 40 12 11 80       	push   $0x80111240
80101af1:	e8 07 35 00 00       	call   80104ffd <release>
80101af6:	83 c4 10             	add    $0x10,%esp
}
80101af9:	90                   	nop
80101afa:	c9                   	leave  
80101afb:	c3                   	ret    

80101afc <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101afc:	55                   	push   %ebp
80101afd:	89 e5                	mov    %esp,%ebp
80101aff:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101b02:	83 ec 0c             	sub    $0xc,%esp
80101b05:	68 40 12 11 80       	push   $0x80111240
80101b0a:	e8 87 34 00 00       	call   80104f96 <acquire>
80101b0f:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101b12:	8b 45 08             	mov    0x8(%ebp),%eax
80101b15:	8b 40 08             	mov    0x8(%eax),%eax
80101b18:	83 f8 01             	cmp    $0x1,%eax
80101b1b:	0f 85 a9 00 00 00    	jne    80101bca <iput+0xce>
80101b21:	8b 45 08             	mov    0x8(%ebp),%eax
80101b24:	8b 40 0c             	mov    0xc(%eax),%eax
80101b27:	83 e0 02             	and    $0x2,%eax
80101b2a:	85 c0                	test   %eax,%eax
80101b2c:	0f 84 98 00 00 00    	je     80101bca <iput+0xce>
80101b32:	8b 45 08             	mov    0x8(%ebp),%eax
80101b35:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101b39:	66 85 c0             	test   %ax,%ax
80101b3c:	0f 85 88 00 00 00    	jne    80101bca <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101b42:	8b 45 08             	mov    0x8(%ebp),%eax
80101b45:	8b 40 0c             	mov    0xc(%eax),%eax
80101b48:	83 e0 01             	and    $0x1,%eax
80101b4b:	85 c0                	test   %eax,%eax
80101b4d:	74 0d                	je     80101b5c <iput+0x60>
      panic("iput busy");
80101b4f:	83 ec 0c             	sub    $0xc,%esp
80101b52:	68 1d 87 10 80       	push   $0x8010871d
80101b57:	e8 0a ea ff ff       	call   80100566 <panic>
    ip->flags |= I_BUSY;
80101b5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5f:	8b 40 0c             	mov    0xc(%eax),%eax
80101b62:	83 c8 01             	or     $0x1,%eax
80101b65:	89 c2                	mov    %eax,%edx
80101b67:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6a:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101b6d:	83 ec 0c             	sub    $0xc,%esp
80101b70:	68 40 12 11 80       	push   $0x80111240
80101b75:	e8 83 34 00 00       	call   80104ffd <release>
80101b7a:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101b7d:	83 ec 0c             	sub    $0xc,%esp
80101b80:	ff 75 08             	pushl  0x8(%ebp)
80101b83:	e8 a8 01 00 00       	call   80101d30 <itrunc>
80101b88:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101b8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8e:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101b94:	83 ec 0c             	sub    $0xc,%esp
80101b97:	ff 75 08             	pushl  0x8(%ebp)
80101b9a:	e8 b3 fb ff ff       	call   80101752 <iupdate>
80101b9f:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101ba2:	83 ec 0c             	sub    $0xc,%esp
80101ba5:	68 40 12 11 80       	push   $0x80111240
80101baa:	e8 e7 33 00 00       	call   80104f96 <acquire>
80101baf:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101bb2:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101bbc:	83 ec 0c             	sub    $0xc,%esp
80101bbf:	ff 75 08             	pushl  0x8(%ebp)
80101bc2:	e8 c1 31 00 00       	call   80104d88 <wakeup>
80101bc7:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101bca:	8b 45 08             	mov    0x8(%ebp),%eax
80101bcd:	8b 40 08             	mov    0x8(%eax),%eax
80101bd0:	8d 50 ff             	lea    -0x1(%eax),%edx
80101bd3:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd6:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101bd9:	83 ec 0c             	sub    $0xc,%esp
80101bdc:	68 40 12 11 80       	push   $0x80111240
80101be1:	e8 17 34 00 00       	call   80104ffd <release>
80101be6:	83 c4 10             	add    $0x10,%esp
}
80101be9:	90                   	nop
80101bea:	c9                   	leave  
80101beb:	c3                   	ret    

80101bec <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101bec:	55                   	push   %ebp
80101bed:	89 e5                	mov    %esp,%ebp
80101bef:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101bf2:	83 ec 0c             	sub    $0xc,%esp
80101bf5:	ff 75 08             	pushl  0x8(%ebp)
80101bf8:	e8 8d fe ff ff       	call   80101a8a <iunlock>
80101bfd:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101c00:	83 ec 0c             	sub    $0xc,%esp
80101c03:	ff 75 08             	pushl  0x8(%ebp)
80101c06:	e8 f1 fe ff ff       	call   80101afc <iput>
80101c0b:	83 c4 10             	add    $0x10,%esp
}
80101c0e:	90                   	nop
80101c0f:	c9                   	leave  
80101c10:	c3                   	ret    

80101c11 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c11:	55                   	push   %ebp
80101c12:	89 e5                	mov    %esp,%ebp
80101c14:	53                   	push   %ebx
80101c15:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c18:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101c1c:	77 42                	ja     80101c60 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101c1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c21:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c24:	83 c2 04             	add    $0x4,%edx
80101c27:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c32:	75 24                	jne    80101c58 <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c34:	8b 45 08             	mov    0x8(%ebp),%eax
80101c37:	8b 00                	mov    (%eax),%eax
80101c39:	83 ec 0c             	sub    $0xc,%esp
80101c3c:	50                   	push   %eax
80101c3d:	e8 e4 f7 ff ff       	call   80101426 <balloc>
80101c42:	83 c4 10             	add    $0x10,%esp
80101c45:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c48:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4b:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c4e:	8d 4a 04             	lea    0x4(%edx),%ecx
80101c51:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c54:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c5b:	e9 cb 00 00 00       	jmp    80101d2b <bmap+0x11a>
  }
  bn -= NDIRECT;
80101c60:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101c64:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101c68:	0f 87 b0 00 00 00    	ja     80101d1e <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101c6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c71:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c74:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c7b:	75 1d                	jne    80101c9a <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101c7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c80:	8b 00                	mov    (%eax),%eax
80101c82:	83 ec 0c             	sub    $0xc,%esp
80101c85:	50                   	push   %eax
80101c86:	e8 9b f7 ff ff       	call   80101426 <balloc>
80101c8b:	83 c4 10             	add    $0x10,%esp
80101c8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c91:	8b 45 08             	mov    0x8(%ebp),%eax
80101c94:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c97:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101c9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c9d:	8b 00                	mov    (%eax),%eax
80101c9f:	83 ec 08             	sub    $0x8,%esp
80101ca2:	ff 75 f4             	pushl  -0xc(%ebp)
80101ca5:	50                   	push   %eax
80101ca6:	e8 0b e5 ff ff       	call   801001b6 <bread>
80101cab:	83 c4 10             	add    $0x10,%esp
80101cae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cb4:	83 c0 18             	add    $0x18,%eax
80101cb7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101cba:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cbd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cc7:	01 d0                	add    %edx,%eax
80101cc9:	8b 00                	mov    (%eax),%eax
80101ccb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cd2:	75 37                	jne    80101d0b <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cd7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cde:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ce1:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101ce4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce7:	8b 00                	mov    (%eax),%eax
80101ce9:	83 ec 0c             	sub    $0xc,%esp
80101cec:	50                   	push   %eax
80101ced:	e8 34 f7 ff ff       	call   80101426 <balloc>
80101cf2:	83 c4 10             	add    $0x10,%esp
80101cf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cfb:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101cfd:	83 ec 0c             	sub    $0xc,%esp
80101d00:	ff 75 f0             	pushl  -0x10(%ebp)
80101d03:	e8 3f 1a 00 00       	call   80103747 <log_write>
80101d08:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101d0b:	83 ec 0c             	sub    $0xc,%esp
80101d0e:	ff 75 f0             	pushl  -0x10(%ebp)
80101d11:	e8 18 e5 ff ff       	call   8010022e <brelse>
80101d16:	83 c4 10             	add    $0x10,%esp
    return addr;
80101d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d1c:	eb 0d                	jmp    80101d2b <bmap+0x11a>
  }

  panic("bmap: out of range");
80101d1e:	83 ec 0c             	sub    $0xc,%esp
80101d21:	68 27 87 10 80       	push   $0x80108727
80101d26:	e8 3b e8 ff ff       	call   80100566 <panic>
}
80101d2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d2e:	c9                   	leave  
80101d2f:	c3                   	ret    

80101d30 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d30:	55                   	push   %ebp
80101d31:	89 e5                	mov    %esp,%ebp
80101d33:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d36:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d3d:	eb 45                	jmp    80101d84 <itrunc+0x54>
    if(ip->addrs[i]){
80101d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d42:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d45:	83 c2 04             	add    $0x4,%edx
80101d48:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d4c:	85 c0                	test   %eax,%eax
80101d4e:	74 30                	je     80101d80 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101d50:	8b 45 08             	mov    0x8(%ebp),%eax
80101d53:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d56:	83 c2 04             	add    $0x4,%edx
80101d59:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d5d:	8b 55 08             	mov    0x8(%ebp),%edx
80101d60:	8b 12                	mov    (%edx),%edx
80101d62:	83 ec 08             	sub    $0x8,%esp
80101d65:	50                   	push   %eax
80101d66:	52                   	push   %edx
80101d67:	e8 06 f8 ff ff       	call   80101572 <bfree>
80101d6c:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d72:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d75:	83 c2 04             	add    $0x4,%edx
80101d78:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101d7f:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d80:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101d84:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101d88:	7e b5                	jle    80101d3f <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101d8a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8d:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d90:	85 c0                	test   %eax,%eax
80101d92:	0f 84 a1 00 00 00    	je     80101e39 <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101d98:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9b:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d9e:	8b 45 08             	mov    0x8(%ebp),%eax
80101da1:	8b 00                	mov    (%eax),%eax
80101da3:	83 ec 08             	sub    $0x8,%esp
80101da6:	52                   	push   %edx
80101da7:	50                   	push   %eax
80101da8:	e8 09 e4 ff ff       	call   801001b6 <bread>
80101dad:	83 c4 10             	add    $0x10,%esp
80101db0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101db3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101db6:	83 c0 18             	add    $0x18,%eax
80101db9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101dbc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101dc3:	eb 3c                	jmp    80101e01 <itrunc+0xd1>
      if(a[j])
80101dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dc8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101dcf:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101dd2:	01 d0                	add    %edx,%eax
80101dd4:	8b 00                	mov    (%eax),%eax
80101dd6:	85 c0                	test   %eax,%eax
80101dd8:	74 23                	je     80101dfd <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ddd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101de4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101de7:	01 d0                	add    %edx,%eax
80101de9:	8b 00                	mov    (%eax),%eax
80101deb:	8b 55 08             	mov    0x8(%ebp),%edx
80101dee:	8b 12                	mov    (%edx),%edx
80101df0:	83 ec 08             	sub    $0x8,%esp
80101df3:	50                   	push   %eax
80101df4:	52                   	push   %edx
80101df5:	e8 78 f7 ff ff       	call   80101572 <bfree>
80101dfa:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101dfd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101e01:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e04:	83 f8 7f             	cmp    $0x7f,%eax
80101e07:	76 bc                	jbe    80101dc5 <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101e09:	83 ec 0c             	sub    $0xc,%esp
80101e0c:	ff 75 ec             	pushl  -0x14(%ebp)
80101e0f:	e8 1a e4 ff ff       	call   8010022e <brelse>
80101e14:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e17:	8b 45 08             	mov    0x8(%ebp),%eax
80101e1a:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e1d:	8b 55 08             	mov    0x8(%ebp),%edx
80101e20:	8b 12                	mov    (%edx),%edx
80101e22:	83 ec 08             	sub    $0x8,%esp
80101e25:	50                   	push   %eax
80101e26:	52                   	push   %edx
80101e27:	e8 46 f7 ff ff       	call   80101572 <bfree>
80101e2c:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101e2f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e32:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101e39:	8b 45 08             	mov    0x8(%ebp),%eax
80101e3c:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101e43:	83 ec 0c             	sub    $0xc,%esp
80101e46:	ff 75 08             	pushl  0x8(%ebp)
80101e49:	e8 04 f9 ff ff       	call   80101752 <iupdate>
80101e4e:	83 c4 10             	add    $0x10,%esp
}
80101e51:	90                   	nop
80101e52:	c9                   	leave  
80101e53:	c3                   	ret    

80101e54 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101e54:	55                   	push   %ebp
80101e55:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101e57:	8b 45 08             	mov    0x8(%ebp),%eax
80101e5a:	8b 00                	mov    (%eax),%eax
80101e5c:	89 c2                	mov    %eax,%edx
80101e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e61:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101e64:	8b 45 08             	mov    0x8(%ebp),%eax
80101e67:	8b 50 04             	mov    0x4(%eax),%edx
80101e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e6d:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101e70:	8b 45 08             	mov    0x8(%ebp),%eax
80101e73:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101e77:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e7a:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101e7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e80:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101e84:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e87:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101e8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e8e:	8b 50 18             	mov    0x18(%eax),%edx
80101e91:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e94:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e97:	90                   	nop
80101e98:	5d                   	pop    %ebp
80101e99:	c3                   	ret    

80101e9a <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101e9a:	55                   	push   %ebp
80101e9b:	89 e5                	mov    %esp,%ebp
80101e9d:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ea0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101ea7:	66 83 f8 03          	cmp    $0x3,%ax
80101eab:	75 5c                	jne    80101f09 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ead:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb0:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101eb4:	66 85 c0             	test   %ax,%ax
80101eb7:	78 20                	js     80101ed9 <readi+0x3f>
80101eb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebc:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ec0:	66 83 f8 09          	cmp    $0x9,%ax
80101ec4:	7f 13                	jg     80101ed9 <readi+0x3f>
80101ec6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec9:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ecd:	98                   	cwtl   
80101ece:	8b 04 c5 c0 11 11 80 	mov    -0x7feeee40(,%eax,8),%eax
80101ed5:	85 c0                	test   %eax,%eax
80101ed7:	75 0a                	jne    80101ee3 <readi+0x49>
      return -1;
80101ed9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ede:	e9 0c 01 00 00       	jmp    80101fef <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80101ee3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee6:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101eea:	98                   	cwtl   
80101eeb:	8b 04 c5 c0 11 11 80 	mov    -0x7feeee40(,%eax,8),%eax
80101ef2:	8b 55 14             	mov    0x14(%ebp),%edx
80101ef5:	83 ec 04             	sub    $0x4,%esp
80101ef8:	52                   	push   %edx
80101ef9:	ff 75 0c             	pushl  0xc(%ebp)
80101efc:	ff 75 08             	pushl  0x8(%ebp)
80101eff:	ff d0                	call   *%eax
80101f01:	83 c4 10             	add    $0x10,%esp
80101f04:	e9 e6 00 00 00       	jmp    80101fef <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80101f09:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0c:	8b 40 18             	mov    0x18(%eax),%eax
80101f0f:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f12:	72 0d                	jb     80101f21 <readi+0x87>
80101f14:	8b 55 10             	mov    0x10(%ebp),%edx
80101f17:	8b 45 14             	mov    0x14(%ebp),%eax
80101f1a:	01 d0                	add    %edx,%eax
80101f1c:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f1f:	73 0a                	jae    80101f2b <readi+0x91>
    return -1;
80101f21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f26:	e9 c4 00 00 00       	jmp    80101fef <readi+0x155>
  if(off + n > ip->size)
80101f2b:	8b 55 10             	mov    0x10(%ebp),%edx
80101f2e:	8b 45 14             	mov    0x14(%ebp),%eax
80101f31:	01 c2                	add    %eax,%edx
80101f33:	8b 45 08             	mov    0x8(%ebp),%eax
80101f36:	8b 40 18             	mov    0x18(%eax),%eax
80101f39:	39 c2                	cmp    %eax,%edx
80101f3b:	76 0c                	jbe    80101f49 <readi+0xaf>
    n = ip->size - off;
80101f3d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f40:	8b 40 18             	mov    0x18(%eax),%eax
80101f43:	2b 45 10             	sub    0x10(%ebp),%eax
80101f46:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f50:	e9 8b 00 00 00       	jmp    80101fe0 <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f55:	8b 45 10             	mov    0x10(%ebp),%eax
80101f58:	c1 e8 09             	shr    $0x9,%eax
80101f5b:	83 ec 08             	sub    $0x8,%esp
80101f5e:	50                   	push   %eax
80101f5f:	ff 75 08             	pushl  0x8(%ebp)
80101f62:	e8 aa fc ff ff       	call   80101c11 <bmap>
80101f67:	83 c4 10             	add    $0x10,%esp
80101f6a:	89 c2                	mov    %eax,%edx
80101f6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f6f:	8b 00                	mov    (%eax),%eax
80101f71:	83 ec 08             	sub    $0x8,%esp
80101f74:	52                   	push   %edx
80101f75:	50                   	push   %eax
80101f76:	e8 3b e2 ff ff       	call   801001b6 <bread>
80101f7b:	83 c4 10             	add    $0x10,%esp
80101f7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101f81:	8b 45 10             	mov    0x10(%ebp),%eax
80101f84:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f89:	ba 00 02 00 00       	mov    $0x200,%edx
80101f8e:	29 c2                	sub    %eax,%edx
80101f90:	8b 45 14             	mov    0x14(%ebp),%eax
80101f93:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101f96:	39 c2                	cmp    %eax,%edx
80101f98:	0f 46 c2             	cmovbe %edx,%eax
80101f9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fa1:	8d 50 18             	lea    0x18(%eax),%edx
80101fa4:	8b 45 10             	mov    0x10(%ebp),%eax
80101fa7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fac:	01 d0                	add    %edx,%eax
80101fae:	83 ec 04             	sub    $0x4,%esp
80101fb1:	ff 75 ec             	pushl  -0x14(%ebp)
80101fb4:	50                   	push   %eax
80101fb5:	ff 75 0c             	pushl  0xc(%ebp)
80101fb8:	e8 fb 32 00 00       	call   801052b8 <memmove>
80101fbd:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101fc0:	83 ec 0c             	sub    $0xc,%esp
80101fc3:	ff 75 f0             	pushl  -0x10(%ebp)
80101fc6:	e8 63 e2 ff ff       	call   8010022e <brelse>
80101fcb:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fce:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fd1:	01 45 f4             	add    %eax,-0xc(%ebp)
80101fd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fd7:	01 45 10             	add    %eax,0x10(%ebp)
80101fda:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fdd:	01 45 0c             	add    %eax,0xc(%ebp)
80101fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fe3:	3b 45 14             	cmp    0x14(%ebp),%eax
80101fe6:	0f 82 69 ff ff ff    	jb     80101f55 <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101fec:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101fef:	c9                   	leave  
80101ff0:	c3                   	ret    

80101ff1 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ff1:	55                   	push   %ebp
80101ff2:	89 e5                	mov    %esp,%ebp
80101ff4:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ff7:	8b 45 08             	mov    0x8(%ebp),%eax
80101ffa:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101ffe:	66 83 f8 03          	cmp    $0x3,%ax
80102002:	75 5c                	jne    80102060 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102004:	8b 45 08             	mov    0x8(%ebp),%eax
80102007:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010200b:	66 85 c0             	test   %ax,%ax
8010200e:	78 20                	js     80102030 <writei+0x3f>
80102010:	8b 45 08             	mov    0x8(%ebp),%eax
80102013:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102017:	66 83 f8 09          	cmp    $0x9,%ax
8010201b:	7f 13                	jg     80102030 <writei+0x3f>
8010201d:	8b 45 08             	mov    0x8(%ebp),%eax
80102020:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102024:	98                   	cwtl   
80102025:	8b 04 c5 c4 11 11 80 	mov    -0x7feeee3c(,%eax,8),%eax
8010202c:	85 c0                	test   %eax,%eax
8010202e:	75 0a                	jne    8010203a <writei+0x49>
      return -1;
80102030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102035:	e9 3d 01 00 00       	jmp    80102177 <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
8010203a:	8b 45 08             	mov    0x8(%ebp),%eax
8010203d:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102041:	98                   	cwtl   
80102042:	8b 04 c5 c4 11 11 80 	mov    -0x7feeee3c(,%eax,8),%eax
80102049:	8b 55 14             	mov    0x14(%ebp),%edx
8010204c:	83 ec 04             	sub    $0x4,%esp
8010204f:	52                   	push   %edx
80102050:	ff 75 0c             	pushl  0xc(%ebp)
80102053:	ff 75 08             	pushl  0x8(%ebp)
80102056:	ff d0                	call   *%eax
80102058:	83 c4 10             	add    $0x10,%esp
8010205b:	e9 17 01 00 00       	jmp    80102177 <writei+0x186>
  }

  if(off > ip->size || off + n < off)
80102060:	8b 45 08             	mov    0x8(%ebp),%eax
80102063:	8b 40 18             	mov    0x18(%eax),%eax
80102066:	3b 45 10             	cmp    0x10(%ebp),%eax
80102069:	72 0d                	jb     80102078 <writei+0x87>
8010206b:	8b 55 10             	mov    0x10(%ebp),%edx
8010206e:	8b 45 14             	mov    0x14(%ebp),%eax
80102071:	01 d0                	add    %edx,%eax
80102073:	3b 45 10             	cmp    0x10(%ebp),%eax
80102076:	73 0a                	jae    80102082 <writei+0x91>
    return -1;
80102078:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010207d:	e9 f5 00 00 00       	jmp    80102177 <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
80102082:	8b 55 10             	mov    0x10(%ebp),%edx
80102085:	8b 45 14             	mov    0x14(%ebp),%eax
80102088:	01 d0                	add    %edx,%eax
8010208a:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010208f:	76 0a                	jbe    8010209b <writei+0xaa>
    return -1;
80102091:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102096:	e9 dc 00 00 00       	jmp    80102177 <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010209b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020a2:	e9 99 00 00 00       	jmp    80102140 <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020a7:	8b 45 10             	mov    0x10(%ebp),%eax
801020aa:	c1 e8 09             	shr    $0x9,%eax
801020ad:	83 ec 08             	sub    $0x8,%esp
801020b0:	50                   	push   %eax
801020b1:	ff 75 08             	pushl  0x8(%ebp)
801020b4:	e8 58 fb ff ff       	call   80101c11 <bmap>
801020b9:	83 c4 10             	add    $0x10,%esp
801020bc:	89 c2                	mov    %eax,%edx
801020be:	8b 45 08             	mov    0x8(%ebp),%eax
801020c1:	8b 00                	mov    (%eax),%eax
801020c3:	83 ec 08             	sub    $0x8,%esp
801020c6:	52                   	push   %edx
801020c7:	50                   	push   %eax
801020c8:	e8 e9 e0 ff ff       	call   801001b6 <bread>
801020cd:	83 c4 10             	add    $0x10,%esp
801020d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801020d3:	8b 45 10             	mov    0x10(%ebp),%eax
801020d6:	25 ff 01 00 00       	and    $0x1ff,%eax
801020db:	ba 00 02 00 00       	mov    $0x200,%edx
801020e0:	29 c2                	sub    %eax,%edx
801020e2:	8b 45 14             	mov    0x14(%ebp),%eax
801020e5:	2b 45 f4             	sub    -0xc(%ebp),%eax
801020e8:	39 c2                	cmp    %eax,%edx
801020ea:	0f 46 c2             	cmovbe %edx,%eax
801020ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801020f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020f3:	8d 50 18             	lea    0x18(%eax),%edx
801020f6:	8b 45 10             	mov    0x10(%ebp),%eax
801020f9:	25 ff 01 00 00       	and    $0x1ff,%eax
801020fe:	01 d0                	add    %edx,%eax
80102100:	83 ec 04             	sub    $0x4,%esp
80102103:	ff 75 ec             	pushl  -0x14(%ebp)
80102106:	ff 75 0c             	pushl  0xc(%ebp)
80102109:	50                   	push   %eax
8010210a:	e8 a9 31 00 00       	call   801052b8 <memmove>
8010210f:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
80102112:	83 ec 0c             	sub    $0xc,%esp
80102115:	ff 75 f0             	pushl  -0x10(%ebp)
80102118:	e8 2a 16 00 00       	call   80103747 <log_write>
8010211d:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102120:	83 ec 0c             	sub    $0xc,%esp
80102123:	ff 75 f0             	pushl  -0x10(%ebp)
80102126:	e8 03 e1 ff ff       	call   8010022e <brelse>
8010212b:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010212e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102131:	01 45 f4             	add    %eax,-0xc(%ebp)
80102134:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102137:	01 45 10             	add    %eax,0x10(%ebp)
8010213a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010213d:	01 45 0c             	add    %eax,0xc(%ebp)
80102140:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102143:	3b 45 14             	cmp    0x14(%ebp),%eax
80102146:	0f 82 5b ff ff ff    	jb     801020a7 <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
8010214c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102150:	74 22                	je     80102174 <writei+0x183>
80102152:	8b 45 08             	mov    0x8(%ebp),%eax
80102155:	8b 40 18             	mov    0x18(%eax),%eax
80102158:	3b 45 10             	cmp    0x10(%ebp),%eax
8010215b:	73 17                	jae    80102174 <writei+0x183>
    ip->size = off;
8010215d:	8b 45 08             	mov    0x8(%ebp),%eax
80102160:	8b 55 10             	mov    0x10(%ebp),%edx
80102163:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
80102166:	83 ec 0c             	sub    $0xc,%esp
80102169:	ff 75 08             	pushl  0x8(%ebp)
8010216c:	e8 e1 f5 ff ff       	call   80101752 <iupdate>
80102171:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80102174:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102177:	c9                   	leave  
80102178:	c3                   	ret    

80102179 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102179:	55                   	push   %ebp
8010217a:	89 e5                	mov    %esp,%ebp
8010217c:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
8010217f:	83 ec 04             	sub    $0x4,%esp
80102182:	6a 0e                	push   $0xe
80102184:	ff 75 0c             	pushl  0xc(%ebp)
80102187:	ff 75 08             	pushl  0x8(%ebp)
8010218a:	e8 bf 31 00 00       	call   8010534e <strncmp>
8010218f:	83 c4 10             	add    $0x10,%esp
}
80102192:	c9                   	leave  
80102193:	c3                   	ret    

80102194 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102194:	55                   	push   %ebp
80102195:	89 e5                	mov    %esp,%ebp
80102197:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010219a:	8b 45 08             	mov    0x8(%ebp),%eax
8010219d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801021a1:	66 83 f8 01          	cmp    $0x1,%ax
801021a5:	74 0d                	je     801021b4 <dirlookup+0x20>
    panic("dirlookup not DIR");
801021a7:	83 ec 0c             	sub    $0xc,%esp
801021aa:	68 3a 87 10 80       	push   $0x8010873a
801021af:	e8 b2 e3 ff ff       	call   80100566 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801021b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021bb:	eb 7b                	jmp    80102238 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021bd:	6a 10                	push   $0x10
801021bf:	ff 75 f4             	pushl  -0xc(%ebp)
801021c2:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021c5:	50                   	push   %eax
801021c6:	ff 75 08             	pushl  0x8(%ebp)
801021c9:	e8 cc fc ff ff       	call   80101e9a <readi>
801021ce:	83 c4 10             	add    $0x10,%esp
801021d1:	83 f8 10             	cmp    $0x10,%eax
801021d4:	74 0d                	je     801021e3 <dirlookup+0x4f>
      panic("dirlink read");
801021d6:	83 ec 0c             	sub    $0xc,%esp
801021d9:	68 4c 87 10 80       	push   $0x8010874c
801021de:	e8 83 e3 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
801021e3:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021e7:	66 85 c0             	test   %ax,%ax
801021ea:	74 47                	je     80102233 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
801021ec:	83 ec 08             	sub    $0x8,%esp
801021ef:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021f2:	83 c0 02             	add    $0x2,%eax
801021f5:	50                   	push   %eax
801021f6:	ff 75 0c             	pushl  0xc(%ebp)
801021f9:	e8 7b ff ff ff       	call   80102179 <namecmp>
801021fe:	83 c4 10             	add    $0x10,%esp
80102201:	85 c0                	test   %eax,%eax
80102203:	75 2f                	jne    80102234 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
80102205:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102209:	74 08                	je     80102213 <dirlookup+0x7f>
        *poff = off;
8010220b:	8b 45 10             	mov    0x10(%ebp),%eax
8010220e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102211:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102213:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102217:	0f b7 c0             	movzwl %ax,%eax
8010221a:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
8010221d:	8b 45 08             	mov    0x8(%ebp),%eax
80102220:	8b 00                	mov    (%eax),%eax
80102222:	83 ec 08             	sub    $0x8,%esp
80102225:	ff 75 f0             	pushl  -0x10(%ebp)
80102228:	50                   	push   %eax
80102229:	e8 e5 f5 ff ff       	call   80101813 <iget>
8010222e:	83 c4 10             	add    $0x10,%esp
80102231:	eb 19                	jmp    8010224c <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
80102233:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102234:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102238:	8b 45 08             	mov    0x8(%ebp),%eax
8010223b:	8b 40 18             	mov    0x18(%eax),%eax
8010223e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102241:	0f 87 76 ff ff ff    	ja     801021bd <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102247:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010224c:	c9                   	leave  
8010224d:	c3                   	ret    

8010224e <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
8010224e:	55                   	push   %ebp
8010224f:	89 e5                	mov    %esp,%ebp
80102251:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102254:	83 ec 04             	sub    $0x4,%esp
80102257:	6a 00                	push   $0x0
80102259:	ff 75 0c             	pushl  0xc(%ebp)
8010225c:	ff 75 08             	pushl  0x8(%ebp)
8010225f:	e8 30 ff ff ff       	call   80102194 <dirlookup>
80102264:	83 c4 10             	add    $0x10,%esp
80102267:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010226a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010226e:	74 18                	je     80102288 <dirlink+0x3a>
    iput(ip);
80102270:	83 ec 0c             	sub    $0xc,%esp
80102273:	ff 75 f0             	pushl  -0x10(%ebp)
80102276:	e8 81 f8 ff ff       	call   80101afc <iput>
8010227b:	83 c4 10             	add    $0x10,%esp
    return -1;
8010227e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102283:	e9 9c 00 00 00       	jmp    80102324 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102288:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010228f:	eb 39                	jmp    801022ca <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102291:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102294:	6a 10                	push   $0x10
80102296:	50                   	push   %eax
80102297:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010229a:	50                   	push   %eax
8010229b:	ff 75 08             	pushl  0x8(%ebp)
8010229e:	e8 f7 fb ff ff       	call   80101e9a <readi>
801022a3:	83 c4 10             	add    $0x10,%esp
801022a6:	83 f8 10             	cmp    $0x10,%eax
801022a9:	74 0d                	je     801022b8 <dirlink+0x6a>
      panic("dirlink read");
801022ab:	83 ec 0c             	sub    $0xc,%esp
801022ae:	68 4c 87 10 80       	push   $0x8010874c
801022b3:	e8 ae e2 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
801022b8:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022bc:	66 85 c0             	test   %ax,%ax
801022bf:	74 18                	je     801022d9 <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801022c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022c4:	83 c0 10             	add    $0x10,%eax
801022c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801022ca:	8b 45 08             	mov    0x8(%ebp),%eax
801022cd:	8b 50 18             	mov    0x18(%eax),%edx
801022d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022d3:	39 c2                	cmp    %eax,%edx
801022d5:	77 ba                	ja     80102291 <dirlink+0x43>
801022d7:	eb 01                	jmp    801022da <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
801022d9:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801022da:	83 ec 04             	sub    $0x4,%esp
801022dd:	6a 0e                	push   $0xe
801022df:	ff 75 0c             	pushl  0xc(%ebp)
801022e2:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022e5:	83 c0 02             	add    $0x2,%eax
801022e8:	50                   	push   %eax
801022e9:	e8 b6 30 00 00       	call   801053a4 <strncpy>
801022ee:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801022f1:	8b 45 10             	mov    0x10(%ebp),%eax
801022f4:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022fb:	6a 10                	push   $0x10
801022fd:	50                   	push   %eax
801022fe:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102301:	50                   	push   %eax
80102302:	ff 75 08             	pushl  0x8(%ebp)
80102305:	e8 e7 fc ff ff       	call   80101ff1 <writei>
8010230a:	83 c4 10             	add    $0x10,%esp
8010230d:	83 f8 10             	cmp    $0x10,%eax
80102310:	74 0d                	je     8010231f <dirlink+0xd1>
    panic("dirlink");
80102312:	83 ec 0c             	sub    $0xc,%esp
80102315:	68 59 87 10 80       	push   $0x80108759
8010231a:	e8 47 e2 ff ff       	call   80100566 <panic>
  
  return 0;
8010231f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102324:	c9                   	leave  
80102325:	c3                   	ret    

80102326 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102326:	55                   	push   %ebp
80102327:	89 e5                	mov    %esp,%ebp
80102329:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
8010232c:	eb 04                	jmp    80102332 <skipelem+0xc>
    path++;
8010232e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102332:	8b 45 08             	mov    0x8(%ebp),%eax
80102335:	0f b6 00             	movzbl (%eax),%eax
80102338:	3c 2f                	cmp    $0x2f,%al
8010233a:	74 f2                	je     8010232e <skipelem+0x8>
    path++;
  if(*path == 0)
8010233c:	8b 45 08             	mov    0x8(%ebp),%eax
8010233f:	0f b6 00             	movzbl (%eax),%eax
80102342:	84 c0                	test   %al,%al
80102344:	75 07                	jne    8010234d <skipelem+0x27>
    return 0;
80102346:	b8 00 00 00 00       	mov    $0x0,%eax
8010234b:	eb 7b                	jmp    801023c8 <skipelem+0xa2>
  s = path;
8010234d:	8b 45 08             	mov    0x8(%ebp),%eax
80102350:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102353:	eb 04                	jmp    80102359 <skipelem+0x33>
    path++;
80102355:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102359:	8b 45 08             	mov    0x8(%ebp),%eax
8010235c:	0f b6 00             	movzbl (%eax),%eax
8010235f:	3c 2f                	cmp    $0x2f,%al
80102361:	74 0a                	je     8010236d <skipelem+0x47>
80102363:	8b 45 08             	mov    0x8(%ebp),%eax
80102366:	0f b6 00             	movzbl (%eax),%eax
80102369:	84 c0                	test   %al,%al
8010236b:	75 e8                	jne    80102355 <skipelem+0x2f>
    path++;
  len = path - s;
8010236d:	8b 55 08             	mov    0x8(%ebp),%edx
80102370:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102373:	29 c2                	sub    %eax,%edx
80102375:	89 d0                	mov    %edx,%eax
80102377:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
8010237a:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010237e:	7e 15                	jle    80102395 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
80102380:	83 ec 04             	sub    $0x4,%esp
80102383:	6a 0e                	push   $0xe
80102385:	ff 75 f4             	pushl  -0xc(%ebp)
80102388:	ff 75 0c             	pushl  0xc(%ebp)
8010238b:	e8 28 2f 00 00       	call   801052b8 <memmove>
80102390:	83 c4 10             	add    $0x10,%esp
80102393:	eb 26                	jmp    801023bb <skipelem+0x95>
  else {
    memmove(name, s, len);
80102395:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102398:	83 ec 04             	sub    $0x4,%esp
8010239b:	50                   	push   %eax
8010239c:	ff 75 f4             	pushl  -0xc(%ebp)
8010239f:	ff 75 0c             	pushl  0xc(%ebp)
801023a2:	e8 11 2f 00 00       	call   801052b8 <memmove>
801023a7:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
801023aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
801023ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801023b0:	01 d0                	add    %edx,%eax
801023b2:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801023b5:	eb 04                	jmp    801023bb <skipelem+0x95>
    path++;
801023b7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801023bb:	8b 45 08             	mov    0x8(%ebp),%eax
801023be:	0f b6 00             	movzbl (%eax),%eax
801023c1:	3c 2f                	cmp    $0x2f,%al
801023c3:	74 f2                	je     801023b7 <skipelem+0x91>
    path++;
  return path;
801023c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
801023c8:	c9                   	leave  
801023c9:	c3                   	ret    

801023ca <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801023ca:	55                   	push   %ebp
801023cb:	89 e5                	mov    %esp,%ebp
801023cd:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
801023d0:	8b 45 08             	mov    0x8(%ebp),%eax
801023d3:	0f b6 00             	movzbl (%eax),%eax
801023d6:	3c 2f                	cmp    $0x2f,%al
801023d8:	75 17                	jne    801023f1 <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
801023da:	83 ec 08             	sub    $0x8,%esp
801023dd:	6a 01                	push   $0x1
801023df:	6a 01                	push   $0x1
801023e1:	e8 2d f4 ff ff       	call   80101813 <iget>
801023e6:	83 c4 10             	add    $0x10,%esp
801023e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801023ec:	e9 bb 00 00 00       	jmp    801024ac <namex+0xe2>
  else
    ip = idup(proc->cwd);
801023f1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801023f7:	8b 40 6c             	mov    0x6c(%eax),%eax
801023fa:	83 ec 0c             	sub    $0xc,%esp
801023fd:	50                   	push   %eax
801023fe:	e8 ef f4 ff ff       	call   801018f2 <idup>
80102403:	83 c4 10             	add    $0x10,%esp
80102406:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102409:	e9 9e 00 00 00       	jmp    801024ac <namex+0xe2>
    ilock(ip);
8010240e:	83 ec 0c             	sub    $0xc,%esp
80102411:	ff 75 f4             	pushl  -0xc(%ebp)
80102414:	e8 13 f5 ff ff       	call   8010192c <ilock>
80102419:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
8010241c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010241f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102423:	66 83 f8 01          	cmp    $0x1,%ax
80102427:	74 18                	je     80102441 <namex+0x77>
      iunlockput(ip);
80102429:	83 ec 0c             	sub    $0xc,%esp
8010242c:	ff 75 f4             	pushl  -0xc(%ebp)
8010242f:	e8 b8 f7 ff ff       	call   80101bec <iunlockput>
80102434:	83 c4 10             	add    $0x10,%esp
      return 0;
80102437:	b8 00 00 00 00       	mov    $0x0,%eax
8010243c:	e9 a7 00 00 00       	jmp    801024e8 <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
80102441:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102445:	74 20                	je     80102467 <namex+0x9d>
80102447:	8b 45 08             	mov    0x8(%ebp),%eax
8010244a:	0f b6 00             	movzbl (%eax),%eax
8010244d:	84 c0                	test   %al,%al
8010244f:	75 16                	jne    80102467 <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
80102451:	83 ec 0c             	sub    $0xc,%esp
80102454:	ff 75 f4             	pushl  -0xc(%ebp)
80102457:	e8 2e f6 ff ff       	call   80101a8a <iunlock>
8010245c:	83 c4 10             	add    $0x10,%esp
      return ip;
8010245f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102462:	e9 81 00 00 00       	jmp    801024e8 <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102467:	83 ec 04             	sub    $0x4,%esp
8010246a:	6a 00                	push   $0x0
8010246c:	ff 75 10             	pushl  0x10(%ebp)
8010246f:	ff 75 f4             	pushl  -0xc(%ebp)
80102472:	e8 1d fd ff ff       	call   80102194 <dirlookup>
80102477:	83 c4 10             	add    $0x10,%esp
8010247a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010247d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102481:	75 15                	jne    80102498 <namex+0xce>
      iunlockput(ip);
80102483:	83 ec 0c             	sub    $0xc,%esp
80102486:	ff 75 f4             	pushl  -0xc(%ebp)
80102489:	e8 5e f7 ff ff       	call   80101bec <iunlockput>
8010248e:	83 c4 10             	add    $0x10,%esp
      return 0;
80102491:	b8 00 00 00 00       	mov    $0x0,%eax
80102496:	eb 50                	jmp    801024e8 <namex+0x11e>
    }
    iunlockput(ip);
80102498:	83 ec 0c             	sub    $0xc,%esp
8010249b:	ff 75 f4             	pushl  -0xc(%ebp)
8010249e:	e8 49 f7 ff ff       	call   80101bec <iunlockput>
801024a3:	83 c4 10             	add    $0x10,%esp
    ip = next;
801024a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801024a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801024ac:	83 ec 08             	sub    $0x8,%esp
801024af:	ff 75 10             	pushl  0x10(%ebp)
801024b2:	ff 75 08             	pushl  0x8(%ebp)
801024b5:	e8 6c fe ff ff       	call   80102326 <skipelem>
801024ba:	83 c4 10             	add    $0x10,%esp
801024bd:	89 45 08             	mov    %eax,0x8(%ebp)
801024c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801024c4:	0f 85 44 ff ff ff    	jne    8010240e <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801024ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024ce:	74 15                	je     801024e5 <namex+0x11b>
    iput(ip);
801024d0:	83 ec 0c             	sub    $0xc,%esp
801024d3:	ff 75 f4             	pushl  -0xc(%ebp)
801024d6:	e8 21 f6 ff ff       	call   80101afc <iput>
801024db:	83 c4 10             	add    $0x10,%esp
    return 0;
801024de:	b8 00 00 00 00       	mov    $0x0,%eax
801024e3:	eb 03                	jmp    801024e8 <namex+0x11e>
  }
  return ip;
801024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801024e8:	c9                   	leave  
801024e9:	c3                   	ret    

801024ea <namei>:

struct inode*
namei(char *path)
{
801024ea:	55                   	push   %ebp
801024eb:	89 e5                	mov    %esp,%ebp
801024ed:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801024f0:	83 ec 04             	sub    $0x4,%esp
801024f3:	8d 45 ea             	lea    -0x16(%ebp),%eax
801024f6:	50                   	push   %eax
801024f7:	6a 00                	push   $0x0
801024f9:	ff 75 08             	pushl  0x8(%ebp)
801024fc:	e8 c9 fe ff ff       	call   801023ca <namex>
80102501:	83 c4 10             	add    $0x10,%esp
}
80102504:	c9                   	leave  
80102505:	c3                   	ret    

80102506 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102506:	55                   	push   %ebp
80102507:	89 e5                	mov    %esp,%ebp
80102509:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
8010250c:	83 ec 04             	sub    $0x4,%esp
8010250f:	ff 75 0c             	pushl  0xc(%ebp)
80102512:	6a 01                	push   $0x1
80102514:	ff 75 08             	pushl  0x8(%ebp)
80102517:	e8 ae fe ff ff       	call   801023ca <namex>
8010251c:	83 c4 10             	add    $0x10,%esp
}
8010251f:	c9                   	leave  
80102520:	c3                   	ret    

80102521 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102521:	55                   	push   %ebp
80102522:	89 e5                	mov    %esp,%ebp
80102524:	83 ec 14             	sub    $0x14,%esp
80102527:	8b 45 08             	mov    0x8(%ebp),%eax
8010252a:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010252e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102532:	89 c2                	mov    %eax,%edx
80102534:	ec                   	in     (%dx),%al
80102535:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102538:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010253c:	c9                   	leave  
8010253d:	c3                   	ret    

8010253e <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
8010253e:	55                   	push   %ebp
8010253f:	89 e5                	mov    %esp,%ebp
80102541:	57                   	push   %edi
80102542:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102543:	8b 55 08             	mov    0x8(%ebp),%edx
80102546:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102549:	8b 45 10             	mov    0x10(%ebp),%eax
8010254c:	89 cb                	mov    %ecx,%ebx
8010254e:	89 df                	mov    %ebx,%edi
80102550:	89 c1                	mov    %eax,%ecx
80102552:	fc                   	cld    
80102553:	f3 6d                	rep insl (%dx),%es:(%edi)
80102555:	89 c8                	mov    %ecx,%eax
80102557:	89 fb                	mov    %edi,%ebx
80102559:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010255c:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
8010255f:	90                   	nop
80102560:	5b                   	pop    %ebx
80102561:	5f                   	pop    %edi
80102562:	5d                   	pop    %ebp
80102563:	c3                   	ret    

80102564 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102564:	55                   	push   %ebp
80102565:	89 e5                	mov    %esp,%ebp
80102567:	83 ec 08             	sub    $0x8,%esp
8010256a:	8b 55 08             	mov    0x8(%ebp),%edx
8010256d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102570:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102574:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102577:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010257b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010257f:	ee                   	out    %al,(%dx)
}
80102580:	90                   	nop
80102581:	c9                   	leave  
80102582:	c3                   	ret    

80102583 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102583:	55                   	push   %ebp
80102584:	89 e5                	mov    %esp,%ebp
80102586:	56                   	push   %esi
80102587:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102588:	8b 55 08             	mov    0x8(%ebp),%edx
8010258b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010258e:	8b 45 10             	mov    0x10(%ebp),%eax
80102591:	89 cb                	mov    %ecx,%ebx
80102593:	89 de                	mov    %ebx,%esi
80102595:	89 c1                	mov    %eax,%ecx
80102597:	fc                   	cld    
80102598:	f3 6f                	rep outsl %ds:(%esi),(%dx)
8010259a:	89 c8                	mov    %ecx,%eax
8010259c:	89 f3                	mov    %esi,%ebx
8010259e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801025a1:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801025a4:	90                   	nop
801025a5:	5b                   	pop    %ebx
801025a6:	5e                   	pop    %esi
801025a7:	5d                   	pop    %ebp
801025a8:	c3                   	ret    

801025a9 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801025a9:	55                   	push   %ebp
801025aa:	89 e5                	mov    %esp,%ebp
801025ac:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801025af:	90                   	nop
801025b0:	68 f7 01 00 00       	push   $0x1f7
801025b5:	e8 67 ff ff ff       	call   80102521 <inb>
801025ba:	83 c4 04             	add    $0x4,%esp
801025bd:	0f b6 c0             	movzbl %al,%eax
801025c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
801025c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801025c6:	25 c0 00 00 00       	and    $0xc0,%eax
801025cb:	83 f8 40             	cmp    $0x40,%eax
801025ce:	75 e0                	jne    801025b0 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801025d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025d4:	74 11                	je     801025e7 <idewait+0x3e>
801025d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801025d9:	83 e0 21             	and    $0x21,%eax
801025dc:	85 c0                	test   %eax,%eax
801025de:	74 07                	je     801025e7 <idewait+0x3e>
    return -1;
801025e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025e5:	eb 05                	jmp    801025ec <idewait+0x43>
  return 0;
801025e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801025ec:	c9                   	leave  
801025ed:	c3                   	ret    

801025ee <ideinit>:

void
ideinit(void)
{
801025ee:	55                   	push   %ebp
801025ef:	89 e5                	mov    %esp,%ebp
801025f1:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
801025f4:	83 ec 08             	sub    $0x8,%esp
801025f7:	68 61 87 10 80       	push   $0x80108761
801025fc:	68 00 b6 10 80       	push   $0x8010b600
80102601:	e8 6e 29 00 00       	call   80104f74 <initlock>
80102606:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
80102609:	83 ec 0c             	sub    $0xc,%esp
8010260c:	6a 0e                	push   $0xe
8010260e:	e8 a0 18 00 00       	call   80103eb3 <picenable>
80102613:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
80102616:	a1 40 29 11 80       	mov    0x80112940,%eax
8010261b:	83 e8 01             	sub    $0x1,%eax
8010261e:	83 ec 08             	sub    $0x8,%esp
80102621:	50                   	push   %eax
80102622:	6a 0e                	push   $0xe
80102624:	e8 73 04 00 00       	call   80102a9c <ioapicenable>
80102629:	83 c4 10             	add    $0x10,%esp
  idewait(0);
8010262c:	83 ec 0c             	sub    $0xc,%esp
8010262f:	6a 00                	push   $0x0
80102631:	e8 73 ff ff ff       	call   801025a9 <idewait>
80102636:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102639:	83 ec 08             	sub    $0x8,%esp
8010263c:	68 f0 00 00 00       	push   $0xf0
80102641:	68 f6 01 00 00       	push   $0x1f6
80102646:	e8 19 ff ff ff       	call   80102564 <outb>
8010264b:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
8010264e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102655:	eb 24                	jmp    8010267b <ideinit+0x8d>
    if(inb(0x1f7) != 0){
80102657:	83 ec 0c             	sub    $0xc,%esp
8010265a:	68 f7 01 00 00       	push   $0x1f7
8010265f:	e8 bd fe ff ff       	call   80102521 <inb>
80102664:	83 c4 10             	add    $0x10,%esp
80102667:	84 c0                	test   %al,%al
80102669:	74 0c                	je     80102677 <ideinit+0x89>
      havedisk1 = 1;
8010266b:	c7 05 38 b6 10 80 01 	movl   $0x1,0x8010b638
80102672:	00 00 00 
      break;
80102675:	eb 0d                	jmp    80102684 <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102677:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010267b:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102682:	7e d3                	jle    80102657 <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102684:	83 ec 08             	sub    $0x8,%esp
80102687:	68 e0 00 00 00       	push   $0xe0
8010268c:	68 f6 01 00 00       	push   $0x1f6
80102691:	e8 ce fe ff ff       	call   80102564 <outb>
80102696:	83 c4 10             	add    $0x10,%esp
}
80102699:	90                   	nop
8010269a:	c9                   	leave  
8010269b:	c3                   	ret    

8010269c <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
8010269c:	55                   	push   %ebp
8010269d:	89 e5                	mov    %esp,%ebp
8010269f:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801026a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026a6:	75 0d                	jne    801026b5 <idestart+0x19>
    panic("idestart");
801026a8:	83 ec 0c             	sub    $0xc,%esp
801026ab:	68 65 87 10 80       	push   $0x80108765
801026b0:	e8 b1 de ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
801026b5:	8b 45 08             	mov    0x8(%ebp),%eax
801026b8:	8b 40 08             	mov    0x8(%eax),%eax
801026bb:	3d e7 03 00 00       	cmp    $0x3e7,%eax
801026c0:	76 0d                	jbe    801026cf <idestart+0x33>
    panic("incorrect blockno");
801026c2:	83 ec 0c             	sub    $0xc,%esp
801026c5:	68 6e 87 10 80       	push   $0x8010876e
801026ca:	e8 97 de ff ff       	call   80100566 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
801026cf:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
801026d6:	8b 45 08             	mov    0x8(%ebp),%eax
801026d9:	8b 50 08             	mov    0x8(%eax),%edx
801026dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026df:	0f af c2             	imul   %edx,%eax
801026e2:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
801026e5:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
801026e9:	7e 0d                	jle    801026f8 <idestart+0x5c>
801026eb:	83 ec 0c             	sub    $0xc,%esp
801026ee:	68 65 87 10 80       	push   $0x80108765
801026f3:	e8 6e de ff ff       	call   80100566 <panic>
  
  idewait(0);
801026f8:	83 ec 0c             	sub    $0xc,%esp
801026fb:	6a 00                	push   $0x0
801026fd:	e8 a7 fe ff ff       	call   801025a9 <idewait>
80102702:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102705:	83 ec 08             	sub    $0x8,%esp
80102708:	6a 00                	push   $0x0
8010270a:	68 f6 03 00 00       	push   $0x3f6
8010270f:	e8 50 fe ff ff       	call   80102564 <outb>
80102714:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
80102717:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010271a:	0f b6 c0             	movzbl %al,%eax
8010271d:	83 ec 08             	sub    $0x8,%esp
80102720:	50                   	push   %eax
80102721:	68 f2 01 00 00       	push   $0x1f2
80102726:	e8 39 fe ff ff       	call   80102564 <outb>
8010272b:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
8010272e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102731:	0f b6 c0             	movzbl %al,%eax
80102734:	83 ec 08             	sub    $0x8,%esp
80102737:	50                   	push   %eax
80102738:	68 f3 01 00 00       	push   $0x1f3
8010273d:	e8 22 fe ff ff       	call   80102564 <outb>
80102742:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102745:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102748:	c1 f8 08             	sar    $0x8,%eax
8010274b:	0f b6 c0             	movzbl %al,%eax
8010274e:	83 ec 08             	sub    $0x8,%esp
80102751:	50                   	push   %eax
80102752:	68 f4 01 00 00       	push   $0x1f4
80102757:	e8 08 fe ff ff       	call   80102564 <outb>
8010275c:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
8010275f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102762:	c1 f8 10             	sar    $0x10,%eax
80102765:	0f b6 c0             	movzbl %al,%eax
80102768:	83 ec 08             	sub    $0x8,%esp
8010276b:	50                   	push   %eax
8010276c:	68 f5 01 00 00       	push   $0x1f5
80102771:	e8 ee fd ff ff       	call   80102564 <outb>
80102776:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102779:	8b 45 08             	mov    0x8(%ebp),%eax
8010277c:	8b 40 04             	mov    0x4(%eax),%eax
8010277f:	83 e0 01             	and    $0x1,%eax
80102782:	c1 e0 04             	shl    $0x4,%eax
80102785:	89 c2                	mov    %eax,%edx
80102787:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010278a:	c1 f8 18             	sar    $0x18,%eax
8010278d:	83 e0 0f             	and    $0xf,%eax
80102790:	09 d0                	or     %edx,%eax
80102792:	83 c8 e0             	or     $0xffffffe0,%eax
80102795:	0f b6 c0             	movzbl %al,%eax
80102798:	83 ec 08             	sub    $0x8,%esp
8010279b:	50                   	push   %eax
8010279c:	68 f6 01 00 00       	push   $0x1f6
801027a1:	e8 be fd ff ff       	call   80102564 <outb>
801027a6:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
801027a9:	8b 45 08             	mov    0x8(%ebp),%eax
801027ac:	8b 00                	mov    (%eax),%eax
801027ae:	83 e0 04             	and    $0x4,%eax
801027b1:	85 c0                	test   %eax,%eax
801027b3:	74 30                	je     801027e5 <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
801027b5:	83 ec 08             	sub    $0x8,%esp
801027b8:	6a 30                	push   $0x30
801027ba:	68 f7 01 00 00       	push   $0x1f7
801027bf:	e8 a0 fd ff ff       	call   80102564 <outb>
801027c4:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
801027c7:	8b 45 08             	mov    0x8(%ebp),%eax
801027ca:	83 c0 18             	add    $0x18,%eax
801027cd:	83 ec 04             	sub    $0x4,%esp
801027d0:	68 80 00 00 00       	push   $0x80
801027d5:	50                   	push   %eax
801027d6:	68 f0 01 00 00       	push   $0x1f0
801027db:	e8 a3 fd ff ff       	call   80102583 <outsl>
801027e0:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
801027e3:	eb 12                	jmp    801027f7 <idestart+0x15b>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
801027e5:	83 ec 08             	sub    $0x8,%esp
801027e8:	6a 20                	push   $0x20
801027ea:	68 f7 01 00 00       	push   $0x1f7
801027ef:	e8 70 fd ff ff       	call   80102564 <outb>
801027f4:	83 c4 10             	add    $0x10,%esp
  }
}
801027f7:	90                   	nop
801027f8:	c9                   	leave  
801027f9:	c3                   	ret    

801027fa <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801027fa:	55                   	push   %ebp
801027fb:	89 e5                	mov    %esp,%ebp
801027fd:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102800:	83 ec 0c             	sub    $0xc,%esp
80102803:	68 00 b6 10 80       	push   $0x8010b600
80102808:	e8 89 27 00 00       	call   80104f96 <acquire>
8010280d:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
80102810:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102815:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102818:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010281c:	75 15                	jne    80102833 <ideintr+0x39>
    release(&idelock);
8010281e:	83 ec 0c             	sub    $0xc,%esp
80102821:	68 00 b6 10 80       	push   $0x8010b600
80102826:	e8 d2 27 00 00       	call   80104ffd <release>
8010282b:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
8010282e:	e9 9a 00 00 00       	jmp    801028cd <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102833:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102836:	8b 40 14             	mov    0x14(%eax),%eax
80102839:	a3 34 b6 10 80       	mov    %eax,0x8010b634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102841:	8b 00                	mov    (%eax),%eax
80102843:	83 e0 04             	and    $0x4,%eax
80102846:	85 c0                	test   %eax,%eax
80102848:	75 2d                	jne    80102877 <ideintr+0x7d>
8010284a:	83 ec 0c             	sub    $0xc,%esp
8010284d:	6a 01                	push   $0x1
8010284f:	e8 55 fd ff ff       	call   801025a9 <idewait>
80102854:	83 c4 10             	add    $0x10,%esp
80102857:	85 c0                	test   %eax,%eax
80102859:	78 1c                	js     80102877 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
8010285b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010285e:	83 c0 18             	add    $0x18,%eax
80102861:	83 ec 04             	sub    $0x4,%esp
80102864:	68 80 00 00 00       	push   $0x80
80102869:	50                   	push   %eax
8010286a:	68 f0 01 00 00       	push   $0x1f0
8010286f:	e8 ca fc ff ff       	call   8010253e <insl>
80102874:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102877:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010287a:	8b 00                	mov    (%eax),%eax
8010287c:	83 c8 02             	or     $0x2,%eax
8010287f:	89 c2                	mov    %eax,%edx
80102881:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102884:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102886:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102889:	8b 00                	mov    (%eax),%eax
8010288b:	83 e0 fb             	and    $0xfffffffb,%eax
8010288e:	89 c2                	mov    %eax,%edx
80102890:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102893:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102895:	83 ec 0c             	sub    $0xc,%esp
80102898:	ff 75 f4             	pushl  -0xc(%ebp)
8010289b:	e8 e8 24 00 00       	call   80104d88 <wakeup>
801028a0:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
801028a3:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801028a8:	85 c0                	test   %eax,%eax
801028aa:	74 11                	je     801028bd <ideintr+0xc3>
    idestart(idequeue);
801028ac:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801028b1:	83 ec 0c             	sub    $0xc,%esp
801028b4:	50                   	push   %eax
801028b5:	e8 e2 fd ff ff       	call   8010269c <idestart>
801028ba:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
801028bd:	83 ec 0c             	sub    $0xc,%esp
801028c0:	68 00 b6 10 80       	push   $0x8010b600
801028c5:	e8 33 27 00 00       	call   80104ffd <release>
801028ca:	83 c4 10             	add    $0x10,%esp
}
801028cd:	c9                   	leave  
801028ce:	c3                   	ret    

801028cf <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801028cf:	55                   	push   %ebp
801028d0:	89 e5                	mov    %esp,%ebp
801028d2:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801028d5:	8b 45 08             	mov    0x8(%ebp),%eax
801028d8:	8b 00                	mov    (%eax),%eax
801028da:	83 e0 01             	and    $0x1,%eax
801028dd:	85 c0                	test   %eax,%eax
801028df:	75 0d                	jne    801028ee <iderw+0x1f>
    panic("iderw: buf not busy");
801028e1:	83 ec 0c             	sub    $0xc,%esp
801028e4:	68 80 87 10 80       	push   $0x80108780
801028e9:	e8 78 dc ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801028ee:	8b 45 08             	mov    0x8(%ebp),%eax
801028f1:	8b 00                	mov    (%eax),%eax
801028f3:	83 e0 06             	and    $0x6,%eax
801028f6:	83 f8 02             	cmp    $0x2,%eax
801028f9:	75 0d                	jne    80102908 <iderw+0x39>
    panic("iderw: nothing to do");
801028fb:	83 ec 0c             	sub    $0xc,%esp
801028fe:	68 94 87 10 80       	push   $0x80108794
80102903:	e8 5e dc ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
80102908:	8b 45 08             	mov    0x8(%ebp),%eax
8010290b:	8b 40 04             	mov    0x4(%eax),%eax
8010290e:	85 c0                	test   %eax,%eax
80102910:	74 16                	je     80102928 <iderw+0x59>
80102912:	a1 38 b6 10 80       	mov    0x8010b638,%eax
80102917:	85 c0                	test   %eax,%eax
80102919:	75 0d                	jne    80102928 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
8010291b:	83 ec 0c             	sub    $0xc,%esp
8010291e:	68 a9 87 10 80       	push   $0x801087a9
80102923:	e8 3e dc ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102928:	83 ec 0c             	sub    $0xc,%esp
8010292b:	68 00 b6 10 80       	push   $0x8010b600
80102930:	e8 61 26 00 00       	call   80104f96 <acquire>
80102935:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102938:	8b 45 08             	mov    0x8(%ebp),%eax
8010293b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102942:	c7 45 f4 34 b6 10 80 	movl   $0x8010b634,-0xc(%ebp)
80102949:	eb 0b                	jmp    80102956 <iderw+0x87>
8010294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010294e:	8b 00                	mov    (%eax),%eax
80102950:	83 c0 14             	add    $0x14,%eax
80102953:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102956:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102959:	8b 00                	mov    (%eax),%eax
8010295b:	85 c0                	test   %eax,%eax
8010295d:	75 ec                	jne    8010294b <iderw+0x7c>
    ;
  *pp = b;
8010295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102962:	8b 55 08             	mov    0x8(%ebp),%edx
80102965:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102967:	a1 34 b6 10 80       	mov    0x8010b634,%eax
8010296c:	3b 45 08             	cmp    0x8(%ebp),%eax
8010296f:	75 23                	jne    80102994 <iderw+0xc5>
    idestart(b);
80102971:	83 ec 0c             	sub    $0xc,%esp
80102974:	ff 75 08             	pushl  0x8(%ebp)
80102977:	e8 20 fd ff ff       	call   8010269c <idestart>
8010297c:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010297f:	eb 13                	jmp    80102994 <iderw+0xc5>
    sleep(b, &idelock);
80102981:	83 ec 08             	sub    $0x8,%esp
80102984:	68 00 b6 10 80       	push   $0x8010b600
80102989:	ff 75 08             	pushl  0x8(%ebp)
8010298c:	e8 0c 23 00 00       	call   80104c9d <sleep>
80102991:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102994:	8b 45 08             	mov    0x8(%ebp),%eax
80102997:	8b 00                	mov    (%eax),%eax
80102999:	83 e0 06             	and    $0x6,%eax
8010299c:	83 f8 02             	cmp    $0x2,%eax
8010299f:	75 e0                	jne    80102981 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
801029a1:	83 ec 0c             	sub    $0xc,%esp
801029a4:	68 00 b6 10 80       	push   $0x8010b600
801029a9:	e8 4f 26 00 00       	call   80104ffd <release>
801029ae:	83 c4 10             	add    $0x10,%esp
}
801029b1:	90                   	nop
801029b2:	c9                   	leave  
801029b3:	c3                   	ret    

801029b4 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
801029b4:	55                   	push   %ebp
801029b5:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801029b7:	a1 14 22 11 80       	mov    0x80112214,%eax
801029bc:	8b 55 08             	mov    0x8(%ebp),%edx
801029bf:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
801029c1:	a1 14 22 11 80       	mov    0x80112214,%eax
801029c6:	8b 40 10             	mov    0x10(%eax),%eax
}
801029c9:	5d                   	pop    %ebp
801029ca:	c3                   	ret    

801029cb <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
801029cb:	55                   	push   %ebp
801029cc:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801029ce:	a1 14 22 11 80       	mov    0x80112214,%eax
801029d3:	8b 55 08             	mov    0x8(%ebp),%edx
801029d6:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801029d8:	a1 14 22 11 80       	mov    0x80112214,%eax
801029dd:	8b 55 0c             	mov    0xc(%ebp),%edx
801029e0:	89 50 10             	mov    %edx,0x10(%eax)
}
801029e3:	90                   	nop
801029e4:	5d                   	pop    %ebp
801029e5:	c3                   	ret    

801029e6 <ioapicinit>:

void
ioapicinit(void)
{
801029e6:	55                   	push   %ebp
801029e7:	89 e5                	mov    %esp,%ebp
801029e9:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
801029ec:	a1 44 23 11 80       	mov    0x80112344,%eax
801029f1:	85 c0                	test   %eax,%eax
801029f3:	0f 84 a0 00 00 00    	je     80102a99 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
801029f9:	c7 05 14 22 11 80 00 	movl   $0xfec00000,0x80112214
80102a00:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a03:	6a 01                	push   $0x1
80102a05:	e8 aa ff ff ff       	call   801029b4 <ioapicread>
80102a0a:	83 c4 04             	add    $0x4,%esp
80102a0d:	c1 e8 10             	shr    $0x10,%eax
80102a10:	25 ff 00 00 00       	and    $0xff,%eax
80102a15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102a18:	6a 00                	push   $0x0
80102a1a:	e8 95 ff ff ff       	call   801029b4 <ioapicread>
80102a1f:	83 c4 04             	add    $0x4,%esp
80102a22:	c1 e8 18             	shr    $0x18,%eax
80102a25:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102a28:	0f b6 05 40 23 11 80 	movzbl 0x80112340,%eax
80102a2f:	0f b6 c0             	movzbl %al,%eax
80102a32:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102a35:	74 10                	je     80102a47 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102a37:	83 ec 0c             	sub    $0xc,%esp
80102a3a:	68 c8 87 10 80       	push   $0x801087c8
80102a3f:	e8 82 d9 ff ff       	call   801003c6 <cprintf>
80102a44:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a47:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102a4e:	eb 3f                	jmp    80102a8f <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a53:	83 c0 20             	add    $0x20,%eax
80102a56:	0d 00 00 01 00       	or     $0x10000,%eax
80102a5b:	89 c2                	mov    %eax,%edx
80102a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a60:	83 c0 08             	add    $0x8,%eax
80102a63:	01 c0                	add    %eax,%eax
80102a65:	83 ec 08             	sub    $0x8,%esp
80102a68:	52                   	push   %edx
80102a69:	50                   	push   %eax
80102a6a:	e8 5c ff ff ff       	call   801029cb <ioapicwrite>
80102a6f:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a75:	83 c0 08             	add    $0x8,%eax
80102a78:	01 c0                	add    %eax,%eax
80102a7a:	83 c0 01             	add    $0x1,%eax
80102a7d:	83 ec 08             	sub    $0x8,%esp
80102a80:	6a 00                	push   $0x0
80102a82:	50                   	push   %eax
80102a83:	e8 43 ff ff ff       	call   801029cb <ioapicwrite>
80102a88:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a8b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a92:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102a95:	7e b9                	jle    80102a50 <ioapicinit+0x6a>
80102a97:	eb 01                	jmp    80102a9a <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102a99:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102a9a:	c9                   	leave  
80102a9b:	c3                   	ret    

80102a9c <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102a9c:	55                   	push   %ebp
80102a9d:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102a9f:	a1 44 23 11 80       	mov    0x80112344,%eax
80102aa4:	85 c0                	test   %eax,%eax
80102aa6:	74 39                	je     80102ae1 <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102aa8:	8b 45 08             	mov    0x8(%ebp),%eax
80102aab:	83 c0 20             	add    $0x20,%eax
80102aae:	89 c2                	mov    %eax,%edx
80102ab0:	8b 45 08             	mov    0x8(%ebp),%eax
80102ab3:	83 c0 08             	add    $0x8,%eax
80102ab6:	01 c0                	add    %eax,%eax
80102ab8:	52                   	push   %edx
80102ab9:	50                   	push   %eax
80102aba:	e8 0c ff ff ff       	call   801029cb <ioapicwrite>
80102abf:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ac5:	c1 e0 18             	shl    $0x18,%eax
80102ac8:	89 c2                	mov    %eax,%edx
80102aca:	8b 45 08             	mov    0x8(%ebp),%eax
80102acd:	83 c0 08             	add    $0x8,%eax
80102ad0:	01 c0                	add    %eax,%eax
80102ad2:	83 c0 01             	add    $0x1,%eax
80102ad5:	52                   	push   %edx
80102ad6:	50                   	push   %eax
80102ad7:	e8 ef fe ff ff       	call   801029cb <ioapicwrite>
80102adc:	83 c4 08             	add    $0x8,%esp
80102adf:	eb 01                	jmp    80102ae2 <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102ae1:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102ae2:	c9                   	leave  
80102ae3:	c3                   	ret    

80102ae4 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102ae4:	55                   	push   %ebp
80102ae5:	89 e5                	mov    %esp,%ebp
80102ae7:	8b 45 08             	mov    0x8(%ebp),%eax
80102aea:	05 00 00 00 80       	add    $0x80000000,%eax
80102aef:	5d                   	pop    %ebp
80102af0:	c3                   	ret    

80102af1 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102af1:	55                   	push   %ebp
80102af2:	89 e5                	mov    %esp,%ebp
80102af4:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102af7:	83 ec 08             	sub    $0x8,%esp
80102afa:	68 fa 87 10 80       	push   $0x801087fa
80102aff:	68 20 22 11 80       	push   $0x80112220
80102b04:	e8 6b 24 00 00       	call   80104f74 <initlock>
80102b09:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102b0c:	c7 05 54 22 11 80 00 	movl   $0x0,0x80112254
80102b13:	00 00 00 
  freerange(vstart, vend);
80102b16:	83 ec 08             	sub    $0x8,%esp
80102b19:	ff 75 0c             	pushl  0xc(%ebp)
80102b1c:	ff 75 08             	pushl  0x8(%ebp)
80102b1f:	e8 2a 00 00 00       	call   80102b4e <freerange>
80102b24:	83 c4 10             	add    $0x10,%esp
}
80102b27:	90                   	nop
80102b28:	c9                   	leave  
80102b29:	c3                   	ret    

80102b2a <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102b2a:	55                   	push   %ebp
80102b2b:	89 e5                	mov    %esp,%ebp
80102b2d:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102b30:	83 ec 08             	sub    $0x8,%esp
80102b33:	ff 75 0c             	pushl  0xc(%ebp)
80102b36:	ff 75 08             	pushl  0x8(%ebp)
80102b39:	e8 10 00 00 00       	call   80102b4e <freerange>
80102b3e:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102b41:	c7 05 54 22 11 80 01 	movl   $0x1,0x80112254
80102b48:	00 00 00 
}
80102b4b:	90                   	nop
80102b4c:	c9                   	leave  
80102b4d:	c3                   	ret    

80102b4e <freerange>:

void
freerange(void *vstart, void *vend)
{
80102b4e:	55                   	push   %ebp
80102b4f:	89 e5                	mov    %esp,%ebp
80102b51:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102b54:	8b 45 08             	mov    0x8(%ebp),%eax
80102b57:	05 ff 0f 00 00       	add    $0xfff,%eax
80102b5c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102b61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b64:	eb 15                	jmp    80102b7b <freerange+0x2d>
    kfree(p);
80102b66:	83 ec 0c             	sub    $0xc,%esp
80102b69:	ff 75 f4             	pushl  -0xc(%ebp)
80102b6c:	e8 1a 00 00 00       	call   80102b8b <kfree>
80102b71:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b74:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b7e:	05 00 10 00 00       	add    $0x1000,%eax
80102b83:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102b86:	76 de                	jbe    80102b66 <freerange+0x18>
    kfree(p);
}
80102b88:	90                   	nop
80102b89:	c9                   	leave  
80102b8a:	c3                   	ret    

80102b8b <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b8b:	55                   	push   %ebp
80102b8c:	89 e5                	mov    %esp,%ebp
80102b8e:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102b91:	8b 45 08             	mov    0x8(%ebp),%eax
80102b94:	25 ff 0f 00 00       	and    $0xfff,%eax
80102b99:	85 c0                	test   %eax,%eax
80102b9b:	75 1b                	jne    80102bb8 <kfree+0x2d>
80102b9d:	81 7d 08 3c 52 11 80 	cmpl   $0x8011523c,0x8(%ebp)
80102ba4:	72 12                	jb     80102bb8 <kfree+0x2d>
80102ba6:	ff 75 08             	pushl  0x8(%ebp)
80102ba9:	e8 36 ff ff ff       	call   80102ae4 <v2p>
80102bae:	83 c4 04             	add    $0x4,%esp
80102bb1:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102bb6:	76 0d                	jbe    80102bc5 <kfree+0x3a>
    panic("kfree");
80102bb8:	83 ec 0c             	sub    $0xc,%esp
80102bbb:	68 ff 87 10 80       	push   $0x801087ff
80102bc0:	e8 a1 d9 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102bc5:	83 ec 04             	sub    $0x4,%esp
80102bc8:	68 00 10 00 00       	push   $0x1000
80102bcd:	6a 01                	push   $0x1
80102bcf:	ff 75 08             	pushl  0x8(%ebp)
80102bd2:	e8 22 26 00 00       	call   801051f9 <memset>
80102bd7:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102bda:	a1 54 22 11 80       	mov    0x80112254,%eax
80102bdf:	85 c0                	test   %eax,%eax
80102be1:	74 10                	je     80102bf3 <kfree+0x68>
    acquire(&kmem.lock);
80102be3:	83 ec 0c             	sub    $0xc,%esp
80102be6:	68 20 22 11 80       	push   $0x80112220
80102beb:	e8 a6 23 00 00       	call   80104f96 <acquire>
80102bf0:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102bf3:	8b 45 08             	mov    0x8(%ebp),%eax
80102bf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102bf9:	8b 15 58 22 11 80    	mov    0x80112258,%edx
80102bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c02:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c07:	a3 58 22 11 80       	mov    %eax,0x80112258
  if(kmem.use_lock)
80102c0c:	a1 54 22 11 80       	mov    0x80112254,%eax
80102c11:	85 c0                	test   %eax,%eax
80102c13:	74 10                	je     80102c25 <kfree+0x9a>
    release(&kmem.lock);
80102c15:	83 ec 0c             	sub    $0xc,%esp
80102c18:	68 20 22 11 80       	push   $0x80112220
80102c1d:	e8 db 23 00 00       	call   80104ffd <release>
80102c22:	83 c4 10             	add    $0x10,%esp
}
80102c25:	90                   	nop
80102c26:	c9                   	leave  
80102c27:	c3                   	ret    

80102c28 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102c28:	55                   	push   %ebp
80102c29:	89 e5                	mov    %esp,%ebp
80102c2b:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102c2e:	a1 54 22 11 80       	mov    0x80112254,%eax
80102c33:	85 c0                	test   %eax,%eax
80102c35:	74 10                	je     80102c47 <kalloc+0x1f>
    acquire(&kmem.lock);
80102c37:	83 ec 0c             	sub    $0xc,%esp
80102c3a:	68 20 22 11 80       	push   $0x80112220
80102c3f:	e8 52 23 00 00       	call   80104f96 <acquire>
80102c44:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102c47:	a1 58 22 11 80       	mov    0x80112258,%eax
80102c4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102c4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102c53:	74 0a                	je     80102c5f <kalloc+0x37>
    kmem.freelist = r->next;
80102c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c58:	8b 00                	mov    (%eax),%eax
80102c5a:	a3 58 22 11 80       	mov    %eax,0x80112258
  if(kmem.use_lock)
80102c5f:	a1 54 22 11 80       	mov    0x80112254,%eax
80102c64:	85 c0                	test   %eax,%eax
80102c66:	74 10                	je     80102c78 <kalloc+0x50>
    release(&kmem.lock);
80102c68:	83 ec 0c             	sub    $0xc,%esp
80102c6b:	68 20 22 11 80       	push   $0x80112220
80102c70:	e8 88 23 00 00       	call   80104ffd <release>
80102c75:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102c7b:	c9                   	leave  
80102c7c:	c3                   	ret    

80102c7d <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102c7d:	55                   	push   %ebp
80102c7e:	89 e5                	mov    %esp,%ebp
80102c80:	83 ec 14             	sub    $0x14,%esp
80102c83:	8b 45 08             	mov    0x8(%ebp),%eax
80102c86:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c8a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102c8e:	89 c2                	mov    %eax,%edx
80102c90:	ec                   	in     (%dx),%al
80102c91:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102c94:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102c98:	c9                   	leave  
80102c99:	c3                   	ret    

80102c9a <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102c9a:	55                   	push   %ebp
80102c9b:	89 e5                	mov    %esp,%ebp
80102c9d:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102ca0:	6a 64                	push   $0x64
80102ca2:	e8 d6 ff ff ff       	call   80102c7d <inb>
80102ca7:	83 c4 04             	add    $0x4,%esp
80102caa:	0f b6 c0             	movzbl %al,%eax
80102cad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cb3:	83 e0 01             	and    $0x1,%eax
80102cb6:	85 c0                	test   %eax,%eax
80102cb8:	75 0a                	jne    80102cc4 <kbdgetc+0x2a>
    return -1;
80102cba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102cbf:	e9 23 01 00 00       	jmp    80102de7 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102cc4:	6a 60                	push   $0x60
80102cc6:	e8 b2 ff ff ff       	call   80102c7d <inb>
80102ccb:	83 c4 04             	add    $0x4,%esp
80102cce:	0f b6 c0             	movzbl %al,%eax
80102cd1:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102cd4:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102cdb:	75 17                	jne    80102cf4 <kbdgetc+0x5a>
    shift |= E0ESC;
80102cdd:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102ce2:	83 c8 40             	or     $0x40,%eax
80102ce5:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102cea:	b8 00 00 00 00       	mov    $0x0,%eax
80102cef:	e9 f3 00 00 00       	jmp    80102de7 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102cf4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cf7:	25 80 00 00 00       	and    $0x80,%eax
80102cfc:	85 c0                	test   %eax,%eax
80102cfe:	74 45                	je     80102d45 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102d00:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d05:	83 e0 40             	and    $0x40,%eax
80102d08:	85 c0                	test   %eax,%eax
80102d0a:	75 08                	jne    80102d14 <kbdgetc+0x7a>
80102d0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d0f:	83 e0 7f             	and    $0x7f,%eax
80102d12:	eb 03                	jmp    80102d17 <kbdgetc+0x7d>
80102d14:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d17:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102d1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d1d:	05 20 90 10 80       	add    $0x80109020,%eax
80102d22:	0f b6 00             	movzbl (%eax),%eax
80102d25:	83 c8 40             	or     $0x40,%eax
80102d28:	0f b6 c0             	movzbl %al,%eax
80102d2b:	f7 d0                	not    %eax
80102d2d:	89 c2                	mov    %eax,%edx
80102d2f:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d34:	21 d0                	and    %edx,%eax
80102d36:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102d3b:	b8 00 00 00 00       	mov    $0x0,%eax
80102d40:	e9 a2 00 00 00       	jmp    80102de7 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102d45:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d4a:	83 e0 40             	and    $0x40,%eax
80102d4d:	85 c0                	test   %eax,%eax
80102d4f:	74 14                	je     80102d65 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102d51:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102d58:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d5d:	83 e0 bf             	and    $0xffffffbf,%eax
80102d60:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  }

  shift |= shiftcode[data];
80102d65:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d68:	05 20 90 10 80       	add    $0x80109020,%eax
80102d6d:	0f b6 00             	movzbl (%eax),%eax
80102d70:	0f b6 d0             	movzbl %al,%edx
80102d73:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d78:	09 d0                	or     %edx,%eax
80102d7a:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  shift ^= togglecode[data];
80102d7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d82:	05 20 91 10 80       	add    $0x80109120,%eax
80102d87:	0f b6 00             	movzbl (%eax),%eax
80102d8a:	0f b6 d0             	movzbl %al,%edx
80102d8d:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d92:	31 d0                	xor    %edx,%eax
80102d94:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102d99:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d9e:	83 e0 03             	and    $0x3,%eax
80102da1:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102da8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dab:	01 d0                	add    %edx,%eax
80102dad:	0f b6 00             	movzbl (%eax),%eax
80102db0:	0f b6 c0             	movzbl %al,%eax
80102db3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102db6:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102dbb:	83 e0 08             	and    $0x8,%eax
80102dbe:	85 c0                	test   %eax,%eax
80102dc0:	74 22                	je     80102de4 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102dc2:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102dc6:	76 0c                	jbe    80102dd4 <kbdgetc+0x13a>
80102dc8:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102dcc:	77 06                	ja     80102dd4 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102dce:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102dd2:	eb 10                	jmp    80102de4 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102dd4:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102dd8:	76 0a                	jbe    80102de4 <kbdgetc+0x14a>
80102dda:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102dde:	77 04                	ja     80102de4 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102de0:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102de4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102de7:	c9                   	leave  
80102de8:	c3                   	ret    

80102de9 <kbdintr>:

void
kbdintr(void)
{
80102de9:	55                   	push   %ebp
80102dea:	89 e5                	mov    %esp,%ebp
80102dec:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102def:	83 ec 0c             	sub    $0xc,%esp
80102df2:	68 9a 2c 10 80       	push   $0x80102c9a
80102df7:	e8 fd d9 ff ff       	call   801007f9 <consoleintr>
80102dfc:	83 c4 10             	add    $0x10,%esp
}
80102dff:	90                   	nop
80102e00:	c9                   	leave  
80102e01:	c3                   	ret    

80102e02 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102e02:	55                   	push   %ebp
80102e03:	89 e5                	mov    %esp,%ebp
80102e05:	83 ec 14             	sub    $0x14,%esp
80102e08:	8b 45 08             	mov    0x8(%ebp),%eax
80102e0b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e0f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102e13:	89 c2                	mov    %eax,%edx
80102e15:	ec                   	in     (%dx),%al
80102e16:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102e19:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102e1d:	c9                   	leave  
80102e1e:	c3                   	ret    

80102e1f <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102e1f:	55                   	push   %ebp
80102e20:	89 e5                	mov    %esp,%ebp
80102e22:	83 ec 08             	sub    $0x8,%esp
80102e25:	8b 55 08             	mov    0x8(%ebp),%edx
80102e28:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e2b:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102e2f:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e32:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102e36:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102e3a:	ee                   	out    %al,(%dx)
}
80102e3b:	90                   	nop
80102e3c:	c9                   	leave  
80102e3d:	c3                   	ret    

80102e3e <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102e3e:	55                   	push   %ebp
80102e3f:	89 e5                	mov    %esp,%ebp
80102e41:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102e44:	9c                   	pushf  
80102e45:	58                   	pop    %eax
80102e46:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102e49:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102e4c:	c9                   	leave  
80102e4d:	c3                   	ret    

80102e4e <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102e4e:	55                   	push   %ebp
80102e4f:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102e51:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102e56:	8b 55 08             	mov    0x8(%ebp),%edx
80102e59:	c1 e2 02             	shl    $0x2,%edx
80102e5c:	01 c2                	add    %eax,%edx
80102e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e61:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102e63:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102e68:	83 c0 20             	add    $0x20,%eax
80102e6b:	8b 00                	mov    (%eax),%eax
}
80102e6d:	90                   	nop
80102e6e:	5d                   	pop    %ebp
80102e6f:	c3                   	ret    

80102e70 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102e73:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102e78:	85 c0                	test   %eax,%eax
80102e7a:	0f 84 0b 01 00 00    	je     80102f8b <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102e80:	68 3f 01 00 00       	push   $0x13f
80102e85:	6a 3c                	push   $0x3c
80102e87:	e8 c2 ff ff ff       	call   80102e4e <lapicw>
80102e8c:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102e8f:	6a 0b                	push   $0xb
80102e91:	68 f8 00 00 00       	push   $0xf8
80102e96:	e8 b3 ff ff ff       	call   80102e4e <lapicw>
80102e9b:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102e9e:	68 20 00 02 00       	push   $0x20020
80102ea3:	68 c8 00 00 00       	push   $0xc8
80102ea8:	e8 a1 ff ff ff       	call   80102e4e <lapicw>
80102ead:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80102eb0:	68 80 96 98 00       	push   $0x989680
80102eb5:	68 e0 00 00 00       	push   $0xe0
80102eba:	e8 8f ff ff ff       	call   80102e4e <lapicw>
80102ebf:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102ec2:	68 00 00 01 00       	push   $0x10000
80102ec7:	68 d4 00 00 00       	push   $0xd4
80102ecc:	e8 7d ff ff ff       	call   80102e4e <lapicw>
80102ed1:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102ed4:	68 00 00 01 00       	push   $0x10000
80102ed9:	68 d8 00 00 00       	push   $0xd8
80102ede:	e8 6b ff ff ff       	call   80102e4e <lapicw>
80102ee3:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102ee6:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102eeb:	83 c0 30             	add    $0x30,%eax
80102eee:	8b 00                	mov    (%eax),%eax
80102ef0:	c1 e8 10             	shr    $0x10,%eax
80102ef3:	0f b6 c0             	movzbl %al,%eax
80102ef6:	83 f8 03             	cmp    $0x3,%eax
80102ef9:	76 12                	jbe    80102f0d <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80102efb:	68 00 00 01 00       	push   $0x10000
80102f00:	68 d0 00 00 00       	push   $0xd0
80102f05:	e8 44 ff ff ff       	call   80102e4e <lapicw>
80102f0a:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102f0d:	6a 33                	push   $0x33
80102f0f:	68 dc 00 00 00       	push   $0xdc
80102f14:	e8 35 ff ff ff       	call   80102e4e <lapicw>
80102f19:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102f1c:	6a 00                	push   $0x0
80102f1e:	68 a0 00 00 00       	push   $0xa0
80102f23:	e8 26 ff ff ff       	call   80102e4e <lapicw>
80102f28:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102f2b:	6a 00                	push   $0x0
80102f2d:	68 a0 00 00 00       	push   $0xa0
80102f32:	e8 17 ff ff ff       	call   80102e4e <lapicw>
80102f37:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102f3a:	6a 00                	push   $0x0
80102f3c:	6a 2c                	push   $0x2c
80102f3e:	e8 0b ff ff ff       	call   80102e4e <lapicw>
80102f43:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102f46:	6a 00                	push   $0x0
80102f48:	68 c4 00 00 00       	push   $0xc4
80102f4d:	e8 fc fe ff ff       	call   80102e4e <lapicw>
80102f52:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102f55:	68 00 85 08 00       	push   $0x88500
80102f5a:	68 c0 00 00 00       	push   $0xc0
80102f5f:	e8 ea fe ff ff       	call   80102e4e <lapicw>
80102f64:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102f67:	90                   	nop
80102f68:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102f6d:	05 00 03 00 00       	add    $0x300,%eax
80102f72:	8b 00                	mov    (%eax),%eax
80102f74:	25 00 10 00 00       	and    $0x1000,%eax
80102f79:	85 c0                	test   %eax,%eax
80102f7b:	75 eb                	jne    80102f68 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102f7d:	6a 00                	push   $0x0
80102f7f:	6a 20                	push   $0x20
80102f81:	e8 c8 fe ff ff       	call   80102e4e <lapicw>
80102f86:	83 c4 08             	add    $0x8,%esp
80102f89:	eb 01                	jmp    80102f8c <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80102f8b:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102f8c:	c9                   	leave  
80102f8d:	c3                   	ret    

80102f8e <cpunum>:

int
cpunum(void)
{
80102f8e:	55                   	push   %ebp
80102f8f:	89 e5                	mov    %esp,%ebp
80102f91:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102f94:	e8 a5 fe ff ff       	call   80102e3e <readeflags>
80102f99:	25 00 02 00 00       	and    $0x200,%eax
80102f9e:	85 c0                	test   %eax,%eax
80102fa0:	74 26                	je     80102fc8 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
80102fa2:	a1 40 b6 10 80       	mov    0x8010b640,%eax
80102fa7:	8d 50 01             	lea    0x1(%eax),%edx
80102faa:	89 15 40 b6 10 80    	mov    %edx,0x8010b640
80102fb0:	85 c0                	test   %eax,%eax
80102fb2:	75 14                	jne    80102fc8 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80102fb4:	8b 45 04             	mov    0x4(%ebp),%eax
80102fb7:	83 ec 08             	sub    $0x8,%esp
80102fba:	50                   	push   %eax
80102fbb:	68 08 88 10 80       	push   $0x80108808
80102fc0:	e8 01 d4 ff ff       	call   801003c6 <cprintf>
80102fc5:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80102fc8:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102fcd:	85 c0                	test   %eax,%eax
80102fcf:	74 0f                	je     80102fe0 <cpunum+0x52>
    return lapic[ID]>>24;
80102fd1:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102fd6:	83 c0 20             	add    $0x20,%eax
80102fd9:	8b 00                	mov    (%eax),%eax
80102fdb:	c1 e8 18             	shr    $0x18,%eax
80102fde:	eb 05                	jmp    80102fe5 <cpunum+0x57>
  return 0;
80102fe0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102fe5:	c9                   	leave  
80102fe6:	c3                   	ret    

80102fe7 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102fe7:	55                   	push   %ebp
80102fe8:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102fea:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102fef:	85 c0                	test   %eax,%eax
80102ff1:	74 0c                	je     80102fff <lapiceoi+0x18>
    lapicw(EOI, 0);
80102ff3:	6a 00                	push   $0x0
80102ff5:	6a 2c                	push   $0x2c
80102ff7:	e8 52 fe ff ff       	call   80102e4e <lapicw>
80102ffc:	83 c4 08             	add    $0x8,%esp
}
80102fff:	90                   	nop
80103000:	c9                   	leave  
80103001:	c3                   	ret    

80103002 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103002:	55                   	push   %ebp
80103003:	89 e5                	mov    %esp,%ebp
}
80103005:	90                   	nop
80103006:	5d                   	pop    %ebp
80103007:	c3                   	ret    

80103008 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103008:	55                   	push   %ebp
80103009:	89 e5                	mov    %esp,%ebp
8010300b:	83 ec 14             	sub    $0x14,%esp
8010300e:	8b 45 08             	mov    0x8(%ebp),%eax
80103011:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80103014:	6a 0f                	push   $0xf
80103016:	6a 70                	push   $0x70
80103018:	e8 02 fe ff ff       	call   80102e1f <outb>
8010301d:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80103020:	6a 0a                	push   $0xa
80103022:	6a 71                	push   $0x71
80103024:	e8 f6 fd ff ff       	call   80102e1f <outb>
80103029:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
8010302c:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80103033:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103036:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
8010303b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010303e:	83 c0 02             	add    $0x2,%eax
80103041:	8b 55 0c             	mov    0xc(%ebp),%edx
80103044:	c1 ea 04             	shr    $0x4,%edx
80103047:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
8010304a:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010304e:	c1 e0 18             	shl    $0x18,%eax
80103051:	50                   	push   %eax
80103052:	68 c4 00 00 00       	push   $0xc4
80103057:	e8 f2 fd ff ff       	call   80102e4e <lapicw>
8010305c:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
8010305f:	68 00 c5 00 00       	push   $0xc500
80103064:	68 c0 00 00 00       	push   $0xc0
80103069:	e8 e0 fd ff ff       	call   80102e4e <lapicw>
8010306e:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103071:	68 c8 00 00 00       	push   $0xc8
80103076:	e8 87 ff ff ff       	call   80103002 <microdelay>
8010307b:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
8010307e:	68 00 85 00 00       	push   $0x8500
80103083:	68 c0 00 00 00       	push   $0xc0
80103088:	e8 c1 fd ff ff       	call   80102e4e <lapicw>
8010308d:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103090:	6a 64                	push   $0x64
80103092:	e8 6b ff ff ff       	call   80103002 <microdelay>
80103097:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010309a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801030a1:	eb 3d                	jmp    801030e0 <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
801030a3:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801030a7:	c1 e0 18             	shl    $0x18,%eax
801030aa:	50                   	push   %eax
801030ab:	68 c4 00 00 00       	push   $0xc4
801030b0:	e8 99 fd ff ff       	call   80102e4e <lapicw>
801030b5:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
801030b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801030bb:	c1 e8 0c             	shr    $0xc,%eax
801030be:	80 cc 06             	or     $0x6,%ah
801030c1:	50                   	push   %eax
801030c2:	68 c0 00 00 00       	push   $0xc0
801030c7:	e8 82 fd ff ff       	call   80102e4e <lapicw>
801030cc:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
801030cf:	68 c8 00 00 00       	push   $0xc8
801030d4:	e8 29 ff ff ff       	call   80103002 <microdelay>
801030d9:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801030dc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801030e0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801030e4:	7e bd                	jle    801030a3 <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801030e6:	90                   	nop
801030e7:	c9                   	leave  
801030e8:	c3                   	ret    

801030e9 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
801030e9:	55                   	push   %ebp
801030ea:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
801030ec:	8b 45 08             	mov    0x8(%ebp),%eax
801030ef:	0f b6 c0             	movzbl %al,%eax
801030f2:	50                   	push   %eax
801030f3:	6a 70                	push   $0x70
801030f5:	e8 25 fd ff ff       	call   80102e1f <outb>
801030fa:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801030fd:	68 c8 00 00 00       	push   $0xc8
80103102:	e8 fb fe ff ff       	call   80103002 <microdelay>
80103107:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
8010310a:	6a 71                	push   $0x71
8010310c:	e8 f1 fc ff ff       	call   80102e02 <inb>
80103111:	83 c4 04             	add    $0x4,%esp
80103114:	0f b6 c0             	movzbl %al,%eax
}
80103117:	c9                   	leave  
80103118:	c3                   	ret    

80103119 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103119:	55                   	push   %ebp
8010311a:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
8010311c:	6a 00                	push   $0x0
8010311e:	e8 c6 ff ff ff       	call   801030e9 <cmos_read>
80103123:	83 c4 04             	add    $0x4,%esp
80103126:	89 c2                	mov    %eax,%edx
80103128:	8b 45 08             	mov    0x8(%ebp),%eax
8010312b:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
8010312d:	6a 02                	push   $0x2
8010312f:	e8 b5 ff ff ff       	call   801030e9 <cmos_read>
80103134:	83 c4 04             	add    $0x4,%esp
80103137:	89 c2                	mov    %eax,%edx
80103139:	8b 45 08             	mov    0x8(%ebp),%eax
8010313c:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
8010313f:	6a 04                	push   $0x4
80103141:	e8 a3 ff ff ff       	call   801030e9 <cmos_read>
80103146:	83 c4 04             	add    $0x4,%esp
80103149:	89 c2                	mov    %eax,%edx
8010314b:	8b 45 08             	mov    0x8(%ebp),%eax
8010314e:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
80103151:	6a 07                	push   $0x7
80103153:	e8 91 ff ff ff       	call   801030e9 <cmos_read>
80103158:	83 c4 04             	add    $0x4,%esp
8010315b:	89 c2                	mov    %eax,%edx
8010315d:	8b 45 08             	mov    0x8(%ebp),%eax
80103160:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
80103163:	6a 08                	push   $0x8
80103165:	e8 7f ff ff ff       	call   801030e9 <cmos_read>
8010316a:	83 c4 04             	add    $0x4,%esp
8010316d:	89 c2                	mov    %eax,%edx
8010316f:	8b 45 08             	mov    0x8(%ebp),%eax
80103172:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
80103175:	6a 09                	push   $0x9
80103177:	e8 6d ff ff ff       	call   801030e9 <cmos_read>
8010317c:	83 c4 04             	add    $0x4,%esp
8010317f:	89 c2                	mov    %eax,%edx
80103181:	8b 45 08             	mov    0x8(%ebp),%eax
80103184:	89 50 14             	mov    %edx,0x14(%eax)
}
80103187:	90                   	nop
80103188:	c9                   	leave  
80103189:	c3                   	ret    

8010318a <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
8010318a:	55                   	push   %ebp
8010318b:	89 e5                	mov    %esp,%ebp
8010318d:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103190:	6a 0b                	push   $0xb
80103192:	e8 52 ff ff ff       	call   801030e9 <cmos_read>
80103197:	83 c4 04             	add    $0x4,%esp
8010319a:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
8010319d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031a0:	83 e0 04             	and    $0x4,%eax
801031a3:	85 c0                	test   %eax,%eax
801031a5:	0f 94 c0             	sete   %al
801031a8:	0f b6 c0             	movzbl %al,%eax
801031ab:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
801031ae:	8d 45 d8             	lea    -0x28(%ebp),%eax
801031b1:	50                   	push   %eax
801031b2:	e8 62 ff ff ff       	call   80103119 <fill_rtcdate>
801031b7:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
801031ba:	6a 0a                	push   $0xa
801031bc:	e8 28 ff ff ff       	call   801030e9 <cmos_read>
801031c1:	83 c4 04             	add    $0x4,%esp
801031c4:	25 80 00 00 00       	and    $0x80,%eax
801031c9:	85 c0                	test   %eax,%eax
801031cb:	75 27                	jne    801031f4 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
801031cd:	8d 45 c0             	lea    -0x40(%ebp),%eax
801031d0:	50                   	push   %eax
801031d1:	e8 43 ff ff ff       	call   80103119 <fill_rtcdate>
801031d6:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
801031d9:	83 ec 04             	sub    $0x4,%esp
801031dc:	6a 18                	push   $0x18
801031de:	8d 45 c0             	lea    -0x40(%ebp),%eax
801031e1:	50                   	push   %eax
801031e2:	8d 45 d8             	lea    -0x28(%ebp),%eax
801031e5:	50                   	push   %eax
801031e6:	e8 75 20 00 00       	call   80105260 <memcmp>
801031eb:	83 c4 10             	add    $0x10,%esp
801031ee:	85 c0                	test   %eax,%eax
801031f0:	74 05                	je     801031f7 <cmostime+0x6d>
801031f2:	eb ba                	jmp    801031ae <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
801031f4:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801031f5:	eb b7                	jmp    801031ae <cmostime+0x24>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
801031f7:	90                   	nop
  }

  // convert
  if (bcd) {
801031f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801031fc:	0f 84 b4 00 00 00    	je     801032b6 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103202:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103205:	c1 e8 04             	shr    $0x4,%eax
80103208:	89 c2                	mov    %eax,%edx
8010320a:	89 d0                	mov    %edx,%eax
8010320c:	c1 e0 02             	shl    $0x2,%eax
8010320f:	01 d0                	add    %edx,%eax
80103211:	01 c0                	add    %eax,%eax
80103213:	89 c2                	mov    %eax,%edx
80103215:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103218:	83 e0 0f             	and    $0xf,%eax
8010321b:	01 d0                	add    %edx,%eax
8010321d:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103220:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103223:	c1 e8 04             	shr    $0x4,%eax
80103226:	89 c2                	mov    %eax,%edx
80103228:	89 d0                	mov    %edx,%eax
8010322a:	c1 e0 02             	shl    $0x2,%eax
8010322d:	01 d0                	add    %edx,%eax
8010322f:	01 c0                	add    %eax,%eax
80103231:	89 c2                	mov    %eax,%edx
80103233:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103236:	83 e0 0f             	and    $0xf,%eax
80103239:	01 d0                	add    %edx,%eax
8010323b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
8010323e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103241:	c1 e8 04             	shr    $0x4,%eax
80103244:	89 c2                	mov    %eax,%edx
80103246:	89 d0                	mov    %edx,%eax
80103248:	c1 e0 02             	shl    $0x2,%eax
8010324b:	01 d0                	add    %edx,%eax
8010324d:	01 c0                	add    %eax,%eax
8010324f:	89 c2                	mov    %eax,%edx
80103251:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103254:	83 e0 0f             	and    $0xf,%eax
80103257:	01 d0                	add    %edx,%eax
80103259:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
8010325c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010325f:	c1 e8 04             	shr    $0x4,%eax
80103262:	89 c2                	mov    %eax,%edx
80103264:	89 d0                	mov    %edx,%eax
80103266:	c1 e0 02             	shl    $0x2,%eax
80103269:	01 d0                	add    %edx,%eax
8010326b:	01 c0                	add    %eax,%eax
8010326d:	89 c2                	mov    %eax,%edx
8010326f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103272:	83 e0 0f             	and    $0xf,%eax
80103275:	01 d0                	add    %edx,%eax
80103277:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
8010327a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010327d:	c1 e8 04             	shr    $0x4,%eax
80103280:	89 c2                	mov    %eax,%edx
80103282:	89 d0                	mov    %edx,%eax
80103284:	c1 e0 02             	shl    $0x2,%eax
80103287:	01 d0                	add    %edx,%eax
80103289:	01 c0                	add    %eax,%eax
8010328b:	89 c2                	mov    %eax,%edx
8010328d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103290:	83 e0 0f             	and    $0xf,%eax
80103293:	01 d0                	add    %edx,%eax
80103295:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103298:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010329b:	c1 e8 04             	shr    $0x4,%eax
8010329e:	89 c2                	mov    %eax,%edx
801032a0:	89 d0                	mov    %edx,%eax
801032a2:	c1 e0 02             	shl    $0x2,%eax
801032a5:	01 d0                	add    %edx,%eax
801032a7:	01 c0                	add    %eax,%eax
801032a9:	89 c2                	mov    %eax,%edx
801032ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032ae:	83 e0 0f             	and    $0xf,%eax
801032b1:	01 d0                	add    %edx,%eax
801032b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
801032b6:	8b 45 08             	mov    0x8(%ebp),%eax
801032b9:	8b 55 d8             	mov    -0x28(%ebp),%edx
801032bc:	89 10                	mov    %edx,(%eax)
801032be:	8b 55 dc             	mov    -0x24(%ebp),%edx
801032c1:	89 50 04             	mov    %edx,0x4(%eax)
801032c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
801032c7:	89 50 08             	mov    %edx,0x8(%eax)
801032ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801032cd:	89 50 0c             	mov    %edx,0xc(%eax)
801032d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
801032d3:	89 50 10             	mov    %edx,0x10(%eax)
801032d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801032d9:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
801032dc:	8b 45 08             	mov    0x8(%ebp),%eax
801032df:	8b 40 14             	mov    0x14(%eax),%eax
801032e2:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801032e8:	8b 45 08             	mov    0x8(%ebp),%eax
801032eb:	89 50 14             	mov    %edx,0x14(%eax)
}
801032ee:	90                   	nop
801032ef:	c9                   	leave  
801032f0:	c3                   	ret    

801032f1 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801032f1:	55                   	push   %ebp
801032f2:	89 e5                	mov    %esp,%ebp
801032f4:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801032f7:	83 ec 08             	sub    $0x8,%esp
801032fa:	68 34 88 10 80       	push   $0x80108834
801032ff:	68 60 22 11 80       	push   $0x80112260
80103304:	e8 6b 1c 00 00       	call   80104f74 <initlock>
80103309:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
8010330c:	83 ec 08             	sub    $0x8,%esp
8010330f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103312:	50                   	push   %eax
80103313:	ff 75 08             	pushl  0x8(%ebp)
80103316:	e8 75 e0 ff ff       	call   80101390 <readsb>
8010331b:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
8010331e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103321:	a3 94 22 11 80       	mov    %eax,0x80112294
  log.size = sb.nlog;
80103326:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103329:	a3 98 22 11 80       	mov    %eax,0x80112298
  log.dev = dev;
8010332e:	8b 45 08             	mov    0x8(%ebp),%eax
80103331:	a3 a4 22 11 80       	mov    %eax,0x801122a4
  recover_from_log();
80103336:	e8 b2 01 00 00       	call   801034ed <recover_from_log>
}
8010333b:	90                   	nop
8010333c:	c9                   	leave  
8010333d:	c3                   	ret    

8010333e <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
8010333e:	55                   	push   %ebp
8010333f:	89 e5                	mov    %esp,%ebp
80103341:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103344:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010334b:	e9 95 00 00 00       	jmp    801033e5 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103350:	8b 15 94 22 11 80    	mov    0x80112294,%edx
80103356:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103359:	01 d0                	add    %edx,%eax
8010335b:	83 c0 01             	add    $0x1,%eax
8010335e:	89 c2                	mov    %eax,%edx
80103360:	a1 a4 22 11 80       	mov    0x801122a4,%eax
80103365:	83 ec 08             	sub    $0x8,%esp
80103368:	52                   	push   %edx
80103369:	50                   	push   %eax
8010336a:	e8 47 ce ff ff       	call   801001b6 <bread>
8010336f:	83 c4 10             	add    $0x10,%esp
80103372:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103375:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103378:	83 c0 10             	add    $0x10,%eax
8010337b:	8b 04 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%eax
80103382:	89 c2                	mov    %eax,%edx
80103384:	a1 a4 22 11 80       	mov    0x801122a4,%eax
80103389:	83 ec 08             	sub    $0x8,%esp
8010338c:	52                   	push   %edx
8010338d:	50                   	push   %eax
8010338e:	e8 23 ce ff ff       	call   801001b6 <bread>
80103393:	83 c4 10             	add    $0x10,%esp
80103396:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103399:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010339c:	8d 50 18             	lea    0x18(%eax),%edx
8010339f:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033a2:	83 c0 18             	add    $0x18,%eax
801033a5:	83 ec 04             	sub    $0x4,%esp
801033a8:	68 00 02 00 00       	push   $0x200
801033ad:	52                   	push   %edx
801033ae:	50                   	push   %eax
801033af:	e8 04 1f 00 00       	call   801052b8 <memmove>
801033b4:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
801033b7:	83 ec 0c             	sub    $0xc,%esp
801033ba:	ff 75 ec             	pushl  -0x14(%ebp)
801033bd:	e8 2d ce ff ff       	call   801001ef <bwrite>
801033c2:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
801033c5:	83 ec 0c             	sub    $0xc,%esp
801033c8:	ff 75 f0             	pushl  -0x10(%ebp)
801033cb:	e8 5e ce ff ff       	call   8010022e <brelse>
801033d0:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
801033d3:	83 ec 0c             	sub    $0xc,%esp
801033d6:	ff 75 ec             	pushl  -0x14(%ebp)
801033d9:	e8 50 ce ff ff       	call   8010022e <brelse>
801033de:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801033e1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033e5:	a1 a8 22 11 80       	mov    0x801122a8,%eax
801033ea:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033ed:	0f 8f 5d ff ff ff    	jg     80103350 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
801033f3:	90                   	nop
801033f4:	c9                   	leave  
801033f5:	c3                   	ret    

801033f6 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801033f6:	55                   	push   %ebp
801033f7:	89 e5                	mov    %esp,%ebp
801033f9:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801033fc:	a1 94 22 11 80       	mov    0x80112294,%eax
80103401:	89 c2                	mov    %eax,%edx
80103403:	a1 a4 22 11 80       	mov    0x801122a4,%eax
80103408:	83 ec 08             	sub    $0x8,%esp
8010340b:	52                   	push   %edx
8010340c:	50                   	push   %eax
8010340d:	e8 a4 cd ff ff       	call   801001b6 <bread>
80103412:	83 c4 10             	add    $0x10,%esp
80103415:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103418:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010341b:	83 c0 18             	add    $0x18,%eax
8010341e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103421:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103424:	8b 00                	mov    (%eax),%eax
80103426:	a3 a8 22 11 80       	mov    %eax,0x801122a8
  for (i = 0; i < log.lh.n; i++) {
8010342b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103432:	eb 1b                	jmp    8010344f <read_head+0x59>
    log.lh.block[i] = lh->block[i];
80103434:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103437:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010343a:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
8010343e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103441:	83 c2 10             	add    $0x10,%edx
80103444:	89 04 95 6c 22 11 80 	mov    %eax,-0x7feedd94(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010344b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010344f:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103454:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103457:	7f db                	jg     80103434 <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80103459:	83 ec 0c             	sub    $0xc,%esp
8010345c:	ff 75 f0             	pushl  -0x10(%ebp)
8010345f:	e8 ca cd ff ff       	call   8010022e <brelse>
80103464:	83 c4 10             	add    $0x10,%esp
}
80103467:	90                   	nop
80103468:	c9                   	leave  
80103469:	c3                   	ret    

8010346a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010346a:	55                   	push   %ebp
8010346b:	89 e5                	mov    %esp,%ebp
8010346d:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103470:	a1 94 22 11 80       	mov    0x80112294,%eax
80103475:	89 c2                	mov    %eax,%edx
80103477:	a1 a4 22 11 80       	mov    0x801122a4,%eax
8010347c:	83 ec 08             	sub    $0x8,%esp
8010347f:	52                   	push   %edx
80103480:	50                   	push   %eax
80103481:	e8 30 cd ff ff       	call   801001b6 <bread>
80103486:	83 c4 10             	add    $0x10,%esp
80103489:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
8010348c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010348f:	83 c0 18             	add    $0x18,%eax
80103492:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103495:	8b 15 a8 22 11 80    	mov    0x801122a8,%edx
8010349b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010349e:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801034a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801034a7:	eb 1b                	jmp    801034c4 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
801034a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034ac:	83 c0 10             	add    $0x10,%eax
801034af:	8b 0c 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%ecx
801034b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801034bc:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801034c0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801034c4:	a1 a8 22 11 80       	mov    0x801122a8,%eax
801034c9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034cc:	7f db                	jg     801034a9 <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
801034ce:	83 ec 0c             	sub    $0xc,%esp
801034d1:	ff 75 f0             	pushl  -0x10(%ebp)
801034d4:	e8 16 cd ff ff       	call   801001ef <bwrite>
801034d9:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
801034dc:	83 ec 0c             	sub    $0xc,%esp
801034df:	ff 75 f0             	pushl  -0x10(%ebp)
801034e2:	e8 47 cd ff ff       	call   8010022e <brelse>
801034e7:	83 c4 10             	add    $0x10,%esp
}
801034ea:	90                   	nop
801034eb:	c9                   	leave  
801034ec:	c3                   	ret    

801034ed <recover_from_log>:

static void
recover_from_log(void)
{
801034ed:	55                   	push   %ebp
801034ee:	89 e5                	mov    %esp,%ebp
801034f0:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801034f3:	e8 fe fe ff ff       	call   801033f6 <read_head>
  install_trans(); // if committed, copy from log to disk
801034f8:	e8 41 fe ff ff       	call   8010333e <install_trans>
  log.lh.n = 0;
801034fd:	c7 05 a8 22 11 80 00 	movl   $0x0,0x801122a8
80103504:	00 00 00 
  write_head(); // clear the log
80103507:	e8 5e ff ff ff       	call   8010346a <write_head>
}
8010350c:	90                   	nop
8010350d:	c9                   	leave  
8010350e:	c3                   	ret    

8010350f <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
8010350f:	55                   	push   %ebp
80103510:	89 e5                	mov    %esp,%ebp
80103512:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
80103515:	83 ec 0c             	sub    $0xc,%esp
80103518:	68 60 22 11 80       	push   $0x80112260
8010351d:	e8 74 1a 00 00       	call   80104f96 <acquire>
80103522:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103525:	a1 a0 22 11 80       	mov    0x801122a0,%eax
8010352a:	85 c0                	test   %eax,%eax
8010352c:	74 17                	je     80103545 <begin_op+0x36>
      sleep(&log, &log.lock);
8010352e:	83 ec 08             	sub    $0x8,%esp
80103531:	68 60 22 11 80       	push   $0x80112260
80103536:	68 60 22 11 80       	push   $0x80112260
8010353b:	e8 5d 17 00 00       	call   80104c9d <sleep>
80103540:	83 c4 10             	add    $0x10,%esp
80103543:	eb e0                	jmp    80103525 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103545:	8b 0d a8 22 11 80    	mov    0x801122a8,%ecx
8010354b:	a1 9c 22 11 80       	mov    0x8011229c,%eax
80103550:	8d 50 01             	lea    0x1(%eax),%edx
80103553:	89 d0                	mov    %edx,%eax
80103555:	c1 e0 02             	shl    $0x2,%eax
80103558:	01 d0                	add    %edx,%eax
8010355a:	01 c0                	add    %eax,%eax
8010355c:	01 c8                	add    %ecx,%eax
8010355e:	83 f8 1e             	cmp    $0x1e,%eax
80103561:	7e 17                	jle    8010357a <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103563:	83 ec 08             	sub    $0x8,%esp
80103566:	68 60 22 11 80       	push   $0x80112260
8010356b:	68 60 22 11 80       	push   $0x80112260
80103570:	e8 28 17 00 00       	call   80104c9d <sleep>
80103575:	83 c4 10             	add    $0x10,%esp
80103578:	eb ab                	jmp    80103525 <begin_op+0x16>
    } else {
      log.outstanding += 1;
8010357a:	a1 9c 22 11 80       	mov    0x8011229c,%eax
8010357f:	83 c0 01             	add    $0x1,%eax
80103582:	a3 9c 22 11 80       	mov    %eax,0x8011229c
      release(&log.lock);
80103587:	83 ec 0c             	sub    $0xc,%esp
8010358a:	68 60 22 11 80       	push   $0x80112260
8010358f:	e8 69 1a 00 00       	call   80104ffd <release>
80103594:	83 c4 10             	add    $0x10,%esp
      break;
80103597:	90                   	nop
    }
  }
}
80103598:	90                   	nop
80103599:	c9                   	leave  
8010359a:	c3                   	ret    

8010359b <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
8010359b:	55                   	push   %ebp
8010359c:	89 e5                	mov    %esp,%ebp
8010359e:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
801035a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801035a8:	83 ec 0c             	sub    $0xc,%esp
801035ab:	68 60 22 11 80       	push   $0x80112260
801035b0:	e8 e1 19 00 00       	call   80104f96 <acquire>
801035b5:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801035b8:	a1 9c 22 11 80       	mov    0x8011229c,%eax
801035bd:	83 e8 01             	sub    $0x1,%eax
801035c0:	a3 9c 22 11 80       	mov    %eax,0x8011229c
  if(log.committing)
801035c5:	a1 a0 22 11 80       	mov    0x801122a0,%eax
801035ca:	85 c0                	test   %eax,%eax
801035cc:	74 0d                	je     801035db <end_op+0x40>
    panic("log.committing");
801035ce:	83 ec 0c             	sub    $0xc,%esp
801035d1:	68 38 88 10 80       	push   $0x80108838
801035d6:	e8 8b cf ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
801035db:	a1 9c 22 11 80       	mov    0x8011229c,%eax
801035e0:	85 c0                	test   %eax,%eax
801035e2:	75 13                	jne    801035f7 <end_op+0x5c>
    do_commit = 1;
801035e4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801035eb:	c7 05 a0 22 11 80 01 	movl   $0x1,0x801122a0
801035f2:	00 00 00 
801035f5:	eb 10                	jmp    80103607 <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
801035f7:	83 ec 0c             	sub    $0xc,%esp
801035fa:	68 60 22 11 80       	push   $0x80112260
801035ff:	e8 84 17 00 00       	call   80104d88 <wakeup>
80103604:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103607:	83 ec 0c             	sub    $0xc,%esp
8010360a:	68 60 22 11 80       	push   $0x80112260
8010360f:	e8 e9 19 00 00       	call   80104ffd <release>
80103614:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
80103617:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010361b:	74 3f                	je     8010365c <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
8010361d:	e8 f5 00 00 00       	call   80103717 <commit>
    acquire(&log.lock);
80103622:	83 ec 0c             	sub    $0xc,%esp
80103625:	68 60 22 11 80       	push   $0x80112260
8010362a:	e8 67 19 00 00       	call   80104f96 <acquire>
8010362f:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103632:	c7 05 a0 22 11 80 00 	movl   $0x0,0x801122a0
80103639:	00 00 00 
    wakeup(&log);
8010363c:	83 ec 0c             	sub    $0xc,%esp
8010363f:	68 60 22 11 80       	push   $0x80112260
80103644:	e8 3f 17 00 00       	call   80104d88 <wakeup>
80103649:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
8010364c:	83 ec 0c             	sub    $0xc,%esp
8010364f:	68 60 22 11 80       	push   $0x80112260
80103654:	e8 a4 19 00 00       	call   80104ffd <release>
80103659:	83 c4 10             	add    $0x10,%esp
  }
}
8010365c:	90                   	nop
8010365d:	c9                   	leave  
8010365e:	c3                   	ret    

8010365f <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
8010365f:	55                   	push   %ebp
80103660:	89 e5                	mov    %esp,%ebp
80103662:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103665:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010366c:	e9 95 00 00 00       	jmp    80103706 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103671:	8b 15 94 22 11 80    	mov    0x80112294,%edx
80103677:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010367a:	01 d0                	add    %edx,%eax
8010367c:	83 c0 01             	add    $0x1,%eax
8010367f:	89 c2                	mov    %eax,%edx
80103681:	a1 a4 22 11 80       	mov    0x801122a4,%eax
80103686:	83 ec 08             	sub    $0x8,%esp
80103689:	52                   	push   %edx
8010368a:	50                   	push   %eax
8010368b:	e8 26 cb ff ff       	call   801001b6 <bread>
80103690:	83 c4 10             	add    $0x10,%esp
80103693:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103696:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103699:	83 c0 10             	add    $0x10,%eax
8010369c:	8b 04 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%eax
801036a3:	89 c2                	mov    %eax,%edx
801036a5:	a1 a4 22 11 80       	mov    0x801122a4,%eax
801036aa:	83 ec 08             	sub    $0x8,%esp
801036ad:	52                   	push   %edx
801036ae:	50                   	push   %eax
801036af:	e8 02 cb ff ff       	call   801001b6 <bread>
801036b4:	83 c4 10             	add    $0x10,%esp
801036b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801036ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036bd:	8d 50 18             	lea    0x18(%eax),%edx
801036c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036c3:	83 c0 18             	add    $0x18,%eax
801036c6:	83 ec 04             	sub    $0x4,%esp
801036c9:	68 00 02 00 00       	push   $0x200
801036ce:	52                   	push   %edx
801036cf:	50                   	push   %eax
801036d0:	e8 e3 1b 00 00       	call   801052b8 <memmove>
801036d5:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
801036d8:	83 ec 0c             	sub    $0xc,%esp
801036db:	ff 75 f0             	pushl  -0x10(%ebp)
801036de:	e8 0c cb ff ff       	call   801001ef <bwrite>
801036e3:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
801036e6:	83 ec 0c             	sub    $0xc,%esp
801036e9:	ff 75 ec             	pushl  -0x14(%ebp)
801036ec:	e8 3d cb ff ff       	call   8010022e <brelse>
801036f1:	83 c4 10             	add    $0x10,%esp
    brelse(to);
801036f4:	83 ec 0c             	sub    $0xc,%esp
801036f7:	ff 75 f0             	pushl  -0x10(%ebp)
801036fa:	e8 2f cb ff ff       	call   8010022e <brelse>
801036ff:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103702:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103706:	a1 a8 22 11 80       	mov    0x801122a8,%eax
8010370b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010370e:	0f 8f 5d ff ff ff    	jg     80103671 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
80103714:	90                   	nop
80103715:	c9                   	leave  
80103716:	c3                   	ret    

80103717 <commit>:

static void
commit()
{
80103717:	55                   	push   %ebp
80103718:	89 e5                	mov    %esp,%ebp
8010371a:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
8010371d:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103722:	85 c0                	test   %eax,%eax
80103724:	7e 1e                	jle    80103744 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103726:	e8 34 ff ff ff       	call   8010365f <write_log>
    write_head();    // Write header to disk -- the real commit
8010372b:	e8 3a fd ff ff       	call   8010346a <write_head>
    install_trans(); // Now install writes to home locations
80103730:	e8 09 fc ff ff       	call   8010333e <install_trans>
    log.lh.n = 0; 
80103735:	c7 05 a8 22 11 80 00 	movl   $0x0,0x801122a8
8010373c:	00 00 00 
    write_head();    // Erase the transaction from the log
8010373f:	e8 26 fd ff ff       	call   8010346a <write_head>
  }
}
80103744:	90                   	nop
80103745:	c9                   	leave  
80103746:	c3                   	ret    

80103747 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103747:	55                   	push   %ebp
80103748:	89 e5                	mov    %esp,%ebp
8010374a:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010374d:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103752:	83 f8 1d             	cmp    $0x1d,%eax
80103755:	7f 12                	jg     80103769 <log_write+0x22>
80103757:	a1 a8 22 11 80       	mov    0x801122a8,%eax
8010375c:	8b 15 98 22 11 80    	mov    0x80112298,%edx
80103762:	83 ea 01             	sub    $0x1,%edx
80103765:	39 d0                	cmp    %edx,%eax
80103767:	7c 0d                	jl     80103776 <log_write+0x2f>
    panic("too big a transaction");
80103769:	83 ec 0c             	sub    $0xc,%esp
8010376c:	68 47 88 10 80       	push   $0x80108847
80103771:	e8 f0 cd ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
80103776:	a1 9c 22 11 80       	mov    0x8011229c,%eax
8010377b:	85 c0                	test   %eax,%eax
8010377d:	7f 0d                	jg     8010378c <log_write+0x45>
    panic("log_write outside of trans");
8010377f:	83 ec 0c             	sub    $0xc,%esp
80103782:	68 5d 88 10 80       	push   $0x8010885d
80103787:	e8 da cd ff ff       	call   80100566 <panic>

  acquire(&log.lock);
8010378c:	83 ec 0c             	sub    $0xc,%esp
8010378f:	68 60 22 11 80       	push   $0x80112260
80103794:	e8 fd 17 00 00       	call   80104f96 <acquire>
80103799:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
8010379c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801037a3:	eb 1d                	jmp    801037c2 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801037a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037a8:	83 c0 10             	add    $0x10,%eax
801037ab:	8b 04 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%eax
801037b2:	89 c2                	mov    %eax,%edx
801037b4:	8b 45 08             	mov    0x8(%ebp),%eax
801037b7:	8b 40 08             	mov    0x8(%eax),%eax
801037ba:	39 c2                	cmp    %eax,%edx
801037bc:	74 10                	je     801037ce <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
801037be:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801037c2:	a1 a8 22 11 80       	mov    0x801122a8,%eax
801037c7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037ca:	7f d9                	jg     801037a5 <log_write+0x5e>
801037cc:	eb 01                	jmp    801037cf <log_write+0x88>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
801037ce:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
801037cf:	8b 45 08             	mov    0x8(%ebp),%eax
801037d2:	8b 40 08             	mov    0x8(%eax),%eax
801037d5:	89 c2                	mov    %eax,%edx
801037d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037da:	83 c0 10             	add    $0x10,%eax
801037dd:	89 14 85 6c 22 11 80 	mov    %edx,-0x7feedd94(,%eax,4)
  if (i == log.lh.n)
801037e4:	a1 a8 22 11 80       	mov    0x801122a8,%eax
801037e9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037ec:	75 0d                	jne    801037fb <log_write+0xb4>
    log.lh.n++;
801037ee:	a1 a8 22 11 80       	mov    0x801122a8,%eax
801037f3:	83 c0 01             	add    $0x1,%eax
801037f6:	a3 a8 22 11 80       	mov    %eax,0x801122a8
  b->flags |= B_DIRTY; // prevent eviction
801037fb:	8b 45 08             	mov    0x8(%ebp),%eax
801037fe:	8b 00                	mov    (%eax),%eax
80103800:	83 c8 04             	or     $0x4,%eax
80103803:	89 c2                	mov    %eax,%edx
80103805:	8b 45 08             	mov    0x8(%ebp),%eax
80103808:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
8010380a:	83 ec 0c             	sub    $0xc,%esp
8010380d:	68 60 22 11 80       	push   $0x80112260
80103812:	e8 e6 17 00 00       	call   80104ffd <release>
80103817:	83 c4 10             	add    $0x10,%esp
}
8010381a:	90                   	nop
8010381b:	c9                   	leave  
8010381c:	c3                   	ret    

8010381d <v2p>:
8010381d:	55                   	push   %ebp
8010381e:	89 e5                	mov    %esp,%ebp
80103820:	8b 45 08             	mov    0x8(%ebp),%eax
80103823:	05 00 00 00 80       	add    $0x80000000,%eax
80103828:	5d                   	pop    %ebp
80103829:	c3                   	ret    

8010382a <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
8010382a:	55                   	push   %ebp
8010382b:	89 e5                	mov    %esp,%ebp
8010382d:	8b 45 08             	mov    0x8(%ebp),%eax
80103830:	05 00 00 00 80       	add    $0x80000000,%eax
80103835:	5d                   	pop    %ebp
80103836:	c3                   	ret    

80103837 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103837:	55                   	push   %ebp
80103838:	89 e5                	mov    %esp,%ebp
8010383a:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010383d:	8b 55 08             	mov    0x8(%ebp),%edx
80103840:	8b 45 0c             	mov    0xc(%ebp),%eax
80103843:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103846:	f0 87 02             	lock xchg %eax,(%edx)
80103849:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010384c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010384f:	c9                   	leave  
80103850:	c3                   	ret    

80103851 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103851:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103855:	83 e4 f0             	and    $0xfffffff0,%esp
80103858:	ff 71 fc             	pushl  -0x4(%ecx)
8010385b:	55                   	push   %ebp
8010385c:	89 e5                	mov    %esp,%ebp
8010385e:	51                   	push   %ecx
8010385f:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103862:	83 ec 08             	sub    $0x8,%esp
80103865:	68 00 00 40 80       	push   $0x80400000
8010386a:	68 3c 52 11 80       	push   $0x8011523c
8010386f:	e8 7d f2 ff ff       	call   80102af1 <kinit1>
80103874:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103877:	e8 30 45 00 00       	call   80107dac <kvmalloc>
  mpinit();        // collect info about this machine
8010387c:	e8 09 04 00 00       	call   80103c8a <mpinit>
  lapicinit();
80103881:	e8 ea f5 ff ff       	call   80102e70 <lapicinit>
  seginit();       // set up segments
80103886:	e8 ca 3e 00 00       	call   80107755 <seginit>
  picinit();       // interrupt controller
8010388b:	e8 50 06 00 00       	call   80103ee0 <picinit>
  ioapicinit();    // another interrupt controller
80103890:	e8 51 f1 ff ff       	call   801029e6 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103895:	e8 7f d2 ff ff       	call   80100b19 <consoleinit>
  uartinit();      // serial port
8010389a:	e8 3e 32 00 00       	call   80106add <uartinit>
  pinit();         // process table
8010389f:	e8 39 0b 00 00       	call   801043dd <pinit>
  tvinit();        // trap vectors
801038a4:	e8 8b 2d 00 00       	call   80106634 <tvinit>
  binit();         // buffer cache
801038a9:	e8 86 c7 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801038ae:	e8 ce d6 ff ff       	call   80100f81 <fileinit>
  ideinit();       // disk
801038b3:	e8 36 ed ff ff       	call   801025ee <ideinit>
  if(!ismp)
801038b8:	a1 44 23 11 80       	mov    0x80112344,%eax
801038bd:	85 c0                	test   %eax,%eax
801038bf:	75 05                	jne    801038c6 <main+0x75>
    timerinit();   // uniprocessor timer
801038c1:	e8 cb 2c 00 00       	call   80106591 <timerinit>
  startothers();   // start other processors
801038c6:	e8 62 00 00 00       	call   8010392d <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801038cb:	83 ec 08             	sub    $0x8,%esp
801038ce:	68 00 00 00 8e       	push   $0x8e000000
801038d3:	68 00 00 40 80       	push   $0x80400000
801038d8:	e8 4d f2 ff ff       	call   80102b2a <kinit2>
801038dd:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
801038e0:	e8 1c 0c 00 00       	call   80104501 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801038e5:	e8 1a 00 00 00       	call   80103904 <mpmain>

801038ea <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801038ea:	55                   	push   %ebp
801038eb:	89 e5                	mov    %esp,%ebp
801038ed:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
801038f0:	e8 cf 44 00 00       	call   80107dc4 <switchkvm>
  seginit();
801038f5:	e8 5b 3e 00 00       	call   80107755 <seginit>
  lapicinit();
801038fa:	e8 71 f5 ff ff       	call   80102e70 <lapicinit>
  mpmain();
801038ff:	e8 00 00 00 00       	call   80103904 <mpmain>

80103904 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103904:	55                   	push   %ebp
80103905:	89 e5                	mov    %esp,%ebp
80103907:	83 ec 08             	sub    $0x8,%esp
  idtinit();       // load idt register
8010390a:	e8 9b 2e 00 00       	call   801067aa <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
8010390f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103915:	05 a8 00 00 00       	add    $0xa8,%eax
8010391a:	83 ec 08             	sub    $0x8,%esp
8010391d:	6a 01                	push   $0x1
8010391f:	50                   	push   %eax
80103920:	e8 12 ff ff ff       	call   80103837 <xchg>
80103925:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103928:	e8 8e 11 00 00       	call   80104abb <scheduler>

8010392d <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
8010392d:	55                   	push   %ebp
8010392e:	89 e5                	mov    %esp,%ebp
80103930:	53                   	push   %ebx
80103931:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103934:	68 00 70 00 00       	push   $0x7000
80103939:	e8 ec fe ff ff       	call   8010382a <p2v>
8010393e:	83 c4 04             	add    $0x4,%esp
80103941:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103944:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103949:	83 ec 04             	sub    $0x4,%esp
8010394c:	50                   	push   %eax
8010394d:	68 0c b5 10 80       	push   $0x8010b50c
80103952:	ff 75 f0             	pushl  -0x10(%ebp)
80103955:	e8 5e 19 00 00       	call   801052b8 <memmove>
8010395a:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
8010395d:	c7 45 f4 60 23 11 80 	movl   $0x80112360,-0xc(%ebp)
80103964:	e9 90 00 00 00       	jmp    801039f9 <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103969:	e8 20 f6 ff ff       	call   80102f8e <cpunum>
8010396e:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103974:	05 60 23 11 80       	add    $0x80112360,%eax
80103979:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010397c:	74 73                	je     801039f1 <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010397e:	e8 a5 f2 ff ff       	call   80102c28 <kalloc>
80103983:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103986:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103989:	83 e8 04             	sub    $0x4,%eax
8010398c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010398f:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103995:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103997:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010399a:	83 e8 08             	sub    $0x8,%eax
8010399d:	c7 00 ea 38 10 80    	movl   $0x801038ea,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
801039a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039a6:	8d 58 f4             	lea    -0xc(%eax),%ebx
801039a9:	83 ec 0c             	sub    $0xc,%esp
801039ac:	68 00 a0 10 80       	push   $0x8010a000
801039b1:	e8 67 fe ff ff       	call   8010381d <v2p>
801039b6:	83 c4 10             	add    $0x10,%esp
801039b9:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
801039bb:	83 ec 0c             	sub    $0xc,%esp
801039be:	ff 75 f0             	pushl  -0x10(%ebp)
801039c1:	e8 57 fe ff ff       	call   8010381d <v2p>
801039c6:	83 c4 10             	add    $0x10,%esp
801039c9:	89 c2                	mov    %eax,%edx
801039cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039ce:	0f b6 00             	movzbl (%eax),%eax
801039d1:	0f b6 c0             	movzbl %al,%eax
801039d4:	83 ec 08             	sub    $0x8,%esp
801039d7:	52                   	push   %edx
801039d8:	50                   	push   %eax
801039d9:	e8 2a f6 ff ff       	call   80103008 <lapicstartap>
801039de:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801039e1:	90                   	nop
801039e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039e5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801039eb:	85 c0                	test   %eax,%eax
801039ed:	74 f3                	je     801039e2 <startothers+0xb5>
801039ef:	eb 01                	jmp    801039f2 <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
801039f1:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801039f2:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
801039f9:	a1 40 29 11 80       	mov    0x80112940,%eax
801039fe:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a04:	05 60 23 11 80       	add    $0x80112360,%eax
80103a09:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a0c:	0f 87 57 ff ff ff    	ja     80103969 <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103a12:	90                   	nop
80103a13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a16:	c9                   	leave  
80103a17:	c3                   	ret    

80103a18 <p2v>:
80103a18:	55                   	push   %ebp
80103a19:	89 e5                	mov    %esp,%ebp
80103a1b:	8b 45 08             	mov    0x8(%ebp),%eax
80103a1e:	05 00 00 00 80       	add    $0x80000000,%eax
80103a23:	5d                   	pop    %ebp
80103a24:	c3                   	ret    

80103a25 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103a25:	55                   	push   %ebp
80103a26:	89 e5                	mov    %esp,%ebp
80103a28:	83 ec 14             	sub    $0x14,%esp
80103a2b:	8b 45 08             	mov    0x8(%ebp),%eax
80103a2e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103a32:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103a36:	89 c2                	mov    %eax,%edx
80103a38:	ec                   	in     (%dx),%al
80103a39:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103a3c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103a40:	c9                   	leave  
80103a41:	c3                   	ret    

80103a42 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a42:	55                   	push   %ebp
80103a43:	89 e5                	mov    %esp,%ebp
80103a45:	83 ec 08             	sub    $0x8,%esp
80103a48:	8b 55 08             	mov    0x8(%ebp),%edx
80103a4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a4e:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a52:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a55:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a59:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a5d:	ee                   	out    %al,(%dx)
}
80103a5e:	90                   	nop
80103a5f:	c9                   	leave  
80103a60:	c3                   	ret    

80103a61 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103a61:	55                   	push   %ebp
80103a62:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103a64:	a1 44 b6 10 80       	mov    0x8010b644,%eax
80103a69:	89 c2                	mov    %eax,%edx
80103a6b:	b8 60 23 11 80       	mov    $0x80112360,%eax
80103a70:	29 c2                	sub    %eax,%edx
80103a72:	89 d0                	mov    %edx,%eax
80103a74:	c1 f8 02             	sar    $0x2,%eax
80103a77:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103a7d:	5d                   	pop    %ebp
80103a7e:	c3                   	ret    

80103a7f <sum>:

static uchar
sum(uchar *addr, int len)
{
80103a7f:	55                   	push   %ebp
80103a80:	89 e5                	mov    %esp,%ebp
80103a82:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103a85:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103a8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103a93:	eb 15                	jmp    80103aaa <sum+0x2b>
    sum += addr[i];
80103a95:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103a98:	8b 45 08             	mov    0x8(%ebp),%eax
80103a9b:	01 d0                	add    %edx,%eax
80103a9d:	0f b6 00             	movzbl (%eax),%eax
80103aa0:	0f b6 c0             	movzbl %al,%eax
80103aa3:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103aa6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103aaa:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103aad:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103ab0:	7c e3                	jl     80103a95 <sum+0x16>
    sum += addr[i];
  return sum;
80103ab2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103ab5:	c9                   	leave  
80103ab6:	c3                   	ret    

80103ab7 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103ab7:	55                   	push   %ebp
80103ab8:	89 e5                	mov    %esp,%ebp
80103aba:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103abd:	ff 75 08             	pushl  0x8(%ebp)
80103ac0:	e8 53 ff ff ff       	call   80103a18 <p2v>
80103ac5:	83 c4 04             	add    $0x4,%esp
80103ac8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103acb:	8b 55 0c             	mov    0xc(%ebp),%edx
80103ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ad1:	01 d0                	add    %edx,%eax
80103ad3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ad9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103adc:	eb 36                	jmp    80103b14 <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103ade:	83 ec 04             	sub    $0x4,%esp
80103ae1:	6a 04                	push   $0x4
80103ae3:	68 78 88 10 80       	push   $0x80108878
80103ae8:	ff 75 f4             	pushl  -0xc(%ebp)
80103aeb:	e8 70 17 00 00       	call   80105260 <memcmp>
80103af0:	83 c4 10             	add    $0x10,%esp
80103af3:	85 c0                	test   %eax,%eax
80103af5:	75 19                	jne    80103b10 <mpsearch1+0x59>
80103af7:	83 ec 08             	sub    $0x8,%esp
80103afa:	6a 10                	push   $0x10
80103afc:	ff 75 f4             	pushl  -0xc(%ebp)
80103aff:	e8 7b ff ff ff       	call   80103a7f <sum>
80103b04:	83 c4 10             	add    $0x10,%esp
80103b07:	84 c0                	test   %al,%al
80103b09:	75 05                	jne    80103b10 <mpsearch1+0x59>
      return (struct mp*)p;
80103b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b0e:	eb 11                	jmp    80103b21 <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103b10:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b17:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103b1a:	72 c2                	jb     80103ade <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103b1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103b21:	c9                   	leave  
80103b22:	c3                   	ret    

80103b23 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103b23:	55                   	push   %ebp
80103b24:	89 e5                	mov    %esp,%ebp
80103b26:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103b29:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b33:	83 c0 0f             	add    $0xf,%eax
80103b36:	0f b6 00             	movzbl (%eax),%eax
80103b39:	0f b6 c0             	movzbl %al,%eax
80103b3c:	c1 e0 08             	shl    $0x8,%eax
80103b3f:	89 c2                	mov    %eax,%edx
80103b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b44:	83 c0 0e             	add    $0xe,%eax
80103b47:	0f b6 00             	movzbl (%eax),%eax
80103b4a:	0f b6 c0             	movzbl %al,%eax
80103b4d:	09 d0                	or     %edx,%eax
80103b4f:	c1 e0 04             	shl    $0x4,%eax
80103b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103b55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103b59:	74 21                	je     80103b7c <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103b5b:	83 ec 08             	sub    $0x8,%esp
80103b5e:	68 00 04 00 00       	push   $0x400
80103b63:	ff 75 f0             	pushl  -0x10(%ebp)
80103b66:	e8 4c ff ff ff       	call   80103ab7 <mpsearch1>
80103b6b:	83 c4 10             	add    $0x10,%esp
80103b6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b71:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b75:	74 51                	je     80103bc8 <mpsearch+0xa5>
      return mp;
80103b77:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b7a:	eb 61                	jmp    80103bdd <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b7f:	83 c0 14             	add    $0x14,%eax
80103b82:	0f b6 00             	movzbl (%eax),%eax
80103b85:	0f b6 c0             	movzbl %al,%eax
80103b88:	c1 e0 08             	shl    $0x8,%eax
80103b8b:	89 c2                	mov    %eax,%edx
80103b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b90:	83 c0 13             	add    $0x13,%eax
80103b93:	0f b6 00             	movzbl (%eax),%eax
80103b96:	0f b6 c0             	movzbl %al,%eax
80103b99:	09 d0                	or     %edx,%eax
80103b9b:	c1 e0 0a             	shl    $0xa,%eax
80103b9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103ba1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ba4:	2d 00 04 00 00       	sub    $0x400,%eax
80103ba9:	83 ec 08             	sub    $0x8,%esp
80103bac:	68 00 04 00 00       	push   $0x400
80103bb1:	50                   	push   %eax
80103bb2:	e8 00 ff ff ff       	call   80103ab7 <mpsearch1>
80103bb7:	83 c4 10             	add    $0x10,%esp
80103bba:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103bbd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103bc1:	74 05                	je     80103bc8 <mpsearch+0xa5>
      return mp;
80103bc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103bc6:	eb 15                	jmp    80103bdd <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103bc8:	83 ec 08             	sub    $0x8,%esp
80103bcb:	68 00 00 01 00       	push   $0x10000
80103bd0:	68 00 00 0f 00       	push   $0xf0000
80103bd5:	e8 dd fe ff ff       	call   80103ab7 <mpsearch1>
80103bda:	83 c4 10             	add    $0x10,%esp
}
80103bdd:	c9                   	leave  
80103bde:	c3                   	ret    

80103bdf <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103bdf:	55                   	push   %ebp
80103be0:	89 e5                	mov    %esp,%ebp
80103be2:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103be5:	e8 39 ff ff ff       	call   80103b23 <mpsearch>
80103bea:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103bf1:	74 0a                	je     80103bfd <mpconfig+0x1e>
80103bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bf6:	8b 40 04             	mov    0x4(%eax),%eax
80103bf9:	85 c0                	test   %eax,%eax
80103bfb:	75 0a                	jne    80103c07 <mpconfig+0x28>
    return 0;
80103bfd:	b8 00 00 00 00       	mov    $0x0,%eax
80103c02:	e9 81 00 00 00       	jmp    80103c88 <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c0a:	8b 40 04             	mov    0x4(%eax),%eax
80103c0d:	83 ec 0c             	sub    $0xc,%esp
80103c10:	50                   	push   %eax
80103c11:	e8 02 fe ff ff       	call   80103a18 <p2v>
80103c16:	83 c4 10             	add    $0x10,%esp
80103c19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103c1c:	83 ec 04             	sub    $0x4,%esp
80103c1f:	6a 04                	push   $0x4
80103c21:	68 7d 88 10 80       	push   $0x8010887d
80103c26:	ff 75 f0             	pushl  -0x10(%ebp)
80103c29:	e8 32 16 00 00       	call   80105260 <memcmp>
80103c2e:	83 c4 10             	add    $0x10,%esp
80103c31:	85 c0                	test   %eax,%eax
80103c33:	74 07                	je     80103c3c <mpconfig+0x5d>
    return 0;
80103c35:	b8 00 00 00 00       	mov    $0x0,%eax
80103c3a:	eb 4c                	jmp    80103c88 <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c3f:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c43:	3c 01                	cmp    $0x1,%al
80103c45:	74 12                	je     80103c59 <mpconfig+0x7a>
80103c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c4a:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c4e:	3c 04                	cmp    $0x4,%al
80103c50:	74 07                	je     80103c59 <mpconfig+0x7a>
    return 0;
80103c52:	b8 00 00 00 00       	mov    $0x0,%eax
80103c57:	eb 2f                	jmp    80103c88 <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c5c:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c60:	0f b7 c0             	movzwl %ax,%eax
80103c63:	83 ec 08             	sub    $0x8,%esp
80103c66:	50                   	push   %eax
80103c67:	ff 75 f0             	pushl  -0x10(%ebp)
80103c6a:	e8 10 fe ff ff       	call   80103a7f <sum>
80103c6f:	83 c4 10             	add    $0x10,%esp
80103c72:	84 c0                	test   %al,%al
80103c74:	74 07                	je     80103c7d <mpconfig+0x9e>
    return 0;
80103c76:	b8 00 00 00 00       	mov    $0x0,%eax
80103c7b:	eb 0b                	jmp    80103c88 <mpconfig+0xa9>
  *pmp = mp;
80103c7d:	8b 45 08             	mov    0x8(%ebp),%eax
80103c80:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c83:	89 10                	mov    %edx,(%eax)
  return conf;
80103c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103c88:	c9                   	leave  
80103c89:	c3                   	ret    

80103c8a <mpinit>:

void
mpinit(void)
{
80103c8a:	55                   	push   %ebp
80103c8b:	89 e5                	mov    %esp,%ebp
80103c8d:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103c90:	c7 05 44 b6 10 80 60 	movl   $0x80112360,0x8010b644
80103c97:	23 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103c9a:	83 ec 0c             	sub    $0xc,%esp
80103c9d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103ca0:	50                   	push   %eax
80103ca1:	e8 39 ff ff ff       	call   80103bdf <mpconfig>
80103ca6:	83 c4 10             	add    $0x10,%esp
80103ca9:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103cac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103cb0:	0f 84 96 01 00 00    	je     80103e4c <mpinit+0x1c2>
    return;
  ismp = 1;
80103cb6:	c7 05 44 23 11 80 01 	movl   $0x1,0x80112344
80103cbd:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cc3:	8b 40 24             	mov    0x24(%eax),%eax
80103cc6:	a3 5c 22 11 80       	mov    %eax,0x8011225c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cce:	83 c0 2c             	add    $0x2c,%eax
80103cd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cd7:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103cdb:	0f b7 d0             	movzwl %ax,%edx
80103cde:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ce1:	01 d0                	add    %edx,%eax
80103ce3:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103ce6:	e9 f2 00 00 00       	jmp    80103ddd <mpinit+0x153>
    switch(*p){
80103ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cee:	0f b6 00             	movzbl (%eax),%eax
80103cf1:	0f b6 c0             	movzbl %al,%eax
80103cf4:	83 f8 04             	cmp    $0x4,%eax
80103cf7:	0f 87 bc 00 00 00    	ja     80103db9 <mpinit+0x12f>
80103cfd:	8b 04 85 c0 88 10 80 	mov    -0x7fef7740(,%eax,4),%eax
80103d04:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d09:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103d0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d0f:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d13:	0f b6 d0             	movzbl %al,%edx
80103d16:	a1 40 29 11 80       	mov    0x80112940,%eax
80103d1b:	39 c2                	cmp    %eax,%edx
80103d1d:	74 2b                	je     80103d4a <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103d1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d22:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d26:	0f b6 d0             	movzbl %al,%edx
80103d29:	a1 40 29 11 80       	mov    0x80112940,%eax
80103d2e:	83 ec 04             	sub    $0x4,%esp
80103d31:	52                   	push   %edx
80103d32:	50                   	push   %eax
80103d33:	68 82 88 10 80       	push   $0x80108882
80103d38:	e8 89 c6 ff ff       	call   801003c6 <cprintf>
80103d3d:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103d40:	c7 05 44 23 11 80 00 	movl   $0x0,0x80112344
80103d47:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103d4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d4d:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103d51:	0f b6 c0             	movzbl %al,%eax
80103d54:	83 e0 02             	and    $0x2,%eax
80103d57:	85 c0                	test   %eax,%eax
80103d59:	74 15                	je     80103d70 <mpinit+0xe6>
        bcpu = &cpus[ncpu];
80103d5b:	a1 40 29 11 80       	mov    0x80112940,%eax
80103d60:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d66:	05 60 23 11 80       	add    $0x80112360,%eax
80103d6b:	a3 44 b6 10 80       	mov    %eax,0x8010b644
      cpus[ncpu].id = ncpu;
80103d70:	a1 40 29 11 80       	mov    0x80112940,%eax
80103d75:	8b 15 40 29 11 80    	mov    0x80112940,%edx
80103d7b:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d81:	05 60 23 11 80       	add    $0x80112360,%eax
80103d86:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103d88:	a1 40 29 11 80       	mov    0x80112940,%eax
80103d8d:	83 c0 01             	add    $0x1,%eax
80103d90:	a3 40 29 11 80       	mov    %eax,0x80112940
      p += sizeof(struct mpproc);
80103d95:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103d99:	eb 42                	jmp    80103ddd <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103da1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103da4:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103da8:	a2 40 23 11 80       	mov    %al,0x80112340
      p += sizeof(struct mpioapic);
80103dad:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103db1:	eb 2a                	jmp    80103ddd <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103db3:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103db7:	eb 24                	jmp    80103ddd <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dbc:	0f b6 00             	movzbl (%eax),%eax
80103dbf:	0f b6 c0             	movzbl %al,%eax
80103dc2:	83 ec 08             	sub    $0x8,%esp
80103dc5:	50                   	push   %eax
80103dc6:	68 a0 88 10 80       	push   $0x801088a0
80103dcb:	e8 f6 c5 ff ff       	call   801003c6 <cprintf>
80103dd0:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103dd3:	c7 05 44 23 11 80 00 	movl   $0x0,0x80112344
80103dda:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103de0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103de3:	0f 82 02 ff ff ff    	jb     80103ceb <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103de9:	a1 44 23 11 80       	mov    0x80112344,%eax
80103dee:	85 c0                	test   %eax,%eax
80103df0:	75 1d                	jne    80103e0f <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103df2:	c7 05 40 29 11 80 01 	movl   $0x1,0x80112940
80103df9:	00 00 00 
    lapic = 0;
80103dfc:	c7 05 5c 22 11 80 00 	movl   $0x0,0x8011225c
80103e03:	00 00 00 
    ioapicid = 0;
80103e06:	c6 05 40 23 11 80 00 	movb   $0x0,0x80112340
    return;
80103e0d:	eb 3e                	jmp    80103e4d <mpinit+0x1c3>
  }

  if(mp->imcrp){
80103e0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e12:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103e16:	84 c0                	test   %al,%al
80103e18:	74 33                	je     80103e4d <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103e1a:	83 ec 08             	sub    $0x8,%esp
80103e1d:	6a 70                	push   $0x70
80103e1f:	6a 22                	push   $0x22
80103e21:	e8 1c fc ff ff       	call   80103a42 <outb>
80103e26:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103e29:	83 ec 0c             	sub    $0xc,%esp
80103e2c:	6a 23                	push   $0x23
80103e2e:	e8 f2 fb ff ff       	call   80103a25 <inb>
80103e33:	83 c4 10             	add    $0x10,%esp
80103e36:	83 c8 01             	or     $0x1,%eax
80103e39:	0f b6 c0             	movzbl %al,%eax
80103e3c:	83 ec 08             	sub    $0x8,%esp
80103e3f:	50                   	push   %eax
80103e40:	6a 23                	push   $0x23
80103e42:	e8 fb fb ff ff       	call   80103a42 <outb>
80103e47:	83 c4 10             	add    $0x10,%esp
80103e4a:	eb 01                	jmp    80103e4d <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80103e4c:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103e4d:	c9                   	leave  
80103e4e:	c3                   	ret    

80103e4f <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103e4f:	55                   	push   %ebp
80103e50:	89 e5                	mov    %esp,%ebp
80103e52:	83 ec 08             	sub    $0x8,%esp
80103e55:	8b 55 08             	mov    0x8(%ebp),%edx
80103e58:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e5b:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103e5f:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e62:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103e66:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103e6a:	ee                   	out    %al,(%dx)
}
80103e6b:	90                   	nop
80103e6c:	c9                   	leave  
80103e6d:	c3                   	ret    

80103e6e <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103e6e:	55                   	push   %ebp
80103e6f:	89 e5                	mov    %esp,%ebp
80103e71:	83 ec 04             	sub    $0x4,%esp
80103e74:	8b 45 08             	mov    0x8(%ebp),%eax
80103e77:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103e7b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e7f:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103e85:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e89:	0f b6 c0             	movzbl %al,%eax
80103e8c:	50                   	push   %eax
80103e8d:	6a 21                	push   $0x21
80103e8f:	e8 bb ff ff ff       	call   80103e4f <outb>
80103e94:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103e97:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e9b:	66 c1 e8 08          	shr    $0x8,%ax
80103e9f:	0f b6 c0             	movzbl %al,%eax
80103ea2:	50                   	push   %eax
80103ea3:	68 a1 00 00 00       	push   $0xa1
80103ea8:	e8 a2 ff ff ff       	call   80103e4f <outb>
80103ead:	83 c4 08             	add    $0x8,%esp
}
80103eb0:	90                   	nop
80103eb1:	c9                   	leave  
80103eb2:	c3                   	ret    

80103eb3 <picenable>:

void
picenable(int irq)
{
80103eb3:	55                   	push   %ebp
80103eb4:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103eb6:	8b 45 08             	mov    0x8(%ebp),%eax
80103eb9:	ba 01 00 00 00       	mov    $0x1,%edx
80103ebe:	89 c1                	mov    %eax,%ecx
80103ec0:	d3 e2                	shl    %cl,%edx
80103ec2:	89 d0                	mov    %edx,%eax
80103ec4:	f7 d0                	not    %eax
80103ec6:	89 c2                	mov    %eax,%edx
80103ec8:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103ecf:	21 d0                	and    %edx,%eax
80103ed1:	0f b7 c0             	movzwl %ax,%eax
80103ed4:	50                   	push   %eax
80103ed5:	e8 94 ff ff ff       	call   80103e6e <picsetmask>
80103eda:	83 c4 04             	add    $0x4,%esp
}
80103edd:	90                   	nop
80103ede:	c9                   	leave  
80103edf:	c3                   	ret    

80103ee0 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103ee3:	68 ff 00 00 00       	push   $0xff
80103ee8:	6a 21                	push   $0x21
80103eea:	e8 60 ff ff ff       	call   80103e4f <outb>
80103eef:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103ef2:	68 ff 00 00 00       	push   $0xff
80103ef7:	68 a1 00 00 00       	push   $0xa1
80103efc:	e8 4e ff ff ff       	call   80103e4f <outb>
80103f01:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103f04:	6a 11                	push   $0x11
80103f06:	6a 20                	push   $0x20
80103f08:	e8 42 ff ff ff       	call   80103e4f <outb>
80103f0d:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103f10:	6a 20                	push   $0x20
80103f12:	6a 21                	push   $0x21
80103f14:	e8 36 ff ff ff       	call   80103e4f <outb>
80103f19:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103f1c:	6a 04                	push   $0x4
80103f1e:	6a 21                	push   $0x21
80103f20:	e8 2a ff ff ff       	call   80103e4f <outb>
80103f25:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103f28:	6a 03                	push   $0x3
80103f2a:	6a 21                	push   $0x21
80103f2c:	e8 1e ff ff ff       	call   80103e4f <outb>
80103f31:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103f34:	6a 11                	push   $0x11
80103f36:	68 a0 00 00 00       	push   $0xa0
80103f3b:	e8 0f ff ff ff       	call   80103e4f <outb>
80103f40:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103f43:	6a 28                	push   $0x28
80103f45:	68 a1 00 00 00       	push   $0xa1
80103f4a:	e8 00 ff ff ff       	call   80103e4f <outb>
80103f4f:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103f52:	6a 02                	push   $0x2
80103f54:	68 a1 00 00 00       	push   $0xa1
80103f59:	e8 f1 fe ff ff       	call   80103e4f <outb>
80103f5e:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103f61:	6a 03                	push   $0x3
80103f63:	68 a1 00 00 00       	push   $0xa1
80103f68:	e8 e2 fe ff ff       	call   80103e4f <outb>
80103f6d:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103f70:	6a 68                	push   $0x68
80103f72:	6a 20                	push   $0x20
80103f74:	e8 d6 fe ff ff       	call   80103e4f <outb>
80103f79:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103f7c:	6a 0a                	push   $0xa
80103f7e:	6a 20                	push   $0x20
80103f80:	e8 ca fe ff ff       	call   80103e4f <outb>
80103f85:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80103f88:	6a 68                	push   $0x68
80103f8a:	68 a0 00 00 00       	push   $0xa0
80103f8f:	e8 bb fe ff ff       	call   80103e4f <outb>
80103f94:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80103f97:	6a 0a                	push   $0xa
80103f99:	68 a0 00 00 00       	push   $0xa0
80103f9e:	e8 ac fe ff ff       	call   80103e4f <outb>
80103fa3:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
80103fa6:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103fad:	66 83 f8 ff          	cmp    $0xffff,%ax
80103fb1:	74 13                	je     80103fc6 <picinit+0xe6>
    picsetmask(irqmask);
80103fb3:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103fba:	0f b7 c0             	movzwl %ax,%eax
80103fbd:	50                   	push   %eax
80103fbe:	e8 ab fe ff ff       	call   80103e6e <picsetmask>
80103fc3:	83 c4 04             	add    $0x4,%esp
}
80103fc6:	90                   	nop
80103fc7:	c9                   	leave  
80103fc8:	c3                   	ret    

80103fc9 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103fc9:	55                   	push   %ebp
80103fca:	89 e5                	mov    %esp,%ebp
80103fcc:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103fcf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103fdf:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fe2:	8b 10                	mov    (%eax),%edx
80103fe4:	8b 45 08             	mov    0x8(%ebp),%eax
80103fe7:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103fe9:	e8 b1 cf ff ff       	call   80100f9f <filealloc>
80103fee:	89 c2                	mov    %eax,%edx
80103ff0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff3:	89 10                	mov    %edx,(%eax)
80103ff5:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff8:	8b 00                	mov    (%eax),%eax
80103ffa:	85 c0                	test   %eax,%eax
80103ffc:	0f 84 cb 00 00 00    	je     801040cd <pipealloc+0x104>
80104002:	e8 98 cf ff ff       	call   80100f9f <filealloc>
80104007:	89 c2                	mov    %eax,%edx
80104009:	8b 45 0c             	mov    0xc(%ebp),%eax
8010400c:	89 10                	mov    %edx,(%eax)
8010400e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104011:	8b 00                	mov    (%eax),%eax
80104013:	85 c0                	test   %eax,%eax
80104015:	0f 84 b2 00 00 00    	je     801040cd <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010401b:	e8 08 ec ff ff       	call   80102c28 <kalloc>
80104020:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104023:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104027:	0f 84 9f 00 00 00    	je     801040cc <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
8010402d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104030:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104037:	00 00 00 
  p->writeopen = 1;
8010403a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010403d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80104044:	00 00 00 
  p->nwrite = 0;
80104047:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010404a:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104051:	00 00 00 
  p->nread = 0;
80104054:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104057:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
8010405e:	00 00 00 
  initlock(&p->lock, "pipe");
80104061:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104064:	83 ec 08             	sub    $0x8,%esp
80104067:	68 d4 88 10 80       	push   $0x801088d4
8010406c:	50                   	push   %eax
8010406d:	e8 02 0f 00 00       	call   80104f74 <initlock>
80104072:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104075:	8b 45 08             	mov    0x8(%ebp),%eax
80104078:	8b 00                	mov    (%eax),%eax
8010407a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104080:	8b 45 08             	mov    0x8(%ebp),%eax
80104083:	8b 00                	mov    (%eax),%eax
80104085:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104089:	8b 45 08             	mov    0x8(%ebp),%eax
8010408c:	8b 00                	mov    (%eax),%eax
8010408e:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104092:	8b 45 08             	mov    0x8(%ebp),%eax
80104095:	8b 00                	mov    (%eax),%eax
80104097:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010409a:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010409d:	8b 45 0c             	mov    0xc(%ebp),%eax
801040a0:	8b 00                	mov    (%eax),%eax
801040a2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801040a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801040ab:	8b 00                	mov    (%eax),%eax
801040ad:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801040b1:	8b 45 0c             	mov    0xc(%ebp),%eax
801040b4:	8b 00                	mov    (%eax),%eax
801040b6:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801040ba:	8b 45 0c             	mov    0xc(%ebp),%eax
801040bd:	8b 00                	mov    (%eax),%eax
801040bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040c2:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801040c5:	b8 00 00 00 00       	mov    $0x0,%eax
801040ca:	eb 4e                	jmp    8010411a <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
801040cc:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
801040cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801040d1:	74 0e                	je     801040e1 <pipealloc+0x118>
    kfree((char*)p);
801040d3:	83 ec 0c             	sub    $0xc,%esp
801040d6:	ff 75 f4             	pushl  -0xc(%ebp)
801040d9:	e8 ad ea ff ff       	call   80102b8b <kfree>
801040de:	83 c4 10             	add    $0x10,%esp
  if(*f0)
801040e1:	8b 45 08             	mov    0x8(%ebp),%eax
801040e4:	8b 00                	mov    (%eax),%eax
801040e6:	85 c0                	test   %eax,%eax
801040e8:	74 11                	je     801040fb <pipealloc+0x132>
    fileclose(*f0);
801040ea:	8b 45 08             	mov    0x8(%ebp),%eax
801040ed:	8b 00                	mov    (%eax),%eax
801040ef:	83 ec 0c             	sub    $0xc,%esp
801040f2:	50                   	push   %eax
801040f3:	e8 65 cf ff ff       	call   8010105d <fileclose>
801040f8:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801040fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801040fe:	8b 00                	mov    (%eax),%eax
80104100:	85 c0                	test   %eax,%eax
80104102:	74 11                	je     80104115 <pipealloc+0x14c>
    fileclose(*f1);
80104104:	8b 45 0c             	mov    0xc(%ebp),%eax
80104107:	8b 00                	mov    (%eax),%eax
80104109:	83 ec 0c             	sub    $0xc,%esp
8010410c:	50                   	push   %eax
8010410d:	e8 4b cf ff ff       	call   8010105d <fileclose>
80104112:	83 c4 10             	add    $0x10,%esp
  return -1;
80104115:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010411a:	c9                   	leave  
8010411b:	c3                   	ret    

8010411c <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
8010411c:	55                   	push   %ebp
8010411d:	89 e5                	mov    %esp,%ebp
8010411f:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80104122:	8b 45 08             	mov    0x8(%ebp),%eax
80104125:	83 ec 0c             	sub    $0xc,%esp
80104128:	50                   	push   %eax
80104129:	e8 68 0e 00 00       	call   80104f96 <acquire>
8010412e:	83 c4 10             	add    $0x10,%esp
  if(writable){
80104131:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104135:	74 23                	je     8010415a <pipeclose+0x3e>
    p->writeopen = 0;
80104137:	8b 45 08             	mov    0x8(%ebp),%eax
8010413a:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104141:	00 00 00 
    wakeup(&p->nread);
80104144:	8b 45 08             	mov    0x8(%ebp),%eax
80104147:	05 34 02 00 00       	add    $0x234,%eax
8010414c:	83 ec 0c             	sub    $0xc,%esp
8010414f:	50                   	push   %eax
80104150:	e8 33 0c 00 00       	call   80104d88 <wakeup>
80104155:	83 c4 10             	add    $0x10,%esp
80104158:	eb 21                	jmp    8010417b <pipeclose+0x5f>
  } else {
    p->readopen = 0;
8010415a:	8b 45 08             	mov    0x8(%ebp),%eax
8010415d:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104164:	00 00 00 
    wakeup(&p->nwrite);
80104167:	8b 45 08             	mov    0x8(%ebp),%eax
8010416a:	05 38 02 00 00       	add    $0x238,%eax
8010416f:	83 ec 0c             	sub    $0xc,%esp
80104172:	50                   	push   %eax
80104173:	e8 10 0c 00 00       	call   80104d88 <wakeup>
80104178:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010417b:	8b 45 08             	mov    0x8(%ebp),%eax
8010417e:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104184:	85 c0                	test   %eax,%eax
80104186:	75 2c                	jne    801041b4 <pipeclose+0x98>
80104188:	8b 45 08             	mov    0x8(%ebp),%eax
8010418b:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104191:	85 c0                	test   %eax,%eax
80104193:	75 1f                	jne    801041b4 <pipeclose+0x98>
    release(&p->lock);
80104195:	8b 45 08             	mov    0x8(%ebp),%eax
80104198:	83 ec 0c             	sub    $0xc,%esp
8010419b:	50                   	push   %eax
8010419c:	e8 5c 0e 00 00       	call   80104ffd <release>
801041a1:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
801041a4:	83 ec 0c             	sub    $0xc,%esp
801041a7:	ff 75 08             	pushl  0x8(%ebp)
801041aa:	e8 dc e9 ff ff       	call   80102b8b <kfree>
801041af:	83 c4 10             	add    $0x10,%esp
801041b2:	eb 0f                	jmp    801041c3 <pipeclose+0xa7>
  } else
    release(&p->lock);
801041b4:	8b 45 08             	mov    0x8(%ebp),%eax
801041b7:	83 ec 0c             	sub    $0xc,%esp
801041ba:	50                   	push   %eax
801041bb:	e8 3d 0e 00 00       	call   80104ffd <release>
801041c0:	83 c4 10             	add    $0x10,%esp
}
801041c3:	90                   	nop
801041c4:	c9                   	leave  
801041c5:	c3                   	ret    

801041c6 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801041c6:	55                   	push   %ebp
801041c7:	89 e5                	mov    %esp,%ebp
801041c9:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
801041cc:	8b 45 08             	mov    0x8(%ebp),%eax
801041cf:	83 ec 0c             	sub    $0xc,%esp
801041d2:	50                   	push   %eax
801041d3:	e8 be 0d 00 00       	call   80104f96 <acquire>
801041d8:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
801041db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801041e2:	e9 ad 00 00 00       	jmp    80104294 <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
801041e7:	8b 45 08             	mov    0x8(%ebp),%eax
801041ea:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801041f0:	85 c0                	test   %eax,%eax
801041f2:	74 0d                	je     80104201 <pipewrite+0x3b>
801041f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801041fa:	8b 40 28             	mov    0x28(%eax),%eax
801041fd:	85 c0                	test   %eax,%eax
801041ff:	74 19                	je     8010421a <pipewrite+0x54>
        release(&p->lock);
80104201:	8b 45 08             	mov    0x8(%ebp),%eax
80104204:	83 ec 0c             	sub    $0xc,%esp
80104207:	50                   	push   %eax
80104208:	e8 f0 0d 00 00       	call   80104ffd <release>
8010420d:	83 c4 10             	add    $0x10,%esp
        return -1;
80104210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104215:	e9 a8 00 00 00       	jmp    801042c2 <pipewrite+0xfc>
      }
      wakeup(&p->nread);
8010421a:	8b 45 08             	mov    0x8(%ebp),%eax
8010421d:	05 34 02 00 00       	add    $0x234,%eax
80104222:	83 ec 0c             	sub    $0xc,%esp
80104225:	50                   	push   %eax
80104226:	e8 5d 0b 00 00       	call   80104d88 <wakeup>
8010422b:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010422e:	8b 45 08             	mov    0x8(%ebp),%eax
80104231:	8b 55 08             	mov    0x8(%ebp),%edx
80104234:	81 c2 38 02 00 00    	add    $0x238,%edx
8010423a:	83 ec 08             	sub    $0x8,%esp
8010423d:	50                   	push   %eax
8010423e:	52                   	push   %edx
8010423f:	e8 59 0a 00 00       	call   80104c9d <sleep>
80104244:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104247:	8b 45 08             	mov    0x8(%ebp),%eax
8010424a:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104250:	8b 45 08             	mov    0x8(%ebp),%eax
80104253:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104259:	05 00 02 00 00       	add    $0x200,%eax
8010425e:	39 c2                	cmp    %eax,%edx
80104260:	74 85                	je     801041e7 <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104262:	8b 45 08             	mov    0x8(%ebp),%eax
80104265:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010426b:	8d 48 01             	lea    0x1(%eax),%ecx
8010426e:	8b 55 08             	mov    0x8(%ebp),%edx
80104271:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104277:	25 ff 01 00 00       	and    $0x1ff,%eax
8010427c:	89 c1                	mov    %eax,%ecx
8010427e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104281:	8b 45 0c             	mov    0xc(%ebp),%eax
80104284:	01 d0                	add    %edx,%eax
80104286:	0f b6 10             	movzbl (%eax),%edx
80104289:	8b 45 08             	mov    0x8(%ebp),%eax
8010428c:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80104290:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104294:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104297:	3b 45 10             	cmp    0x10(%ebp),%eax
8010429a:	7c ab                	jl     80104247 <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010429c:	8b 45 08             	mov    0x8(%ebp),%eax
8010429f:	05 34 02 00 00       	add    $0x234,%eax
801042a4:	83 ec 0c             	sub    $0xc,%esp
801042a7:	50                   	push   %eax
801042a8:	e8 db 0a 00 00       	call   80104d88 <wakeup>
801042ad:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801042b0:	8b 45 08             	mov    0x8(%ebp),%eax
801042b3:	83 ec 0c             	sub    $0xc,%esp
801042b6:	50                   	push   %eax
801042b7:	e8 41 0d 00 00       	call   80104ffd <release>
801042bc:	83 c4 10             	add    $0x10,%esp
  return n;
801042bf:	8b 45 10             	mov    0x10(%ebp),%eax
}
801042c2:	c9                   	leave  
801042c3:	c3                   	ret    

801042c4 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801042c4:	55                   	push   %ebp
801042c5:	89 e5                	mov    %esp,%ebp
801042c7:	53                   	push   %ebx
801042c8:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
801042cb:	8b 45 08             	mov    0x8(%ebp),%eax
801042ce:	83 ec 0c             	sub    $0xc,%esp
801042d1:	50                   	push   %eax
801042d2:	e8 bf 0c 00 00       	call   80104f96 <acquire>
801042d7:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801042da:	eb 3f                	jmp    8010431b <piperead+0x57>
    if(proc->killed){
801042dc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042e2:	8b 40 28             	mov    0x28(%eax),%eax
801042e5:	85 c0                	test   %eax,%eax
801042e7:	74 19                	je     80104302 <piperead+0x3e>
      release(&p->lock);
801042e9:	8b 45 08             	mov    0x8(%ebp),%eax
801042ec:	83 ec 0c             	sub    $0xc,%esp
801042ef:	50                   	push   %eax
801042f0:	e8 08 0d 00 00       	call   80104ffd <release>
801042f5:	83 c4 10             	add    $0x10,%esp
      return -1;
801042f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042fd:	e9 bf 00 00 00       	jmp    801043c1 <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104302:	8b 45 08             	mov    0x8(%ebp),%eax
80104305:	8b 55 08             	mov    0x8(%ebp),%edx
80104308:	81 c2 34 02 00 00    	add    $0x234,%edx
8010430e:	83 ec 08             	sub    $0x8,%esp
80104311:	50                   	push   %eax
80104312:	52                   	push   %edx
80104313:	e8 85 09 00 00       	call   80104c9d <sleep>
80104318:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010431b:	8b 45 08             	mov    0x8(%ebp),%eax
8010431e:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104324:	8b 45 08             	mov    0x8(%ebp),%eax
80104327:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010432d:	39 c2                	cmp    %eax,%edx
8010432f:	75 0d                	jne    8010433e <piperead+0x7a>
80104331:	8b 45 08             	mov    0x8(%ebp),%eax
80104334:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010433a:	85 c0                	test   %eax,%eax
8010433c:	75 9e                	jne    801042dc <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010433e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104345:	eb 49                	jmp    80104390 <piperead+0xcc>
    if(p->nread == p->nwrite)
80104347:	8b 45 08             	mov    0x8(%ebp),%eax
8010434a:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104350:	8b 45 08             	mov    0x8(%ebp),%eax
80104353:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104359:	39 c2                	cmp    %eax,%edx
8010435b:	74 3d                	je     8010439a <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010435d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104360:	8b 45 0c             	mov    0xc(%ebp),%eax
80104363:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104366:	8b 45 08             	mov    0x8(%ebp),%eax
80104369:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010436f:	8d 48 01             	lea    0x1(%eax),%ecx
80104372:	8b 55 08             	mov    0x8(%ebp),%edx
80104375:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
8010437b:	25 ff 01 00 00       	and    $0x1ff,%eax
80104380:	89 c2                	mov    %eax,%edx
80104382:	8b 45 08             	mov    0x8(%ebp),%eax
80104385:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
8010438a:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010438c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104390:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104393:	3b 45 10             	cmp    0x10(%ebp),%eax
80104396:	7c af                	jl     80104347 <piperead+0x83>
80104398:	eb 01                	jmp    8010439b <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
8010439a:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010439b:	8b 45 08             	mov    0x8(%ebp),%eax
8010439e:	05 38 02 00 00       	add    $0x238,%eax
801043a3:	83 ec 0c             	sub    $0xc,%esp
801043a6:	50                   	push   %eax
801043a7:	e8 dc 09 00 00       	call   80104d88 <wakeup>
801043ac:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043af:	8b 45 08             	mov    0x8(%ebp),%eax
801043b2:	83 ec 0c             	sub    $0xc,%esp
801043b5:	50                   	push   %eax
801043b6:	e8 42 0c 00 00       	call   80104ffd <release>
801043bb:	83 c4 10             	add    $0x10,%esp
  return i;
801043be:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801043c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043c4:	c9                   	leave  
801043c5:	c3                   	ret    

801043c6 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801043c6:	55                   	push   %ebp
801043c7:	89 e5                	mov    %esp,%ebp
801043c9:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043cc:	9c                   	pushf  
801043cd:	58                   	pop    %eax
801043ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801043d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801043d4:	c9                   	leave  
801043d5:	c3                   	ret    

801043d6 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801043d6:	55                   	push   %ebp
801043d7:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801043d9:	fb                   	sti    
}
801043da:	90                   	nop
801043db:	5d                   	pop    %ebp
801043dc:	c3                   	ret    

801043dd <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801043dd:	55                   	push   %ebp
801043de:	89 e5                	mov    %esp,%ebp
801043e0:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
801043e3:	83 ec 08             	sub    $0x8,%esp
801043e6:	68 d9 88 10 80       	push   $0x801088d9
801043eb:	68 60 29 11 80       	push   $0x80112960
801043f0:	e8 7f 0b 00 00       	call   80104f74 <initlock>
801043f5:	83 c4 10             	add    $0x10,%esp
}
801043f8:	90                   	nop
801043f9:	c9                   	leave  
801043fa:	c3                   	ret    

801043fb <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801043fb:	55                   	push   %ebp
801043fc:	89 e5                	mov    %esp,%ebp
801043fe:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104401:	83 ec 0c             	sub    $0xc,%esp
80104404:	68 60 29 11 80       	push   $0x80112960
80104409:	e8 88 0b 00 00       	call   80104f96 <acquire>
8010440e:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104411:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104418:	eb 0e                	jmp    80104428 <allocproc+0x2d>
    if(p->state == UNUSED)
8010441a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010441d:	8b 40 10             	mov    0x10(%eax),%eax
80104420:	85 c0                	test   %eax,%eax
80104422:	74 27                	je     8010444b <allocproc+0x50>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104424:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104428:	81 7d f4 94 49 11 80 	cmpl   $0x80114994,-0xc(%ebp)
8010442f:	72 e9                	jb     8010441a <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
80104431:	83 ec 0c             	sub    $0xc,%esp
80104434:	68 60 29 11 80       	push   $0x80112960
80104439:	e8 bf 0b 00 00       	call   80104ffd <release>
8010443e:	83 c4 10             	add    $0x10,%esp
  return 0;
80104441:	b8 00 00 00 00       	mov    $0x0,%eax
80104446:	e9 b4 00 00 00       	jmp    801044ff <allocproc+0x104>
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
8010444b:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
8010444c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010444f:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
  p->pid = nextpid++;
80104456:	a1 04 b0 10 80       	mov    0x8010b004,%eax
8010445b:	8d 50 01             	lea    0x1(%eax),%edx
8010445e:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
80104464:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104467:	89 42 14             	mov    %eax,0x14(%edx)
  release(&ptable.lock);
8010446a:	83 ec 0c             	sub    $0xc,%esp
8010446d:	68 60 29 11 80       	push   $0x80112960
80104472:	e8 86 0b 00 00       	call   80104ffd <release>
80104477:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010447a:	e8 a9 e7 ff ff       	call   80102c28 <kalloc>
8010447f:	89 c2                	mov    %eax,%edx
80104481:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104484:	89 50 0c             	mov    %edx,0xc(%eax)
80104487:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010448a:	8b 40 0c             	mov    0xc(%eax),%eax
8010448d:	85 c0                	test   %eax,%eax
8010448f:	75 11                	jne    801044a2 <allocproc+0xa7>
    p->state = UNUSED;
80104491:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104494:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
    return 0;
8010449b:	b8 00 00 00 00       	mov    $0x0,%eax
801044a0:	eb 5d                	jmp    801044ff <allocproc+0x104>
  }
  sp = p->kstack + KSTACKSIZE;
801044a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044a5:	8b 40 0c             	mov    0xc(%eax),%eax
801044a8:	05 00 10 00 00       	add    $0x1000,%eax
801044ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801044b0:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801044b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044ba:	89 50 1c             	mov    %edx,0x1c(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801044bd:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801044c1:	ba ee 65 10 80       	mov    $0x801065ee,%edx
801044c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044c9:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801044cb:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801044cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044d5:	89 50 20             	mov    %edx,0x20(%eax)
  memset(p->context, 0, sizeof *p->context);
801044d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044db:	8b 40 20             	mov    0x20(%eax),%eax
801044de:	83 ec 04             	sub    $0x4,%esp
801044e1:	6a 14                	push   $0x14
801044e3:	6a 00                	push   $0x0
801044e5:	50                   	push   %eax
801044e6:	e8 0e 0d 00 00       	call   801051f9 <memset>
801044eb:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801044ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044f1:	8b 40 20             	mov    0x20(%eax),%eax
801044f4:	ba 57 4c 10 80       	mov    $0x80104c57,%edx
801044f9:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801044fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801044ff:	c9                   	leave  
80104500:	c3                   	ret    

80104501 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104501:	55                   	push   %ebp
80104502:	89 e5                	mov    %esp,%ebp
80104504:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  p = allocproc();
80104507:	e8 ef fe ff ff       	call   801043fb <allocproc>
8010450c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
8010450f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104512:	a3 48 b6 10 80       	mov    %eax,0x8010b648
  if((p->pgdir = setupkvm()) == 0)
80104517:	e8 de 37 00 00       	call   80107cfa <setupkvm>
8010451c:	89 c2                	mov    %eax,%edx
8010451e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104521:	89 50 08             	mov    %edx,0x8(%eax)
80104524:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104527:	8b 40 08             	mov    0x8(%eax),%eax
8010452a:	85 c0                	test   %eax,%eax
8010452c:	75 0d                	jne    8010453b <userinit+0x3a>
    panic("userinit: out of memory?");
8010452e:	83 ec 0c             	sub    $0xc,%esp
80104531:	68 e0 88 10 80       	push   $0x801088e0
80104536:	e8 2b c0 ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010453b:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104540:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104543:	8b 40 08             	mov    0x8(%eax),%eax
80104546:	83 ec 04             	sub    $0x4,%esp
80104549:	52                   	push   %edx
8010454a:	68 e0 b4 10 80       	push   $0x8010b4e0
8010454f:	50                   	push   %eax
80104550:	e8 ff 39 00 00       	call   80107f54 <inituvm>
80104555:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104558:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010455b:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104561:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104564:	8b 40 1c             	mov    0x1c(%eax),%eax
80104567:	83 ec 04             	sub    $0x4,%esp
8010456a:	6a 4c                	push   $0x4c
8010456c:	6a 00                	push   $0x0
8010456e:	50                   	push   %eax
8010456f:	e8 85 0c 00 00       	call   801051f9 <memset>
80104574:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104577:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010457a:	8b 40 1c             	mov    0x1c(%eax),%eax
8010457d:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104583:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104586:	8b 40 1c             	mov    0x1c(%eax),%eax
80104589:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010458f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104592:	8b 40 1c             	mov    0x1c(%eax),%eax
80104595:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104598:	8b 52 1c             	mov    0x1c(%edx),%edx
8010459b:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010459f:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801045a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a6:	8b 40 1c             	mov    0x1c(%eax),%eax
801045a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045ac:	8b 52 1c             	mov    0x1c(%edx),%edx
801045af:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801045b3:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801045b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ba:	8b 40 1c             	mov    0x1c(%eax),%eax
801045bd:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801045c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c7:	8b 40 1c             	mov    0x1c(%eax),%eax
801045ca:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801045d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d4:	8b 40 1c             	mov    0x1c(%eax),%eax
801045d7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801045de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e1:	83 c0 70             	add    $0x70,%eax
801045e4:	83 ec 04             	sub    $0x4,%esp
801045e7:	6a 10                	push   $0x10
801045e9:	68 f9 88 10 80       	push   $0x801088f9
801045ee:	50                   	push   %eax
801045ef:	e8 08 0e 00 00       	call   801053fc <safestrcpy>
801045f4:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
801045f7:	83 ec 0c             	sub    $0xc,%esp
801045fa:	68 02 89 10 80       	push   $0x80108902
801045ff:	e8 e6 de ff ff       	call   801024ea <namei>
80104604:	83 c4 10             	add    $0x10,%esp
80104607:	89 c2                	mov    %eax,%edx
80104609:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010460c:	89 50 6c             	mov    %edx,0x6c(%eax)

  p->state = RUNNABLE;
8010460f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104612:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
}
80104619:	90                   	nop
8010461a:	c9                   	leave  
8010461b:	c3                   	ret    

8010461c <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010461c:	55                   	push   %ebp
8010461d:	89 e5                	mov    %esp,%ebp
8010461f:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
80104622:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104628:	8b 00                	mov    (%eax),%eax
8010462a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010462d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104631:	7e 31                	jle    80104664 <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104633:	8b 55 08             	mov    0x8(%ebp),%edx
80104636:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104639:	01 c2                	add    %eax,%edx
8010463b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104641:	8b 40 08             	mov    0x8(%eax),%eax
80104644:	83 ec 04             	sub    $0x4,%esp
80104647:	52                   	push   %edx
80104648:	ff 75 f4             	pushl  -0xc(%ebp)
8010464b:	50                   	push   %eax
8010464c:	e8 50 3a 00 00       	call   801080a1 <allocuvm>
80104651:	83 c4 10             	add    $0x10,%esp
80104654:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104657:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010465b:	75 3e                	jne    8010469b <growproc+0x7f>
      return -1;
8010465d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104662:	eb 59                	jmp    801046bd <growproc+0xa1>
  } else if(n < 0){
80104664:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104668:	79 31                	jns    8010469b <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
8010466a:	8b 55 08             	mov    0x8(%ebp),%edx
8010466d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104670:	01 c2                	add    %eax,%edx
80104672:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104678:	8b 40 08             	mov    0x8(%eax),%eax
8010467b:	83 ec 04             	sub    $0x4,%esp
8010467e:	52                   	push   %edx
8010467f:	ff 75 f4             	pushl  -0xc(%ebp)
80104682:	50                   	push   %eax
80104683:	e8 e2 3a 00 00       	call   8010816a <deallocuvm>
80104688:	83 c4 10             	add    $0x10,%esp
8010468b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010468e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104692:	75 07                	jne    8010469b <growproc+0x7f>
      return -1;
80104694:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104699:	eb 22                	jmp    801046bd <growproc+0xa1>
  }
  proc->sz = sz;
8010469b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046a4:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801046a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046ac:	83 ec 0c             	sub    $0xc,%esp
801046af:	50                   	push   %eax
801046b0:	e8 2c 37 00 00       	call   80107de1 <switchuvm>
801046b5:	83 c4 10             	add    $0x10,%esp
  return 0;
801046b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801046bd:	c9                   	leave  
801046be:	c3                   	ret    

801046bf <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801046bf:	55                   	push   %ebp
801046c0:	89 e5                	mov    %esp,%ebp
801046c2:	57                   	push   %edi
801046c3:	56                   	push   %esi
801046c4:	53                   	push   %ebx
801046c5:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801046c8:	e8 2e fd ff ff       	call   801043fb <allocproc>
801046cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
801046d0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801046d4:	75 0a                	jne    801046e0 <fork+0x21>
    return -1;
801046d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046db:	e9 77 01 00 00       	jmp    80104857 <fork+0x198>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801046e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046e6:	8b 10                	mov    (%eax),%edx
801046e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046ee:	8b 40 08             	mov    0x8(%eax),%eax
801046f1:	83 ec 08             	sub    $0x8,%esp
801046f4:	52                   	push   %edx
801046f5:	50                   	push   %eax
801046f6:	e8 0d 3c 00 00       	call   80108308 <copyuvm>
801046fb:	83 c4 10             	add    $0x10,%esp
801046fe:	89 c2                	mov    %eax,%edx
80104700:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104703:	89 50 08             	mov    %edx,0x8(%eax)
80104706:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104709:	8b 40 08             	mov    0x8(%eax),%eax
8010470c:	85 c0                	test   %eax,%eax
8010470e:	75 30                	jne    80104740 <fork+0x81>
    kfree(np->kstack);
80104710:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104713:	8b 40 0c             	mov    0xc(%eax),%eax
80104716:	83 ec 0c             	sub    $0xc,%esp
80104719:	50                   	push   %eax
8010471a:	e8 6c e4 ff ff       	call   80102b8b <kfree>
8010471f:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104722:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104725:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    np->state = UNUSED;
8010472c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010472f:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
    return -1;
80104736:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010473b:	e9 17 01 00 00       	jmp    80104857 <fork+0x198>
  }
  np->sz = proc->sz;
80104740:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104746:	8b 10                	mov    (%eax),%edx
80104748:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010474b:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
8010474d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104754:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104757:	89 50 18             	mov    %edx,0x18(%eax)
  *np->tf = *proc->tf;
8010475a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010475d:	8b 50 1c             	mov    0x1c(%eax),%edx
80104760:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104766:	8b 40 1c             	mov    0x1c(%eax),%eax
80104769:	89 c3                	mov    %eax,%ebx
8010476b:	b8 13 00 00 00       	mov    $0x13,%eax
80104770:	89 d7                	mov    %edx,%edi
80104772:	89 de                	mov    %ebx,%esi
80104774:	89 c1                	mov    %eax,%ecx
80104776:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->sb = proc->sb;
80104778:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010477e:	8b 50 04             	mov    0x4(%eax),%edx
80104781:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104784:	89 50 04             	mov    %edx,0x4(%eax)
  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104787:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010478a:	8b 40 1c             	mov    0x1c(%eax),%eax
8010478d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104794:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010479b:	eb 43                	jmp    801047e0 <fork+0x121>
    if(proc->ofile[i])
8010479d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047a6:	83 c2 08             	add    $0x8,%edx
801047a9:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
801047ad:	85 c0                	test   %eax,%eax
801047af:	74 2b                	je     801047dc <fork+0x11d>
      np->ofile[i] = filedup(proc->ofile[i]);
801047b1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047ba:	83 c2 08             	add    $0x8,%edx
801047bd:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
801047c1:	83 ec 0c             	sub    $0xc,%esp
801047c4:	50                   	push   %eax
801047c5:	e8 42 c8 ff ff       	call   8010100c <filedup>
801047ca:	83 c4 10             	add    $0x10,%esp
801047cd:	89 c1                	mov    %eax,%ecx
801047cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047d5:	83 c2 08             	add    $0x8,%edx
801047d8:	89 4c 90 0c          	mov    %ecx,0xc(%eax,%edx,4)
  *np->tf = *proc->tf;
  np->sb = proc->sb;
  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801047dc:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801047e0:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801047e4:	7e b7                	jle    8010479d <fork+0xde>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
801047e6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047ec:	8b 40 6c             	mov    0x6c(%eax),%eax
801047ef:	83 ec 0c             	sub    $0xc,%esp
801047f2:	50                   	push   %eax
801047f3:	e8 fa d0 ff ff       	call   801018f2 <idup>
801047f8:	83 c4 10             	add    $0x10,%esp
801047fb:	89 c2                	mov    %eax,%edx
801047fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104800:	89 50 6c             	mov    %edx,0x6c(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104803:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104809:	8d 50 70             	lea    0x70(%eax),%edx
8010480c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010480f:	83 c0 70             	add    $0x70,%eax
80104812:	83 ec 04             	sub    $0x4,%esp
80104815:	6a 10                	push   $0x10
80104817:	52                   	push   %edx
80104818:	50                   	push   %eax
80104819:	e8 de 0b 00 00       	call   801053fc <safestrcpy>
8010481e:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80104821:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104824:	8b 40 14             	mov    0x14(%eax),%eax
80104827:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
8010482a:	83 ec 0c             	sub    $0xc,%esp
8010482d:	68 60 29 11 80       	push   $0x80112960
80104832:	e8 5f 07 00 00       	call   80104f96 <acquire>
80104837:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
8010483a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010483d:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  release(&ptable.lock);
80104844:	83 ec 0c             	sub    $0xc,%esp
80104847:	68 60 29 11 80       	push   $0x80112960
8010484c:	e8 ac 07 00 00       	call   80104ffd <release>
80104851:	83 c4 10             	add    $0x10,%esp
  
  return pid;
80104854:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104857:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010485a:	5b                   	pop    %ebx
8010485b:	5e                   	pop    %esi
8010485c:	5f                   	pop    %edi
8010485d:	5d                   	pop    %ebp
8010485e:	c3                   	ret    

8010485f <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
8010485f:	55                   	push   %ebp
80104860:	89 e5                	mov    %esp,%ebp
80104862:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104865:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010486c:	a1 48 b6 10 80       	mov    0x8010b648,%eax
80104871:	39 c2                	cmp    %eax,%edx
80104873:	75 0d                	jne    80104882 <exit+0x23>
    panic("init exiting");
80104875:	83 ec 0c             	sub    $0xc,%esp
80104878:	68 04 89 10 80       	push   $0x80108904
8010487d:	e8 e4 bc ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104882:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104889:	eb 48                	jmp    801048d3 <exit+0x74>
    if(proc->ofile[fd]){
8010488b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104891:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104894:	83 c2 08             	add    $0x8,%edx
80104897:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
8010489b:	85 c0                	test   %eax,%eax
8010489d:	74 30                	je     801048cf <exit+0x70>
      fileclose(proc->ofile[fd]);
8010489f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048a8:	83 c2 08             	add    $0x8,%edx
801048ab:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
801048af:	83 ec 0c             	sub    $0xc,%esp
801048b2:	50                   	push   %eax
801048b3:	e8 a5 c7 ff ff       	call   8010105d <fileclose>
801048b8:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
801048bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048c4:	83 c2 08             	add    $0x8,%edx
801048c7:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
801048ce:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801048cf:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801048d3:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801048d7:	7e b2                	jle    8010488b <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
801048d9:	e8 31 ec ff ff       	call   8010350f <begin_op>
  iput(proc->cwd);
801048de:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048e4:	8b 40 6c             	mov    0x6c(%eax),%eax
801048e7:	83 ec 0c             	sub    $0xc,%esp
801048ea:	50                   	push   %eax
801048eb:	e8 0c d2 ff ff       	call   80101afc <iput>
801048f0:	83 c4 10             	add    $0x10,%esp
  end_op();
801048f3:	e8 a3 ec ff ff       	call   8010359b <end_op>
  proc->cwd = 0;
801048f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048fe:	c7 40 6c 00 00 00 00 	movl   $0x0,0x6c(%eax)

  acquire(&ptable.lock);
80104905:	83 ec 0c             	sub    $0xc,%esp
80104908:	68 60 29 11 80       	push   $0x80112960
8010490d:	e8 84 06 00 00       	call   80104f96 <acquire>
80104912:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104915:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010491b:	8b 40 18             	mov    0x18(%eax),%eax
8010491e:	83 ec 0c             	sub    $0xc,%esp
80104921:	50                   	push   %eax
80104922:	e8 22 04 00 00       	call   80104d49 <wakeup1>
80104927:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010492a:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104931:	eb 3c                	jmp    8010496f <exit+0x110>
    if(p->parent == proc){
80104933:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104936:	8b 50 18             	mov    0x18(%eax),%edx
80104939:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010493f:	39 c2                	cmp    %eax,%edx
80104941:	75 28                	jne    8010496b <exit+0x10c>
      p->parent = initproc;
80104943:	8b 15 48 b6 10 80    	mov    0x8010b648,%edx
80104949:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010494c:	89 50 18             	mov    %edx,0x18(%eax)
      if(p->state == ZOMBIE)
8010494f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104952:	8b 40 10             	mov    0x10(%eax),%eax
80104955:	83 f8 05             	cmp    $0x5,%eax
80104958:	75 11                	jne    8010496b <exit+0x10c>
        wakeup1(initproc);
8010495a:	a1 48 b6 10 80       	mov    0x8010b648,%eax
8010495f:	83 ec 0c             	sub    $0xc,%esp
80104962:	50                   	push   %eax
80104963:	e8 e1 03 00 00       	call   80104d49 <wakeup1>
80104968:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010496b:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
8010496f:	81 7d f4 94 49 11 80 	cmpl   $0x80114994,-0xc(%ebp)
80104976:	72 bb                	jb     80104933 <exit+0xd4>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104978:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010497e:	c7 40 10 05 00 00 00 	movl   $0x5,0x10(%eax)
  sched();
80104985:	e8 d6 01 00 00       	call   80104b60 <sched>
  panic("zombie exit");
8010498a:	83 ec 0c             	sub    $0xc,%esp
8010498d:	68 11 89 10 80       	push   $0x80108911
80104992:	e8 cf bb ff ff       	call   80100566 <panic>

80104997 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104997:	55                   	push   %ebp
80104998:	89 e5                	mov    %esp,%ebp
8010499a:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
8010499d:	83 ec 0c             	sub    $0xc,%esp
801049a0:	68 60 29 11 80       	push   $0x80112960
801049a5:	e8 ec 05 00 00       	call   80104f96 <acquire>
801049aa:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
801049ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049b4:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
801049bb:	e9 a6 00 00 00       	jmp    80104a66 <wait+0xcf>
      if(p->parent != proc)
801049c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c3:	8b 50 18             	mov    0x18(%eax),%edx
801049c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049cc:	39 c2                	cmp    %eax,%edx
801049ce:	0f 85 8d 00 00 00    	jne    80104a61 <wait+0xca>
        continue;
      havekids = 1;
801049d4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801049db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049de:	8b 40 10             	mov    0x10(%eax),%eax
801049e1:	83 f8 05             	cmp    $0x5,%eax
801049e4:	75 7c                	jne    80104a62 <wait+0xcb>
        // Found one.
        pid = p->pid;
801049e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e9:	8b 40 14             	mov    0x14(%eax),%eax
801049ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
801049ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f2:	8b 40 0c             	mov    0xc(%eax),%eax
801049f5:	83 ec 0c             	sub    $0xc,%esp
801049f8:	50                   	push   %eax
801049f9:	e8 8d e1 ff ff       	call   80102b8b <kfree>
801049fe:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a04:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        freevm(p->pgdir);
80104a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a0e:	8b 40 08             	mov    0x8(%eax),%eax
80104a11:	83 ec 0c             	sub    $0xc,%esp
80104a14:	50                   	push   %eax
80104a15:	e8 0d 38 00 00       	call   80108227 <freevm>
80104a1a:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a20:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->pid = 0;
80104a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a2a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->parent = 0;
80104a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a34:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
        p->name[0] = 0;
80104a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a3e:	c6 40 70 00          	movb   $0x0,0x70(%eax)
        p->killed = 0;
80104a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a45:	c7 40 28 00 00 00 00 	movl   $0x0,0x28(%eax)
        release(&ptable.lock);
80104a4c:	83 ec 0c             	sub    $0xc,%esp
80104a4f:	68 60 29 11 80       	push   $0x80112960
80104a54:	e8 a4 05 00 00       	call   80104ffd <release>
80104a59:	83 c4 10             	add    $0x10,%esp
        return pid;
80104a5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a5f:	eb 58                	jmp    80104ab9 <wait+0x122>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104a61:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a62:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104a66:	81 7d f4 94 49 11 80 	cmpl   $0x80114994,-0xc(%ebp)
80104a6d:	0f 82 4d ff ff ff    	jb     801049c0 <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104a73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104a77:	74 0d                	je     80104a86 <wait+0xef>
80104a79:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a7f:	8b 40 28             	mov    0x28(%eax),%eax
80104a82:	85 c0                	test   %eax,%eax
80104a84:	74 17                	je     80104a9d <wait+0x106>
      release(&ptable.lock);
80104a86:	83 ec 0c             	sub    $0xc,%esp
80104a89:	68 60 29 11 80       	push   $0x80112960
80104a8e:	e8 6a 05 00 00       	call   80104ffd <release>
80104a93:	83 c4 10             	add    $0x10,%esp
      return -1;
80104a96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a9b:	eb 1c                	jmp    80104ab9 <wait+0x122>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104a9d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aa3:	83 ec 08             	sub    $0x8,%esp
80104aa6:	68 60 29 11 80       	push   $0x80112960
80104aab:	50                   	push   %eax
80104aac:	e8 ec 01 00 00       	call   80104c9d <sleep>
80104ab1:	83 c4 10             	add    $0x10,%esp
  }
80104ab4:	e9 f4 fe ff ff       	jmp    801049ad <wait+0x16>
}
80104ab9:	c9                   	leave  
80104aba:	c3                   	ret    

80104abb <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104abb:	55                   	push   %ebp
80104abc:	89 e5                	mov    %esp,%ebp
80104abe:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104ac1:	e8 10 f9 ff ff       	call   801043d6 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104ac6:	83 ec 0c             	sub    $0xc,%esp
80104ac9:	68 60 29 11 80       	push   $0x80112960
80104ace:	e8 c3 04 00 00       	call   80104f96 <acquire>
80104ad3:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ad6:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104add:	eb 63                	jmp    80104b42 <scheduler+0x87>
      if(p->state != RUNNABLE)
80104adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae2:	8b 40 10             	mov    0x10(%eax),%eax
80104ae5:	83 f8 03             	cmp    $0x3,%eax
80104ae8:	75 53                	jne    80104b3d <scheduler+0x82>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aed:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104af3:	83 ec 0c             	sub    $0xc,%esp
80104af6:	ff 75 f4             	pushl  -0xc(%ebp)
80104af9:	e8 e3 32 00 00       	call   80107de1 <switchuvm>
80104afe:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b04:	c7 40 10 04 00 00 00 	movl   $0x4,0x10(%eax)
      swtch(&cpu->scheduler, proc->context);
80104b0b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b11:	8b 40 20             	mov    0x20(%eax),%eax
80104b14:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104b1b:	83 c2 04             	add    $0x4,%edx
80104b1e:	83 ec 08             	sub    $0x8,%esp
80104b21:	50                   	push   %eax
80104b22:	52                   	push   %edx
80104b23:	e8 45 09 00 00       	call   8010546d <swtch>
80104b28:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104b2b:	e8 94 32 00 00       	call   80107dc4 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104b30:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104b37:	00 00 00 00 
80104b3b:	eb 01                	jmp    80104b3e <scheduler+0x83>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104b3d:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b3e:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104b42:	81 7d f4 94 49 11 80 	cmpl   $0x80114994,-0xc(%ebp)
80104b49:	72 94                	jb     80104adf <scheduler+0x24>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104b4b:	83 ec 0c             	sub    $0xc,%esp
80104b4e:	68 60 29 11 80       	push   $0x80112960
80104b53:	e8 a5 04 00 00       	call   80104ffd <release>
80104b58:	83 c4 10             	add    $0x10,%esp

  }
80104b5b:	e9 61 ff ff ff       	jmp    80104ac1 <scheduler+0x6>

80104b60 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80104b66:	83 ec 0c             	sub    $0xc,%esp
80104b69:	68 60 29 11 80       	push   $0x80112960
80104b6e:	e8 56 05 00 00       	call   801050c9 <holding>
80104b73:	83 c4 10             	add    $0x10,%esp
80104b76:	85 c0                	test   %eax,%eax
80104b78:	75 0d                	jne    80104b87 <sched+0x27>
    panic("sched ptable.lock");
80104b7a:	83 ec 0c             	sub    $0xc,%esp
80104b7d:	68 1d 89 10 80       	push   $0x8010891d
80104b82:	e8 df b9 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80104b87:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b8d:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104b93:	83 f8 01             	cmp    $0x1,%eax
80104b96:	74 0d                	je     80104ba5 <sched+0x45>
    panic("sched locks");
80104b98:	83 ec 0c             	sub    $0xc,%esp
80104b9b:	68 2f 89 10 80       	push   $0x8010892f
80104ba0:	e8 c1 b9 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80104ba5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bab:	8b 40 10             	mov    0x10(%eax),%eax
80104bae:	83 f8 04             	cmp    $0x4,%eax
80104bb1:	75 0d                	jne    80104bc0 <sched+0x60>
    panic("sched running");
80104bb3:	83 ec 0c             	sub    $0xc,%esp
80104bb6:	68 3b 89 10 80       	push   $0x8010893b
80104bbb:	e8 a6 b9 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
80104bc0:	e8 01 f8 ff ff       	call   801043c6 <readeflags>
80104bc5:	25 00 02 00 00       	and    $0x200,%eax
80104bca:	85 c0                	test   %eax,%eax
80104bcc:	74 0d                	je     80104bdb <sched+0x7b>
    panic("sched interruptible");
80104bce:	83 ec 0c             	sub    $0xc,%esp
80104bd1:	68 49 89 10 80       	push   $0x80108949
80104bd6:	e8 8b b9 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
80104bdb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104be1:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104be7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104bea:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104bf0:	8b 40 04             	mov    0x4(%eax),%eax
80104bf3:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104bfa:	83 c2 20             	add    $0x20,%edx
80104bfd:	83 ec 08             	sub    $0x8,%esp
80104c00:	50                   	push   %eax
80104c01:	52                   	push   %edx
80104c02:	e8 66 08 00 00       	call   8010546d <swtch>
80104c07:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104c0a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c10:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c13:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104c19:	90                   	nop
80104c1a:	c9                   	leave  
80104c1b:	c3                   	ret    

80104c1c <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104c1c:	55                   	push   %ebp
80104c1d:	89 e5                	mov    %esp,%ebp
80104c1f:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104c22:	83 ec 0c             	sub    $0xc,%esp
80104c25:	68 60 29 11 80       	push   $0x80112960
80104c2a:	e8 67 03 00 00       	call   80104f96 <acquire>
80104c2f:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104c32:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c38:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  sched();
80104c3f:	e8 1c ff ff ff       	call   80104b60 <sched>
  release(&ptable.lock);
80104c44:	83 ec 0c             	sub    $0xc,%esp
80104c47:	68 60 29 11 80       	push   $0x80112960
80104c4c:	e8 ac 03 00 00       	call   80104ffd <release>
80104c51:	83 c4 10             	add    $0x10,%esp
}
80104c54:	90                   	nop
80104c55:	c9                   	leave  
80104c56:	c3                   	ret    

80104c57 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104c57:	55                   	push   %ebp
80104c58:	89 e5                	mov    %esp,%ebp
80104c5a:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104c5d:	83 ec 0c             	sub    $0xc,%esp
80104c60:	68 60 29 11 80       	push   $0x80112960
80104c65:	e8 93 03 00 00       	call   80104ffd <release>
80104c6a:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104c6d:	a1 08 b0 10 80       	mov    0x8010b008,%eax
80104c72:	85 c0                	test   %eax,%eax
80104c74:	74 24                	je     80104c9a <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104c76:	c7 05 08 b0 10 80 00 	movl   $0x0,0x8010b008
80104c7d:	00 00 00 
    iinit(ROOTDEV);
80104c80:	83 ec 0c             	sub    $0xc,%esp
80104c83:	6a 01                	push   $0x1
80104c85:	e8 c0 c9 ff ff       	call   8010164a <iinit>
80104c8a:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104c8d:	83 ec 0c             	sub    $0xc,%esp
80104c90:	6a 01                	push   $0x1
80104c92:	e8 5a e6 ff ff       	call   801032f1 <initlog>
80104c97:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104c9a:	90                   	nop
80104c9b:	c9                   	leave  
80104c9c:	c3                   	ret    

80104c9d <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104c9d:	55                   	push   %ebp
80104c9e:	89 e5                	mov    %esp,%ebp
80104ca0:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104ca3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ca9:	85 c0                	test   %eax,%eax
80104cab:	75 0d                	jne    80104cba <sleep+0x1d>
    panic("sleep");
80104cad:	83 ec 0c             	sub    $0xc,%esp
80104cb0:	68 5d 89 10 80       	push   $0x8010895d
80104cb5:	e8 ac b8 ff ff       	call   80100566 <panic>

  if(lk == 0)
80104cba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104cbe:	75 0d                	jne    80104ccd <sleep+0x30>
    panic("sleep without lk");
80104cc0:	83 ec 0c             	sub    $0xc,%esp
80104cc3:	68 63 89 10 80       	push   $0x80108963
80104cc8:	e8 99 b8 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104ccd:	81 7d 0c 60 29 11 80 	cmpl   $0x80112960,0xc(%ebp)
80104cd4:	74 1e                	je     80104cf4 <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104cd6:	83 ec 0c             	sub    $0xc,%esp
80104cd9:	68 60 29 11 80       	push   $0x80112960
80104cde:	e8 b3 02 00 00       	call   80104f96 <acquire>
80104ce3:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104ce6:	83 ec 0c             	sub    $0xc,%esp
80104ce9:	ff 75 0c             	pushl  0xc(%ebp)
80104cec:	e8 0c 03 00 00       	call   80104ffd <release>
80104cf1:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104cf4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cfa:	8b 55 08             	mov    0x8(%ebp),%edx
80104cfd:	89 50 24             	mov    %edx,0x24(%eax)
  proc->state = SLEEPING;
80104d00:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d06:	c7 40 10 02 00 00 00 	movl   $0x2,0x10(%eax)
  sched();
80104d0d:	e8 4e fe ff ff       	call   80104b60 <sched>

  // Tidy up.
  proc->chan = 0;
80104d12:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d18:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104d1f:	81 7d 0c 60 29 11 80 	cmpl   $0x80112960,0xc(%ebp)
80104d26:	74 1e                	je     80104d46 <sleep+0xa9>
    release(&ptable.lock);
80104d28:	83 ec 0c             	sub    $0xc,%esp
80104d2b:	68 60 29 11 80       	push   $0x80112960
80104d30:	e8 c8 02 00 00       	call   80104ffd <release>
80104d35:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104d38:	83 ec 0c             	sub    $0xc,%esp
80104d3b:	ff 75 0c             	pushl  0xc(%ebp)
80104d3e:	e8 53 02 00 00       	call   80104f96 <acquire>
80104d43:	83 c4 10             	add    $0x10,%esp
  }
}
80104d46:	90                   	nop
80104d47:	c9                   	leave  
80104d48:	c3                   	ret    

80104d49 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104d49:	55                   	push   %ebp
80104d4a:	89 e5                	mov    %esp,%ebp
80104d4c:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d4f:	c7 45 fc 94 29 11 80 	movl   $0x80112994,-0x4(%ebp)
80104d56:	eb 24                	jmp    80104d7c <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104d58:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d5b:	8b 40 10             	mov    0x10(%eax),%eax
80104d5e:	83 f8 02             	cmp    $0x2,%eax
80104d61:	75 15                	jne    80104d78 <wakeup1+0x2f>
80104d63:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d66:	8b 40 24             	mov    0x24(%eax),%eax
80104d69:	3b 45 08             	cmp    0x8(%ebp),%eax
80104d6c:	75 0a                	jne    80104d78 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104d6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d71:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d78:	83 6d fc 80          	subl   $0xffffff80,-0x4(%ebp)
80104d7c:	81 7d fc 94 49 11 80 	cmpl   $0x80114994,-0x4(%ebp)
80104d83:	72 d3                	jb     80104d58 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104d85:	90                   	nop
80104d86:	c9                   	leave  
80104d87:	c3                   	ret    

80104d88 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104d88:	55                   	push   %ebp
80104d89:	89 e5                	mov    %esp,%ebp
80104d8b:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104d8e:	83 ec 0c             	sub    $0xc,%esp
80104d91:	68 60 29 11 80       	push   $0x80112960
80104d96:	e8 fb 01 00 00       	call   80104f96 <acquire>
80104d9b:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104d9e:	83 ec 0c             	sub    $0xc,%esp
80104da1:	ff 75 08             	pushl  0x8(%ebp)
80104da4:	e8 a0 ff ff ff       	call   80104d49 <wakeup1>
80104da9:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104dac:	83 ec 0c             	sub    $0xc,%esp
80104daf:	68 60 29 11 80       	push   $0x80112960
80104db4:	e8 44 02 00 00       	call   80104ffd <release>
80104db9:	83 c4 10             	add    $0x10,%esp
}
80104dbc:	90                   	nop
80104dbd:	c9                   	leave  
80104dbe:	c3                   	ret    

80104dbf <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104dbf:	55                   	push   %ebp
80104dc0:	89 e5                	mov    %esp,%ebp
80104dc2:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104dc5:	83 ec 0c             	sub    $0xc,%esp
80104dc8:	68 60 29 11 80       	push   $0x80112960
80104dcd:	e8 c4 01 00 00       	call   80104f96 <acquire>
80104dd2:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104dd5:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104ddc:	eb 45                	jmp    80104e23 <kill+0x64>
    if(p->pid == pid){
80104dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104de1:	8b 40 14             	mov    0x14(%eax),%eax
80104de4:	3b 45 08             	cmp    0x8(%ebp),%eax
80104de7:	75 36                	jne    80104e1f <kill+0x60>
      p->killed = 1;
80104de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dec:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104df6:	8b 40 10             	mov    0x10(%eax),%eax
80104df9:	83 f8 02             	cmp    $0x2,%eax
80104dfc:	75 0a                	jne    80104e08 <kill+0x49>
        p->state = RUNNABLE;
80104dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e01:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
      release(&ptable.lock);
80104e08:	83 ec 0c             	sub    $0xc,%esp
80104e0b:	68 60 29 11 80       	push   $0x80112960
80104e10:	e8 e8 01 00 00       	call   80104ffd <release>
80104e15:	83 c4 10             	add    $0x10,%esp
      return 0;
80104e18:	b8 00 00 00 00       	mov    $0x0,%eax
80104e1d:	eb 22                	jmp    80104e41 <kill+0x82>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e1f:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104e23:	81 7d f4 94 49 11 80 	cmpl   $0x80114994,-0xc(%ebp)
80104e2a:	72 b2                	jb     80104dde <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104e2c:	83 ec 0c             	sub    $0xc,%esp
80104e2f:	68 60 29 11 80       	push   $0x80112960
80104e34:	e8 c4 01 00 00       	call   80104ffd <release>
80104e39:	83 c4 10             	add    $0x10,%esp
  return -1;
80104e3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e41:	c9                   	leave  
80104e42:	c3                   	ret    

80104e43 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104e43:	55                   	push   %ebp
80104e44:	89 e5                	mov    %esp,%ebp
80104e46:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e49:	c7 45 f0 94 29 11 80 	movl   $0x80112994,-0x10(%ebp)
80104e50:	e9 d7 00 00 00       	jmp    80104f2c <procdump+0xe9>
    if(p->state == UNUSED)
80104e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e58:	8b 40 10             	mov    0x10(%eax),%eax
80104e5b:	85 c0                	test   %eax,%eax
80104e5d:	0f 84 c4 00 00 00    	je     80104f27 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104e63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e66:	8b 40 10             	mov    0x10(%eax),%eax
80104e69:	83 f8 05             	cmp    $0x5,%eax
80104e6c:	77 23                	ja     80104e91 <procdump+0x4e>
80104e6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e71:	8b 40 10             	mov    0x10(%eax),%eax
80104e74:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104e7b:	85 c0                	test   %eax,%eax
80104e7d:	74 12                	je     80104e91 <procdump+0x4e>
      state = states[p->state];
80104e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e82:	8b 40 10             	mov    0x10(%eax),%eax
80104e85:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104e8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104e8f:	eb 07                	jmp    80104e98 <procdump+0x55>
    else
      state = "???";
80104e91:	c7 45 ec 74 89 10 80 	movl   $0x80108974,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e9b:	8d 50 70             	lea    0x70(%eax),%edx
80104e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ea1:	8b 40 14             	mov    0x14(%eax),%eax
80104ea4:	52                   	push   %edx
80104ea5:	ff 75 ec             	pushl  -0x14(%ebp)
80104ea8:	50                   	push   %eax
80104ea9:	68 78 89 10 80       	push   $0x80108978
80104eae:	e8 13 b5 ff ff       	call   801003c6 <cprintf>
80104eb3:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80104eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104eb9:	8b 40 10             	mov    0x10(%eax),%eax
80104ebc:	83 f8 02             	cmp    $0x2,%eax
80104ebf:	75 54                	jne    80104f15 <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104ec1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ec4:	8b 40 20             	mov    0x20(%eax),%eax
80104ec7:	8b 40 0c             	mov    0xc(%eax),%eax
80104eca:	83 c0 08             	add    $0x8,%eax
80104ecd:	89 c2                	mov    %eax,%edx
80104ecf:	83 ec 08             	sub    $0x8,%esp
80104ed2:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104ed5:	50                   	push   %eax
80104ed6:	52                   	push   %edx
80104ed7:	e8 73 01 00 00       	call   8010504f <getcallerpcs>
80104edc:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104edf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104ee6:	eb 1c                	jmp    80104f04 <procdump+0xc1>
        cprintf(" %p", pc[i]);
80104ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eeb:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104eef:	83 ec 08             	sub    $0x8,%esp
80104ef2:	50                   	push   %eax
80104ef3:	68 81 89 10 80       	push   $0x80108981
80104ef8:	e8 c9 b4 ff ff       	call   801003c6 <cprintf>
80104efd:	83 c4 10             	add    $0x10,%esp
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104f00:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104f04:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104f08:	7f 0b                	jg     80104f15 <procdump+0xd2>
80104f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f0d:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104f11:	85 c0                	test   %eax,%eax
80104f13:	75 d3                	jne    80104ee8 <procdump+0xa5>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104f15:	83 ec 0c             	sub    $0xc,%esp
80104f18:	68 85 89 10 80       	push   $0x80108985
80104f1d:	e8 a4 b4 ff ff       	call   801003c6 <cprintf>
80104f22:	83 c4 10             	add    $0x10,%esp
80104f25:	eb 01                	jmp    80104f28 <procdump+0xe5>
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80104f27:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f28:	83 6d f0 80          	subl   $0xffffff80,-0x10(%ebp)
80104f2c:	81 7d f0 94 49 11 80 	cmpl   $0x80114994,-0x10(%ebp)
80104f33:	0f 82 1c ff ff ff    	jb     80104e55 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104f39:	90                   	nop
80104f3a:	c9                   	leave  
80104f3b:	c3                   	ret    

80104f3c <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104f3c:	55                   	push   %ebp
80104f3d:	89 e5                	mov    %esp,%ebp
80104f3f:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104f42:	9c                   	pushf  
80104f43:	58                   	pop    %eax
80104f44:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104f47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f4a:	c9                   	leave  
80104f4b:	c3                   	ret    

80104f4c <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104f4c:	55                   	push   %ebp
80104f4d:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104f4f:	fa                   	cli    
}
80104f50:	90                   	nop
80104f51:	5d                   	pop    %ebp
80104f52:	c3                   	ret    

80104f53 <sti>:

static inline void
sti(void)
{
80104f53:	55                   	push   %ebp
80104f54:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104f56:	fb                   	sti    
}
80104f57:	90                   	nop
80104f58:	5d                   	pop    %ebp
80104f59:	c3                   	ret    

80104f5a <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104f5a:	55                   	push   %ebp
80104f5b:	89 e5                	mov    %esp,%ebp
80104f5d:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104f60:	8b 55 08             	mov    0x8(%ebp),%edx
80104f63:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f66:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f69:	f0 87 02             	lock xchg %eax,(%edx)
80104f6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104f6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f72:	c9                   	leave  
80104f73:	c3                   	ret    

80104f74 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104f74:	55                   	push   %ebp
80104f75:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104f77:	8b 45 08             	mov    0x8(%ebp),%eax
80104f7a:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f7d:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104f80:	8b 45 08             	mov    0x8(%ebp),%eax
80104f83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104f89:	8b 45 08             	mov    0x8(%ebp),%eax
80104f8c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104f93:	90                   	nop
80104f94:	5d                   	pop    %ebp
80104f95:	c3                   	ret    

80104f96 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104f96:	55                   	push   %ebp
80104f97:	89 e5                	mov    %esp,%ebp
80104f99:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104f9c:	e8 52 01 00 00       	call   801050f3 <pushcli>
  if(holding(lk))
80104fa1:	8b 45 08             	mov    0x8(%ebp),%eax
80104fa4:	83 ec 0c             	sub    $0xc,%esp
80104fa7:	50                   	push   %eax
80104fa8:	e8 1c 01 00 00       	call   801050c9 <holding>
80104fad:	83 c4 10             	add    $0x10,%esp
80104fb0:	85 c0                	test   %eax,%eax
80104fb2:	74 0d                	je     80104fc1 <acquire+0x2b>
    panic("acquire");
80104fb4:	83 ec 0c             	sub    $0xc,%esp
80104fb7:	68 b1 89 10 80       	push   $0x801089b1
80104fbc:	e8 a5 b5 ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104fc1:	90                   	nop
80104fc2:	8b 45 08             	mov    0x8(%ebp),%eax
80104fc5:	83 ec 08             	sub    $0x8,%esp
80104fc8:	6a 01                	push   $0x1
80104fca:	50                   	push   %eax
80104fcb:	e8 8a ff ff ff       	call   80104f5a <xchg>
80104fd0:	83 c4 10             	add    $0x10,%esp
80104fd3:	85 c0                	test   %eax,%eax
80104fd5:	75 eb                	jne    80104fc2 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104fd7:	8b 45 08             	mov    0x8(%ebp),%eax
80104fda:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104fe1:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104fe4:	8b 45 08             	mov    0x8(%ebp),%eax
80104fe7:	83 c0 0c             	add    $0xc,%eax
80104fea:	83 ec 08             	sub    $0x8,%esp
80104fed:	50                   	push   %eax
80104fee:	8d 45 08             	lea    0x8(%ebp),%eax
80104ff1:	50                   	push   %eax
80104ff2:	e8 58 00 00 00       	call   8010504f <getcallerpcs>
80104ff7:	83 c4 10             	add    $0x10,%esp
}
80104ffa:	90                   	nop
80104ffb:	c9                   	leave  
80104ffc:	c3                   	ret    

80104ffd <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104ffd:	55                   	push   %ebp
80104ffe:	89 e5                	mov    %esp,%ebp
80105000:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80105003:	83 ec 0c             	sub    $0xc,%esp
80105006:	ff 75 08             	pushl  0x8(%ebp)
80105009:	e8 bb 00 00 00       	call   801050c9 <holding>
8010500e:	83 c4 10             	add    $0x10,%esp
80105011:	85 c0                	test   %eax,%eax
80105013:	75 0d                	jne    80105022 <release+0x25>
    panic("release");
80105015:	83 ec 0c             	sub    $0xc,%esp
80105018:	68 b9 89 10 80       	push   $0x801089b9
8010501d:	e8 44 b5 ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
80105022:	8b 45 08             	mov    0x8(%ebp),%eax
80105025:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
8010502c:	8b 45 08             	mov    0x8(%ebp),%eax
8010502f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80105036:	8b 45 08             	mov    0x8(%ebp),%eax
80105039:	83 ec 08             	sub    $0x8,%esp
8010503c:	6a 00                	push   $0x0
8010503e:	50                   	push   %eax
8010503f:	e8 16 ff ff ff       	call   80104f5a <xchg>
80105044:	83 c4 10             	add    $0x10,%esp

  popcli();
80105047:	e8 ec 00 00 00       	call   80105138 <popcli>
}
8010504c:	90                   	nop
8010504d:	c9                   	leave  
8010504e:	c3                   	ret    

8010504f <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
8010504f:	55                   	push   %ebp
80105050:	89 e5                	mov    %esp,%ebp
80105052:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105055:	8b 45 08             	mov    0x8(%ebp),%eax
80105058:	83 e8 08             	sub    $0x8,%eax
8010505b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010505e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105065:	eb 38                	jmp    8010509f <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105067:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010506b:	74 53                	je     801050c0 <getcallerpcs+0x71>
8010506d:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105074:	76 4a                	jbe    801050c0 <getcallerpcs+0x71>
80105076:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
8010507a:	74 44                	je     801050c0 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010507c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010507f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105086:	8b 45 0c             	mov    0xc(%ebp),%eax
80105089:	01 c2                	add    %eax,%edx
8010508b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010508e:	8b 40 04             	mov    0x4(%eax),%eax
80105091:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105093:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105096:	8b 00                	mov    (%eax),%eax
80105098:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010509b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010509f:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801050a3:	7e c2                	jle    80105067 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801050a5:	eb 19                	jmp    801050c0 <getcallerpcs+0x71>
    pcs[i] = 0;
801050a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
801050aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801050b1:	8b 45 0c             	mov    0xc(%ebp),%eax
801050b4:	01 d0                	add    %edx,%eax
801050b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801050bc:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801050c0:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801050c4:	7e e1                	jle    801050a7 <getcallerpcs+0x58>
    pcs[i] = 0;
}
801050c6:	90                   	nop
801050c7:	c9                   	leave  
801050c8:	c3                   	ret    

801050c9 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801050c9:	55                   	push   %ebp
801050ca:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801050cc:	8b 45 08             	mov    0x8(%ebp),%eax
801050cf:	8b 00                	mov    (%eax),%eax
801050d1:	85 c0                	test   %eax,%eax
801050d3:	74 17                	je     801050ec <holding+0x23>
801050d5:	8b 45 08             	mov    0x8(%ebp),%eax
801050d8:	8b 50 08             	mov    0x8(%eax),%edx
801050db:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801050e1:	39 c2                	cmp    %eax,%edx
801050e3:	75 07                	jne    801050ec <holding+0x23>
801050e5:	b8 01 00 00 00       	mov    $0x1,%eax
801050ea:	eb 05                	jmp    801050f1 <holding+0x28>
801050ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
801050f1:	5d                   	pop    %ebp
801050f2:	c3                   	ret    

801050f3 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801050f3:	55                   	push   %ebp
801050f4:	89 e5                	mov    %esp,%ebp
801050f6:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801050f9:	e8 3e fe ff ff       	call   80104f3c <readeflags>
801050fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80105101:	e8 46 fe ff ff       	call   80104f4c <cli>
  if(cpu->ncli++ == 0)
80105106:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010510d:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80105113:	8d 48 01             	lea    0x1(%eax),%ecx
80105116:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
8010511c:	85 c0                	test   %eax,%eax
8010511e:	75 15                	jne    80105135 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80105120:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105126:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105129:	81 e2 00 02 00 00    	and    $0x200,%edx
8010512f:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105135:	90                   	nop
80105136:	c9                   	leave  
80105137:	c3                   	ret    

80105138 <popcli>:

void
popcli(void)
{
80105138:	55                   	push   %ebp
80105139:	89 e5                	mov    %esp,%ebp
8010513b:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
8010513e:	e8 f9 fd ff ff       	call   80104f3c <readeflags>
80105143:	25 00 02 00 00       	and    $0x200,%eax
80105148:	85 c0                	test   %eax,%eax
8010514a:	74 0d                	je     80105159 <popcli+0x21>
    panic("popcli - interruptible");
8010514c:	83 ec 0c             	sub    $0xc,%esp
8010514f:	68 c1 89 10 80       	push   $0x801089c1
80105154:	e8 0d b4 ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
80105159:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010515f:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105165:	83 ea 01             	sub    $0x1,%edx
80105168:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
8010516e:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105174:	85 c0                	test   %eax,%eax
80105176:	79 0d                	jns    80105185 <popcli+0x4d>
    panic("popcli");
80105178:	83 ec 0c             	sub    $0xc,%esp
8010517b:	68 d8 89 10 80       	push   $0x801089d8
80105180:	e8 e1 b3 ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105185:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010518b:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105191:	85 c0                	test   %eax,%eax
80105193:	75 15                	jne    801051aa <popcli+0x72>
80105195:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010519b:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801051a1:	85 c0                	test   %eax,%eax
801051a3:	74 05                	je     801051aa <popcli+0x72>
    sti();
801051a5:	e8 a9 fd ff ff       	call   80104f53 <sti>
}
801051aa:	90                   	nop
801051ab:	c9                   	leave  
801051ac:	c3                   	ret    

801051ad <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
801051ad:	55                   	push   %ebp
801051ae:	89 e5                	mov    %esp,%ebp
801051b0:	57                   	push   %edi
801051b1:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801051b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
801051b5:	8b 55 10             	mov    0x10(%ebp),%edx
801051b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801051bb:	89 cb                	mov    %ecx,%ebx
801051bd:	89 df                	mov    %ebx,%edi
801051bf:	89 d1                	mov    %edx,%ecx
801051c1:	fc                   	cld    
801051c2:	f3 aa                	rep stos %al,%es:(%edi)
801051c4:	89 ca                	mov    %ecx,%edx
801051c6:	89 fb                	mov    %edi,%ebx
801051c8:	89 5d 08             	mov    %ebx,0x8(%ebp)
801051cb:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801051ce:	90                   	nop
801051cf:	5b                   	pop    %ebx
801051d0:	5f                   	pop    %edi
801051d1:	5d                   	pop    %ebp
801051d2:	c3                   	ret    

801051d3 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801051d3:	55                   	push   %ebp
801051d4:	89 e5                	mov    %esp,%ebp
801051d6:	57                   	push   %edi
801051d7:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801051d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801051db:	8b 55 10             	mov    0x10(%ebp),%edx
801051de:	8b 45 0c             	mov    0xc(%ebp),%eax
801051e1:	89 cb                	mov    %ecx,%ebx
801051e3:	89 df                	mov    %ebx,%edi
801051e5:	89 d1                	mov    %edx,%ecx
801051e7:	fc                   	cld    
801051e8:	f3 ab                	rep stos %eax,%es:(%edi)
801051ea:	89 ca                	mov    %ecx,%edx
801051ec:	89 fb                	mov    %edi,%ebx
801051ee:	89 5d 08             	mov    %ebx,0x8(%ebp)
801051f1:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801051f4:	90                   	nop
801051f5:	5b                   	pop    %ebx
801051f6:	5f                   	pop    %edi
801051f7:	5d                   	pop    %ebp
801051f8:	c3                   	ret    

801051f9 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801051f9:	55                   	push   %ebp
801051fa:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
801051fc:	8b 45 08             	mov    0x8(%ebp),%eax
801051ff:	83 e0 03             	and    $0x3,%eax
80105202:	85 c0                	test   %eax,%eax
80105204:	75 43                	jne    80105249 <memset+0x50>
80105206:	8b 45 10             	mov    0x10(%ebp),%eax
80105209:	83 e0 03             	and    $0x3,%eax
8010520c:	85 c0                	test   %eax,%eax
8010520e:	75 39                	jne    80105249 <memset+0x50>
    c &= 0xFF;
80105210:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105217:	8b 45 10             	mov    0x10(%ebp),%eax
8010521a:	c1 e8 02             	shr    $0x2,%eax
8010521d:	89 c1                	mov    %eax,%ecx
8010521f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105222:	c1 e0 18             	shl    $0x18,%eax
80105225:	89 c2                	mov    %eax,%edx
80105227:	8b 45 0c             	mov    0xc(%ebp),%eax
8010522a:	c1 e0 10             	shl    $0x10,%eax
8010522d:	09 c2                	or     %eax,%edx
8010522f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105232:	c1 e0 08             	shl    $0x8,%eax
80105235:	09 d0                	or     %edx,%eax
80105237:	0b 45 0c             	or     0xc(%ebp),%eax
8010523a:	51                   	push   %ecx
8010523b:	50                   	push   %eax
8010523c:	ff 75 08             	pushl  0x8(%ebp)
8010523f:	e8 8f ff ff ff       	call   801051d3 <stosl>
80105244:	83 c4 0c             	add    $0xc,%esp
80105247:	eb 12                	jmp    8010525b <memset+0x62>
  } else
    stosb(dst, c, n);
80105249:	8b 45 10             	mov    0x10(%ebp),%eax
8010524c:	50                   	push   %eax
8010524d:	ff 75 0c             	pushl  0xc(%ebp)
80105250:	ff 75 08             	pushl  0x8(%ebp)
80105253:	e8 55 ff ff ff       	call   801051ad <stosb>
80105258:	83 c4 0c             	add    $0xc,%esp
  return dst;
8010525b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010525e:	c9                   	leave  
8010525f:	c3                   	ret    

80105260 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105266:	8b 45 08             	mov    0x8(%ebp),%eax
80105269:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
8010526c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010526f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105272:	eb 30                	jmp    801052a4 <memcmp+0x44>
    if(*s1 != *s2)
80105274:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105277:	0f b6 10             	movzbl (%eax),%edx
8010527a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010527d:	0f b6 00             	movzbl (%eax),%eax
80105280:	38 c2                	cmp    %al,%dl
80105282:	74 18                	je     8010529c <memcmp+0x3c>
      return *s1 - *s2;
80105284:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105287:	0f b6 00             	movzbl (%eax),%eax
8010528a:	0f b6 d0             	movzbl %al,%edx
8010528d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105290:	0f b6 00             	movzbl (%eax),%eax
80105293:	0f b6 c0             	movzbl %al,%eax
80105296:	29 c2                	sub    %eax,%edx
80105298:	89 d0                	mov    %edx,%eax
8010529a:	eb 1a                	jmp    801052b6 <memcmp+0x56>
    s1++, s2++;
8010529c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801052a0:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801052a4:	8b 45 10             	mov    0x10(%ebp),%eax
801052a7:	8d 50 ff             	lea    -0x1(%eax),%edx
801052aa:	89 55 10             	mov    %edx,0x10(%ebp)
801052ad:	85 c0                	test   %eax,%eax
801052af:	75 c3                	jne    80105274 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801052b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801052b6:	c9                   	leave  
801052b7:	c3                   	ret    

801052b8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801052b8:	55                   	push   %ebp
801052b9:	89 e5                	mov    %esp,%ebp
801052bb:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801052be:	8b 45 0c             	mov    0xc(%ebp),%eax
801052c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801052c4:	8b 45 08             	mov    0x8(%ebp),%eax
801052c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801052ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052cd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801052d0:	73 54                	jae    80105326 <memmove+0x6e>
801052d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
801052d5:	8b 45 10             	mov    0x10(%ebp),%eax
801052d8:	01 d0                	add    %edx,%eax
801052da:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801052dd:	76 47                	jbe    80105326 <memmove+0x6e>
    s += n;
801052df:	8b 45 10             	mov    0x10(%ebp),%eax
801052e2:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801052e5:	8b 45 10             	mov    0x10(%ebp),%eax
801052e8:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801052eb:	eb 13                	jmp    80105300 <memmove+0x48>
      *--d = *--s;
801052ed:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801052f1:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801052f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052f8:	0f b6 10             	movzbl (%eax),%edx
801052fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052fe:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105300:	8b 45 10             	mov    0x10(%ebp),%eax
80105303:	8d 50 ff             	lea    -0x1(%eax),%edx
80105306:	89 55 10             	mov    %edx,0x10(%ebp)
80105309:	85 c0                	test   %eax,%eax
8010530b:	75 e0                	jne    801052ed <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010530d:	eb 24                	jmp    80105333 <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
8010530f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105312:	8d 50 01             	lea    0x1(%eax),%edx
80105315:	89 55 f8             	mov    %edx,-0x8(%ebp)
80105318:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010531b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010531e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105321:	0f b6 12             	movzbl (%edx),%edx
80105324:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105326:	8b 45 10             	mov    0x10(%ebp),%eax
80105329:	8d 50 ff             	lea    -0x1(%eax),%edx
8010532c:	89 55 10             	mov    %edx,0x10(%ebp)
8010532f:	85 c0                	test   %eax,%eax
80105331:	75 dc                	jne    8010530f <memmove+0x57>
      *d++ = *s++;

  return dst;
80105333:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105336:	c9                   	leave  
80105337:	c3                   	ret    

80105338 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105338:	55                   	push   %ebp
80105339:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
8010533b:	ff 75 10             	pushl  0x10(%ebp)
8010533e:	ff 75 0c             	pushl  0xc(%ebp)
80105341:	ff 75 08             	pushl  0x8(%ebp)
80105344:	e8 6f ff ff ff       	call   801052b8 <memmove>
80105349:	83 c4 0c             	add    $0xc,%esp
}
8010534c:	c9                   	leave  
8010534d:	c3                   	ret    

8010534e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
8010534e:	55                   	push   %ebp
8010534f:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105351:	eb 0c                	jmp    8010535f <strncmp+0x11>
    n--, p++, q++;
80105353:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105357:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010535b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010535f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105363:	74 1a                	je     8010537f <strncmp+0x31>
80105365:	8b 45 08             	mov    0x8(%ebp),%eax
80105368:	0f b6 00             	movzbl (%eax),%eax
8010536b:	84 c0                	test   %al,%al
8010536d:	74 10                	je     8010537f <strncmp+0x31>
8010536f:	8b 45 08             	mov    0x8(%ebp),%eax
80105372:	0f b6 10             	movzbl (%eax),%edx
80105375:	8b 45 0c             	mov    0xc(%ebp),%eax
80105378:	0f b6 00             	movzbl (%eax),%eax
8010537b:	38 c2                	cmp    %al,%dl
8010537d:	74 d4                	je     80105353 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
8010537f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105383:	75 07                	jne    8010538c <strncmp+0x3e>
    return 0;
80105385:	b8 00 00 00 00       	mov    $0x0,%eax
8010538a:	eb 16                	jmp    801053a2 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
8010538c:	8b 45 08             	mov    0x8(%ebp),%eax
8010538f:	0f b6 00             	movzbl (%eax),%eax
80105392:	0f b6 d0             	movzbl %al,%edx
80105395:	8b 45 0c             	mov    0xc(%ebp),%eax
80105398:	0f b6 00             	movzbl (%eax),%eax
8010539b:	0f b6 c0             	movzbl %al,%eax
8010539e:	29 c2                	sub    %eax,%edx
801053a0:	89 d0                	mov    %edx,%eax
}
801053a2:	5d                   	pop    %ebp
801053a3:	c3                   	ret    

801053a4 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801053a4:	55                   	push   %ebp
801053a5:	89 e5                	mov    %esp,%ebp
801053a7:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801053aa:	8b 45 08             	mov    0x8(%ebp),%eax
801053ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801053b0:	90                   	nop
801053b1:	8b 45 10             	mov    0x10(%ebp),%eax
801053b4:	8d 50 ff             	lea    -0x1(%eax),%edx
801053b7:	89 55 10             	mov    %edx,0x10(%ebp)
801053ba:	85 c0                	test   %eax,%eax
801053bc:	7e 2c                	jle    801053ea <strncpy+0x46>
801053be:	8b 45 08             	mov    0x8(%ebp),%eax
801053c1:	8d 50 01             	lea    0x1(%eax),%edx
801053c4:	89 55 08             	mov    %edx,0x8(%ebp)
801053c7:	8b 55 0c             	mov    0xc(%ebp),%edx
801053ca:	8d 4a 01             	lea    0x1(%edx),%ecx
801053cd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801053d0:	0f b6 12             	movzbl (%edx),%edx
801053d3:	88 10                	mov    %dl,(%eax)
801053d5:	0f b6 00             	movzbl (%eax),%eax
801053d8:	84 c0                	test   %al,%al
801053da:	75 d5                	jne    801053b1 <strncpy+0xd>
    ;
  while(n-- > 0)
801053dc:	eb 0c                	jmp    801053ea <strncpy+0x46>
    *s++ = 0;
801053de:	8b 45 08             	mov    0x8(%ebp),%eax
801053e1:	8d 50 01             	lea    0x1(%eax),%edx
801053e4:	89 55 08             	mov    %edx,0x8(%ebp)
801053e7:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801053ea:	8b 45 10             	mov    0x10(%ebp),%eax
801053ed:	8d 50 ff             	lea    -0x1(%eax),%edx
801053f0:	89 55 10             	mov    %edx,0x10(%ebp)
801053f3:	85 c0                	test   %eax,%eax
801053f5:	7f e7                	jg     801053de <strncpy+0x3a>
    *s++ = 0;
  return os;
801053f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053fa:	c9                   	leave  
801053fb:	c3                   	ret    

801053fc <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801053fc:	55                   	push   %ebp
801053fd:	89 e5                	mov    %esp,%ebp
801053ff:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105402:	8b 45 08             	mov    0x8(%ebp),%eax
80105405:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105408:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010540c:	7f 05                	jg     80105413 <safestrcpy+0x17>
    return os;
8010540e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105411:	eb 31                	jmp    80105444 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105413:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105417:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010541b:	7e 1e                	jle    8010543b <safestrcpy+0x3f>
8010541d:	8b 45 08             	mov    0x8(%ebp),%eax
80105420:	8d 50 01             	lea    0x1(%eax),%edx
80105423:	89 55 08             	mov    %edx,0x8(%ebp)
80105426:	8b 55 0c             	mov    0xc(%ebp),%edx
80105429:	8d 4a 01             	lea    0x1(%edx),%ecx
8010542c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010542f:	0f b6 12             	movzbl (%edx),%edx
80105432:	88 10                	mov    %dl,(%eax)
80105434:	0f b6 00             	movzbl (%eax),%eax
80105437:	84 c0                	test   %al,%al
80105439:	75 d8                	jne    80105413 <safestrcpy+0x17>
    ;
  *s = 0;
8010543b:	8b 45 08             	mov    0x8(%ebp),%eax
8010543e:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105441:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105444:	c9                   	leave  
80105445:	c3                   	ret    

80105446 <strlen>:

int
strlen(const char *s)
{
80105446:	55                   	push   %ebp
80105447:	89 e5                	mov    %esp,%ebp
80105449:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
8010544c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105453:	eb 04                	jmp    80105459 <strlen+0x13>
80105455:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105459:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010545c:	8b 45 08             	mov    0x8(%ebp),%eax
8010545f:	01 d0                	add    %edx,%eax
80105461:	0f b6 00             	movzbl (%eax),%eax
80105464:	84 c0                	test   %al,%al
80105466:	75 ed                	jne    80105455 <strlen+0xf>
    ;
  return n;
80105468:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010546b:	c9                   	leave  
8010546c:	c3                   	ret    

8010546d <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010546d:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105471:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105475:	55                   	push   %ebp
  pushl %ebx
80105476:	53                   	push   %ebx
  pushl %esi
80105477:	56                   	push   %esi
  pushl %edi
80105478:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105479:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
8010547b:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010547d:	5f                   	pop    %edi
  popl %esi
8010547e:	5e                   	pop    %esi
  popl %ebx
8010547f:	5b                   	pop    %ebx
  popl %ebp
80105480:	5d                   	pop    %ebp
  ret
80105481:	c3                   	ret    

80105482 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105482:	55                   	push   %ebp
80105483:	89 e5                	mov    %esp,%ebp
  if(addr >= KERNBASE || addr+4 > KERNBASE)
80105485:	8b 45 08             	mov    0x8(%ebp),%eax
80105488:	85 c0                	test   %eax,%eax
8010548a:	78 0d                	js     80105499 <fetchint+0x17>
8010548c:	8b 45 08             	mov    0x8(%ebp),%eax
8010548f:	83 c0 04             	add    $0x4,%eax
80105492:	3d 00 00 00 80       	cmp    $0x80000000,%eax
80105497:	76 07                	jbe    801054a0 <fetchint+0x1e>
    return -1;
80105499:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010549e:	eb 0f                	jmp    801054af <fetchint+0x2d>
  *ip = *(int*)(addr);
801054a0:	8b 45 08             	mov    0x8(%ebp),%eax
801054a3:	8b 10                	mov    (%eax),%edx
801054a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801054a8:	89 10                	mov    %edx,(%eax)
  return 0;
801054aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
801054af:	5d                   	pop    %ebp
801054b0:	c3                   	ret    

801054b1 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801054b1:	55                   	push   %ebp
801054b2:	89 e5                	mov    %esp,%ebp
801054b4:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= KERNBASE)
801054b7:	8b 45 08             	mov    0x8(%ebp),%eax
801054ba:	85 c0                	test   %eax,%eax
801054bc:	79 07                	jns    801054c5 <fetchstr+0x14>
    return -1;
801054be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054c3:	eb 42                	jmp    80105507 <fetchstr+0x56>
  *pp = (char*)addr;
801054c5:	8b 55 08             	mov    0x8(%ebp),%edx
801054c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801054cb:	89 10                	mov    %edx,(%eax)
  ep = (char*)KERNBASE;
801054cd:	c7 45 f8 00 00 00 80 	movl   $0x80000000,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
801054d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801054d7:	8b 00                	mov    (%eax),%eax
801054d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
801054dc:	eb 1c                	jmp    801054fa <fetchstr+0x49>
    if(*s == 0)
801054de:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054e1:	0f b6 00             	movzbl (%eax),%eax
801054e4:	84 c0                	test   %al,%al
801054e6:	75 0e                	jne    801054f6 <fetchstr+0x45>
      return s - *pp;
801054e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
801054eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801054ee:	8b 00                	mov    (%eax),%eax
801054f0:	29 c2                	sub    %eax,%edx
801054f2:	89 d0                	mov    %edx,%eax
801054f4:	eb 11                	jmp    80105507 <fetchstr+0x56>

  if(addr >= KERNBASE)
    return -1;
  *pp = (char*)addr;
  ep = (char*)KERNBASE;
  for(s = *pp; s < ep; s++)
801054f6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801054fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054fd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105500:	72 dc                	jb     801054de <fetchstr+0x2d>
    if(*s == 0)
      return s - *pp;
  return -1;
80105502:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105507:	c9                   	leave  
80105508:	c3                   	ret    

80105509 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105509:	55                   	push   %ebp
8010550a:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010550c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105512:	8b 40 1c             	mov    0x1c(%eax),%eax
80105515:	8b 40 44             	mov    0x44(%eax),%eax
80105518:	8b 55 08             	mov    0x8(%ebp),%edx
8010551b:	c1 e2 02             	shl    $0x2,%edx
8010551e:	01 d0                	add    %edx,%eax
80105520:	83 c0 04             	add    $0x4,%eax
80105523:	ff 75 0c             	pushl  0xc(%ebp)
80105526:	50                   	push   %eax
80105527:	e8 56 ff ff ff       	call   80105482 <fetchint>
8010552c:	83 c4 08             	add    $0x8,%esp
}
8010552f:	c9                   	leave  
80105530:	c3                   	ret    

80105531 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105531:	55                   	push   %ebp
80105532:	89 e5                	mov    %esp,%ebp
80105534:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105537:	8d 45 fc             	lea    -0x4(%ebp),%eax
8010553a:	50                   	push   %eax
8010553b:	ff 75 08             	pushl  0x8(%ebp)
8010553e:	e8 c6 ff ff ff       	call   80105509 <argint>
80105543:	83 c4 08             	add    $0x8,%esp
80105546:	85 c0                	test   %eax,%eax
80105548:	79 07                	jns    80105551 <argptr+0x20>
    return -1;
8010554a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010554f:	eb 2e                	jmp    8010557f <argptr+0x4e>
  if((uint)i >= KERNBASE|| (uint)i+size > KERNBASE)
80105551:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105554:	85 c0                	test   %eax,%eax
80105556:	78 11                	js     80105569 <argptr+0x38>
80105558:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010555b:	89 c2                	mov    %eax,%edx
8010555d:	8b 45 10             	mov    0x10(%ebp),%eax
80105560:	01 d0                	add    %edx,%eax
80105562:	3d 00 00 00 80       	cmp    $0x80000000,%eax
80105567:	76 07                	jbe    80105570 <argptr+0x3f>
    return -1;
80105569:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010556e:	eb 0f                	jmp    8010557f <argptr+0x4e>
  *pp = (char*)i;
80105570:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105573:	89 c2                	mov    %eax,%edx
80105575:	8b 45 0c             	mov    0xc(%ebp),%eax
80105578:	89 10                	mov    %edx,(%eax)
  return 0;
8010557a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010557f:	c9                   	leave  
80105580:	c3                   	ret    

80105581 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105581:	55                   	push   %ebp
80105582:	89 e5                	mov    %esp,%ebp
80105584:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105587:	8d 45 fc             	lea    -0x4(%ebp),%eax
8010558a:	50                   	push   %eax
8010558b:	ff 75 08             	pushl  0x8(%ebp)
8010558e:	e8 76 ff ff ff       	call   80105509 <argint>
80105593:	83 c4 08             	add    $0x8,%esp
80105596:	85 c0                	test   %eax,%eax
80105598:	79 07                	jns    801055a1 <argstr+0x20>
    return -1;
8010559a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010559f:	eb 0f                	jmp    801055b0 <argstr+0x2f>
  return fetchstr(addr, pp);
801055a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055a4:	ff 75 0c             	pushl  0xc(%ebp)
801055a7:	50                   	push   %eax
801055a8:	e8 04 ff ff ff       	call   801054b1 <fetchstr>
801055ad:	83 c4 08             	add    $0x8,%esp
}
801055b0:	c9                   	leave  
801055b1:	c3                   	ret    

801055b2 <syscall>:
[SYS_halt]    sys_halt,
};

void
syscall(void)
{
801055b2:	55                   	push   %ebp
801055b3:	89 e5                	mov    %esp,%ebp
801055b5:	53                   	push   %ebx
801055b6:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
801055b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055bf:	8b 40 1c             	mov    0x1c(%eax),%eax
801055c2:	8b 40 1c             	mov    0x1c(%eax),%eax
801055c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801055c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801055cc:	7e 30                	jle    801055fe <syscall+0x4c>
801055ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055d1:	83 f8 16             	cmp    $0x16,%eax
801055d4:	77 28                	ja     801055fe <syscall+0x4c>
801055d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055d9:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801055e0:	85 c0                	test   %eax,%eax
801055e2:	74 1a                	je     801055fe <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
801055e4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055ea:	8b 58 1c             	mov    0x1c(%eax),%ebx
801055ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055f0:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801055f7:	ff d0                	call   *%eax
801055f9:	89 43 1c             	mov    %eax,0x1c(%ebx)
801055fc:	eb 34                	jmp    80105632 <syscall+0x80>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
801055fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105604:	8d 50 70             	lea    0x70(%eax),%edx
80105607:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010560d:	8b 40 14             	mov    0x14(%eax),%eax
80105610:	ff 75 f4             	pushl  -0xc(%ebp)
80105613:	52                   	push   %edx
80105614:	50                   	push   %eax
80105615:	68 df 89 10 80       	push   $0x801089df
8010561a:	e8 a7 ad ff ff       	call   801003c6 <cprintf>
8010561f:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105622:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105628:	8b 40 1c             	mov    0x1c(%eax),%eax
8010562b:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105632:	90                   	nop
80105633:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105636:	c9                   	leave  
80105637:	c3                   	ret    

80105638 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105638:	55                   	push   %ebp
80105639:	89 e5                	mov    %esp,%ebp
8010563b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010563e:	83 ec 08             	sub    $0x8,%esp
80105641:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105644:	50                   	push   %eax
80105645:	ff 75 08             	pushl  0x8(%ebp)
80105648:	e8 bc fe ff ff       	call   80105509 <argint>
8010564d:	83 c4 10             	add    $0x10,%esp
80105650:	85 c0                	test   %eax,%eax
80105652:	79 07                	jns    8010565b <argfd+0x23>
    return -1;
80105654:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105659:	eb 50                	jmp    801056ab <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
8010565b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010565e:	85 c0                	test   %eax,%eax
80105660:	78 21                	js     80105683 <argfd+0x4b>
80105662:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105665:	83 f8 0f             	cmp    $0xf,%eax
80105668:	7f 19                	jg     80105683 <argfd+0x4b>
8010566a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105670:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105673:	83 c2 08             	add    $0x8,%edx
80105676:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
8010567a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010567d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105681:	75 07                	jne    8010568a <argfd+0x52>
    return -1;
80105683:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105688:	eb 21                	jmp    801056ab <argfd+0x73>
  if(pfd)
8010568a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010568e:	74 08                	je     80105698 <argfd+0x60>
    *pfd = fd;
80105690:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105693:	8b 45 0c             	mov    0xc(%ebp),%eax
80105696:	89 10                	mov    %edx,(%eax)
  if(pf)
80105698:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010569c:	74 08                	je     801056a6 <argfd+0x6e>
    *pf = f;
8010569e:	8b 45 10             	mov    0x10(%ebp),%eax
801056a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056a4:	89 10                	mov    %edx,(%eax)
  return 0;
801056a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056ab:	c9                   	leave  
801056ac:	c3                   	ret    

801056ad <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801056ad:	55                   	push   %ebp
801056ae:	89 e5                	mov    %esp,%ebp
801056b0:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801056b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801056ba:	eb 30                	jmp    801056ec <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
801056bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
801056c5:	83 c2 08             	add    $0x8,%edx
801056c8:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
801056cc:	85 c0                	test   %eax,%eax
801056ce:	75 18                	jne    801056e8 <fdalloc+0x3b>
      proc->ofile[fd] = f;
801056d0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801056d9:	8d 4a 08             	lea    0x8(%edx),%ecx
801056dc:	8b 55 08             	mov    0x8(%ebp),%edx
801056df:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
      return fd;
801056e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056e6:	eb 0f                	jmp    801056f7 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801056e8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801056ec:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801056f0:	7e ca                	jle    801056bc <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801056f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056f7:	c9                   	leave  
801056f8:	c3                   	ret    

801056f9 <sys_dup>:

int
sys_dup(void)
{
801056f9:	55                   	push   %ebp
801056fa:	89 e5                	mov    %esp,%ebp
801056fc:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
801056ff:	83 ec 04             	sub    $0x4,%esp
80105702:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105705:	50                   	push   %eax
80105706:	6a 00                	push   $0x0
80105708:	6a 00                	push   $0x0
8010570a:	e8 29 ff ff ff       	call   80105638 <argfd>
8010570f:	83 c4 10             	add    $0x10,%esp
80105712:	85 c0                	test   %eax,%eax
80105714:	79 07                	jns    8010571d <sys_dup+0x24>
    return -1;
80105716:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010571b:	eb 31                	jmp    8010574e <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
8010571d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105720:	83 ec 0c             	sub    $0xc,%esp
80105723:	50                   	push   %eax
80105724:	e8 84 ff ff ff       	call   801056ad <fdalloc>
80105729:	83 c4 10             	add    $0x10,%esp
8010572c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010572f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105733:	79 07                	jns    8010573c <sys_dup+0x43>
    return -1;
80105735:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010573a:	eb 12                	jmp    8010574e <sys_dup+0x55>
  filedup(f);
8010573c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010573f:	83 ec 0c             	sub    $0xc,%esp
80105742:	50                   	push   %eax
80105743:	e8 c4 b8 ff ff       	call   8010100c <filedup>
80105748:	83 c4 10             	add    $0x10,%esp
  return fd;
8010574b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010574e:	c9                   	leave  
8010574f:	c3                   	ret    

80105750 <sys_read>:

int
sys_read(void)
{
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105756:	83 ec 04             	sub    $0x4,%esp
80105759:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010575c:	50                   	push   %eax
8010575d:	6a 00                	push   $0x0
8010575f:	6a 00                	push   $0x0
80105761:	e8 d2 fe ff ff       	call   80105638 <argfd>
80105766:	83 c4 10             	add    $0x10,%esp
80105769:	85 c0                	test   %eax,%eax
8010576b:	78 2e                	js     8010579b <sys_read+0x4b>
8010576d:	83 ec 08             	sub    $0x8,%esp
80105770:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105773:	50                   	push   %eax
80105774:	6a 02                	push   $0x2
80105776:	e8 8e fd ff ff       	call   80105509 <argint>
8010577b:	83 c4 10             	add    $0x10,%esp
8010577e:	85 c0                	test   %eax,%eax
80105780:	78 19                	js     8010579b <sys_read+0x4b>
80105782:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105785:	83 ec 04             	sub    $0x4,%esp
80105788:	50                   	push   %eax
80105789:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010578c:	50                   	push   %eax
8010578d:	6a 01                	push   $0x1
8010578f:	e8 9d fd ff ff       	call   80105531 <argptr>
80105794:	83 c4 10             	add    $0x10,%esp
80105797:	85 c0                	test   %eax,%eax
80105799:	79 07                	jns    801057a2 <sys_read+0x52>
    return -1;
8010579b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057a0:	eb 17                	jmp    801057b9 <sys_read+0x69>
  return fileread(f, p, n);
801057a2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801057a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
801057a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057ab:	83 ec 04             	sub    $0x4,%esp
801057ae:	51                   	push   %ecx
801057af:	52                   	push   %edx
801057b0:	50                   	push   %eax
801057b1:	e8 e6 b9 ff ff       	call   8010119c <fileread>
801057b6:	83 c4 10             	add    $0x10,%esp
}
801057b9:	c9                   	leave  
801057ba:	c3                   	ret    

801057bb <sys_write>:

int
sys_write(void)
{
801057bb:	55                   	push   %ebp
801057bc:	89 e5                	mov    %esp,%ebp
801057be:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801057c1:	83 ec 04             	sub    $0x4,%esp
801057c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057c7:	50                   	push   %eax
801057c8:	6a 00                	push   $0x0
801057ca:	6a 00                	push   $0x0
801057cc:	e8 67 fe ff ff       	call   80105638 <argfd>
801057d1:	83 c4 10             	add    $0x10,%esp
801057d4:	85 c0                	test   %eax,%eax
801057d6:	78 2e                	js     80105806 <sys_write+0x4b>
801057d8:	83 ec 08             	sub    $0x8,%esp
801057db:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057de:	50                   	push   %eax
801057df:	6a 02                	push   $0x2
801057e1:	e8 23 fd ff ff       	call   80105509 <argint>
801057e6:	83 c4 10             	add    $0x10,%esp
801057e9:	85 c0                	test   %eax,%eax
801057eb:	78 19                	js     80105806 <sys_write+0x4b>
801057ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057f0:	83 ec 04             	sub    $0x4,%esp
801057f3:	50                   	push   %eax
801057f4:	8d 45 ec             	lea    -0x14(%ebp),%eax
801057f7:	50                   	push   %eax
801057f8:	6a 01                	push   $0x1
801057fa:	e8 32 fd ff ff       	call   80105531 <argptr>
801057ff:	83 c4 10             	add    $0x10,%esp
80105802:	85 c0                	test   %eax,%eax
80105804:	79 07                	jns    8010580d <sys_write+0x52>
    return -1;
80105806:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010580b:	eb 17                	jmp    80105824 <sys_write+0x69>
  return filewrite(f, p, n);
8010580d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105810:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105813:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105816:	83 ec 04             	sub    $0x4,%esp
80105819:	51                   	push   %ecx
8010581a:	52                   	push   %edx
8010581b:	50                   	push   %eax
8010581c:	e8 33 ba ff ff       	call   80101254 <filewrite>
80105821:	83 c4 10             	add    $0x10,%esp
}
80105824:	c9                   	leave  
80105825:	c3                   	ret    

80105826 <sys_close>:

int
sys_close(void)
{
80105826:	55                   	push   %ebp
80105827:	89 e5                	mov    %esp,%ebp
80105829:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
8010582c:	83 ec 04             	sub    $0x4,%esp
8010582f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105832:	50                   	push   %eax
80105833:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105836:	50                   	push   %eax
80105837:	6a 00                	push   $0x0
80105839:	e8 fa fd ff ff       	call   80105638 <argfd>
8010583e:	83 c4 10             	add    $0x10,%esp
80105841:	85 c0                	test   %eax,%eax
80105843:	79 07                	jns    8010584c <sys_close+0x26>
    return -1;
80105845:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010584a:	eb 28                	jmp    80105874 <sys_close+0x4e>
  proc->ofile[fd] = 0;
8010584c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105852:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105855:	83 c2 08             	add    $0x8,%edx
80105858:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
8010585f:	00 
  fileclose(f);
80105860:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105863:	83 ec 0c             	sub    $0xc,%esp
80105866:	50                   	push   %eax
80105867:	e8 f1 b7 ff ff       	call   8010105d <fileclose>
8010586c:	83 c4 10             	add    $0x10,%esp
  return 0;
8010586f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105874:	c9                   	leave  
80105875:	c3                   	ret    

80105876 <sys_fstat>:

int
sys_fstat(void)
{
80105876:	55                   	push   %ebp
80105877:	89 e5                	mov    %esp,%ebp
80105879:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010587c:	83 ec 04             	sub    $0x4,%esp
8010587f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105882:	50                   	push   %eax
80105883:	6a 00                	push   $0x0
80105885:	6a 00                	push   $0x0
80105887:	e8 ac fd ff ff       	call   80105638 <argfd>
8010588c:	83 c4 10             	add    $0x10,%esp
8010588f:	85 c0                	test   %eax,%eax
80105891:	78 17                	js     801058aa <sys_fstat+0x34>
80105893:	83 ec 04             	sub    $0x4,%esp
80105896:	6a 14                	push   $0x14
80105898:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010589b:	50                   	push   %eax
8010589c:	6a 01                	push   $0x1
8010589e:	e8 8e fc ff ff       	call   80105531 <argptr>
801058a3:	83 c4 10             	add    $0x10,%esp
801058a6:	85 c0                	test   %eax,%eax
801058a8:	79 07                	jns    801058b1 <sys_fstat+0x3b>
    return -1;
801058aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058af:	eb 13                	jmp    801058c4 <sys_fstat+0x4e>
  return filestat(f, st);
801058b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801058b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058b7:	83 ec 08             	sub    $0x8,%esp
801058ba:	52                   	push   %edx
801058bb:	50                   	push   %eax
801058bc:	e8 84 b8 ff ff       	call   80101145 <filestat>
801058c1:	83 c4 10             	add    $0x10,%esp
}
801058c4:	c9                   	leave  
801058c5:	c3                   	ret    

801058c6 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801058c6:	55                   	push   %ebp
801058c7:	89 e5                	mov    %esp,%ebp
801058c9:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801058cc:	83 ec 08             	sub    $0x8,%esp
801058cf:	8d 45 d8             	lea    -0x28(%ebp),%eax
801058d2:	50                   	push   %eax
801058d3:	6a 00                	push   $0x0
801058d5:	e8 a7 fc ff ff       	call   80105581 <argstr>
801058da:	83 c4 10             	add    $0x10,%esp
801058dd:	85 c0                	test   %eax,%eax
801058df:	78 15                	js     801058f6 <sys_link+0x30>
801058e1:	83 ec 08             	sub    $0x8,%esp
801058e4:	8d 45 dc             	lea    -0x24(%ebp),%eax
801058e7:	50                   	push   %eax
801058e8:	6a 01                	push   $0x1
801058ea:	e8 92 fc ff ff       	call   80105581 <argstr>
801058ef:	83 c4 10             	add    $0x10,%esp
801058f2:	85 c0                	test   %eax,%eax
801058f4:	79 0a                	jns    80105900 <sys_link+0x3a>
    return -1;
801058f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058fb:	e9 68 01 00 00       	jmp    80105a68 <sys_link+0x1a2>

  begin_op();
80105900:	e8 0a dc ff ff       	call   8010350f <begin_op>
  if((ip = namei(old)) == 0){
80105905:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105908:	83 ec 0c             	sub    $0xc,%esp
8010590b:	50                   	push   %eax
8010590c:	e8 d9 cb ff ff       	call   801024ea <namei>
80105911:	83 c4 10             	add    $0x10,%esp
80105914:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105917:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010591b:	75 0f                	jne    8010592c <sys_link+0x66>
    end_op();
8010591d:	e8 79 dc ff ff       	call   8010359b <end_op>
    return -1;
80105922:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105927:	e9 3c 01 00 00       	jmp    80105a68 <sys_link+0x1a2>
  }

  ilock(ip);
8010592c:	83 ec 0c             	sub    $0xc,%esp
8010592f:	ff 75 f4             	pushl  -0xc(%ebp)
80105932:	e8 f5 bf ff ff       	call   8010192c <ilock>
80105937:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
8010593a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010593d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105941:	66 83 f8 01          	cmp    $0x1,%ax
80105945:	75 1d                	jne    80105964 <sys_link+0x9e>
    iunlockput(ip);
80105947:	83 ec 0c             	sub    $0xc,%esp
8010594a:	ff 75 f4             	pushl  -0xc(%ebp)
8010594d:	e8 9a c2 ff ff       	call   80101bec <iunlockput>
80105952:	83 c4 10             	add    $0x10,%esp
    end_op();
80105955:	e8 41 dc ff ff       	call   8010359b <end_op>
    return -1;
8010595a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010595f:	e9 04 01 00 00       	jmp    80105a68 <sys_link+0x1a2>
  }

  ip->nlink++;
80105964:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105967:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010596b:	83 c0 01             	add    $0x1,%eax
8010596e:	89 c2                	mov    %eax,%edx
80105970:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105973:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105977:	83 ec 0c             	sub    $0xc,%esp
8010597a:	ff 75 f4             	pushl  -0xc(%ebp)
8010597d:	e8 d0 bd ff ff       	call   80101752 <iupdate>
80105982:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105985:	83 ec 0c             	sub    $0xc,%esp
80105988:	ff 75 f4             	pushl  -0xc(%ebp)
8010598b:	e8 fa c0 ff ff       	call   80101a8a <iunlock>
80105990:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105993:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105996:	83 ec 08             	sub    $0x8,%esp
80105999:	8d 55 e2             	lea    -0x1e(%ebp),%edx
8010599c:	52                   	push   %edx
8010599d:	50                   	push   %eax
8010599e:	e8 63 cb ff ff       	call   80102506 <nameiparent>
801059a3:	83 c4 10             	add    $0x10,%esp
801059a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801059a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801059ad:	74 71                	je     80105a20 <sys_link+0x15a>
    goto bad;
  ilock(dp);
801059af:	83 ec 0c             	sub    $0xc,%esp
801059b2:	ff 75 f0             	pushl  -0x10(%ebp)
801059b5:	e8 72 bf ff ff       	call   8010192c <ilock>
801059ba:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801059bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059c0:	8b 10                	mov    (%eax),%edx
801059c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059c5:	8b 00                	mov    (%eax),%eax
801059c7:	39 c2                	cmp    %eax,%edx
801059c9:	75 1d                	jne    801059e8 <sys_link+0x122>
801059cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059ce:	8b 40 04             	mov    0x4(%eax),%eax
801059d1:	83 ec 04             	sub    $0x4,%esp
801059d4:	50                   	push   %eax
801059d5:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801059d8:	50                   	push   %eax
801059d9:	ff 75 f0             	pushl  -0x10(%ebp)
801059dc:	e8 6d c8 ff ff       	call   8010224e <dirlink>
801059e1:	83 c4 10             	add    $0x10,%esp
801059e4:	85 c0                	test   %eax,%eax
801059e6:	79 10                	jns    801059f8 <sys_link+0x132>
    iunlockput(dp);
801059e8:	83 ec 0c             	sub    $0xc,%esp
801059eb:	ff 75 f0             	pushl  -0x10(%ebp)
801059ee:	e8 f9 c1 ff ff       	call   80101bec <iunlockput>
801059f3:	83 c4 10             	add    $0x10,%esp
    goto bad;
801059f6:	eb 29                	jmp    80105a21 <sys_link+0x15b>
  }
  iunlockput(dp);
801059f8:	83 ec 0c             	sub    $0xc,%esp
801059fb:	ff 75 f0             	pushl  -0x10(%ebp)
801059fe:	e8 e9 c1 ff ff       	call   80101bec <iunlockput>
80105a03:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105a06:	83 ec 0c             	sub    $0xc,%esp
80105a09:	ff 75 f4             	pushl  -0xc(%ebp)
80105a0c:	e8 eb c0 ff ff       	call   80101afc <iput>
80105a11:	83 c4 10             	add    $0x10,%esp

  end_op();
80105a14:	e8 82 db ff ff       	call   8010359b <end_op>

  return 0;
80105a19:	b8 00 00 00 00       	mov    $0x0,%eax
80105a1e:	eb 48                	jmp    80105a68 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80105a20:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80105a21:	83 ec 0c             	sub    $0xc,%esp
80105a24:	ff 75 f4             	pushl  -0xc(%ebp)
80105a27:	e8 00 bf ff ff       	call   8010192c <ilock>
80105a2c:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a32:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105a36:	83 e8 01             	sub    $0x1,%eax
80105a39:	89 c2                	mov    %eax,%edx
80105a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a3e:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105a42:	83 ec 0c             	sub    $0xc,%esp
80105a45:	ff 75 f4             	pushl  -0xc(%ebp)
80105a48:	e8 05 bd ff ff       	call   80101752 <iupdate>
80105a4d:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105a50:	83 ec 0c             	sub    $0xc,%esp
80105a53:	ff 75 f4             	pushl  -0xc(%ebp)
80105a56:	e8 91 c1 ff ff       	call   80101bec <iunlockput>
80105a5b:	83 c4 10             	add    $0x10,%esp
  end_op();
80105a5e:	e8 38 db ff ff       	call   8010359b <end_op>
  return -1;
80105a63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a68:	c9                   	leave  
80105a69:	c3                   	ret    

80105a6a <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105a6a:	55                   	push   %ebp
80105a6b:	89 e5                	mov    %esp,%ebp
80105a6d:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105a70:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105a77:	eb 40                	jmp    80105ab9 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a7c:	6a 10                	push   $0x10
80105a7e:	50                   	push   %eax
80105a7f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a82:	50                   	push   %eax
80105a83:	ff 75 08             	pushl  0x8(%ebp)
80105a86:	e8 0f c4 ff ff       	call   80101e9a <readi>
80105a8b:	83 c4 10             	add    $0x10,%esp
80105a8e:	83 f8 10             	cmp    $0x10,%eax
80105a91:	74 0d                	je     80105aa0 <isdirempty+0x36>
      panic("isdirempty: readi");
80105a93:	83 ec 0c             	sub    $0xc,%esp
80105a96:	68 fb 89 10 80       	push   $0x801089fb
80105a9b:	e8 c6 aa ff ff       	call   80100566 <panic>
    if(de.inum != 0)
80105aa0:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105aa4:	66 85 c0             	test   %ax,%ax
80105aa7:	74 07                	je     80105ab0 <isdirempty+0x46>
      return 0;
80105aa9:	b8 00 00 00 00       	mov    $0x0,%eax
80105aae:	eb 1b                	jmp    80105acb <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ab3:	83 c0 10             	add    $0x10,%eax
80105ab6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ab9:	8b 45 08             	mov    0x8(%ebp),%eax
80105abc:	8b 50 18             	mov    0x18(%eax),%edx
80105abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ac2:	39 c2                	cmp    %eax,%edx
80105ac4:	77 b3                	ja     80105a79 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105ac6:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105acb:	c9                   	leave  
80105acc:	c3                   	ret    

80105acd <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105acd:	55                   	push   %ebp
80105ace:	89 e5                	mov    %esp,%ebp
80105ad0:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105ad3:	83 ec 08             	sub    $0x8,%esp
80105ad6:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105ad9:	50                   	push   %eax
80105ada:	6a 00                	push   $0x0
80105adc:	e8 a0 fa ff ff       	call   80105581 <argstr>
80105ae1:	83 c4 10             	add    $0x10,%esp
80105ae4:	85 c0                	test   %eax,%eax
80105ae6:	79 0a                	jns    80105af2 <sys_unlink+0x25>
    return -1;
80105ae8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aed:	e9 bc 01 00 00       	jmp    80105cae <sys_unlink+0x1e1>

  begin_op();
80105af2:	e8 18 da ff ff       	call   8010350f <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105af7:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105afa:	83 ec 08             	sub    $0x8,%esp
80105afd:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105b00:	52                   	push   %edx
80105b01:	50                   	push   %eax
80105b02:	e8 ff c9 ff ff       	call   80102506 <nameiparent>
80105b07:	83 c4 10             	add    $0x10,%esp
80105b0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b11:	75 0f                	jne    80105b22 <sys_unlink+0x55>
    end_op();
80105b13:	e8 83 da ff ff       	call   8010359b <end_op>
    return -1;
80105b18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b1d:	e9 8c 01 00 00       	jmp    80105cae <sys_unlink+0x1e1>
  }

  ilock(dp);
80105b22:	83 ec 0c             	sub    $0xc,%esp
80105b25:	ff 75 f4             	pushl  -0xc(%ebp)
80105b28:	e8 ff bd ff ff       	call   8010192c <ilock>
80105b2d:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105b30:	83 ec 08             	sub    $0x8,%esp
80105b33:	68 0d 8a 10 80       	push   $0x80108a0d
80105b38:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105b3b:	50                   	push   %eax
80105b3c:	e8 38 c6 ff ff       	call   80102179 <namecmp>
80105b41:	83 c4 10             	add    $0x10,%esp
80105b44:	85 c0                	test   %eax,%eax
80105b46:	0f 84 4a 01 00 00    	je     80105c96 <sys_unlink+0x1c9>
80105b4c:	83 ec 08             	sub    $0x8,%esp
80105b4f:	68 0f 8a 10 80       	push   $0x80108a0f
80105b54:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105b57:	50                   	push   %eax
80105b58:	e8 1c c6 ff ff       	call   80102179 <namecmp>
80105b5d:	83 c4 10             	add    $0x10,%esp
80105b60:	85 c0                	test   %eax,%eax
80105b62:	0f 84 2e 01 00 00    	je     80105c96 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105b68:	83 ec 04             	sub    $0x4,%esp
80105b6b:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105b6e:	50                   	push   %eax
80105b6f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105b72:	50                   	push   %eax
80105b73:	ff 75 f4             	pushl  -0xc(%ebp)
80105b76:	e8 19 c6 ff ff       	call   80102194 <dirlookup>
80105b7b:	83 c4 10             	add    $0x10,%esp
80105b7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b81:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b85:	0f 84 0a 01 00 00    	je     80105c95 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80105b8b:	83 ec 0c             	sub    $0xc,%esp
80105b8e:	ff 75 f0             	pushl  -0x10(%ebp)
80105b91:	e8 96 bd ff ff       	call   8010192c <ilock>
80105b96:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b9c:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105ba0:	66 85 c0             	test   %ax,%ax
80105ba3:	7f 0d                	jg     80105bb2 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80105ba5:	83 ec 0c             	sub    $0xc,%esp
80105ba8:	68 12 8a 10 80       	push   $0x80108a12
80105bad:	e8 b4 a9 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bb5:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105bb9:	66 83 f8 01          	cmp    $0x1,%ax
80105bbd:	75 25                	jne    80105be4 <sys_unlink+0x117>
80105bbf:	83 ec 0c             	sub    $0xc,%esp
80105bc2:	ff 75 f0             	pushl  -0x10(%ebp)
80105bc5:	e8 a0 fe ff ff       	call   80105a6a <isdirempty>
80105bca:	83 c4 10             	add    $0x10,%esp
80105bcd:	85 c0                	test   %eax,%eax
80105bcf:	75 13                	jne    80105be4 <sys_unlink+0x117>
    iunlockput(ip);
80105bd1:	83 ec 0c             	sub    $0xc,%esp
80105bd4:	ff 75 f0             	pushl  -0x10(%ebp)
80105bd7:	e8 10 c0 ff ff       	call   80101bec <iunlockput>
80105bdc:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105bdf:	e9 b2 00 00 00       	jmp    80105c96 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80105be4:	83 ec 04             	sub    $0x4,%esp
80105be7:	6a 10                	push   $0x10
80105be9:	6a 00                	push   $0x0
80105beb:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105bee:	50                   	push   %eax
80105bef:	e8 05 f6 ff ff       	call   801051f9 <memset>
80105bf4:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105bf7:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105bfa:	6a 10                	push   $0x10
80105bfc:	50                   	push   %eax
80105bfd:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c00:	50                   	push   %eax
80105c01:	ff 75 f4             	pushl  -0xc(%ebp)
80105c04:	e8 e8 c3 ff ff       	call   80101ff1 <writei>
80105c09:	83 c4 10             	add    $0x10,%esp
80105c0c:	83 f8 10             	cmp    $0x10,%eax
80105c0f:	74 0d                	je     80105c1e <sys_unlink+0x151>
    panic("unlink: writei");
80105c11:	83 ec 0c             	sub    $0xc,%esp
80105c14:	68 24 8a 10 80       	push   $0x80108a24
80105c19:	e8 48 a9 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
80105c1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c21:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105c25:	66 83 f8 01          	cmp    $0x1,%ax
80105c29:	75 21                	jne    80105c4c <sys_unlink+0x17f>
    dp->nlink--;
80105c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c2e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105c32:	83 e8 01             	sub    $0x1,%eax
80105c35:	89 c2                	mov    %eax,%edx
80105c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c3a:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105c3e:	83 ec 0c             	sub    $0xc,%esp
80105c41:	ff 75 f4             	pushl  -0xc(%ebp)
80105c44:	e8 09 bb ff ff       	call   80101752 <iupdate>
80105c49:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105c4c:	83 ec 0c             	sub    $0xc,%esp
80105c4f:	ff 75 f4             	pushl  -0xc(%ebp)
80105c52:	e8 95 bf ff ff       	call   80101bec <iunlockput>
80105c57:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c5d:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105c61:	83 e8 01             	sub    $0x1,%eax
80105c64:	89 c2                	mov    %eax,%edx
80105c66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c69:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105c6d:	83 ec 0c             	sub    $0xc,%esp
80105c70:	ff 75 f0             	pushl  -0x10(%ebp)
80105c73:	e8 da ba ff ff       	call   80101752 <iupdate>
80105c78:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105c7b:	83 ec 0c             	sub    $0xc,%esp
80105c7e:	ff 75 f0             	pushl  -0x10(%ebp)
80105c81:	e8 66 bf ff ff       	call   80101bec <iunlockput>
80105c86:	83 c4 10             	add    $0x10,%esp

  end_op();
80105c89:	e8 0d d9 ff ff       	call   8010359b <end_op>

  return 0;
80105c8e:	b8 00 00 00 00       	mov    $0x0,%eax
80105c93:	eb 19                	jmp    80105cae <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80105c95:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105c96:	83 ec 0c             	sub    $0xc,%esp
80105c99:	ff 75 f4             	pushl  -0xc(%ebp)
80105c9c:	e8 4b bf ff ff       	call   80101bec <iunlockput>
80105ca1:	83 c4 10             	add    $0x10,%esp
  end_op();
80105ca4:	e8 f2 d8 ff ff       	call   8010359b <end_op>
  return -1;
80105ca9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cae:	c9                   	leave  
80105caf:	c3                   	ret    

80105cb0 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105cb0:	55                   	push   %ebp
80105cb1:	89 e5                	mov    %esp,%ebp
80105cb3:	83 ec 38             	sub    $0x38,%esp
80105cb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105cb9:	8b 55 10             	mov    0x10(%ebp),%edx
80105cbc:	8b 45 14             	mov    0x14(%ebp),%eax
80105cbf:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105cc3:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105cc7:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105ccb:	83 ec 08             	sub    $0x8,%esp
80105cce:	8d 45 de             	lea    -0x22(%ebp),%eax
80105cd1:	50                   	push   %eax
80105cd2:	ff 75 08             	pushl  0x8(%ebp)
80105cd5:	e8 2c c8 ff ff       	call   80102506 <nameiparent>
80105cda:	83 c4 10             	add    $0x10,%esp
80105cdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ce0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ce4:	75 0a                	jne    80105cf0 <create+0x40>
    return 0;
80105ce6:	b8 00 00 00 00       	mov    $0x0,%eax
80105ceb:	e9 90 01 00 00       	jmp    80105e80 <create+0x1d0>
  ilock(dp);
80105cf0:	83 ec 0c             	sub    $0xc,%esp
80105cf3:	ff 75 f4             	pushl  -0xc(%ebp)
80105cf6:	e8 31 bc ff ff       	call   8010192c <ilock>
80105cfb:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80105cfe:	83 ec 04             	sub    $0x4,%esp
80105d01:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d04:	50                   	push   %eax
80105d05:	8d 45 de             	lea    -0x22(%ebp),%eax
80105d08:	50                   	push   %eax
80105d09:	ff 75 f4             	pushl  -0xc(%ebp)
80105d0c:	e8 83 c4 ff ff       	call   80102194 <dirlookup>
80105d11:	83 c4 10             	add    $0x10,%esp
80105d14:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d1b:	74 50                	je     80105d6d <create+0xbd>
    iunlockput(dp);
80105d1d:	83 ec 0c             	sub    $0xc,%esp
80105d20:	ff 75 f4             	pushl  -0xc(%ebp)
80105d23:	e8 c4 be ff ff       	call   80101bec <iunlockput>
80105d28:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80105d2b:	83 ec 0c             	sub    $0xc,%esp
80105d2e:	ff 75 f0             	pushl  -0x10(%ebp)
80105d31:	e8 f6 bb ff ff       	call   8010192c <ilock>
80105d36:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80105d39:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105d3e:	75 15                	jne    80105d55 <create+0xa5>
80105d40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d43:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105d47:	66 83 f8 02          	cmp    $0x2,%ax
80105d4b:	75 08                	jne    80105d55 <create+0xa5>
      return ip;
80105d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d50:	e9 2b 01 00 00       	jmp    80105e80 <create+0x1d0>
    iunlockput(ip);
80105d55:	83 ec 0c             	sub    $0xc,%esp
80105d58:	ff 75 f0             	pushl  -0x10(%ebp)
80105d5b:	e8 8c be ff ff       	call   80101bec <iunlockput>
80105d60:	83 c4 10             	add    $0x10,%esp
    return 0;
80105d63:	b8 00 00 00 00       	mov    $0x0,%eax
80105d68:	e9 13 01 00 00       	jmp    80105e80 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105d6d:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d74:	8b 00                	mov    (%eax),%eax
80105d76:	83 ec 08             	sub    $0x8,%esp
80105d79:	52                   	push   %edx
80105d7a:	50                   	push   %eax
80105d7b:	e8 fb b8 ff ff       	call   8010167b <ialloc>
80105d80:	83 c4 10             	add    $0x10,%esp
80105d83:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d86:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d8a:	75 0d                	jne    80105d99 <create+0xe9>
    panic("create: ialloc");
80105d8c:	83 ec 0c             	sub    $0xc,%esp
80105d8f:	68 33 8a 10 80       	push   $0x80108a33
80105d94:	e8 cd a7 ff ff       	call   80100566 <panic>

  ilock(ip);
80105d99:	83 ec 0c             	sub    $0xc,%esp
80105d9c:	ff 75 f0             	pushl  -0x10(%ebp)
80105d9f:	e8 88 bb ff ff       	call   8010192c <ilock>
80105da4:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80105da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105daa:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105dae:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105db2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105db5:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105db9:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105dbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dc0:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105dc6:	83 ec 0c             	sub    $0xc,%esp
80105dc9:	ff 75 f0             	pushl  -0x10(%ebp)
80105dcc:	e8 81 b9 ff ff       	call   80101752 <iupdate>
80105dd1:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80105dd4:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105dd9:	75 6a                	jne    80105e45 <create+0x195>
    dp->nlink++;  // for ".."
80105ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dde:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105de2:	83 c0 01             	add    $0x1,%eax
80105de5:	89 c2                	mov    %eax,%edx
80105de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dea:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105dee:	83 ec 0c             	sub    $0xc,%esp
80105df1:	ff 75 f4             	pushl  -0xc(%ebp)
80105df4:	e8 59 b9 ff ff       	call   80101752 <iupdate>
80105df9:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105dfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dff:	8b 40 04             	mov    0x4(%eax),%eax
80105e02:	83 ec 04             	sub    $0x4,%esp
80105e05:	50                   	push   %eax
80105e06:	68 0d 8a 10 80       	push   $0x80108a0d
80105e0b:	ff 75 f0             	pushl  -0x10(%ebp)
80105e0e:	e8 3b c4 ff ff       	call   8010224e <dirlink>
80105e13:	83 c4 10             	add    $0x10,%esp
80105e16:	85 c0                	test   %eax,%eax
80105e18:	78 1e                	js     80105e38 <create+0x188>
80105e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e1d:	8b 40 04             	mov    0x4(%eax),%eax
80105e20:	83 ec 04             	sub    $0x4,%esp
80105e23:	50                   	push   %eax
80105e24:	68 0f 8a 10 80       	push   $0x80108a0f
80105e29:	ff 75 f0             	pushl  -0x10(%ebp)
80105e2c:	e8 1d c4 ff ff       	call   8010224e <dirlink>
80105e31:	83 c4 10             	add    $0x10,%esp
80105e34:	85 c0                	test   %eax,%eax
80105e36:	79 0d                	jns    80105e45 <create+0x195>
      panic("create dots");
80105e38:	83 ec 0c             	sub    $0xc,%esp
80105e3b:	68 42 8a 10 80       	push   $0x80108a42
80105e40:	e8 21 a7 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e48:	8b 40 04             	mov    0x4(%eax),%eax
80105e4b:	83 ec 04             	sub    $0x4,%esp
80105e4e:	50                   	push   %eax
80105e4f:	8d 45 de             	lea    -0x22(%ebp),%eax
80105e52:	50                   	push   %eax
80105e53:	ff 75 f4             	pushl  -0xc(%ebp)
80105e56:	e8 f3 c3 ff ff       	call   8010224e <dirlink>
80105e5b:	83 c4 10             	add    $0x10,%esp
80105e5e:	85 c0                	test   %eax,%eax
80105e60:	79 0d                	jns    80105e6f <create+0x1bf>
    panic("create: dirlink");
80105e62:	83 ec 0c             	sub    $0xc,%esp
80105e65:	68 4e 8a 10 80       	push   $0x80108a4e
80105e6a:	e8 f7 a6 ff ff       	call   80100566 <panic>

  iunlockput(dp);
80105e6f:	83 ec 0c             	sub    $0xc,%esp
80105e72:	ff 75 f4             	pushl  -0xc(%ebp)
80105e75:	e8 72 bd ff ff       	call   80101bec <iunlockput>
80105e7a:	83 c4 10             	add    $0x10,%esp

  return ip;
80105e7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105e80:	c9                   	leave  
80105e81:	c3                   	ret    

80105e82 <sys_open>:

int
sys_open(void)
{
80105e82:	55                   	push   %ebp
80105e83:	89 e5                	mov    %esp,%ebp
80105e85:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105e88:	83 ec 08             	sub    $0x8,%esp
80105e8b:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105e8e:	50                   	push   %eax
80105e8f:	6a 00                	push   $0x0
80105e91:	e8 eb f6 ff ff       	call   80105581 <argstr>
80105e96:	83 c4 10             	add    $0x10,%esp
80105e99:	85 c0                	test   %eax,%eax
80105e9b:	78 15                	js     80105eb2 <sys_open+0x30>
80105e9d:	83 ec 08             	sub    $0x8,%esp
80105ea0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ea3:	50                   	push   %eax
80105ea4:	6a 01                	push   $0x1
80105ea6:	e8 5e f6 ff ff       	call   80105509 <argint>
80105eab:	83 c4 10             	add    $0x10,%esp
80105eae:	85 c0                	test   %eax,%eax
80105eb0:	79 0a                	jns    80105ebc <sys_open+0x3a>
    return -1;
80105eb2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eb7:	e9 61 01 00 00       	jmp    8010601d <sys_open+0x19b>

  begin_op();
80105ebc:	e8 4e d6 ff ff       	call   8010350f <begin_op>

  if(omode & O_CREATE){
80105ec1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ec4:	25 00 02 00 00       	and    $0x200,%eax
80105ec9:	85 c0                	test   %eax,%eax
80105ecb:	74 2a                	je     80105ef7 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80105ecd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105ed0:	6a 00                	push   $0x0
80105ed2:	6a 00                	push   $0x0
80105ed4:	6a 02                	push   $0x2
80105ed6:	50                   	push   %eax
80105ed7:	e8 d4 fd ff ff       	call   80105cb0 <create>
80105edc:	83 c4 10             	add    $0x10,%esp
80105edf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105ee2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ee6:	75 75                	jne    80105f5d <sys_open+0xdb>
      end_op();
80105ee8:	e8 ae d6 ff ff       	call   8010359b <end_op>
      return -1;
80105eed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ef2:	e9 26 01 00 00       	jmp    8010601d <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80105ef7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105efa:	83 ec 0c             	sub    $0xc,%esp
80105efd:	50                   	push   %eax
80105efe:	e8 e7 c5 ff ff       	call   801024ea <namei>
80105f03:	83 c4 10             	add    $0x10,%esp
80105f06:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f0d:	75 0f                	jne    80105f1e <sys_open+0x9c>
      end_op();
80105f0f:	e8 87 d6 ff ff       	call   8010359b <end_op>
      return -1;
80105f14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f19:	e9 ff 00 00 00       	jmp    8010601d <sys_open+0x19b>
    }
    ilock(ip);
80105f1e:	83 ec 0c             	sub    $0xc,%esp
80105f21:	ff 75 f4             	pushl  -0xc(%ebp)
80105f24:	e8 03 ba ff ff       	call   8010192c <ilock>
80105f29:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80105f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f2f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f33:	66 83 f8 01          	cmp    $0x1,%ax
80105f37:	75 24                	jne    80105f5d <sys_open+0xdb>
80105f39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f3c:	85 c0                	test   %eax,%eax
80105f3e:	74 1d                	je     80105f5d <sys_open+0xdb>
      iunlockput(ip);
80105f40:	83 ec 0c             	sub    $0xc,%esp
80105f43:	ff 75 f4             	pushl  -0xc(%ebp)
80105f46:	e8 a1 bc ff ff       	call   80101bec <iunlockput>
80105f4b:	83 c4 10             	add    $0x10,%esp
      end_op();
80105f4e:	e8 48 d6 ff ff       	call   8010359b <end_op>
      return -1;
80105f53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f58:	e9 c0 00 00 00       	jmp    8010601d <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105f5d:	e8 3d b0 ff ff       	call   80100f9f <filealloc>
80105f62:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f69:	74 17                	je     80105f82 <sys_open+0x100>
80105f6b:	83 ec 0c             	sub    $0xc,%esp
80105f6e:	ff 75 f0             	pushl  -0x10(%ebp)
80105f71:	e8 37 f7 ff ff       	call   801056ad <fdalloc>
80105f76:	83 c4 10             	add    $0x10,%esp
80105f79:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105f7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105f80:	79 2e                	jns    80105fb0 <sys_open+0x12e>
    if(f)
80105f82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f86:	74 0e                	je     80105f96 <sys_open+0x114>
      fileclose(f);
80105f88:	83 ec 0c             	sub    $0xc,%esp
80105f8b:	ff 75 f0             	pushl  -0x10(%ebp)
80105f8e:	e8 ca b0 ff ff       	call   8010105d <fileclose>
80105f93:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105f96:	83 ec 0c             	sub    $0xc,%esp
80105f99:	ff 75 f4             	pushl  -0xc(%ebp)
80105f9c:	e8 4b bc ff ff       	call   80101bec <iunlockput>
80105fa1:	83 c4 10             	add    $0x10,%esp
    end_op();
80105fa4:	e8 f2 d5 ff ff       	call   8010359b <end_op>
    return -1;
80105fa9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fae:	eb 6d                	jmp    8010601d <sys_open+0x19b>
  }
  iunlock(ip);
80105fb0:	83 ec 0c             	sub    $0xc,%esp
80105fb3:	ff 75 f4             	pushl  -0xc(%ebp)
80105fb6:	e8 cf ba ff ff       	call   80101a8a <iunlock>
80105fbb:	83 c4 10             	add    $0x10,%esp
  end_op();
80105fbe:	e8 d8 d5 ff ff       	call   8010359b <end_op>

  f->type = FD_INODE;
80105fc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fc6:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105fcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105fd2:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105fd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fd8:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105fdf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fe2:	83 e0 01             	and    $0x1,%eax
80105fe5:	85 c0                	test   %eax,%eax
80105fe7:	0f 94 c0             	sete   %al
80105fea:	89 c2                	mov    %eax,%edx
80105fec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fef:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ff2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ff5:	83 e0 01             	and    $0x1,%eax
80105ff8:	85 c0                	test   %eax,%eax
80105ffa:	75 0a                	jne    80106006 <sys_open+0x184>
80105ffc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fff:	83 e0 02             	and    $0x2,%eax
80106002:	85 c0                	test   %eax,%eax
80106004:	74 07                	je     8010600d <sys_open+0x18b>
80106006:	b8 01 00 00 00       	mov    $0x1,%eax
8010600b:	eb 05                	jmp    80106012 <sys_open+0x190>
8010600d:	b8 00 00 00 00       	mov    $0x0,%eax
80106012:	89 c2                	mov    %eax,%edx
80106014:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106017:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010601a:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010601d:	c9                   	leave  
8010601e:	c3                   	ret    

8010601f <sys_mkdir>:

int
sys_mkdir(void)
{
8010601f:	55                   	push   %ebp
80106020:	89 e5                	mov    %esp,%ebp
80106022:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106025:	e8 e5 d4 ff ff       	call   8010350f <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010602a:	83 ec 08             	sub    $0x8,%esp
8010602d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106030:	50                   	push   %eax
80106031:	6a 00                	push   $0x0
80106033:	e8 49 f5 ff ff       	call   80105581 <argstr>
80106038:	83 c4 10             	add    $0x10,%esp
8010603b:	85 c0                	test   %eax,%eax
8010603d:	78 1b                	js     8010605a <sys_mkdir+0x3b>
8010603f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106042:	6a 00                	push   $0x0
80106044:	6a 00                	push   $0x0
80106046:	6a 01                	push   $0x1
80106048:	50                   	push   %eax
80106049:	e8 62 fc ff ff       	call   80105cb0 <create>
8010604e:	83 c4 10             	add    $0x10,%esp
80106051:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106054:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106058:	75 0c                	jne    80106066 <sys_mkdir+0x47>
    end_op();
8010605a:	e8 3c d5 ff ff       	call   8010359b <end_op>
    return -1;
8010605f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106064:	eb 18                	jmp    8010607e <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80106066:	83 ec 0c             	sub    $0xc,%esp
80106069:	ff 75 f4             	pushl  -0xc(%ebp)
8010606c:	e8 7b bb ff ff       	call   80101bec <iunlockput>
80106071:	83 c4 10             	add    $0x10,%esp
  end_op();
80106074:	e8 22 d5 ff ff       	call   8010359b <end_op>
  return 0;
80106079:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010607e:	c9                   	leave  
8010607f:	c3                   	ret    

80106080 <sys_mknod>:

int
sys_mknod(void)
{
80106080:	55                   	push   %ebp
80106081:	89 e5                	mov    %esp,%ebp
80106083:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80106086:	e8 84 d4 ff ff       	call   8010350f <begin_op>
  if((len=argstr(0, &path)) < 0 ||
8010608b:	83 ec 08             	sub    $0x8,%esp
8010608e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106091:	50                   	push   %eax
80106092:	6a 00                	push   $0x0
80106094:	e8 e8 f4 ff ff       	call   80105581 <argstr>
80106099:	83 c4 10             	add    $0x10,%esp
8010609c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010609f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060a3:	78 4f                	js     801060f4 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
801060a5:	83 ec 08             	sub    $0x8,%esp
801060a8:	8d 45 e8             	lea    -0x18(%ebp),%eax
801060ab:	50                   	push   %eax
801060ac:	6a 01                	push   $0x1
801060ae:	e8 56 f4 ff ff       	call   80105509 <argint>
801060b3:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
801060b6:	85 c0                	test   %eax,%eax
801060b8:	78 3a                	js     801060f4 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801060ba:	83 ec 08             	sub    $0x8,%esp
801060bd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801060c0:	50                   	push   %eax
801060c1:	6a 02                	push   $0x2
801060c3:	e8 41 f4 ff ff       	call   80105509 <argint>
801060c8:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801060cb:	85 c0                	test   %eax,%eax
801060cd:	78 25                	js     801060f4 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801060cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060d2:	0f bf c8             	movswl %ax,%ecx
801060d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801060d8:	0f bf d0             	movswl %ax,%edx
801060db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801060de:	51                   	push   %ecx
801060df:	52                   	push   %edx
801060e0:	6a 03                	push   $0x3
801060e2:	50                   	push   %eax
801060e3:	e8 c8 fb ff ff       	call   80105cb0 <create>
801060e8:	83 c4 10             	add    $0x10,%esp
801060eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
801060ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060f2:	75 0c                	jne    80106100 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801060f4:	e8 a2 d4 ff ff       	call   8010359b <end_op>
    return -1;
801060f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060fe:	eb 18                	jmp    80106118 <sys_mknod+0x98>
  }
  iunlockput(ip);
80106100:	83 ec 0c             	sub    $0xc,%esp
80106103:	ff 75 f0             	pushl  -0x10(%ebp)
80106106:	e8 e1 ba ff ff       	call   80101bec <iunlockput>
8010610b:	83 c4 10             	add    $0x10,%esp
  end_op();
8010610e:	e8 88 d4 ff ff       	call   8010359b <end_op>
  return 0;
80106113:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106118:	c9                   	leave  
80106119:	c3                   	ret    

8010611a <sys_chdir>:

int
sys_chdir(void)
{
8010611a:	55                   	push   %ebp
8010611b:	89 e5                	mov    %esp,%ebp
8010611d:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106120:	e8 ea d3 ff ff       	call   8010350f <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106125:	83 ec 08             	sub    $0x8,%esp
80106128:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010612b:	50                   	push   %eax
8010612c:	6a 00                	push   $0x0
8010612e:	e8 4e f4 ff ff       	call   80105581 <argstr>
80106133:	83 c4 10             	add    $0x10,%esp
80106136:	85 c0                	test   %eax,%eax
80106138:	78 18                	js     80106152 <sys_chdir+0x38>
8010613a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010613d:	83 ec 0c             	sub    $0xc,%esp
80106140:	50                   	push   %eax
80106141:	e8 a4 c3 ff ff       	call   801024ea <namei>
80106146:	83 c4 10             	add    $0x10,%esp
80106149:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010614c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106150:	75 0c                	jne    8010615e <sys_chdir+0x44>
    end_op();
80106152:	e8 44 d4 ff ff       	call   8010359b <end_op>
    return -1;
80106157:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010615c:	eb 6e                	jmp    801061cc <sys_chdir+0xb2>
  }
  ilock(ip);
8010615e:	83 ec 0c             	sub    $0xc,%esp
80106161:	ff 75 f4             	pushl  -0xc(%ebp)
80106164:	e8 c3 b7 ff ff       	call   8010192c <ilock>
80106169:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
8010616c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010616f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106173:	66 83 f8 01          	cmp    $0x1,%ax
80106177:	74 1a                	je     80106193 <sys_chdir+0x79>
    iunlockput(ip);
80106179:	83 ec 0c             	sub    $0xc,%esp
8010617c:	ff 75 f4             	pushl  -0xc(%ebp)
8010617f:	e8 68 ba ff ff       	call   80101bec <iunlockput>
80106184:	83 c4 10             	add    $0x10,%esp
    end_op();
80106187:	e8 0f d4 ff ff       	call   8010359b <end_op>
    return -1;
8010618c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106191:	eb 39                	jmp    801061cc <sys_chdir+0xb2>
  }
  iunlock(ip);
80106193:	83 ec 0c             	sub    $0xc,%esp
80106196:	ff 75 f4             	pushl  -0xc(%ebp)
80106199:	e8 ec b8 ff ff       	call   80101a8a <iunlock>
8010619e:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
801061a1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061a7:	8b 40 6c             	mov    0x6c(%eax),%eax
801061aa:	83 ec 0c             	sub    $0xc,%esp
801061ad:	50                   	push   %eax
801061ae:	e8 49 b9 ff ff       	call   80101afc <iput>
801061b3:	83 c4 10             	add    $0x10,%esp
  end_op();
801061b6:	e8 e0 d3 ff ff       	call   8010359b <end_op>
  proc->cwd = ip;
801061bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801061c4:	89 50 6c             	mov    %edx,0x6c(%eax)
  return 0;
801061c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061cc:	c9                   	leave  
801061cd:	c3                   	ret    

801061ce <sys_exec>:

int
sys_exec(void)
{
801061ce:	55                   	push   %ebp
801061cf:	89 e5                	mov    %esp,%ebp
801061d1:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801061d7:	83 ec 08             	sub    $0x8,%esp
801061da:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061dd:	50                   	push   %eax
801061de:	6a 00                	push   $0x0
801061e0:	e8 9c f3 ff ff       	call   80105581 <argstr>
801061e5:	83 c4 10             	add    $0x10,%esp
801061e8:	85 c0                	test   %eax,%eax
801061ea:	78 18                	js     80106204 <sys_exec+0x36>
801061ec:	83 ec 08             	sub    $0x8,%esp
801061ef:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801061f5:	50                   	push   %eax
801061f6:	6a 01                	push   $0x1
801061f8:	e8 0c f3 ff ff       	call   80105509 <argint>
801061fd:	83 c4 10             	add    $0x10,%esp
80106200:	85 c0                	test   %eax,%eax
80106202:	79 0a                	jns    8010620e <sys_exec+0x40>
    return -1;
80106204:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106209:	e9 c6 00 00 00       	jmp    801062d4 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
8010620e:	83 ec 04             	sub    $0x4,%esp
80106211:	68 80 00 00 00       	push   $0x80
80106216:	6a 00                	push   $0x0
80106218:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010621e:	50                   	push   %eax
8010621f:	e8 d5 ef ff ff       	call   801051f9 <memset>
80106224:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80106227:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
8010622e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106231:	83 f8 1f             	cmp    $0x1f,%eax
80106234:	76 0a                	jbe    80106240 <sys_exec+0x72>
      return -1;
80106236:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010623b:	e9 94 00 00 00       	jmp    801062d4 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106240:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106243:	c1 e0 02             	shl    $0x2,%eax
80106246:	89 c2                	mov    %eax,%edx
80106248:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
8010624e:	01 c2                	add    %eax,%edx
80106250:	83 ec 08             	sub    $0x8,%esp
80106253:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106259:	50                   	push   %eax
8010625a:	52                   	push   %edx
8010625b:	e8 22 f2 ff ff       	call   80105482 <fetchint>
80106260:	83 c4 10             	add    $0x10,%esp
80106263:	85 c0                	test   %eax,%eax
80106265:	79 07                	jns    8010626e <sys_exec+0xa0>
      return -1;
80106267:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010626c:	eb 66                	jmp    801062d4 <sys_exec+0x106>
    if(uarg == 0){
8010626e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106274:	85 c0                	test   %eax,%eax
80106276:	75 27                	jne    8010629f <sys_exec+0xd1>
      argv[i] = 0;
80106278:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010627b:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106282:	00 00 00 00 
      break;
80106286:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106287:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010628a:	83 ec 08             	sub    $0x8,%esp
8010628d:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106293:	52                   	push   %edx
80106294:	50                   	push   %eax
80106295:	e8 d7 a8 ff ff       	call   80100b71 <exec>
8010629a:	83 c4 10             	add    $0x10,%esp
8010629d:	eb 35                	jmp    801062d4 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010629f:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801062a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062a8:	c1 e2 02             	shl    $0x2,%edx
801062ab:	01 c2                	add    %eax,%edx
801062ad:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801062b3:	83 ec 08             	sub    $0x8,%esp
801062b6:	52                   	push   %edx
801062b7:	50                   	push   %eax
801062b8:	e8 f4 f1 ff ff       	call   801054b1 <fetchstr>
801062bd:	83 c4 10             	add    $0x10,%esp
801062c0:	85 c0                	test   %eax,%eax
801062c2:	79 07                	jns    801062cb <sys_exec+0xfd>
      return -1;
801062c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062c9:	eb 09                	jmp    801062d4 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801062cb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
801062cf:	e9 5a ff ff ff       	jmp    8010622e <sys_exec+0x60>
  return exec(path, argv);
}
801062d4:	c9                   	leave  
801062d5:	c3                   	ret    

801062d6 <sys_pipe>:

int
sys_pipe(void)
{
801062d6:	55                   	push   %ebp
801062d7:	89 e5                	mov    %esp,%ebp
801062d9:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801062dc:	83 ec 04             	sub    $0x4,%esp
801062df:	6a 08                	push   $0x8
801062e1:	8d 45 ec             	lea    -0x14(%ebp),%eax
801062e4:	50                   	push   %eax
801062e5:	6a 00                	push   $0x0
801062e7:	e8 45 f2 ff ff       	call   80105531 <argptr>
801062ec:	83 c4 10             	add    $0x10,%esp
801062ef:	85 c0                	test   %eax,%eax
801062f1:	79 0a                	jns    801062fd <sys_pipe+0x27>
    return -1;
801062f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062f8:	e9 af 00 00 00       	jmp    801063ac <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
801062fd:	83 ec 08             	sub    $0x8,%esp
80106300:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106303:	50                   	push   %eax
80106304:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106307:	50                   	push   %eax
80106308:	e8 bc dc ff ff       	call   80103fc9 <pipealloc>
8010630d:	83 c4 10             	add    $0x10,%esp
80106310:	85 c0                	test   %eax,%eax
80106312:	79 0a                	jns    8010631e <sys_pipe+0x48>
    return -1;
80106314:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106319:	e9 8e 00 00 00       	jmp    801063ac <sys_pipe+0xd6>
  fd0 = -1;
8010631e:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106325:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106328:	83 ec 0c             	sub    $0xc,%esp
8010632b:	50                   	push   %eax
8010632c:	e8 7c f3 ff ff       	call   801056ad <fdalloc>
80106331:	83 c4 10             	add    $0x10,%esp
80106334:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106337:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010633b:	78 18                	js     80106355 <sys_pipe+0x7f>
8010633d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106340:	83 ec 0c             	sub    $0xc,%esp
80106343:	50                   	push   %eax
80106344:	e8 64 f3 ff ff       	call   801056ad <fdalloc>
80106349:	83 c4 10             	add    $0x10,%esp
8010634c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010634f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106353:	79 3f                	jns    80106394 <sys_pipe+0xbe>
    if(fd0 >= 0)
80106355:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106359:	78 14                	js     8010636f <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
8010635b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106361:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106364:	83 c2 08             	add    $0x8,%edx
80106367:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
8010636e:	00 
    fileclose(rf);
8010636f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106372:	83 ec 0c             	sub    $0xc,%esp
80106375:	50                   	push   %eax
80106376:	e8 e2 ac ff ff       	call   8010105d <fileclose>
8010637b:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
8010637e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106381:	83 ec 0c             	sub    $0xc,%esp
80106384:	50                   	push   %eax
80106385:	e8 d3 ac ff ff       	call   8010105d <fileclose>
8010638a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010638d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106392:	eb 18                	jmp    801063ac <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80106394:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106397:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010639a:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
8010639c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010639f:	8d 50 04             	lea    0x4(%eax),%edx
801063a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063a5:	89 02                	mov    %eax,(%edx)
  return 0;
801063a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063ac:	c9                   	leave  
801063ad:	c3                   	ret    

801063ae <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
801063ae:	55                   	push   %ebp
801063af:	89 e5                	mov    %esp,%ebp
801063b1:	83 ec 08             	sub    $0x8,%esp
801063b4:	8b 55 08             	mov    0x8(%ebp),%edx
801063b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801063ba:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801063be:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801063c2:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
801063c6:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801063ca:	66 ef                	out    %ax,(%dx)
}
801063cc:	90                   	nop
801063cd:	c9                   	leave  
801063ce:	c3                   	ret    

801063cf <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801063cf:	55                   	push   %ebp
801063d0:	89 e5                	mov    %esp,%ebp
801063d2:	83 ec 08             	sub    $0x8,%esp
  return fork();
801063d5:	e8 e5 e2 ff ff       	call   801046bf <fork>
}
801063da:	c9                   	leave  
801063db:	c3                   	ret    

801063dc <sys_exit>:

int
sys_exit(void)
{
801063dc:	55                   	push   %ebp
801063dd:	89 e5                	mov    %esp,%ebp
801063df:	83 ec 08             	sub    $0x8,%esp
  exit();
801063e2:	e8 78 e4 ff ff       	call   8010485f <exit>
  return 0;  // not reached
801063e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063ec:	c9                   	leave  
801063ed:	c3                   	ret    

801063ee <sys_wait>:

int
sys_wait(void)
{
801063ee:	55                   	push   %ebp
801063ef:	89 e5                	mov    %esp,%ebp
801063f1:	83 ec 08             	sub    $0x8,%esp
  return wait();
801063f4:	e8 9e e5 ff ff       	call   80104997 <wait>
}
801063f9:	c9                   	leave  
801063fa:	c3                   	ret    

801063fb <sys_kill>:

int
sys_kill(void)
{
801063fb:	55                   	push   %ebp
801063fc:	89 e5                	mov    %esp,%ebp
801063fe:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106401:	83 ec 08             	sub    $0x8,%esp
80106404:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106407:	50                   	push   %eax
80106408:	6a 00                	push   $0x0
8010640a:	e8 fa f0 ff ff       	call   80105509 <argint>
8010640f:	83 c4 10             	add    $0x10,%esp
80106412:	85 c0                	test   %eax,%eax
80106414:	79 07                	jns    8010641d <sys_kill+0x22>
    return -1;
80106416:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010641b:	eb 0f                	jmp    8010642c <sys_kill+0x31>
  return kill(pid);
8010641d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106420:	83 ec 0c             	sub    $0xc,%esp
80106423:	50                   	push   %eax
80106424:	e8 96 e9 ff ff       	call   80104dbf <kill>
80106429:	83 c4 10             	add    $0x10,%esp
}
8010642c:	c9                   	leave  
8010642d:	c3                   	ret    

8010642e <sys_getpid>:

int
sys_getpid(void)
{
8010642e:	55                   	push   %ebp
8010642f:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106431:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106437:	8b 40 14             	mov    0x14(%eax),%eax
}
8010643a:	5d                   	pop    %ebp
8010643b:	c3                   	ret    

8010643c <sys_sbrk>:

int
sys_sbrk(void)
{
8010643c:	55                   	push   %ebp
8010643d:	89 e5                	mov    %esp,%ebp
8010643f:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106442:	83 ec 08             	sub    $0x8,%esp
80106445:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106448:	50                   	push   %eax
80106449:	6a 00                	push   $0x0
8010644b:	e8 b9 f0 ff ff       	call   80105509 <argint>
80106450:	83 c4 10             	add    $0x10,%esp
80106453:	85 c0                	test   %eax,%eax
80106455:	79 07                	jns    8010645e <sys_sbrk+0x22>
    return -1;
80106457:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010645c:	eb 28                	jmp    80106486 <sys_sbrk+0x4a>
  addr = proc->sz;
8010645e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106464:	8b 00                	mov    (%eax),%eax
80106466:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106469:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010646c:	83 ec 0c             	sub    $0xc,%esp
8010646f:	50                   	push   %eax
80106470:	e8 a7 e1 ff ff       	call   8010461c <growproc>
80106475:	83 c4 10             	add    $0x10,%esp
80106478:	85 c0                	test   %eax,%eax
8010647a:	79 07                	jns    80106483 <sys_sbrk+0x47>
    return -1;
8010647c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106481:	eb 03                	jmp    80106486 <sys_sbrk+0x4a>
  return addr;
80106483:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106486:	c9                   	leave  
80106487:	c3                   	ret    

80106488 <sys_sleep>:

int
sys_sleep(void)
{
80106488:	55                   	push   %ebp
80106489:	89 e5                	mov    %esp,%ebp
8010648b:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
8010648e:	83 ec 08             	sub    $0x8,%esp
80106491:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106494:	50                   	push   %eax
80106495:	6a 00                	push   $0x0
80106497:	e8 6d f0 ff ff       	call   80105509 <argint>
8010649c:	83 c4 10             	add    $0x10,%esp
8010649f:	85 c0                	test   %eax,%eax
801064a1:	79 07                	jns    801064aa <sys_sleep+0x22>
    return -1;
801064a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064a8:	eb 77                	jmp    80106521 <sys_sleep+0x99>
  acquire(&tickslock);
801064aa:	83 ec 0c             	sub    $0xc,%esp
801064ad:	68 a0 49 11 80       	push   $0x801149a0
801064b2:	e8 df ea ff ff       	call   80104f96 <acquire>
801064b7:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801064ba:	a1 e0 51 11 80       	mov    0x801151e0,%eax
801064bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801064c2:	eb 39                	jmp    801064fd <sys_sleep+0x75>
    if(proc->killed){
801064c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064ca:	8b 40 28             	mov    0x28(%eax),%eax
801064cd:	85 c0                	test   %eax,%eax
801064cf:	74 17                	je     801064e8 <sys_sleep+0x60>
      release(&tickslock);
801064d1:	83 ec 0c             	sub    $0xc,%esp
801064d4:	68 a0 49 11 80       	push   $0x801149a0
801064d9:	e8 1f eb ff ff       	call   80104ffd <release>
801064de:	83 c4 10             	add    $0x10,%esp
      return -1;
801064e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064e6:	eb 39                	jmp    80106521 <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
801064e8:	83 ec 08             	sub    $0x8,%esp
801064eb:	68 a0 49 11 80       	push   $0x801149a0
801064f0:	68 e0 51 11 80       	push   $0x801151e0
801064f5:	e8 a3 e7 ff ff       	call   80104c9d <sleep>
801064fa:	83 c4 10             	add    $0x10,%esp
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801064fd:	a1 e0 51 11 80       	mov    0x801151e0,%eax
80106502:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106505:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106508:	39 d0                	cmp    %edx,%eax
8010650a:	72 b8                	jb     801064c4 <sys_sleep+0x3c>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
8010650c:	83 ec 0c             	sub    $0xc,%esp
8010650f:	68 a0 49 11 80       	push   $0x801149a0
80106514:	e8 e4 ea ff ff       	call   80104ffd <release>
80106519:	83 c4 10             	add    $0x10,%esp
  return 0;
8010651c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106521:	c9                   	leave  
80106522:	c3                   	ret    

80106523 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106523:	55                   	push   %ebp
80106524:	89 e5                	mov    %esp,%ebp
80106526:	83 ec 18             	sub    $0x18,%esp
  uint xticks;
  
  acquire(&tickslock);
80106529:	83 ec 0c             	sub    $0xc,%esp
8010652c:	68 a0 49 11 80       	push   $0x801149a0
80106531:	e8 60 ea ff ff       	call   80104f96 <acquire>
80106536:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80106539:	a1 e0 51 11 80       	mov    0x801151e0,%eax
8010653e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106541:	83 ec 0c             	sub    $0xc,%esp
80106544:	68 a0 49 11 80       	push   $0x801149a0
80106549:	e8 af ea ff ff       	call   80104ffd <release>
8010654e:	83 c4 10             	add    $0x10,%esp
  return xticks;
80106551:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106554:	c9                   	leave  
80106555:	c3                   	ret    

80106556 <sys_halt>:

int
sys_halt(void)
{
80106556:	55                   	push   %ebp
80106557:	89 e5                	mov    %esp,%ebp
	outw(0xB004, 0x0|0x2000);
80106559:	68 00 20 00 00       	push   $0x2000
8010655e:	68 04 b0 00 00       	push   $0xb004
80106563:	e8 46 fe ff ff       	call   801063ae <outw>
80106568:	83 c4 08             	add    $0x8,%esp
	return 0;
8010656b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106570:	c9                   	leave  
80106571:	c3                   	ret    

80106572 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106572:	55                   	push   %ebp
80106573:	89 e5                	mov    %esp,%ebp
80106575:	83 ec 08             	sub    $0x8,%esp
80106578:	8b 55 08             	mov    0x8(%ebp),%edx
8010657b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010657e:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106582:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106585:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106589:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010658d:	ee                   	out    %al,(%dx)
}
8010658e:	90                   	nop
8010658f:	c9                   	leave  
80106590:	c3                   	ret    

80106591 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106591:	55                   	push   %ebp
80106592:	89 e5                	mov    %esp,%ebp
80106594:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106597:	6a 34                	push   $0x34
80106599:	6a 43                	push   $0x43
8010659b:	e8 d2 ff ff ff       	call   80106572 <outb>
801065a0:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
801065a3:	68 9c 00 00 00       	push   $0x9c
801065a8:	6a 40                	push   $0x40
801065aa:	e8 c3 ff ff ff       	call   80106572 <outb>
801065af:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
801065b2:	6a 2e                	push   $0x2e
801065b4:	6a 40                	push   $0x40
801065b6:	e8 b7 ff ff ff       	call   80106572 <outb>
801065bb:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
801065be:	83 ec 0c             	sub    $0xc,%esp
801065c1:	6a 00                	push   $0x0
801065c3:	e8 eb d8 ff ff       	call   80103eb3 <picenable>
801065c8:	83 c4 10             	add    $0x10,%esp
}
801065cb:	90                   	nop
801065cc:	c9                   	leave  
801065cd:	c3                   	ret    

801065ce <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801065ce:	1e                   	push   %ds
  pushl %es
801065cf:	06                   	push   %es
  pushl %fs
801065d0:	0f a0                	push   %fs
  pushl %gs
801065d2:	0f a8                	push   %gs
  pushal
801065d4:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
801065d5:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801065d9:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801065db:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
801065dd:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
801065e1:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
801065e3:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
801065e5:	54                   	push   %esp
  call trap
801065e6:	e8 d7 01 00 00       	call   801067c2 <trap>
  addl $4, %esp
801065eb:	83 c4 04             	add    $0x4,%esp

801065ee <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801065ee:	61                   	popa   
  popl %gs
801065ef:	0f a9                	pop    %gs
  popl %fs
801065f1:	0f a1                	pop    %fs
  popl %es
801065f3:	07                   	pop    %es
  popl %ds
801065f4:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801065f5:	83 c4 08             	add    $0x8,%esp
  iret
801065f8:	cf                   	iret   

801065f9 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
801065f9:	55                   	push   %ebp
801065fa:	89 e5                	mov    %esp,%ebp
801065fc:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801065ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80106602:	83 e8 01             	sub    $0x1,%eax
80106605:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106609:	8b 45 08             	mov    0x8(%ebp),%eax
8010660c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106610:	8b 45 08             	mov    0x8(%ebp),%eax
80106613:	c1 e8 10             	shr    $0x10,%eax
80106616:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010661a:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010661d:	0f 01 18             	lidtl  (%eax)
}
80106620:	90                   	nop
80106621:	c9                   	leave  
80106622:	c3                   	ret    

80106623 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106623:	55                   	push   %ebp
80106624:	89 e5                	mov    %esp,%ebp
80106626:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106629:	0f 20 d0             	mov    %cr2,%eax
8010662c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
8010662f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106632:	c9                   	leave  
80106633:	c3                   	ret    

80106634 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106634:	55                   	push   %ebp
80106635:	89 e5                	mov    %esp,%ebp
80106637:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
8010663a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106641:	e9 c3 00 00 00       	jmp    80106709 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106646:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106649:	8b 04 85 9c b0 10 80 	mov    -0x7fef4f64(,%eax,4),%eax
80106650:	89 c2                	mov    %eax,%edx
80106652:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106655:	66 89 14 c5 e0 49 11 	mov    %dx,-0x7feeb620(,%eax,8)
8010665c:	80 
8010665d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106660:	66 c7 04 c5 e2 49 11 	movw   $0x8,-0x7feeb61e(,%eax,8)
80106667:	80 08 00 
8010666a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010666d:	0f b6 14 c5 e4 49 11 	movzbl -0x7feeb61c(,%eax,8),%edx
80106674:	80 
80106675:	83 e2 e0             	and    $0xffffffe0,%edx
80106678:	88 14 c5 e4 49 11 80 	mov    %dl,-0x7feeb61c(,%eax,8)
8010667f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106682:	0f b6 14 c5 e4 49 11 	movzbl -0x7feeb61c(,%eax,8),%edx
80106689:	80 
8010668a:	83 e2 1f             	and    $0x1f,%edx
8010668d:	88 14 c5 e4 49 11 80 	mov    %dl,-0x7feeb61c(,%eax,8)
80106694:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106697:	0f b6 14 c5 e5 49 11 	movzbl -0x7feeb61b(,%eax,8),%edx
8010669e:	80 
8010669f:	83 e2 f0             	and    $0xfffffff0,%edx
801066a2:	83 ca 0e             	or     $0xe,%edx
801066a5:	88 14 c5 e5 49 11 80 	mov    %dl,-0x7feeb61b(,%eax,8)
801066ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066af:	0f b6 14 c5 e5 49 11 	movzbl -0x7feeb61b(,%eax,8),%edx
801066b6:	80 
801066b7:	83 e2 ef             	and    $0xffffffef,%edx
801066ba:	88 14 c5 e5 49 11 80 	mov    %dl,-0x7feeb61b(,%eax,8)
801066c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066c4:	0f b6 14 c5 e5 49 11 	movzbl -0x7feeb61b(,%eax,8),%edx
801066cb:	80 
801066cc:	83 e2 9f             	and    $0xffffff9f,%edx
801066cf:	88 14 c5 e5 49 11 80 	mov    %dl,-0x7feeb61b(,%eax,8)
801066d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066d9:	0f b6 14 c5 e5 49 11 	movzbl -0x7feeb61b(,%eax,8),%edx
801066e0:	80 
801066e1:	83 ca 80             	or     $0xffffff80,%edx
801066e4:	88 14 c5 e5 49 11 80 	mov    %dl,-0x7feeb61b(,%eax,8)
801066eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066ee:	8b 04 85 9c b0 10 80 	mov    -0x7fef4f64(,%eax,4),%eax
801066f5:	c1 e8 10             	shr    $0x10,%eax
801066f8:	89 c2                	mov    %eax,%edx
801066fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066fd:	66 89 14 c5 e6 49 11 	mov    %dx,-0x7feeb61a(,%eax,8)
80106704:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106705:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106709:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106710:	0f 8e 30 ff ff ff    	jle    80106646 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106716:	a1 9c b1 10 80       	mov    0x8010b19c,%eax
8010671b:	66 a3 e0 4b 11 80    	mov    %ax,0x80114be0
80106721:	66 c7 05 e2 4b 11 80 	movw   $0x8,0x80114be2
80106728:	08 00 
8010672a:	0f b6 05 e4 4b 11 80 	movzbl 0x80114be4,%eax
80106731:	83 e0 e0             	and    $0xffffffe0,%eax
80106734:	a2 e4 4b 11 80       	mov    %al,0x80114be4
80106739:	0f b6 05 e4 4b 11 80 	movzbl 0x80114be4,%eax
80106740:	83 e0 1f             	and    $0x1f,%eax
80106743:	a2 e4 4b 11 80       	mov    %al,0x80114be4
80106748:	0f b6 05 e5 4b 11 80 	movzbl 0x80114be5,%eax
8010674f:	83 c8 0f             	or     $0xf,%eax
80106752:	a2 e5 4b 11 80       	mov    %al,0x80114be5
80106757:	0f b6 05 e5 4b 11 80 	movzbl 0x80114be5,%eax
8010675e:	83 e0 ef             	and    $0xffffffef,%eax
80106761:	a2 e5 4b 11 80       	mov    %al,0x80114be5
80106766:	0f b6 05 e5 4b 11 80 	movzbl 0x80114be5,%eax
8010676d:	83 c8 60             	or     $0x60,%eax
80106770:	a2 e5 4b 11 80       	mov    %al,0x80114be5
80106775:	0f b6 05 e5 4b 11 80 	movzbl 0x80114be5,%eax
8010677c:	83 c8 80             	or     $0xffffff80,%eax
8010677f:	a2 e5 4b 11 80       	mov    %al,0x80114be5
80106784:	a1 9c b1 10 80       	mov    0x8010b19c,%eax
80106789:	c1 e8 10             	shr    $0x10,%eax
8010678c:	66 a3 e6 4b 11 80    	mov    %ax,0x80114be6
  
  initlock(&tickslock, "time");
80106792:	83 ec 08             	sub    $0x8,%esp
80106795:	68 60 8a 10 80       	push   $0x80108a60
8010679a:	68 a0 49 11 80       	push   $0x801149a0
8010679f:	e8 d0 e7 ff ff       	call   80104f74 <initlock>
801067a4:	83 c4 10             	add    $0x10,%esp
}
801067a7:	90                   	nop
801067a8:	c9                   	leave  
801067a9:	c3                   	ret    

801067aa <idtinit>:

void
idtinit(void)
{
801067aa:	55                   	push   %ebp
801067ab:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
801067ad:	68 00 08 00 00       	push   $0x800
801067b2:	68 e0 49 11 80       	push   $0x801149e0
801067b7:	e8 3d fe ff ff       	call   801065f9 <lidt>
801067bc:	83 c4 08             	add    $0x8,%esp
}
801067bf:	90                   	nop
801067c0:	c9                   	leave  
801067c1:	c3                   	ret    

801067c2 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801067c2:	55                   	push   %ebp
801067c3:	89 e5                	mov    %esp,%ebp
801067c5:	57                   	push   %edi
801067c6:	56                   	push   %esi
801067c7:	53                   	push   %ebx
801067c8:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
801067cb:	8b 45 08             	mov    0x8(%ebp),%eax
801067ce:	8b 40 30             	mov    0x30(%eax),%eax
801067d1:	83 f8 40             	cmp    $0x40,%eax
801067d4:	75 3e                	jne    80106814 <trap+0x52>
    if(proc->killed)
801067d6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067dc:	8b 40 28             	mov    0x28(%eax),%eax
801067df:	85 c0                	test   %eax,%eax
801067e1:	74 05                	je     801067e8 <trap+0x26>
      exit();
801067e3:	e8 77 e0 ff ff       	call   8010485f <exit>
    proc->tf = tf;
801067e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067ee:	8b 55 08             	mov    0x8(%ebp),%edx
801067f1:	89 50 1c             	mov    %edx,0x1c(%eax)
    syscall();
801067f4:	e8 b9 ed ff ff       	call   801055b2 <syscall>
    if(proc->killed)
801067f9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067ff:	8b 40 28             	mov    0x28(%eax),%eax
80106802:	85 c0                	test   %eax,%eax
80106804:	0f 84 8e 02 00 00    	je     80106a98 <trap+0x2d6>
      exit();
8010680a:	e8 50 e0 ff ff       	call   8010485f <exit>
    return;
8010680f:	e9 84 02 00 00       	jmp    80106a98 <trap+0x2d6>
  }

  switch(tf->trapno){
80106814:	8b 45 08             	mov    0x8(%ebp),%eax
80106817:	8b 40 30             	mov    0x30(%eax),%eax
8010681a:	83 e8 0e             	sub    $0xe,%eax
8010681d:	83 f8 31             	cmp    $0x31,%eax
80106820:	0f 87 33 01 00 00    	ja     80106959 <trap+0x197>
80106826:	8b 04 85 08 8b 10 80 	mov    -0x7fef74f8(,%eax,4),%eax
8010682d:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
8010682f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106835:	0f b6 00             	movzbl (%eax),%eax
80106838:	84 c0                	test   %al,%al
8010683a:	75 3d                	jne    80106879 <trap+0xb7>
      acquire(&tickslock);
8010683c:	83 ec 0c             	sub    $0xc,%esp
8010683f:	68 a0 49 11 80       	push   $0x801149a0
80106844:	e8 4d e7 ff ff       	call   80104f96 <acquire>
80106849:	83 c4 10             	add    $0x10,%esp
      ticks++;
8010684c:	a1 e0 51 11 80       	mov    0x801151e0,%eax
80106851:	83 c0 01             	add    $0x1,%eax
80106854:	a3 e0 51 11 80       	mov    %eax,0x801151e0
      wakeup(&ticks);
80106859:	83 ec 0c             	sub    $0xc,%esp
8010685c:	68 e0 51 11 80       	push   $0x801151e0
80106861:	e8 22 e5 ff ff       	call   80104d88 <wakeup>
80106866:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106869:	83 ec 0c             	sub    $0xc,%esp
8010686c:	68 a0 49 11 80       	push   $0x801149a0
80106871:	e8 87 e7 ff ff       	call   80104ffd <release>
80106876:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106879:	e8 69 c7 ff ff       	call   80102fe7 <lapiceoi>
    break;
8010687e:	e9 8f 01 00 00       	jmp    80106a12 <trap+0x250>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106883:	e8 72 bf ff ff       	call   801027fa <ideintr>
    lapiceoi();
80106888:	e8 5a c7 ff ff       	call   80102fe7 <lapiceoi>
    break;
8010688d:	e9 80 01 00 00       	jmp    80106a12 <trap+0x250>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106892:	e8 52 c5 ff ff       	call   80102de9 <kbdintr>
    lapiceoi();
80106897:	e8 4b c7 ff ff       	call   80102fe7 <lapiceoi>
    break;
8010689c:	e9 71 01 00 00       	jmp    80106a12 <trap+0x250>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801068a1:	e8 a7 03 00 00       	call   80106c4d <uartintr>
    lapiceoi();
801068a6:	e8 3c c7 ff ff       	call   80102fe7 <lapiceoi>
    break;
801068ab:	e9 62 01 00 00       	jmp    80106a12 <trap+0x250>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801068b0:	8b 45 08             	mov    0x8(%ebp),%eax
801068b3:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
801068b6:	8b 45 08             	mov    0x8(%ebp),%eax
801068b9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801068bd:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
801068c0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801068c6:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801068c9:	0f b6 c0             	movzbl %al,%eax
801068cc:	51                   	push   %ecx
801068cd:	52                   	push   %edx
801068ce:	50                   	push   %eax
801068cf:	68 68 8a 10 80       	push   $0x80108a68
801068d4:	e8 ed 9a ff ff       	call   801003c6 <cprintf>
801068d9:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
801068dc:	e8 06 c7 ff ff       	call   80102fe7 <lapiceoi>
    break;
801068e1:	e9 2c 01 00 00       	jmp    80106a12 <trap+0x250>
  case T_PGFLT :
//	cprintf("stack top : %x   rcr : <%x>\n",proc->sb,rcr2());
	if(rcr2()<KERNBASE && rcr2() >=proc->sb-PGSIZE){
801068e6:	e8 38 fd ff ff       	call   80106623 <rcr2>
801068eb:	85 c0                	test   %eax,%eax
801068ed:	78 6a                	js     80106959 <trap+0x197>
801068ef:	e8 2f fd ff ff       	call   80106623 <rcr2>
801068f4:	89 c2                	mov    %eax,%edx
801068f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068fc:	8b 40 04             	mov    0x4(%eax),%eax
801068ff:	2d 00 10 00 00       	sub    $0x1000,%eax
80106904:	39 c2                	cmp    %eax,%edx
80106906:	72 51                	jb     80106959 <trap+0x197>
		if((allocuvm(proc->pgdir, (proc->sb)-PGSIZE, proc->sb)) > 0){
80106908:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010690e:	8b 50 04             	mov    0x4(%eax),%edx
80106911:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106917:	8b 40 04             	mov    0x4(%eax),%eax
8010691a:	8d 88 00 f0 ff ff    	lea    -0x1000(%eax),%ecx
80106920:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106926:	8b 40 08             	mov    0x8(%eax),%eax
80106929:	83 ec 04             	sub    $0x4,%esp
8010692c:	52                   	push   %edx
8010692d:	51                   	push   %ecx
8010692e:	50                   	push   %eax
8010692f:	e8 6d 17 00 00       	call   801080a1 <allocuvm>
80106934:	83 c4 10             	add    $0x10,%esp
80106937:	85 c0                	test   %eax,%eax
80106939:	7e 1e                	jle    80106959 <trap+0x197>
			proc->sb-=PGSIZE;
8010693b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106941:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80106948:	8b 52 04             	mov    0x4(%edx),%edx
8010694b:	81 ea 00 10 00 00    	sub    $0x1000,%edx
80106951:	89 50 04             	mov    %edx,0x4(%eax)
			break;
80106954:	e9 b9 00 00 00       	jmp    80106a12 <trap+0x250>
		}
	}
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106959:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010695f:	85 c0                	test   %eax,%eax
80106961:	74 11                	je     80106974 <trap+0x1b2>
80106963:	8b 45 08             	mov    0x8(%ebp),%eax
80106966:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010696a:	0f b7 c0             	movzwl %ax,%eax
8010696d:	83 e0 03             	and    $0x3,%eax
80106970:	85 c0                	test   %eax,%eax
80106972:	75 40                	jne    801069b4 <trap+0x1f2>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106974:	e8 aa fc ff ff       	call   80106623 <rcr2>
80106979:	89 c3                	mov    %eax,%ebx
8010697b:	8b 45 08             	mov    0x8(%ebp),%eax
8010697e:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106981:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106987:	0f b6 00             	movzbl (%eax),%eax
	}
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010698a:	0f b6 d0             	movzbl %al,%edx
8010698d:	8b 45 08             	mov    0x8(%ebp),%eax
80106990:	8b 40 30             	mov    0x30(%eax),%eax
80106993:	83 ec 0c             	sub    $0xc,%esp
80106996:	53                   	push   %ebx
80106997:	51                   	push   %ecx
80106998:	52                   	push   %edx
80106999:	50                   	push   %eax
8010699a:	68 8c 8a 10 80       	push   $0x80108a8c
8010699f:	e8 22 9a ff ff       	call   801003c6 <cprintf>
801069a4:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
801069a7:	83 ec 0c             	sub    $0xc,%esp
801069aa:	68 be 8a 10 80       	push   $0x80108abe
801069af:	e8 b2 9b ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069b4:	e8 6a fc ff ff       	call   80106623 <rcr2>
801069b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801069bc:	8b 45 08             	mov    0x8(%ebp),%eax
801069bf:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801069c2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801069c8:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069cb:	0f b6 d8             	movzbl %al,%ebx
801069ce:	8b 45 08             	mov    0x8(%ebp),%eax
801069d1:	8b 48 34             	mov    0x34(%eax),%ecx
801069d4:	8b 45 08             	mov    0x8(%ebp),%eax
801069d7:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801069da:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069e0:	8d 78 70             	lea    0x70(%eax),%edi
801069e3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069e9:	8b 40 14             	mov    0x14(%eax),%eax
801069ec:	ff 75 e4             	pushl  -0x1c(%ebp)
801069ef:	56                   	push   %esi
801069f0:	53                   	push   %ebx
801069f1:	51                   	push   %ecx
801069f2:	52                   	push   %edx
801069f3:	57                   	push   %edi
801069f4:	50                   	push   %eax
801069f5:	68 c4 8a 10 80       	push   $0x80108ac4
801069fa:	e8 c7 99 ff ff       	call   801003c6 <cprintf>
801069ff:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80106a02:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a08:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
80106a0f:	eb 01                	jmp    80106a12 <trap+0x250>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106a11:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106a12:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a18:	85 c0                	test   %eax,%eax
80106a1a:	74 24                	je     80106a40 <trap+0x27e>
80106a1c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a22:	8b 40 28             	mov    0x28(%eax),%eax
80106a25:	85 c0                	test   %eax,%eax
80106a27:	74 17                	je     80106a40 <trap+0x27e>
80106a29:	8b 45 08             	mov    0x8(%ebp),%eax
80106a2c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106a30:	0f b7 c0             	movzwl %ax,%eax
80106a33:	83 e0 03             	and    $0x3,%eax
80106a36:	83 f8 03             	cmp    $0x3,%eax
80106a39:	75 05                	jne    80106a40 <trap+0x27e>
    exit();
80106a3b:	e8 1f de ff ff       	call   8010485f <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106a40:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a46:	85 c0                	test   %eax,%eax
80106a48:	74 1e                	je     80106a68 <trap+0x2a6>
80106a4a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a50:	8b 40 10             	mov    0x10(%eax),%eax
80106a53:	83 f8 04             	cmp    $0x4,%eax
80106a56:	75 10                	jne    80106a68 <trap+0x2a6>
80106a58:	8b 45 08             	mov    0x8(%ebp),%eax
80106a5b:	8b 40 30             	mov    0x30(%eax),%eax
80106a5e:	83 f8 20             	cmp    $0x20,%eax
80106a61:	75 05                	jne    80106a68 <trap+0x2a6>
    yield();
80106a63:	e8 b4 e1 ff ff       	call   80104c1c <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106a68:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a6e:	85 c0                	test   %eax,%eax
80106a70:	74 27                	je     80106a99 <trap+0x2d7>
80106a72:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a78:	8b 40 28             	mov    0x28(%eax),%eax
80106a7b:	85 c0                	test   %eax,%eax
80106a7d:	74 1a                	je     80106a99 <trap+0x2d7>
80106a7f:	8b 45 08             	mov    0x8(%ebp),%eax
80106a82:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106a86:	0f b7 c0             	movzwl %ax,%eax
80106a89:	83 e0 03             	and    $0x3,%eax
80106a8c:	83 f8 03             	cmp    $0x3,%eax
80106a8f:	75 08                	jne    80106a99 <trap+0x2d7>
    exit();
80106a91:	e8 c9 dd ff ff       	call   8010485f <exit>
80106a96:	eb 01                	jmp    80106a99 <trap+0x2d7>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80106a98:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106a99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a9c:	5b                   	pop    %ebx
80106a9d:	5e                   	pop    %esi
80106a9e:	5f                   	pop    %edi
80106a9f:	5d                   	pop    %ebp
80106aa0:	c3                   	ret    

80106aa1 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106aa1:	55                   	push   %ebp
80106aa2:	89 e5                	mov    %esp,%ebp
80106aa4:	83 ec 14             	sub    $0x14,%esp
80106aa7:	8b 45 08             	mov    0x8(%ebp),%eax
80106aaa:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106aae:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106ab2:	89 c2                	mov    %eax,%edx
80106ab4:	ec                   	in     (%dx),%al
80106ab5:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106ab8:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106abc:	c9                   	leave  
80106abd:	c3                   	ret    

80106abe <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106abe:	55                   	push   %ebp
80106abf:	89 e5                	mov    %esp,%ebp
80106ac1:	83 ec 08             	sub    $0x8,%esp
80106ac4:	8b 55 08             	mov    0x8(%ebp),%edx
80106ac7:	8b 45 0c             	mov    0xc(%ebp),%eax
80106aca:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106ace:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106ad1:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106ad5:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106ad9:	ee                   	out    %al,(%dx)
}
80106ada:	90                   	nop
80106adb:	c9                   	leave  
80106adc:	c3                   	ret    

80106add <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106add:	55                   	push   %ebp
80106ade:	89 e5                	mov    %esp,%ebp
80106ae0:	83 ec 08             	sub    $0x8,%esp
  // Turn off the FIFO
  outb(COM1+2, 0);
80106ae3:	6a 00                	push   $0x0
80106ae5:	68 fa 03 00 00       	push   $0x3fa
80106aea:	e8 cf ff ff ff       	call   80106abe <outb>
80106aef:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106af2:	68 80 00 00 00       	push   $0x80
80106af7:	68 fb 03 00 00       	push   $0x3fb
80106afc:	e8 bd ff ff ff       	call   80106abe <outb>
80106b01:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106b04:	6a 0c                	push   $0xc
80106b06:	68 f8 03 00 00       	push   $0x3f8
80106b0b:	e8 ae ff ff ff       	call   80106abe <outb>
80106b10:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106b13:	6a 00                	push   $0x0
80106b15:	68 f9 03 00 00       	push   $0x3f9
80106b1a:	e8 9f ff ff ff       	call   80106abe <outb>
80106b1f:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106b22:	6a 03                	push   $0x3
80106b24:	68 fb 03 00 00       	push   $0x3fb
80106b29:	e8 90 ff ff ff       	call   80106abe <outb>
80106b2e:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106b31:	6a 00                	push   $0x0
80106b33:	68 fc 03 00 00       	push   $0x3fc
80106b38:	e8 81 ff ff ff       	call   80106abe <outb>
80106b3d:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106b40:	6a 01                	push   $0x1
80106b42:	68 f9 03 00 00       	push   $0x3f9
80106b47:	e8 72 ff ff ff       	call   80106abe <outb>
80106b4c:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106b4f:	68 fd 03 00 00       	push   $0x3fd
80106b54:	e8 48 ff ff ff       	call   80106aa1 <inb>
80106b59:	83 c4 04             	add    $0x4,%esp
80106b5c:	3c ff                	cmp    $0xff,%al
80106b5e:	74 42                	je     80106ba2 <uartinit+0xc5>
    return;
  uart = 1;
80106b60:	c7 05 4c b6 10 80 01 	movl   $0x1,0x8010b64c
80106b67:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106b6a:	68 fa 03 00 00       	push   $0x3fa
80106b6f:	e8 2d ff ff ff       	call   80106aa1 <inb>
80106b74:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106b77:	68 f8 03 00 00       	push   $0x3f8
80106b7c:	e8 20 ff ff ff       	call   80106aa1 <inb>
80106b81:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80106b84:	83 ec 0c             	sub    $0xc,%esp
80106b87:	6a 04                	push   $0x4
80106b89:	e8 25 d3 ff ff       	call   80103eb3 <picenable>
80106b8e:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80106b91:	83 ec 08             	sub    $0x8,%esp
80106b94:	6a 00                	push   $0x0
80106b96:	6a 04                	push   $0x4
80106b98:	e8 ff be ff ff       	call   80102a9c <ioapicenable>
80106b9d:	83 c4 10             	add    $0x10,%esp
80106ba0:	eb 01                	jmp    80106ba3 <uartinit+0xc6>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80106ba2:	90                   	nop
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
}
80106ba3:	c9                   	leave  
80106ba4:	c3                   	ret    

80106ba5 <uartputc>:

void
uartputc(int c)
{
80106ba5:	55                   	push   %ebp
80106ba6:	89 e5                	mov    %esp,%ebp
80106ba8:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80106bab:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106bb0:	85 c0                	test   %eax,%eax
80106bb2:	74 53                	je     80106c07 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106bb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106bbb:	eb 11                	jmp    80106bce <uartputc+0x29>
    microdelay(10);
80106bbd:	83 ec 0c             	sub    $0xc,%esp
80106bc0:	6a 0a                	push   $0xa
80106bc2:	e8 3b c4 ff ff       	call   80103002 <microdelay>
80106bc7:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106bca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106bce:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106bd2:	7f 1a                	jg     80106bee <uartputc+0x49>
80106bd4:	83 ec 0c             	sub    $0xc,%esp
80106bd7:	68 fd 03 00 00       	push   $0x3fd
80106bdc:	e8 c0 fe ff ff       	call   80106aa1 <inb>
80106be1:	83 c4 10             	add    $0x10,%esp
80106be4:	0f b6 c0             	movzbl %al,%eax
80106be7:	83 e0 20             	and    $0x20,%eax
80106bea:	85 c0                	test   %eax,%eax
80106bec:	74 cf                	je     80106bbd <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80106bee:	8b 45 08             	mov    0x8(%ebp),%eax
80106bf1:	0f b6 c0             	movzbl %al,%eax
80106bf4:	83 ec 08             	sub    $0x8,%esp
80106bf7:	50                   	push   %eax
80106bf8:	68 f8 03 00 00       	push   $0x3f8
80106bfd:	e8 bc fe ff ff       	call   80106abe <outb>
80106c02:	83 c4 10             	add    $0x10,%esp
80106c05:	eb 01                	jmp    80106c08 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80106c07:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106c08:	c9                   	leave  
80106c09:	c3                   	ret    

80106c0a <uartgetc>:

static int
uartgetc(void)
{
80106c0a:	55                   	push   %ebp
80106c0b:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106c0d:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106c12:	85 c0                	test   %eax,%eax
80106c14:	75 07                	jne    80106c1d <uartgetc+0x13>
    return -1;
80106c16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c1b:	eb 2e                	jmp    80106c4b <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80106c1d:	68 fd 03 00 00       	push   $0x3fd
80106c22:	e8 7a fe ff ff       	call   80106aa1 <inb>
80106c27:	83 c4 04             	add    $0x4,%esp
80106c2a:	0f b6 c0             	movzbl %al,%eax
80106c2d:	83 e0 01             	and    $0x1,%eax
80106c30:	85 c0                	test   %eax,%eax
80106c32:	75 07                	jne    80106c3b <uartgetc+0x31>
    return -1;
80106c34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c39:	eb 10                	jmp    80106c4b <uartgetc+0x41>
  return inb(COM1+0);
80106c3b:	68 f8 03 00 00       	push   $0x3f8
80106c40:	e8 5c fe ff ff       	call   80106aa1 <inb>
80106c45:	83 c4 04             	add    $0x4,%esp
80106c48:	0f b6 c0             	movzbl %al,%eax
}
80106c4b:	c9                   	leave  
80106c4c:	c3                   	ret    

80106c4d <uartintr>:

void
uartintr(void)
{
80106c4d:	55                   	push   %ebp
80106c4e:	89 e5                	mov    %esp,%ebp
80106c50:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106c53:	83 ec 0c             	sub    $0xc,%esp
80106c56:	68 0a 6c 10 80       	push   $0x80106c0a
80106c5b:	e8 99 9b ff ff       	call   801007f9 <consoleintr>
80106c60:	83 c4 10             	add    $0x10,%esp
}
80106c63:	90                   	nop
80106c64:	c9                   	leave  
80106c65:	c3                   	ret    

80106c66 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106c66:	6a 00                	push   $0x0
  pushl $0
80106c68:	6a 00                	push   $0x0
  jmp alltraps
80106c6a:	e9 5f f9 ff ff       	jmp    801065ce <alltraps>

80106c6f <vector1>:
.globl vector1
vector1:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $1
80106c71:	6a 01                	push   $0x1
  jmp alltraps
80106c73:	e9 56 f9 ff ff       	jmp    801065ce <alltraps>

80106c78 <vector2>:
.globl vector2
vector2:
  pushl $0
80106c78:	6a 00                	push   $0x0
  pushl $2
80106c7a:	6a 02                	push   $0x2
  jmp alltraps
80106c7c:	e9 4d f9 ff ff       	jmp    801065ce <alltraps>

80106c81 <vector3>:
.globl vector3
vector3:
  pushl $0
80106c81:	6a 00                	push   $0x0
  pushl $3
80106c83:	6a 03                	push   $0x3
  jmp alltraps
80106c85:	e9 44 f9 ff ff       	jmp    801065ce <alltraps>

80106c8a <vector4>:
.globl vector4
vector4:
  pushl $0
80106c8a:	6a 00                	push   $0x0
  pushl $4
80106c8c:	6a 04                	push   $0x4
  jmp alltraps
80106c8e:	e9 3b f9 ff ff       	jmp    801065ce <alltraps>

80106c93 <vector5>:
.globl vector5
vector5:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $5
80106c95:	6a 05                	push   $0x5
  jmp alltraps
80106c97:	e9 32 f9 ff ff       	jmp    801065ce <alltraps>

80106c9c <vector6>:
.globl vector6
vector6:
  pushl $0
80106c9c:	6a 00                	push   $0x0
  pushl $6
80106c9e:	6a 06                	push   $0x6
  jmp alltraps
80106ca0:	e9 29 f9 ff ff       	jmp    801065ce <alltraps>

80106ca5 <vector7>:
.globl vector7
vector7:
  pushl $0
80106ca5:	6a 00                	push   $0x0
  pushl $7
80106ca7:	6a 07                	push   $0x7
  jmp alltraps
80106ca9:	e9 20 f9 ff ff       	jmp    801065ce <alltraps>

80106cae <vector8>:
.globl vector8
vector8:
  pushl $8
80106cae:	6a 08                	push   $0x8
  jmp alltraps
80106cb0:	e9 19 f9 ff ff       	jmp    801065ce <alltraps>

80106cb5 <vector9>:
.globl vector9
vector9:
  pushl $0
80106cb5:	6a 00                	push   $0x0
  pushl $9
80106cb7:	6a 09                	push   $0x9
  jmp alltraps
80106cb9:	e9 10 f9 ff ff       	jmp    801065ce <alltraps>

80106cbe <vector10>:
.globl vector10
vector10:
  pushl $10
80106cbe:	6a 0a                	push   $0xa
  jmp alltraps
80106cc0:	e9 09 f9 ff ff       	jmp    801065ce <alltraps>

80106cc5 <vector11>:
.globl vector11
vector11:
  pushl $11
80106cc5:	6a 0b                	push   $0xb
  jmp alltraps
80106cc7:	e9 02 f9 ff ff       	jmp    801065ce <alltraps>

80106ccc <vector12>:
.globl vector12
vector12:
  pushl $12
80106ccc:	6a 0c                	push   $0xc
  jmp alltraps
80106cce:	e9 fb f8 ff ff       	jmp    801065ce <alltraps>

80106cd3 <vector13>:
.globl vector13
vector13:
  pushl $13
80106cd3:	6a 0d                	push   $0xd
  jmp alltraps
80106cd5:	e9 f4 f8 ff ff       	jmp    801065ce <alltraps>

80106cda <vector14>:
.globl vector14
vector14:
  pushl $14
80106cda:	6a 0e                	push   $0xe
  jmp alltraps
80106cdc:	e9 ed f8 ff ff       	jmp    801065ce <alltraps>

80106ce1 <vector15>:
.globl vector15
vector15:
  pushl $0
80106ce1:	6a 00                	push   $0x0
  pushl $15
80106ce3:	6a 0f                	push   $0xf
  jmp alltraps
80106ce5:	e9 e4 f8 ff ff       	jmp    801065ce <alltraps>

80106cea <vector16>:
.globl vector16
vector16:
  pushl $0
80106cea:	6a 00                	push   $0x0
  pushl $16
80106cec:	6a 10                	push   $0x10
  jmp alltraps
80106cee:	e9 db f8 ff ff       	jmp    801065ce <alltraps>

80106cf3 <vector17>:
.globl vector17
vector17:
  pushl $17
80106cf3:	6a 11                	push   $0x11
  jmp alltraps
80106cf5:	e9 d4 f8 ff ff       	jmp    801065ce <alltraps>

80106cfa <vector18>:
.globl vector18
vector18:
  pushl $0
80106cfa:	6a 00                	push   $0x0
  pushl $18
80106cfc:	6a 12                	push   $0x12
  jmp alltraps
80106cfe:	e9 cb f8 ff ff       	jmp    801065ce <alltraps>

80106d03 <vector19>:
.globl vector19
vector19:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $19
80106d05:	6a 13                	push   $0x13
  jmp alltraps
80106d07:	e9 c2 f8 ff ff       	jmp    801065ce <alltraps>

80106d0c <vector20>:
.globl vector20
vector20:
  pushl $0
80106d0c:	6a 00                	push   $0x0
  pushl $20
80106d0e:	6a 14                	push   $0x14
  jmp alltraps
80106d10:	e9 b9 f8 ff ff       	jmp    801065ce <alltraps>

80106d15 <vector21>:
.globl vector21
vector21:
  pushl $0
80106d15:	6a 00                	push   $0x0
  pushl $21
80106d17:	6a 15                	push   $0x15
  jmp alltraps
80106d19:	e9 b0 f8 ff ff       	jmp    801065ce <alltraps>

80106d1e <vector22>:
.globl vector22
vector22:
  pushl $0
80106d1e:	6a 00                	push   $0x0
  pushl $22
80106d20:	6a 16                	push   $0x16
  jmp alltraps
80106d22:	e9 a7 f8 ff ff       	jmp    801065ce <alltraps>

80106d27 <vector23>:
.globl vector23
vector23:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $23
80106d29:	6a 17                	push   $0x17
  jmp alltraps
80106d2b:	e9 9e f8 ff ff       	jmp    801065ce <alltraps>

80106d30 <vector24>:
.globl vector24
vector24:
  pushl $0
80106d30:	6a 00                	push   $0x0
  pushl $24
80106d32:	6a 18                	push   $0x18
  jmp alltraps
80106d34:	e9 95 f8 ff ff       	jmp    801065ce <alltraps>

80106d39 <vector25>:
.globl vector25
vector25:
  pushl $0
80106d39:	6a 00                	push   $0x0
  pushl $25
80106d3b:	6a 19                	push   $0x19
  jmp alltraps
80106d3d:	e9 8c f8 ff ff       	jmp    801065ce <alltraps>

80106d42 <vector26>:
.globl vector26
vector26:
  pushl $0
80106d42:	6a 00                	push   $0x0
  pushl $26
80106d44:	6a 1a                	push   $0x1a
  jmp alltraps
80106d46:	e9 83 f8 ff ff       	jmp    801065ce <alltraps>

80106d4b <vector27>:
.globl vector27
vector27:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $27
80106d4d:	6a 1b                	push   $0x1b
  jmp alltraps
80106d4f:	e9 7a f8 ff ff       	jmp    801065ce <alltraps>

80106d54 <vector28>:
.globl vector28
vector28:
  pushl $0
80106d54:	6a 00                	push   $0x0
  pushl $28
80106d56:	6a 1c                	push   $0x1c
  jmp alltraps
80106d58:	e9 71 f8 ff ff       	jmp    801065ce <alltraps>

80106d5d <vector29>:
.globl vector29
vector29:
  pushl $0
80106d5d:	6a 00                	push   $0x0
  pushl $29
80106d5f:	6a 1d                	push   $0x1d
  jmp alltraps
80106d61:	e9 68 f8 ff ff       	jmp    801065ce <alltraps>

80106d66 <vector30>:
.globl vector30
vector30:
  pushl $0
80106d66:	6a 00                	push   $0x0
  pushl $30
80106d68:	6a 1e                	push   $0x1e
  jmp alltraps
80106d6a:	e9 5f f8 ff ff       	jmp    801065ce <alltraps>

80106d6f <vector31>:
.globl vector31
vector31:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $31
80106d71:	6a 1f                	push   $0x1f
  jmp alltraps
80106d73:	e9 56 f8 ff ff       	jmp    801065ce <alltraps>

80106d78 <vector32>:
.globl vector32
vector32:
  pushl $0
80106d78:	6a 00                	push   $0x0
  pushl $32
80106d7a:	6a 20                	push   $0x20
  jmp alltraps
80106d7c:	e9 4d f8 ff ff       	jmp    801065ce <alltraps>

80106d81 <vector33>:
.globl vector33
vector33:
  pushl $0
80106d81:	6a 00                	push   $0x0
  pushl $33
80106d83:	6a 21                	push   $0x21
  jmp alltraps
80106d85:	e9 44 f8 ff ff       	jmp    801065ce <alltraps>

80106d8a <vector34>:
.globl vector34
vector34:
  pushl $0
80106d8a:	6a 00                	push   $0x0
  pushl $34
80106d8c:	6a 22                	push   $0x22
  jmp alltraps
80106d8e:	e9 3b f8 ff ff       	jmp    801065ce <alltraps>

80106d93 <vector35>:
.globl vector35
vector35:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $35
80106d95:	6a 23                	push   $0x23
  jmp alltraps
80106d97:	e9 32 f8 ff ff       	jmp    801065ce <alltraps>

80106d9c <vector36>:
.globl vector36
vector36:
  pushl $0
80106d9c:	6a 00                	push   $0x0
  pushl $36
80106d9e:	6a 24                	push   $0x24
  jmp alltraps
80106da0:	e9 29 f8 ff ff       	jmp    801065ce <alltraps>

80106da5 <vector37>:
.globl vector37
vector37:
  pushl $0
80106da5:	6a 00                	push   $0x0
  pushl $37
80106da7:	6a 25                	push   $0x25
  jmp alltraps
80106da9:	e9 20 f8 ff ff       	jmp    801065ce <alltraps>

80106dae <vector38>:
.globl vector38
vector38:
  pushl $0
80106dae:	6a 00                	push   $0x0
  pushl $38
80106db0:	6a 26                	push   $0x26
  jmp alltraps
80106db2:	e9 17 f8 ff ff       	jmp    801065ce <alltraps>

80106db7 <vector39>:
.globl vector39
vector39:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $39
80106db9:	6a 27                	push   $0x27
  jmp alltraps
80106dbb:	e9 0e f8 ff ff       	jmp    801065ce <alltraps>

80106dc0 <vector40>:
.globl vector40
vector40:
  pushl $0
80106dc0:	6a 00                	push   $0x0
  pushl $40
80106dc2:	6a 28                	push   $0x28
  jmp alltraps
80106dc4:	e9 05 f8 ff ff       	jmp    801065ce <alltraps>

80106dc9 <vector41>:
.globl vector41
vector41:
  pushl $0
80106dc9:	6a 00                	push   $0x0
  pushl $41
80106dcb:	6a 29                	push   $0x29
  jmp alltraps
80106dcd:	e9 fc f7 ff ff       	jmp    801065ce <alltraps>

80106dd2 <vector42>:
.globl vector42
vector42:
  pushl $0
80106dd2:	6a 00                	push   $0x0
  pushl $42
80106dd4:	6a 2a                	push   $0x2a
  jmp alltraps
80106dd6:	e9 f3 f7 ff ff       	jmp    801065ce <alltraps>

80106ddb <vector43>:
.globl vector43
vector43:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $43
80106ddd:	6a 2b                	push   $0x2b
  jmp alltraps
80106ddf:	e9 ea f7 ff ff       	jmp    801065ce <alltraps>

80106de4 <vector44>:
.globl vector44
vector44:
  pushl $0
80106de4:	6a 00                	push   $0x0
  pushl $44
80106de6:	6a 2c                	push   $0x2c
  jmp alltraps
80106de8:	e9 e1 f7 ff ff       	jmp    801065ce <alltraps>

80106ded <vector45>:
.globl vector45
vector45:
  pushl $0
80106ded:	6a 00                	push   $0x0
  pushl $45
80106def:	6a 2d                	push   $0x2d
  jmp alltraps
80106df1:	e9 d8 f7 ff ff       	jmp    801065ce <alltraps>

80106df6 <vector46>:
.globl vector46
vector46:
  pushl $0
80106df6:	6a 00                	push   $0x0
  pushl $46
80106df8:	6a 2e                	push   $0x2e
  jmp alltraps
80106dfa:	e9 cf f7 ff ff       	jmp    801065ce <alltraps>

80106dff <vector47>:
.globl vector47
vector47:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $47
80106e01:	6a 2f                	push   $0x2f
  jmp alltraps
80106e03:	e9 c6 f7 ff ff       	jmp    801065ce <alltraps>

80106e08 <vector48>:
.globl vector48
vector48:
  pushl $0
80106e08:	6a 00                	push   $0x0
  pushl $48
80106e0a:	6a 30                	push   $0x30
  jmp alltraps
80106e0c:	e9 bd f7 ff ff       	jmp    801065ce <alltraps>

80106e11 <vector49>:
.globl vector49
vector49:
  pushl $0
80106e11:	6a 00                	push   $0x0
  pushl $49
80106e13:	6a 31                	push   $0x31
  jmp alltraps
80106e15:	e9 b4 f7 ff ff       	jmp    801065ce <alltraps>

80106e1a <vector50>:
.globl vector50
vector50:
  pushl $0
80106e1a:	6a 00                	push   $0x0
  pushl $50
80106e1c:	6a 32                	push   $0x32
  jmp alltraps
80106e1e:	e9 ab f7 ff ff       	jmp    801065ce <alltraps>

80106e23 <vector51>:
.globl vector51
vector51:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $51
80106e25:	6a 33                	push   $0x33
  jmp alltraps
80106e27:	e9 a2 f7 ff ff       	jmp    801065ce <alltraps>

80106e2c <vector52>:
.globl vector52
vector52:
  pushl $0
80106e2c:	6a 00                	push   $0x0
  pushl $52
80106e2e:	6a 34                	push   $0x34
  jmp alltraps
80106e30:	e9 99 f7 ff ff       	jmp    801065ce <alltraps>

80106e35 <vector53>:
.globl vector53
vector53:
  pushl $0
80106e35:	6a 00                	push   $0x0
  pushl $53
80106e37:	6a 35                	push   $0x35
  jmp alltraps
80106e39:	e9 90 f7 ff ff       	jmp    801065ce <alltraps>

80106e3e <vector54>:
.globl vector54
vector54:
  pushl $0
80106e3e:	6a 00                	push   $0x0
  pushl $54
80106e40:	6a 36                	push   $0x36
  jmp alltraps
80106e42:	e9 87 f7 ff ff       	jmp    801065ce <alltraps>

80106e47 <vector55>:
.globl vector55
vector55:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $55
80106e49:	6a 37                	push   $0x37
  jmp alltraps
80106e4b:	e9 7e f7 ff ff       	jmp    801065ce <alltraps>

80106e50 <vector56>:
.globl vector56
vector56:
  pushl $0
80106e50:	6a 00                	push   $0x0
  pushl $56
80106e52:	6a 38                	push   $0x38
  jmp alltraps
80106e54:	e9 75 f7 ff ff       	jmp    801065ce <alltraps>

80106e59 <vector57>:
.globl vector57
vector57:
  pushl $0
80106e59:	6a 00                	push   $0x0
  pushl $57
80106e5b:	6a 39                	push   $0x39
  jmp alltraps
80106e5d:	e9 6c f7 ff ff       	jmp    801065ce <alltraps>

80106e62 <vector58>:
.globl vector58
vector58:
  pushl $0
80106e62:	6a 00                	push   $0x0
  pushl $58
80106e64:	6a 3a                	push   $0x3a
  jmp alltraps
80106e66:	e9 63 f7 ff ff       	jmp    801065ce <alltraps>

80106e6b <vector59>:
.globl vector59
vector59:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $59
80106e6d:	6a 3b                	push   $0x3b
  jmp alltraps
80106e6f:	e9 5a f7 ff ff       	jmp    801065ce <alltraps>

80106e74 <vector60>:
.globl vector60
vector60:
  pushl $0
80106e74:	6a 00                	push   $0x0
  pushl $60
80106e76:	6a 3c                	push   $0x3c
  jmp alltraps
80106e78:	e9 51 f7 ff ff       	jmp    801065ce <alltraps>

80106e7d <vector61>:
.globl vector61
vector61:
  pushl $0
80106e7d:	6a 00                	push   $0x0
  pushl $61
80106e7f:	6a 3d                	push   $0x3d
  jmp alltraps
80106e81:	e9 48 f7 ff ff       	jmp    801065ce <alltraps>

80106e86 <vector62>:
.globl vector62
vector62:
  pushl $0
80106e86:	6a 00                	push   $0x0
  pushl $62
80106e88:	6a 3e                	push   $0x3e
  jmp alltraps
80106e8a:	e9 3f f7 ff ff       	jmp    801065ce <alltraps>

80106e8f <vector63>:
.globl vector63
vector63:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $63
80106e91:	6a 3f                	push   $0x3f
  jmp alltraps
80106e93:	e9 36 f7 ff ff       	jmp    801065ce <alltraps>

80106e98 <vector64>:
.globl vector64
vector64:
  pushl $0
80106e98:	6a 00                	push   $0x0
  pushl $64
80106e9a:	6a 40                	push   $0x40
  jmp alltraps
80106e9c:	e9 2d f7 ff ff       	jmp    801065ce <alltraps>

80106ea1 <vector65>:
.globl vector65
vector65:
  pushl $0
80106ea1:	6a 00                	push   $0x0
  pushl $65
80106ea3:	6a 41                	push   $0x41
  jmp alltraps
80106ea5:	e9 24 f7 ff ff       	jmp    801065ce <alltraps>

80106eaa <vector66>:
.globl vector66
vector66:
  pushl $0
80106eaa:	6a 00                	push   $0x0
  pushl $66
80106eac:	6a 42                	push   $0x42
  jmp alltraps
80106eae:	e9 1b f7 ff ff       	jmp    801065ce <alltraps>

80106eb3 <vector67>:
.globl vector67
vector67:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $67
80106eb5:	6a 43                	push   $0x43
  jmp alltraps
80106eb7:	e9 12 f7 ff ff       	jmp    801065ce <alltraps>

80106ebc <vector68>:
.globl vector68
vector68:
  pushl $0
80106ebc:	6a 00                	push   $0x0
  pushl $68
80106ebe:	6a 44                	push   $0x44
  jmp alltraps
80106ec0:	e9 09 f7 ff ff       	jmp    801065ce <alltraps>

80106ec5 <vector69>:
.globl vector69
vector69:
  pushl $0
80106ec5:	6a 00                	push   $0x0
  pushl $69
80106ec7:	6a 45                	push   $0x45
  jmp alltraps
80106ec9:	e9 00 f7 ff ff       	jmp    801065ce <alltraps>

80106ece <vector70>:
.globl vector70
vector70:
  pushl $0
80106ece:	6a 00                	push   $0x0
  pushl $70
80106ed0:	6a 46                	push   $0x46
  jmp alltraps
80106ed2:	e9 f7 f6 ff ff       	jmp    801065ce <alltraps>

80106ed7 <vector71>:
.globl vector71
vector71:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $71
80106ed9:	6a 47                	push   $0x47
  jmp alltraps
80106edb:	e9 ee f6 ff ff       	jmp    801065ce <alltraps>

80106ee0 <vector72>:
.globl vector72
vector72:
  pushl $0
80106ee0:	6a 00                	push   $0x0
  pushl $72
80106ee2:	6a 48                	push   $0x48
  jmp alltraps
80106ee4:	e9 e5 f6 ff ff       	jmp    801065ce <alltraps>

80106ee9 <vector73>:
.globl vector73
vector73:
  pushl $0
80106ee9:	6a 00                	push   $0x0
  pushl $73
80106eeb:	6a 49                	push   $0x49
  jmp alltraps
80106eed:	e9 dc f6 ff ff       	jmp    801065ce <alltraps>

80106ef2 <vector74>:
.globl vector74
vector74:
  pushl $0
80106ef2:	6a 00                	push   $0x0
  pushl $74
80106ef4:	6a 4a                	push   $0x4a
  jmp alltraps
80106ef6:	e9 d3 f6 ff ff       	jmp    801065ce <alltraps>

80106efb <vector75>:
.globl vector75
vector75:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $75
80106efd:	6a 4b                	push   $0x4b
  jmp alltraps
80106eff:	e9 ca f6 ff ff       	jmp    801065ce <alltraps>

80106f04 <vector76>:
.globl vector76
vector76:
  pushl $0
80106f04:	6a 00                	push   $0x0
  pushl $76
80106f06:	6a 4c                	push   $0x4c
  jmp alltraps
80106f08:	e9 c1 f6 ff ff       	jmp    801065ce <alltraps>

80106f0d <vector77>:
.globl vector77
vector77:
  pushl $0
80106f0d:	6a 00                	push   $0x0
  pushl $77
80106f0f:	6a 4d                	push   $0x4d
  jmp alltraps
80106f11:	e9 b8 f6 ff ff       	jmp    801065ce <alltraps>

80106f16 <vector78>:
.globl vector78
vector78:
  pushl $0
80106f16:	6a 00                	push   $0x0
  pushl $78
80106f18:	6a 4e                	push   $0x4e
  jmp alltraps
80106f1a:	e9 af f6 ff ff       	jmp    801065ce <alltraps>

80106f1f <vector79>:
.globl vector79
vector79:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $79
80106f21:	6a 4f                	push   $0x4f
  jmp alltraps
80106f23:	e9 a6 f6 ff ff       	jmp    801065ce <alltraps>

80106f28 <vector80>:
.globl vector80
vector80:
  pushl $0
80106f28:	6a 00                	push   $0x0
  pushl $80
80106f2a:	6a 50                	push   $0x50
  jmp alltraps
80106f2c:	e9 9d f6 ff ff       	jmp    801065ce <alltraps>

80106f31 <vector81>:
.globl vector81
vector81:
  pushl $0
80106f31:	6a 00                	push   $0x0
  pushl $81
80106f33:	6a 51                	push   $0x51
  jmp alltraps
80106f35:	e9 94 f6 ff ff       	jmp    801065ce <alltraps>

80106f3a <vector82>:
.globl vector82
vector82:
  pushl $0
80106f3a:	6a 00                	push   $0x0
  pushl $82
80106f3c:	6a 52                	push   $0x52
  jmp alltraps
80106f3e:	e9 8b f6 ff ff       	jmp    801065ce <alltraps>

80106f43 <vector83>:
.globl vector83
vector83:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $83
80106f45:	6a 53                	push   $0x53
  jmp alltraps
80106f47:	e9 82 f6 ff ff       	jmp    801065ce <alltraps>

80106f4c <vector84>:
.globl vector84
vector84:
  pushl $0
80106f4c:	6a 00                	push   $0x0
  pushl $84
80106f4e:	6a 54                	push   $0x54
  jmp alltraps
80106f50:	e9 79 f6 ff ff       	jmp    801065ce <alltraps>

80106f55 <vector85>:
.globl vector85
vector85:
  pushl $0
80106f55:	6a 00                	push   $0x0
  pushl $85
80106f57:	6a 55                	push   $0x55
  jmp alltraps
80106f59:	e9 70 f6 ff ff       	jmp    801065ce <alltraps>

80106f5e <vector86>:
.globl vector86
vector86:
  pushl $0
80106f5e:	6a 00                	push   $0x0
  pushl $86
80106f60:	6a 56                	push   $0x56
  jmp alltraps
80106f62:	e9 67 f6 ff ff       	jmp    801065ce <alltraps>

80106f67 <vector87>:
.globl vector87
vector87:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $87
80106f69:	6a 57                	push   $0x57
  jmp alltraps
80106f6b:	e9 5e f6 ff ff       	jmp    801065ce <alltraps>

80106f70 <vector88>:
.globl vector88
vector88:
  pushl $0
80106f70:	6a 00                	push   $0x0
  pushl $88
80106f72:	6a 58                	push   $0x58
  jmp alltraps
80106f74:	e9 55 f6 ff ff       	jmp    801065ce <alltraps>

80106f79 <vector89>:
.globl vector89
vector89:
  pushl $0
80106f79:	6a 00                	push   $0x0
  pushl $89
80106f7b:	6a 59                	push   $0x59
  jmp alltraps
80106f7d:	e9 4c f6 ff ff       	jmp    801065ce <alltraps>

80106f82 <vector90>:
.globl vector90
vector90:
  pushl $0
80106f82:	6a 00                	push   $0x0
  pushl $90
80106f84:	6a 5a                	push   $0x5a
  jmp alltraps
80106f86:	e9 43 f6 ff ff       	jmp    801065ce <alltraps>

80106f8b <vector91>:
.globl vector91
vector91:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $91
80106f8d:	6a 5b                	push   $0x5b
  jmp alltraps
80106f8f:	e9 3a f6 ff ff       	jmp    801065ce <alltraps>

80106f94 <vector92>:
.globl vector92
vector92:
  pushl $0
80106f94:	6a 00                	push   $0x0
  pushl $92
80106f96:	6a 5c                	push   $0x5c
  jmp alltraps
80106f98:	e9 31 f6 ff ff       	jmp    801065ce <alltraps>

80106f9d <vector93>:
.globl vector93
vector93:
  pushl $0
80106f9d:	6a 00                	push   $0x0
  pushl $93
80106f9f:	6a 5d                	push   $0x5d
  jmp alltraps
80106fa1:	e9 28 f6 ff ff       	jmp    801065ce <alltraps>

80106fa6 <vector94>:
.globl vector94
vector94:
  pushl $0
80106fa6:	6a 00                	push   $0x0
  pushl $94
80106fa8:	6a 5e                	push   $0x5e
  jmp alltraps
80106faa:	e9 1f f6 ff ff       	jmp    801065ce <alltraps>

80106faf <vector95>:
.globl vector95
vector95:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $95
80106fb1:	6a 5f                	push   $0x5f
  jmp alltraps
80106fb3:	e9 16 f6 ff ff       	jmp    801065ce <alltraps>

80106fb8 <vector96>:
.globl vector96
vector96:
  pushl $0
80106fb8:	6a 00                	push   $0x0
  pushl $96
80106fba:	6a 60                	push   $0x60
  jmp alltraps
80106fbc:	e9 0d f6 ff ff       	jmp    801065ce <alltraps>

80106fc1 <vector97>:
.globl vector97
vector97:
  pushl $0
80106fc1:	6a 00                	push   $0x0
  pushl $97
80106fc3:	6a 61                	push   $0x61
  jmp alltraps
80106fc5:	e9 04 f6 ff ff       	jmp    801065ce <alltraps>

80106fca <vector98>:
.globl vector98
vector98:
  pushl $0
80106fca:	6a 00                	push   $0x0
  pushl $98
80106fcc:	6a 62                	push   $0x62
  jmp alltraps
80106fce:	e9 fb f5 ff ff       	jmp    801065ce <alltraps>

80106fd3 <vector99>:
.globl vector99
vector99:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $99
80106fd5:	6a 63                	push   $0x63
  jmp alltraps
80106fd7:	e9 f2 f5 ff ff       	jmp    801065ce <alltraps>

80106fdc <vector100>:
.globl vector100
vector100:
  pushl $0
80106fdc:	6a 00                	push   $0x0
  pushl $100
80106fde:	6a 64                	push   $0x64
  jmp alltraps
80106fe0:	e9 e9 f5 ff ff       	jmp    801065ce <alltraps>

80106fe5 <vector101>:
.globl vector101
vector101:
  pushl $0
80106fe5:	6a 00                	push   $0x0
  pushl $101
80106fe7:	6a 65                	push   $0x65
  jmp alltraps
80106fe9:	e9 e0 f5 ff ff       	jmp    801065ce <alltraps>

80106fee <vector102>:
.globl vector102
vector102:
  pushl $0
80106fee:	6a 00                	push   $0x0
  pushl $102
80106ff0:	6a 66                	push   $0x66
  jmp alltraps
80106ff2:	e9 d7 f5 ff ff       	jmp    801065ce <alltraps>

80106ff7 <vector103>:
.globl vector103
vector103:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $103
80106ff9:	6a 67                	push   $0x67
  jmp alltraps
80106ffb:	e9 ce f5 ff ff       	jmp    801065ce <alltraps>

80107000 <vector104>:
.globl vector104
vector104:
  pushl $0
80107000:	6a 00                	push   $0x0
  pushl $104
80107002:	6a 68                	push   $0x68
  jmp alltraps
80107004:	e9 c5 f5 ff ff       	jmp    801065ce <alltraps>

80107009 <vector105>:
.globl vector105
vector105:
  pushl $0
80107009:	6a 00                	push   $0x0
  pushl $105
8010700b:	6a 69                	push   $0x69
  jmp alltraps
8010700d:	e9 bc f5 ff ff       	jmp    801065ce <alltraps>

80107012 <vector106>:
.globl vector106
vector106:
  pushl $0
80107012:	6a 00                	push   $0x0
  pushl $106
80107014:	6a 6a                	push   $0x6a
  jmp alltraps
80107016:	e9 b3 f5 ff ff       	jmp    801065ce <alltraps>

8010701b <vector107>:
.globl vector107
vector107:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $107
8010701d:	6a 6b                	push   $0x6b
  jmp alltraps
8010701f:	e9 aa f5 ff ff       	jmp    801065ce <alltraps>

80107024 <vector108>:
.globl vector108
vector108:
  pushl $0
80107024:	6a 00                	push   $0x0
  pushl $108
80107026:	6a 6c                	push   $0x6c
  jmp alltraps
80107028:	e9 a1 f5 ff ff       	jmp    801065ce <alltraps>

8010702d <vector109>:
.globl vector109
vector109:
  pushl $0
8010702d:	6a 00                	push   $0x0
  pushl $109
8010702f:	6a 6d                	push   $0x6d
  jmp alltraps
80107031:	e9 98 f5 ff ff       	jmp    801065ce <alltraps>

80107036 <vector110>:
.globl vector110
vector110:
  pushl $0
80107036:	6a 00                	push   $0x0
  pushl $110
80107038:	6a 6e                	push   $0x6e
  jmp alltraps
8010703a:	e9 8f f5 ff ff       	jmp    801065ce <alltraps>

8010703f <vector111>:
.globl vector111
vector111:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $111
80107041:	6a 6f                	push   $0x6f
  jmp alltraps
80107043:	e9 86 f5 ff ff       	jmp    801065ce <alltraps>

80107048 <vector112>:
.globl vector112
vector112:
  pushl $0
80107048:	6a 00                	push   $0x0
  pushl $112
8010704a:	6a 70                	push   $0x70
  jmp alltraps
8010704c:	e9 7d f5 ff ff       	jmp    801065ce <alltraps>

80107051 <vector113>:
.globl vector113
vector113:
  pushl $0
80107051:	6a 00                	push   $0x0
  pushl $113
80107053:	6a 71                	push   $0x71
  jmp alltraps
80107055:	e9 74 f5 ff ff       	jmp    801065ce <alltraps>

8010705a <vector114>:
.globl vector114
vector114:
  pushl $0
8010705a:	6a 00                	push   $0x0
  pushl $114
8010705c:	6a 72                	push   $0x72
  jmp alltraps
8010705e:	e9 6b f5 ff ff       	jmp    801065ce <alltraps>

80107063 <vector115>:
.globl vector115
vector115:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $115
80107065:	6a 73                	push   $0x73
  jmp alltraps
80107067:	e9 62 f5 ff ff       	jmp    801065ce <alltraps>

8010706c <vector116>:
.globl vector116
vector116:
  pushl $0
8010706c:	6a 00                	push   $0x0
  pushl $116
8010706e:	6a 74                	push   $0x74
  jmp alltraps
80107070:	e9 59 f5 ff ff       	jmp    801065ce <alltraps>

80107075 <vector117>:
.globl vector117
vector117:
  pushl $0
80107075:	6a 00                	push   $0x0
  pushl $117
80107077:	6a 75                	push   $0x75
  jmp alltraps
80107079:	e9 50 f5 ff ff       	jmp    801065ce <alltraps>

8010707e <vector118>:
.globl vector118
vector118:
  pushl $0
8010707e:	6a 00                	push   $0x0
  pushl $118
80107080:	6a 76                	push   $0x76
  jmp alltraps
80107082:	e9 47 f5 ff ff       	jmp    801065ce <alltraps>

80107087 <vector119>:
.globl vector119
vector119:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $119
80107089:	6a 77                	push   $0x77
  jmp alltraps
8010708b:	e9 3e f5 ff ff       	jmp    801065ce <alltraps>

80107090 <vector120>:
.globl vector120
vector120:
  pushl $0
80107090:	6a 00                	push   $0x0
  pushl $120
80107092:	6a 78                	push   $0x78
  jmp alltraps
80107094:	e9 35 f5 ff ff       	jmp    801065ce <alltraps>

80107099 <vector121>:
.globl vector121
vector121:
  pushl $0
80107099:	6a 00                	push   $0x0
  pushl $121
8010709b:	6a 79                	push   $0x79
  jmp alltraps
8010709d:	e9 2c f5 ff ff       	jmp    801065ce <alltraps>

801070a2 <vector122>:
.globl vector122
vector122:
  pushl $0
801070a2:	6a 00                	push   $0x0
  pushl $122
801070a4:	6a 7a                	push   $0x7a
  jmp alltraps
801070a6:	e9 23 f5 ff ff       	jmp    801065ce <alltraps>

801070ab <vector123>:
.globl vector123
vector123:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $123
801070ad:	6a 7b                	push   $0x7b
  jmp alltraps
801070af:	e9 1a f5 ff ff       	jmp    801065ce <alltraps>

801070b4 <vector124>:
.globl vector124
vector124:
  pushl $0
801070b4:	6a 00                	push   $0x0
  pushl $124
801070b6:	6a 7c                	push   $0x7c
  jmp alltraps
801070b8:	e9 11 f5 ff ff       	jmp    801065ce <alltraps>

801070bd <vector125>:
.globl vector125
vector125:
  pushl $0
801070bd:	6a 00                	push   $0x0
  pushl $125
801070bf:	6a 7d                	push   $0x7d
  jmp alltraps
801070c1:	e9 08 f5 ff ff       	jmp    801065ce <alltraps>

801070c6 <vector126>:
.globl vector126
vector126:
  pushl $0
801070c6:	6a 00                	push   $0x0
  pushl $126
801070c8:	6a 7e                	push   $0x7e
  jmp alltraps
801070ca:	e9 ff f4 ff ff       	jmp    801065ce <alltraps>

801070cf <vector127>:
.globl vector127
vector127:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $127
801070d1:	6a 7f                	push   $0x7f
  jmp alltraps
801070d3:	e9 f6 f4 ff ff       	jmp    801065ce <alltraps>

801070d8 <vector128>:
.globl vector128
vector128:
  pushl $0
801070d8:	6a 00                	push   $0x0
  pushl $128
801070da:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801070df:	e9 ea f4 ff ff       	jmp    801065ce <alltraps>

801070e4 <vector129>:
.globl vector129
vector129:
  pushl $0
801070e4:	6a 00                	push   $0x0
  pushl $129
801070e6:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801070eb:	e9 de f4 ff ff       	jmp    801065ce <alltraps>

801070f0 <vector130>:
.globl vector130
vector130:
  pushl $0
801070f0:	6a 00                	push   $0x0
  pushl $130
801070f2:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801070f7:	e9 d2 f4 ff ff       	jmp    801065ce <alltraps>

801070fc <vector131>:
.globl vector131
vector131:
  pushl $0
801070fc:	6a 00                	push   $0x0
  pushl $131
801070fe:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107103:	e9 c6 f4 ff ff       	jmp    801065ce <alltraps>

80107108 <vector132>:
.globl vector132
vector132:
  pushl $0
80107108:	6a 00                	push   $0x0
  pushl $132
8010710a:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010710f:	e9 ba f4 ff ff       	jmp    801065ce <alltraps>

80107114 <vector133>:
.globl vector133
vector133:
  pushl $0
80107114:	6a 00                	push   $0x0
  pushl $133
80107116:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010711b:	e9 ae f4 ff ff       	jmp    801065ce <alltraps>

80107120 <vector134>:
.globl vector134
vector134:
  pushl $0
80107120:	6a 00                	push   $0x0
  pushl $134
80107122:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107127:	e9 a2 f4 ff ff       	jmp    801065ce <alltraps>

8010712c <vector135>:
.globl vector135
vector135:
  pushl $0
8010712c:	6a 00                	push   $0x0
  pushl $135
8010712e:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107133:	e9 96 f4 ff ff       	jmp    801065ce <alltraps>

80107138 <vector136>:
.globl vector136
vector136:
  pushl $0
80107138:	6a 00                	push   $0x0
  pushl $136
8010713a:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010713f:	e9 8a f4 ff ff       	jmp    801065ce <alltraps>

80107144 <vector137>:
.globl vector137
vector137:
  pushl $0
80107144:	6a 00                	push   $0x0
  pushl $137
80107146:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010714b:	e9 7e f4 ff ff       	jmp    801065ce <alltraps>

80107150 <vector138>:
.globl vector138
vector138:
  pushl $0
80107150:	6a 00                	push   $0x0
  pushl $138
80107152:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107157:	e9 72 f4 ff ff       	jmp    801065ce <alltraps>

8010715c <vector139>:
.globl vector139
vector139:
  pushl $0
8010715c:	6a 00                	push   $0x0
  pushl $139
8010715e:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107163:	e9 66 f4 ff ff       	jmp    801065ce <alltraps>

80107168 <vector140>:
.globl vector140
vector140:
  pushl $0
80107168:	6a 00                	push   $0x0
  pushl $140
8010716a:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010716f:	e9 5a f4 ff ff       	jmp    801065ce <alltraps>

80107174 <vector141>:
.globl vector141
vector141:
  pushl $0
80107174:	6a 00                	push   $0x0
  pushl $141
80107176:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010717b:	e9 4e f4 ff ff       	jmp    801065ce <alltraps>

80107180 <vector142>:
.globl vector142
vector142:
  pushl $0
80107180:	6a 00                	push   $0x0
  pushl $142
80107182:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107187:	e9 42 f4 ff ff       	jmp    801065ce <alltraps>

8010718c <vector143>:
.globl vector143
vector143:
  pushl $0
8010718c:	6a 00                	push   $0x0
  pushl $143
8010718e:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107193:	e9 36 f4 ff ff       	jmp    801065ce <alltraps>

80107198 <vector144>:
.globl vector144
vector144:
  pushl $0
80107198:	6a 00                	push   $0x0
  pushl $144
8010719a:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010719f:	e9 2a f4 ff ff       	jmp    801065ce <alltraps>

801071a4 <vector145>:
.globl vector145
vector145:
  pushl $0
801071a4:	6a 00                	push   $0x0
  pushl $145
801071a6:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801071ab:	e9 1e f4 ff ff       	jmp    801065ce <alltraps>

801071b0 <vector146>:
.globl vector146
vector146:
  pushl $0
801071b0:	6a 00                	push   $0x0
  pushl $146
801071b2:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801071b7:	e9 12 f4 ff ff       	jmp    801065ce <alltraps>

801071bc <vector147>:
.globl vector147
vector147:
  pushl $0
801071bc:	6a 00                	push   $0x0
  pushl $147
801071be:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801071c3:	e9 06 f4 ff ff       	jmp    801065ce <alltraps>

801071c8 <vector148>:
.globl vector148
vector148:
  pushl $0
801071c8:	6a 00                	push   $0x0
  pushl $148
801071ca:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801071cf:	e9 fa f3 ff ff       	jmp    801065ce <alltraps>

801071d4 <vector149>:
.globl vector149
vector149:
  pushl $0
801071d4:	6a 00                	push   $0x0
  pushl $149
801071d6:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801071db:	e9 ee f3 ff ff       	jmp    801065ce <alltraps>

801071e0 <vector150>:
.globl vector150
vector150:
  pushl $0
801071e0:	6a 00                	push   $0x0
  pushl $150
801071e2:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801071e7:	e9 e2 f3 ff ff       	jmp    801065ce <alltraps>

801071ec <vector151>:
.globl vector151
vector151:
  pushl $0
801071ec:	6a 00                	push   $0x0
  pushl $151
801071ee:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801071f3:	e9 d6 f3 ff ff       	jmp    801065ce <alltraps>

801071f8 <vector152>:
.globl vector152
vector152:
  pushl $0
801071f8:	6a 00                	push   $0x0
  pushl $152
801071fa:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801071ff:	e9 ca f3 ff ff       	jmp    801065ce <alltraps>

80107204 <vector153>:
.globl vector153
vector153:
  pushl $0
80107204:	6a 00                	push   $0x0
  pushl $153
80107206:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010720b:	e9 be f3 ff ff       	jmp    801065ce <alltraps>

80107210 <vector154>:
.globl vector154
vector154:
  pushl $0
80107210:	6a 00                	push   $0x0
  pushl $154
80107212:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107217:	e9 b2 f3 ff ff       	jmp    801065ce <alltraps>

8010721c <vector155>:
.globl vector155
vector155:
  pushl $0
8010721c:	6a 00                	push   $0x0
  pushl $155
8010721e:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107223:	e9 a6 f3 ff ff       	jmp    801065ce <alltraps>

80107228 <vector156>:
.globl vector156
vector156:
  pushl $0
80107228:	6a 00                	push   $0x0
  pushl $156
8010722a:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010722f:	e9 9a f3 ff ff       	jmp    801065ce <alltraps>

80107234 <vector157>:
.globl vector157
vector157:
  pushl $0
80107234:	6a 00                	push   $0x0
  pushl $157
80107236:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010723b:	e9 8e f3 ff ff       	jmp    801065ce <alltraps>

80107240 <vector158>:
.globl vector158
vector158:
  pushl $0
80107240:	6a 00                	push   $0x0
  pushl $158
80107242:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107247:	e9 82 f3 ff ff       	jmp    801065ce <alltraps>

8010724c <vector159>:
.globl vector159
vector159:
  pushl $0
8010724c:	6a 00                	push   $0x0
  pushl $159
8010724e:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107253:	e9 76 f3 ff ff       	jmp    801065ce <alltraps>

80107258 <vector160>:
.globl vector160
vector160:
  pushl $0
80107258:	6a 00                	push   $0x0
  pushl $160
8010725a:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010725f:	e9 6a f3 ff ff       	jmp    801065ce <alltraps>

80107264 <vector161>:
.globl vector161
vector161:
  pushl $0
80107264:	6a 00                	push   $0x0
  pushl $161
80107266:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010726b:	e9 5e f3 ff ff       	jmp    801065ce <alltraps>

80107270 <vector162>:
.globl vector162
vector162:
  pushl $0
80107270:	6a 00                	push   $0x0
  pushl $162
80107272:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107277:	e9 52 f3 ff ff       	jmp    801065ce <alltraps>

8010727c <vector163>:
.globl vector163
vector163:
  pushl $0
8010727c:	6a 00                	push   $0x0
  pushl $163
8010727e:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107283:	e9 46 f3 ff ff       	jmp    801065ce <alltraps>

80107288 <vector164>:
.globl vector164
vector164:
  pushl $0
80107288:	6a 00                	push   $0x0
  pushl $164
8010728a:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010728f:	e9 3a f3 ff ff       	jmp    801065ce <alltraps>

80107294 <vector165>:
.globl vector165
vector165:
  pushl $0
80107294:	6a 00                	push   $0x0
  pushl $165
80107296:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010729b:	e9 2e f3 ff ff       	jmp    801065ce <alltraps>

801072a0 <vector166>:
.globl vector166
vector166:
  pushl $0
801072a0:	6a 00                	push   $0x0
  pushl $166
801072a2:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801072a7:	e9 22 f3 ff ff       	jmp    801065ce <alltraps>

801072ac <vector167>:
.globl vector167
vector167:
  pushl $0
801072ac:	6a 00                	push   $0x0
  pushl $167
801072ae:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801072b3:	e9 16 f3 ff ff       	jmp    801065ce <alltraps>

801072b8 <vector168>:
.globl vector168
vector168:
  pushl $0
801072b8:	6a 00                	push   $0x0
  pushl $168
801072ba:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801072bf:	e9 0a f3 ff ff       	jmp    801065ce <alltraps>

801072c4 <vector169>:
.globl vector169
vector169:
  pushl $0
801072c4:	6a 00                	push   $0x0
  pushl $169
801072c6:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801072cb:	e9 fe f2 ff ff       	jmp    801065ce <alltraps>

801072d0 <vector170>:
.globl vector170
vector170:
  pushl $0
801072d0:	6a 00                	push   $0x0
  pushl $170
801072d2:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801072d7:	e9 f2 f2 ff ff       	jmp    801065ce <alltraps>

801072dc <vector171>:
.globl vector171
vector171:
  pushl $0
801072dc:	6a 00                	push   $0x0
  pushl $171
801072de:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801072e3:	e9 e6 f2 ff ff       	jmp    801065ce <alltraps>

801072e8 <vector172>:
.globl vector172
vector172:
  pushl $0
801072e8:	6a 00                	push   $0x0
  pushl $172
801072ea:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801072ef:	e9 da f2 ff ff       	jmp    801065ce <alltraps>

801072f4 <vector173>:
.globl vector173
vector173:
  pushl $0
801072f4:	6a 00                	push   $0x0
  pushl $173
801072f6:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801072fb:	e9 ce f2 ff ff       	jmp    801065ce <alltraps>

80107300 <vector174>:
.globl vector174
vector174:
  pushl $0
80107300:	6a 00                	push   $0x0
  pushl $174
80107302:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107307:	e9 c2 f2 ff ff       	jmp    801065ce <alltraps>

8010730c <vector175>:
.globl vector175
vector175:
  pushl $0
8010730c:	6a 00                	push   $0x0
  pushl $175
8010730e:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107313:	e9 b6 f2 ff ff       	jmp    801065ce <alltraps>

80107318 <vector176>:
.globl vector176
vector176:
  pushl $0
80107318:	6a 00                	push   $0x0
  pushl $176
8010731a:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010731f:	e9 aa f2 ff ff       	jmp    801065ce <alltraps>

80107324 <vector177>:
.globl vector177
vector177:
  pushl $0
80107324:	6a 00                	push   $0x0
  pushl $177
80107326:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010732b:	e9 9e f2 ff ff       	jmp    801065ce <alltraps>

80107330 <vector178>:
.globl vector178
vector178:
  pushl $0
80107330:	6a 00                	push   $0x0
  pushl $178
80107332:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107337:	e9 92 f2 ff ff       	jmp    801065ce <alltraps>

8010733c <vector179>:
.globl vector179
vector179:
  pushl $0
8010733c:	6a 00                	push   $0x0
  pushl $179
8010733e:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107343:	e9 86 f2 ff ff       	jmp    801065ce <alltraps>

80107348 <vector180>:
.globl vector180
vector180:
  pushl $0
80107348:	6a 00                	push   $0x0
  pushl $180
8010734a:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010734f:	e9 7a f2 ff ff       	jmp    801065ce <alltraps>

80107354 <vector181>:
.globl vector181
vector181:
  pushl $0
80107354:	6a 00                	push   $0x0
  pushl $181
80107356:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010735b:	e9 6e f2 ff ff       	jmp    801065ce <alltraps>

80107360 <vector182>:
.globl vector182
vector182:
  pushl $0
80107360:	6a 00                	push   $0x0
  pushl $182
80107362:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107367:	e9 62 f2 ff ff       	jmp    801065ce <alltraps>

8010736c <vector183>:
.globl vector183
vector183:
  pushl $0
8010736c:	6a 00                	push   $0x0
  pushl $183
8010736e:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107373:	e9 56 f2 ff ff       	jmp    801065ce <alltraps>

80107378 <vector184>:
.globl vector184
vector184:
  pushl $0
80107378:	6a 00                	push   $0x0
  pushl $184
8010737a:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010737f:	e9 4a f2 ff ff       	jmp    801065ce <alltraps>

80107384 <vector185>:
.globl vector185
vector185:
  pushl $0
80107384:	6a 00                	push   $0x0
  pushl $185
80107386:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010738b:	e9 3e f2 ff ff       	jmp    801065ce <alltraps>

80107390 <vector186>:
.globl vector186
vector186:
  pushl $0
80107390:	6a 00                	push   $0x0
  pushl $186
80107392:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107397:	e9 32 f2 ff ff       	jmp    801065ce <alltraps>

8010739c <vector187>:
.globl vector187
vector187:
  pushl $0
8010739c:	6a 00                	push   $0x0
  pushl $187
8010739e:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801073a3:	e9 26 f2 ff ff       	jmp    801065ce <alltraps>

801073a8 <vector188>:
.globl vector188
vector188:
  pushl $0
801073a8:	6a 00                	push   $0x0
  pushl $188
801073aa:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801073af:	e9 1a f2 ff ff       	jmp    801065ce <alltraps>

801073b4 <vector189>:
.globl vector189
vector189:
  pushl $0
801073b4:	6a 00                	push   $0x0
  pushl $189
801073b6:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801073bb:	e9 0e f2 ff ff       	jmp    801065ce <alltraps>

801073c0 <vector190>:
.globl vector190
vector190:
  pushl $0
801073c0:	6a 00                	push   $0x0
  pushl $190
801073c2:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801073c7:	e9 02 f2 ff ff       	jmp    801065ce <alltraps>

801073cc <vector191>:
.globl vector191
vector191:
  pushl $0
801073cc:	6a 00                	push   $0x0
  pushl $191
801073ce:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801073d3:	e9 f6 f1 ff ff       	jmp    801065ce <alltraps>

801073d8 <vector192>:
.globl vector192
vector192:
  pushl $0
801073d8:	6a 00                	push   $0x0
  pushl $192
801073da:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801073df:	e9 ea f1 ff ff       	jmp    801065ce <alltraps>

801073e4 <vector193>:
.globl vector193
vector193:
  pushl $0
801073e4:	6a 00                	push   $0x0
  pushl $193
801073e6:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801073eb:	e9 de f1 ff ff       	jmp    801065ce <alltraps>

801073f0 <vector194>:
.globl vector194
vector194:
  pushl $0
801073f0:	6a 00                	push   $0x0
  pushl $194
801073f2:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801073f7:	e9 d2 f1 ff ff       	jmp    801065ce <alltraps>

801073fc <vector195>:
.globl vector195
vector195:
  pushl $0
801073fc:	6a 00                	push   $0x0
  pushl $195
801073fe:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107403:	e9 c6 f1 ff ff       	jmp    801065ce <alltraps>

80107408 <vector196>:
.globl vector196
vector196:
  pushl $0
80107408:	6a 00                	push   $0x0
  pushl $196
8010740a:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010740f:	e9 ba f1 ff ff       	jmp    801065ce <alltraps>

80107414 <vector197>:
.globl vector197
vector197:
  pushl $0
80107414:	6a 00                	push   $0x0
  pushl $197
80107416:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010741b:	e9 ae f1 ff ff       	jmp    801065ce <alltraps>

80107420 <vector198>:
.globl vector198
vector198:
  pushl $0
80107420:	6a 00                	push   $0x0
  pushl $198
80107422:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107427:	e9 a2 f1 ff ff       	jmp    801065ce <alltraps>

8010742c <vector199>:
.globl vector199
vector199:
  pushl $0
8010742c:	6a 00                	push   $0x0
  pushl $199
8010742e:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107433:	e9 96 f1 ff ff       	jmp    801065ce <alltraps>

80107438 <vector200>:
.globl vector200
vector200:
  pushl $0
80107438:	6a 00                	push   $0x0
  pushl $200
8010743a:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010743f:	e9 8a f1 ff ff       	jmp    801065ce <alltraps>

80107444 <vector201>:
.globl vector201
vector201:
  pushl $0
80107444:	6a 00                	push   $0x0
  pushl $201
80107446:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010744b:	e9 7e f1 ff ff       	jmp    801065ce <alltraps>

80107450 <vector202>:
.globl vector202
vector202:
  pushl $0
80107450:	6a 00                	push   $0x0
  pushl $202
80107452:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107457:	e9 72 f1 ff ff       	jmp    801065ce <alltraps>

8010745c <vector203>:
.globl vector203
vector203:
  pushl $0
8010745c:	6a 00                	push   $0x0
  pushl $203
8010745e:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107463:	e9 66 f1 ff ff       	jmp    801065ce <alltraps>

80107468 <vector204>:
.globl vector204
vector204:
  pushl $0
80107468:	6a 00                	push   $0x0
  pushl $204
8010746a:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010746f:	e9 5a f1 ff ff       	jmp    801065ce <alltraps>

80107474 <vector205>:
.globl vector205
vector205:
  pushl $0
80107474:	6a 00                	push   $0x0
  pushl $205
80107476:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010747b:	e9 4e f1 ff ff       	jmp    801065ce <alltraps>

80107480 <vector206>:
.globl vector206
vector206:
  pushl $0
80107480:	6a 00                	push   $0x0
  pushl $206
80107482:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107487:	e9 42 f1 ff ff       	jmp    801065ce <alltraps>

8010748c <vector207>:
.globl vector207
vector207:
  pushl $0
8010748c:	6a 00                	push   $0x0
  pushl $207
8010748e:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107493:	e9 36 f1 ff ff       	jmp    801065ce <alltraps>

80107498 <vector208>:
.globl vector208
vector208:
  pushl $0
80107498:	6a 00                	push   $0x0
  pushl $208
8010749a:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010749f:	e9 2a f1 ff ff       	jmp    801065ce <alltraps>

801074a4 <vector209>:
.globl vector209
vector209:
  pushl $0
801074a4:	6a 00                	push   $0x0
  pushl $209
801074a6:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801074ab:	e9 1e f1 ff ff       	jmp    801065ce <alltraps>

801074b0 <vector210>:
.globl vector210
vector210:
  pushl $0
801074b0:	6a 00                	push   $0x0
  pushl $210
801074b2:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801074b7:	e9 12 f1 ff ff       	jmp    801065ce <alltraps>

801074bc <vector211>:
.globl vector211
vector211:
  pushl $0
801074bc:	6a 00                	push   $0x0
  pushl $211
801074be:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801074c3:	e9 06 f1 ff ff       	jmp    801065ce <alltraps>

801074c8 <vector212>:
.globl vector212
vector212:
  pushl $0
801074c8:	6a 00                	push   $0x0
  pushl $212
801074ca:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801074cf:	e9 fa f0 ff ff       	jmp    801065ce <alltraps>

801074d4 <vector213>:
.globl vector213
vector213:
  pushl $0
801074d4:	6a 00                	push   $0x0
  pushl $213
801074d6:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801074db:	e9 ee f0 ff ff       	jmp    801065ce <alltraps>

801074e0 <vector214>:
.globl vector214
vector214:
  pushl $0
801074e0:	6a 00                	push   $0x0
  pushl $214
801074e2:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801074e7:	e9 e2 f0 ff ff       	jmp    801065ce <alltraps>

801074ec <vector215>:
.globl vector215
vector215:
  pushl $0
801074ec:	6a 00                	push   $0x0
  pushl $215
801074ee:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801074f3:	e9 d6 f0 ff ff       	jmp    801065ce <alltraps>

801074f8 <vector216>:
.globl vector216
vector216:
  pushl $0
801074f8:	6a 00                	push   $0x0
  pushl $216
801074fa:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801074ff:	e9 ca f0 ff ff       	jmp    801065ce <alltraps>

80107504 <vector217>:
.globl vector217
vector217:
  pushl $0
80107504:	6a 00                	push   $0x0
  pushl $217
80107506:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010750b:	e9 be f0 ff ff       	jmp    801065ce <alltraps>

80107510 <vector218>:
.globl vector218
vector218:
  pushl $0
80107510:	6a 00                	push   $0x0
  pushl $218
80107512:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107517:	e9 b2 f0 ff ff       	jmp    801065ce <alltraps>

8010751c <vector219>:
.globl vector219
vector219:
  pushl $0
8010751c:	6a 00                	push   $0x0
  pushl $219
8010751e:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107523:	e9 a6 f0 ff ff       	jmp    801065ce <alltraps>

80107528 <vector220>:
.globl vector220
vector220:
  pushl $0
80107528:	6a 00                	push   $0x0
  pushl $220
8010752a:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010752f:	e9 9a f0 ff ff       	jmp    801065ce <alltraps>

80107534 <vector221>:
.globl vector221
vector221:
  pushl $0
80107534:	6a 00                	push   $0x0
  pushl $221
80107536:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010753b:	e9 8e f0 ff ff       	jmp    801065ce <alltraps>

80107540 <vector222>:
.globl vector222
vector222:
  pushl $0
80107540:	6a 00                	push   $0x0
  pushl $222
80107542:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107547:	e9 82 f0 ff ff       	jmp    801065ce <alltraps>

8010754c <vector223>:
.globl vector223
vector223:
  pushl $0
8010754c:	6a 00                	push   $0x0
  pushl $223
8010754e:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107553:	e9 76 f0 ff ff       	jmp    801065ce <alltraps>

80107558 <vector224>:
.globl vector224
vector224:
  pushl $0
80107558:	6a 00                	push   $0x0
  pushl $224
8010755a:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010755f:	e9 6a f0 ff ff       	jmp    801065ce <alltraps>

80107564 <vector225>:
.globl vector225
vector225:
  pushl $0
80107564:	6a 00                	push   $0x0
  pushl $225
80107566:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010756b:	e9 5e f0 ff ff       	jmp    801065ce <alltraps>

80107570 <vector226>:
.globl vector226
vector226:
  pushl $0
80107570:	6a 00                	push   $0x0
  pushl $226
80107572:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107577:	e9 52 f0 ff ff       	jmp    801065ce <alltraps>

8010757c <vector227>:
.globl vector227
vector227:
  pushl $0
8010757c:	6a 00                	push   $0x0
  pushl $227
8010757e:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107583:	e9 46 f0 ff ff       	jmp    801065ce <alltraps>

80107588 <vector228>:
.globl vector228
vector228:
  pushl $0
80107588:	6a 00                	push   $0x0
  pushl $228
8010758a:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010758f:	e9 3a f0 ff ff       	jmp    801065ce <alltraps>

80107594 <vector229>:
.globl vector229
vector229:
  pushl $0
80107594:	6a 00                	push   $0x0
  pushl $229
80107596:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010759b:	e9 2e f0 ff ff       	jmp    801065ce <alltraps>

801075a0 <vector230>:
.globl vector230
vector230:
  pushl $0
801075a0:	6a 00                	push   $0x0
  pushl $230
801075a2:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801075a7:	e9 22 f0 ff ff       	jmp    801065ce <alltraps>

801075ac <vector231>:
.globl vector231
vector231:
  pushl $0
801075ac:	6a 00                	push   $0x0
  pushl $231
801075ae:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801075b3:	e9 16 f0 ff ff       	jmp    801065ce <alltraps>

801075b8 <vector232>:
.globl vector232
vector232:
  pushl $0
801075b8:	6a 00                	push   $0x0
  pushl $232
801075ba:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801075bf:	e9 0a f0 ff ff       	jmp    801065ce <alltraps>

801075c4 <vector233>:
.globl vector233
vector233:
  pushl $0
801075c4:	6a 00                	push   $0x0
  pushl $233
801075c6:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801075cb:	e9 fe ef ff ff       	jmp    801065ce <alltraps>

801075d0 <vector234>:
.globl vector234
vector234:
  pushl $0
801075d0:	6a 00                	push   $0x0
  pushl $234
801075d2:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801075d7:	e9 f2 ef ff ff       	jmp    801065ce <alltraps>

801075dc <vector235>:
.globl vector235
vector235:
  pushl $0
801075dc:	6a 00                	push   $0x0
  pushl $235
801075de:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801075e3:	e9 e6 ef ff ff       	jmp    801065ce <alltraps>

801075e8 <vector236>:
.globl vector236
vector236:
  pushl $0
801075e8:	6a 00                	push   $0x0
  pushl $236
801075ea:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801075ef:	e9 da ef ff ff       	jmp    801065ce <alltraps>

801075f4 <vector237>:
.globl vector237
vector237:
  pushl $0
801075f4:	6a 00                	push   $0x0
  pushl $237
801075f6:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801075fb:	e9 ce ef ff ff       	jmp    801065ce <alltraps>

80107600 <vector238>:
.globl vector238
vector238:
  pushl $0
80107600:	6a 00                	push   $0x0
  pushl $238
80107602:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107607:	e9 c2 ef ff ff       	jmp    801065ce <alltraps>

8010760c <vector239>:
.globl vector239
vector239:
  pushl $0
8010760c:	6a 00                	push   $0x0
  pushl $239
8010760e:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107613:	e9 b6 ef ff ff       	jmp    801065ce <alltraps>

80107618 <vector240>:
.globl vector240
vector240:
  pushl $0
80107618:	6a 00                	push   $0x0
  pushl $240
8010761a:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010761f:	e9 aa ef ff ff       	jmp    801065ce <alltraps>

80107624 <vector241>:
.globl vector241
vector241:
  pushl $0
80107624:	6a 00                	push   $0x0
  pushl $241
80107626:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010762b:	e9 9e ef ff ff       	jmp    801065ce <alltraps>

80107630 <vector242>:
.globl vector242
vector242:
  pushl $0
80107630:	6a 00                	push   $0x0
  pushl $242
80107632:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107637:	e9 92 ef ff ff       	jmp    801065ce <alltraps>

8010763c <vector243>:
.globl vector243
vector243:
  pushl $0
8010763c:	6a 00                	push   $0x0
  pushl $243
8010763e:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107643:	e9 86 ef ff ff       	jmp    801065ce <alltraps>

80107648 <vector244>:
.globl vector244
vector244:
  pushl $0
80107648:	6a 00                	push   $0x0
  pushl $244
8010764a:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010764f:	e9 7a ef ff ff       	jmp    801065ce <alltraps>

80107654 <vector245>:
.globl vector245
vector245:
  pushl $0
80107654:	6a 00                	push   $0x0
  pushl $245
80107656:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010765b:	e9 6e ef ff ff       	jmp    801065ce <alltraps>

80107660 <vector246>:
.globl vector246
vector246:
  pushl $0
80107660:	6a 00                	push   $0x0
  pushl $246
80107662:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107667:	e9 62 ef ff ff       	jmp    801065ce <alltraps>

8010766c <vector247>:
.globl vector247
vector247:
  pushl $0
8010766c:	6a 00                	push   $0x0
  pushl $247
8010766e:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107673:	e9 56 ef ff ff       	jmp    801065ce <alltraps>

80107678 <vector248>:
.globl vector248
vector248:
  pushl $0
80107678:	6a 00                	push   $0x0
  pushl $248
8010767a:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010767f:	e9 4a ef ff ff       	jmp    801065ce <alltraps>

80107684 <vector249>:
.globl vector249
vector249:
  pushl $0
80107684:	6a 00                	push   $0x0
  pushl $249
80107686:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010768b:	e9 3e ef ff ff       	jmp    801065ce <alltraps>

80107690 <vector250>:
.globl vector250
vector250:
  pushl $0
80107690:	6a 00                	push   $0x0
  pushl $250
80107692:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107697:	e9 32 ef ff ff       	jmp    801065ce <alltraps>

8010769c <vector251>:
.globl vector251
vector251:
  pushl $0
8010769c:	6a 00                	push   $0x0
  pushl $251
8010769e:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801076a3:	e9 26 ef ff ff       	jmp    801065ce <alltraps>

801076a8 <vector252>:
.globl vector252
vector252:
  pushl $0
801076a8:	6a 00                	push   $0x0
  pushl $252
801076aa:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801076af:	e9 1a ef ff ff       	jmp    801065ce <alltraps>

801076b4 <vector253>:
.globl vector253
vector253:
  pushl $0
801076b4:	6a 00                	push   $0x0
  pushl $253
801076b6:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801076bb:	e9 0e ef ff ff       	jmp    801065ce <alltraps>

801076c0 <vector254>:
.globl vector254
vector254:
  pushl $0
801076c0:	6a 00                	push   $0x0
  pushl $254
801076c2:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801076c7:	e9 02 ef ff ff       	jmp    801065ce <alltraps>

801076cc <vector255>:
.globl vector255
vector255:
  pushl $0
801076cc:	6a 00                	push   $0x0
  pushl $255
801076ce:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801076d3:	e9 f6 ee ff ff       	jmp    801065ce <alltraps>

801076d8 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
801076d8:	55                   	push   %ebp
801076d9:	89 e5                	mov    %esp,%ebp
801076db:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801076de:	8b 45 0c             	mov    0xc(%ebp),%eax
801076e1:	83 e8 01             	sub    $0x1,%eax
801076e4:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801076e8:	8b 45 08             	mov    0x8(%ebp),%eax
801076eb:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801076ef:	8b 45 08             	mov    0x8(%ebp),%eax
801076f2:	c1 e8 10             	shr    $0x10,%eax
801076f5:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801076f9:	8d 45 fa             	lea    -0x6(%ebp),%eax
801076fc:	0f 01 10             	lgdtl  (%eax)
}
801076ff:	90                   	nop
80107700:	c9                   	leave  
80107701:	c3                   	ret    

80107702 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107702:	55                   	push   %ebp
80107703:	89 e5                	mov    %esp,%ebp
80107705:	83 ec 04             	sub    $0x4,%esp
80107708:	8b 45 08             	mov    0x8(%ebp),%eax
8010770b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
8010770f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107713:	0f 00 d8             	ltr    %ax
}
80107716:	90                   	nop
80107717:	c9                   	leave  
80107718:	c3                   	ret    

80107719 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107719:	55                   	push   %ebp
8010771a:	89 e5                	mov    %esp,%ebp
8010771c:	83 ec 04             	sub    $0x4,%esp
8010771f:	8b 45 08             	mov    0x8(%ebp),%eax
80107722:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107726:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010772a:	8e e8                	mov    %eax,%gs
}
8010772c:	90                   	nop
8010772d:	c9                   	leave  
8010772e:	c3                   	ret    

8010772f <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
8010772f:	55                   	push   %ebp
80107730:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107732:	8b 45 08             	mov    0x8(%ebp),%eax
80107735:	0f 22 d8             	mov    %eax,%cr3
}
80107738:	90                   	nop
80107739:	5d                   	pop    %ebp
8010773a:	c3                   	ret    

8010773b <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
8010773b:	55                   	push   %ebp
8010773c:	89 e5                	mov    %esp,%ebp
8010773e:	8b 45 08             	mov    0x8(%ebp),%eax
80107741:	05 00 00 00 80       	add    $0x80000000,%eax
80107746:	5d                   	pop    %ebp
80107747:	c3                   	ret    

80107748 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107748:	55                   	push   %ebp
80107749:	89 e5                	mov    %esp,%ebp
8010774b:	8b 45 08             	mov    0x8(%ebp),%eax
8010774e:	05 00 00 00 80       	add    $0x80000000,%eax
80107753:	5d                   	pop    %ebp
80107754:	c3                   	ret    

80107755 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107755:	55                   	push   %ebp
80107756:	89 e5                	mov    %esp,%ebp
80107758:	53                   	push   %ebx
80107759:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
8010775c:	e8 2d b8 ff ff       	call   80102f8e <cpunum>
80107761:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107767:	05 60 23 11 80       	add    $0x80112360,%eax
8010776c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010776f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107772:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107778:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010777b:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107781:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107784:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107788:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010778b:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010778f:	83 e2 f0             	and    $0xfffffff0,%edx
80107792:	83 ca 0a             	or     $0xa,%edx
80107795:	88 50 7d             	mov    %dl,0x7d(%eax)
80107798:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010779b:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010779f:	83 ca 10             	or     $0x10,%edx
801077a2:	88 50 7d             	mov    %dl,0x7d(%eax)
801077a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077a8:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801077ac:	83 e2 9f             	and    $0xffffff9f,%edx
801077af:	88 50 7d             	mov    %dl,0x7d(%eax)
801077b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077b5:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801077b9:	83 ca 80             	or     $0xffffff80,%edx
801077bc:	88 50 7d             	mov    %dl,0x7d(%eax)
801077bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077c2:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801077c6:	83 ca 0f             	or     $0xf,%edx
801077c9:	88 50 7e             	mov    %dl,0x7e(%eax)
801077cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077cf:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801077d3:	83 e2 ef             	and    $0xffffffef,%edx
801077d6:	88 50 7e             	mov    %dl,0x7e(%eax)
801077d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077dc:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801077e0:	83 e2 df             	and    $0xffffffdf,%edx
801077e3:	88 50 7e             	mov    %dl,0x7e(%eax)
801077e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077e9:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801077ed:	83 ca 40             	or     $0x40,%edx
801077f0:	88 50 7e             	mov    %dl,0x7e(%eax)
801077f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077f6:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801077fa:	83 ca 80             	or     $0xffffff80,%edx
801077fd:	88 50 7e             	mov    %dl,0x7e(%eax)
80107800:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107803:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107807:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010780a:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107811:	ff ff 
80107813:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107816:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010781d:	00 00 
8010781f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107822:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107829:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010782c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107833:	83 e2 f0             	and    $0xfffffff0,%edx
80107836:	83 ca 02             	or     $0x2,%edx
80107839:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010783f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107842:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107849:	83 ca 10             	or     $0x10,%edx
8010784c:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107852:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107855:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010785c:	83 e2 9f             	and    $0xffffff9f,%edx
8010785f:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107865:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107868:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010786f:	83 ca 80             	or     $0xffffff80,%edx
80107872:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107878:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010787b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107882:	83 ca 0f             	or     $0xf,%edx
80107885:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010788b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010788e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107895:	83 e2 ef             	and    $0xffffffef,%edx
80107898:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010789e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078a1:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801078a8:	83 e2 df             	and    $0xffffffdf,%edx
801078ab:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801078b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078b4:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801078bb:	83 ca 40             	or     $0x40,%edx
801078be:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801078c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078c7:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801078ce:	83 ca 80             	or     $0xffffff80,%edx
801078d1:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801078d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078da:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801078e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078e4:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801078eb:	ff ff 
801078ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f0:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801078f7:	00 00 
801078f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078fc:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107903:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107906:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010790d:	83 e2 f0             	and    $0xfffffff0,%edx
80107910:	83 ca 0a             	or     $0xa,%edx
80107913:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107919:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010791c:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107923:	83 ca 10             	or     $0x10,%edx
80107926:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010792c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010792f:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107936:	83 ca 60             	or     $0x60,%edx
80107939:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010793f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107942:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107949:	83 ca 80             	or     $0xffffff80,%edx
8010794c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107952:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107955:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010795c:	83 ca 0f             	or     $0xf,%edx
8010795f:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107965:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107968:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010796f:	83 e2 ef             	and    $0xffffffef,%edx
80107972:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107978:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010797b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107982:	83 e2 df             	and    $0xffffffdf,%edx
80107985:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010798b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010798e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107995:	83 ca 40             	or     $0x40,%edx
80107998:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010799e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079a1:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801079a8:	83 ca 80             	or     $0xffffff80,%edx
801079ab:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801079b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079b4:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801079bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079be:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801079c5:	ff ff 
801079c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079ca:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801079d1:	00 00 
801079d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079d6:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801079dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079e0:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801079e7:	83 e2 f0             	and    $0xfffffff0,%edx
801079ea:	83 ca 02             	or     $0x2,%edx
801079ed:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801079f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079f6:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801079fd:	83 ca 10             	or     $0x10,%edx
80107a00:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a09:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107a10:	83 ca 60             	or     $0x60,%edx
80107a13:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a1c:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107a23:	83 ca 80             	or     $0xffffff80,%edx
80107a26:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a2f:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107a36:	83 ca 0f             	or     $0xf,%edx
80107a39:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a42:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107a49:	83 e2 ef             	and    $0xffffffef,%edx
80107a4c:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a55:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107a5c:	83 e2 df             	and    $0xffffffdf,%edx
80107a5f:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a68:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107a6f:	83 ca 40             	or     $0x40,%edx
80107a72:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a7b:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107a82:	83 ca 80             	or     $0xffffff80,%edx
80107a85:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a8e:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a98:	05 b4 00 00 00       	add    $0xb4,%eax
80107a9d:	89 c3                	mov    %eax,%ebx
80107a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa2:	05 b4 00 00 00       	add    $0xb4,%eax
80107aa7:	c1 e8 10             	shr    $0x10,%eax
80107aaa:	89 c2                	mov    %eax,%edx
80107aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aaf:	05 b4 00 00 00       	add    $0xb4,%eax
80107ab4:	c1 e8 18             	shr    $0x18,%eax
80107ab7:	89 c1                	mov    %eax,%ecx
80107ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107abc:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107ac3:	00 00 
80107ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ac8:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ad2:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80107ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107adb:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107ae2:	83 e2 f0             	and    $0xfffffff0,%edx
80107ae5:	83 ca 02             	or     $0x2,%edx
80107ae8:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af1:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107af8:	83 ca 10             	or     $0x10,%edx
80107afb:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b04:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107b0b:	83 e2 9f             	and    $0xffffff9f,%edx
80107b0e:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b17:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107b1e:	83 ca 80             	or     $0xffffff80,%edx
80107b21:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b2a:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107b31:	83 e2 f0             	and    $0xfffffff0,%edx
80107b34:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b3d:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107b44:	83 e2 ef             	and    $0xffffffef,%edx
80107b47:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b50:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107b57:	83 e2 df             	and    $0xffffffdf,%edx
80107b5a:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b63:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107b6a:	83 ca 40             	or     $0x40,%edx
80107b6d:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b76:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107b7d:	83 ca 80             	or     $0xffffff80,%edx
80107b80:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b89:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b92:	83 c0 70             	add    $0x70,%eax
80107b95:	83 ec 08             	sub    $0x8,%esp
80107b98:	6a 38                	push   $0x38
80107b9a:	50                   	push   %eax
80107b9b:	e8 38 fb ff ff       	call   801076d8 <lgdt>
80107ba0:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80107ba3:	83 ec 0c             	sub    $0xc,%esp
80107ba6:	6a 18                	push   $0x18
80107ba8:	e8 6c fb ff ff       	call   80107719 <loadgs>
80107bad:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80107bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bb3:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107bb9:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107bc0:	00 00 00 00 
}
80107bc4:	90                   	nop
80107bc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107bc8:	c9                   	leave  
80107bc9:	c3                   	ret    

80107bca <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107bca:	55                   	push   %ebp
80107bcb:	89 e5                	mov    %esp,%ebp
80107bcd:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bd3:	c1 e8 16             	shr    $0x16,%eax
80107bd6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107bdd:	8b 45 08             	mov    0x8(%ebp),%eax
80107be0:	01 d0                	add    %edx,%eax
80107be2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107be8:	8b 00                	mov    (%eax),%eax
80107bea:	83 e0 01             	and    $0x1,%eax
80107bed:	85 c0                	test   %eax,%eax
80107bef:	74 18                	je     80107c09 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107bf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107bf4:	8b 00                	mov    (%eax),%eax
80107bf6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107bfb:	50                   	push   %eax
80107bfc:	e8 47 fb ff ff       	call   80107748 <p2v>
80107c01:	83 c4 04             	add    $0x4,%esp
80107c04:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c07:	eb 48                	jmp    80107c51 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107c09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107c0d:	74 0e                	je     80107c1d <walkpgdir+0x53>
80107c0f:	e8 14 b0 ff ff       	call   80102c28 <kalloc>
80107c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107c1b:	75 07                	jne    80107c24 <walkpgdir+0x5a>
      return 0;
80107c1d:	b8 00 00 00 00       	mov    $0x0,%eax
80107c22:	eb 44                	jmp    80107c68 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107c24:	83 ec 04             	sub    $0x4,%esp
80107c27:	68 00 10 00 00       	push   $0x1000
80107c2c:	6a 00                	push   $0x0
80107c2e:	ff 75 f4             	pushl  -0xc(%ebp)
80107c31:	e8 c3 d5 ff ff       	call   801051f9 <memset>
80107c36:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107c39:	83 ec 0c             	sub    $0xc,%esp
80107c3c:	ff 75 f4             	pushl  -0xc(%ebp)
80107c3f:	e8 f7 fa ff ff       	call   8010773b <v2p>
80107c44:	83 c4 10             	add    $0x10,%esp
80107c47:	83 c8 07             	or     $0x7,%eax
80107c4a:	89 c2                	mov    %eax,%edx
80107c4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c4f:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107c51:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c54:	c1 e8 0c             	shr    $0xc,%eax
80107c57:	25 ff 03 00 00       	and    $0x3ff,%eax
80107c5c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c66:	01 d0                	add    %edx,%eax
}
80107c68:	c9                   	leave  
80107c69:	c3                   	ret    

80107c6a <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107c6a:	55                   	push   %ebp
80107c6b:	89 e5                	mov    %esp,%ebp
80107c6d:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80107c70:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c73:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107c7b:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c7e:	8b 45 10             	mov    0x10(%ebp),%eax
80107c81:	01 d0                	add    %edx,%eax
80107c83:	83 e8 01             	sub    $0x1,%eax
80107c86:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107c8e:	83 ec 04             	sub    $0x4,%esp
80107c91:	6a 01                	push   $0x1
80107c93:	ff 75 f4             	pushl  -0xc(%ebp)
80107c96:	ff 75 08             	pushl  0x8(%ebp)
80107c99:	e8 2c ff ff ff       	call   80107bca <walkpgdir>
80107c9e:	83 c4 10             	add    $0x10,%esp
80107ca1:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107ca4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107ca8:	75 07                	jne    80107cb1 <mappages+0x47>
      return -1;
80107caa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107caf:	eb 47                	jmp    80107cf8 <mappages+0x8e>
    if(*pte & PTE_P)
80107cb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107cb4:	8b 00                	mov    (%eax),%eax
80107cb6:	83 e0 01             	and    $0x1,%eax
80107cb9:	85 c0                	test   %eax,%eax
80107cbb:	74 0d                	je     80107cca <mappages+0x60>
      panic("remap");
80107cbd:	83 ec 0c             	sub    $0xc,%esp
80107cc0:	68 d0 8b 10 80       	push   $0x80108bd0
80107cc5:	e8 9c 88 ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
80107cca:	8b 45 18             	mov    0x18(%ebp),%eax
80107ccd:	0b 45 14             	or     0x14(%ebp),%eax
80107cd0:	83 c8 01             	or     $0x1,%eax
80107cd3:	89 c2                	mov    %eax,%edx
80107cd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107cd8:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cdd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107ce0:	74 10                	je     80107cf2 <mappages+0x88>
      break;
    a += PGSIZE;
80107ce2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107ce9:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107cf0:	eb 9c                	jmp    80107c8e <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80107cf2:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107cf3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107cf8:	c9                   	leave  
80107cf9:	c3                   	ret    

80107cfa <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107cfa:	55                   	push   %ebp
80107cfb:	89 e5                	mov    %esp,%ebp
80107cfd:	53                   	push   %ebx
80107cfe:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107d01:	e8 22 af ff ff       	call   80102c28 <kalloc>
80107d06:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107d09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107d0d:	75 0a                	jne    80107d19 <setupkvm+0x1f>
    return 0;
80107d0f:	b8 00 00 00 00       	mov    $0x0,%eax
80107d14:	e9 8e 00 00 00       	jmp    80107da7 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80107d19:	83 ec 04             	sub    $0x4,%esp
80107d1c:	68 00 10 00 00       	push   $0x1000
80107d21:	6a 00                	push   $0x0
80107d23:	ff 75 f0             	pushl  -0x10(%ebp)
80107d26:	e8 ce d4 ff ff       	call   801051f9 <memset>
80107d2b:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107d2e:	83 ec 0c             	sub    $0xc,%esp
80107d31:	68 00 00 00 0e       	push   $0xe000000
80107d36:	e8 0d fa ff ff       	call   80107748 <p2v>
80107d3b:	83 c4 10             	add    $0x10,%esp
80107d3e:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80107d43:	76 0d                	jbe    80107d52 <setupkvm+0x58>
    panic("PHYSTOP too high");
80107d45:	83 ec 0c             	sub    $0xc,%esp
80107d48:	68 d6 8b 10 80       	push   $0x80108bd6
80107d4d:	e8 14 88 ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107d52:	c7 45 f4 a0 b4 10 80 	movl   $0x8010b4a0,-0xc(%ebp)
80107d59:	eb 40                	jmp    80107d9b <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d5e:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80107d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d64:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d6a:	8b 58 08             	mov    0x8(%eax),%ebx
80107d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d70:	8b 40 04             	mov    0x4(%eax),%eax
80107d73:	29 c3                	sub    %eax,%ebx
80107d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d78:	8b 00                	mov    (%eax),%eax
80107d7a:	83 ec 0c             	sub    $0xc,%esp
80107d7d:	51                   	push   %ecx
80107d7e:	52                   	push   %edx
80107d7f:	53                   	push   %ebx
80107d80:	50                   	push   %eax
80107d81:	ff 75 f0             	pushl  -0x10(%ebp)
80107d84:	e8 e1 fe ff ff       	call   80107c6a <mappages>
80107d89:	83 c4 20             	add    $0x20,%esp
80107d8c:	85 c0                	test   %eax,%eax
80107d8e:	79 07                	jns    80107d97 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80107d90:	b8 00 00 00 00       	mov    $0x0,%eax
80107d95:	eb 10                	jmp    80107da7 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107d97:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107d9b:	81 7d f4 e0 b4 10 80 	cmpl   $0x8010b4e0,-0xc(%ebp)
80107da2:	72 b7                	jb     80107d5b <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80107da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107da7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107daa:	c9                   	leave  
80107dab:	c3                   	ret    

80107dac <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107dac:	55                   	push   %ebp
80107dad:	89 e5                	mov    %esp,%ebp
80107daf:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107db2:	e8 43 ff ff ff       	call   80107cfa <setupkvm>
80107db7:	a3 38 52 11 80       	mov    %eax,0x80115238
  switchkvm();
80107dbc:	e8 03 00 00 00       	call   80107dc4 <switchkvm>
}
80107dc1:	90                   	nop
80107dc2:	c9                   	leave  
80107dc3:	c3                   	ret    

80107dc4 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107dc4:	55                   	push   %ebp
80107dc5:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107dc7:	a1 38 52 11 80       	mov    0x80115238,%eax
80107dcc:	50                   	push   %eax
80107dcd:	e8 69 f9 ff ff       	call   8010773b <v2p>
80107dd2:	83 c4 04             	add    $0x4,%esp
80107dd5:	50                   	push   %eax
80107dd6:	e8 54 f9 ff ff       	call   8010772f <lcr3>
80107ddb:	83 c4 04             	add    $0x4,%esp
}
80107dde:	90                   	nop
80107ddf:	c9                   	leave  
80107de0:	c3                   	ret    

80107de1 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107de1:	55                   	push   %ebp
80107de2:	89 e5                	mov    %esp,%ebp
80107de4:	56                   	push   %esi
80107de5:	53                   	push   %ebx
  pushcli();
80107de6:	e8 08 d3 ff ff       	call   801050f3 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107deb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107df1:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107df8:	83 c2 08             	add    $0x8,%edx
80107dfb:	89 d6                	mov    %edx,%esi
80107dfd:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107e04:	83 c2 08             	add    $0x8,%edx
80107e07:	c1 ea 10             	shr    $0x10,%edx
80107e0a:	89 d3                	mov    %edx,%ebx
80107e0c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107e13:	83 c2 08             	add    $0x8,%edx
80107e16:	c1 ea 18             	shr    $0x18,%edx
80107e19:	89 d1                	mov    %edx,%ecx
80107e1b:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107e22:	67 00 
80107e24:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80107e2b:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80107e31:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107e38:	83 e2 f0             	and    $0xfffffff0,%edx
80107e3b:	83 ca 09             	or     $0x9,%edx
80107e3e:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107e44:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107e4b:	83 ca 10             	or     $0x10,%edx
80107e4e:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107e54:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107e5b:	83 e2 9f             	and    $0xffffff9f,%edx
80107e5e:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107e64:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107e6b:	83 ca 80             	or     $0xffffff80,%edx
80107e6e:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107e74:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107e7b:	83 e2 f0             	and    $0xfffffff0,%edx
80107e7e:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107e84:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107e8b:	83 e2 ef             	and    $0xffffffef,%edx
80107e8e:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107e94:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107e9b:	83 e2 df             	and    $0xffffffdf,%edx
80107e9e:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107ea4:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107eab:	83 ca 40             	or     $0x40,%edx
80107eae:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107eb4:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107ebb:	83 e2 7f             	and    $0x7f,%edx
80107ebe:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107ec4:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107eca:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107ed0:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107ed7:	83 e2 ef             	and    $0xffffffef,%edx
80107eda:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107ee0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107ee6:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107eec:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107ef2:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107ef9:	8b 52 0c             	mov    0xc(%edx),%edx
80107efc:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107f02:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107f05:	83 ec 0c             	sub    $0xc,%esp
80107f08:	6a 30                	push   $0x30
80107f0a:	e8 f3 f7 ff ff       	call   80107702 <ltr>
80107f0f:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80107f12:	8b 45 08             	mov    0x8(%ebp),%eax
80107f15:	8b 40 08             	mov    0x8(%eax),%eax
80107f18:	85 c0                	test   %eax,%eax
80107f1a:	75 0d                	jne    80107f29 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80107f1c:	83 ec 0c             	sub    $0xc,%esp
80107f1f:	68 e7 8b 10 80       	push   $0x80108be7
80107f24:	e8 3d 86 ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107f29:	8b 45 08             	mov    0x8(%ebp),%eax
80107f2c:	8b 40 08             	mov    0x8(%eax),%eax
80107f2f:	83 ec 0c             	sub    $0xc,%esp
80107f32:	50                   	push   %eax
80107f33:	e8 03 f8 ff ff       	call   8010773b <v2p>
80107f38:	83 c4 10             	add    $0x10,%esp
80107f3b:	83 ec 0c             	sub    $0xc,%esp
80107f3e:	50                   	push   %eax
80107f3f:	e8 eb f7 ff ff       	call   8010772f <lcr3>
80107f44:	83 c4 10             	add    $0x10,%esp
  popcli();
80107f47:	e8 ec d1 ff ff       	call   80105138 <popcli>
}
80107f4c:	90                   	nop
80107f4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107f50:	5b                   	pop    %ebx
80107f51:	5e                   	pop    %esi
80107f52:	5d                   	pop    %ebp
80107f53:	c3                   	ret    

80107f54 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107f54:	55                   	push   %ebp
80107f55:	89 e5                	mov    %esp,%ebp
80107f57:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107f5a:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107f61:	76 0d                	jbe    80107f70 <inituvm+0x1c>
    panic("inituvm: more than a page");
80107f63:	83 ec 0c             	sub    $0xc,%esp
80107f66:	68 fb 8b 10 80       	push   $0x80108bfb
80107f6b:	e8 f6 85 ff ff       	call   80100566 <panic>
  mem = kalloc();
80107f70:	e8 b3 ac ff ff       	call   80102c28 <kalloc>
80107f75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107f78:	83 ec 04             	sub    $0x4,%esp
80107f7b:	68 00 10 00 00       	push   $0x1000
80107f80:	6a 00                	push   $0x0
80107f82:	ff 75 f4             	pushl  -0xc(%ebp)
80107f85:	e8 6f d2 ff ff       	call   801051f9 <memset>
80107f8a:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107f8d:	83 ec 0c             	sub    $0xc,%esp
80107f90:	ff 75 f4             	pushl  -0xc(%ebp)
80107f93:	e8 a3 f7 ff ff       	call   8010773b <v2p>
80107f98:	83 c4 10             	add    $0x10,%esp
80107f9b:	83 ec 0c             	sub    $0xc,%esp
80107f9e:	6a 06                	push   $0x6
80107fa0:	50                   	push   %eax
80107fa1:	68 00 10 00 00       	push   $0x1000
80107fa6:	6a 00                	push   $0x0
80107fa8:	ff 75 08             	pushl  0x8(%ebp)
80107fab:	e8 ba fc ff ff       	call   80107c6a <mappages>
80107fb0:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80107fb3:	83 ec 04             	sub    $0x4,%esp
80107fb6:	ff 75 10             	pushl  0x10(%ebp)
80107fb9:	ff 75 0c             	pushl  0xc(%ebp)
80107fbc:	ff 75 f4             	pushl  -0xc(%ebp)
80107fbf:	e8 f4 d2 ff ff       	call   801052b8 <memmove>
80107fc4:	83 c4 10             	add    $0x10,%esp
}
80107fc7:	90                   	nop
80107fc8:	c9                   	leave  
80107fc9:	c3                   	ret    

80107fca <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107fca:	55                   	push   %ebp
80107fcb:	89 e5                	mov    %esp,%ebp
80107fcd:	53                   	push   %ebx
80107fce:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fd4:	25 ff 0f 00 00       	and    $0xfff,%eax
80107fd9:	85 c0                	test   %eax,%eax
80107fdb:	74 0d                	je     80107fea <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80107fdd:	83 ec 0c             	sub    $0xc,%esp
80107fe0:	68 18 8c 10 80       	push   $0x80108c18
80107fe5:	e8 7c 85 ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107fea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107ff1:	e9 95 00 00 00       	jmp    8010808b <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107ff6:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ffc:	01 d0                	add    %edx,%eax
80107ffe:	83 ec 04             	sub    $0x4,%esp
80108001:	6a 00                	push   $0x0
80108003:	50                   	push   %eax
80108004:	ff 75 08             	pushl  0x8(%ebp)
80108007:	e8 be fb ff ff       	call   80107bca <walkpgdir>
8010800c:	83 c4 10             	add    $0x10,%esp
8010800f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108012:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108016:	75 0d                	jne    80108025 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80108018:	83 ec 0c             	sub    $0xc,%esp
8010801b:	68 3b 8c 10 80       	push   $0x80108c3b
80108020:	e8 41 85 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80108025:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108028:	8b 00                	mov    (%eax),%eax
8010802a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010802f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108032:	8b 45 18             	mov    0x18(%ebp),%eax
80108035:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108038:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010803d:	77 0b                	ja     8010804a <loaduvm+0x80>
      n = sz - i;
8010803f:	8b 45 18             	mov    0x18(%ebp),%eax
80108042:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108045:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108048:	eb 07                	jmp    80108051 <loaduvm+0x87>
    else
      n = PGSIZE;
8010804a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108051:	8b 55 14             	mov    0x14(%ebp),%edx
80108054:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108057:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010805a:	83 ec 0c             	sub    $0xc,%esp
8010805d:	ff 75 e8             	pushl  -0x18(%ebp)
80108060:	e8 e3 f6 ff ff       	call   80107748 <p2v>
80108065:	83 c4 10             	add    $0x10,%esp
80108068:	ff 75 f0             	pushl  -0x10(%ebp)
8010806b:	53                   	push   %ebx
8010806c:	50                   	push   %eax
8010806d:	ff 75 10             	pushl  0x10(%ebp)
80108070:	e8 25 9e ff ff       	call   80101e9a <readi>
80108075:	83 c4 10             	add    $0x10,%esp
80108078:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010807b:	74 07                	je     80108084 <loaduvm+0xba>
      return -1;
8010807d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108082:	eb 18                	jmp    8010809c <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80108084:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010808b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010808e:	3b 45 18             	cmp    0x18(%ebp),%eax
80108091:	0f 82 5f ff ff ff    	jb     80107ff6 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80108097:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010809c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010809f:	c9                   	leave  
801080a0:	c3                   	ret    

801080a1 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801080a1:	55                   	push   %ebp
801080a2:	89 e5                	mov    %esp,%ebp
801080a4:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801080a7:	8b 45 10             	mov    0x10(%ebp),%eax
801080aa:	85 c0                	test   %eax,%eax
801080ac:	79 0a                	jns    801080b8 <allocuvm+0x17>
    return 0;
801080ae:	b8 00 00 00 00       	mov    $0x0,%eax
801080b3:	e9 b0 00 00 00       	jmp    80108168 <allocuvm+0xc7>
  if(newsz < oldsz)
801080b8:	8b 45 10             	mov    0x10(%ebp),%eax
801080bb:	3b 45 0c             	cmp    0xc(%ebp),%eax
801080be:	73 08                	jae    801080c8 <allocuvm+0x27>
    return oldsz;
801080c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801080c3:	e9 a0 00 00 00       	jmp    80108168 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
801080c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801080cb:	05 ff 0f 00 00       	add    $0xfff,%eax
801080d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
//  cprintf("allocuvm = old: %x  a: %x   new: %x\n",oldsz,a,newsz);
  for(; a < newsz; a += PGSIZE){
801080d8:	eb 7f                	jmp    80108159 <allocuvm+0xb8>
    mem = kalloc();
801080da:	e8 49 ab ff ff       	call   80102c28 <kalloc>
801080df:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801080e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801080e6:	75 2b                	jne    80108113 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
801080e8:	83 ec 0c             	sub    $0xc,%esp
801080eb:	68 59 8c 10 80       	push   $0x80108c59
801080f0:	e8 d1 82 ff ff       	call   801003c6 <cprintf>
801080f5:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
801080f8:	83 ec 04             	sub    $0x4,%esp
801080fb:	ff 75 0c             	pushl  0xc(%ebp)
801080fe:	ff 75 10             	pushl  0x10(%ebp)
80108101:	ff 75 08             	pushl  0x8(%ebp)
80108104:	e8 61 00 00 00       	call   8010816a <deallocuvm>
80108109:	83 c4 10             	add    $0x10,%esp
      return 0;
8010810c:	b8 00 00 00 00       	mov    $0x0,%eax
80108111:	eb 55                	jmp    80108168 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80108113:	83 ec 04             	sub    $0x4,%esp
80108116:	68 00 10 00 00       	push   $0x1000
8010811b:	6a 00                	push   $0x0
8010811d:	ff 75 f0             	pushl  -0x10(%ebp)
80108120:	e8 d4 d0 ff ff       	call   801051f9 <memset>
80108125:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108128:	83 ec 0c             	sub    $0xc,%esp
8010812b:	ff 75 f0             	pushl  -0x10(%ebp)
8010812e:	e8 08 f6 ff ff       	call   8010773b <v2p>
80108133:	83 c4 10             	add    $0x10,%esp
80108136:	89 c2                	mov    %eax,%edx
80108138:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010813b:	83 ec 0c             	sub    $0xc,%esp
8010813e:	6a 06                	push   $0x6
80108140:	52                   	push   %edx
80108141:	68 00 10 00 00       	push   $0x1000
80108146:	50                   	push   %eax
80108147:	ff 75 08             	pushl  0x8(%ebp)
8010814a:	e8 1b fb ff ff       	call   80107c6a <mappages>
8010814f:	83 c4 20             	add    $0x20,%esp
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
//  cprintf("allocuvm = old: %x  a: %x   new: %x\n",oldsz,a,newsz);
  for(; a < newsz; a += PGSIZE){
80108152:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010815c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010815f:	0f 82 75 ff ff ff    	jb     801080da <allocuvm+0x39>
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
//	cprintf("a: %x is allocated\n",a);
  }
  return newsz;
80108165:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108168:	c9                   	leave  
80108169:	c3                   	ret    

8010816a <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010816a:	55                   	push   %ebp
8010816b:	89 e5                	mov    %esp,%ebp
8010816d:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108170:	8b 45 10             	mov    0x10(%ebp),%eax
80108173:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108176:	72 08                	jb     80108180 <deallocuvm+0x16>
    return oldsz;
80108178:	8b 45 0c             	mov    0xc(%ebp),%eax
8010817b:	e9 a5 00 00 00       	jmp    80108225 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80108180:	8b 45 10             	mov    0x10(%ebp),%eax
80108183:	05 ff 0f 00 00       	add    $0xfff,%eax
80108188:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010818d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108190:	e9 81 00 00 00       	jmp    80108216 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108198:	83 ec 04             	sub    $0x4,%esp
8010819b:	6a 00                	push   $0x0
8010819d:	50                   	push   %eax
8010819e:	ff 75 08             	pushl  0x8(%ebp)
801081a1:	e8 24 fa ff ff       	call   80107bca <walkpgdir>
801081a6:	83 c4 10             	add    $0x10,%esp
801081a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801081ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801081b0:	75 09                	jne    801081bb <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
801081b2:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
801081b9:	eb 54                	jmp    8010820f <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
801081bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081be:	8b 00                	mov    (%eax),%eax
801081c0:	83 e0 01             	and    $0x1,%eax
801081c3:	85 c0                	test   %eax,%eax
801081c5:	74 48                	je     8010820f <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
801081c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081ca:	8b 00                	mov    (%eax),%eax
801081cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801081d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801081d8:	75 0d                	jne    801081e7 <deallocuvm+0x7d>
        panic("kfree");
801081da:	83 ec 0c             	sub    $0xc,%esp
801081dd:	68 71 8c 10 80       	push   $0x80108c71
801081e2:	e8 7f 83 ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
801081e7:	83 ec 0c             	sub    $0xc,%esp
801081ea:	ff 75 ec             	pushl  -0x14(%ebp)
801081ed:	e8 56 f5 ff ff       	call   80107748 <p2v>
801081f2:	83 c4 10             	add    $0x10,%esp
801081f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801081f8:	83 ec 0c             	sub    $0xc,%esp
801081fb:	ff 75 e8             	pushl  -0x18(%ebp)
801081fe:	e8 88 a9 ff ff       	call   80102b8b <kfree>
80108203:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108206:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010820f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108216:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108219:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010821c:	0f 82 73 ff ff ff    	jb     80108195 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108222:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108225:	c9                   	leave  
80108226:	c3                   	ret    

80108227 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108227:	55                   	push   %ebp
80108228:	89 e5                	mov    %esp,%ebp
8010822a:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
8010822d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108231:	75 0d                	jne    80108240 <freevm+0x19>
    panic("freevm: no pgdir");
80108233:	83 ec 0c             	sub    $0xc,%esp
80108236:	68 77 8c 10 80       	push   $0x80108c77
8010823b:	e8 26 83 ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108240:	83 ec 04             	sub    $0x4,%esp
80108243:	6a 00                	push   $0x0
80108245:	68 00 00 00 80       	push   $0x80000000
8010824a:	ff 75 08             	pushl  0x8(%ebp)
8010824d:	e8 18 ff ff ff       	call   8010816a <deallocuvm>
80108252:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108255:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010825c:	eb 4f                	jmp    801082ad <freevm+0x86>
    if(pgdir[i] & PTE_P){
8010825e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108261:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108268:	8b 45 08             	mov    0x8(%ebp),%eax
8010826b:	01 d0                	add    %edx,%eax
8010826d:	8b 00                	mov    (%eax),%eax
8010826f:	83 e0 01             	and    $0x1,%eax
80108272:	85 c0                	test   %eax,%eax
80108274:	74 33                	je     801082a9 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108276:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108279:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108280:	8b 45 08             	mov    0x8(%ebp),%eax
80108283:	01 d0                	add    %edx,%eax
80108285:	8b 00                	mov    (%eax),%eax
80108287:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010828c:	83 ec 0c             	sub    $0xc,%esp
8010828f:	50                   	push   %eax
80108290:	e8 b3 f4 ff ff       	call   80107748 <p2v>
80108295:	83 c4 10             	add    $0x10,%esp
80108298:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
8010829b:	83 ec 0c             	sub    $0xc,%esp
8010829e:	ff 75 f0             	pushl  -0x10(%ebp)
801082a1:	e8 e5 a8 ff ff       	call   80102b8b <kfree>
801082a6:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801082a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801082ad:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801082b4:	76 a8                	jbe    8010825e <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801082b6:	83 ec 0c             	sub    $0xc,%esp
801082b9:	ff 75 08             	pushl  0x8(%ebp)
801082bc:	e8 ca a8 ff ff       	call   80102b8b <kfree>
801082c1:	83 c4 10             	add    $0x10,%esp
}
801082c4:	90                   	nop
801082c5:	c9                   	leave  
801082c6:	c3                   	ret    

801082c7 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801082c7:	55                   	push   %ebp
801082c8:	89 e5                	mov    %esp,%ebp
801082ca:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801082cd:	83 ec 04             	sub    $0x4,%esp
801082d0:	6a 00                	push   $0x0
801082d2:	ff 75 0c             	pushl  0xc(%ebp)
801082d5:	ff 75 08             	pushl  0x8(%ebp)
801082d8:	e8 ed f8 ff ff       	call   80107bca <walkpgdir>
801082dd:	83 c4 10             	add    $0x10,%esp
801082e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801082e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801082e7:	75 0d                	jne    801082f6 <clearpteu+0x2f>
    panic("clearpteu");
801082e9:	83 ec 0c             	sub    $0xc,%esp
801082ec:	68 88 8c 10 80       	push   $0x80108c88
801082f1:	e8 70 82 ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
801082f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082f9:	8b 00                	mov    (%eax),%eax
801082fb:	83 e0 fb             	and    $0xfffffffb,%eax
801082fe:	89 c2                	mov    %eax,%edx
80108300:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108303:	89 10                	mov    %edx,(%eax)
}
80108305:	90                   	nop
80108306:	c9                   	leave  
80108307:	c3                   	ret    

80108308 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108308:	55                   	push   %ebp
80108309:	89 e5                	mov    %esp,%ebp
8010830b:	53                   	push   %ebx
8010830c:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010830f:	e8 e6 f9 ff ff       	call   80107cfa <setupkvm>
80108314:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108317:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010831b:	75 0a                	jne    80108327 <copyuvm+0x1f>
    return 0;
8010831d:	b8 00 00 00 00       	mov    $0x0,%eax
80108322:	e9 e6 01 00 00       	jmp    8010850d <copyuvm+0x205>
  for(i = 0; i < sz; i += PGSIZE){
80108327:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010832e:	e9 cc 00 00 00       	jmp    801083ff <copyuvm+0xf7>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108333:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108336:	83 ec 04             	sub    $0x4,%esp
80108339:	6a 00                	push   $0x0
8010833b:	50                   	push   %eax
8010833c:	ff 75 08             	pushl  0x8(%ebp)
8010833f:	e8 86 f8 ff ff       	call   80107bca <walkpgdir>
80108344:	83 c4 10             	add    $0x10,%esp
80108347:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010834a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010834e:	75 0d                	jne    8010835d <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80108350:	83 ec 0c             	sub    $0xc,%esp
80108353:	68 92 8c 10 80       	push   $0x80108c92
80108358:	e8 09 82 ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
8010835d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108360:	8b 00                	mov    (%eax),%eax
80108362:	83 e0 01             	and    $0x1,%eax
80108365:	85 c0                	test   %eax,%eax
80108367:	75 0d                	jne    80108376 <copyuvm+0x6e>
      panic("copyuvm: page not present");
80108369:	83 ec 0c             	sub    $0xc,%esp
8010836c:	68 ac 8c 10 80       	push   $0x80108cac
80108371:	e8 f0 81 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80108376:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108379:	8b 00                	mov    (%eax),%eax
8010837b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108380:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108383:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108386:	8b 00                	mov    (%eax),%eax
80108388:	25 ff 0f 00 00       	and    $0xfff,%eax
8010838d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108390:	e8 93 a8 ff ff       	call   80102c28 <kalloc>
80108395:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108398:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010839c:	0f 84 4e 01 00 00    	je     801084f0 <copyuvm+0x1e8>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
801083a2:	83 ec 0c             	sub    $0xc,%esp
801083a5:	ff 75 e8             	pushl  -0x18(%ebp)
801083a8:	e8 9b f3 ff ff       	call   80107748 <p2v>
801083ad:	83 c4 10             	add    $0x10,%esp
801083b0:	83 ec 04             	sub    $0x4,%esp
801083b3:	68 00 10 00 00       	push   $0x1000
801083b8:	50                   	push   %eax
801083b9:	ff 75 e0             	pushl  -0x20(%ebp)
801083bc:	e8 f7 ce ff ff       	call   801052b8 <memmove>
801083c1:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
801083c4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801083c7:	83 ec 0c             	sub    $0xc,%esp
801083ca:	ff 75 e0             	pushl  -0x20(%ebp)
801083cd:	e8 69 f3 ff ff       	call   8010773b <v2p>
801083d2:	83 c4 10             	add    $0x10,%esp
801083d5:	89 c2                	mov    %eax,%edx
801083d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083da:	83 ec 0c             	sub    $0xc,%esp
801083dd:	53                   	push   %ebx
801083de:	52                   	push   %edx
801083df:	68 00 10 00 00       	push   $0x1000
801083e4:	50                   	push   %eax
801083e5:	ff 75 f0             	pushl  -0x10(%ebp)
801083e8:	e8 7d f8 ff ff       	call   80107c6a <mappages>
801083ed:	83 c4 20             	add    $0x20,%esp
801083f0:	85 c0                	test   %eax,%eax
801083f2:	0f 88 fb 00 00 00    	js     801084f3 <copyuvm+0x1eb>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801083f8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801083ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108402:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108405:	0f 82 28 ff ff ff    	jb     80108333 <copyuvm+0x2b>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  //cprintf("<<%x>>\n",proc->sb);
  for(i =proc->sb; i < KERNBASE; i += PGSIZE){
8010840b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108411:	8b 40 04             	mov    0x4(%eax),%eax
80108414:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108417:	e9 c4 00 00 00       	jmp    801084e0 <copyuvm+0x1d8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010841c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010841f:	83 ec 04             	sub    $0x4,%esp
80108422:	6a 00                	push   $0x0
80108424:	50                   	push   %eax
80108425:	ff 75 08             	pushl  0x8(%ebp)
80108428:	e8 9d f7 ff ff       	call   80107bca <walkpgdir>
8010842d:	83 c4 10             	add    $0x10,%esp
80108430:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108433:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108437:	75 0d                	jne    80108446 <copyuvm+0x13e>
      panic("copyuvm: pte should exist");
80108439:	83 ec 0c             	sub    $0xc,%esp
8010843c:	68 92 8c 10 80       	push   $0x80108c92
80108441:	e8 20 81 ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80108446:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108449:	8b 00                	mov    (%eax),%eax
8010844b:	83 e0 01             	and    $0x1,%eax
8010844e:	85 c0                	test   %eax,%eax
80108450:	75 0d                	jne    8010845f <copyuvm+0x157>
      panic("copyuvm: page not present");
80108452:	83 ec 0c             	sub    $0xc,%esp
80108455:	68 ac 8c 10 80       	push   $0x80108cac
8010845a:	e8 07 81 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
8010845f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108462:	8b 00                	mov    (%eax),%eax
80108464:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108469:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
8010846c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010846f:	8b 00                	mov    (%eax),%eax
80108471:	25 ff 0f 00 00       	and    $0xfff,%eax
80108476:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108479:	e8 aa a7 ff ff       	call   80102c28 <kalloc>
8010847e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108481:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108485:	74 6f                	je     801084f6 <copyuvm+0x1ee>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108487:	83 ec 0c             	sub    $0xc,%esp
8010848a:	ff 75 e8             	pushl  -0x18(%ebp)
8010848d:	e8 b6 f2 ff ff       	call   80107748 <p2v>
80108492:	83 c4 10             	add    $0x10,%esp
80108495:	83 ec 04             	sub    $0x4,%esp
80108498:	68 00 10 00 00       	push   $0x1000
8010849d:	50                   	push   %eax
8010849e:	ff 75 e0             	pushl  -0x20(%ebp)
801084a1:	e8 12 ce ff ff       	call   801052b8 <memmove>
801084a6:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
801084a9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801084ac:	83 ec 0c             	sub    $0xc,%esp
801084af:	ff 75 e0             	pushl  -0x20(%ebp)
801084b2:	e8 84 f2 ff ff       	call   8010773b <v2p>
801084b7:	83 c4 10             	add    $0x10,%esp
801084ba:	89 c2                	mov    %eax,%edx
801084bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084bf:	83 ec 0c             	sub    $0xc,%esp
801084c2:	53                   	push   %ebx
801084c3:	52                   	push   %edx
801084c4:	68 00 10 00 00       	push   $0x1000
801084c9:	50                   	push   %eax
801084ca:	ff 75 f0             	pushl  -0x10(%ebp)
801084cd:	e8 98 f7 ff ff       	call   80107c6a <mappages>
801084d2:	83 c4 20             	add    $0x20,%esp
801084d5:	85 c0                	test   %eax,%eax
801084d7:	78 20                	js     801084f9 <copyuvm+0x1f1>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  //cprintf("<<%x>>\n",proc->sb);
  for(i =proc->sb; i < KERNBASE; i += PGSIZE){
801084d9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801084e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084e3:	85 c0                	test   %eax,%eax
801084e5:	0f 89 31 ff ff ff    	jns    8010841c <copyuvm+0x114>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
801084eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084ee:	eb 1d                	jmp    8010850d <copyuvm+0x205>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
801084f0:	90                   	nop
801084f1:	eb 07                	jmp    801084fa <copyuvm+0x1f2>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
801084f3:	90                   	nop
801084f4:	eb 04                	jmp    801084fa <copyuvm+0x1f2>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
801084f6:	90                   	nop
801084f7:	eb 01                	jmp    801084fa <copyuvm+0x1f2>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
801084f9:	90                   	nop
  }
  return d;

bad:
  freevm(d);
801084fa:	83 ec 0c             	sub    $0xc,%esp
801084fd:	ff 75 f0             	pushl  -0x10(%ebp)
80108500:	e8 22 fd ff ff       	call   80108227 <freevm>
80108505:	83 c4 10             	add    $0x10,%esp
  return 0;
80108508:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010850d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108510:	c9                   	leave  
80108511:	c3                   	ret    

80108512 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108512:	55                   	push   %ebp
80108513:	89 e5                	mov    %esp,%ebp
80108515:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108518:	83 ec 04             	sub    $0x4,%esp
8010851b:	6a 00                	push   $0x0
8010851d:	ff 75 0c             	pushl  0xc(%ebp)
80108520:	ff 75 08             	pushl  0x8(%ebp)
80108523:	e8 a2 f6 ff ff       	call   80107bca <walkpgdir>
80108528:	83 c4 10             	add    $0x10,%esp
8010852b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
8010852e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108531:	8b 00                	mov    (%eax),%eax
80108533:	83 e0 01             	and    $0x1,%eax
80108536:	85 c0                	test   %eax,%eax
80108538:	75 07                	jne    80108541 <uva2ka+0x2f>
    return 0;
8010853a:	b8 00 00 00 00       	mov    $0x0,%eax
8010853f:	eb 29                	jmp    8010856a <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108541:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108544:	8b 00                	mov    (%eax),%eax
80108546:	83 e0 04             	and    $0x4,%eax
80108549:	85 c0                	test   %eax,%eax
8010854b:	75 07                	jne    80108554 <uva2ka+0x42>
    return 0;
8010854d:	b8 00 00 00 00       	mov    $0x0,%eax
80108552:	eb 16                	jmp    8010856a <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80108554:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108557:	8b 00                	mov    (%eax),%eax
80108559:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010855e:	83 ec 0c             	sub    $0xc,%esp
80108561:	50                   	push   %eax
80108562:	e8 e1 f1 ff ff       	call   80107748 <p2v>
80108567:	83 c4 10             	add    $0x10,%esp
}
8010856a:	c9                   	leave  
8010856b:	c3                   	ret    

8010856c <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
8010856c:	55                   	push   %ebp
8010856d:	89 e5                	mov    %esp,%ebp
8010856f:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108572:	8b 45 10             	mov    0x10(%ebp),%eax
80108575:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108578:	eb 7f                	jmp    801085f9 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
8010857a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010857d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108582:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108585:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108588:	83 ec 08             	sub    $0x8,%esp
8010858b:	50                   	push   %eax
8010858c:	ff 75 08             	pushl  0x8(%ebp)
8010858f:	e8 7e ff ff ff       	call   80108512 <uva2ka>
80108594:	83 c4 10             	add    $0x10,%esp
80108597:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
8010859a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010859e:	75 07                	jne    801085a7 <copyout+0x3b>
      return -1;
801085a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801085a5:	eb 61                	jmp    80108608 <copyout+0x9c>
    n = PGSIZE - (va - va0);
801085a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801085aa:	2b 45 0c             	sub    0xc(%ebp),%eax
801085ad:	05 00 10 00 00       	add    $0x1000,%eax
801085b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801085b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801085b8:	3b 45 14             	cmp    0x14(%ebp),%eax
801085bb:	76 06                	jbe    801085c3 <copyout+0x57>
      n = len;
801085bd:	8b 45 14             	mov    0x14(%ebp),%eax
801085c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801085c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801085c6:	2b 45 ec             	sub    -0x14(%ebp),%eax
801085c9:	89 c2                	mov    %eax,%edx
801085cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801085ce:	01 d0                	add    %edx,%eax
801085d0:	83 ec 04             	sub    $0x4,%esp
801085d3:	ff 75 f0             	pushl  -0x10(%ebp)
801085d6:	ff 75 f4             	pushl  -0xc(%ebp)
801085d9:	50                   	push   %eax
801085da:	e8 d9 cc ff ff       	call   801052b8 <memmove>
801085df:	83 c4 10             	add    $0x10,%esp
    len -= n;
801085e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801085e5:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801085e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801085eb:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
801085ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
801085f1:	05 00 10 00 00       	add    $0x1000,%eax
801085f6:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801085f9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801085fd:	0f 85 77 ff ff ff    	jne    8010857a <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108603:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108608:	c9                   	leave  
80108609:	c3                   	ret    
