from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('/create_athlete', views.create_athlete, name='create_athlete'),
    path('/create_training', views.create_training, name='create_training'),
    path('/create_training_data', views.create_training_data, name='create_training_data')
]