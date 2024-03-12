package ic.project.bytebistro.culinarycraft.service.implementation;

import ic.project.bytebistro.culinarycraft.repository.UserRepository;
import ic.project.bytebistro.culinarycraft.repository.entity.GoogleUserInfo;
import ic.project.bytebistro.culinarycraft.repository.entity.User;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.oauth2.client.oidc.userinfo.OidcUserRequest;
import org.springframework.security.oauth2.client.oidc.userinfo.OidcUserService;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.oidc.user.OidcUser;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class CustomOidcUserService extends OidcUserService {

    private final UserRepository userRepository;

    public CustomOidcUserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

//    @Override
//    public OidcUser loadUser(OidcUserRequest userRequest) throws OAuth2AuthenticationException {
//        OidcUser oidcUser = super.loadUser(userRequest);
//
//        try {
//            return processOidcUser(userRequest, oidcUser);
//        } catch (Exception ex) {
//            throw new InternalAuthenticationServiceException(ex.getMessage(), ex.getCause());
//        }
//    }
//
//    private OidcUser processOidcUser(OidcUserRequest userRequest, OidcUser oidcUser) {
//        GoogleUserInfo googleUserInfo = new GoogleUserInfo(oidcUser.getAttributes());
//        Optional<User> userOptional = userRepository.findByEmail(googleUserInfo.getEmail());
//        if (!userOptional.isPresent()) {
//            User user = new User();
//            user.setEmail(googleUserInfo.getEmail());
//            user.setName(googleUserInfo.getName());
//
//            // set other needed data
//
//            userRepository.save(user);
//        }
//
//        return oidcUser;
//    }
}