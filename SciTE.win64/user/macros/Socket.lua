--go@ dofile $(FilePath)
-- ^^tell Scite to use its internal Lua interpreter.
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local socket = require "socket"
-- library provides 
-- "_VERSION", "_DEBUG", "gettime", "newtry", "protect", "select", "sink", "skip", "sleep", "source", "try" "auxiliar", "except", "timeout", "buffer","inet"
-- socket.dns: "dns.toip", "dns.tohostname", "dns.gethostname"
-- socket.tcp: "tcp.accept", "tcp.bind", "tcp.close", "tcp.connect", "tcp.getpeername","tcp.getstats", "tcp.recieve", "tcp.send", "tcp.setoption", "tcp.setstats", "tcp.settimeout", "tcp.shutdown"
-- socket.udp: "udp.close", "udp.getpeername", "udp.getsockname", "udp.receive", "udp.receivefrom", "udp.send", "udp.sendto", "udp.setpeername", "udp.setsockname", "udp.setoption", "udp.settimeout" 
-- socket.lua layer provides "connect4", "connect6", "bind"
    
print("Hello from " .. socket._VERSION .."!")

print("Test -  UDP socket 5088")
local u = socket.udp() assert(u:setsockname("*", 5088)) u:close()
local u = socket.udp() assert(u:setsockname("*", 0)) u:close()
print("Test -  TCP socket 5088")
local t = socket.tcp() assert(t:bind("*", 5088)) t:close()
local t = socket.tcp() assert(t:bind("*", 0)) t:close()
print("done!")

print ("Test - DNS_Query -> www.sourceforge.net")
local addresses = assert(socket.dns.getaddrinfo("www.sourceforge.net"))
local ipv4mask = "^%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?$"

for i, alt in ipairs(addresses) do
  if alt.family == 'inet' then
    assert(type(alt.addr) == 'string')
    assert(alt.addr:find(ipv4mask))
    --assert(alt.addr == '127.0.0.1')
	 print (alt.family,alt.addr)
  end
end

print("done!")