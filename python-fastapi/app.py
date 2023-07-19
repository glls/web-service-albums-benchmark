from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import json
import uvicorn

app = FastAPI()
albums={}

class Album(BaseModel):
    ID: str
    Title: str
    Artist: str
    Price: float

def read_albums(filename):
    with open(filename, "r") as file:
        albums_data = json.load(file)
        albums = [Album(**album_data) for album_data in albums_data]
    return albums


@app.get("/albums")
async def get_albums():
    return albums

@app.get("/albums/{id}")
async def get_album_by_id(id: str):
    for album in albums:
        if album.id == id:
            return album
    raise HTTPException(status_code=404, detail="Album not found")

@app.post("/albums")
async def post_album(album: Album):
    albums.append(album)
    return album

if __name__ == "__main__":
    albums = read_albums("../albums.json")    
    uvicorn.run(app, host="0.0.0.0", port=8000)
