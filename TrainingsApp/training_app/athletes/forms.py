from django import forms
from django.forms import ModelForm
from .models import Athletes
from .models import Workout
from .models import Workout_data



class AthletesForm(ModelForm):
    '''
    A class to create a form from database model 'athletes'
    ModelForm
        Django helper class to create a form from a model
    fields = '__all__'
        Is required, cause all fields of the model are needed for the model
    labels
        define the label of the specific field that is displayed
    widgets
        contain css class and placeholder if the field isn't filled
    '''
    class Meta:
        model = Athletes
        fields = '__all__'

        labels = {
            'gender': '',
            'first_name': 'Enter your first name below:',
            'last_name': 'Enter your last name below',
            'height': 'Enter your height in cm',
            'weight': 'Enter your weight in kg',
        }
       
        widgets = {
            'first_name': forms.TextInput(attrs={'class':'form-control', 'placeholder':'Jane'}),
            'last_name': forms.TextInput(attrs={'class':'form-control', 'placeholder':'Doe'}),
            'height': forms.TextInput(attrs={'class':'form-control', 'placeholder':'180'}),
            'weight': forms.TextInput(attrs={'class':'form-control', 'placeholder':'80'}),
        }

class WorkoutForm(ModelForm):
    '''
    A class to create a form from database model 'workouts'
    ModelForm
        Django helper class to create a form from a model
    fields = '__all__'
        Is required, cause all fields of the model are needed for the model
    labels
        define the label of the specific field that is displayed
    widgets
        contain css class and placeholder if the field isn't filled
    '''
    class Meta:
        model = Workout
        fields = '__all__'

        labels = {
            'designation': 'Enter your workout name',
            'description': 'Enter your description',            
        }
        
        widgets = {
            'designation': forms.TextInput(attrs={'class':'form-control', 'placeholder':'e.g. Weight Lifting'}),            
            'description': forms.TextInput(attrs={'class':'form-control', 'placeholder':'--'}),            
        }

class WorkoutDataForm(ModelForm):
    '''
    A class to create a form from database model 'workout_data'
    ModelForm
        Django helper class to create a form from a model
    fields = '__all__'
        Is required, cause all fields of the model are needed for the model
    labels
        define the label of the specific field that is displayed
    widgets
        contain css class and placeholder if the field isn't filled
    '''
    class Meta:
        model = Workout_data
        fields = '__all__'

        labels = {
            'date': 'Enter your date',
            'start': 'Enter your start time',
            'end': 'Enter your end time',
        }
       
        widgets = {
            'start': forms.TimeInput(format='hh:mm', attrs={'class':'form-control', 'placeholder':'HH:SS'}),
            'end': forms.TimeInput(format='hh:mm', attrs={'class':'form-control', 'placeholder':'HH:SS'}),
            'date': forms.DateInput(format=('%d/%m/%Y'), attrs={'class':'form-control', 'type':'date'}),
        }

         