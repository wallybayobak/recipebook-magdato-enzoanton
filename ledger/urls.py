from django.urls import path
from .views import index, RecipeListView, RecipeDetailView, RecipeCreateView, RecipeImageCreateView

urlpatterns = [
		path('', index, name='index'),
		path('recipes/list/', RecipeListView.as_view(), name='recipe-list'),
    	path('recipe/<int:pk>/', RecipeDetailView.as_view(), name='recipe-detail'),
    	path('recipes/add/', RecipeCreateView.as_view(), name='recipe-add'),
    	path('recipes/<int:pk>/add_image/', RecipeImageCreateView.as_view(), name='recipe-add-image'),
]

app_name = 'ledger'