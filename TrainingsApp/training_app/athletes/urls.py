from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('create_athlete/', views.create_athlete, name='create_athlete'),
    path('create_course/', views.create_course, name='create_course'),
    path('create_training_data/', views.create_training_data, name='create_training_data'),
    path('athletes_list', views.athletes_list, name='athletes_list'),
    path('workout_list', views.workout_list, name='workout_list'),
    path('delete_athlete/<athlete_id>', views.delete_athlete, name='delete_athlete')
    
]