from flask import Flask
from flask import render_template, url_for
import pymysql
import pymysql.cursors
from urllib.parse import unquote
import os
from dotenv import load_dotenv

load_dotenv()


app = Flask(__name__)


@app.template_filter('url_decode')
def url_decode_filter(s):
    return unquote(s)

@app.route('/')
def home_page():
    return render_template('home.html')


if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0', port=5001)