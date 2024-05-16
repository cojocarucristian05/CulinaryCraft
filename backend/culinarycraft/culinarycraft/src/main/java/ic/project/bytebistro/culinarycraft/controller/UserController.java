package ic.project.bytebistro.culinarycraft.controller;

import ic.project.bytebistro.culinarycraft.repository.dto.request.UserUpdateDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.RecipeDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.UserResponseDTO;
import ic.project.bytebistro.culinarycraft.repository.entity.LoginType;
import ic.project.bytebistro.culinarycraft.repository.entity.Recipe;
import ic.project.bytebistro.culinarycraft.service.UserService;
import jakarta.transaction.Transactional;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;


@RestController
@RequestMapping("${apiVersion}/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PutMapping("/{id}")
    public ResponseEntity<UserResponseDTO> updateProfile(@PathVariable Long id,
                                                         @RequestBody UserUpdateDTO userUpdateDTO) {
        return new ResponseEntity<>(userService.updateProfile(id, userUpdateDTO), HttpStatus.OK);
    }
}
