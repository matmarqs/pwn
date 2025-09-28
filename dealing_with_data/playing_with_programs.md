# Playing with Programs

## What's the password

Here is the `/challenge/runme` file:

```python
#!/usr/bin/exec-suid -- /bin/python3 -I

import sys


print("Enter the password:")
entered_password = sys.stdin.buffer.read1().strip()
correct_password = b"hctvgren"

print(f"Read {len(entered_password)} bytes.")


if entered_password == correct_password:
    print("Congrats! Here is your flag:")
    print(open("/flag").read().strip())
else:
    print("Incorrect!")
    sys.exit(1)
```

Very easy, the password is `hctvgren`.

```
hacker@data-dealings~whats-the-password:~$ /challenge/runme
Enter the password:
hctvgren
Read 8 bytes.
Congrats! Here is your flag:
pwn.college{EC2m76qcA5N1plKYB3TObt5jS2w.0VO0YDNxwyMyITOyEzW}
```

## ... and again!

Same thing

```python
#!/usr/bin/exec-suid -- /bin/python3 -I

import sys


print("Enter the password:")
entered_password = sys.stdin.buffer.read1().strip()
correct_password = b"tkqhcukj"

print(f"Read {len(entered_password)} bytes.")


if entered_password == correct_password:
    print("Congrats! Here is your flag:")
    print(open("/flag").read().strip())
else:
    print("Incorrect!")
    sys.exit(1)
```

```
hacker@data-dealings~-and-again:~$ /challenge/runme
Enter the password:
tkqhcukj
Read 8 bytes.
Congrats! Here is your flag:
pwn.college{cWIw7nP9ZfEWpsVYoiT3sX_zMEK.0FM1YDNxwyMyITOyEzW}
```

## Newline troubles

Here is `/challenge/runme`:

```python
#!/usr/bin/exec-suid -- /bin/python3 -I

import sys


print("Enter the password:")
entered_password = sys.stdin.buffer.read1()
if b"\n" in entered_password:
    print("Password has newlines /")
    print("Editors add them sometimes /")
    print("Learn to remove them.")

correct_password = b"wptikkqn"

print(f"Read {len(entered_password)} bytes.")


if entered_password == correct_password:
    print("Congrats! Here is your flag:")
    print(open("/flag").read().strip())
else:
    print("Incorrect!")
    sys.exit(1)
```

Three ways to solve this challenge:

### Replace Enter with Ctrl-D

```
hacker@data-dealings~newline-troubles:~$ /challenge/runme
Enter the password:
wptikkqnRead 8 bytes.
Congrats! Here is your flag:
pwn.college{AqNL17pmVaSRSc6hg4XzUgzUGqN.0VM1YDNxwyMyITOyEzW}
```

### Using echo

```
hacker@data-dealings~newline-troubles:~$ echo -n wptikkqn | /challenge/runme
Enter the password:
Read 8 bytes.
Congrats! Here is your flag:
pwn.college{AqNL17pmVaSRSc6hg4XzUgzUGqN.0VM1YDNxwyMyITOyEzW}
```

### Redirect file to stdin

```
hacker@data-dealings~newline-troubles:~$ echo -n wptikkqn > input.txt
hacker@data-dealings~newline-troubles:~$ /challenge/runme < input.txt
Enter the password:
Read 8 bytes.
Congrats! Here is your flag:
pwn.college{AqNL17pmVaSRSc6hg4XzUgzUGqN.0VM1YDNxwyMyITOyEzW}
```

## Reasoning about files

```python
#!/usr/bin/exec-suid -- /bin/python3 -I

import sys


try:
    entered_password = open("dlvd", "rb").read()
except FileNotFoundError:
    print("Input file not found...")
    sys.exit(1)
if b"\n" in entered_password:
    print("Password has newlines /")
    print("Editors add them sometimes /")
    print("Learn to remove them.")

correct_password = b"agnhodts"

print(f"Read {len(entered_password)} bytes.")


if entered_password == correct_password:
    print("Congrats! Here is your flag:")
    print(open("/flag").read().strip())
else:
    print("Incorrect!")
    sys.exit(1)
```

We do not have to be in the same directory as the program (`/challenge`), below we were in `/home/hacker`.

