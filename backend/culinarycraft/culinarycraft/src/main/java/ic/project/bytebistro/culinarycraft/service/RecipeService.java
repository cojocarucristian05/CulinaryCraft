package ic.project.bytebistro.culinarycraft.service;

import ic.project.bytebistro.culinarycraft.repository.dto.response.RecipeDTO;
import org.springframework.data.domain.Page;

import java.util.List;

public interface RecipeService {
    RecipeDTO getRecipeById(Long id);

    List<RecipeDTO> getAllRecipeByUserId(Long id);

    Page<RecipeDTO> getAllRecipesByUser(Long id, int pageNumber, int pageSize);

    Page<RecipeDTO> getAllRecipes(int pageNumber, int pageSize);
}
