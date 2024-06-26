package ic.project.bytebistro.culinarycraft.repository.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class IngredientDTO {
    private Long id;
    private String name;
    private String imageUrl;
}
