from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('create_athlete', views.create_athlete, name='create_athlete'),
    path('create_workout', views.create_workout, name='create_workout'),
    path('create_workout_data', views.create_workout_data, name='create_workout_data'),
    path('athletes_list', views.athletes_list, name='athletes_list'),
    path('workout_list', views.workout_list, name='workout_list'),
    path('workout_data_list', views.workout_data_list, name='workout_data_list'),
    path('delete_athlete/<athlete_id>', views.delete_athlete, name='delete_athlete'),
    path('delete_workout/<workout_id>', views.delete_workout, name='delete_workout'),
    path('delete_workout_data/<workout_data_id>', views.delete_workout_data, name='delete_workout_data'),
    path('update_athlete/<athlete_id>', views.update_athlete, name='update_athlete'),
    path('update_workout/<workout_id>', views.update_workout, name='update_workout'),
    path('update_workout_data/<workout_data_id>', views.update_workout_data, name='update_workout_data'),
    path('athletes_workout', views.athletes_workout, name='athletes_workout'),
    
    
]