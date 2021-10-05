# -*- coding: utf-8 -*-

flag = "灩捯䍔䙻ㄶ形楴獟楮獴㌴摟潦弸彤㔲挶戹㍽"

# val = ''.join([chr((ord(flag[i]) << 8) + ord(flag[i + 1])) for i in range(0, len(flag), 2)])

val = ""
for byte in flag:
   first = ord(byte) >> 8
   second = ord(byte) & 255
   val += chr(first) + chr(second)

#flag = 'picoCTF{'

#val = ''.join([chr((ord(flag[i]) << 8) + ord(flag[i + 1])) for i in range(0, len(flag), 2)])

print(val)
