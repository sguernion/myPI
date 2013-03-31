#!/usr/bin/python

import SimpleHTTPServer
import SocketServer
import time
import os
import mimetypes
import json
import bluetooth
from utils.spell import Voice

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
             return do_scanDevice(self,20)
        elif self.path.startswith('/scanServices'):
             return find_services(self.path.replace('/scanServices/',''))
        elif self.path == '/redirections':
             return serve_json(self,json_file('/webapp/conf/redirections.conf'))
        else:
             self.path = '/webapp/index.html'
        return SimpleHTTPServer.SimpleHTTPRequestHandler.do_GET(self)
    def do_POST(self):
        if self.path.startswith('/voice'):
             voice = Voice()   
             phrase = self.path.replace('/voice/','').replace('%20',' ')
             print phrase
             voice.spell(' '+phrase)
        self.path = '/webapp/index.html'
        return SimpleHTTPServer.SimpleHTTPRequestHandler.do_GET(self)



def do_scanDevice(self,duree=20):
     data = '{"devices":['
     nearby_devices = bluetooth.discover_devices(lookup_names = True, flush_cache = True, duration = duree)
     for addr, name in nearby_devices:
         data+= '{"name":"'+name+'","mac":"'+addr+'"'
         data+= ',"services":'+find_services(addr)
         data+= '}'
     data += ']}'
     serve_json(self,data)
     return

def find_services(addr):
     data ='['
     for services in bluetooth.find_service(address = addr):
         data+= '{"name":"'+str(services["name"])+'","description":"'+str(services["description"])+'"'
         data+=',"provider":"'+str(services["provider"])+',"protocol":"'+str(services["protocol"])+'"'
         data+=',"port":"'+str(services["port"])+',"service-id":"'+str(services["service-id"])+'"}'
     data+=']'
     return data

def json_file(filename='/webapp/conf/redirections.conf'):
     cwd = os.path.abspath('.')
     f = open(cwd + filename)
     data = f.read()
     f.close()
     return data

def serve_json(self,data='{}'): 
     self.send_response(200)
     self.send_header('Content-Type', 'application/json')
     self.end_headers()
     self.wfile.write(data)
     return
     
def do_getRedirect(self):
     data = json.loads(json_file('/webapp/conf/redirections.conf'))
     for i, val in enumerate(data['redirections']):
         if self.path == '/redirect/'+data['redirections'][i]['path']:
             url = data['redirections'][i]['url']
             do_redirect(self,url )
             return
     return

def do_redirect(self, path="/webapp/index.html"):
    self.send_response(301)
    self.send_header('Location', path)
    self.end_headers()

def do_static(self, path="/static"):
    try:
        if self.path.startswith("/static") and  '../' not in self.path:
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
print 'start bluetooth'
os.system('sudo service bluetooth start')
print 'enable audio'
os.system('sudo modprobe snd-bcm2835')
os.system('sudo amixer cset numid=3 1')
os.system('amixer cset numid=3 -- 60%')
print time.asctime(),'Server Start on '+host+':'+str(port)
try:
    server.serve_forever(10)
except KeyboardInterrupt:
    pass
server.socket.close()
server.server_close()
print time.asctime(), "Server Stops - %s:%s" % (host, port)