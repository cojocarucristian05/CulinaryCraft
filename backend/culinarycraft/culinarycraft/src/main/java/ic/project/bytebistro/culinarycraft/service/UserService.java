package ic.project.bytebistro.culinarycraft.service;

import ic.project.bytebistro.culinarycraft.repository.dto.request.UserLoginRequestDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.request.UserLoginWithGoogleOrFacebookDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.request.UserRegisterRequestDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.ForgotPasswordDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.RecipeDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.UserResponseDTO;
import ic.project.bytebistro.culinarycraft.repository.entity.LoginType;
import ic.project.bytebistro.culinarycraft.repository.entity.Recipe;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

public interface UserService {
    UserResponseDTO create(UserRegisterRequestDTO userRegisterRequestDTO);

    UserResponseDTO login(UserLoginRequestDTO userLoginRequestDTO);

    ForgotPasswordDTO forgotPassword(String email);

    UserResponseDTO signInWithGoogleOrFacebook(UserLoginWithGoogleOrFacebookDTO userLoginWithGoogleOrFacebookDTO, LoginType loginType);

    void verifySecurityCode(Long userId, Long securityCode);

    void changePassword(Long userId, String newPassword);

    RecipeDTO createRecipe(Long userId, LoginType loginType, Recipe recipe);

    List<RecipeDTO> getMyRecipes(Long userId, LoginType loginType);

    RecipeDTO createRecipe(Long userId, LoginType loginType, String name, String description, MultipartFile file) throws IOException;
}
