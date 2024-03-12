package ic.project.bytebistro.culinarycraft.service.implementation;

import ic.project.bytebistro.culinarycraft.exception.UserNotFoundException;
import ic.project.bytebistro.culinarycraft.repository.UserRepository;
import ic.project.bytebistro.culinarycraft.repository.dto.UserDTO;
import ic.project.bytebistro.culinarycraft.repository.entity.User;
import ic.project.bytebistro.culinarycraft.service.UserService;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final ModelMapper modelMapper;

    public UserServiceImpl(UserRepository userRepository, ModelMapper modelMapper) {
        this.userRepository = userRepository;
        this.modelMapper = modelMapper;
    }

    @Override
    public UserDTO create(User user) {
        return modelMapper.map(userRepository.save(user), UserDTO.class);
    }

    @Override
    public UserDTO read(Long id) {
        return modelMapper.map(userRepository.findById(id).orElseThrow(UserNotFoundException::new), UserDTO.class);
    }
}
