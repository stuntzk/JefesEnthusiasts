from flask import Blueprint, request, jsonify, make_response
import json
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

@customers.route("/product/ingr/form")
def get_prodIngr_form():
    return """
    <h2>New Ingredient</h2>
    <form action="/cust/product/ingr/form" method="POST">
    <label for="ingrId">IngredientId:</label><br>
    <input type="text" id="ingrId" name="ingrId" value=""><br>
    <label for="quantity">Quantity:</label><br>
    <input type="text" id="quantity" name="quantity" value=""><br>
    <input type="submit" value="Submit">
    </form> 
    """

@customers.route("/product/ingr/form", methods = ['POST'])
def post_prodIngr_form():
    ingr_id = request.form['ingrId']
    quant = request.form['quantity']
    cursor = db.get_db().cursor()
    cursor.execute('select max(ProductId) from Product')
    all = cursor.fetchall()
    for row in all:
        data = row[0]
    data = data + 1
    return f'<h1>IngrId: {ingr_id} Quantity: {quant} ProductId: {data}</h1>'




