# SQL Playground

## SQL Queries

```python
#!/opt/pwn.college/python

import sys
import string
import random
import sqlite3
import tempfile


# Don't panic about the TemporaryDB class. It simply implements a temporary database
# in which this application can store data. You don't need to understand its internals,
# just that it processes SQL queries using db.execute().
class TemporaryDB:
    def __init__(self):
        self.db_file = tempfile.NamedTemporaryFile("x", suffix=".db")

    def execute(self, sql, parameters=()):
        connection = sqlite3.connect(self.db_file.name)
        connection.row_factory = sqlite3.Row
        cursor = connection.cursor()
        result = cursor.execute(sql, parameters)
        connection.commit()
        return result


db = TemporaryDB()

# https://www.sqlite.org/lang_createtable.html
db.execute("""CREATE TABLE secrets AS SELECT ? as entry""", [open("/flag").read().strip()])

# HINT: https://www.sqlite.org/lang_select.html
for _ in range(1):
    query = input("sql> ")

    try:
        results = db.execute(query).fetchall()
    except sqlite3.Error as e:
        print("SQL ERROR:", e)
        sys.exit(1)

    if len(results) == 0:
        print("No results returned!")
        sys.exit(0)

    print(f"Got {len(results)} rows.")
    for row in results:
        print(f"- { { k:row[k] for k in row.keys() } }")
```

```
hacker@sql-playground~sql-queries:~$ /challenge/sql 
sql> select * from secrets
Got 1 rows.
- {'entry': 'pwn.college{YYNX0ByFKGdsixaiUoURdvCZt6_.0VO5cDNxwyMyITOyEzW}'}
```

## Filtering SQL

```python
#!/opt/pwn.college/python

import sys
import string
import random
import sqlite3
import tempfile


# Don't panic about the TemporaryDB class. It simply implements a temporary database
# in which this application can store data. You don't need to understand its internals,
# just that it processes SQL queries using db.execute().
class TemporaryDB:
    def __init__(self):
        self.db_file = tempfile.NamedTemporaryFile("x", suffix=".db")

    def execute(self, sql, parameters=()):
        connection = sqlite3.connect(self.db_file.name)
        connection.row_factory = sqlite3.Row
        cursor = connection.cursor()
        result = cursor.execute(sql, parameters)
        connection.commit()
        return result


db = TemporaryDB()


def random_word(length):
    return "".join(random.sample(string.ascii_letters * 10, length))


flag = open("/flag").read().strip()

# https://www.sqlite.org/lang_createtable.html
db.execute("""CREATE TABLE data AS SELECT 1 as flag_tag, ? as note""", [random_word(len(flag))])
# https://www.sqlite.org/lang_insert.html
for i in range(random.randrange(5, 42)):
    db.execute("""INSERT INTO data VALUES(1, ?)""", [random_word(len(flag))])
db.execute("""INSERT INTO data VALUES(?, ?)""", [1337, flag])


for i in range(random.randrange(5, 42)):
    db.execute("""INSERT INTO data VALUES(1, ?)""", [random_word(len(flag))])

# HINT: https://www.sqlite.org/lang_select.html#whereclause
for _ in range(1):
    query = input("sql> ")

    try:
        results = db.execute(query).fetchall()
    except sqlite3.Error as e:
        print("SQL ERROR:", e)
        sys.exit(1)

    if len(results) == 0:
        print("No results returned!")
        sys.exit(0)

    if len(results) > 1:
        print("You're not allowed to read this many rows!")
        sys.exit(1)
    print(f"Got {len(results)} rows.")
    for row in results:
        print(f"- { { k:row[k] for k in row.keys() } }")
```

```
hacker@sql-playground~filtering-sql:~$ /challenge/sql 
sql> SELECT * FROM data where flag_tag = 1337
Got 1 rows.
- {'flag_tag': 1337, 'note': 'pwn.college{gOst55yixmL8gY9b7kUTAMUQLyq.0FMwgDNxwyMyITOyEzW}'}
```

## Choosing Columns

