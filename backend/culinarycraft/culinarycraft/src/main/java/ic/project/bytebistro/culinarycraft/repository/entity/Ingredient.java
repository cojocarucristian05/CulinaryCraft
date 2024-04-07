package ic.project.bytebistro.culinarycraft.repository.entity;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
public class Ingredient {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "ingredient_id")
    private Long id;

    @Column(name = "ingredient_name")
    private String name;

    //    private Image image;

    @ManyToOne
    @JoinColumn(name = "recipe_id", nullable = false)
    private Recipe recipe;
}
