from django.db import models

# Create your models here.

class Athletes(models.Model):
    Gender = models.CharField(max_length=200)
    Name = models.CharField(max_length=200)
    Size = models.IntegerField()
    Weight = models.IntegerField()