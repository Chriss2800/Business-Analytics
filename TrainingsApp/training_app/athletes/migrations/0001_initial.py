# Generated by Django 4.1.3 on 2022-11-30 11:48

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Athletes',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('Name', models.CharField(max_length=200)),
                ('Size', models.IntegerField()),
                ('Weight', models.IntegerField()),
            ],
        ),
    ]
