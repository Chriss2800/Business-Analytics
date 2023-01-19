from django.shortcuts import render, redirect
from django.http import HttpResponseRedirect
from django.contrib import messages
from .models import Athletes
from .models import Workout
from .models import Workout_data
from .forms import AthletesForm
from .forms import WorkoutForm
from .forms import WorkoutDataForm

### HOME VIEW###

def index(request):
    '''Rendering the home.html
    '''
    return render(request, "home.html")

### VIEWS FOR ATHLETE ###

def create_athlete(request):
    '''Rendering the create_athlete.html
    submitted = False
        Required parameter with default False turns to True if form is filled in and submitted
    form
        form with all fields of the athletes model
    '''
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
    '''Rendering the athletes_list.html
    athletes_list
        List of all athletes that are currently maintained in the database and are displayed on the html page'''
    athletes_list = Athletes.objects.all
    return render(request, "athletes_list.html", {'athletes_list':athletes_list})

def delete_athlete(request, athlete_id):
    '''Deletes an athlete with an specific ID
    athlete
        athlete_id of the concerned athlete
    '''
    athlete = Athletes.objects.get(pk=athlete_id)
    athlete.delete()
    return redirect('athletes_list')

def update_athlete(request, athlete_id):
    '''Updates an athlete with an specific ID
    athlete
        athlete_id of the concerned athlete
    form 
        form of datamodel athlete that is prefilled with the values linked to the ID (instance = athlete)
    '''
    athlete = Athletes.objects.get(pk=athlete_id)
    form = AthletesForm(request.POST or None, instance=athlete)
    if form.is_valid():
        '''Redirect to athletes_list.html if form is filled in correctly
        '''
        form.save()
        return redirect('athletes_list')
    return render(request, 'update_athlete.html', {'athlete': athlete, 'form':form})

### VIEWS FOR  WORKOUT ###

def create_workout(request):
    '''Rendering the create_workout.html
    submitted = False
        Required parameter with default False turns to True if form is filled in and submitted
    form
        form with all fields of the workout model
    '''
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
    '''Rendering the workout_list.html
    athletes_list
        List of all workouts that are currently maintained in the database and are displayed on the html page'''
    workout_list = Workout.objects.all
    return render(request, "workout_list.html", {'workout_list':workout_list})

def delete_workout(request, workout_id):
    '''Deletes an workout with an specific ID
    workout
        workout_id of the concerned athlete
    '''
    workout = Workout.objects.get(pk=workout_id)
    workout.delete()
    return redirect('workout_list')

def update_workout(request, workout_id):
    '''Updates an workout with an specific ID
    workout
        workout_id of the concerned workout
    form 
        form of datamodel workout that is prefilled with the values linked to the ID (instance = workout)
    '''
    workout = Workout.objects.get(pk=workout_id)
    form = WorkoutForm(request.POST or None, instance=workout)
    if form.is_valid():
        '''Redirect to workout_list.html if form is filled in correctly
        '''
        form.save()
        return redirect('workout_list')
    return render(request, 'update_workout.html', {'workout': workout, 'form':form})

### VIEWS FOR  WORKOUT DATA ###

def create_workout_data(request):
    '''Rendering the create_workout_data.html
    submitted = False
        Required parameter with default False turns to True if form is filled in and submitted
    form
        form with all fields of the workout_data model
    '''
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
    '''Rendering the workout_data_list.html
    athletes_list
        List of all workout_datas that are currently maintained in the database and are displayed on the html page'''
    workout_data_list = Workout_data.objects.all
    return render(request, "workout_data_list.html", {'workout_data_list':workout_data_list})

def delete_workout_data(request, workout_data_id):
    '''Deletes an workout_data with an specific ID
    workout
        workout_data_id of the concerned athlete
    '''
    workout_data = Workout_data.objects.get(pk=workout_data_id)
    workout_data.delete()
    return redirect('workout_data_list')

def update_workout_data(request, workout_data_id):
    '''Updates an workout_data with an specific ID
    workout
        workout_data_id of the concerned workout_data
    form 
        form of datamodel workout_data that is prefilled with the values linked to the ID (instance = workout_data)
    '''
    workout_data = Workout_data.objects.get(pk=workout_data_id)
    form = WorkoutDataForm(request.POST or None, instance=workout_data)
    if form.is_valid():
        '''Redirect to workout_data_list.html if form is filled in correctly
        '''
        form.save()
        return redirect('workout_data_list')
    return render(request, 'update_workout_data.html', {'workout_data': workout_data, 'form':form})

def athletes_workout(request, athlete_id):
    '''Renders athletes_workout.html with all workouts of an specific athlete
    athlete
        athlete_id that is concerned
    workouts
        all workout datas that contain the athlete_id
    '''
    athlete = Athletes.objects.get(pk=athlete_id)
    workouts = Workout_data.objects.filter(athlete_id=athlete_id)
    return render(request,'athletes_workout.html', {'athlete': athlete, 'workouts':workouts})
    


