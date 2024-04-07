package ic.project.bytebistro.culinarycraft.service.implementation;

import ic.project.bytebistro.culinarycraft.exception.InvalidSecurityCodeException;
import ic.project.bytebistro.culinarycraft.exception.UserAlreadyExistException;
import ic.project.bytebistro.culinarycraft.exception.UserNotFoundException;
import ic.project.bytebistro.culinarycraft.exception.UserUnauthorizedException;
import ic.project.bytebistro.culinarycraft.repository.UserRepository;
import ic.project.bytebistro.culinarycraft.repository.dto.request.UserLoginRequestDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.request.UserLoginWithGoogleOrFacebookDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.request.UserRegisterRequestDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.UserResponseDTO;
import ic.project.bytebistro.culinarycraft.repository.entity.LoginType;
import ic.project.bytebistro.culinarycraft.repository.entity.User;
import ic.project.bytebistro.culinarycraft.service.UserService;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.Random;

import static ic.project.bytebistro.culinarycraft.utils.PasswordGenerator.generatePassword;
import static ic.project.bytebistro.culinarycraft.utils.PasswordGenerator.hashPassword;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final ModelMapper modelMapper;

    public UserServiceImpl(UserRepository userRepository, ModelMapper modelMapper) {
        this.userRepository = userRepository;
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

    private boolean usernameExists(String username) {
        return userRepository.findByUsername(username) != null;
    }

    private boolean emailExists(String email) { return userRepository.findByEmail(email) != null; }
}
