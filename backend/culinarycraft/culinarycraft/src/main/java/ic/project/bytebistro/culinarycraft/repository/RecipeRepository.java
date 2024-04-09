package ic.project.bytebistro.culinarycraft.repository;

import ic.project.bytebistro.culinarycraft.repository.entity.Recipe;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RecipeRepository extends JpaRepository<Recipe, Long> {
}
