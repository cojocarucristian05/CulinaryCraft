package ic.project.bytebistro.culinarycraft.service.implementation;

import ic.project.bytebistro.culinarycraft.exception.RecipeNotFoundException;
import ic.project.bytebistro.culinarycraft.exception.UserInactiveException;
import ic.project.bytebistro.culinarycraft.exception.UserNotFoundException;
import ic.project.bytebistro.culinarycraft.repository.RecipeRepository;
import ic.project.bytebistro.culinarycraft.repository.UserRepository;
import ic.project.bytebistro.culinarycraft.repository.dto.response.IngredientDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.RecipeDTO;
import ic.project.bytebistro.culinarycraft.repository.entity.Ingredient;
import ic.project.bytebistro.culinarycraft.repository.entity.Recipe;
import ic.project.bytebistro.culinarycraft.repository.entity.User;
import ic.project.bytebistro.culinarycraft.service.RecipeService;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

@Service
public class RecipeServiceImpl implements RecipeService {

    private final RecipeRepository recipeRepository;

    private final UserRepository userRepository;
    private final ModelMapper modelMapper;

    public RecipeServiceImpl(RecipeRepository recipeRepository, UserRepository userRepository, ModelMapper modelMapper) {
        this.recipeRepository = recipeRepository;
        this.userRepository = userRepository;
        this.modelMapper = modelMapper;
    }

    @Override
    public RecipeDTO getRecipeById(Long id) {
        return modelMapper.map(recipeRepository.findById(id).orElseThrow(RecipeNotFoundException::new), RecipeDTO.class);
    }

    @Override
    public List<RecipeDTO> getAllRecipeByUserId(Long id) {
        User user = userRepository.findById(id).orElseThrow(UserNotFoundException::new);
        if (!user.getIsActive()) {
            throw new UserInactiveException();
        }
        Type listType = new TypeToken<List<RecipeDTO>>(){}.getType();
        return modelMapper.map(user.getMyRecipes(), listType);
    }

    @Override
    public Page<RecipeDTO> getAllRecipesByUser(Long id, int pageNumber, int pageSize) {
        User user = userRepository.findById(id).orElseThrow(UserNotFoundException::new);
        if (!user.getIsActive()) {
            throw new UserInactiveException();
        }
        Page<Recipe> recipes = recipeRepository
                .findAllByUser(user, PageRequest.of(pageNumber, pageSize, Sort.unsorted()));
        List<RecipeDTO> recipeDTOS = mapRecipes(recipes);
        return new PageImpl<>(recipeDTOS);
    }

    @Override
    public Page<RecipeDTO> getAllRecipes(int pageNumber, int pageSize) {
        Page<Recipe> recipes = recipeRepository
                .findAll(PageRequest.of(pageNumber, pageSize, Sort.unsorted()));
        List<RecipeDTO> recipeDTOS = mapRecipes(recipes);
        return new PageImpl<>(recipeDTOS);
    }

    private List<IngredientDTO> mapIngredients(List<Ingredient> ingredients) {
        return ingredients
                .stream()
                .map(ingredient -> new IngredientDTO(ingredient.getName(), ingredient.getUrlImage()))
                .toList();
    }

    private List<RecipeDTO> mapRecipes(Page<Recipe> recipes) {
        List<RecipeDTO> recipeDTOS = new ArrayList<>();
        recipes
                .stream()
                .map(recipe -> new RecipeDTO(
                        recipe.getName(),
                        recipe.getDescription(),
                        mapIngredients(recipe.getIngredients()),
                        recipe.getUrlImage()))
                .forEach(recipeDTOS::add);
        return recipeDTOS;
    }
}
