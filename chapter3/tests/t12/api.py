from flask import Flask, jsonify, request

app = Flask(__name__)

changelog = "no-data"

@app.route("/changelog", methods=["POST"])
def setName():
    global changelog
    
    if request.method=='POST':
        posted_data = request.get_json()    
        changelog = posted_data['changelog']
        return jsonify(str("Successfully stored: " + str(changelog)))
    
@app.route("/changelog", methods=["GET"])
def message():    
    # We make this for return 500 error from server
    call_not_exist_function()

    return jsonify("Changelog from the memory: " +  changelog)

if __name__=='__main__':
   app.run(host="0.0.0.0", debug=True)
