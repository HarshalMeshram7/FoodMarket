from flask import Blueprint, jsonify, request
from flask_login import login_required, current_user
from db import get_db_connection
from werkzeug.security import check_password_hash, generate_password_hash
import psycopg2
from datetime import datetime, timedelta
import os
from functools import wraps

routes = Blueprint('routes', __name__)

@routes.route('/api/categories', methods=['GET'])
def get_categories():
    """
    Get all product categories
    ---
    tags:
      - Products
    responses:
      200:
        description: A list of product categories
        schema:
          type: array
          items:
            type: object
            properties:
              id:
                type: integer
              name:
                type: string
    """
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
    """
    Get 5 random products
    ---
    tags:
      - Products
    responses:
      200:
        description: A list of 5 random products
        schema:
          type: array
          items:
            type: object
            properties:
              id:
                type: integer
              name:
                type: string
              price:
                type: number
              category_id:
                type: integer
    """
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
    """
    Get products by category ID
    ---
    tags:
      - Products
    parameters:
      - name: category_id
        in: path
        type: integer
        required: true
        description: ID of the product category
    responses:
      200:
        description: List of products in the specified category
        schema:
          type: array
          items:
            type: object
            properties:
              id:
                type: integer
              name:
                type: string
              price:
                type: number
              category_id:
                type: integer
    """
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
def get_user():
    """
    Get user details by user ID
    ---
    tags:
      - User
    parameters:
      - name: user_id
        in: query
        type: integer
        required: true
        description: ID of the user
    responses:
      200:
        description: User details
        schema:
          type: object
          properties:
            id:
              type: integer
            first_name:
              type: string
            last_name:
              type: string
            email:
              type: string
            phone:
              type: string
    """
    try:
        user_id = request.args.get('user_id', type=int)
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
def update_user_details():
    """
    Update user details
    ---
    tags:
      - User
    parameters:
      - name: body
        in: body
        required: true
        schema:
          type: object
          properties:
            id:
              type: integer
            first_name:
              type: string
            last_name:
              type: string
            phone:
              type: string
    responses:
      200:
        description: User details updated successfully
        schema:
          type: object
          properties:
            message:
              type: string
    """
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
def login_user():
    """
    Login user with email and password
    ---
    tags:
      - Auth
    parameters:
      - name: body
        in: body
        required: true
        schema:
          type: object
          properties:
            email:
              type: string
              example: user@example.com
            password:
              type: string
              example: yourpassword
    responses:
      200:
        description: Successfully logged in
        schema:
          type: object
          properties:
            message:
              type: string
            user:
              type: object
              properties:
                user_id:
                  type: integer
                username:
                  type: string
                email:
                  type: string
        401:
          description: Invalid credentials
    """
    try:
        data = request.get_json()
        email = data.get('email')
        password = data.get('password')

        if not email or not password:
            return jsonify({'error': 'Email and password are required'}), 400

        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
        user = cursor.fetchone()
        cursor.close()
        conn.close()

        if user and check_password_hash(user['password_hash'], password):
            return jsonify({
                'message': 'Login successful',
                'token': 'dummy-token-123',  # Replace with real token or session ID
                'user_id': user['user_id'],
                'username': user['username'],
                'email': user['email'],
                'first_name': user['first_name']  # Add these if needed on frontend
            }), 200

        else:
            return jsonify({'error': 'Invalid email or password'}), 401

    except Exception as e:
        print("❌ Login error:", e)
        return jsonify({'error': 'Internal server error'}), 500


@routes.route('/api/register', methods=['POST'])
def register_user():
    """
    Register a new user
    ---
    tags:
      - Authentication
    consumes:
      - application/json
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - username
            - email
            - password
          properties:
            username:
              type: string
            email:
              type: string
            password:
              type: string
            first_name:
              type: string
            last_name:
              type: string
            phone:
              type: string
            address:
              type: string
    responses:
      200:
        description: User registered successfully
        schema:
          type: object
          properties:
            message:
              type: string
      400:
        description: Invalid input or user already exists
        schema:
          type: object
          properties:
            error:
              type: string
    """
    try:
        data = request.get_json()

        required_fields = ['username','first_name', 'last_name', 'email', 'password']
        if not all(field in data for field in required_fields):
            return jsonify({'error': 'Missing required fields'}), 400

        username = data['username']
        email = data['email']
        password = generate_password_hash(data['password'])  # hash password
        first_name = data.get('first_name')
        last_name = data.get('last_name')
        phone = data.get('phone')
        address = data.get('address')

        conn = get_db_connection()
        cursor = conn.cursor()

        # Check if user already exists
        cursor.execute("SELECT * FROM users WHERE email = %s OR username = %s", (email, username))
        existing_user = cursor.fetchone()

        if existing_user:
            cursor.close()
            conn.close()
            return jsonify({'error': 'User already exists'}), 400

        cursor.execute("""
            INSERT INTO users (username, email, password_hash, first_name, last_name, phone, address, created_at)
            VALUES (%s, %s, %s, %s, %s, %s, %s, NOW())
        """, (username, email, password, first_name, last_name, phone, address))

        conn.commit()
        cursor.close()
        conn.close()

        return jsonify({'message': 'User registered successfully'}), 200

    except Exception as e:
        print("❌ Error during registration:", e)
        return jsonify({'error': str(e)}), 500




