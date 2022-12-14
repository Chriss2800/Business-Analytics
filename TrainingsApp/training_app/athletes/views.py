from django.shortcuts import render
from django.http import HttpResponseRedirect
from .models import Athletes
from .forms import AthletesForm
from .forms import WorkoutForm
from .forms import WorkoutDataForm

# Create your views here.

def index(request):
    return render(request, "index.html")

def create_athlete(request):
    submitted = False
    if request.method == 'POST':
        form = AthletesForm(request.POST)
        if form.is_valid():
            form.save()
            return HttpResponseRedirect('/create_athlete/?submitted=True')
    else:
        form = AthletesForm
        if 'submitted' in request.GET:
            submitted = True    
    return render(request, "create_athlete.html", {'form': form, 'submitted':submitted})

def athletes_list(request):
    athletes_list = Athletes.objects.all
    return render(request, "athletes_list.html", {'athletes_list':athletes_list})

def create_course(request):
    submitted = False
    if request.method == 'POST':
        form = WorkoutForm(request.POST)
        if form.is_valid():
            form.save()
            return HttpResponseRedirect('/create_course/?submitted=True')
    else:
        form = WorkoutForm
        if 'submitted' in request.GET:
            submitted = True
    return render(request, "create_training.html", {'form': form, 'submitted':submitted})

def create_training_data(request):
    submitted = False
    if request.method == 'POST':
        form = WorkoutDataForm(request.POST)
        if form.is_valid():
            form.save()
            return HttpResponseRedirect('/create_training_data/?submitted=True')
    else:
        form = WorkoutDataForm
        if 'submitted' in request.GET:
            submitted = True
    return render(request, "create_training_data.html", {'form': form, 'submitted':submitted})


 #if request.method == 'POST':
        #print('Received data:', request.POST['itemName'])
        #Athletes.objects.create(Name = request.POST['itemName'])

#def create_training(request):
   # return render(request, "create_training.html")