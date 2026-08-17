package com.hs.keycloak.auth;

import java.util.List;
import java.util.Objects;

import org.keycloak.models.RealmModel;
import org.keycloak.models.UserModel;
import org.keycloak.provider.ConfiguredProvider;
import org.keycloak.provider.ProviderConfigProperty;
import org.keycloak.userprofile.UserProfileAttributeValidationContext;
import org.keycloak.validate.SimpleValidator;
import org.keycloak.validate.ValidationContext;
import org.keycloak.validate.ValidationError;
import org.keycloak.validate.ValidatorConfig;

import jakarta.ws.rs.core.Response;

public final class UniquePhoneNumberValidator implements SimpleValidator, ConfiguredProvider {

    public static final String ID = "unique-phone-number";
    public static final String ERROR_MESSAGE = "error-phone-number-already-exists";

    @Override
    public String getId() {
        return ID;
    }

    @Override
    public String getHelpText() {
        return "Ensures that the phone number is not assigned to another user in the realm.";
    }

    @Override
    public List<ProviderConfigProperty> getConfigProperties() {
        return List.of();
    }

    @Override
    public ValidationContext validate(
            Object input,
            String inputHint,
            ValidationContext context,
            ValidatorConfig config) {
        if (!(input instanceof List<?> values) || values.isEmpty() || values.get(0) == null) {
            return context;
        }

        String phoneNumber = values.get(0).toString().trim();
        if (phoneNumber.isEmpty()) {
            return context;
        }

        UserModel currentUser = UserProfileAttributeValidationContext.from(context)
                .getAttributeContext()
                .getUser();

        if (currentUser != null
                && Objects.equals(currentUser.getFirstAttribute(inputHint), phoneNumber)) {
            return context;
        }

        RealmModel realm = context.getSession().getContext().getRealm();
        boolean duplicate = context.getSession().users()
                .searchForUserByUserAttributeStream(realm, inputHint, phoneNumber)
                .anyMatch(user -> currentUser == null || !user.getId().equals(currentUser.getId()));

        if (duplicate) {
            context.addError(new ValidationError(ID, inputHint, ERROR_MESSAGE)
                    .setStatusCode(Response.Status.CONFLICT));
        }

        return context;
    }
}
