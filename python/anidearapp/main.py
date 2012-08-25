import webapp2
from ipcheck import *

class MainPage(webapp2.RequestHandler):
    def get(self):
		self.response.write('Hello World.\n')

app = webapp2.WSGIApplication([('/', MainPage),
                              ('/ipcheck(/.*)?', IpCheckPage)],
                              debug=True)