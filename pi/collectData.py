from socket import *
import time
import datetime
from time import strftime
import mysql.connector as mariadb

# SQL Init
mariadb_connection = mariadb.connect(user='root', password='root', host='localhost', port='3306', database='raspberry_database')
cursor = mariadb_connection.cursor()

# Ethernet init
try: 
	# Temperatur Sensor
	sensor_address_temp = ('192.168.254.101', 5001)
	client_socket_temp = socket(AF_INET, SOCK_DGRAM)
	client_socket_temp.settimeout(5)
	# Potentiometer Sensor
	sensor_address_poti = ('192.168.254.102', 5002)
	client_socket_poti = socket(AF_INET, SOCK_DGRAM)
	client_socket_poti.settimeout(5)
	# Motor Aktor
	aktor_address_motor = ('192.168.254.103', 5003)
	client_socket_motor = socket(AF_INET, SOCK_DGRAM)
	client_socket_motor.settimeout(5)

except Exception as e:
	s = str(e)
	print s
print "Sensor init done"

def uploadTemperatureToSQL(datetime, temperature):
    cursor.execute("""INSERT INTO temperatureSensor(time, temp) VALUES (%s, %s);""", (datetime, temperature))
    mariadb_connection.commit()
    return 0


def uploadPotentiometerToSQL(datetime, potentiometer):
	cursor.execute("""INSERT INTO potentiometerSensor(time, poti) VALUES (%s, %s);""", (datetime, potentiometer))
	mariadb_connection.commit()
	return 0

def getDateTimeString():
        try:
                dateTimeStr = (time.strftime("%Y-%m-%d ") + time.strftime("%H:%M:%S %p"))
        except Exception as e:
                s = str(e)
                print s
        return dateTimeStr

def getMotorValue():
	try:
		f = open("/var/www/html/aslan.txt")
		ints = []
		for val in f.read().split():
			ints.append(int(val))
		f.close()
		numberString = "%03d" % ints[0]
	except Exception as e:
		s = str(e)
		print s
	return numberString

while(1):

	data = "Temperature"
	client_socket_temp.sendto(data, sensor_address_temp)
	time.sleep(0.1)
	try:
		rec_data, addr = client_socket_temp.recvfrom(2048)
		temp = float(rec_data)
		print "Temperature: ", temp, "C"
		uploadTemperatureToSQL(getDateTimeString(), temp)
	except Exception as e:
		s = str(e)
		print s
	time.sleep(0.1)

	data = "Potentiometer"
	client_socket_poti.sendto(data, sensor_address_poti)
	time.sleep(0.1)
	try:
		rec_data, addr = client_socket_poti.recvfrom(2048)
		poti = float(rec_data)
		print "Potentiometer: ", poti, "cm"
		uploadPotentiometerToSQL(getDateTimeString(), poti)
	except Exception as e:
		s = str(e)
		print s
	time.sleep(0.1)
	
	data =  getMotorValue() + "Motor"
	client_socket_motor.sendto(data, aktor_address_motor)
	time.sleep(0.1)
	try:
		rec_data, addr = client_socket_motor.recvfrom(2048)
		result = rec_data
		print "Motor set: ", result
	except Exception as e:
		s = str(e)
		print s
	time.sleep(0.1)

	print ""
	


	
