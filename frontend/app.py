from flask import Flask
from flask import render_template, url_for
import pymysql
import pymysql.cursors
from urllib.parse import unquote

app = Flask(__name__)


db = pymysql.connect(
    host='65.2.83.131',
    user='harshal',
    password='Harshal@112',
    database='foodmart'
    )

@app.template_filter('url_decode')
def url_decode_filter(s):
    return unquote(s)

@app.route('/')
def home_page():
    return render_template('home.html')


if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0', port=5001)