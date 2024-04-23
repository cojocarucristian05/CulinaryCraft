package ic.project.bytebistro.culinarycraft.repository.dto.response;

import lombok.Data;

import java.util.List;

@Data
public class RecipeDTO {
    private String name;
    private String description;
    private List<IngredientDTO> ingredients;
    private String imageUrl;
}
