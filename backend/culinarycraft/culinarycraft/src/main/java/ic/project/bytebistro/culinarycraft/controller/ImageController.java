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

        // Define temporary file location
        File tempFile = File.createTempFile("uploaded_image", ".jpg");
        tempFile.deleteOnExit(); // Ensure the file is deleted on exit

        // Save the image to the temporary file
        try (FileOutputStream fos = new FileOutputStream(tempFile)) {
            fos.write(file.getBytes());
        }

        String scriptPath = "src/main/resources/scripts/food.py"; // Adjust the path as needed
        ProcessBuilder processBuilder = new ProcessBuilder("python", scriptPath, tempFile.getAbsolutePath());
        Process process;

        try {
            process = processBuilder.start();
            System.out.println(tempFile.getAbsolutePath());
            // Read the output from the Python script
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            StringBuilder output = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                output.append(line).append("\n");
            }

            // Wait for the process to finish and get the exit code
            int exitCode = process.waitFor();
            if (exitCode == 0) {

                // If successful, return the recognized ingredients
                return ResponseEntity.ok(ingredientService.getIngredientByName(output.toString().replace("\n","")));
            } else {
                // Handle the error case
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body("Error running Python script. Exit code: " + exitCode);
            }
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An error occurred while processing the image.");
        }
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