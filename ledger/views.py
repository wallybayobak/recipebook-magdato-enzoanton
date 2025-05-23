from django.shortcuts import render, redirect
from django.http import HttpResponse
from django.views.generic import ListView, DetailView
from django.views.generic.edit import CreateView
from django.contrib.auth.mixins import LoginRequiredMixin
from django.urls import reverse_lazy
from .models import Recipe
from .forms import RecipeForm, RecipeImageForm
# Create your views here.

def index(request):
	return HttpResponse('From index view')

class RecipeListView(ListView):
    model = Recipe
    template_name = 'ledger/recipes_list.html'
    context_object_name = 'recipes'

class RecipeDetailView(LoginRequiredMixin, DetailView):
    model = Recipe
    template_name = 'ledger/recipes_detail.html'
    login_url = 'login'
    redirect_field_name = None
    context_object_name = 'recipe'

class RecipeCreateView(LoginRequiredMixin, CreateView):
    model = Recipe
    template_name = 'ledger/recipe_add.html'
    form_class = RecipeForm
    success_url = reverse_lazy('ledger:recipe-list')

    def post(self, request, *args, **kwargs):
        form = self.get_form()
        if form.is_valid():
            recipe = form.save(commit=False)
            recipe.author = request.user
            recipe.save()
            return redirect(self.success_url)
        return self.form_invalid(form)

class RecipeImageCreateView(LoginRequiredMixin, CreateView):
    model = RecipeImage
    template_name = 'ledger/recipe_addimage.html'
    form_class = RecipeImageForm

    def get_context_data(self, **kwargs):
        ctx = super().get_context_data(**kwargs)
        ctx['recipe'] = Recipe.objects.get(pk=self.kwargs['pk'])
        ctx['form'] = RecipeImageForm()
        return ctx

    def post(self, request, *args, **kwargs):
        recipe = Recipe.objects.get(pk=kwargs['pk'])
        form = RecipeImageForm(request.POST, request.FILES)

        if form.is_valid():
            image = form.save(commit=False)
            image.recipe = recipe
            image.save()
            self.object = image
            return redirect(self.get_success_url())

        self.object_list = self.get_queryset()
        context = self.get_context_data(**kwargs)
        context['form'] = form
        return self.render_to_response(context)

    def get_success_url(self):
        return reverse_lazy('ledger:recipe-detail', kwargs={'pk': self.kwargs['pk']})
    '''
def recipes_list(request):
	ctx = {
    "recipes": [
        {
            "name": "Recipe 1",
            "ingredients": [
                {
                    "name": "tomato",
                    "quantity": "3pcs"
                },
                {
                    "name": "onion",
                    "quantity": "1pc"
                },
                {
                    "name": "pork",
                    "quantity": "1kg"
                },
                {
                    "name": "water",
                    "quantity": "1L"
                },
                {
                    "name": "sinigang mix",
                    "quantity": "1 packet"
                }
            ],
            "link": "/recipe/1"
        },
        {
            "name": "Recipe 2",
            "ingredients": [
                {
                    "name": "garlic",
                    "quantity": "1 head"
                },
                {
                    "name": "onion",
                    "quantity": "1pc"
                },
                {
                    "name": "vinegar",
                    "quantity": "1/2cup"
                },
                {
                    "name": "water",
                    "quanity": "1 cup"
                },
                {
                    "name": "salt",
                    "quantity": "1 tablespoon"
                },
                {
                    "name": "whole black peppers",
                    "quantity": "1 tablespoon"
                },
                {
                    "name": "pork",
                    "quantity": "1 kilo"
                }
            ],
            "link": "/recipe/2"
        }
    ]
}

	return render(request, "ledger/recipes_list.html", ctx)

def recipe1(request):
	ctx = {
			"name": "Recipe 1",
    		"ingredients": [
        		{
            		"name": "tomato",
            		"quantity": "3pcs"
        		},
        		{
            		"name": "onion",
            		"quantity": "1pc"
        		},
        		{
            		"name": "pork",
            		"quantity": "1kg"
        		},
        		{
            		"name": "water",
            		"quantity": "1L"
        		},
        		{
            		"name": "sinigang mix",
            		"quantity": "1 packet"
        		}
    		],
    		"link": "/recipe/1"
		}
	return render(request, "ledger/recipe_1.html", ctx)

def recipe2(request):
	ctx = {
    		"name": "Recipe 2",
    		"ingredients": [
        		{
            		"name": "garlic",
            		"quantity": "1 head"
        		},
        		{
        		    "name": "onion",
        		    "quantity": "1pc"
        		},
        		{
            		"name": "vinegar",
            		"quantity": "1/2cup"
        		},
        		{
            		"name": "water",
            		"quantity": "1 cup"
        		},
        		{
            		"name": "salt",
            		"quantity": "1 tablespoon"
        		},
        		{
            		"name": "whole black peppers",
            		"quantity": "1 tablespoon"
        		},
        		{
            		"name": "pork",
            		"quantity": "1 kilo"
        		}
    		],
    		"link": "/recipe/2"
		}
	return render(request, "ledger/recipe_2.html", ctx)
	'''