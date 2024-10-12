## Luhn check
 
The Luhn check is a simple checksum, famously used to check credit card numbers are at least possibly valid.
 
Take this number:
 
```text
4539 3195 0343 6467
```
 
The first thing we do is, *starting on the right*, double every second number and, if that number is greater than 9, subtract 9 from it:
 
```text
4539 3195 0343 6467
^ ^  ^ ^  ^ ^  ^ ^
8569 6195 0383 3437
```
 
The next step is to add all the digits:
 
```text
8+5+6+9+6+1+9+5+0+3+8+3+3+4+3+7 = 80
```
 
If the sum is evenly divisible by 10 then the number is valid.
 
Another example:
 
```text
8273 1232 7352 0569
^ ^  ^ ^  ^ ^  ^ ^
7+2+5+3+2+2+6+2+5+3+1+2+0+5+3+9 = 57
```
 
57 is not evenly divisible by 10 so it is invalid.