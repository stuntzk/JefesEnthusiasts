from flask import Blueprint, request, jsonify, make_response
import json
from src import db
from datetime import timedelta

managers = Blueprint('managers', __name__)

# route rused when logging into the manager site
@managers.route('/<manID>')
def get_manager(manID):
    cursor = db.get_db().cursor()
    cursor.execute(f'select * from Employee where EmpId = ManagerId and ManagerId = {manID}')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

#route used when creating the graph of time to make 
@managers.route('/timeMake', methods=['GET'])
def get_all_times():
    cursor = db.get_db().cursor()
    query = '''
        select hour as x, avg(totalTime)/60 as y
        from (select OrderDate, EXTRACT(HOUR from TimeOrdered) as hour, totalTime
        from (SELECT OrderDate, TimeOrdered, TIME_TO_SEC(TimeToMake) as totalTime
        FROM Orders) as second) as third
        group by hour
        ORDER BY hour;
    '''

    cursor.execute(query)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
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





