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

        labels = {
            'designation': 'Enter Your Workout Name',
            'description': 'Enter Your Description',            
        }
        
        widgets = {
            'designation': forms.TextInput(attrs={'class':'form-control', 'placeholder':'e.g. Weight Lifting'}),            
            'description': forms.TextInput(attrs={'class':'form-control', 'placeholder':'--'}),            
        }

class WorkoutDataForm(ModelForm):
    class Meta:
        model = Workout_data
        fields = '__all__'

        labels = {
            #'workout': forms.TextInput(attrs={'class':'form-select'}),
            'pause': 'Enter your pause in minutes',
            'start': 'Enter your Start Time',
            'end': 'Enter your End Time',
            #'duration': 'Enter your Duration in minutes',
            #'date': forms.TextInput(attrs={'class':'form-control'}),
        }
       
        widgets = {
            #'workout': forms.TextInput(attrs={'class':'form-select'}),
            #'pause': forms.TextInput(attrs={'class':'form-control', 'placeholder':'5'}),
            'start': forms.TimeInput(format='hh:mm', attrs={'class':'form-control', 'placeholder':'HH:SS'}),
            'end': forms.TimeInput(format='hh:mm', attrs={'class':'form-control', 'placeholder':'HH:SS'}),
            #'duration': forms.TextInput(attrs={'class':'form-control', 'placeholder':'120'}),
            'date': forms.DateInput(format=('%d/%m/%Y'), attrs={'class':'form-control', 'type':'date'}),
        }

         