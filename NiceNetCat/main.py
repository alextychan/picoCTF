with open('val.txt', 'r') as f:
    val = ""
    for line in f.readlines():
        if line:
            val += chr(int(line))
    print(val)
