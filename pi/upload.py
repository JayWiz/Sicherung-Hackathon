import thingspeak
import time
import mysql.connector as mariadb
 


mariadb_connection = mariadb.connect(user='root', password='root', host='localhost', port='3306', database='raspberry_database')
cursor = mariadb_connection.cursor()
sqlSelect = ("""SELECT * FROM temperatureSensor;""")


channel_id = 480334 # PUT CHANNEL ID HERE
write_key ='VNP47TG4MG3HMAXR' # PUT YOUR WRITE KEY HERE
read_key   = 'V4KXVGQDTMG2WKZ7' # PUT YOUR READ KEY HERE
dataTemp = -1
dataDruck = -1
dataVent = -1
	
def getPotent():
	try:
		#getdata
		mariadb_connection.commit()
		cursor.execute("SELECT * FROM potentiometerSensor WHERE ID= (SELECT MAX(ID) FROM potentiometerSensor);")
 		result = cursor.fetchall()
		for row in result:
			print row[0], row[1]
			potentData = row[2]
			print potentData
	except Exception as e:
		print str(e)
		print("error")
	
	return potentData
    
def getTemp():
	try:
		#getdata
		mariadb_connection.commit()
		cursor.execute("SELECT * FROM temperatureSensor WHERE ID= (SELECT MAX(ID) FROM temperatureSensor);")
 		result = cursor.fetchall()
		for row in result:
			print row[0], row[1]
			testdata = row[2]
	except Exception as e:
		print str(e)
		print("error")
	
	return testdata
                       
def measure(channel):
    try:
        # write
        potentData = getPotent()
        tempData = getTemp()
        print tempData
        print potentData
        response = channel.update({'field1': tempData, 'field2': potentData})
        print response
        # read
        read = channel.get({})
        
        
    except:
        print("connection failed")
                 
if __name__ == "__main__":
	channel = thingspeak.Channel(id=channel_id, write_key=write_key, api_key=read_key)
	while True:
    		measure(channel)
       	 # free account has an api limit of 15sec
		time.sleep(15)


