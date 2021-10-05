Reverse Engineering

# Solution

Find edge case of program

netcat and check out program
```bash
nc mercury.picoctf.net 10337
```

We are greeted with a program that requires us to buy the flag. But we do not have enough coins.

```bash
Welcome to the market!
=====================
You have 40 coins
   Item         Price   Count
(0) Quiet Quiches       10      12
(1) Average Apple       15      8
(2) Fruitful Flag       100     1
(3) Sell an Item
(4) Exit
```

Check if we can sell items.

```bash
Choose an option: 
3
Your inventory
(0) Quiet Quiches       10      0
(1) Average Apple       15      0
(2) Fruitful Flag       100     0
What do you want to sell? 
2
How many?
-2147483647
```

Looks like the program doesn't check for negative numbers. By overflowing the integer, we keep our coins positive and even have enough coins (surplus) to buy the flag.

```
You have 140 coins
   Item         Price   Count
(0) Quiet Quiches       10      12
(1) Average Apple       15      8
(2) Fruitful Flag       100     1
(3) Sell an Item
(4) Exit
Choose an option: 
2
How many do you want to buy?
1
Flag is:  [112 105 99 111 67 84 70 123 98 52 100 95 98 114 111 103 114 97 109 109 101 114 95 51 100 97 51 52 97 56 102 125]
```

The flag is just a list of integers. Let's change it to ascii.

```python
flag = [112,105,99,111,67,84,70,123,98,52,100,95,98,114,111,103,114,97,109,109,101,114,95,51,100,97,51,52,97,56,102,125]

print(''.join([chr(f) for f in flag]))
```

Flag is ```bash
picoCTF{b4d_brogrammer_3da34a8f}
```


