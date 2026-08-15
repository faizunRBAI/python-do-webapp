from django.test import TestCase, Client


class HomePageTest(TestCase):
    def setUp(self):
        self.client = Client()

    def test_home_page_renders(self):
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'<!doctype html>', response.content.lower())

    def test_health_reports_ok(self):
        response = self.client.get('/health')
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertEqual(data['status'], 'ok')

    def test_api_info(self):
        response = self.client.get('/api/info')
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertEqual(data['app'], 'django')
