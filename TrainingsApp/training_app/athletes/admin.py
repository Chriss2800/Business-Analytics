from django.contrib import admin
from .models import Athletes
from .models import Workout
from .models import Workout_data

# Register your models here.
admin.site.register(Athletes)
admin.site.register(Workout)
admin.site.register(Workout_data)