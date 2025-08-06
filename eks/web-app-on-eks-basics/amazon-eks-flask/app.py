from flask import Flask, jsonify
from flask_restx import Api, Resource
import requests
import json

app = Flask(__name__)
api = Api(app)

@api.route('/contents/<string:topic>')
class SearchContents(Resource):
    def get(self, topic):
        url = 'https://hn.algolia.com/api/v1/search?query='+topic
        response = requests.get(url)
        data = []
        if(response.status_code == 200):
            raw_data = json.loads(response.text)
            for index in raw_data['hits']:
                if 'title' in index and 'url' in index and index['title'] and index['url']:
                    data.append({
                        'id': index['objectID'],
                        'title' : index['title'],
                        'url': index['url']
                    })
        
        response = jsonify(outcome=data)
        response.headers.add("Access-Control-Allow-Origin", "*")
        
        return response

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8080)
