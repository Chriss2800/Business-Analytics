from django.db import models
from django.utils import timezone

# Create your models here.

GENDER_CHOICES= [
    ('Male', 'male'),
    ('Female', 'female'),
    ('Diverse', 'diverse'),
    ]

class Athletes(models.Model):
    gender = models.CharField(max_length=10, choices=GENDER_CHOICES, default='diverse')
    first_name = models.CharField(max_length=200)
    last_name = models.CharField(max_length=200)
    height = models.IntegerField()
    weight = models.IntegerField()

    def __str__(self):
        return self.first_name + " " + self.last_name


class Workout(models.Model):
    designation = models.CharField(max_length=50)
    description = models.CharField(max_length=200)
    
    def __str__(self):
        return self.designation

class Workout_data(models.Model):
    workout = models.ForeignKey(Workout, on_delete=models.CASCADE)
    athlete = models.ForeignKey(Athletes, on_delete=models.CASCADE)
    start = models.TimeField(max_length=30)
    end = models.TimeField(max_length=30)
    date = models.DateField(max_length=30, default=timezone.now)
    
    def __str__(self):
        return self.workout.designation + " on " + str(self.date) + " for " + str(self.duration) + " minutes"

    @property
    def duration(self):
        end = self.end.hour*60 + self.end.minute
        start = self.start.hour*60 + self.start.minute
        duration = end - start
        return duration
