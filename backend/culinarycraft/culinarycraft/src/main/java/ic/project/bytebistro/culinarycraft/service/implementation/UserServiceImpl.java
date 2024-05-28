package ic.project.bytebistro.culinarycraft.service.implementation;

import ic.project.bytebistro.culinarycraft.exception.*;
import ic.project.bytebistro.culinarycraft.repository.IngredientRepository;
import ic.project.bytebistro.culinarycraft.repository.RecipeRepository;
import ic.project.bytebistro.culinarycraft.repository.UserRepository;
import ic.project.bytebistro.culinarycraft.repository.dto.request.UserLoginRequestDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.request.UserLoginWithGoogleOrFacebookDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.request.UserRegisterRequestDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.request.UserUpdateDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.ForgotPasswordDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.RecipeDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.RegisterResponseDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.UserResponseDTO;
import ic.project.bytebistro.culinarycraft.repository.entity.LoginType;
import ic.project.bytebistro.culinarycraft.repository.entity.Recipe;
import ic.project.bytebistro.culinarycraft.repository.entity.User;
import ic.project.bytebistro.culinarycraft.service.UserService;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import static ic.project.bytebistro.culinarycraft.utils.PasswordGenerator.generatePassword;
import static ic.project.bytebistro.culinarycraft.utils.PasswordGenerator.hashPassword;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final ModelMapper modelMapper;

    public UserServiceImpl(UserRepository userRepository,
                           ModelMapper modelMapper) {
        this.userRepository = userRepository;
        this.modelMapper = modelMapper;
    }

    @Override
    public RegisterResponseDTO create(UserRegisterRequestDTO userRegisterRequestDTO) {
        User savedUser = userRepository.findByEmailAndLoginType(userRegisterRequestDTO.getEmail(), LoginType.USERNAME_PASSWORD);
        RegisterResponseDTO registerResponseDTO;
        if (savedUser != null ) {
            if (savedUser.getIsActive()) {
                throw new UserAlreadyExistException();
            } else {
                savedUser.setUsername(userRegisterRequestDTO.getUsername());
                savedUser.setPassword(userRegisterRequestDTO.getPassword());
                savedUser.setIsActive(true);
                registerResponseDTO = modelMapper.map(userRepository.save(savedUser), RegisterResponseDTO.class);
                registerResponseDTO.setIsReactivated(true);
                return registerResponseDTO;
            }
        }
        User user = modelMapper.map(userRegisterRequestDTO, User.class);
        user.setLoginType(LoginType.USERNAME_PASSWORD);
        user.setIsActive(true);
        user.setFavouritesRecipes(new ArrayList<>());
        user.setMyRecipes(new ArrayList<>());
        registerResponseDTO = modelMapper.map(userRepository.save(user), RegisterResponseDTO.class);
        registerResponseDTO.setIsReactivated(false);
        return registerResponseDTO;
    }

    @Override
    public UserResponseDTO login(UserLoginRequestDTO userLoginRequestDTO) {
        User user = userRepository.findByUsernameAndLoginType(userLoginRequestDTO.getUsername(), LoginType.USERNAME_PASSWORD);
        if (user != null) {
            if (!user.getIsActive()) {
                throw new UserInactiveException();
            }
            if (user.getPassword().equals(userLoginRequestDTO.getPassword())) {
                return modelMapper.map(user, UserResponseDTO.class);
            } else {
                throw new UserUnauthorizedException();
            }
        }
        throw new UserNotFoundException();
    }

    @Override
    public ForgotPasswordDTO forgotPassword(String email) {
        User user = userRepository.findByEmailAndLoginType(email, LoginType.USERNAME_PASSWORD);
        if (user == null) {
            throw new UserNotFoundException();
        }
        Random random = new Random();
        Long code = random.nextLong(1000, 9999);
        user.setCode(code);
        userRepository.save(user);
        ForgotPasswordDTO forgotPasswordDTO = new ForgotPasswordDTO();
        forgotPasswordDTO.setUserId(user.getId());
        forgotPasswordDTO.setSecurityCode(code);
        return forgotPasswordDTO;
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
    public UserResponseDTO updateProfile(Long id, UserUpdateDTO userUpdateDTO) {
        User user = userRepository.findById(id).orElseThrow(UserNotFoundException::new);
        if (userUpdateDTO.getUsername() != null) {
            user.setUsername(userUpdateDTO.getUsername());
        }
        return modelMapper.map(userRepository.save(user), UserResponseDTO.class);
    }

    @Override
    public void deactivateAccount(Long id) {
        User user = userRepository.findById(id).orElseThrow(UserNotFoundException::new);
        user.setIsActive(false);
        userRepository.save(user);
    }

    @Override
    public void deleteAccount(Long id) {
        User user = userRepository.findById(id).orElseThrow(UserNotFoundException::new);
        for(Recipe r:user.getMyRecipes()){
            for (User u : r.getLikes()) {
                u.getFavouritesRecipes().remove(r);
                userRepository.save(u);
            }
        }
        userRepository.delete(user);
    }

    @Override
    public String getEmail(Long id) {
        User user = userRepository.findById(id).orElseThrow(UserNotFoundException::new);
        return user.getEmail();
    }

    @Override
    public String getUsername(Long id) {
        User user = userRepository.findById(id).orElseThrow(UserNotFoundException::new);
        return user.getUsername();
    }

}
