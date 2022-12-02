from flask import Blueprint, request, jsonify, make_response
import json
from src import db


stores = Blueprint('stores', __name__)

# returns all the stores with their id and name
@stores.route('/storeNames', methods=['GET'])
def get_storeNames():
    cursor = db.get_db().cursor()
    cursor.execute('select StoreId, StoreName from Store')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# returns the ingredients available at the store asked
@stores.route('/ingr/<storeID>', methods=['GET'])
def get_ingredients(storeID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from Ingredient where CurrQuantity > 0 and StoreId = {0}'.format(storeID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# returns the store name with the specific storeID
@stores.route('/<storeID>', methods=['GET'])
def get_store(storeID):
    cursor = db.get_db().cursor()
    cursor.execute('select StoreName from Store where StoreId = {0}'.format(storeID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# returns the stores that are in this zip code
@stores.route('/zip/<zipCode>', methods=['GET'])
def get_storeInZip(zipCode):
    cursor = db.get_db().cursor()
    cursor.execute('select StoreName, StoreStreet, StoreCity, StoreState, StoreZip from Store where StoreZip = {0}'.format(zipCode))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response