```python
#!/opt/pwn.college/python

import sys
import string
import random
import sqlite3
import tempfile


# Don't panic about the TemporaryDB class. It simply implements a temporary database
# in which this application can store data. You don't need to understand its internals,
# just that it processes SQL queries using db.execute().
class TemporaryDB:
    def __init__(self):
        self.db_file = tempfile.NamedTemporaryFile("x", suffix=".db")

    def execute(self, sql, parameters=()):
        connection = sqlite3.connect(self.db_file.name)
        connection.row_factory = sqlite3.Row
        cursor = connection.cursor()
        result = cursor.execute(sql, parameters)
        connection.commit()
        return result


db = TemporaryDB()


def random_word(length):
    return "".join(random.sample(string.ascii_letters * 10, length))


flag = open("/flag").read().strip()

# https://www.sqlite.org/lang_createtable.html
db.execute("""CREATE TABLE details AS SELECT 1 as flag_tag, ? as info""", [random_word(len(flag))])
# https://www.sqlite.org/lang_insert.html
for i in range(random.randrange(5, 42)):
    db.execute("""INSERT INTO details VALUES(1, ?)""", [random_word(len(flag))])
db.execute("""INSERT INTO details VALUES(?, ?)""", [1337, flag])


for i in range(random.randrange(5, 42)):
    db.execute("""INSERT INTO details VALUES(1, ?)""", [random_word(len(flag))])

# HINT: https://www.sqlite.org/syntax/result-column.html
for _ in range(1):
    query = input("sql> ")

    try:
        results = db.execute(query).fetchall()
    except sqlite3.Error as e:
        print("SQL ERROR:", e)
        sys.exit(1)

    if len(results) == 0:
        print("No results returned!")
        sys.exit(0)

    if len(results) > 1:
        print("You're not allowed to read this many rows!")
        sys.exit(1)
    if len(results[0].keys()) > 1:
        print("You're not allowed to read this many columns!")
        sys.exit(1)
    print(f"Got {len(results)} rows.")
    for row in results:
        print(f"- { { k:row[k] for k in row.keys() } }")
```

```
hacker@sql-playground~choosing-columns:~$ /challenge/sql 
sql> SELECT info FROM details where flag_tag = 1337
Got 1 rows.
- {'info': 'pwn.college{AEy4Hnga8U-rCY30eUmmt-uq9Ng.0VMwgDNxwyMyITOyEzW}'}
```

## Exclusionary Filtering

```python
#!/opt/pwn.college/python

import sys
import string
import random
import sqlite3
import tempfile


# Don't panic about the TemporaryDB class. It simply implements a temporary database
# in which this application can store data. You don't need to understand its internals,
# just that it processes SQL queries using db.execute().
class TemporaryDB:
    def __init__(self):
        self.db_file = tempfile.NamedTemporaryFile("x", suffix=".db")

    def execute(self, sql, parameters=()):
        connection = sqlite3.connect(self.db_file.name)
        connection.row_factory = sqlite3.Row
        cursor = connection.cursor()
        result = cursor.execute(sql, parameters)
        connection.commit()
        return result


db = TemporaryDB()


def random_word(length):
    return "".join(random.sample(string.ascii_letters * 10, length))


flag = open("/flag").read().strip()

# https://www.sqlite.org/lang_createtable.html
db.execute("""CREATE TABLE information AS SELECT 1 as flag_tag, ? as snippet""", [random_word(len(flag))])
# https://www.sqlite.org/lang_insert.html
for i in range(random.randrange(5, 42)):
    db.execute("""INSERT INTO information VALUES(1, ?)""", [random_word(len(flag))])
db.execute("""INSERT INTO information VALUES(?, ?)""", [random.randrange(1337, 313371337), flag])


for i in range(random.randrange(5, 42)):
    db.execute("""INSERT INTO information VALUES(1, ?)""", [random_word(len(flag))])

# HINT: https://www.sqlite.org/lang_expr.html
for _ in range(1):
    query = input("sql> ")

    try:
        results = db.execute(query).fetchall()
    except sqlite3.Error as e:
        print("SQL ERROR:", e)
        sys.exit(1)

    if len(results) == 0:
        print("No results returned!")
        sys.exit(0)

    if len(results) > 1:
        print("You're not allowed to read this many rows!")
        sys.exit(1)
    if len(results[0].keys()) > 1:
        print("You're not allowed to read this many columns!")
        sys.exit(1)
    print(f"Got {len(results)} rows.")
    for row in results:
        print(f"- { { k:row[k] for k in row.keys() } }")
```

