from flask import Blueprint, request, jsonify, make_response
import json
import random
from src import db



customers = Blueprint('customers', __name__)

# Get all customers from the DB
@customers.route('/all', methods=['GET'])
def get_customers():
    cursor = db.get_db().cursor()
    cursor.execute('select * from Customer')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get customer detail for customer with particular userID
@customers.route('/<custID>')
def get_customer(custID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from Customer where CustId = {0}'.format(custID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# adds a product into the database after the user has it. All of the product ingredients are added individuals
@customers.route("/product", methods = ['POST'])
def add_product():
    cursor = db.get_db().cursor()
    type = request.form['typeid']
    cursor.execute('select max(ProductId) from Product')
    prod = cursor.fetchone()[0] + 1
    query = f'SELECT BasePrice FROM FoodType where TypeId = {type}'
    cursor.execute(query)
    price = cursor.fetchone()[0]
    ingrs = request.form['ingrs']
    ingrLen = len(ingrs)
    newIngr = ingrs[1: ingrLen - 1]
    arr = newIngr.split(',')
    for x in arr:
        query = f'SELECT Upcharge FROM Ingredient where IngrId = {x}'
        cursor.execute(query)
        price = price + cursor.fetchone()[0]
    cursor.execute('select max(OrderId) from Orders')
    order = request.form['orderNum']
    query = f'INSERT INTO Product(ProductId, Price, OrderId, TypeId) VALUES ({prod}, {price}, {order}, {type})'
    cursor.execute(query)
    db.get_db().commit()
    for x in arr:
        query = f'INSERT INTO ProductIngredient(ProductId, IngredientId, Quantity) VALUES ({prod}, {x}, 1)'
        cursor.execute(query)
        db.get_db().commit()
    return f'{price}'

# completes the proper steps after the user places submit on the order (updates the order to have the proper information)
@customers.route('/submit', methods = ['POST'])
def update_order():
    cursor = db.get_db().cursor()
    s = request.form['store']
    store = int(s)
    cursor.execute('select max(OrderId) from Orders')
    o = cursor.fetchone()[0]
    query = f'select sum(Price) from Product where OrderId = {o}'
    cursor.execute(query)
    price = cursor.fetchone()[0]
    db_update_order(store, price, o)
    return 'succes'

# updates the information for each order after the user presses submit
def db_update_order(store, price, orderId):
    cursor = db.get_db().cursor()
    minutes = random.randint(2,40)
    seconds = random.randint(0,59)
    cookTime = f'00:{minutes}:{seconds}'
    cursor.execute(f'UPDATE Orders SET StoreId = {store}, TotalPrice = {price}, OrderDate = now(), TimeOrdered = now(), TimeCompleted = now(), TimeToMake = time(0) WHERE OrderId = {orderId}')
    db.get_db().commit()
    return "hi"

# determines all the orders a single customer has placed
@customers.route('/orders/<custId>', methods=['GET'])
def get_orders(custId):
    cursor = db.get_db().cursor()
    cursor.execute('select OrderId, StoreId, TotalPrice, OrderDate from Orders where CustomerId = {0}'.format(custId))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# creates a list of all the products
@customers.route('/product/all', methods=['GET'])
def get_prod():
    cursor = db.get_db().cursor()
    cursor.execute('select ProductId from Product')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# determines what the highest order so far is
@customers.route('/maxOrder', methods =['GET'])
def get_max():
    cursor = db.get_db().cursor()
    cursor.execute('select max(OrderId) from Orders')
    order = cursor.fetchone()[0] + 1
    return f'{order}'

# adds a new order into the system
@customers.route('/newOrder', methods =['POST'])
def new_order():
    cursor = db.get_db().cursor()
    cust = request.form['custId']
    order = request.form['orderId']
    query = f'INSERT INTO Orders(OrderId, CustomerId) VALUES ({order}, {cust})'
    cursor.execute(query)
    db.get_db().commit()
    return "hi"

# Get all the products from the database
@customers.route('/types', methods=['GET'])
def get_foodTypes():
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of products
    cursor.execute('select * from FoodType')

    # grab the column headers from the returned data
    column_headers = [x[0] for x in cursor.description]

    # create an empty dictionary object to use in
    # putting column headers together with data
    json_data = []

    # fetch all the data from the cursor
    theData = cursor.fetchall()

    # for each of the rows, zip the data elements together with
    # the column headers.
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)

# returns all the stores with their id and name
@customers.route('/storeNames', methods=['GET'])
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
@customers.route('/ingr/<storeID>', methods=['GET'])
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
@customers.route('/home/<storeID>', methods=['GET'])
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
@customers.route('/zip/<zipCode>', methods=['GET'])
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
