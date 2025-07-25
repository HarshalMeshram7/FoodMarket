from flask import Blueprint, jsonify, request
from flask_login import login_required, current_user
from db import get_db_connection
from werkzeug.security import check_password_hash
import jwt  # Install with: pip install pyjwt
from datetime import datetime, timedelta
import os
from functools import wraps

routes = Blueprint('routes', __name__)

# JWT decorator for API authentication
def jwt_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        token = request.headers.get('Authorization')
        if not token:
            return jsonify({'error': 'Token is missing'}), 401
        
        try:
            # Remove 'Bearer ' prefix if present
            if token.startswith('Bearer '):
                token = token[7:]
            
            # Decode the token
            data = jwt.decode(token, os.getenv('SECRET_KEY', 'your-secret-key-here'), algorithms=['HS256'])
            current_user_id = data['user_id']
            
            # Store user_id in request context
            request.current_user_id = current_user_id
            
        except jwt.ExpiredSignatureError:
            return jsonify({'error': 'Token has expired'}), 401
        except jwt.InvalidTokenError:
            return jsonify({'error': 'Token is invalid'}), 401
        
        return f(*args, **kwargs)
    return decorated_function

@routes.route('/api/categories', methods=['GET'])
def get_categories():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT main_category_id, name, description, image_url, display_order, is_active, created_at FROM main_categories WHERE is_active = 1 ORDER BY display_order")
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
        cursor.execute("SELECT product_id, main_category_id, name, description, price, cost_price, image_url, quantity_in_stock, rating FROM products WHERE quantity_in_stock > 0 ORDER BY RAND() LIMIT 10")
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
            WHERE main_category_id = %s AND quantity_in_stock > 0
            ORDER BY name
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
@jwt_required
def get_user():
    try:
        user_id = request.current_user_id
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT user_id, username, email, first_name, last_name, phone, address FROM users WHERE user_id = %s", (user_id,))
        data = cursor.fetchone()
        cursor.close()
        conn.close()
        
        if not data:
            return jsonify({'error': 'User not found'}), 404
        
        return jsonify(data)
    except Exception as e:
        print("❌ DB Error (get user):", e)
        return jsonify({'error': str(e)}), 500

@routes.route('/api/update-user-details', methods=['PUT'])
@jwt_required
def update_user_details():
    try:
        data = request.get_json()
        user_id = request.current_user_id
        
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
        
        return jsonify(updated_user)
        
    except Exception as e:
        print(f"Update error: {str(e)}")
        return jsonify({'error': 'Server error'}), 500
    finally:
        if 'cursor' in locals():
            cursor.close()
        if 'conn' in locals():
            conn.close()

@routes.route('/api/login', methods=['POST'])
def login():
    try:
        data = request.get_json()
        email = data.get('email')
        password = data.get('password')
        
        # Validate input
        if not email or not password:
            return jsonify({'message': 'Email and password are required'}), 400
            
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Check if user exists
        cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
        user = cursor.fetchone()
        
        if not user:
            return jsonify({'message': 'Invalid credentials'}), 401
            
        # Verify password
        if not check_password_hash(user['password'], password):
            return jsonify({'message': 'Invalid credentials'}), 401
            
        # Create JWT token
        token = jwt.encode({
            'user_id': user['user_id'],
            'exp': datetime.utcnow() + timedelta(days=7)
        }, os.getenv('SECRET_KEY', 'your-secret-key-here'), algorithm='HS256')
        
        return jsonify({
            'token': token,
            'user_id': user['user_id'],
            'first_name': user['first_name']
        })
        
    except Exception as e:
        print(f"Login error: {str(e)}")
        return jsonify({'message': 'Server error'}), 500
    finally:
        if 'cursor' in locals():
            cursor.close()
        if 'conn' in locals():
            conn.close()