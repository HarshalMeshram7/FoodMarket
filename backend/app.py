from flask import Flask, jsonify, request
import pymysql
from flask_cors import CORS
from flasgger import Swagger
from dotenv import load_dotenv
import os   

load_dotenv()

backend_url = os.getenv('BACKEND_URL')
frontend_url = os.getenv('FRONTEND_URL')
DB_HOST = os.getenv('DB_HOST')
DB_USER = os.getenv('DB_USER')
DB_PASSWORD = os.getenv('DB_PASSWORD')
DB_NAME = os.getenv('DB_NAME')

app = Flask(__name__)
CORS(app, origins=[frontend_url], supports_credentials=True)
swagger = Swagger(app)

def get_db_connection():
    return pymysql.connect(
        host=DB_HOST,
        port=3306,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
        cursorclass=pymysql.cursors.DictCursor
    )

@app.route('/api/categories', methods=['GET'])
def get_categories():
    """
    Get all main categories
    ---
    responses:
      200:
        description: A list of categories
    """
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT main_category_id, name, description, image_url, display_order, is_active , created_at FROM main_categories")
        data = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(data)
    except Exception as e:
        print("❌ DB Error (categories):", e)
        return jsonify({'error': str(e)}), 500

@app.route('/api/randomproducts', methods=['GET'])
def get_random_products():
    """
    Get random products
    ---
    responses:
        200:
            description: A list of random products
    """
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT product_id, main_category_id, name, description, price, cost_price, image_url, quantity_in_stock, rating FROM products ORDER BY RAND() LIMIT 10")
        data = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(data)
    except Exception as e:
        print("❌ DB Error (products):", e)
        return jsonify({'error': str(e)}), 500




@app.route('/api/products/by-category/<int:category_id>', methods=['GET'])
def get_products_by_category(category_id):
    """
    Get products by category
    ---
    parameters:
      - in: path
        name: category_id
        type: integer
        required: true
        description: ID of the category
    responses:
      200:
        description: A list of products in the given category
    """
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        query = """
            SELECT product_id, main_category_id, name, description, price, cost_price,
                   image_url, quantity_in_stock, rating
            FROM products
            WHERE main_category_id = %s



            
        """
        cursor.execute(query, (category_id,))
        data = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(data)
    except Exception as e:
        print("❌ DB Error (products by category):", e)
        return jsonify({'error': str(e)}), 500


@app.route('/api/get-user-details', methods=['GET'])
def get_user():
    """
    Get user information
    ---
    responses:
      200:
        description: User information
    """
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT user_id, username, email, first_name, last_name, phone FROM users")
        data = cursor.fetchall()
        cursor.close()
        conn.close()
        if not data:
            return jsonify({'error': 'User not found'}), 404
            
        # Convert to dictionary with column names
        columns = [col[0] for col in cursor.description]
        return jsonify(dict(zip(columns, data)))
    
    except Exception as e:
        print("❌ DB Error (users):", e)
        return jsonify({'error': str(e)}), 500
    


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5003)
