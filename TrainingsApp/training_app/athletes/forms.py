from django import forms
from django.forms import ModelForm
from .models import Athletes
from .models import Workout
from .models import Workout_data

#Create Athletes Form



class AthletesForm(ModelForm):
    class Meta:
        model = Athletes
        fields = '__all__'

        labels = {
            'gender': '',
            'first_name': 'Enter your First Name below:',
            'last_name': 'Enter your Last Name below',
            'height': 'Enter your height in cm',
            'weight': 'Enter your weight in kg',
            #'birth_date': forms.TextInput(attrs={'class':'form'}),
        }
       
        widgets = {
            #'gender': forms.TextInput(attrs={'class':'form-control', 'placeholder':'Gender'}),
            'first_name': forms.TextInput(attrs={'class':'form-control', 'placeholder':'Jane'}),
            'last_name': forms.TextInput(attrs={'class':'form-control', 'placeholder':'Doe'}),
            'height': forms.TextInput(attrs={'class':'form-control', 'placeholder':'180'}),
            'weight': forms.TextInput(attrs={'class':'form-control', 'placeholder':'80'}),
            #'birth_date': forms.TextInput(attrs={'class':'form'}),
        }

class WorkoutForm(ModelForm):
    class Meta:
        model = Workout
        fields = '__all__'

        widgets = {
            'description': forms.TextInput(attrs={'class':'form-control'}),            
        }

class WorkoutDataForm(ModelForm):
    class Meta:
        model = Workout_data
        fields = '__all__'
       
        widgets = {
            #'workout': forms.TextInput(attrs={'class':'form-select'}),
            'pause': forms.TextInput(attrs={'class':'form-control'}),
            'start': forms.TextInput(attrs={'class':'form-control'}),
            'end': forms.TextInput(attrs={'class':'form-control'}),
            'duration': forms.TextInput(attrs={'class':'form-control'}),
            'date': forms.TextInput(attrs={'class':'form-control'}),
        }

         