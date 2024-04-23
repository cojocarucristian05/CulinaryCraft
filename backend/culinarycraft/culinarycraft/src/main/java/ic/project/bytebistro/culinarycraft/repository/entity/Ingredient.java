package ic.project.bytebistro.culinarycraft.repository.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Entity
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Ingredient {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "ingredient_id")
    private Long id;

    @Column(name = "ingredient_name")
    private String name;

    @Column(name = "url_image")
    private String urlImage;

    @ManyToMany(fetch = FetchType.EAGER, mappedBy = "ingredients")
    private List<Recipe> recipes;
}
