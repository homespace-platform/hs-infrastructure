package com.hs.keycloak.auth;

import java.util.List;
import java.util.regex.Pattern;

import org.keycloak.authentication.AuthenticationFlowContext;
import org.keycloak.authentication.authenticators.browser.UsernamePasswordForm;
import org.keycloak.events.Details;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.UserModel;
import org.keycloak.services.managers.AuthenticationManager;

import jakarta.ws.rs.core.MultivaluedMap;

public class PhoneUsernamePasswordForm extends UsernamePasswordForm {

    private static final String PHONE_ATTRIBUTE = "phoneNumber";
    private static final Pattern VIETNAMESE_MOBILE =
            Pattern.compile("^0(?:3[2-9]|5[689]|7[06-9]|8[1-9]|9[0-9])[0-9]{7}$");

    public PhoneUsernamePasswordForm(KeycloakSession session) {
        super(session);
    }

    @Override
    protected boolean validateForm(AuthenticationFlowContext context, MultivaluedMap<String, String> formData) {
        String identifier = formData.getFirst(AuthenticationManager.FORM_USERNAME);
        if (identifier == null || identifier.isBlank()) {
            return super.validateForm(context, formData);
        }

        identifier = identifier.trim();
        formData.putSingle(AuthenticationManager.FORM_USERNAME, identifier);

        UserModel user = resolveUser(context, identifier);
        if (user == null) {
            // Delegate failures to Keycloak so error messages and event handling do not reveal
            // whether a username, email address, or phone number exists.
            return super.validateForm(context, formData);
        }

        return validateResolvedUser(context, formData, identifier, user);
    }

    private UserModel resolveUser(AuthenticationFlowContext context, String identifier) {
        if (VIETNAMESE_MOBILE.matcher(identifier).matches()) {
            List<UserModel> matches = context.getSession().users()
                    .searchForUserByUserAttributeStream(context.getRealm(), PHONE_ATTRIBUTE, identifier)
                    .limit(2)
                    .toList();

            // Never select an arbitrary account if legacy data contains duplicate phones.
            return matches.size() == 1 ? matches.get(0) : null;
        }

        if (identifier.contains("@") && context.getRealm().isLoginWithEmailAllowed()) {
            return context.getSession().users().getUserByEmail(context.getRealm(), identifier);
        }

        return context.getSession().users().getUserByUsername(context.getRealm(), identifier);
    }

    private boolean validateResolvedUser(
            AuthenticationFlowContext context,
            MultivaluedMap<String, String> formData,
            String identifier,
            UserModel user) {
        String previousUserSetNote = context.getAuthenticationSession()
                .getAuthNote(USER_SET_BEFORE_USERNAME_PASSWORD_AUTH);

        context.getEvent().detail(Details.USERNAME, identifier);
        context.getAuthenticationSession().setAuthNote(ATTEMPTED_USERNAME, identifier);
        context.getAuthenticationSession().setAuthNote(USER_SET_BEFORE_USERNAME_PASSWORD_AUTH, "true");
        context.setUser(user);

        boolean valid = super.validateUserAndPassword(context, formData);

        if (previousUserSetNote == null) {
            context.getAuthenticationSession().removeAuthNote(USER_SET_BEFORE_USERNAME_PASSWORD_AUTH);
        } else {
            context.getAuthenticationSession().setAuthNote(
                    USER_SET_BEFORE_USERNAME_PASSWORD_AUTH,
                    previousUserSetNote);
        }

        if (!valid) {
            context.clearUser();
            return false;
        }

        processRememberMe(context, formData);
        return true;
    }

    private void processRememberMe(AuthenticationFlowContext context, MultivaluedMap<String, String> formData) {
        boolean remember = context.getRealm().isRememberMe()
                && "on".equalsIgnoreCase(formData.getFirst("rememberMe"));

        if (remember) {
            context.getAuthenticationSession().setAuthNote(Details.REMEMBER_ME, "true");
            context.getEvent().detail(Details.REMEMBER_ME, "true");
        } else {
            context.getAuthenticationSession().removeAuthNote(Details.REMEMBER_ME);
        }
    }
}
