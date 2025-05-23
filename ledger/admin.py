from django.contrib import admin
from .models import Ingredient, Recipe, RecipeIngredient, RecipeImage

# Register your models here.
class RecipeImageInline(admin.TabularInline):
    model = RecipeImage
    extra = 1

class RecipeIngredientInline(admin.TabularInline):
	model = RecipeIngredient
	extra = 1

class RecipeAdmin(admin.ModelAdmin):
	inlines = [RecipeIngredientInline]
	search_fields = ("name",)
	list_display  = ("name",)
	list_filter   = ("name",)	

admin.site.register(Recipe, RecipeAdmin)
admin.site.register(Ingredient)
