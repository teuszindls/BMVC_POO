"""
route.py - Definicao de todas as rotas HTTP (BMVC - Bottle)
Nivel 1: paginas estaticas
Nivel 2: CRUD de transacoes
Nivel 3: autenticacao / login / logout
Nivel 4: WebSocket em tempo real
"""

from bottle import Bottle, request, response, redirect, static_file, abort
from application import Application

app = Bottle()
ctl = Application()


# ─── Arquivos estaticos ───────────────────────────────────────────────────────

@app.route('/static/<filepath:path>')
def serve_static(filepath):
    return static_file(filepath, root='app/static')


# ─── Raiz ─────────────────────────────────────────────────────────────────────

@app.route('/')
def index():
    return redirect('/portal')


# ─── NIVEL 1 - Portal (pagina estatica de login) ──────────────────────────────

@app.route('/portal', method='GET')
def portal():
    return ctl.render('portal')


# ─── NIVEL 3 - Autenticacao POST ──────────────────────────────────────────────

@app.route('/portal', method='POST')
def action_portal():
    from bottle import template
    username = request.forms.get('username', '').strip()
    password = request.forms.get('password', '').strip()
    session_id, uname = ctl.authenticate_user(username, password)
    if session_id:
        response.set_cookie('session_id', session_id, httponly=True, max_age=3600)
        return redirect(f'/dashboard/{uname}')
    return template('app/views/html/portal', error='Usuario ou senha invalidos.')


# ─── Cadastro ─────────────────────────────────────────────────────────────────

@app.route('/cadastro', method='GET')
def cadastro():
    return ctl.render('cadastro')


@app.route('/cadastro', method='POST')
def action_cadastro():
    from bottle import template
    username = request.forms.get('username', '').strip()
    password = request.forms.get('password', '').strip()
    email    = request.forms.get('email', '').strip()
    confirm  = request.forms.get('confirm', '').strip()
    if not username or not password:
        return template('app/views/html/cadastro', error='Preencha usuario e senha.', success=None)
    if password != confirm:
        return template('app/views/html/cadastro', error='As senhas nao coincidem.', success=None)
    if ctl.action_register(username, password, email):
        return template('app/views/html/cadastro', error=None, success='Conta criada! Faca seu login.')
    return template('app/views/html/cadastro', error='Usuario ja existe.', success=None)


# ─── NIVEL 3 - Logout ─────────────────────────────────────────────────────────

@app.route('/logout', method='POST')
def logout():
    ctl.logout_user()
    response.delete_cookie('session_id')
    return redirect('/portal')


# ─── NIVEL 2+3 - Dashboard (pagina restrita) ──────────────────────────────────

@app.route('/dashboard/<username>')
def dashboard(username):
    return ctl.dashboard(username)


# ─── NIVEL 2 - CRUD de Transacoes ─────────────────────────────────────────────

@app.route('/transacoes/<username>')
def transacoes(username):
    return ctl.transacoes(username)


@app.route('/transacoes/<username>/add', method='POST')
def add_transaction(username):
    if not ctl.is_authenticated(username):
        return redirect('/portal')
    tipo      = request.forms.get('tipo', '').strip()
    categoria = request.forms.get('categoria', '').strip()
    descricao = request.forms.get('descricao', '').strip()
    data      = request.forms.get('data', '').strip()
    try:
        valor = float(request.forms.get('valor', '0').strip().replace(',', '.'))
    except ValueError:
        valor = 0.0
    ctl.action_add_transaction(username, tipo, categoria, descricao, valor, data)
    return redirect(f'/transacoes/{username}')


@app.route('/transacoes/<username>/edit/<tid>', method='GET')
def edit_form(username, tid):
    if not ctl.is_authenticated(username):
        return redirect('/portal')
    return ctl.transacoes_edit(username, tid)


@app.route('/transacoes/<username>/edit/<tid>', method='POST')
def edit_transaction(username, tid):
    if not ctl.is_authenticated(username):
        return redirect('/portal')
    tipo      = request.forms.get('tipo', '').strip()
    categoria = request.forms.get('categoria', '').strip()
    descricao = request.forms.get('descricao', '').strip()
    data      = request.forms.get('data', '').strip()
    try:
        valor = float(request.forms.get('valor', '0').strip().replace(',', '.'))
    except ValueError:
        valor = 0.0
    ctl.action_update_transaction(tid, username, tipo, categoria, descricao, valor, data)
    return redirect(f'/transacoes/{username}')


@app.route('/transacoes/<username>/delete/<tid>', method='POST')
def delete_transaction(username, tid):
    if not ctl.is_authenticated(username):
        return redirect('/portal')
    ctl.action_delete_transaction(tid, username)
    return redirect(f'/transacoes/{username}')


# ─── Relatorios ───────────────────────────────────────────────────────────────

@app.route('/relatorios/<username>')
def relatorios(username):
    return ctl.relatorios(username)


# ─── NIVEL 4 - WebSocket (atualizacao assincrona em tempo real) ───────────────

@app.route('/ws')
def websocket_handler():
    ws = request.environ.get('wsgi.websocket')
    if not ws:
        abort(400, 'WebSocket esperado.')
    ctl.ws_clients.append(ws)
    try:
        while True:
            msg = ws.receive()
            if msg is None:
                break
    except Exception:
        pass
    finally:
        if ws in ctl.ws_clients:
            ctl.ws_clients.remove(ws)


# ─── Helper (pagina de erro / acesso negado) ──────────────────────────────────

@app.route('/helper')
def helper():
    return ctl.render('helper')
