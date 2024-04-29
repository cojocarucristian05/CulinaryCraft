package ic.project.bytebistro.culinarycraft.service.implementation;

import ic.project.bytebistro.culinarycraft.repository.IngredientRepository;
import ic.project.bytebistro.culinarycraft.repository.dto.response.IngredientDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.RecipeDTO;
import ic.project.bytebistro.culinarycraft.service.IngredientService;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

@Service
public class IngredientServiceImpl implements IngredientService {
    private final IngredientRepository ingredientRepository;

    public IngredientServiceImpl(IngredientRepository ingredientRepository) {
        this.ingredientRepository = ingredientRepository;
    }

    @Override
    public Page<IngredientDTO> getIngredients(int pageNumber, int pageSize) {
        List<IngredientDTO> ingredientsDTO = new ArrayList<>();
        ingredientRepository
                .findAll(PageRequest.of(pageNumber, pageSize, Sort.unsorted()))
                .stream()
                .map(ingredient -> new IngredientDTO(ingredient.getName(), ingredient.getUrlImage()))
                .forEach(ingredientsDTO::add);
        return new PageImpl<>(ingredientsDTO);
    }

    @Override
    public Page<IngredientDTO> getIngredientsSortedByName(int pageNumber, int pageSize) {
        return getIngredientsHelper(pageNumber, pageSize, Sort.Direction.ASC, "name");
    }

    @Override
    public Page<IngredientDTO> getIngredientsSortedByNameDescending(int pageNumber, int pageSize) {
        return getIngredientsHelper(pageNumber, pageSize, Sort.Direction.DESC, "name");
    }

    private Page<IngredientDTO> getIngredientsHelper(int pageNumber, int pageSize, Sort.Direction direction, String ... properties) {
        List<IngredientDTO> ingredientsDTO = new ArrayList<>();
        ingredientRepository
                .findAll(PageRequest.of(pageNumber, pageSize, Sort.by(direction, properties)))
                .stream()
                .map(ingredient -> new IngredientDTO(ingredient.getName(), ingredient.getUrlImage()))
                .forEach(ingredientsDTO::add);
        return new PageImpl<>(ingredientsDTO);
    }
}
