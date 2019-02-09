########################################################################
# Author:Sagar Chavan
# Elasticsearch Management Script to Create Index,
# List Indices, Delete Index, cleanup the Index data
# Usage: 
#1. To get list of indices 
#	python es_operation.py <get> 
#2. To create index 
#	python es_operation.py <create> <index_name> <doc_name>   
#3. To delete Index
#	python es_operation.py <delete> <index_name>
#4. To cleanup Index
#	python es_operation.py <cleanup> <index_name> <doc_name> <no_of_days>
#########################################################################

import datetime
from elasticsearch import Elasticsearch
import sys
from sys import argv
import json

ES = 'Your Elasticsearch URL'
 
data = {
	"settings": {
		"number_of_shards": 5,
		"number_of_replicas": 1
	},
	"mappings": {
		"doc_name": {
			"properties": {
				"timestamp": {
					"type": "date"
				}
			}
		}
	}
}

del_data = {
  "query":{
     "range":{
        "timestamp":{ "lt" : "dDateT00:00:00.281775"}
    }
  }
}


es = Elasticsearch([ES])

#Get index list 
def getIndexList():
	print ("List of available indices")
	for index in es.indices.get('*'):
		print (index)

#delete existing index			
def deleteIndex(INDEX_NAME, *args):
	if es.indices.exists(INDEX_NAME):
		print (INDEX_NAME + " exist")
		print("deleting '%s' index..." % (INDEX_NAME))
		res = es.indices.delete(index = INDEX_NAME)
	else :
		print (INDEX_NAME + " does not exist")

#Create new index if doesn't exist		
def createIndex(INDEX_NAME, DOC_TYPE, *args):
	if es.indices.exists(INDEX_NAME):
		print (INDEX_NAME + " exist")
	else:
		print("creating '%s' index..." % (INDEX_NAME))
		request_body = json.dumps(data).replace('doc_name', DOC_TYPE) #replace doc_name
		print (request_body)
		res = es.indices.create(index = INDEX_NAME, body = request_body)
		print(" response: '%s'" % (res))

def cleanupIndex(INDEX_NAME, DOC_TYPE, NO_OF_DAYS, *args):
	if es.indices.exists(INDEX_NAME):
		print (INDEX_NAME + " exist")
		TODAYS_DATE = datetime.date.today()
		ndays = int(NO_OF_DAYS)
		LAST_DATE = str(datetime.date.today() + datetime.timedelta(-ndays))
		request_body = json.dumps(del_data).replace('dDate', LAST_DATE) #replace doc_name
		print (request_body)
		result = es.delete_by_query(index = INDEX_NAME, doc_type = DOC_TYPE, body= request_body)
		print(" response: '%s'" % (result))
	else :
		print (INDEX_NAME + " does not exist")	


#Switch funtion for choice 
def switcherfun(choice):
	switch={'get':getIndexList,'create':createIndex, 'delete':deleteIndex, 'cleanup':cleanupIndex}
	switch[choice](*argv[2:])
  
if __name__ == "__main__":
	choice = str(sys.argv[1])
	switcherfun(choice)