```
hacker@data-dealings~reasoning-about-files:~$ echo -n agnhodts > dlvd
hacker@data-dealings~reasoning-about-files:~$ /challenge/runme
Read 8 bytes.
Congrats! Here is your flag:
pwn.college{MBUQ11ItW8Kf--3NqCnwUVT981W.0lM1YDNxwyMyITOyEzW}
hacker@data-dealings~reasoning-about-files:~$ pwd
/home/hacker
```

## Specifying filenames

```python
#!/usr/bin/exec-suid -- /bin/python3 -I

import sys


try:
    entered_password = open(sys.argv[1], "rb").read()
except FileNotFoundError:
    print("Input file not found...")
    sys.exit(1)
if b"\n" in entered_password:
    print("Password has newlines /")
    print("Editors add them sometimes /")
    print("Learn to remove them.")

correct_password = b"gkqcyxsm"

print(f"Read {len(entered_password)} bytes.")


if entered_password == correct_password:
    print("Congrats! Here is your flag:")
    print(open("/flag").read().strip())
else:
    print("Incorrect!")
    sys.exit(1)
```

```
hacker@data-dealings~specifying-filenames:~$ /challenge/runme <(echo -n gkqcyxsm)
Read 8 bytes.
Congrats! Here is your flag:
pwn.college{8XyxGCrsdl5BgREkJvT9CQ-Epsz.01M1YDNxwyMyITOyEzW}
```

## Binary and Hex Encoding

```python
#!/usr/bin/exec-suid -- /bin/python3 -I

import sys


print("Enter the password:")
entered_password = sys.stdin.buffer.read1()
correct_password = b"\x86"

print(f"Read {len(entered_password)} bytes.")


entered_password = bytes.fromhex(entered_password.decode("l1"))


if entered_password == correct_password:
    print("Congrats! Here is your flag:")
    print(open("/flag").read().strip())
else:
    print("Incorrect!")
    sys.exit(1)
```

Just input `86`, because it interprets your input as `hex`

```
hacker@data-dealings~binary-and-hex-encoding:~$ /challenge/runme
Enter the password:
86
Read 3 bytes.
Congrats! Here is your flag:
pwn.college{A5OrZwd7wzjGDvvV8oxHuHn8INf.0FN1YDNxwyMyITOyEzW}
```


## More Hex

```python
#!/usr/bin/exec-suid -- /bin/python3 -I

import sys


print("Enter the password:")
entered_password = sys.stdin.buffer.read1()
correct_password = b"\xc2\xa1\x82\xdb\x91\xce\x94\x8a"

print(f"Read {len(entered_password)} bytes.")


entered_password = bytes.fromhex(entered_password.decode("l1"))


if entered_password == correct_password:
    print("Congrats! Here is your flag:")
    print(open("/flag").read().strip())
else:
    print("Incorrect!")
    sys.exit(1)
```

The program interprets the input as hex, so the password is `c2a182db91ce948a`.

```
hacker@data-dealings~more-hex:~$ /challenge/runme
Enter the password:
c2a182db91ce948a
Read 17 bytes.
Congrats! Here is your flag:
pwn.college{gAY64wVCXSnm5oXpJwV23Jt97Wh.0VN1YDNxwyMyITOyEzW}
```


## Decoding Hex

```python
#!/usr/bin/exec-suid -- /bin/python3 -I

import sys


print("Enter the password:")
entered_password = sys.stdin.buffer.read1()
correct_password = b"88b5ceecae959ff8"

print(f"Read {len(entered_password)} bytes.")


correct_password = bytes.fromhex(correct_password.decode("l1"))


if entered_password == correct_password:
    print("Congrats! Here is your flag:")
    print(open("/flag").read().strip())
else:
    print("Incorrect!")
    sys.exit(1)
```

If we create a `python` script to output the correct password, we get
```
[sekai@void ~]$ cat test.py
correct_password = b"88b5ceecae959ff8"
correct_password = bytes.fromhex(correct_password.decode("l1"))
print(correct_password)
[sekai@void ~]$ python test.py
b'\x88\xb5\xce\xec\xae\x95\x9f\xf8'
```

Therefore, the solution is:
```
hacker@data-dealings~decoding-hex:~$ echo -ne '\x88\xb5\xce\xec\xae\x95\x9f\xf8' | /challenge/runme
Enter the password:
Read 8 bytes.
Congrats! Here is your flag:
pwn.college{Afc7dHILJqfcm7feegH6-Vzf0nP.0lN1YDNxwyMyITOyEzW}
```


