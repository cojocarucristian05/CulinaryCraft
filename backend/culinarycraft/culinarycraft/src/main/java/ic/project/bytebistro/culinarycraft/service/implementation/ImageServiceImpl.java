package ic.project.bytebistro.culinarycraft.service.implementation;

import ic.project.bytebistro.culinarycraft.exception.ImageNotFoundException;
import ic.project.bytebistro.culinarycraft.exception.IngredientRecognitionException;
import ic.project.bytebistro.culinarycraft.repository.ImageRepository;
import ic.project.bytebistro.culinarycraft.repository.dto.response.ImageUploadResponse;
import ic.project.bytebistro.culinarycraft.repository.entity.Image;
import ic.project.bytebistro.culinarycraft.service.ImageService;
import ic.project.bytebistro.culinarycraft.utils.ImageUtils;
import jakarta.transaction.Transactional;
import lombok.SneakyThrows;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.util.Optional;

@Service
public class ImageServiceImpl implements ImageService {

    private final ImageRepository imageRepository;

    public ImageServiceImpl(ImageRepository imageRepository) {
        this.imageRepository = imageRepository;
    }

    @Override
    public ImageUploadResponse uploadImage(MultipartFile file) throws IOException {
        imageRepository.save(Image.builder()
                .name(file.getOriginalFilename())
                .type(file.getContentType())
                .imageData(ImageUtils.compressImage(file.getBytes())).build());

        return new ImageUploadResponse("Image uploaded successfully: " +
                file.getOriginalFilename());
    }

    @Transactional
    public Image getInfoByImageByName(String name) {
        Optional<Image> dbImage = imageRepository.findByName(name);
        if (dbImage.isEmpty()) {
            throw new ImageNotFoundException();
        }
        return Image.builder()
                .name(dbImage.get().getName())
                .type(dbImage.get().getType())
                .imageData(ImageUtils.decompressImage(dbImage.get().getImageData())).build();
    }

    @Override
    @Transactional
    public byte[] getImage(String name) {
        Optional<Image> dbImage = imageRepository.findByName(name);
        if (dbImage.isEmpty()) {
            throw new ImageNotFoundException();
        }
        return ImageUtils.decompressImage(dbImage.get().getImageData());
    }

    @SneakyThrows
    @Override
    public String foodRecognition(MultipartFile file) {
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
                return output.toString().replace("\n","");
            } else {
                throw new IngredientRecognitionException("Error running Python script. Exit code: " + exitCode);
            }
        } catch (IOException | InterruptedException e) {
            throw new IngredientRecognitionException("An error occurred while processing the image.");
        }
    }
}