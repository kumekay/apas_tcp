require "socket"
s = TCPSocket.open("163.172.137.48", 4040)
ready = s.gets(5)
puts ready

while true
    s.print "AT_pour_amb=100;"
    sleep 1
    s.print "AT_bottle_changed=1;"
    sleep 1
end
s.close
