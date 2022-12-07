from django.shortcuts import render
from django.http import HttpResponseRedirect
from .models import Athletes
from .forms import AthletesForm

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

#def create_training(request):
   # return render(request, "create_training.html")

def create_course(request):
    return render(request, "create_training.html")

def create_training_data(request):
    return render(request, "create_training_data.html")


 #if request.method == 'POST':
        #print('Received data:', request.POST['itemName'])
        #Athletes.objects.create(Name = request.POST['itemName'])