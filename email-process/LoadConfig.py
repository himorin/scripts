#! /usr/bin/env python3

import sys
import json

DEF_CONF_NAME = "./config.json"

def LoadConfig():
  try:
    fjson = open(DEF_CONF_NAME, 'r')
  except IOError as e:
    raise Exception("File '%s' open error: %s" % (DEF_CONF_NAME, e))
  try:
    site_config = json.load(fjson)
  except:
    raise Exception("json format parse error for '%s'" % (DEF_CONF_NAME))
  return site_config

