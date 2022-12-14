from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('create_athlete/', views.create_athlete, name='create_athlete'),
    path('create_course/', views.create_course, name='create_course'),
    path('create_training_data/', views.create_training_data, name='create_training_data'),
    path('athletes_list', views.athletes_list, name='athletes_list')
    
]