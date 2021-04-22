import os
import configparser
import time

config = configparser.ConfigParser()
config.read("code/plots/ihc_config.cfg")

def get_config_parameter(key):
    return config.get('IHC', key)