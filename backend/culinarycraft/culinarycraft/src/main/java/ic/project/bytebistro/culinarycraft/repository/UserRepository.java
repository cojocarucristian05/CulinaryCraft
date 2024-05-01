package ic.project.bytebistro.culinarycraft.repository;

import ic.project.bytebistro.culinarycraft.repository.entity.LoginType;
import ic.project.bytebistro.culinarycraft.repository.entity.User;
import lombok.NonNull;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    User findByUsernameAndLoginType(String username, LoginType loginType);

    User findByEmail(String email);

    User findByEmailAndLoginType(@NonNull String email, LoginType loginType);

    User findByIdAndLoginType(@NonNull Long id, LoginType loginType);
}
