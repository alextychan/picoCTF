# Solution was from https://github.com/Dvd848/CTFs/blob/master/2021_picoCTF/Easy_Peasy.md

Got the solution, just couldn't understand why netcat wasn't sending the bytes. Or if it's not capable of from the shell?

# Question
Question: Why does the command line not allow us to send binary or hex over?

Checking the captured packets in Wireshark, we can see that python is sending the bytes just fine. But when typing and sending the decoded string in the command line it will actually send the typed string instead of the actual bytes.


# References:

1. [How to send binary data in netcat to an already established connection?
   ](https://superuser.com/questions/1307732/how-to-send-binary-data-in-netcat-to-an-already-established-connection)