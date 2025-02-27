from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/backend")
def home():
    return jsonify(message="Projeto - Anderson Oliveira")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
