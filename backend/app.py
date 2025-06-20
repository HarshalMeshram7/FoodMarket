from flask import Flask, jsonify
import pymysql
from flask_cors import CORS
from flasgger import Swagger

app = Flask(__name__)
CORS(app)
swagger = Swagger(app)

db = pymysql.connect(
    host='65.2.83.131',
    user='harshal',
    password='Harshal@112',
    database='foodmart',
    cursorclass=pymysql.cursors.DictCursor
    )

@app.route('/api/catagories', methods=['GET'])
def get_catagories():
    """
    Get all main categories
    ---
    responses:
      200:
        description: A list of categories
    """
    cursor = db.cursor()
    cursor.execute("SELECT * FROM main_catagories")
    data = cursor.fetchall()
    return jsonify(data)


if __name__ == '__main__':
    app.run(debug=True)