```
hacker@sql-playground~exclusionary-filtering:~$ /challenge/sql 
sql> SELECT snippet FROM information WHERE flag_tag != 1
Got 1 rows.
- {'snippet': 'pwn.college{MeiW7K_vSQmTHxQlqLm1Qqezr0u.0lMwgDNxwyMyITOyEzW}'}
```

## Filtering Strings

```python
#!/opt/pwn.college/python

import sys
import string
import random
import sqlite3
import tempfile


# Don't panic about the TemporaryDB class. It simply implements a temporary database
# in which this application can store data. You don't need to understand its internals,
# just that it processes SQL queries using db.execute().
class TemporaryDB:
    def __init__(self):
        self.db_file = tempfile.NamedTemporaryFile("x", suffix=".db")

    def execute(self, sql, parameters=()):
        connection = sqlite3.connect(self.db_file.name)
        connection.row_factory = sqlite3.Row
        cursor = connection.cursor()
        result = cursor.execute(sql, parameters)
        connection.commit()
        return result


db = TemporaryDB()


def random_word(length):
    return "".join(random.sample(string.ascii_letters * 10, length))


flag = open("/flag").read().strip()

# https://www.sqlite.org/lang_createtable.html
db.execute("""CREATE TABLE data AS SELECT 'nope' as flag_tag, ? as secret""", [random_word(len(flag))])
# https://www.sqlite.org/lang_insert.html
for i in range(random.randrange(5, 42)):
    db.execute("""INSERT INTO data VALUES('nope', ?)""", [random_word(len(flag))])
db.execute("""INSERT INTO data VALUES(?, ?)""", ["yep", flag])


for i in range(random.randrange(5, 42)):
    db.execute("""INSERT INTO data VALUES('nope', ?)""", [random_word(len(flag))])

# HINT: https://www.sqlite.org/lang_expr.html
for _ in range(1):
    query = input("sql> ")

    try:
        results = db.execute(query).fetchall()
    except sqlite3.Error as e:
        print("SQL ERROR:", e)
        sys.exit(1)

    if len(results) == 0:
        print("No results returned!")
        sys.exit(0)

    if len(results) > 1:
        print("You're not allowed to read this many rows!")
        sys.exit(1)
    if len(results[0].keys()) > 1:
        print("You're not allowed to read this many columns!")
        sys.exit(1)
    print(f"Got {len(results)} rows.")
    for row in results:
        print(f"- { { k:row[k] for k in row.keys() } }")
```

```
hacker@sql-playground~filtering-strings:~$ /challenge/sql 
sql> SELECT secret FROM data WHERE flag_tag != 'nope'
Got 1 rows.
- {'secret': 'pwn.college{snJl2YZa53dX8v2A5JYsBRVsY50.01MwgDNxwyMyITOyEzW}'}
```

## Filtering on Expressions