## Decoding Practice

```python
#!/usr/bin/exec-suid -- /bin/python3 -I

import sys


def decode_from_bits(s):
    s = s.decode("latin1")
    assert set(s) <= {"0", "1"}, "non-binary characters found in bitstream!"
    assert len(s) % 8 == 0, "must enter data in complete bytes (each byte is 8 bits)"
    return int.to_bytes(int(s, 2), length=len(s) // 8, byteorder="big")


print("Enter the password:")
entered_password = sys.stdin.buffer.read1()
correct_password = b"1001011010001010111101011000001010111010101001101101101011101101"

print(f"Read {len(entered_password)} bytes.")


correct_password = decode_from_bits(correct_password)


if entered_password == correct_password:
    print("Congrats! Here is your flag:")
    print(open("/flag").read().strip())
else:
    print("Incorrect!")
    sys.exit(1)
```

Our `python` script solution:
```python
def decode_from_bits(s):
    s = s.decode("latin1")
    assert set(s) <= {"0", "1"}, "non-binary characters found in bitstream!"
    assert len(s) % 8 == 0, "must enter data in complete bytes (each byte is 8 bits)"
    return int.to_bytes(int(s, 2), length=len(s) // 8, byteorder="big")

correct_password = b"1001011010001010111101011000001010111010101001101101101011101101"
correct_password = decode_from_bits(correct_password)
print(correct_password)
```

```
hacker@data-dealings~decoding-practice:~$ echo -ne '\x96\x8a\xf5\x82\xba\xa6\xda\xed' | /challenge/runme
Enter the password:
Read 8 bytes.
Congrats! Here is your flag:
pwn.college{QSOkKTamuUaywLUr16uP53DnPVT.01N1YDNxwyMyITOyEzW}
```


## Encoding Practice

```python
#!/usr/bin/exec-suid -- /bin/python3 -I

import sys


def decode_from_bits(s):
    s = s.decode("latin1")
    assert set(s) <= {"0", "1"}, "non-binary characters found in bitstream!"
    assert len(s) % 8 == 0, "must enter data in complete bytes (each byte is 8 bits)"
    return int.to_bytes(int(s, 2), length=len(s) // 8, byteorder="big")


print("Enter the password:")
entered_password = sys.stdin.buffer.read1()
correct_password = b"\x9e\x94\xe0\xb8\x8d\x84\xa2\x8b"

print(f"Read {len(entered_password)} bytes.")


entered_password = decode_from_bits(entered_password)


if entered_password == correct_password:
    print("Congrats! Here is your flag:")
    print(open("/flag").read().strip())
else:
    print("Incorrect!")
    sys.exit(1)
```

Here is our `python` script solution to encode in bits:
```
def encode_from_hex(s):
    result = ''
    for b in s:
        result += bin(b)[2:]
    return result

correct_password = b"\x9e\x94\xe0\xb8\x8d\x84\xa2\x8b"
print(encode_from_hex(correct_password))
```

```
hacker@data-dealings~encoding-practice:~$ echo -ne "1001111010010100111000001011100010001101100001001010001010001011" | /challenge/runme
Enter the password:
Read 64 bytes.
Congrats! Here is your flag:
pwn.college{kGCT8cXVHEJfERsqnEoilOsFEyV.0FO1YDNxwyMyITOyEzW}
```

## Hex-encoding ASCII

```python
#!/usr/bin/exec-suid -- /bin/python3 -I

import sys


print("Enter the password:")
entered_password = sys.stdin.buffer.read1()
correct_password = b"iurukelx"

print(f"Read {len(entered_password)} bytes.")


entered_password = bytes.fromhex(entered_password.decode("l1"))


if entered_password == correct_password:
    print("Congrats! Here is your flag:")
    print(open("/flag").read().strip())
else:
    print("Incorrect!")
    sys.exit(1)
```

Here is `python` the solution:
```python
def encode_from_ascii(s):
    result = ''
    for b in s:
        result += hex(b)[2:]
    return result

correct_password = b"iurukelx"

print(encode_from_ascii(correct_password))
```


