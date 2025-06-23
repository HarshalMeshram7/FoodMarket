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

@app.route('/api/categories', methods=['GET'])
def get_catagories():
    """
    Get all main categories
    ---
    responses:
      200:
        description: A list of categories
    """
    cursor = db.cursor()
    cursor.execute("SELECT main_category_id, name, description, image_url, display_order, is_active , created_at FROM main_categories")
    data = cursor.fetchall()
    return jsonify(data)


if __name__ == '__main__':
    app.run(debug=True, port=5000) 