from django.urls import path
from .views import index, recipes_list, recipe1, recipe2

urlpatterns = [
		path('', index, name='index'),
		path('recipes/list', recipes_list, name="recipe_list"),
		path('recipe/1', recipe1, name='recipe_1'),
		path('recipe/2', recipe2, name='recipe_2'),
]

