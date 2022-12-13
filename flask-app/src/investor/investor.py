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
def get_investors():
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


# adds an investment into the database after the investor has it
@investors.route("/investment", methods=['POST'])
def add_investment():
    cursor = db.get_db().cursor()
    stake = request.form['stake']
    franchiseId = request.form['franchiseid']
    invId = request.form['invid']
    query = f'INSERT INTO Investment(FranchiseId, InvId, InvStatus, Stake) values ({franchiseId}, {invId}, \'new\', {stake}) '
    return "Success!"


# Returns all the franchises by franchiseID
# 127.0.0.1:8001/investors/franchises
@investors.route('/franchises', methods=['GET'])
def get_franchises():
    cursor = db.get_db().cursor()
    query = 'select franchise_id as value from franchise'
    cursor.execute(query)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


@investors.route('/<invId>')
def get_investor(invId):
    cursor = db.get_db().cursor()
    cursor.execute(f'select * from Investor where InvID = {invId}')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


@investors.route('/investments/<invID>', methods=['GET'])
def get_investments(invId):
    cursor = db.get_db().cursor()
    cursor.execute('select FranchiseId, InvId, InvStatus, Stake from Investments where InvID = {0}'.format(invId))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response
