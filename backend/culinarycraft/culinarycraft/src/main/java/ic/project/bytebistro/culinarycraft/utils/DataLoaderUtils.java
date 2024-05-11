package ic.project.bytebistro.culinarycraft.utils;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import ic.project.bytebistro.culinarycraft.exception.UserNotFoundException;
import ic.project.bytebistro.culinarycraft.repository.IngredientRepository;
import ic.project.bytebistro.culinarycraft.repository.RecipeRepository;
import ic.project.bytebistro.culinarycraft.repository.UserRepository;
import ic.project.bytebistro.culinarycraft.repository.entity.Ingredient;
import ic.project.bytebistro.culinarycraft.repository.entity.LoginType;
import ic.project.bytebistro.culinarycraft.repository.entity.Recipe;
import ic.project.bytebistro.culinarycraft.repository.entity.User;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import static ic.project.bytebistro.culinarycraft.utils.PasswordGenerator.hashPassword;

@Component
public class DataLoaderUtils implements CommandLineRunner {

    private final String ADMIN_USERNAME = "admin";
    private final String ADMIN_MAIL = "culinarycraft60@gmail.com";

    @Value("${admin.password}")
    private String ADMIN_PASSWORD;
    private final UserRepository userRepository;
    private final IngredientRepository ingredientRepository;
    private final RecipeRepository recipeRepository;
    private final WebClient webClient;

    @Value("${spring.jpa.hibernate.ddl-auto}")
    private String ddlAuto;

    public DataLoaderUtils(UserRepository userRepository, IngredientRepository ingredientRepository, RecipeRepository recipeRepository, WebClient.Builder webClientBuilder) {
        this.userRepository = userRepository;
        this.ingredientRepository = ingredientRepository;
        this.recipeRepository = recipeRepository;
        this.webClient = webClientBuilder.baseUrl("https://www.themealdb.com").build();
    }

    @Override
    public void run(String... args) throws Exception {
        System.out.println(" >>>>> > > >>>>>> ddl_auto: " + ddlAuto);
        if (ddlAuto.equals("create")) {
            createUser(ADMIN_USERNAME, ADMIN_MAIL, ADMIN_PASSWORD);
            getIngredients().subscribe(
                jsonData -> {
                    try {
                        parseIngredientsJson(jsonData);
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                },
                Throwable::printStackTrace,
                () -> {
                    System.out.println("\nCOMPLETED\n".toUpperCase());
//                    fetchRecipes();
                }
            );
        }
    }

    private void fetchRecipes() {
        for(char letter = 'a' ; letter <= 'z'; letter++) {
            getRecipesByFirstLetter(letter).subscribe(
                    jsonData -> {
                        try {
                            parseRecipesJson(jsonData);
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }
                    },
                    Throwable::printStackTrace,
                    () -> System.out.println("\nCOMPLETED\n")
            );
        }
    }

    private void createUser(String username, String mail, String password) {
        User user = User.builder()
                .username(username)
                .email(mail)
                .password(hashPassword(password))
                .isActive(true)
                .loginType(LoginType.USERNAME_PASSWORD)
                .build();
        userRepository.save(user);
    }

    private void createIngredient(String ingredientName, String ingredientImageUrl) {
        Ingredient ingredient = Ingredient.builder()
                .name(ingredientName)
                .urlImage(ingredientImageUrl)
                .recipes(new ArrayList<>())
                .build();
        ingredientRepository.save(ingredient);
    }

    private void createRecipe(String recipeName,
                              String recipeDescription,
                              String recipeImageUrl,
                              List<String> ingredients) {
        User user = userRepository.findByEmailAndLoginType("culinarycraft60@gmail.com", LoginType.USERNAME_PASSWORD);
        if (user == null) {
            throw new UserNotFoundException();
        }
        Recipe recipe = Recipe.builder()
                .name(recipeName)
                .description(recipeDescription)
                .urlImage(recipeImageUrl)
                .user(user)
                .ingredients(new ArrayList<>())
                .build();
        ingredients.forEach(name -> {
            Ingredient ingredient = ingredientRepository.findByName(name);
            if (ingredient == null) {
                System.out.println(name + " not found!");
            } else {
                recipe.getIngredients().add(ingredient);
            }
        });
        recipeRepository.save(recipe);
        user.getMyRecipes().add(recipe);
        userRepository.save(user);
        ingredients.forEach(name -> {
            Ingredient ingredient = ingredientRepository.findByName(name);
            if (ingredient == null) {
                System.out.println(name + " not found!");
            } else {
                ingredient.getRecipes().add(recipe);
                ingredientRepository.save(ingredient);
            }
        });
    }

    private Mono<String> getCategories() {
        return this.webClient.get().uri("/api/json/v1/1/categories.php")
                .retrieve().bodyToMono(String.class);
    }

    private Mono<String> getRecipesByFirstLetter(char letter) {
        return this.webClient.get().uri("/api/json/v1/1/search.php?f=" + letter)
                .retrieve().bodyToMono(String.class);
    }

    private Mono<String> getIngredients() {
        return this.webClient.get().uri("/api/json/v1/1/list.php?i=list")
                .retrieve().bodyToMono(String.class);
    }

    private void parse(String value) {
        System.out.println(value);
    }

    private void parseRecipesJson(String jsonData) throws JsonProcessingException {
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode rootNode = objectMapper.readTree(jsonData);
        JsonNode recipesNode = rootNode.get("meals");
        if (recipesNode.isArray()) {
            for (JsonNode recipeNode : recipesNode) {
                String recipeName = recipeNode.get("strMeal").asText();
                String recipeDescription = recipeNode.get("strInstructions").asText();
                String recipeImageUrl = recipeNode.get("strMealThumb").asText() + "/preview";
                List<String> ingredients = new ArrayList<>();
                for (int i = 1; i <= 20; i++) {
                    String ingredient = recipeNode.get("strIngredient" + i).asText();
                    if (!ingredient.isEmpty()) {
                        ingredients.add(ingredient.toLowerCase());
                    }
                }
                createRecipe(recipeName, recipeDescription, recipeImageUrl, ingredients);
            }
        }
    }

    private void parseIngredientsJson(String jsonData) throws JsonProcessingException {
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode rootNode = objectMapper.readTree(jsonData);
        JsonNode ingredientsNode = rootNode.get("meals");
        if (ingredientsNode.isArray()) {
            for (JsonNode ingredientNode : ingredientsNode) {
                String ingredientName = ingredientNode.get("strIngredient").asText();
                String ingredientImageUrl = "www.themealdb.com/images/ingredients/" + ingredientName + ".png";
                createIngredient(ingredientName.toLowerCase(), ingredientImageUrl);
            }
        }
    }
}
