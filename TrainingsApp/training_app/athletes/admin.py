from django.contrib import admin
from .models import Athletes
from .models import Workout
from .models import Workout_data

# Registration of database model
admin.site.register(Athletes)
admin.site.register(Workout)
admin.site.register(Workout_data)