```
hacker@data-dealings~hex-encoding-ascii:~$ echo "697572756b656c78" | /challenge/runme
Enter the password:
Read 17 bytes.
Congrats! Here is your flag:
pwn.college{4RjVx25_43sEiye-6L9EGNf9XHX.0VO1YDNxwyMyITOyEzW}
```

## Nested Encoding

```python
#!/usr/bin/exec-suid -- /bin/python3 -I

import sys


try:
    entered_password = open(sys.argv[1], "rb").read()
except FileNotFoundError:
    print("Input file not found...")
    sys.exit(1)
correct_password = b"qbtsxoxg"

print(f"Read {len(entered_password)} bytes.")


entered_password = bytes.fromhex(entered_password.decode("l1"))
entered_password = bytes.fromhex(entered_password.decode("l1"))
entered_password = bytes.fromhex(entered_password.decode("l1"))
entered_password = bytes.fromhex(entered_password.decode("l1"))


if entered_password == correct_password:
    print("Congrats! Here is your flag:")
    print(open("/flag").read().strip())
else:
    print("Incorrect!")
    sys.exit(1)
```

Here is the `python` script solution:
```python
def encode_to_hex(s):
    if type(s) == bytes:
         = str(s, 'ascii')
    result = ""
    for c in s:
        result += hex(ord(c))[2:]
    return result

correct_password = b"qbtsxoxg"

for _ in range(4):
    print(correct_password)
    correct_password = encode_to_hex(correct_password)

print(correct_password)
```


```
hacker@data-dealings~nested-encoding:~$ /challenge/runme <(echo -n "33333337333333313333333633333332333333373333333433333337333333333333333733333338333333363336333633333337333333383333333633333337")
Read 128 bytes.
Congrats! Here is your flag:
pwn.college{M-0wbQFK08LYK6W31ZEOaKzF3TT.0FM2YDNxwyMyITOyEzW}
```


## Hex-encoding UTF-8

```python
#!/usr/bin/exec-suid -- /bin/python3 -I

import sys


try:
    entered_password = open("wsjh", "rb").read()
except FileNotFoundError:
    print("Input file not found...")
    sys.exit(1)
correct_password = "📥 🔋 🍇 ❓".encode("utf-8")

print(f"Read {len(entered_password)} bytes.")


entered_password = bytes.fromhex(entered_password.decode("l1"))


if entered_password == correct_password:
    print("Congrats! Here is your flag:")
    print(open("/flag").read().strip())
else:
    print("Incorrect!")
    sys.exit(1)
```

Here is the `python` script solution:
```python
def bytes_to_hex(bs):
    result = ""
    for b in bs:
        result += hex(b)[2:]
    return result

correct_password = "📥 🔋 🍇 ❓".encode("utf-8")

entered_password = bytes_to_hex(correct_password)
print(entered_password)

# the below code only verifies the password
entered_password = entered_password.encode("utf-8")
entered_password = bytes.fromhex(entered_password.decode("l1"))

if entered_password == correct_password:
    print("Congrats! Here is your flag:")
else:
    print("Incorrect!")
```



```
hacker@data-dealings~hex-encoding-utf-8:~$ echo -n "f09f93a520f09f948b20f09f8d8720e29d93" > wsjh
hacker@data-dealings~hex-encoding-utf-8:~$ /challenge/runme
Read 36 bytes.
Congrats! Here is your flag:
pwn.college{A1QY6Soq7AspmLYN5vssenjLPum.0VM2YDNxwyMyITOyEzW}
```

## UTF Mixups

```python
#!/usr/bin/exec-suid -- /bin/python3 -I

import sys


print("Enter the password:")
entered_password = sys.stdin.buffer.read1()
correct_password = b"kddozchq"

print(f"Read {len(entered_password)} bytes.")

assert entered_password != correct_password

entered_password = entered_password.decode("utf-16")
entered_password = entered_password.encode("latin1")


if entered_password == correct_password:
    print("Congrats! Here is your flag:")
    print(open("/flag").read().strip())
else:
    print("Incorrect!")
    sys.exit(1)
```

Here is the `python` script solution:
```python
correct_password = b"kddozchq"

print(repr(correct_password.decode("latin1").encode("utf-16"))[2:-1])
```

