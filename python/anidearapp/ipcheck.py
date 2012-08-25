import webapp2

class IpCheckPage(webapp2.RequestHandler):
    def get(self,param):
		self.response.headers['Content-Type'] = 'text/plain'
		if param is None:
			# print default (all) for none param
			if 'X-Forwarded-For' in self.request.headers:
				self.response.write('real_ip:'+self.request.headers['X-Forwarded-For'])
				self.response.write('(proxy_ip:'+self.request.remote_addr+')\n')
			else:
				self.response.write('real_ip:'+self.request.remote_addr+'\n')
					
			self.response.write('---------\n')
			for k, v in self.request.headers.items():
				self.response.write(k+':'+v+'\n')
		else:
			if param=='/ip':
				self.response.write(self.request.remote_addr)
			elif param=='/proxy' and 'X-Forwarded-For' in self.request.headers.keys():
				self.response.write(self.request.headers['X-Forwarded-For'])
			elif param=='/via' and 'Via' in self.request.headers.keys():
				self.response.write(self.request.headers['Via'])
			elif param=='/useragent' and 'User-Agent' in self.request.headers.keys():
				self.response.write(self.request.headers['User-Agent'])
			elif param[1:] in self.request.headers:
				self.response.write(self.request.headers[param[1:]])
			else:
				self.response.write('empty')
