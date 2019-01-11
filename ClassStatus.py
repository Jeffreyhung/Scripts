#!/usr/bin/python
# coding: utf-8

import requests
import webbrowser as wb
import time
import datetime

class_link = "https://psmobile.pitt.edu/app/catalog/classsection/UPITT/2194/27330"
headers = {'User-Agent' : 'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.6) Gecko/20091201 Firefox/3.5.6'} 

# print (r.text)
# print (str.find("<div>Closed</div>"))
print ("Checking for status of class 27330")

while True:
    r = requests.get(class_link, headers=headers)
    str1 = r.text
    search = str1.find("<div>Open</div>")
    if search != -1: #if class open, open the browser with the class page
        wb.open_new_tab(class_link)
        break;
    else : #if class closed, run chech again 60 seconds later
        print (datetime.datetime.now(), " Class closed")
        print ("Try again in 60 seconds")
        time.sleep(60)
