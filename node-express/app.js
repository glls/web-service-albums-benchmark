const express = require('express');
const bodyParser = require('body-parser');
const fs = require('fs');

const app = express();
const port = 8000;

// Middleware to parse JSON data from the request body
app.use(bodyParser.json());

// Variable to store the albums data
let albumsData;

// Read the albums data from the file on app startup
fs.readFile('../albums.json', 'utf8', (err, data) => {
  if (err) {
    console.error('Failed to read albums.json:', err);
    process.exit(1);
  }
  albumsData = JSON.parse(data);
  console.log('Album data loaded successfully.');
});

// Define the Album object
class Album {
  constructor(ID, Title, Artist, Price) {
    this.ID = ID;
    this.Title = Title;
    this.Artist = Artist;
    this.Price = Price;
  }
}

// Endpoint to get all albums
app.get('/albums', (req, res) => {
  res.json(albumsData);
});

// Endpoint to get an album by ID
app.get('/albums/:id', (req, res) => {
  const albumId = req.params.id;

  const album = albumsData.find((album) => album.ID === albumId);

  if (album) {
    res.json(album);
  } else {
    res.status(404).json({ error: 'Album not found' });
  }
});

// Start the server after the albums data is loaded
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
