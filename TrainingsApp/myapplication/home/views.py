from django.shortcuts import render
from django.http import HttpResponse
import datetime

TEMPLATE_DIRS = (
    'os.path.join(BASE_DIR, "templates"),'
)

def index(request):
    today = datetime.datetime.now().date()
    return render(request, "index.html", {"today": today})

def create_athlete(request):
    return render(request, "create_athlete.html")

def create_training(request):
    return render(request, "create_training.html")

def create_training_data(request):
    return render(request, "create_training_data.html")

# Create your views here.
