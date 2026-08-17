package com.hs.keycloak.auth;

import java.util.Collections;
import java.util.List;
import java.util.Set;

import org.keycloak.Config;
import org.keycloak.authentication.Authenticator;
import org.keycloak.authentication.AuthenticatorFactory;
import org.keycloak.models.AuthenticationExecutionModel;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.KeycloakSessionFactory;
import org.keycloak.models.credential.PasswordCredentialModel;
import org.keycloak.provider.ProviderConfigProperty;

public class PhoneUsernamePasswordFormFactory implements AuthenticatorFactory {

    // Keycloak stores authenticator provider IDs in AUTHENTICATION_EXECUTION.AUTHENTICATOR,
    // which is limited to 36 characters.
    public static final String PROVIDER_ID = "hs-phone-username-password";
    private static final AuthenticationExecutionModel.Requirement[] REQUIREMENTS = {
            AuthenticationExecutionModel.Requirement.REQUIRED
    };

    @Override
    public Authenticator create(KeycloakSession session) {
        return new PhoneUsernamePasswordForm(session);
    }

    @Override
    public String getId() {
        return PROVIDER_ID;
    }

    @Override
    public String getDisplayType() {
        return "HomeSpace Phone, Email or Username Password Form";
    }

    @Override
    public String getHelpText() {
        return "Authenticates with a Vietnamese phone number, email address, or username and password.";
    }

    @Override
    public String getReferenceCategory() {
        return PasswordCredentialModel.TYPE;
    }

    @Override
    public boolean isConfigurable() {
        return false;
    }

    @Override
    public AuthenticationExecutionModel.Requirement[] getRequirementChoices() {
        return REQUIREMENTS;
    }

    @Override
    public boolean isUserSetupAllowed() {
        return false;
    }

    @Override
    public List<ProviderConfigProperty> getConfigProperties() {
        return Collections.emptyList();
    }

    @Override
    public Set<String> getOptionalReferenceCategories(KeycloakSession session) {
        return Collections.emptySet();
    }

    @Override
    public void init(Config.Scope config) {
    }

    @Override
    public void postInit(KeycloakSessionFactory factory) {
    }

    @Override
    public void close() {
    }
}