```python
#!/opt/pwn.college/python

import sys
import string
import random
import sqlite3
import tempfile


# Don't panic about the TemporaryDB class. It simply implements a temporary database
# in which this application can store data. You don't need to understand its internals,
# just that it processes SQL queries using db.execute().
class TemporaryDB:
    def __init__(self):
        self.db_file = tempfile.NamedTemporaryFile("x", suffix=".db")

    def execute(self, sql, parameters=()):
        connection = sqlite3.connect(self.db_file.name)
        connection.row_factory = sqlite3.Row
        cursor = connection.cursor()
        result = cursor.execute(sql, parameters)
        connection.commit()
        return result


db = TemporaryDB()


def random_word(length):
    return "".join(random.sample(string.ascii_letters * 10, length))


flag = open("/flag").read().strip()

# https://www.sqlite.org/lang_createtable.html
db.execute("""CREATE TABLE assets AS SELECT ? as note""", [random_word(len(flag))])
# https://www.sqlite.org/lang_insert.html
for i in range(random.randrange(5, 42)):
    db.execute("""INSERT INTO assets VALUES(?)""", [random_word(len(flag))])
db.execute("""INSERT INTO assets VALUES(?)""", [flag])


for i in range(random.randrange(5, 42)):
    db.execute("""INSERT INTO assets VALUES(?)""", [random_word(len(flag))])

# HINT: https://www.sqlite.org/lang_corefunc.html#substr
for _ in range(1):
    query = input("sql> ")

    try:
        results = db.execute(query).fetchall()
    except sqlite3.Error as e:
        print("SQL ERROR:", e)
        sys.exit(1)

    if len(results) == 0:
        print("No results returned!")
        sys.exit(0)

    if len(results) > 1:
        print("You're not allowed to read this many rows!")
        sys.exit(1)
    if len(results[0].keys()) > 1:
        print("You're not allowed to read this many columns!")
        sys.exit(1)
    print(f"Got {len(results)} rows.")
    for row in results:
        print(f"- { { k:row[k] for k in row.keys() } }")
```

With `LIKE`:

```
hacker@sql-playground~filtering-on-expressions:~$ /challenge/sql 
sql> SELECT note FROM assets WHERE note LIKE 'pwn.college{%'
Got 1 rows.
- {'note': 'pwn.college{Yw2ZQElPdmWNCHzw2JWaw6FP2Sx.0FNwgDNxwyMyITOyEzW}'}
```

With `substr`:
```
hacker@sql-playground~filtering-on-expressions:~$ /challenge/sql 
sql> SELECT note FROM assets WHERE substr(note, 1, 11) = 'pwn.college'
Got 1 rows.
- {'note': 'pwn.college{Yw2ZQElPdmWNCHzw2JWaw6FP2Sx.0FNwgDNxwyMyITOyEzW}'}
```

## SELECTing Expressions

```python
#!/opt/pwn.college/python

import sys
import string
import random
import sqlite3
import tempfile


# Don't panic about the TemporaryDB class. It simply implements a temporary database
# in which this application can store data. You don't need to understand its internals,
# just that it processes SQL queries using db.execute().
class TemporaryDB:
    def __init__(self):
        self.db_file = tempfile.NamedTemporaryFile("x", suffix=".db")

    def execute(self, sql, parameters=()):
        connection = sqlite3.connect(self.db_file.name)
        connection.row_factory = sqlite3.Row
        cursor = connection.cursor()
        result = cursor.execute(sql, parameters)
        connection.commit()
        return result


db = TemporaryDB()

# https://www.sqlite.org/lang_createtable.html
db.execute("""CREATE TABLE items AS SELECT ? as secret""", [open("/flag").read().strip()])

# HINT: https://www.sqlite.org/lang_corefunc.html#substr
for _ in range(1):
    query = input("sql> ")

    try:
        results = db.execute(query).fetchall()
    except sqlite3.Error as e:
        print("SQL ERROR:", e)
        sys.exit(1)

    if len(results) == 0:
        print("No results returned!")
        sys.exit(0)

    for row in results:
        for k in row.keys():
            if type(row[k]) in (str, bytes) and len(row[k]) > 5:
                print("You're not allowed to read this many characters!")
                sys.exit(1)
    print(f"Got {len(results)} rows.")
    for row in results:
        print(f"- { { k:row[k] for k in row.keys() } }")
```

```
hacker@sql-playground~selecting-expressions:~$ n=1; for i in {1..13}; do echo "SELECT substr(secret, $n, 5) FROM items" | /challenge/sql | grep "substr" | cut -d ':' -f 2 | tr -d "' " | sed 's/}$//' | tr -d "\n"; n=$(expr $n + 5); done; echo
pwn.college{42qXhVkFlVUgWoapR0HFkwnmVtl.0VNwgDNxwyMyITOyEzW}
```

