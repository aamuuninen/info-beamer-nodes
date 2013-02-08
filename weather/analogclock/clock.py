import socket, datetime

now = datetime.datetime.now()

since_midnight = (
    now - 
    now.replace(hour=0, minute=0, second=0)
).seconds
datastring = 'weather/analogclock/clock/set:'+str(since_midnight)
data = bytes(datastring, 'utf-8')
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.sendto(data ,('127.0.0.1',4444))
