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
    #birth_date = models.DateField('Your Birthdate', default=2022-0o1-0o1)

    def __str__(self):
        return self.first_name


class Workout(models.Model):
    #athlete = models.ForeignKey(Athletes, blank=True, null=True, on_delete=models.CASCADE)
    description = models.CharField(max_length=200)
    
    def __str__(self):
        return self.description

class Workout_data(models.Model):
    workout = models.ForeignKey(Workout, blank=True, null=True, on_delete=models.CASCADE)
    athlete = models.ForeignKey(Athletes, blank=True, null=True, on_delete=models.CASCADE)
    #pause = models.TimeField(max_length=30)
    start = models.TimeField(max_length=30)
    end = models.TimeField(max_length=30)
    #duration = models.IntegerField()
    date = models.DateField(max_length=30, default=timezone.now)
    
    def __str__(self):
        return self.start



    @property
    def duration(self):
        end = self.end.hour*60 + self.end.minute
        start = self.start.hour*60 + self.start.minute
        #pause = self.pause.hour*60 + self.pause.minute
        duration = end - start
        return duration
