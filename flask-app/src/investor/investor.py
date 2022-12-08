from random import random

from flask import Blueprint, request, jsonify, make_response
import json
from src import db

investors = Blueprint('investors', __name__)


# returns all the investors with their id and name
@investors.route('/all', methods=['GET'])
def get_InvestorNames():
    cursor = db.get_db().cursor()
    cursor.execute('select InvId, FirstName from Investor')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# Get all investors from the DB
@investors.route('/allinvestors', methods=['GET'])
def get_customers():
    cursor = db.get_db().cursor()
    cursor.execute('select * from Investor')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Returns all the franchises by franchise ID
# 127.0.0.1:8001/investors/franchises
@investors.route('/franchises', methods=['GET'])
def get_franchises():
    cursor = db.get_db().cursor()
    cursor.execute('select FranchiseId, FranchiseName from Franchise')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# adds an investment into the database after the investor has it
@investors.route("/investment", methods = ['POST'])
def add_investment():
    cursor = db.get_db().cursor()
    stake = request.form['stake']
    franchid = request.form['franchid']
    query = f'INSERT INTO investments(stake, franchid) VALUES(\"{franchid}", \"{stake}")'
    cursor.execute(query)
    db.get_db().commit()
    return "Success!"

# completes the proper steps after the user places submit on the order (updates the order to have the proper information)
@investors.route('/submit', methods = ['POST'])
def update_investment():
    cursor = db.get_db().cursor()
    s = request.form['FranchiseID']
    franchise = int(s)
    cursor.execute('select max(FranchiseID) from Investments')
    o = cursor.fetchone()[0]
    query = f'select Stake from Investments where InvID = {o}'
    cursor.execute(query)
    stake = cursor.fetchone()[0]
    db_update_investment(franchise, stake, o)
    return 'success'

# updates the information for each investment after the user presses submit
def db_update_investment(franchise, stake, invID):
    cursor = db.get_db().cursor()
    cursor.execute(f'UPDATE Investments SET FranchiseID = {franchise}, Stake = {stake}, WHERE InvID = {invID}')
    db.get_db().commit()
    return "hello"

# post a new investment, according to % written and according franchise
@investors.route('/investmentPresentation')
def get_investment():
    return """
        <h2>HTML Forms</h2>
        <form action="/form" method="POST">
        <label for="stake">Investment Amount:</label><br>
        <input type="text" id="stake" name="stake" value="10"><br>
        <label for="franchiseID">Franchise:</label><br>
        <input type="text" id="franchiseID" name="franchiseID" value="12"><br><br>
        <input type="submit" value="Submit">
        </form> 
        """


@investors.route('/investmentForm', methods=['POST'])
def invest_post_form():
    return '<h2>Submitted an investment</h2>'
