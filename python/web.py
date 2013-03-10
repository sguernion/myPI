#!/usr/bin/env python
import SimpleHTTPServer
import SocketServer
import time
import os
import mimetypes
import json
import bluetooth

port = 8081
host = '192.168.0.17'

class MyRequestHandler(SimpleHTTPServer.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
             self.path = '/webapp/index.html'
        elif self.path.startswith('/static'):
             return do_static(self, self.path)
        elif self.path.startswith('/redirect/'):
             return do_getRedirect(self)
        elif self.path == '/scan':
             return do_scanDevice(self)
        elif self.path == '/redirections':
             return json_file(self,'/webapp/conf/redirections.conf')
        else:
             self.path = '/webapp/index.html'
        return SimpleHTTPServer.SimpleHTTPRequestHandler.do_GET(self)


def do_scanDevice(self):
     data = '{"devices":['
     nearby_devices = bluetooth.discover_devices(lookup_names = True, flush_cache = True, duration = 20)
     print "found %d devices" % len(nearby_devices)
     for addr, name in nearby_devices:
         data+= '{"name":"'+name+'","mac":"'+addr+'"'
         #data+= ',"services":['
         #for services in bluetooth.find_service(address = addr):
         #    data+= '{"name":"'+str(services["name"])+'","description":"'+str(services["description"])+'"'
         #    data+=',"provider":"'+str(services["provider"])+',"protocol":"'+str(services["protocol"])+'"'
         #    data+=',"port":"'+str(services["port"])+',"service-id":"'+str(services["service-id"])+'"}'
         data+= '}'
     data += ']}'
     self.send_response(200)
     self.send_header('Content-Type', 'application/json')
     self.end_headers()
     self.wfile.write(data)
     return

def json_file(self,filename='/webapp/conf/redirections.conf'):
     cwd = os.path.abspath('.')
     f = open(cwd + filename)
     self.send_response(200)
     self.send_header('Content-Type', 'application/json')
     self.end_headers()
     self.wfile.write(f.read())
     f.close()
     return
     
def do_getRedirect(self):
     cwd = os.path.abspath('.')
     f = open(cwd + '/webapp/redirections.conf')
     data = json.loads(f.read())
     for i, val in enumerate(data['redirections']):
         #print '---'
         #for key, value in data['redirections'][i].items():
         #    print key, value
         if self.path == '/redirect/'+data['redirections'][i]['path']:
          url = data['redirections'][i]['url']
          do_redirect(self,url )
          f.close()
          return
     return

def do_redirect(self, path="/webapp/index.html"):
    self.send_response(301)
    self.send_header('Location', path)
    self.end_headers()

def do_static(self, path="/static"):
    try:
        if self.path.startswith("/static"):
            cwd = os.path.abspath('.')
            #print 'current dir :'+cwd
            #print 'path :'+self.path
            #print ''
            f = open(cwd + '/webapp' + self.path) #self.path has /test.html
            #note that this potentially makes every file on your computer readable by the internet
            self.send_response(200)
            mimetype, _ = mimetypes.guess_type(cwd + '/webapp' + self.path)
            self.send_header('Content-type',mimetype)
            self.end_headers()
            self.wfile.write(f.read())
            f.close()
            return
    except IOError:
        self.send_error(404,'File Not Found: %s' % self.path)

         
         
Handler = MyRequestHandler
server = SocketServer.TCPServer((host, port), Handler)
print time.asctime(),'Server Start on '+host+':'+str(port)
try:
    server.serve_forever(10)
except KeyboardInterrupt:
    pass
server.socket.close()
server.server_close()
print time.asctime(), "Server Stops - %s:%s" % (host, port)