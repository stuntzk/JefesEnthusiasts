from flask import Blueprint, request, jsonify, make_response
import json
from src import db
from datetime import timedelta

managers = Blueprint('managers', __name__)

@managers.route('/managers')
def get_all_managers():

    cursor = db.get_db().cursor()
    cursor.execute('select FirstName from Employee where EmpId = ManagerId')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


@managers.route('/timeMake')
def get_all_times():
    cursor = db.get_db().cursor()
    cursor.execute('select * from Orders')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    type_data = []
    theData = cursor.fetchall()
    for row in theData:
        rowList = list(row)
        for index, item in list(enumerate(rowList)):
            if isinstance(item, timedelta):
                rowList[index] = str(rowList[index])
        rowTuple = tuple(rowList)
        json_data.append(dict(zip(row_headers, rowTuple)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response
    # the_response = make_response(jsonify(json_data))
    #the_response.status_code = 200
    #the_response.mimetype = 'application/json'
    #return the_response
