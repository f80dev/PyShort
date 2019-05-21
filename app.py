import base64
import datetime
import ssl
import urllib.parse
from io import BytesIO, StringIO

import pyqrcode
from flask import Flask, request, render_template, redirect, send_file
from math import floor
import string, sqlite3
from urllib.parse import urlparse
import sys

#Assuming urls.db is in your app root folder
def table_check():
    create_table = "CREATE TABLE WEB_URL (ID INTEGER PRIMARY KEY AUTOINCREMENT,URL TEXT NOT NULL,EXPIRE INTEGER NOT NULL);"
    with sqlite3.connect('urls.db') as conn:
        cursor = conn.cursor()
        try:
            cursor.execute(create_table)
        except sqlite3.OperationalError:
            pass


# Base62 Encoder and Decoder
def toBase62(num, b = 62):
    if b <= 0 or b > 62:
        return 0
    base = string.digits + string.ascii_lowercase + string.ascii_uppercase
    r = num % b
    res = base[r];
    q = floor(num / b)
    while q:
        r = q % b
        q = floor(q / b)
        res = base[int(r)] + res
    return res

def toBase10(num, b = 62):
    base = string.digits + string.ascii_lowercase + string.ascii_uppercase
    limit = len(num)
    res = 0
    for i in range(limit):
        res = b * res + base.find(num[i])
    return res


app = Flask(__name__)


# http://localhost:8100/short?url=http://shifumix.com&format=img
#http://207.180.198.227:8100/short?url=http://shifumix.com
#https://server.f80.fr:8100/short?url=http://shifumix.com&format=text
@app.route('/short', methods=['POST','GET'])
def home():
    if request.method=="POST":
        original_url = request.data.decode("utf-8")
    else:
        original_url = urllib.parse.unquote(request.args.get("url"))

    if original_url=="":
        return "Error: url empty"
    else:
        print("A traiter = "+original_url)

    #token = base64.b64decode(request.args.get('token'))
    #delayInDay=1

    format=request.args.get("format","text")
    if urlparse(original_url).scheme == '':
        original_url = 'https://' + original_url

    with sqlite3.connect('urls.db') as conn:
        cursor = conn.cursor()
        #expire_date=datetime.datetime.now()+delayInDay*(1000*3600*24)

        insert_row = "INSERT INTO WEB_URL (URL) VALUES ('%s')" % original_url
        result_cursor = cursor.execute(insert_row)
        encoded_string = toBase62(result_cursor.lastrowid)

    if format=="text":
        result= host + "/"+encoded_string
        print(result)
        return result
    else:
        res=pyqrcode.create(host+"/"+encoded_string)
        buffer=BytesIO()
        res.png(buffer,scale=8)
        buffer.seek(0)
        return send_file(buffer,as_attachment=False,mimetype='image/png')



@app.route('/<short_url>')
def redirect_short_url(short_url):
    decoded_string = toBase10(short_url)
    redirect_url = 'http://localhost:5000'
    with sqlite3.connect('urls.db') as conn:
        cursor = conn.cursor()
        select_row = "SELECT URL FROM WEB_URL WHERE ID="+str(decoded_string)
        result_cursor = cursor.execute(select_row)
        try:
            redirect_url = result_cursor.fetchone()[0]
            print("Redirection vers "+redirect_url)
        except Exception as e:
            print(e)
    rc=redirect(redirect_url)
    return rc


if __name__ == '__main__':
    # This code checks whether database table is created or not
    host=sys.argv[1]
    _port=sys.argv[2]
    print("Démarage sur le port "+_port+" pour host:"+host)
    table_check()
    if "debug" in sys.argv:
        app.run(host="0.0.0.0",port=_port,debug=True)
    else:
        if "ssl" in sys.argv:
            context = ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)
            context.load_cert_chain("./certs/fullchain.pem", "./certs/privkey.pem")
            app.run(host="0.0.0.0", port=_port, debug=False, ssl_context=context)
        else:
            app.run(host="0.0.0.0", port=_port, debug=False)