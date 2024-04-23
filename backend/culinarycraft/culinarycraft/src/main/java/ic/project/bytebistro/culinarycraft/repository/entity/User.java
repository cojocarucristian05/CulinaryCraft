package ic.project.bytebistro.culinarycraft.repository.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Data
@NoArgsConstructor
@Table(name = "\"user\"")
@AllArgsConstructor
@Builder
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "user_id")
    private Long id;

    @NonNull
    @Column(name = "username")
    private String username;

    @NonNull
    @Column(name = "email")
    private String email;

    @NonNull
    @Column(name = "password")
    private String password;

    @Column(name = "code")
    private Long code;

    @Column(name = "login_type")
    LoginType loginType;

    @OneToMany(fetch = FetchType.EAGER, mappedBy = "user")
    private List<Recipe> myRecipes;

}
