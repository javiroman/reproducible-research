#!/usr/bin/python

"""A skeleton for a python rsyslog output plugin
   Copyright (C) 2014 by Adiscon GmbH

   This file is part of rsyslog.
  
   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at
   
         http://www.apache.org/licenses/LICENSE-2.0
         -or-
         see COPYING.ASL20 in the source distribution
   
   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
"""

import sys
import select
import requests
import json

# skeleton config parameters
pollPeriod = 0.75 # the number of seconds between polling for new messages
maxAtOnce = 1024  # max nbr of messages that are processed within one batch

# App logic global variables
httpServer = "http://flume-tier1.cloudapps.redhat.lan:80"

def onInit():
	""" Do everything that is needed to initialize processing (e.g.
	    open files, create handles, connect to systems...)
	"""
	print "onInit"

def onReceive(msgs):
	"""This is the entry point where actual work needs to be done. It receives
	   a list with all messages pulled from rsyslog. The list is of variable
	   length, but contains all messages that are currently available. It is
	   suggest NOT to use any further buffering, as we do not know when the
	   next message will arrive. It may be in a nanosecond from now, but it
	   may also be in three hours...
	"""
	headers = {'Content-type': 'application/json;charset=utf-8'}
	for i in msgs:
		payload = [{"headers": {"a":"b", "c":"d"},"body": i}]
		r = requests.post(httpServer, data=json.dumps(payload), headers=headers)
		if (r.status_code <> 200):
			print "Error status code"

def onExit():
	""" Do everything that is needed to finish processing (e.g.
	    close files, handles, disconnect from systems...). This is
	    being called immediately before exiting.
	"""
	print "onExit"


"""
-------------------------------------------------------
This is plumbing that DOES NOT need to be CHANGED
-------------------------------------------------------
Implementor's note: Python seems to very agressively
buffer stdouot. The end result was that rsyslog does not
receive the script's messages in a timely manner (sometimes
even never, probably due to races). To prevent this, we
flush stdout after we have done processing. This is especially
important once we get to the point where the plugin does
two-way conversations with rsyslog. Do NOT change this!
See also: https://github.com/rsyslog/rsyslog/issues/22
"""
onInit()
keepRunning = 1
while keepRunning == 1:
	while keepRunning and sys.stdin in select.select([sys.stdin], [], [], pollPeriod)[0]:
		msgs = []
	        msgsInBatch = 0
		while keepRunning and sys.stdin in select.select([sys.stdin], [], [], 0)[0]:
			line = sys.stdin.readline()
			if line:
				msgs.append(line)
			else: # an empty line means stdin has been closed
				keepRunning = 0
			msgsInBatch = msgsInBatch + 1
			if msgsInBatch >= maxAtOnce:
				break;
		if len(msgs) > 0:
			onReceive(msgs)
			sys.stdout.flush() # very important, Python buffers far too much!
onExit()
