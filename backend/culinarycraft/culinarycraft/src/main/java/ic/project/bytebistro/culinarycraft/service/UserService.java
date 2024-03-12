package ic.project.bytebistro.culinarycraft.service;

import ic.project.bytebistro.culinarycraft.repository.dto.UserDTO;
import ic.project.bytebistro.culinarycraft.repository.entity.User;

public interface UserService {
    UserDTO create(User user);

    UserDTO read(Long id);
}
