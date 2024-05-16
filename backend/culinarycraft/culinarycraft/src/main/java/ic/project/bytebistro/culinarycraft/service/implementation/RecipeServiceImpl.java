package ic.project.bytebistro.culinarycraft.service.implementation;

import ic.project.bytebistro.culinarycraft.exception.*;
import ic.project.bytebistro.culinarycraft.repository.IngredientRepository;
import ic.project.bytebistro.culinarycraft.repository.RecipeRepository;
import ic.project.bytebistro.culinarycraft.repository.UserRepository;
import ic.project.bytebistro.culinarycraft.repository.dto.request.IngredientsRequestDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.request.RecipeCreateDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.IngredientDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.LikeDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.RecipeDTO;
import ic.project.bytebistro.culinarycraft.repository.entity.Ingredient;
import ic.project.bytebistro.culinarycraft.repository.entity.Recipe;
import ic.project.bytebistro.culinarycraft.repository.entity.User;
import ic.project.bytebistro.culinarycraft.service.RecipeService;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Service
public class RecipeServiceImpl implements RecipeService {

    private final RecipeRepository recipeRepository;

    private final UserRepository userRepository;

    private final IngredientRepository ingredientRepository;
    private final ModelMapper modelMapper;

    public RecipeServiceImpl(RecipeRepository recipeRepository, UserRepository userRepository, IngredientRepository ingredientRepository, ModelMapper modelMapper) {
        this.recipeRepository = recipeRepository;
        this.userRepository = userRepository;
        this.ingredientRepository = ingredientRepository;
        this.modelMapper = modelMapper;
    }

    @Override
    public RecipeDTO getRecipeById(Long id) {
        return modelMapper.map(recipeRepository.findById(id).orElseThrow(RecipeNotFoundException::new), RecipeDTO.class);
    }

    @Override
    public List<RecipeDTO> getAllRecipeByUserId(Long id) {
        User user = getUser(id);
        Type listType = new TypeToken<List<RecipeDTO>>(){}.getType();
        return modelMapper.map(user.getMyRecipes(), listType);
    }

    @Override
    public Page<RecipeDTO> getAllRecipesByUser(Long id, int pageNumber, int pageSize) {
        User user = getUser(id);
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

    @Override
    public RecipeDTO craftRecipe(Long id, RecipeCreateDTO recipeCreateDTO) {
        User user = getUser(id);
        List<Ingredient> ingredients = new ArrayList<>();
        for (Long ingredientId : recipeCreateDTO.getIngredientsID()) {
            Ingredient ingredient = ingredientRepository.findById(ingredientId).orElseThrow(IngredientNotFoundException::new);
            ingredients.add(ingredient);
        }
        Recipe recipe = Recipe.builder()
                .name(recipeCreateDTO.getName())
                .description(recipeCreateDTO.getDescription())
                .urlImage(recipeCreateDTO.getImageUrl())
                .user(user)
                .ingredients(ingredients)
                .likes(new ArrayList<>())
                .build();
        recipeRepository.save(recipe);
        userRepository.save(user);
        ingredients.forEach(ingredient ->  {
            ingredient.getRecipes().add(recipe);
            ingredientRepository.save(ingredient);
        });
        return RecipeDTO.builder()
                .id(recipe.getId())
                .name(recipe.getName())
                .description(recipe.getDescription())
                .ingredients(mapIngredients(recipe.getIngredients()))
                .imageUrl(recipe.getUrlImage())
                .build();
    }

    @Override
    public Boolean addToFavourites(Long userId, Long recipeId) {
        User user = getUser(userId);
        Recipe recipe = recipeRepository.findById(recipeId).orElseThrow(RecipeNotFoundException::new);
        if (user.getFavouritesRecipes().contains(recipe)) {
            throw new RecipeAlreadyLikedException();
        }
        user.getFavouritesRecipes().add(recipe);
        recipe.getLikes().add(user);
        userRepository.save(user);
        recipeRepository.save(recipe);
        return true;
    }

    @Override
    public Page<RecipeDTO> getFavouritesRecipes(Long userId, int pageNumber, int pageSize) {
        User user = getUser(userId);
        Page<Recipe> recipes = recipeRepository
                .findAllByLikesContaining(user, PageRequest.of(pageNumber, pageSize, Sort.unsorted()));
        List<RecipeDTO> recipeDTOS = mapRecipes(recipes);
        return new PageImpl<>(recipeDTOS);
    }

    @Override
    public void removeRecipeFromFavourites(Long userId, Long recipeId) {
        User user = getUser(userId);
        Recipe recipe = recipeRepository.findById(recipeId).orElseThrow(RecipeNotFoundException::new);
        if (!user.getFavouritesRecipes().contains(recipe)) {
            throw new RecipeNotFoundException();
        }
        user.getFavouritesRecipes().remove(recipe);
        recipe.getLikes().remove(user);
        userRepository.save(user);
        recipeRepository.save(recipe);
    }

    @Override
    public void deleteRecipe(Long userId, Long recipeId) {
        User user = getUser(userId);
        Recipe recipe = recipeRepository.findById(recipeId).orElseThrow(RecipeNotFoundException::new);
        if (!user.getMyRecipes().contains(recipe)) {
            throw new RecipeNotFoundException();
        }
        user.getMyRecipes().remove(recipe);
        recipe.getLikes().remove(user);
        recipeRepository.delete(recipe);
        userRepository.save(user);
    }

    @Override
    public Page<RecipeDTO> searchRecipes(IngredientsRequestDTO ingredientsRequestDTO, int pageNumber, int pageSize) {
        Pageable pageable = PageRequest.of(pageNumber, pageSize);
        List<Long> ingredientsIdList = Arrays.asList(ingredientsRequestDTO.getIngredientsID());

        Page<Recipe> recipes = recipeRepository.findByIngredientsContaining(ingredientsIdList, ingredientsIdList.size(), pageable);

        List<RecipeDTO> recipeDTOS = mapRecipes(recipes);
        return new PageImpl<>(recipeDTOS);
    }

    private User getUser(Long userId) {
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);
        if (!user.getIsActive()) {
            throw new UserInactiveException();
        }
        return user;
    }

    private List<IngredientDTO> mapIngredients(List<Ingredient> ingredients) {
        return ingredients
                .stream()
                .map(ingredient -> new IngredientDTO(ingredient.getId(), ingredient.getName(), ingredient.getUrlImage()))
                .toList();
    }

    private List<RecipeDTO> mapRecipes(Page<Recipe> recipes) {
        List<RecipeDTO> recipeDTOS = new ArrayList<>();
        recipes
                .stream()
                .map(recipe -> RecipeDTO.builder()
                        .id(recipe.getId())
                        .name(recipe.getName())
                        .description(recipe.getDescription())
                        .ingredients(mapIngredients(recipe.getIngredients()))
                        .imageUrl(recipe.getUrlImage())
                        .likes(recipe.getLikes()
                                .stream()
                                .map(like -> LikeDTO.builder()
                                                    .id(like.getId())
                                                    .username(like.getUsername())
                                                    .build())
                                .toList()
                        )
                        .build())
                .forEach(recipeDTOS::add);
        return recipeDTOS;
    }
}
