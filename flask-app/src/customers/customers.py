from flask import Blueprint, request, jsonify, make_response
import json
import datetime
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
    order = cursor.fetchone()[0] + 1
    # need to have an order already created for this -- may make it with null values and then replace them upon submit
    cust = request.form['custId']
    query = f'INSERT INTO Orders(OrderId, CustomerId) VALUES ({order}, {cust})'
    cursor.execute(query)
    db.get_db().commit()
    query = f'INSERT INTO Product(ProductId, Price, OrderId, TypeId) VALUES ({prod}, {price}, {order}, {type})'
    cursor.execute(query)
    db.get_db().commit()
    for x in arr:
        query = f'INSERT INTO ProductIngredient(ProductId, IngredientId, Quantity) VALUES ({prod}, {x}, 1)'
        cursor.execute(query)
        db.get_db().commit()
    return f'{price}'

@customers.route('/submit', methods = ['POST'])
def update_order():
    cursor = db.get_db().cursor()
    store = request.form['store']
    cursor.execute('select max(OrderId) from Orders')
    order = cursor.fetchone()[0]
    query = f'select sum(Price) from Product where OrderId = {order}'
    cursor.execute(query)
    price = cursor.fetchone()[0]
    current = datetime.datetime.now()
    date = current.date()
    time = current.time()
    # update this to have the right time
    #query = f'UPDATE Orders SET StoreId = {store}, Price = {price}, OrderDate = {date}, TimeOrdered = {time} WHERE OrderId = {order}'
    #cursor.execute(query)
    #db.get_db().commit()
    return f'{date}, {time}'



@customers.route('/orders', methods=['GET'])
def get_orders():
    cursor = db.get_db().cursor()
    cursor.execute('select OrderId from Orders')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

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






