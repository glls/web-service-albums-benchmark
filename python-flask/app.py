from flask import Flask, jsonify, request
import json
from pydantic import BaseModel

app = Flask(__name__)
albums = {}

class Album(BaseModel):
    ID: str
    Title: str
    Artist: str
    Price: float

def read_albums(filename):
    with open(filename, "r") as file:
        albums_data = json.load(file)
        albums = {album_data["ID"]: Album(**album_data) for album_data in albums_data}
    return albums

@app.route('/albums', methods=['GET'])
def get_albums():
    album_list = [album.dict() for album in albums.values()]
    return jsonify(album_list)

@app.route('/albums/<string:id>', methods=['GET'])
def get_album_by_id(id):
    album = albums.get(id)
    if album:
        return jsonify(album.dict())
    else:
        return jsonify({"message": "Album not found"}), 404

@app.route('/albums', methods=['POST'])
def create_album():
    new_album_data = request.get_json()
    if not all(key in new_album_data for key in ["ID", "Title", "Artist", "Price"]):
        return jsonify({"message": "Invalid album data"}), 400

    new_album = Album(**new_album_data)
    albums[new_album.ID] = new_album
    return jsonify(new_album.dict()), 201

if __name__ == '__main__':
    albums = read_albums("../albums.json")
    app.run(debug=False, port=8000)
