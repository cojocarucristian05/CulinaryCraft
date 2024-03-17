package ic.project.bytebistro.culinarycraft.service.implementation;

import ic.project.bytebistro.culinarycraft.exception.UserAlreadyExistException;
import ic.project.bytebistro.culinarycraft.repository.UserRepository;
import ic.project.bytebistro.culinarycraft.repository.entity.UserRegisterDTO;
import ic.project.bytebistro.culinarycraft.service.UserService;
import org.modelmapper.ModelMapper;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Service;

import java.util.Arrays;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final ModelMapper modelMapper;

    public UserServiceImpl(UserRepository userRepository, ModelMapper modelMapper) {
        this.userRepository = userRepository;
        this.modelMapper = modelMapper;
    }

    @Override
    public User registerNewUserAccount(UserRegisterDTO userRegisterDTO) {
        if (emailExists(userRegisterDTO.getEmail())) {
            throw new UserAlreadyExistException("There is an account with that email address: "
                    + userRegisterDTO.getEmail());
        }

        User user = new User(userRegisterDTO.getUsername(),
                userRegisterDTO.getEmail(),
                Arrays.asList(  new SimpleGrantedAuthority("ROLE_USER"),
                        new SimpleGrantedAuthority("ROLE_ADMIN")
                )
        );

        userRepository.save(userRegisterDTO);
        return user;
    }

    @Override
    public void create(UserRegisterDTO userRegisterDTO) {
        if (emailExists(userRegisterDTO.getEmail()) || usernameExists(userRegisterDTO.getUsername())) {
            throw new UserAlreadyExistException();
        }
        userRepository.save(userRegisterDTO);
    }

    private boolean usernameExists(String username) {
        return userRepository.findByUsername(username) != null;
    }

    private boolean emailExists(String email) { return userRepository.findByEmail(email) != null; }
}
