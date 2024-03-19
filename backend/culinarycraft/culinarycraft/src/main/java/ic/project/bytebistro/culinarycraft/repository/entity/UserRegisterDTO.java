package ic.project.bytebistro.culinarycraft.repository.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.NonNull;

@Entity
@Data
@NoArgsConstructor
@Table(name = "\"user\"")
public class UserRegisterDTO {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "user_id")
    private Long id;

    @NonNull
    @Column(name = "username")
    private String username;

    @NonNull
    @Column(name = "email", unique = true)
    private String email;

    @NonNull
    @Column(name = "password")
    private String password;
}
