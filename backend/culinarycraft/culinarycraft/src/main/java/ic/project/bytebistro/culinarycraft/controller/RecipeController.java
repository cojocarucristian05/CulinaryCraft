package ic.project.bytebistro.culinarycraft.controller;

import ic.project.bytebistro.culinarycraft.repository.dto.response.RecipeDTO;
import ic.project.bytebistro.culinarycraft.service.RecipeService;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("${apiVersion}/recipes")
public class RecipeController {
    private final RecipeService recipeService;

    public RecipeController(RecipeService recipeService) {
        this.recipeService = recipeService;
    }

    @GetMapping("/{id}")
    public ResponseEntity<RecipeDTO> getRecipeById(@PathVariable Long id) {
        return new ResponseEntity<>(recipeService.getRecipeById(id), HttpStatus.OK);
    }

    @GetMapping("/all/user/{id}")
    public ResponseEntity<Page<RecipeDTO>> getAllRecipeByUserId(@PathVariable Long id,
                                                                @RequestParam int pageNumber,
                                                                @RequestParam int pageSize) {
        return new ResponseEntity<>(recipeService.getAllRecipesByUser(id, pageNumber, pageSize), HttpStatus.OK);
    }

    @GetMapping("/all")
    public ResponseEntity<Page<RecipeDTO>> getAllRecipe(@RequestParam int pageNumber,
                                                        @RequestParam int pageSize) {
        return new ResponseEntity<>(recipeService.getAllRecipes(pageNumber, pageSize), HttpStatus.OK);
    }
}
