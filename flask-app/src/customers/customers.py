from flask import Blueprint, request, jsonify, make_response
import json
import random
from src import db



customers = Blueprint('customers', __name__)


# Get customer details for customer with particular userID
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
    return "partial order in system"

# Get all the food types from the database
@customers.route('/types', methods=['GET'])
def get_foodTypes():
    cursor = db.get_db().cursor()
    cursor.execute('select * from FoodType')
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
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

# allows for the user to add a product into the database through the order form in the appsmith application. during
# this process, all the product ingredients are also ordered
@customers.route("/product", methods = ['POST'])
def add_product():
    cursor = db.get_db().cursor()
    type = request.form['typeid']
    # increase the product id by 1
    cursor.execute('select max(ProductId) from Product')
    prod = cursor.fetchone()[0] + 1
    # determines the price of the product
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
    # adds the product into the database
    query = f'INSERT INTO Product(ProductId, Price, OrderId, TypeId) VALUES ({prod}, {price}, {order}, {type})'
    cursor.execute(query)
    db.get_db().commit()
    # adds all the product ingredients into the database
    for x in arr:
        query = f'INSERT INTO ProductIngredient(ProductId, IngredientId, Quantity) VALUES ({prod}, {x}, 1)'
        cursor.execute(query)
        db.get_db().commit()
    return arr

# completes the proper steps after the user places submit on the order
# (updates the order to have the proper information)
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
    cursor.execute(f'UPDATE Orders SET StoreId = {store}, TotalPrice = {price}, OrderDate = now(), TimeOrdered = now(), TimeCompleted = now(), TimeToMake = time(0) WHERE OrderId = {orderId}')
    db.get_db().commit()
    return "updated"


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


# creates a list of all the products with the current orderId
@customers.route('/product/<ord>', methods=['GET'])
def get_order_prod(ord):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT TypeName, Price, ProductId FROM Product NATURAL JOIN FoodType WHERE OrderId = {0}'.format(ord))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# creates a list of all the ingredients with the current productId
@customers.route('/product/ingr/<prodId>', methods=['GET'])
def get_prod_ingr(prodId):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT IngrName, Quantity, Upcharge FROM ProductIngredient pi JOIN Ingredient i on pi.IngredientId = i.IngrId WHERE ProductId = {0}'.format(prodId))
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
