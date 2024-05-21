package ic.project.bytebistro.culinarycraft.controller;

import ic.project.bytebistro.culinarycraft.repository.dto.request.IngredientsRequestDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.request.RecipeCreateDTO;
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

    @PostMapping("/user/{id}")
    public ResponseEntity<RecipeDTO> craftRecipe(@PathVariable Long id, @RequestBody RecipeCreateDTO recipeCreateDTO) {
        return new ResponseEntity<>(recipeService.craftRecipe(id, recipeCreateDTO), HttpStatus.CREATED);
    }

    @PutMapping("/user-id={userId}/add-to-favourite/recipe-id={recipeId}")
    public ResponseEntity<Boolean> addToFavourite(@PathVariable Long userId,
                                           @PathVariable Long recipeId) {
        return new ResponseEntity<>(recipeService.addToFavourites(userId, recipeId), HttpStatus.OK);
    }

    @GetMapping("/favourites/user-id={userId}")
    public ResponseEntity<Page<RecipeDTO>> getFavouritesRecipeByUserId(@PathVariable Long userId,
                                                                       @RequestParam int pageNumber,
                                                                       @RequestParam int pageSize) {
        return new ResponseEntity<>(recipeService.getFavouritesRecipes(userId, pageNumber, pageSize), HttpStatus.OK);
    }

    @PutMapping("/user-id={userId}/remove-from-favourite/recipe-id={recipeId}")
    public ResponseEntity<Void> removeRecipeFromFavourites(@PathVariable Long userId,
                                                           @PathVariable Long recipeId) {
        recipeService.removeRecipeFromFavourites(userId, recipeId);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    @DeleteMapping("/user-id={userId}/delete/recipe-id={recipeId}")
    public ResponseEntity<Void> deleteRecipe(@PathVariable Long userId,
                                             @PathVariable Long recipeId) {
        recipeService.deleteRecipe(userId, recipeId);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    @PostMapping("/search")
    public ResponseEntity<Page<RecipeDTO>> searchRecipes(@RequestParam int pageNumber,
                                                         @RequestParam int pageSize,
                                                         @RequestBody IngredientsRequestDTO ingredientsID) {
        return new ResponseEntity<>(recipeService.searchRecipes(ingredientsID, pageNumber, pageSize), HttpStatus.OK);
    }
}
