package ic.project.bytebistro.culinarycraft.controller;

import ic.project.bytebistro.culinarycraft.repository.dto.response.RecipeDTO;
import ic.project.bytebistro.culinarycraft.repository.entity.Recipe;
import ic.project.bytebistro.culinarycraft.service.MealService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

import java.util.List;

@RestController
@RequestMapping("/api/v1/meals")
public class MealController {
    private final MealService mealService;

    public MealController(MealService mealService) {
        this.mealService = mealService;
    }

    @GetMapping("/{id}")
    public ResponseEntity<RecipeDTO> getRecipeById(@PathVariable Long id) {
        return new ResponseEntity<>(mealService.getRecipeById(id), HttpStatus.OK);
    }

    @GetMapping("/user/{id}")
    public ResponseEntity<List<RecipeDTO>> getAllRecipeByUserId(@PathVariable Long id) {
        return new ResponseEntity<>(mealService.getAllRecipeByUserId(id), HttpStatus.OK);
    }
}
