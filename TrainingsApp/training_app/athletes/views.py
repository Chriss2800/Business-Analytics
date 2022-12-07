from django.shortcuts import render
from django.http import HttpResponse

# Create your views here.

def index(request):
    return render(request, "index.html")

def create_athlete(request):
    return render(request, "create_athlete.html")

#def create_training(request):
   # return render(request, "create_training.html")

def create_course(request):
    return render(request, "create_training.html")

def create_training_data(request):
    return render(request, "create_training_data.html")
