from django.contrib.auth.models import AbstractUser
from django.contrib.auth.tokens import PasswordResetTokenGenerator

import six

class User(AbstractUser):
    pass