```
hacker@data-dealings~utf-mixups:~$ echo -ne "\xff\xfek\x00d\x00d\x00o\x00z\x00c\x00h\x00q\x00" | /challenge/runme
Enter the password:
Read 18 bytes.
Congrats! Here is your flag:
pwn.college{Mqbx3H0E08qmL0pf-Nk3D7lMuPE.0lM2YDNxwyMyITOyEzW}
```

## Modifying Encode Data

```python
#!/usr/bin/exec-suid -- /bin/python3 -I

import sys


def reverse_string(s):
    return s[::-1]


print("Enter the password:")
entered_password = sys.stdin.buffer.read1()
correct_password = b"\xf1~\xe6P\xc0\x9a\x1f\xa6"

print(f"Read {len(entered_password)} bytes.")


entered_password = entered_password[::-1]
entered_password = bytes.fromhex(entered_password.decode("l1"))


if entered_password == correct_password:
    print("Congrats! Here is your flag:")
    print(open("/flag").read().strip())
else:
    print("Incorrect!")
    sys.exit(1)
```

Here is the `python` script solution:
```python
def bytes_to_hex(bs: bytes) -> bytes:
    result = ""
    for b in bs:
        result += hex(b)[2:]
    return result.encode()  # transforms str -> bytes

correct_password = b"\xf1~\xe6P\xc0\x9a\x1f\xa6"

entered_password = bytes_to_hex(correct_password)[::-1]
print(repr(entered_password)[2:-1])

# the code below verifies the answer

entered_password = entered_password[::-1]
entered_password = bytes.fromhex(entered_password.decode("l1"))

if entered_password == correct_password:
    print("Congrats! Here is your flag:")
else:
    print("Incorrect!")
```

Inserting the password with Ctrl-D at the end:
```
hacker@data-dealings~modifying-encoded-data:~$ /challenge/runme
Enter the password:
6af1a90c056ee71fRead 16 bytes.
Congrats! Here is your flag:
pwn.college{04jjyHVYPX-6ji3NoSrwKnE23-l.01M2YDNxwyMyITOyEzW}
```

## Decoding Base64

```python
#!/usr/bin/exec-suid -- /bin/python3 -I

import sys

import base64


print("Enter the password:")
entered_password = sys.stdin.buffer.read1()
correct_password = b"H9746gX780c="

print(f"Read {len(entered_password)} bytes.")


correct_password = base64.b64decode(correct_password.decode("l1"))


if entered_password == correct_password:
    print("Congrats! Here is your flag:")
    print(open("/flag").read().strip())
else:
    print("Incorrect!")
    sys.exit(1)
```

Here is the `python` script solution:
```python
import base64
correct_password = b"H9746gX780c="

entered_password = base64.b64decode(correct_password.decode("l1"))
print(repr(entered_password)[2:-1])
```

```
hacker@data-dealings~decoding-base64:~$ echo -ne "\x1f\xde\xf8\xea\x05\xfb\xf3G" | /challenge/runme
Enter the password:
Read 8 bytes.
Congrats! Here is your flag:
pwn.college{0te2UcGbsi-iDr1xKVrieRaq-5U.QXzczMzwyMyITOyEzW}
```

Another way to solve the challenge is with the command `base64 -d`:
```
hacker@data-dealings~decoding-base64:~$ echo -n "H9746gX780c=" | base64 -d | /challenge/runme
Enter the password:
Read 8 bytes.
Congrats! Here is your flag:
pwn.college{0te2UcGbsi-iDr1xKVrieRaq-5U.QXzczMzwyMyITOyEzW}
```


## Encoding Base64

```python
#!/usr/bin/exec-suid -- /bin/python3 -I

import sys

import base64


print("Enter the password:")
entered_password = sys.stdin.buffer.read1()
correct_password = b"\x13i\xe7).\x88mB"

print(f"Read {len(entered_password)} bytes.")


entered_password = base64.b64decode(entered_password.decode("l1"))


if entered_password == correct_password:
    print("Congrats! Here is your flag:")
    print(open("/flag").read().strip())
else:
    print("Incorrect!")
    sys.exit(1)
```


Here is the `python` script solution:
```python
import base64

correct_password = b"\x13i\xe7).\x88mB"

entered_password = base64.b64encode(correct_password)
print(repr(entered_password)[2:-1])

# the code below verifies the answer
entered_password = base64.b64decode(entered_password.decode("l1"))

if entered_password == correct_password:
    print("Congrats! Here is your flag:")
else:
    print("Incorrect!")
```

