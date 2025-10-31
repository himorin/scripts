#! /usr/bin/env python3

import sys
import json

DEF_CONF_NAME = "config.json"

def LoadConfig(dir):
  if dir is None:
    dir = "./"
  ccnf = dir + DEF_CONF_NAME
  try:
    fjson = open(ccnf, 'r')
  except IOError as e:
    raise Exception("File '%s' open error: %s" % (ccnf, e))
  try:
    site_config = json.load(fjson)
  except:
    raise Exception("json format parse error for '%s'" % (ccnf))
  return site_config

