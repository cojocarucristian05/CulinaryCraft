package ic.project.bytebistro.culinarycraft.service;

import ic.project.bytebistro.culinarycraft.repository.dto.request.UserLoginRequestDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.request.UserLoginWithGoogleOrFacebookDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.request.UserRegisterRequestDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.UserResponseDTO;
import ic.project.bytebistro.culinarycraft.repository.entity.LoginType;

public interface UserService {
    UserResponseDTO create(UserRegisterRequestDTO userRegisterRequestDTO);

    UserResponseDTO login(UserLoginRequestDTO userLoginRequestDTO);

    Long forgotPassword(String email);

    UserResponseDTO signInWithGoogleOrFacebook(UserLoginWithGoogleOrFacebookDTO userLoginWithGoogleOrFacebookDTO, LoginType loginType);

    void verifySecurityCode(Long userId, Long securityCode);

    void changePassword(Long userId, String newPassword);
}
