import os
import time

from django.http import HttpResponse, JsonResponse
from rest_framework.decorators import api_view

from .welcome import WELCOME_HTML

_start = time.time()


def home(request):
    return HttpResponse(WELCOME_HTML, content_type='text/html')


@api_view(['GET'])
def health(request):
    return JsonResponse({'status': 'ok', 'uptime': round(time.time() - _start, 1)})


@api_view(['GET'])
def api_info(request):
    return JsonResponse({
        'app': 'django',
        'version': '1.0.0',
        'db': 'connected' if os.environ.get('DATABASE_URL') else 'sqlite',
        'env': os.environ.get('APP_ENV', 'development'),
    })
