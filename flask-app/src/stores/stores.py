from flask import Blueprint, request, jsonify, make_response
import json
from src import db


stores = Blueprint('stores', __name__)

