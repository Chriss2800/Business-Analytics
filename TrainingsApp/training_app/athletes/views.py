from django.shortcuts import render, redirect
from django.http import HttpResponseRedirect
from .models import Athletes
from .models import Workout
from .models import Workout_data
from .forms import AthletesForm
from .forms import WorkoutForm
from .forms import WorkoutDataForm

### HOME ###

def index(request):
    return render(request, "home.html")

### ATHLETE ###

def create_athlete(request):
    submitted = False
    if request.method == 'POST':
        form = AthletesForm(request.POST)
        if form.is_valid():
            form.save()
            return HttpResponseRedirect('/create_athlete?submitted=True')
    else:
        form = AthletesForm
        if 'submitted' in request.GET:
            submitted = True    
    return render(request, "create_athlete.html", {'form': form, 'submitted':submitted})

def athletes_list(request):
    athletes_list = Athletes.objects.all
    return render(request, "athletes_list.html", {'athletes_list':athletes_list})

def delete_athlete(request, athlete_id):
    athlete = Athletes.objects.get(pk=athlete_id)
    athlete.delete()
    return redirect('athletes_list')

def update_athlete(request, athlete_id):
    athlete = Athletes.objects.get(pk=athlete_id)
    form = AthletesForm(request.POST or None, instance=athlete)
    if form.is_valid():
        form.save()
        return redirect('athletes_list')
    return render(request, 'update_athlete.html', {'athlete': athlete, 'form':form})

### WORKOUT ###

def create_workout(request):
    submitted = False
    if request.method == 'POST':
        form = WorkoutForm(request.POST)
        if form.is_valid():
            form.save()
            return HttpResponseRedirect('/create_workout?submitted=True')
    else:
        form = WorkoutForm
        if 'submitted' in request.GET:
            submitted = True
    return render(request, "create_workout.html", {'form': form, 'submitted':submitted})

def workout_list(request):
    workout_list = Workout.objects.all
    return render(request, "workout_list.html", {'workout_list':workout_list})

def delete_workout(request, workout_id):
    workout = Workout.objects.get(pk=workout_id)
    workout.delete()
    return redirect('workout_list')

def update_workout(request, workout_id):
    workout = Workout.objects.get(pk=workout_id)
    form = WorkoutForm(request.POST or None, instance=workout)
    if form.is_valid():
        form.save()
        return redirect('workout_list')
    return render(request, 'update_workout.html', {'workout': workout, 'form':form})

### WORKOUT DATA ###

def create_workout_data(request):
    submitted = False
    if request.method == 'POST':
        form = WorkoutDataForm(request.POST)
        if form.is_valid():
            form.save()
            return HttpResponseRedirect('/create_workout_data?submitted=True')
    else:
        form = WorkoutDataForm
        if 'submitted' in request.GET:
            submitted = True
    return render(request, "create_workout_data.html", {'form': form, 'submitted':submitted})

def workout_data_list(request):
    workout_data_list = Workout_data.objects.all
    return render(request, "workout_data_list.html", {'workout_data_list':workout_data_list})

def delete_workout_data(request, workout_data_id):
    workout_data = Workout_data.objects.get(pk=workout_data_id)
    workout_data.delete()
    return redirect('workout_data_list')

def update_workout_data(request, workout_data_id):
    workout_data = Workout_data.objects.get(pk=workout_data_id)
    form = WorkoutDataForm(request.POST or None, instance=workout_data)
    if form.is_valid():
        form.save()
        return redirect('workout_data_list')
    return render(request, 'update_workout_data.html', {'workout_data': workout_data, 'form':form})

def athletes_workout(request):
    return render(request,'athletes_workout.html')