```
hacker@data-dealings~encoding-base64:~$ /challenge/runme
Enter the password:
E2nnKS6IbUI=Read 12 bytes.
Congrats! Here is your flag:
pwn.college{EvsfdimGa8bilaRgx_y7l8LT7_n.0FO2YDNxwyMyITOyEzW}
```


## Dealing with Obfuscation

```python
#!/usr/bin/exec-suid -- /bin/python3 -I

import sys

import base64


def reverse_string(s):
    return s[::-1]


print("Enter the password:")
entered_password = sys.stdin.buffer.read1()
correct_password = b"\xb5\xc1\xcbx\x98\xa3\xa8\x84"

print(f"Read {len(entered_password)} bytes.")


correct_password = correct_password[::-1]
correct_password = correct_password[::-1]
correct_password = base64.b64encode(correct_password)
correct_password = base64.b64encode(correct_password)


if entered_password == correct_password:
    print("Congrats! Here is your flag:")
    print(open("/flag").read().strip())
else:
    print("Incorrect!")
    sys.exit(1)
```

Here is the `python` script solution:
```python
import base64

correct_password = b"\xb5\xc1\xcbx\x98\xa3\xa8\x84"

correct_password = correct_password[::-1]
correct_password = correct_password[::-1]
correct_password = base64.b64encode(correct_password)
correct_password = base64.b64encode(correct_password)

print(repr(correct_password)[2:-1])
```

```
hacker@data-dealings~dealing-with-obfuscation:~$ /challenge/runme
Enter the password:
dGNITGVKaWpxSVE9Read 16 bytes.
Congrats! Here is your flag:
pwn.college{4irEswewDnEtF-sBJjLSR5vV1FB.0lN2YDNxwyMyITOyEzW}
```

## Dealing with Obfuscation 2

```python
#!/usr/bin/exec-suid -- /bin/python3 -I

import sys

import base64


def reverse_string(s):
    return s[::-1]


def encode_to_bits(s):
    return b"".join(format(c, "08b").encode("latin1") for c in s)


print("Enter the password:")
entered_password = sys.stdin.buffer.read1()
correct_password = b"\x15m\xa42H\xe1m("

print(f"Read {len(entered_password)} bytes.")


entered_password = entered_password[::-1]
entered_password = entered_password[::-1]
entered_password = entered_password[::-1]
entered_password = base64.b64decode(entered_password.decode("l1"))

correct_password = encode_to_bits(correct_password)
correct_password = base64.b64encode(correct_password)
correct_password = correct_password[::-1]
correct_password = correct_password[::-1]


if entered_password == correct_password:
    print("Congrats! Here is your flag:")
    print(open("/flag").read().strip())
else:
    print("Incorrect!")
    sys.exit(1)
```

Here is the `python` script solution:
```python
import base64

def encode_to_bits(s):
    return b"".join(format(c, "08b").encode("latin1") for c in s)

correct_password = b"\x15m\xa42H\xe1m("
correct_password = encode_to_bits(correct_password)
correct_password = base64.b64encode(correct_password)
correct_password = correct_password[::-1]
correct_password = correct_password[::-1]

# THIS IS THE ACTUAL ANSWER
entered_password = base64.b64encode(correct_password)[::-1]
print(repr(entered_password)[2:-1])

# the code below verifies it
entered_password = entered_password[::-1]
entered_password = entered_password[::-1]
entered_password = entered_password[::-1]
entered_password = base64.b64decode(entered_password.decode("l1"))

if entered_password == correct_password:
    print("Congrats! Here is your flag:")
else:
    print("Incorrect!")
```

```
hacker@data-dealings~dealing-with-obfuscation-2:~$ /challenge/runme
Enter the password:
==QP9EUT3FEVNdXRE10dFRUT4VERNhXRE1EeBRUT3FEVNhXRE10dBRVT3FEVNdXQU10dBRVT4FERNdXQU10dBRVT3VEVNdXRU10dFRVT3VERNhXQU10dBRUTRead 120 bytes.
Congrats! Here is your flag:
pwn.college{QgC2Al6FBF0Mdbk9bUFnifEIxtb.01N2YDNxwyMyITOyEzW}
```
