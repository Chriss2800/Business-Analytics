from django.db import models
from django.utils import timezone

# Definition of DropDown Selection for Athletes model field 'gender'
GENDER_CHOICES= [
    ('Male', 'male'),
    ('Female', 'female'),
    ('Diverse', 'diverse'),
    ]

class Athletes(models.Model):
    '''
    A class to create a database model named athlete
    models.Model
        Django helper class to create a database model
    gender : str
        gender of the athlete
    first_name : str
        First name of the athlete
    last_name : str
        Last name of the athlete
    height : int
        Height of the athlete
    weight : int
        Weight of the athlete
    '''
    gender = models.CharField(max_length=10, choices=GENDER_CHOICES, default='diverse')
    first_name = models.CharField(max_length=200)
    last_name = models.CharField(max_length=200)
    height = models.IntegerField()
    weight = models.IntegerField()

    def __str__(self):
        return self.first_name + " " + self.last_name


class Workout(models.Model):
    '''
    A class to create a database model named workout
    models.Model
        Django helper class to create a database model
    designation : str
        designation of the workout
    describtion : str
        describtion of the workout
    '''
    designation = models.CharField(max_length=50)
    description = models.CharField(max_length=200)
    
    def __str__(self):
        return self.designation

class Workout_data(models.Model):
    '''
    A class to create a database model named workout
    models.Model
        Django helper class to create a database model
    workout : str
        Foreign key connection to model workouts
    athlete : str
        Foreign key connection to model athletes
    start: timefield
        Start of the workout
    end: timefield
        End of the workout
    date: datefield
        Date of the workout
    '''
    workout = models.ForeignKey(Workout, on_delete=models.CASCADE)
    athlete = models.ForeignKey(Athletes, on_delete=models.CASCADE)
    start = models.TimeField(max_length=30)
    end = models.TimeField(max_length=30)
    date = models.DateField(max_length=30, default=timezone.now)
    
    def __str__(self):
        return self.workout.designation + " on " + str(self.date) + " for " + str(self.duration) + " minutes"

    @property
    def duration(self):
        '''
        Calculates the duration of workout dynamically
        '''
        end = self.end.hour*60 + self.end.minute
        start = self.start.hour*60 + self.start.minute
        duration = end - start
        return duration
