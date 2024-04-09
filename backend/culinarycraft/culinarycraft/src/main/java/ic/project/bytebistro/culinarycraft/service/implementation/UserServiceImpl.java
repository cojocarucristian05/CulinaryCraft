package ic.project.bytebistro.culinarycraft.service.implementation;

import ic.project.bytebistro.culinarycraft.exception.InvalidSecurityCodeException;
import ic.project.bytebistro.culinarycraft.exception.UserAlreadyExistException;
import ic.project.bytebistro.culinarycraft.exception.UserNotFoundException;
import ic.project.bytebistro.culinarycraft.exception.UserUnauthorizedException;
import ic.project.bytebistro.culinarycraft.repository.ImageRepository;
import ic.project.bytebistro.culinarycraft.repository.IngredientRepository;
import ic.project.bytebistro.culinarycraft.repository.RecipeRepository;
import ic.project.bytebistro.culinarycraft.repository.UserRepository;
import ic.project.bytebistro.culinarycraft.repository.dto.request.UserLoginRequestDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.request.UserLoginWithGoogleOrFacebookDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.request.UserRegisterRequestDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.ImageDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.RecipeDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.UserResponseDTO;
import ic.project.bytebistro.culinarycraft.repository.entity.Image;
import ic.project.bytebistro.culinarycraft.repository.entity.LoginType;
import ic.project.bytebistro.culinarycraft.repository.entity.Recipe;
import ic.project.bytebistro.culinarycraft.repository.entity.User;
import ic.project.bytebistro.culinarycraft.service.UserService;
import ic.project.bytebistro.culinarycraft.utils.ImageUtil;
import jakarta.annotation.PostConstruct;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.List;
import java.util.Random;

import static ic.project.bytebistro.culinarycraft.utils.PasswordGenerator.generatePassword;
import static ic.project.bytebistro.culinarycraft.utils.PasswordGenerator.hashPassword;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final RecipeRepository recipeRepository;
    private final IngredientRepository ingredientRepository;
    private final ImageRepository imageRepository;
    private final ModelMapper modelMapper;

    public UserServiceImpl(UserRepository userRepository,
                           RecipeRepository recipeRepository,
                           IngredientRepository ingredientRepository,
                           ImageRepository imageRepository, ModelMapper modelMapper) {
        this.userRepository = userRepository;
        this.recipeRepository = recipeRepository;
        this.ingredientRepository = ingredientRepository;
        this.imageRepository = imageRepository;
        this.modelMapper = modelMapper;
    }

    @Override
    public UserResponseDTO create(UserRegisterRequestDTO userRegisterRequestDTO) {
        User savedUser = userRepository.findByEmailAndLoginType(userRegisterRequestDTO.getEmail(), LoginType.USERNAME_PASSWORD);
        if (savedUser != null ) {
            throw new UserAlreadyExistException();
        }
        User user = modelMapper.map(userRegisterRequestDTO, User.class);
        user.setLoginType(LoginType.USERNAME_PASSWORD);
        return modelMapper.map(userRepository.save(user), UserResponseDTO.class);
    }

    @Override
    public UserResponseDTO login(UserLoginRequestDTO userLoginRequestDTO) {
        User user = userRepository.findByUsername(userLoginRequestDTO.getUsername());
        if (user != null) {
            if (user.getPassword().equals(userLoginRequestDTO.getPassword())) {
                return modelMapper.map(user, UserResponseDTO.class);
            } else {
                throw new UserUnauthorizedException();
            }
        }
        throw new UserNotFoundException();
    }

    @Override
    public Long forgotPassword(String email) {
        User user = userRepository.findByEmail(email);
        if (user == null) {
            throw new UserNotFoundException();
        }
        Random random = new Random();
        Long code = random.nextLong(1000, 9999);
        user.setCode(code);
        userRepository.save(user);
        return code;
    }

    @Override
    public UserResponseDTO signInWithGoogleOrFacebook(UserLoginWithGoogleOrFacebookDTO userLoginWithGoogleOrFacebookDTO, LoginType loginType) {
        User user = userRepository.findByEmailAndLoginType(userLoginWithGoogleOrFacebookDTO.getEmail(), loginType);
        User newUser = modelMapper.map(userLoginWithGoogleOrFacebookDTO, User.class);
        newUser.setPassword(hashPassword(generatePassword(12)));
        newUser.setLoginType(loginType);
        if (user != null) {
            if (user.getLoginType() == loginType) {
                return modelMapper.map(user, UserResponseDTO.class);
            }
        }
        return modelMapper.map(userRepository.save(newUser), UserResponseDTO.class);
    }

    @Override
    public void verifySecurityCode(Long userId, Long securityCode) {
        User user = userRepository.findByIdAndLoginType(userId, LoginType.USERNAME_PASSWORD);
        if (user == null) {
            throw new UserNotFoundException();
        }
        if (!user.getCode().equals(securityCode)) {
            throw new InvalidSecurityCodeException();
        }
    }

    @Override
    public void changePassword(Long userId, String newPassword) {
        User user = userRepository.findByIdAndLoginType(userId, LoginType.USERNAME_PASSWORD);
        if (user == null) {
            throw new UserNotFoundException();
        }
        user.setPassword(newPassword);
        userRepository.save(user);
    }

    @Override
    public RecipeDTO createRecipe(Long userId, LoginType loginType, Recipe recipe) {
        User savedUser = userRepository.findByIdAndLoginType(userId, loginType);
        if (savedUser == null) {
            throw new UserNotFoundException();
        }
        savedUser.getMyRecipes().add(recipe);
        recipe.getIngredients()
                .forEach(ingredient -> ingredient.setRecipe(recipe));
        recipe.setUser(savedUser);
        recipeRepository.save(recipe);
        ingredientRepository.saveAll(recipe.getIngredients());
        return modelMapper.map(recipeRepository.save(recipe), RecipeDTO.class);
    }

    @Override
    public List<RecipeDTO> getMyRecipes(Long userId, LoginType loginType) {
        User savedUsed = userRepository.findByIdAndLoginType(userId, loginType);
        if (savedUsed == null) {
            throw new UserNotFoundException();
        }
        Type listType = new TypeToken<List<RecipeDTO>>(){}.getType();
        return modelMapper.map(savedUsed.getMyRecipes(), listType);
    }

    @Override
    public RecipeDTO createRecipe(Long userId, LoginType loginType, String name,
                                  String description, MultipartFile file) throws IOException {
        User savedUser = userRepository.findByIdAndLoginType(userId, loginType);
        if (savedUser == null) {
            throw new UserNotFoundException();
        }
        Image image = Image.builder()
                .name(file.getOriginalFilename())
                .type(file.getContentType())
                .imageData(ImageUtil.compressImage(file.getBytes()))
                .build();
        Recipe recipe = Recipe.builder()
                .name(name)
                .description(description)
                .user(savedUser)
                .image(image)
                .build();
        image.setRecipe(recipe);
        savedUser.getMyRecipes().add(recipe);
        recipeRepository.save(recipe);
        imageRepository.save(image);
        return modelMapper.map(recipeRepository.save(recipe), RecipeDTO.class);
    }

    private boolean usernameExists(String username) {
        return userRepository.findByUsername(username) != null;
    }

    private boolean emailExists(String email) { return userRepository.findByEmail(email) != null; }
}
