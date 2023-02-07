import requests
from flask import Flask, render_template, request

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/weather', methods=['POST'])
def weather():
    zip_code = request.form['zip_code']
    api_key = '10e5051eecc2e322e4e4265eb12ffe09'
    url = f'http://api.openweathermap.org/data/2.5/weather?zip={zip_code},us&appid={api_key}&units=imperial'
    weather_data = requests.get(url).json()
    return render_template('weather.html', weather_data=weather_data)

if __name__ == '__main__':
    app.run(debug=True)