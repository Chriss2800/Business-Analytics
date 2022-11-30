from django.db import models

# Create your models here.

class Athlete(models.Model):
    Name = models.CharField(max_length=200)
    Size = models.IntegerField()
    Weight = models.IntegerField()