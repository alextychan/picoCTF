import hashlib

start = 'picoCTF{1n_7h3_|<3y_of_'

# Need to decode the dynamic part
bUsername_trial = b'FRASER'

decoded_username_trial = [hashlib.sha256(bUsername_trial).hexdigest()[i] for i in range(1, 9)]

order = [4,5,3,6,2,7,1,8]

decoded_part = [decoded_username_trial[i - 1] for i in order]

flag = start + ''.join(decoded_part) + '}'
print(flag)



