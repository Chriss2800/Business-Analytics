from django.db import models

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
    description = models.CharField('Workout description', max_length=200, default='Your Description')
    
    def __str__(self):
        return self.description

class Workout_data(models.Model):
    workout = models.ForeignKey(Workout, blank=True, null=True, on_delete=models.CASCADE)
    athlete = models.ForeignKey(Athletes, blank=True, null=True, on_delete=models.CASCADE)
    pause = models.IntegerField('Pause')
    start = models.IntegerField('Start')
    end = models.IntegerField('End')
    duration = models.IntegerField('Duration')
    #date = models.DateField('Date')
    
    def __str__(self):
        return self.start