In one script:
```bash
#!/bin/bash
n=1
for i in {1..13}; do
    echo "SELECT substr(secret, $n, 5) FROM items" | /challenge/sql \
    | grep "substr" | cut -d ':' -f 2 | tr -d "' " | sed 's/}$//' | tr -d "\n";
    n=$(expr $n + 5)
done
echo
```

## Composite Conditions

```python
#!/opt/pwn.college/python

import sys
import string
import random
import sqlite3
import tempfile


# Don't panic about the TemporaryDB class. It simply implements a temporary database
# in which this application can store data. You don't need to understand its internals,
# just that it processes SQL queries using db.execute().
class TemporaryDB:
    def __init__(self):
        self.db_file = tempfile.NamedTemporaryFile("x", suffix=".db")

    def execute(self, sql, parameters=()):
        connection = sqlite3.connect(self.db_file.name)
        connection.row_factory = sqlite3.Row
        cursor = connection.cursor()
        result = cursor.execute(sql, parameters)
        connection.commit()
        return result


db = TemporaryDB()


def random_word(length):
    return "".join(random.sample(string.ascii_letters * 10, length))


flag = open("/flag").read().strip()

# https://www.sqlite.org/lang_createtable.html
db.execute("""CREATE TABLE storage AS SELECT 1 as flag_tag, ? as note""", [random_word(len(flag))])
# https://www.sqlite.org/lang_insert.html
for i in range(random.randrange(5, 42)):
    db.execute("""INSERT INTO storage VALUES(1, ?)""", [random_word(len(flag))])
db.execute("""INSERT INTO storage VALUES(?, ?)""", [1337, flag])

for i in range(random.randrange(5, 21)):
    db.execute("""INSERT INTO storage VALUES(1337, ?)""", [random_word(len(flag))])
for i in range(random.randrange(5, 21)):
    db.execute(
        """INSERT INTO storage VALUES(1, ?)""", ["pwn.college{" + random_word(len(flag) - len("pwn.college{}")) + "}"]
    )

for i in range(random.randrange(5, 42)):
    db.execute("""INSERT INTO storage VALUES(1, ?)""", [random_word(len(flag))])

# HINT: https://www.geeksforgeeks.org/sql-and-and-or-operators/
for _ in range(1):
    query = input("sql> ")

    try:
        results = db.execute(query).fetchall()
    except sqlite3.Error as e:
        print("SQL ERROR:", e)
        sys.exit(1)

    if len(results) == 0:
        print("No results returned!")
        sys.exit(0)

    if len(results) > 1:
        print("You're not allowed to read this many rows!")
        sys.exit(1)
    if len(results[0].keys()) > 1:
        print("You're not allowed to read this many columns!")
        sys.exit(1)
    print(f"Got {len(results)} rows.")
    for row in results:
        print(f"- { { k:row[k] for k in row.keys() } }")
```

```
hacker@sql-playground~composite-conditions:~$ /challenge/sql 
sql> SELECT note FROM storage WHERE flag_tag = 1337 AND substr(note, 1, 12) = 'pwn.college{'
Got 1 rows.
- {'note': 'pwn.college{8-CQoTrgnHMlOWysIKulqdgR32b.0lNwgDNxwyMyITOyEzW}'}
```

## Reaching Your LIMITs

