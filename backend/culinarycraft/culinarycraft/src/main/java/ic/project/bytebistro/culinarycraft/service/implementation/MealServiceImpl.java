package ic.project.bytebistro.culinarycraft.service.implementation;

import ic.project.bytebistro.culinarycraft.repository.RecipeRepository;
import ic.project.bytebistro.culinarycraft.repository.UserRepository;
import ic.project.bytebistro.culinarycraft.repository.dto.response.RecipeDTO;
import ic.project.bytebistro.culinarycraft.repository.entity.User;
import ic.project.bytebistro.culinarycraft.service.MealService;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;

import java.lang.reflect.Type;
import java.util.List;

@Service
public class MealServiceImpl implements MealService {

    private final RecipeRepository recipeRepository;

    private final UserRepository userRepository;
    private final ModelMapper modelMapper;

    public MealServiceImpl(RecipeRepository recipeRepository, UserRepository userRepository, ModelMapper modelMapper) {
        this.recipeRepository = recipeRepository;
        this.userRepository = userRepository;
        this.modelMapper = modelMapper;
    }

    @Override
    public RecipeDTO getRecipeById(Long id) {
        return modelMapper.map(recipeRepository.findById(id).orElseThrow(RuntimeException::new), RecipeDTO.class);
    }

    @Override
    public List<RecipeDTO> getAllRecipeByUserId(Long id) {
        User user = userRepository.findById(id).orElseThrow(RuntimeException::new);
        Type listType = new TypeToken<List<RecipeDTO>>(){}.getType();
        return modelMapper.map(user.getMyRecipes(), listType);
    }
}
