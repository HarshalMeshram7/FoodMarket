from flask import Blueprint, jsonify, request
from flask_login import login_required, current_user
from db import get_db_connection

# routes.py

from flask import Blueprint, jsonify, request
from flask_login import login_required, current_user
from db import get_db_connection  # We'll define this in a separate db.py file

routes = Blueprint('routes', __name__)

@routes.route('/api/categories', methods=['GET'])
def get_categories():
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

@routes.route('/api/randomproducts', methods=['GET'])
def get_random_products():
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

@routes.route('/api/products/by-category/<int:category_id>', methods=['GET'])
def get_products_by_category(category_id):
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

@routes.route('/api/get-user-details', methods=['GET'])
def get_user():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT user_id, username, email, first_name, last_name, phone FROM users")
        data = cursor.fetchall()
        cursor.close()
        conn.close()
        if not data:
            return jsonify({'error': 'User not found'}), 404
        columns = [col[0] for col in cursor.description]
        return jsonify(dict(zip(columns, data)))
    except Exception as e:
        print("❌ DB Error (users):", e)
        return jsonify({'error': str(e)}), 500

@routes.route('/api/update-user-details', methods=['PUT'])
@login_required
def update_user_details():
    try:
        data = request.get_json()
        user_id = current_user.id
        if not data.get('first_name') or not data.get('last_name'):
            return jsonify({'error': 'First and last name are required'}), 400
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("""
            UPDATE users 
            SET first_name = %s,
                last_name = %s,
                phone = %s,
                address = %s
            WHERE user_id = %s
        """, (data['first_name'], data['last_name'], 
              data.get('phone'), data.get('address'), 
              user_id))
        conn.commit()
        cursor.execute("SELECT user_id, username, email, first_name, last_name, phone, address FROM users WHERE user_id = %s", (user_id,))
        updated_user = cursor.fetchone()
        if not updated_user:
            return jsonify({'error': 'User not found'}), 404
        columns = [col[0] for col in cursor.description]
        user_dict = dict(zip(columns, updated_user))
        return jsonify(user_dict)
    except Exception as e:
        print(f"Update error: {str(e)}")
        return jsonify({'error': 'Server error'}), 500
    finally:
        cursor.close()
        conn.close()