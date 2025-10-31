#! /usr/bin/env python3

import sys
from LoadConfig import LoadConfig
from email.parser import Parser
from email.policy import default
from email.message import EmailMessage
import requests

DEF_SCRIPTNAME = "email-issue"

def ParseEmail(fp):
  msg = Parser(policy=default).parse(fp)
  ret = {}
  ret['from'] = msg['From']
  ret['date'] = msg['Date']
  ret['subject'] = msg['Subject']
  if msg.is_multipart():
    for part in msg.iter_parts():
      ctype = part.get_content_type()
      cdispo = str(part.get("Content-Disposition"))
      if ctype == 'text/plain' and 'attachment' not in cdispo:
        ret['body'] = part.get_payload(decode=True).decode(part.get_content_charset() or 'utf-8', errors='replace')
        break
  else:
    ret['body'] = msg.get_payload(decode=True).decode(msg.get_content_charset() or 'utf-8', errors='replace')
  return ret

def OpenIssue(conf, msg):
  cses = requests.Session()
  chead = {
    "Accept": "application/vnd.github+json",
    "Authorization": "Bearer %s" % (conf['key']),
    "X-GitHub-Api-Version": "2022-11-28"
  }
  cdat = {
    "title": msg['subject'],
    "body": "From: %s\nDate: %s\n\n%s" % (msg['from'], msg['date'], msg['body'])
  }
  curl = "https://api.github.com/repos/%s/issues" % (conf['target'])
  ret = cses.post(curl, headers = chead, json = cdat)
  return ret

if __name__ == "__main__":
  config = LoadConfig()
  cname = sys.argv[0].split('/')[-1]
  if cname[-3] == '.py':
    cname = cname[0:-3]
  ctgt = DEF_SCRIPTNAME + '-' + cname
  if ctgt not in config:
    raise Exception("config item '%s' not found" % (ctgt))
  ccnf = config[ctgt]
  msg = ParseEmail(sys.stdin)
  res = OpenIssue(ccnf, msg)
