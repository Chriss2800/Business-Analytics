# Generated by Django 4.1.3 on 2022-12-21 07:22

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('athletes', '0013_workout_data_date'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='workout_data',
            name='duration',
        ),
    ]
