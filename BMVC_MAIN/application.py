import json
from bottle import template, redirect, request
from app.controllers.datarecord import DataRecord
from app.models.transaction import CATEGORIAS_RECEITA, CATEGORIAS_DESPESA


class Application:
    """
    Controlador principal da aplicacao (BMVC - Controller).
    Gerencia a logica de negocio e a renderizacao das Views.
    Composicao: Application -> DataRecord (Model)
    """

    def __init__(self):
        self.pages = {
            'portal':     self.portal,
            'cadastro':   self.cadastro,
            'dashboard':  self.dashboard,
            'transacoes': self.transacoes,
            'relatorios': self.relatorios,
            'helper':     self.helper,
        }
        self.__model          = DataRecord()
        self.__current_username = None
        self.__ws_clients     = []        # clientes WebSocket (Nivel 4)

    # ─── Utilitarios ──────────────────────────────────────────────────

    def render(self, page, parameter=None):
        """Despacha para a action correspondente a pagina."""
        action = self.pages.get(page, self.helper)
        return action() if parameter is None else action(parameter)

    def get_session_id(self):
        return request.get_cookie('session_id')

    def is_authenticated(self, username):
        session_id    = self.get_session_id()
        current_user  = self.__model.getUserName(session_id)
        return current_user == username

    def authenticate_user(self, username, password):
        """Autentica usuario e retorna (session_id, username) ou (None, None)."""
        session_id = self.__model.checkUser(username, password)
        if session_id:
            self.logout_user()
            self.__current_username = self.__model.getUserName(session_id)
            return session_id, username
        return None, None

    def logout_user(self):
        self.__current_username = None
        session_id = self.get_session_id()
        if session_id:
            self.__model.logout(session_id)

    # ─── WebSocket (Nivel 4) ──────────────────────────────────────────

    @property
    def ws_clients(self):
        return self.__ws_clients

    def broadcast(self, data):
        """Envia dados para todos os clientes WebSocket conectados."""
        payload = json.dumps(data)
        mortos  = []
        for ws in self.__ws_clients:
            try:
                ws.send(payload)
            except Exception:
                mortos.append(ws)
        for ws in mortos:
            self.__ws_clients.remove(ws)

    # ─── Pages (Views) ────────────────────────────────────────────────

    def helper(self):
        return template('app/views/html/helper')

    def portal(self):
        return template('app/views/html/portal', error=None)

    def cadastro(self):
        return template('app/views/html/cadastro', error=None, success=None)

    def dashboard(self, username=None):
        if not username or not self.is_authenticated(username):
            return redirect('/portal')
        session_id = self.get_session_id()
        user    = self.__model.getCurrentUser(session_id)
        balance = self.__model.get_balance(username)
        recent  = self.__model.get_transactions(username)[-5:][::-1]
        return template('app/views/html/dashboard',
                        user=user, balance=balance,
                        recent=recent, username=username)

    def transacoes(self, username=None):
        if not username or not self.is_authenticated(username):
            return redirect('/portal')
        session_id = self.get_session_id()
        user = self.__model.getCurrentUser(session_id)
        txs  = self.__model.get_transactions(username)[::-1]
        return template('app/views/html/transacoes',
                        user=user, transacoes=txs, username=username,
                        cat_receita=CATEGORIAS_RECEITA,
                        cat_despesa=CATEGORIAS_DESPESA,
                        edit_tx=None, error=None)

    def transacoes_edit(self, username, tid):
        if not self.is_authenticated(username):
            return redirect('/portal')
        session_id = self.get_session_id()
        user    = self.__model.getCurrentUser(session_id)
        txs     = self.__model.get_transactions(username)[::-1]
        edit_tx = self.__model.get_transaction_by_id(tid)
        return template('app/views/html/transacoes',
                        user=user, transacoes=txs, username=username,
                        cat_receita=CATEGORIAS_RECEITA,
                        cat_despesa=CATEGORIAS_DESPESA,
                        edit_tx=edit_tx, error=None)

    def relatorios(self, username=None):
        if not username or not self.is_authenticated(username):
            return redirect('/portal')
        session_id = self.get_session_id()
        user    = self.__model.getCurrentUser(session_id)
        balance = self.__model.get_balance(username)
        monthly = self.__model.get_monthly_summary(username)
        cats    = self.__model.get_category_summary(username)
        return template('app/views/html/relatorios',
                        user=user, balance=balance,
                        monthly=monthly, cats=cats, username=username)

    # ─── Actions POST ─────────────────────────────────────────────────

    def action_register(self, username, password, email):
        return self.__model.register_user(username, password, email)

    def action_add_transaction(self, username, tipo, categoria, descricao, valor, data):
        self.__model.add_transaction(username, tipo, categoria, descricao, valor, data)
        balance = self.__model.get_balance(username)
        self.broadcast({'type': 'balance_update', 'username': username, **balance})
        return balance

    def action_update_transaction(self, tid, username, tipo, categoria, descricao, valor, data):
        self.__model.update_transaction(tid, tipo, categoria, descricao, valor, data)
        balance = self.__model.get_balance(username)
        self.broadcast({'type': 'balance_update', 'username': username, **balance})
        return balance

    def action_delete_transaction(self, tid, username):
        self.__model.delete_transaction(tid)
        balance = self.__model.get_balance(username)
        self.broadcast({'type': 'balance_update', 'username': username, **balance})
        return balance
