import mysql.connector
import bcrypt

# Generate hash with $2a$ prefix (compatible with Java BCryptPasswordEncoder)
# bcrypt uses $2b$ by default, but $2a$ is also accepted
password = "admin123".encode()
hashed = bcrypt.hashpw(password, bcrypt.gensalt(rounds=10))

# Change $2b$ to $2a$ if needed (Java's BCryptPasswordEncoder expects $2a$)
hashed_str = hashed.decode().replace('$2b$', '$2a$')

print(f"Generated hash: {hashed_str}")

# Verify it works
try:
    conn = mysql.connector.connect(host='localhost', user='root', password='123456', database='mall_db')
    cursor = conn.cursor()
    
    # Check current admin
    cursor.execute("SELECT id, username, password, nickname FROM admin_user WHERE username = 'admin'")
    rows = cursor.fetchall()
    if rows:
        for row in rows:
            print(f"Current admin: id={row[0]}, username={row[1]}, password_start={row[2][:30]}..., nickname={row[3]}")
        
        # Update password
        cursor.execute("UPDATE admin_user SET password = %s WHERE username = 'admin'", (hashed_str,))
        conn.commit()
        print(f"✓ Password updated successfully! New hash: {hashed_str}")
    else:
        print("No admin user found in database")
        
        # Try inserting
        cursor.execute("""
            INSERT INTO admin_user (username, password, nickname, role, status, created_at, updated_at) 
            VALUES (%s, %s, %s, %s, %s, NOW(), NOW())
        """, ('admin', hashed_str, '系统管理员', 'ADMIN', 1))
        conn.commit()
        print("✓ Admin user created!")
    
    cursor.close()
    conn.close()
    
except Exception as e:
    print(f"Error: {e}")
    # Try to install mysql-connector
    print("Need to install mysql-connector-python")