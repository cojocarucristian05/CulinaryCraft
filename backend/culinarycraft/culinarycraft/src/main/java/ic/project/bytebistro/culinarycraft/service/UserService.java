package ic.project.bytebistro.culinarycraft.service;


import org.springframework.security.core.userdetails.User;

public interface UserService {
//    UserDTO create(User user);
//
//    UserDTO read(Long id);

    User registerNewUserAccount(ic.project.bytebistro.culinarycraft.repository.entity.User userDTO);
}
