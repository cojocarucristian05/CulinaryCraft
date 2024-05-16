package ic.project.bytebistro.culinarycraft.repository;

import ic.project.bytebistro.culinarycraft.repository.entity.Ingredient;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface IngredientRepository extends JpaRepository<Ingredient, Long> {
    Ingredient findByName(String ingredientName);
}
