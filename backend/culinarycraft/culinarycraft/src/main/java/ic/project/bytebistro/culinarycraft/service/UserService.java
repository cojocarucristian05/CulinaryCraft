package ic.project.bytebistro.culinarycraft.service;

import ic.project.bytebistro.culinarycraft.repository.entity.UserRegisterDTO;

public interface UserService {
    UserRegisterDTO create(UserRegisterDTO userRegisterDTO);
}
