from flask import Flask, render_template, url_for


app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/linux')
def linux():
    return render_template('linux.html')

@app.route('/AWS')
def AWS():
    return render_template('AWS.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
