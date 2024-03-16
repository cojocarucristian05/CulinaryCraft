package ic.project.bytebistro.culinarycraft.service;


import ic.project.bytebistro.culinarycraft.repository.entity.UserRegisterDTO;
import org.springframework.security.core.userdetails.User;

public interface UserService {
    User registerNewUserAccount(UserRegisterDTO userRegisterDTODTO);
}
