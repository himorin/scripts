#! /usr/bin/env python3

import sys
from LoadConfig import LoadConfig
from email.parser import Parser
from email.policy import default
from email.message import EmailMessage
import requests

DEF_SCRIPTNAME = "email-issue"

def CheckPart(part):
  ctype = part.get_content_type()
  cdispo = str(part.get("Content-Disposition"))
  if ctype == 'text/plain' and 'attachment' not in cdispo:
    return part.get_payload(decode=True).decode(part.get_content_charset() or 'utf-8', errors='replace')
  elif ctype == 'multipart/mixed':
    # dealing with OpenPGP/MIME signed
    msg_op = Parser(policy=default).parsestr(part.as_bytes(unixfrom=True))
    for part_op in msg_op.iter_parts():
      ret = CheckPart(part_op)
      if ret is not None:
        return ret
  return None

def ParseEmail(fp):
  msg = Parser(policy=default).parse(fp)
  ret = {}
  ret['from'] = msg['From']
  ret['date'] = msg['Date']
  ret['subject'] = msg['Subject']
  ret['body'] = ''
  if msg.is_multipart():
    for part in msg.iter_parts():
      retbd = CheckPart(part)
      if retbd is not None:
        ret['body'] = retbd
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
  caname = sys.argv[0].split('/')
  if len(caname) != 1:
    cdir = '/'.join(caname[:-1]) + '/'
  else:
    cdir = './'
  cname = caname[-1]
  config = LoadConfig(cdir)
  if cname[-3] == '.py':
    cname = cname[0:-3]
  ctgt = DEF_SCRIPTNAME + '-' + cname
  if ctgt not in config:
    raise Exception("config item '%s' not found" % (ctgt))
  ccnf = config[ctgt]
  msg = ParseEmail(sys.stdin)
  res = OpenIssue(ccnf, msg)
