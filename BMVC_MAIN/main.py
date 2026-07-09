"""
FinanceGest - Sistema de Gestao Financeira
Projeto BMVC (Bottle + Model + View + Controller) - UnB/FGA
Nivel 4: CRUD + Login/Sessoes + WebSocket em tempo real

Como executar:
    pip install bottle gevent geventwebsocket
    python main.py

Acesse: http://localhost:8080
Login:  admin / admin123
"""

from gevent import monkey
monkey.patch_all()

from geventwebsocket.handler import WebSocketHandler
from gevent.pywsgi import WSGIServer
from route import app

HOST = '0.0.0.0'
PORT = 8080

if __name__ == '__main__':
    print()
    print('╔══════════════════════════════════════════╗')
    print('║     FinanceGest - BMVC Nivel 4           ║')
    print('╠══════════════════════════════════════════╣')
    print('║  URL:   http://localhost:8080            ║')
    print('║  Login: admin / admin123                 ║')
    print('║  Ctrl+C para encerrar                    ║')
    print('╚══════════════════════════════════════════╝')
    print()
    server = WSGIServer((HOST, PORT), app, handler_class=WebSocketHandler)
    server.serve_forever()
