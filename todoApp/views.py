from django.shortcuts import redirect
#imports the redirect function from Django’s shortcuts module.

def index(request):
    return redirect('/todos')
