#![feature(proc_macro_hygiene, decl_macro)]

use rocket::{get, routes};
use rocket_contrib::json::Json;
use serde::{Deserialize, Serialize};
use std::fs::File;
use std::io::Read;

// Define the Album struct
#[derive(Debug, Clone, Serialize, Deserialize)]
struct Album {
    ID: String,
    Title: String,
    Artist: String,
    Price: f64,
}

// Rocket handler to get all albums
#[get("/albums")]
fn get_albums() -> Json<Vec<Album>> {
    let mut file = File::open("../albums.json").expect("Failed to open albums.json");
    let mut content = String::new();
    file.read_to_string(&mut content)
        .expect("Failed to read albums.json");

    let albums: Vec<Album> = serde_json::from_str(&content).expect("Failed to parse albums.json");
    Json(albums)
}

// Rocket handler to get an album by ID
#[get("/albums/<id>")]
fn get_album_by_id(id: String) -> Option<Json<Album>> {
    let mut file = File::open("albums.json").expect("Failed to open albums.json");
    let mut content = String::new();
    file.read_to_string(&mut content)
        .expect("Failed to read albums.json");

    let albums: Vec<Album> = serde_json::from_str(&content).expect("Failed to parse albums.json");

    if let Some(album) = albums.iter().find(|album| album.ID == id) {
        Some(Json(album.clone()))
    } else {
        None
    }
}

fn main() {
    rocket::ignite()
        .mount("/", routes![get_albums, get_album_by_id])
        .launch();
}
