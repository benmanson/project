from django.conf import settings
from django.contrib.sites.shortcuts import get_current_site
from django.contrib.auth import get_user_model
from django.core.mail import EmailMessage
from django.shortcuts import redirect, HttpResponse
from django.template.loader import render_to_string
from django.utils.encoding import force_bytes, force_str
from django.utils.http import urlsafe_base64_encode, urlsafe_base64_decode
from django.views.generic import CreateView

from . import forms, utils

class RegisterView(CreateView):
    form_class = forms.RegistrationForm
    template_name= 'form.html'
    success_url = '/login/'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context["form_title"] = "Register"
        context["takes_files"] = False
        return context

    def get(self, request, *args, **kwargs):
        if request.user.is_authenticated:
            return redirect("/")
        return super().get(request, *args, **kwargs)

    def post(self, request, *args, **kwargs):
        form_class = self.get_form_class()
        form = self.get_form(form_class)

        if form.is_valid():
            user = form.save(commit=False)
            user.is_active = False
            user.save()

            current_site = get_current_site(request)

            mail_subject = 'Activation link has been sent to your email'

            message = render_to_string('email_activation.html', {
                'user': user,
                'domain': "https://" + current_site.domain if not settings.DEBUG else settings.CSRF_TRUSTED_ORIGINS[0],
                'uid': urlsafe_base64_encode(force_bytes(user.pk)),
                'token': utils.account_activation_token.make_token(user),
            })

            to_email = form.cleaned_data.get('email')

            email = EmailMessage(mail_subject, message, to=[to_email])
            email.send()

            return HttpResponse('Please confirm your email address to complete the registration')

        return super().post(request, *args, **kwargs)

def activate(request, uidb64, token):
    try:
        uid = force_str(urlsafe_base64_decode(uidb64))
        user = get_user_model().objects.get(pk=uid)
    except(TypeError, ValueError, OverflowError, get_user_model().DoesNotExist):
        user = None

    if user is not None and utils.account_activation_token.check_token(user, token):
        user.is_active = True
        user.save()
        return redirect("/")
    else:
        return HttpResponse("Activation link is invalid!")
