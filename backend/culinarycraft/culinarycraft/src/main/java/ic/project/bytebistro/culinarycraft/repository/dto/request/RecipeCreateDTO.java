package ic.project.bytebistro.culinarycraft.repository.dto.request;

import lombok.Data;

@Data
public class RecipeCreateDTO {
    private String name;
    private String description;
    private String imageUrl;
    private Long[] ingredientsID;
}
