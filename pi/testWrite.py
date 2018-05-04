import mysql.connector as mariadb

mariadb_connection = mariadb.connect(user='root', password='root', host='localhost', port='3306', database='raspberry_database')
cursor = mariadb_connection.cursor()




sqlSelect = ("""SELECT * from temperatureSensor;""")

try:
	cursor.execute("INSERT INTO temperatureSensor(time, temp) VALUES ('2018-06-18 15:18:06 AM', 5.24);")
	mariadb_connection.commit()
	print "INSERT PASS"
except:
	mariadb_connection.rollback()
	print "INSERT Failed"


try:
	cursor.execute("SELECT * from temperatureSensor WHERE ID = (SELECT MAX(ID) FROM temperatureSensor);")
	result = cursor.fetchall()
	for row in result:
		print row[0], row[1]	
	print "SELECT PASSED"
except:
	print "SELECT FAILED"
	
mariadb_connection.close()

