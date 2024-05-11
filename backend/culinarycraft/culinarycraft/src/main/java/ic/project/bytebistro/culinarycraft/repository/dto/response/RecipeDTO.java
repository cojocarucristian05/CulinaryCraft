package ic.project.bytebistro.culinarycraft.repository.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class RecipeDTO {
    private Long id;
    private String name;
    private String description;
    private List<IngredientDTO> ingredients;
    private String imageUrl;
}
