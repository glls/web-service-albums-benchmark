#![feature(proc_macro_hygiene, decl_macro)]

use rocket::{get, routes, State};
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

// Rocket state to hold the albums data
struct AppState {
    albums: Vec<Album>,
}

// Rocket handler to get all albums
#[get("/albums")]
fn get_albums(state: State<AppState>) -> Json<Vec<Album>> {
    Json(state.albums.clone())
}

// Rocket handler to get an album by ID
#[get("/albums/<id>")]
fn get_album_by_id(id: String, state: State<AppState>) -> Option<Json<Album>> {
    if let Some(album) = state.albums.iter().find(|album| album.ID == id) {
        Some(Json(album.clone()))
    } else {
        None
    }
}

fn main() {
    // Read the albums data from the file at the beginning
    let mut file = File::open("../albums.json").expect("Failed to open albums.json");
    let mut content = String::new();
    file.read_to_string(&mut content).expect("Failed to read albums.json");
    let albums: Vec<Album> = serde_json::from_str(&content).expect("Failed to parse albums.json");

    // Create the Rocket application and store the albums data in the state
    rocket::ignite()
        .manage(AppState { albums })
        .mount("/", routes![get_albums, get_album_by_id])
        .launch();
}
