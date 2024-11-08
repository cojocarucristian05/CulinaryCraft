package ic.project.bytebistro.culinarycraft.service;

import ic.project.bytebistro.culinarycraft.repository.dto.request.IngredientsRequestDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.request.RecipeCreateDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.RecipeDTO;
import org.springframework.data.domain.Page;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

public interface RecipeService {
    RecipeDTO getRecipeById(Long id);

    List<RecipeDTO> getAllRecipeByUserId(Long id);

    Page<RecipeDTO> getAllRecipesByUser(Long id, int pageNumber, int pageSize);

    Page<RecipeDTO> getAllRecipes(int pageNumber, int pageSize);

    RecipeDTO craftRecipe(Long id, RecipeCreateDTO recipeCreateDTO);

    Boolean addToFavourites(Long userId, Long recipeId);

    Page<RecipeDTO> getFavouritesRecipes(Long userId, int pageNumber, int pageSize);

    void removeRecipeFromFavourites(Long userId, Long recipeId);

    void deleteRecipe(Long userId, Long recipeId);

    Page<RecipeDTO> searchRecipes(IngredientsRequestDTO ingredientsRequestDTO, int pageNumber, int pageSize);

    RecipeDTO craftRecipe2(Long id, String name, String description, Long[] ingredientsID, MultipartFile file) throws IOException;
}
