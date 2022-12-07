from django import forms
from django.forms import ModelForm
from .models import Athletes

#Create Athletes Form

class AthletesForm(ModelForm):
    class Meta:
        model = Athletes
        fields = '__all__'