using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;

namespace YourAppName.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class AlbumsController : ControllerBase
    {
        private readonly List<Album> _albums;

        public AlbumsController()
        {
            // Read albums data from albums.json file
            var albumsData = System.IO.File.ReadAllText("../../albums.json");
            _albums = JsonConvert.DeserializeObject<List<Album>>(albumsData);
        }


        [HttpGet]
        public IEnumerable<Album> GetAlbums([FromQuery] int skip = 0, [FromQuery] int limit = 100)
        {
            return _albums.Skip(skip).Take(limit);
        }

        [HttpGet("{id}")]
        public ActionResult<Album> GetAlbumById(string id)
        {
            var album = _albums.FirstOrDefault(a => a.ID == id);
            if (album == null)
            {
                return NotFound();
            }
            return album;
        }
    }
}
