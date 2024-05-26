package ic.project.bytebistro.culinarycraft.service.implementation;

import ic.project.bytebistro.culinarycraft.exception.*;
import ic.project.bytebistro.culinarycraft.repository.ImageRepository;
import ic.project.bytebistro.culinarycraft.repository.IngredientRepository;
import ic.project.bytebistro.culinarycraft.repository.RecipeRepository;
import ic.project.bytebistro.culinarycraft.repository.UserRepository;
import ic.project.bytebistro.culinarycraft.repository.dto.request.IngredientsRequestDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.request.RecipeCreateDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.ImageUploadResponse;
import ic.project.bytebistro.culinarycraft.repository.dto.response.IngredientDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.LikeDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.RecipeDTO;
import ic.project.bytebistro.culinarycraft.repository.entity.Image;
import ic.project.bytebistro.culinarycraft.repository.entity.Ingredient;
import ic.project.bytebistro.culinarycraft.repository.entity.Recipe;
import ic.project.bytebistro.culinarycraft.repository.entity.User;
import ic.project.bytebistro.culinarycraft.service.RecipeService;
import ic.project.bytebistro.culinarycraft.utils.ImageUtils;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Service
public class RecipeServiceImpl implements RecipeService {

    private final RecipeRepository recipeRepository;

    private final UserRepository userRepository;

    private final IngredientRepository ingredientRepository;

    private final ImageRepository imageRepository;

    private final ModelMapper modelMapper;

    public RecipeServiceImpl(RecipeRepository recipeRepository, UserRepository userRepository, IngredientRepository ingredientRepository, ImageRepository imageRepository, ModelMapper modelMapper) {
        this.recipeRepository = recipeRepository;
        this.userRepository = userRepository;
        this.ingredientRepository = ingredientRepository;
        this.imageRepository = imageRepository;
        this.modelMapper = modelMapper;
    }

    @Override
    public RecipeDTO getRecipeById(Long id) {
        return modelMapper.map(recipeRepository.findById(id).orElseThrow(RecipeNotFoundException::new), RecipeDTO.class);
    }

    @Override
    public List<RecipeDTO> getAllRecipeByUserId(Long id) {
        User user = getUser(id);
        Type listType = new TypeToken<List<RecipeDTO>>() {
        }.getType();
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
        ingredients.forEach(ingredient -> {
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

    @Override
    public RecipeDTO craftRecipe2(Long id, String name, String description, Long[] ingredientsID, MultipartFile file) throws IOException {
        User user = getUser(id);
        List<Ingredient> ingredients = new ArrayList<>();
        for (Long ingredientId : ingredientsID) {
            Ingredient ingredient = ingredientRepository.findById(ingredientId).orElseThrow(IngredientNotFoundException::new);
            ingredients.add(ingredient);
        }
        Image image = Image.builder()
                .name(file.getOriginalFilename())
                .type(file.getContentType())
                .imageData(ImageUtils.compressImage(file.getBytes()))
                .recipe(new Recipe())
                .build();
        Recipe recipe = Recipe.builder()
                .user(user)
                .name(name)
                .description(description)
                .likes(new ArrayList<>())
                .ingredients(ingredients)
                .image(image)
                .build();
        image.setRecipe(recipe);
        recipeRepository.save(recipe);
        imageRepository.save(image);
        userRepository.save(user);
        ingredients.forEach(ingredient -> {
            ingredient.getRecipes().add(recipe);
            ingredientRepository.save(ingredient);
        });
        return RecipeDTO.builder()
                .id(recipe.getId())
                .name(recipe.getName())
                .description(recipe.getDescription())
                .ingredients(mapIngredients(recipe.getIngredients()))
                .imageUrl(recipe.getUrlImage())
                .imageData(image.getImageData())
                .build();
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
                        .imageData(getImageData(recipe))
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

    private byte[] getImageData(Recipe recipe) {
        if (recipe.getImage() == null) {
            return new byte[0];
        }
        return recipe.getImage().getImageData();
    }
}
