package ic.project.bytebistro.culinarycraft.controller;

import ic.project.bytebistro.culinarycraft.repository.dto.response.RecipeDTO;
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
@RequestMapping("/api/v1/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/recipes")
    public ResponseEntity<RecipeDTO> createRecipe(@RequestParam Long userId,
                                                  @RequestParam LoginType loginType,
                                                  @RequestBody Recipe recipe) {
        return new ResponseEntity<>(
                userService.createRecipe(userId, loginType, recipe),
                HttpStatus.CREATED
        );
    }

    @PostMapping("/recipes-with-image")
    public ResponseEntity<RecipeDTO> createRecipe(
            @RequestParam Long userId,
            @RequestParam LoginType loginType,
            @RequestParam("name") String name,
            @RequestParam("description") String description,
            @RequestParam("image") MultipartFile image) throws IOException {

        return new ResponseEntity<>(
            userService.createRecipe(userId, loginType, name, description, image),
            HttpStatus.CREATED
        );
    }

    @Transactional
    @GetMapping("/all")
    public ResponseEntity<List<RecipeDTO>> getRecipes(@RequestParam Long userId,
                                                      @RequestParam LoginType loginType) {
        return new ResponseEntity<>(userService.getMyRecipes(userId, loginType), HttpStatus.OK);
    }
}
