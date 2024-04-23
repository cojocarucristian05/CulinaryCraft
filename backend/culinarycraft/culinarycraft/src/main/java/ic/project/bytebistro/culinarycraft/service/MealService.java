package ic.project.bytebistro.culinarycraft.service;

import ic.project.bytebistro.culinarycraft.repository.dto.response.RecipeDTO;

import java.util.List;

public interface MealService {
    RecipeDTO getRecipeById(Long id);

    List<RecipeDTO> getAllRecipeByUserId(Long id);
}