```python
#!/opt/pwn.college/python

import sys
import string
import random
import sqlite3
import tempfile


# Don't panic about the TemporaryDB class. It simply implements a temporary database
# in which this application can store data. You don't need to understand its internals,
# just that it processes SQL queries using db.execute().
class TemporaryDB:
    def __init__(self):
        self.db_file = tempfile.NamedTemporaryFile("x", suffix=".db")

    def execute(self, sql, parameters=()):
        connection = sqlite3.connect(self.db_file.name)
        connection.row_factory = sqlite3.Row
        cursor = connection.cursor()
        result = cursor.execute(sql, parameters)
        connection.commit()
        return result


db = TemporaryDB()


def random_word(length):
    return "".join(random.sample(string.ascii_letters * 10, length))


flag = open("/flag").read().strip()

# https://www.sqlite.org/lang_createtable.html
db.execute("""CREATE TABLE logs AS SELECT ? as text""", [random_word(len(flag))])
# https://www.sqlite.org/lang_insert.html
for i in range(random.randrange(5, 42)):
    db.execute("""INSERT INTO logs VALUES(?)""", [random_word(len(flag))])
db.execute("""INSERT INTO logs VALUES(?)""", [flag])

for i in range(random.randrange(5, 21)):
    db.execute("""INSERT INTO logs VALUES(?)""", [random_word(len(flag))])
for i in range(random.randrange(5, 21)):
    db.execute("""INSERT INTO logs VALUES(?)""", ["pwn.college{" + random_word(len(flag) - len("pwn.college{}")) + "}"])

for i in range(random.randrange(5, 42)):
    db.execute("""INSERT INTO logs VALUES(?)""", [random_word(len(flag))])

# HINT: https://www.sqlite.org/lang_select.html#limitoffset
for _ in range(1):
    query = input("sql> ")

    try:
        results = db.execute(query).fetchall()
    except sqlite3.Error as e:
        print("SQL ERROR:", e)
        sys.exit(1)

    if len(results) == 0:
        print("No results returned!")
        sys.exit(0)

    if len(results) > 1:
        print("You're not allowed to read this many rows!")
        sys.exit(1)
    if len(results[0].keys()) > 1:
        print("You're not allowed to read this many columns!")
        sys.exit(1)
    print(f"Got {len(results)} rows.")
    for row in results:
        print(f"- { { k:row[k] for k in row.keys() } }")
```

```
hacker@sql-playground~reaching-your-limits:~$ /challenge/sql 
sql> SELECT text FROM logs WHERE substr(text, 1, 12) = 'pwn.college{' LIMIT 1;
Got 1 rows.
- {'text': 'pwn.college{cEHuwUJeUR_tFikgXjlnibhNa6m.01NwgDNxwyMyITOyEzW}'}
```

## Querying Metadata

```python
#!/opt/pwn.college/python

import sys
import string
import random
import sqlite3
import tempfile


# Don't panic about the TemporaryDB class. It simply implements a temporary database
# in which this application can store data. You don't need to understand its internals,
# just that it processes SQL queries using db.execute().
class TemporaryDB:
    def __init__(self):
        self.db_file = tempfile.NamedTemporaryFile("x", suffix=".db")

    def execute(self, sql, parameters=()):
        connection = sqlite3.connect(self.db_file.name)
        connection.row_factory = sqlite3.Row
        cursor = connection.cursor()
        result = cursor.execute(sql, parameters)
        connection.commit()
        return result


db = TemporaryDB()

table_name = "".join(random.sample(string.ascii_letters, 8))
db.execute(f"""CREATE TABLE {table_name} AS SELECT ? as detail""", [open("/flag").read().strip()])

# HINT: https://www.sqlite.org/schematab.html
for _ in range(2):
    query = input("sql> ")

    try:
        results = db.execute(query).fetchall()
    except sqlite3.Error as e:
        print("SQL ERROR:", e)
        sys.exit(1)

    if len(results) == 0:
        print("No results returned!")
        sys.exit(0)

    if len(results[0].keys()) > 1:
        print("You're not allowed to read this many columns!")
        sys.exit(1)
    print(f"Got {len(results)} rows.")
    for row in results:
        print(f"- { { k:row[k] for k in row.keys() } }")
```

```
hacker@sql-playground~querying-metadata:~$ /challenge/sql 
sql> SELECT tbl_name FROM sqlite_master;
Got 1 rows.
- {'tbl_name': 'nsHhXTAt'}
sql> SELECT detail FROM nsHhXTAt;
Got 1 rows.
- {'detail': 'pwn.college{QcRepg-ydQPcZ1WMPF2kYiB5Nl8.0FOwgDNxwyMyITOyEzW}'}
```

