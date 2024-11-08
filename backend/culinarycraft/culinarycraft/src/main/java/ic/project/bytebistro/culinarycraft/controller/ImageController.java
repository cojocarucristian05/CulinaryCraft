package ic.project.bytebistro.culinarycraft.controller;

import ic.project.bytebistro.culinarycraft.repository.dto.response.ImageUploadResponse;
import ic.project.bytebistro.culinarycraft.repository.entity.Image;
import ic.project.bytebistro.culinarycraft.service.ImageService;
import ic.project.bytebistro.culinarycraft.service.IngredientService;
import jakarta.transaction.Transactional;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;

@Transactional
@RestController
@RequestMapping("${apiVersion}/images")
public class ImageController {

    private final ImageService imageService;
    private final IngredientService ingredientService;

    public ImageController(ImageService imageService, IngredientService ingredientService) {
        this.imageService = imageService;
        this.ingredientService = ingredientService;
    }

    @PostMapping
    public ResponseEntity<?> uploadImage(@RequestParam("image") MultipartFile file) throws IOException {
        ImageUploadResponse response = imageService.uploadImage(file);

        return ResponseEntity.status(HttpStatus.OK)
                .body(response);
    }

    @PostMapping(path = "/food-recognition")
    public ResponseEntity<?> foodRecognitionImageUpload(@RequestParam("image") MultipartFile file) throws IOException {
        String output = imageService.foodRecognition(file);
        return ResponseEntity.ok(ingredientService.getIngredientByName(output));
    }

    @GetMapping("/info/{name}")
    public ResponseEntity<?>  getImageInfoByName(@PathVariable("name") String name){
        Image image = imageService.getInfoByImageByName(name);

        return ResponseEntity.status(HttpStatus.OK)
                .body(image);
    }

    @GetMapping("/{name}")
    public ResponseEntity<?> getImageByName(@PathVariable("name") String name){
        byte[] image = imageService.getImage(name);

        return ResponseEntity.status(HttpStatus.OK)
                .contentType(MediaType.valueOf("image/png"))
                .body(image);
    }

}