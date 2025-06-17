from flask import Flask
from flask import render_template, url_for
import pymysql
import pymysql.cursors

app = Flask(__name__)

db = pymysql.connect(
    host='localhost',
    user='root',
    password='root',
    database='foodmart'
    )

@app.route('/')
def home_page():
    cursor = db.cursor(pymysql.cursors.DictCursor)
    cursor.execute("SELECT name FROM main_categories")
    categories = cursor.fetchall()
    return render_template('home.html', categories=categories)




if __name__ == '__main__':
    app.run(debug=True)