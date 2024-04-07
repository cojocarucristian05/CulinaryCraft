package ic.project.bytebistro.culinarycraft.service.implementation;

import ic.project.bytebistro.culinarycraft.exception.ImageNotFoundException;
import ic.project.bytebistro.culinarycraft.repository.ImageRepository;
import ic.project.bytebistro.culinarycraft.repository.dto.response.ImageUploadResponse;
import ic.project.bytebistro.culinarycraft.repository.entity.Image;
import ic.project.bytebistro.culinarycraft.service.ImageService;
import ic.project.bytebistro.culinarycraft.utils.ImageUtil;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
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
                .imageData(ImageUtil.compressImage(file.getBytes())).build());

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
                .imageData(ImageUtil.decompressImage(dbImage.get().getImageData())).build();

    }

    @Override
    @Transactional
    public byte[] getImage(String name) {
        Optional<Image> dbImage = imageRepository.findByName(name);
        if (dbImage.isEmpty()) {
            throw new ImageNotFoundException();
        }
        return ImageUtil.decompressImage(dbImage.get().getImageData());
    }
}
