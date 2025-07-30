from flask import Flask, render_template, url_for, session, redirect, request, jsonify
from flask_login import LoginManager, UserMixin, login_user, logout_user, login_required, current_user
import pymysql
import pymysql.cursors
from urllib.parse import unquote
import os
from dotenv import load_dotenv
import requests
import jwt
from datetime import datetime

load_dotenv()

app = Flask(__name__)

# Initialize Flask-Login
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login_page'
login_manager.login_message = 'Please log in to access this page.'

# User class for Flask-Login
class User(UserMixin):
    def __init__(self, user_id, username, email, first_name, last_name):
        self.id = user_id
        self.username = username
        self.email = email
        self.first_name = first_name
        self.last_name = last_name

@login_manager.user_loader
def load_user(user_id):
    # You can either make an API call to your backend or query database directly
    # For now, let's use session data
    if 'user_data' in session:
        user_data = session['user_data']
        return User(
            user_data['user_id'],
            user_data.get('username', ''),
            user_data.get('email', ''),
            user_data.get('first_name', ''),
            user_data.get('last_name', '')
        )
    return None

@app.template_filter('url_decode')
def url_decode_filter(s):
    return unquote(s)

@app.route('/')
def home_page():
    return render_template('home.html')
    
@app.route('/product')
def product_details():    
    return render_template('productdetails.html')

@app.route('/myaccount')
@login_required
def my_account():
    return render_template('myaccount.html')

@app.route('/login', methods=['GET', 'POST'])
def login_page():
    if current_user.is_authenticated:
        return redirect(url_for('home_page'))
    return render_template('login.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    session.clear()
    return redirect(url_for('home_page'))

@app.route('/register')
def register():
    return render_template('register.html')

# Forgot password route
@app.route('/forgot-password')
def forgot_password():
    return render_template('forgot_password.html')

# API proxy routes (optional - to avoid CORS issues)
@app.route('/api/categories')
def api_categories():
    response = requests.get('http://localhost:5003/api/categories')
    return response.json()

@app.route('/api/randomproducts')
def api_random_products():
    response = requests.get('http://localhost:5003/api/randomproducts')
    return response.json()

@app.route('/api/products/by-category/<int:category_id>')
def api_products_by_category(category_id):
    response = requests.get(f'http://localhost:5003/api/products/by-category/{category_id}')
    return response.json()

@app.route('/api/get-user-details')
@login_required
def api_get_user_details():
    # Make authenticated request to backend
    headers = {'Authorization': f'Bearer {session.get("auth_token")}'}
    response = requests.get('http://localhost:5003/api/get-user-details', headers=headers)
    return response.json()

@app.route('/api/update-user-details', methods=['PUT'])
@login_required
def api_update_user_details():
    headers = {
        'Authorization': f'Bearer {session.get("auth_token")}',
        'Content-Type': 'application/json'
    }
    response = requests.put('http://localhost:5003/api/update-user-details', 
                          json=request.json, headers=headers)
    return response.json()

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5001)