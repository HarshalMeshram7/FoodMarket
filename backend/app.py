# app.py

from flask import Flask
from flask_login import LoginManager
from flask_cors import CORS
from flasgger import Swagger
from dotenv import load_dotenv
import os

from routes import routes  # Import Blueprint

load_dotenv()

frontend_url = os.getenv('FRONTEND_URL')

app = Flask(__name__)
CORS(app, origins=[frontend_url], supports_credentials=True)
swagger = Swagger(app)

# Register Blueprint
app.register_blueprint(routes)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5003)