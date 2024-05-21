package ic.project.bytebistro.culinarycraft.service;

import ic.project.bytebistro.culinarycraft.repository.dto.response.ImageUploadResponse;
import ic.project.bytebistro.culinarycraft.repository.entity.Image;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Service
public interface ImageService {
    ImageUploadResponse uploadImage(MultipartFile file) throws IOException;
    Image getInfoByImageByName(String name);
    byte[] getImage(String name);
}