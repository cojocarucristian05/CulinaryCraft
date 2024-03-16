package ic.project.bytebistro.culinarycraft.repository;

import ic.project.bytebistro.culinarycraft.repository.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    User findByUsername(String username);

//    Optional<User> findByEmail(String email);
//    User findByUsername(String username);
}
