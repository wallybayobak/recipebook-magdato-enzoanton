[33mcommit 102968fac5ec7b660910cdc585f3d7f55c4d76f4[m[33m ([m[1;36mHEAD[m[33m -> [m[1;32mlab4[m[33m)[m
Author: wallybayobak <apmagdato@gmail.com>
Date:   Fri May 23 22:40:46 2025 +0800

    started lab 4, added image and recipe create views as well as started on forms and templates

[1mdiff --git a/ledger/admin.py b/ledger/admin.py[m
[1mindex 4652e43..6590205 100644[m
[1m--- a/ledger/admin.py[m
[1m+++ b/ledger/admin.py[m
[36m@@ -1,7 +1,11 @@[m
 from django.contrib import admin[m
[31m-from .models import Ingredient, Recipe, RecipeIngredient[m
[32m+[m[32mfrom .models import Ingredient, Recipe, RecipeIngredient, RecipeImage[m
 [m
 # Register your models here.[m
[32m+[m[32mclass RecipeImageInline(admin.TabularInline):[m
[32m+[m[32m    model = RecipeImage[m
[32m+[m[32m    extra = 1[m
[32m+[m
 class RecipeIngredientInline(admin.TabularInline):[m
 	model = RecipeIngredient[m
 	extra = 1[m
[1mdiff --git a/ledger/forms.py b/ledger/forms.py[m
[1mnew file mode 100644[m
[1mindex 0000000..85e3845[m
[1m--- /dev/null[m
[1m+++ b/ledger/forms.py[m
[36m@@ -0,0 +1,12 @@[m
[32m+[m[32mfrom django import forms[m
[32m+[m[32mfrom .models import Recipe, RecipeImage[m
[32m+[m
[32m+[m[32mclass RecipeForm(forms.ModelForm):[m
[32m+[m[32m    class Meta:[m
[32m+[m[32m        model = Recipe[m
[32m+[m[32m        fields = ['name'][m[41m [m
[32m+[m
[32m+[m[32mclass RecipeImageForm(forms.ModelForm):[m
[32m+[m[32m    class Meta:[m
[32m+[m[32m        model = RecipeImage[m
[32m+[m[32m        fields = ['image', 'description'][m
\ No newline at end of file[m
[1mdiff --git a/ledger/models.py b/ledger/models.py[m
[1mindex c2229cf..cf2e0be 100644[m
[1m--- a/ledger/models.py[m
[1m+++ b/ledger/models.py[m
[36m@@ -42,4 +42,14 @@[m [mclass RecipeIngredient(models.Model):[m
         on_delete=models.SET_NULL,[m
         null=True,[m
         related_name='ingredients'[m
[31m-    )[m
\ No newline at end of file[m
[32m+[m[32m    )[m
[32m+[m
[32m+[m[32mclass RecipeImage(models.Model):[m
[32m+[m[32m    recipe = models.ForeignKey([m
[32m+[m[41m    [m	[32m'Recipe',[m
[32m+[m[41m    [m	[32mrelated_name='images',[m
[32m+[m[41m    [m	[32mon_delete=models.CASCADE,[m
[32m+[m[41m    [m	[32mnull=True[m
[32m+[m[41m    [m	[32m)[m
[32m+[m[32m    image = models.ImageField(upload_to='images/')[m
[32m+[m[32m    description = models.CharField(max_length=255)[m[41m   [m
\ No newline at end of file[m
[1mdiff --git a/ledger/templates/ledger/recipes_add.html b/ledger/templates/ledger/recipes_add.html[m
[1mnew file mode 100644[m
[1mindex 0000000..e69de29[m
[1mdiff --git a/ledger/templates/ledger/recipes_addimage.html b/ledger/templates/ledger/recipes_addimage.html[m
[1mnew file mode 100644[m
[1mindex 0000000..e69de29[m
[1mdiff --git a/ledger/urls.py b/ledger/urls.py[m
[1mindex 8cac89b..715b6fd 100644[m
[1m--- a/ledger/urls.py[m
[1m+++ b/ledger/urls.py[m
[36m@@ -1,10 +1,12 @@[m
 from django.urls import path[m
[31m-from .views import index, RecipeListView, RecipeDetailView[m
[32m+[m[32mfrom .views import index, RecipeListView, RecipeDetailView, RecipeCreateView, RecipeImageCreateView[m
 [m
 urlpatterns = [[m
 		path('', index, name='index'),[m
 		path('recipes/list/', RecipeListView.as_view(), name='recipes-list'),[m
     	path('recipe/<int:pk>/', RecipeDetailView.as_view(), name='recipe-detail'),[m
[32m+[m[41m    [m	[32mpath('recipes/add/', RecipeCreateView.as_view(), name='recipe-add'),[m
[32m+[m[41m    [m	[32mpath('recipes/<int:pk>/add_image/', RecipeImageCreateView.as_view(), name='recipe-add-image'),[m
 ][m
 [m
 app_name = 'ledger'[m
\ No newline at end of file[m
[1mdiff --git a/ledger/views.py b/ledger/views.py[m
[1mindex 4d4fd33..f4fbbad 100644[m
[1m--- a/ledger/views.py[m
[1m+++ b/ledger/views.py[m
[36m@@ -1,8 +1,11 @@[m
[31m-from django.shortcuts import render[m
[32m+[m[32mfrom django.shortcuts import render, redirect[m
 from django.http import HttpResponse[m
 from django.views.generic import ListView, DetailView[m
[32m+[m[32mfrom django.views.generic.edit import CreateView[m
 from django.contrib.auth.mixins import LoginRequiredMixin[m
[32m+[m[32mfrom django.urls import reverse_lazy[m
 from .models import Recipe[m
[32m+[m[32mfrom .forms import RecipeForm, RecipeImageForm[m
 # Create your views here.[m
 [m
 def index(request):[m
[36m@@ -19,6 +22,51 @@[m [mclass RecipeDetailView(LoginRequiredMixin, DetailView):[m
     login_url = 'login'[m
     redirect_field_name = None[m
     context_object_name = 'recipe'[m
[32m+[m
[32m+[m[32mclass RecipeCreateView(LoginRequiredMixin, CreateView):[m
[32m+[m[32m    model = Recipe[m
[32m+[m[32m    template_name = 'ledger/recipe_add.html'[m
[32m+[m[32m    form_class = RecipeForm[m
[32m+[m[32m    success_url = reverse_lazy('ledger:recipe-list')[m
[32m+[m
[32m+[m[32m    def post(self, request, *args, **kwargs):[m
[32m+[m[32m        form = self.get_form()[m
[32m+[m[32m        if form.is_valid():[m
[32m+[m[32m            recipe = form.save(commit=False)[m
[32m+[m[32m            recipe.author = request.user[m
[32m+[m[32m            recipe.save()[m
[32m+[m[32m            return redirect(self.success_url)[m
[32m+[m[32m        return self.form_invalid(form)[m
[32m+[m
[32m+[m[32mclass RecipeImageCreateView(LoginRequiredMixin, CreateView):[m
[32m+[m[32m    model = RecipeImage[m
[32m+[m[32m    template_name = 'ledger/recipe_addimage.html'[m
[32m+[m[32m    form_class = RecipeImageForm[m
[32m+[m
[32m+[m[32m    def get_context_data(self, **kwargs):[m
[32m+[m[32m        ctx = super().get_context_data(**kwargs)[m
[32m+[m[32m        ctx['recipe'] = Recipe.objects.get(pk=self.kwargs['pk'])[m
[32m+[m[32m        ctx['form'] = RecipeImageForm()[m
[32m+[m[32m        return ctx[m
[32m+[m
[32m+[m[32m    def post(self, request, *args, **kwargs):[m
[32m+[m[32m        recipe = Recipe.objects.get(pk=kwargs['pk'])[m
[32m+[m[32m        form = RecipeImageForm(request.POST, request.FILES)[m
[32m+[m
[32m+[m[32m        if form.is_valid():[m
[32m+[m[32m            image = form.save(commit=False)[m
[32m+[m[32m            image.recipe = recipe[m
[32m+[m[32m            image.save()[m
[32m+[m[32m            self.object = image[m
[32m+[m[32m            return redirect(self.get_success_url())[m
[32m+[m
[32m+[m[32m        self.object_list = self.get_queryset()[m
[32m+[m[32m        context = self.get_context_data(**kwargs)[m
[32m+[m[32m        context['form'] = form[m
[32m+[m[32m        return self.render_to_response(context)[m
[32m+[m
[32m+[m[32m    def get_success_url(self):[m
[32m+[m[32m        return reverse_lazy('ledger:recipe-detail', kwargs={'pk': self.kwargs['pk']})[m
     '''[m
 def recipes_list(request):[m
 	ctx = {[m
