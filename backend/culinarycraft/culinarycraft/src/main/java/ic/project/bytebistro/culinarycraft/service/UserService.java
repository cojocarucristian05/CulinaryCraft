package ic.project.bytebistro.culinarycraft.service;

import ic.project.bytebistro.culinarycraft.repository.dto.request.UserLoginRequestDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.request.UserLoginWithGoogleOrFacebookDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.request.UserRegisterRequestDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.request.UserUpdateDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.ForgotPasswordDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.RegisterResponseDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.UserResponseDTO;
import ic.project.bytebistro.culinarycraft.repository.entity.LoginType;

public interface UserService {
    RegisterResponseDTO create(UserRegisterRequestDTO userRegisterRequestDTO);

    UserResponseDTO login(UserLoginRequestDTO userLoginRequestDTO);

    ForgotPasswordDTO forgotPassword(String email);

    UserResponseDTO signInWithGoogleOrFacebook(UserLoginWithGoogleOrFacebookDTO userLoginWithGoogleOrFacebookDTO, LoginType loginType);

    void verifySecurityCode(Long userId, Long securityCode);

    void changePassword(Long userId, String newPassword);

    UserResponseDTO updateProfile(Long id, UserUpdateDTO userUpdateDTO);

    void deactivateAccount(Long id);

    String getEmail(Long id);

    String getUsername(Long id);

    void deleteAccount(Long id);
}
