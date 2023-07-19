<?php

namespace App\Controller;

use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;

class AlbumController
{
    private const ALBUMS_FILE = __DIR__ . '../../../../../albums.json';
    private array $albums;

    public function __construct() {
        $this->loadAlbums();
    }


    /**
     * @Route("/albums", name="get_albums", methods={"GET"})
     */
    public function getAlbums()
    {
        return new JsonResponse($this->albums);
    }



    /**
     * @Route("/albums/{id}", name="get_album_by_id", methods={"GET"})
     */
    public function getAlbumById($id)
    {
        foreach ($this->albums as $album) {
            if ($album['ID'] === $id) {
                return new JsonResponse($album);
            }
        }

        return new JsonResponse(['message' => 'Album not found'], 404);
    }

    /**
     * @Route("/albums", name="create_album", methods={"POST"})
     */
    public function createAlbum()
    {
        $data = json_decode(file_get_contents('php://input'), true);

        if (!$data || !isset($data['ID']) || !isset($data['Title']) || !isset($data['Artist']) || !isset($data['Price'])) {
            return new JsonResponse(['message' => 'Invalid album data'], 400);
        }

        $albums = $this->loadAlbums();
        $albums[] = $data;

        file_put_contents(self::ALBUMS_FILE, json_encode($albums, JSON_PRETTY_PRINT));

        return new JsonResponse($data, 201);
    }

    private function loadAlbums()
    {
        foreach(json_decode(file_get_contents(self::ALBUMS_FILE), true) as $rawAlbum) {
		$this->albums[] = $rawAlbum;
	};
    }
}
