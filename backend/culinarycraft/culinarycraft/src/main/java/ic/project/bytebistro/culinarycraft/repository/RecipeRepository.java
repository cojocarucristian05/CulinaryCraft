package ic.project.bytebistro.culinarycraft.repository;

import ic.project.bytebistro.culinarycraft.repository.entity.Recipe;
import ic.project.bytebistro.culinarycraft.repository.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RecipeRepository extends JpaRepository<Recipe, Long> {
    Page<Recipe> findAllByUser(User user, Pageable pageable);
    Page<Recipe> findAllByLikesContaining(User user, Pageable pageable);

    @Query("SELECT r FROM Recipe r JOIN r.ingredients i WHERE i.id IN :ingredientsID GROUP BY r HAVING COUNT(DISTINCT i.id) = :size")
    Page<Recipe> findByIngredientsContaining(@Param("ingredientsID") List<Long> ingredientsID, @Param("size") long size, Pageable pageable);
}
