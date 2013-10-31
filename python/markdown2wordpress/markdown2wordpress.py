#! /usr/bin/python

# Credit: 
# original code from: http://parezcoydigo.wordpress.com/2011/05/25/post-to-wordpress-com-with-markdown-6/
# XML-RPC API: http://codex.wordpress.org/XML-RPC_MetaWeblog_API

# for the required library: run the below command
# sudo pip install xmlrpclib pyyaml markdown

import xmlrpclib
import yaml
import re
import sys
import markdown

RE_YAML = re.compile(r'(^---\s*$(?P<yaml>.*?)^---\s*$)?(?P<content>.*)',
    re.M | re.S)
postFile = open(sys.argv[1], 'r').read()
postFile = postFile.decode('utf-8')
fileInfo = RE_YAML.match(postFile)
headers = fileInfo.groupdict().get('yaml').replace("\t",' ')
getYAML = yaml.load(headers)
postMD = fileInfo.groupdict().get('content')

newPost = markdown.markdown(postMD, extentions=['footnotes', 'codehilite'])
blogurl = 'https://localhost/xmlrpc.php'
username = ''
password = ''
server = xmlrpclib.ServerProxy(blogurl, allow_none=True)

status = '1'
data = {}
data['title'] = getYAML['title']
data['description'] = newPost
data['categories'] = [getYAML['category']]
data['mt_keywords'] = getYAML['tags']

# create permalink
filename = "-".join(sys.argv[1].split("/")[-1].split("-")[3:]).replace(".md","")
if getYAML['subcategory']==None:
    permalink = '{}/{}/{}/{}/{}'.format(
        getYAML['country'],
        getYAML['lang'],
        getYAML['category'],
        getYAML['product'],
        filename)
else:
    permalink = '{}/{}/{}/{}/{}/{}'.format(
        getYAML['country'],
        getYAML['lang'],
        getYAML['category'],
        getYAML['product'],
        getYAML['subcategory'],
        filename)

data['custom_fields'] = [ { 'key' : 'custom_permalink', 'value' : permalink } ]
post_id = server.metaWeblog.newPost('' , username, password, data, status)
print "Created id - %s" %post_id
print permalink


