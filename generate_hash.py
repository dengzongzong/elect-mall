import bcrypt

password = "admin123".encode()
salt = bcrypt.gensalt(rounds=10)
hashed = bcrypt.hashpw(password, salt)

print(f"Password: {password.decode()}")
print(f"Hashed: {hashed.decode()}")
print()

# Let me also test
print("Testing verification...")
if bcrypt.checkpw(password, hashed):
    print("✓ Verification successful")
else:
    print("✗ Verification failed")