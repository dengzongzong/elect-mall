import bcrypt

# 从init.sql获取的哈希值
hash_from_sql = b'$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH'

# 尝试常见密码
passwords = [
    'admin123',
    'admin',
    '123456',
    'password',
    'admin@123',
    'admin123456',
    'root',
    '1234',
]

for pwd in passwords:
    print(f"Testing: '{pwd}'")
    try:
        result = bcrypt.checkpw(pwd.encode(), hash_from_sql)
        if result:
            print(f"!!! MATCH FOUND: Password is '{pwd}'")
        else:
            print(f"  NO match")
    except Exception as e:
        print(f"  ERROR: {e}")
print("\nDone.")