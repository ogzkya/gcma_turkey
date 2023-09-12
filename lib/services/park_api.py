from flask import Flask, jsonify
from flask_cors import CORS
import pandas as pd

app = Flask(__name__)
CORS(app)

def read_excel_file():
    url = 'https://data.ibb.gov.tr/dataset/82e809cf-9465-407a-91cd-ac745d6fbc95/resource/d588f256-2982-43d2-b372-c38978d7200b/download/park-ve-yeil-alan-koordinatlar.xlsx'
    df = pd.read_excel(url, engine='openpyxl')
    df = df.rename(columns=lambda x: x.strip())
    df['KOORDINAT'] = df['KOORDINAT (Yatay , Dikey)'].str.split(' , ')
    df['Latitude'] = df['KOORDINAT'].apply(lambda x: float(x[0]))
    df['Longitude'] = df['KOORDINAT'].apply(lambda x: float(x[1]))
    return df[['SIRA NO', 'TÜR', 'MAHAL ADI', 'İLÇE', 'Latitude', 'Longitude']].to_dict(orient='records')

@app.route('/api/park_data', methods=['GET'])
def park_data():
    data = read_excel_file()
    return jsonify(data)

if __name__ == '__main__':
    app.run(debug=True)
