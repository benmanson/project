from django import forms
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth import get_user_model

class RegistrationForm(UserCreationForm):
    email = forms.EmailField(required=True, help_text="Required. You will be required to verify before you can sign in.")

    def clean_email(self):
        """Cleans the email address according to the following criteria:
            - Emails should not contain comma's, or spaces
            - Emails should not already exist i.e. one account per person
        """
        data = self.cleaned_data["email"].strip()
        if get_user_model().objects.filter(email=data).exists():
            raise forms.ValidationError("This email address is already in use.")
        if "," in data or " " in data or "@" not in data:
            raise forms.ValidationError("This is not a valid email address.")

        return data

    def save(self, commit=True):
        user = super(RegistrationForm, self).save(commit=False)
        if commit:
            user.save()
        return user

    class Meta:
        model = get_user_model()
        fields = ("username", "email", "password1", "password2")
