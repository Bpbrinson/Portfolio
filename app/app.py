from flask import Flask, render_template, url_for

def create_app():
    app = Flask(__name__)

    @app.route("/")
    def index():
        return render_template("index.html", page_title="Brandon's Portfolio")

    return app

# For local development: `python app.py`
if __name__ == "__main__":
    app = create_app()
    app.run(host="0.0.0.0", port=80, debug=True)
