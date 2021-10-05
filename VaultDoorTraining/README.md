# Solution

Password is inside the VaultDoorTraining.java source code

```java
// Get the flag between picoCTF{XXX_FLAG_XXX}
String input = userInput.substring("picoCTF{".length(),userInput.length()-1);

public boolean checkPassword(String password) {
    // Flag is stored here
    return password.equals("w4rm1ng_Up_w1tH_jAv4_3808d338b46");
}
```