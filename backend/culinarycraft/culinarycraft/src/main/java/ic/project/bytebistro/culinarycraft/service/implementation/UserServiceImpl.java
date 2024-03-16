package ic.project.bytebistro.culinarycraft.service.implementation;

import ic.project.bytebistro.culinarycraft.exception.UserAlreadyExistException;
import ic.project.bytebistro.culinarycraft.exception.UserNotFoundException;
import ic.project.bytebistro.culinarycraft.repository.UserRepository;
import ic.project.bytebistro.culinarycraft.repository.dto.UserDTO;
import ic.project.bytebistro.culinarycraft.service.UserService;
import org.modelmapper.ModelMapper;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

import static java.util.Arrays.*;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final ModelMapper modelMapper;

    public UserServiceImpl(UserRepository userRepository, ModelMapper modelMapper) {
        this.userRepository = userRepository;
        this.modelMapper = modelMapper;
    }

//    @Override
//    public UserDTO create(User user) {
//        return modelMapper.map(userRepository.save(user), UserDTO.class);
//    }
//
//    @Override
//    public UserDTO read(Long id) {
//        return modelMapper.map(userRepository.findById(id).orElseThrow(UserNotFoundException::new), UserDTO.class);
//    }

    @Override
    public User registerNewUserAccount(ic.project.bytebistro.culinarycraft.repository.entity.User userDTO) {
        if (emailExists(userDTO.getUsername())) {
            throw new UserAlreadyExistException("There is an account with that email address: "
                    + userDTO.getEmail());
        }

        User user = new User(userDTO.getUsername(),
                userDTO.getEmail(),
                Arrays.asList(  new SimpleGrantedAuthority("ROLE_USER"),
                        new SimpleGrantedAuthority("ROLE_ADMIN")
                )
        );

        userRepository.save(userDTO);
        return user;
    }

    private boolean emailExists(String username) {
        return userRepository.findByUsername(username) != null;
    }
}
